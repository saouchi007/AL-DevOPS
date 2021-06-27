codeunit 80871 "MICA Flow Send Sample TXT"
{
    TableNo = "MICA Flow";

    trigger OnRun()
    var
        MissingValueLbl: Label 'Empty Field : %1';
        DataPrepLbl: Label 'Data Preparation Executed';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        ExportedRecordCount: Integer;
        OutStream: OutStream;
        InStream: InStream;
    begin
        If not MICAFlowEntry.Get(Rec.CreateFlowEntry()) then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, 'Unable to create Flow Entry', '');
            exit;
        end;
        MICAFlowEntry.Description += '.txt';
        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, 'Start Preparing Data', ''));

        MICASampleData.Reset();
        MICASampleData.SetRange("MICA Send Last Flow Status", MICASampleData."MICA Send Last Flow Status"::" "); //Send only newly created data
        If MICASampleData.FindSet(false) then
            repeat
                if MICASampleData.Description = '' then // simulate error on business data (not exported)
                    MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICASampleData.RecordId(), StrSubstNo(MissingValueLbl, MICASampleData.FieldCaption(Description)), Format(MICASampleData.RecordId()))
                else begin
                    TempBlob.CreateOutStream(OutStream);
                    OutStream.WriteText(FormatTextLine(MICASampleData));
                    OutStream.WriteText(Rec.GetCRLF());
                    // TempBlob.WriteTextLine(FormatTextLine(SampleData));
                    // TempBlob.WriteTextLine(GetCRLF());
                    MICAFlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", MICASampleData.RecordId(), MICAFlowEntry."Send Status"::Prepared); // Update last send status on business data
                    ExportedRecordCount += 1;
                end;

            until MICASampleData.Next() = 0;

        // Update Blob with exported data
        clear(OutStream);
        clear(InStream);
        MICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        MICAFlowEntry.Validate(Blob);
        MICAFlowEntry.Modify(true);

        MICAFlowEntry.CalcFields("Error Count");
        If ExportedRecordCount > 0 then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            MICAFlowEntry.PrepareToSend(); // update last send status on flow entries
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;

    local procedure FormatTextLine(LocMICASampleData: Record "MICA Sample Data") FormattedText: Text
    var
        FieldSeparatorLbl: label ';', Locked = true;
    begin
        FormattedText := LocMICASampleData."No." + FieldSeparatorLbl;
        FormattedText += LocMICASampleData.Description + FieldSeparatorLbl;
        FormattedText += LocMICASampleData."Inventory Posting Group" + FieldSeparatorLbl;
        FormattedText += format(LocMICASampleData."Costing Method") + FieldSeparatorLbl;
        FormattedText += format(LocMICASampleData."Unit Cost") + FieldSeparatorLbl;
        FormattedText += format(LocMICASampleData."Cost Is Adjusted") + FieldSeparatorLbl;
        FormattedText += format(LocMICASampleData."Lead Time Calculation") + FieldSeparatorLbl;
        FormattedText += format(LocMICASampleData."Last Date Time Modified", 0, 9) + FieldSeparatorLbl;
        FormattedText += format(LocMICASampleData."Last Date Modified") + FieldSeparatorLbl;
        FormattedText += format(LocMICASampleData."Last Time Modified") + FieldSeparatorLbl;

    end;






    var
        MICASampleData: Record "MICA Sample Data";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowRecord: Record "MICA Flow Record";
        TempBlob: Codeunit "Temp Blob";

}