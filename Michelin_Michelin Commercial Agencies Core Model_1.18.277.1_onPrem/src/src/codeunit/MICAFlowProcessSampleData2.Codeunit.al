codeunit 80878 "MICA Flow Process Sample Data2"
{
    TableNo = "MICA Flow Entry";
    trigger OnRun()
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowRecord: Record "MICA Flow Record";
        MICASampleData: Record "MICA Sample Data";
        MICAFlowBufferSampleData: Record "MICA Flow Buffer Sample Data";
        InventoryPostingGroup: Record "Inventory Posting Group";
        ProcessStartedLbl: Label 'Process started.';
        ProcessFinishedLbl: Label 'Process terminated : %1 record(s) processed / %2';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';
        MissingValueLbl: Label 'Missing value : Field %1.';
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
        BufferCountLbl: Label '%1 buffer record(s) to process.';
        UpdateErrorLbl: Label 'Error while updating record %1.';
        UpdateCount: Integer;
        BufferCount: Integer;

    begin
        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ProcessStartedLbl, ''));
        MICAFlow.get(Rec."Flow Code");

        // Check the buffer and update field from raw value
        MICAFlowBufferSampleData.Reset();
        MICAFlowBufferSampleData.SetRange("Flow Code", Rec."Flow Code");
        MICAFlowBufferSampleData.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufferSampleData.SetRange("Skip Line", false); // discard skipped buffer records when reprocessing
        MICAFlowInformation."Description 2" := StrSubstNo(BufferCountLbl, MICAFlowBufferSampleData.Count());
        if MICAFlowBufferSampleData.FindSet() then
            repeat
                if MICAFlowBufferSampleData."No." = '' then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferSampleData."Entry No.", StrSubstNo(MissingValueLbl, MICAFlowBufferSampleData.FieldCaption("No.")), '');

                if not EvaluateRawDateToDate(MICAFlowBufferSampleData."Last Date Modified", MICAFlowBufferSampleData."Last Date Modified Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferSampleData."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferSampleData.FieldCaption("Last Date Modified"), MICAFlowBufferSampleData."Last Date Modified Raw"), '');

                if not EvaluateRawDecToDec(MICAFlowBufferSampleData."Unit Cost", MICAFlowBufferSampleData."Unit Cost Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferSampleData."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferSampleData.FieldCaption("Unit Cost"), MICAFlowBufferSampleData."Unit Cost Raw"), '');

                if not InventoryPostingGroup.Get(MICAFlowBufferSampleData."Inventory Posting Group") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferSampleData."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferSampleData.FieldCaption("Inventory Posting Group"), MICAFlowBufferSampleData."Inventory Posting Group"), '');

                if not EvaluateRawOptionToOption(MICAFlowBufferSampleData."Costing Method", MICAFlowBufferSampleData."Costing Method Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferSampleData."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferSampleData.FieldCaption("Costing Method"), MICAFlowBufferSampleData."Costing Method Raw"), '');

                if not EvaluateRawBoolToBool(MICAFlowBufferSampleData."Cost Is Adjusted", MICAFlowBufferSampleData."Cost Is Adjusted Raw") then
                    Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferSampleData."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferSampleData.FieldCaption("Cost Is Adjusted"), MICAFlowBufferSampleData."Cost Is Adjusted Raw"), '');

                MICAFlowBufferSampleData.Modify();
            until MICAFlowBufferSampleData.Next() = 0;

        // Check allow partial processing
        Rec.CalcFields("Error Count");
        if not MICAFlow."Allow Partial Processing" then
            if Rec."Error Count" > 0 then begin // Aborts process if any error
                MICAFlowInformation.Update('', '');
                Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
                exit;
            end;

        // Update business data from buffer
        MICAFlowBufferSampleData.Reset();
        MICAFlowBufferSampleData.SetAutoCalcFields("Error Count");
        MICAFlowBufferSampleData.SetRange("Flow Code", Rec."Flow Code");
        MICAFlowBufferSampleData.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufferSampleData.SetRange("Skip Line", false); // discard skipped buffer records
        if MICAFlowBufferSampleData.FindSet() then
            repeat
                // Process only buffer records without error(s)
                if MICAFlowBufferSampleData."Error Count" = 0 then begin // Avoid Setrange on "Error Count" field
                    BufferCount += 1;
                    Commit();
                    if Codeunit.Run(Codeunit::"MICA Update Sample Data", MICAFlowBufferSampleData) AND Codeunit.Run(Codeunit::"MICA Update Sample Sub Line", MICAFlowBufferSampleData) then
                        UpdateCount += 1
                    else
                        if MICASampleData.get(MICAFlowBufferSampleData."No.") then begin
                            // Add error on business data
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICASampleData.RecordId(), StrSubstNo(UpdateErrorLbl, format(MICASampleData.RecordId())), GetLastErrorText());
                            // Update status on business data (loaded)
                            MICAFlowRecord.UpdateReceiveRecord(Rec."Entry No.", MICASampleData.RecordId(), Rec."Receive Status"::Loaded);
                        end else
                            // Add error on buffer (business data not found)
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferSampleData."Entry No.", StrSubstNo(UpdateErrorLbl, MICAFlowBufferSampleData."No."), GetLastErrorText());
                end;

            until MICAFlowBufferSampleData.Next() = 0;

        // Report process informations
        Rec.AddInformation(MICAFlowInformation."Info Type"::information, StrSubstNo(ProcessFinishedLbl, format(UpdateCount), Format(BufferCount)), '');
        MICAFlowInformation.Update('', '');
    end;

    local procedure EvaluateRawDateToDate(var OutValue: Date; RawDate: Text): Boolean // RawDate is in 'YYYY/DD/MM' format
    var
        XmlDate: Text;
    begin
        XmlDate := CopyStr(RawDate, 1, 4) + '-' +
                    CopyStr(RawDate, 9, 2) + '-' +
                    CopyStr(RawDate, 6, 2);
        Exit(Evaluate(OutValue, XmlDate, 9)); // Converts to native format (Xml Date format 'YYYY-MM-DD', see https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-format-property)
    end;

    local procedure EvaluateRawDecToDec(var OutValue: Decimal; RawDec: Text): Boolean // 
    var
        XmlDec: Text;
    begin
        XmlDec := DelChr(RawDec, '=', ' ');
        XmlDec := DelChr(XmlDec, '=', '.');
        XmlDec := ConvertStr(XmlDec, ',', '.');
        Exit(Evaluate(OutValue, XmlDec, 9)); // Converts to Xml Decimal format (see https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-format-property)
    end;

    local procedure EvaluateRawOptionToOption(var OutValue: Option; RawOption: Text): Boolean
    begin
        case RawOption of
            'FIFO':
                begin
                    OutValue := 0;
                    exit(true);
                end;

            'LIFO':
                begin
                    OutValue := 1;
                    exit(true);
                end;

            'Specific':
                begin
                    OutValue := 2;
                    exit(true);
                end;
            'Average':
                begin
                    OutValue := 3;
                    exit(true);
                end;
            'Standard':
                begin
                    OutValue := 4;
                    exit(true);
                end;

            else
        end;
    end;

    local procedure EvaluateRawBoolToBool(var OutValue: Boolean; RawBool: Text): Boolean
    begin
        case RawBool of
            'true':
                begin
                    OutValue := true;
                    exit(true);
                end;

            'false':
                begin
                    OutValue := false;
                    exit(true);
                end;
            else
        end;
    end;
}