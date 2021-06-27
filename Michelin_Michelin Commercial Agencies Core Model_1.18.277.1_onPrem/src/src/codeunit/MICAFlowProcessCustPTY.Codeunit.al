codeunit 82820 "MICA Flow Process Cust. PTY"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        Flow: Record "MICA Flow";
        FlowRecord: Record "MICA Flow Record";
        BufferCustomerPTY: Record "MICA Flow Buffer Cust. PTY";
        Customer: Record Customer;
        UpdateCount: Integer;
        BufferCount: Integer;
        ProcessStartedLbl: Label 'Process started.';
        ProcessFinishedLbl: Label 'Process terminated : %1 record(s) processed / %2';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';
        BufferCountLbl: Label '%1 buffer record(s) to process.';
        UpdateErrorLbl: Label 'Error while updating record %1.';
    begin
        FlowInfo.Get(Rec.AddInformation(FlowInfo."Info Type"::Information, ProcessStartedLbl, ''));
        Flow.Get(Rec."Flow Code");

        GeneralLedgerSetup.Get();

        BufferCustomerPTY.Reset();
        BufferCustomerPTY.SetRange("Flow Code", Rec."Flow Code");
        BufferCustomerPTY.SetRange("Flow Entry No.", Rec."Entry No.");
        BufferCustomerPTY.SetRange("Skip Line", false);
        FlowInfo."Description 2" := StrSubstNo(BufferCountLbl, BufferCustomerPTY.Count());
        if BufferCustomerPTY.FindSet() then
            repeat
                CheckAndEvaluateAllFields(BufferCustomerPTY, Rec);
                BufferCustomerPTY.Modify();
            until BufferCustomerPTY.Next() = 0;

        Rec.CalcFields("Error Count");
        if not flow."Allow Partial Processing" then
            if Rec."Error Count" > 0 then begin
                FlowInfo.Update('', '');
                Rec.AddInformation(FlowInfo."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
                exit;
            end;

        BufferCustomerPTY.Reset();
        BufferCustomerPTY.SetAutoCalcFields("Error Count");
        BufferCustomerPTY.SetRange("Flow Code", Rec."Flow Code");
        BufferCustomerPTY.SetRange("Flow Entry No.", Rec."Entry No.");
        BufferCustomerPTY.SetRange("Skip Line", false);
        if BufferCustomerPTY.FindSet() then
            repeat
                if BufferCustomerPTY."Error Count" = 0 then begin
                    BufferCount += 1;
                    Commit();
                    if Codeunit.Run(Codeunit::"MICA Flow Update Cust. PTY", BufferCustomerPTY) then
                        UpdateCount += 1
                    else
                        if Customer.Get(BufferCustomerPTY."No.") then begin
                            Rec.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(UpdateErrorLbl, Customer.RecordId()), GetLastErrorText());
                            FlowRecord.UpdateReceiveRecord(Rec."Entry No.", Customer.RecordId(), Rec."Receive Status"::Loaded);
                        end else
                            Rec.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(UpdateErrorLbl, BufferCustomerPTY."No."), GetLastErrorText());
                end;
            until BufferCustomerPTY.Next() = 0;

        Rec.AddInformation(FlowInfo."Info Type"::information, StrSubstNo(ProcessFinishedLbl, Format(UpdateCount), Format(BufferCount)), '');
        FlowInfo.Update('', '');
    end;

    local procedure CheckAndEvaluateAllFields(var BufferCustomerPTY: Record "MICA Flow Buffer Cust. PTY"; NewFlowEntry: Record "MICA Flow Entry")
    begin
        if BufferCustomerPTY."MICA MDM Bill-to Site Use ID" = '' then
            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("MICA MDM Bill-to Site Use ID")), '');

        CheckCodeValues(BufferCustomerPTY, NewFlowEntry);
        CheckTableValues(BufferCustomerPTY, NewFlowEntry);
        CheckRawValues(BufferCustomerPTY, NewFlowEntry);
    end;

    local procedure CheckCodeValues(var BufferCustomerPTY: Record "MICA Flow Buffer Cust. PTY"; NewFlowEntry: Record "MICA Flow Entry")
    begin
        if BufferCustomerPTY."Currency Code" <> GeneralLedgerSetup."LCY Code" then
            if CheckSingleValue(BufferCustomerPTY."Currency Code", 0) then
                NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("Currency Code")), '');

        if CheckSingleValue(BufferCustomerPTY."Language Code", 1) then
            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("Language Code")), '');

        if CheckSingleValue(BufferCustomerPTY."Country/Region Code", 2) then
            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("Country/Region Code")), '');
    end;

    local procedure CheckSingleValue(NewValue: Code[20]; TypeOfRecord: Integer): Boolean
    var
        Currency: Record Currency;
        Language: Record Language;
        CountryRegion: Record "Country/Region";
    begin
        if NewValue <> '' then
            case TypeOfRecord of
                0:
                    if not Currency.Get(NewValue) then
                        exit(true);
                1:
                    if not Language.Get(NewValue) then
                        exit(true);
                2:
                    if not CountryRegion.Get(NewValue) then
                        exit(true);
            end;
    end;

    local procedure CheckTableValues(var BufferCustomerPTY: Record "MICA Flow Buffer Cust. PTY"; NewFlowEntry: Record "MICA Flow Entry")
    var
        TableValue: Record "MICA Table Value";
    begin
        if CheckSingleFromTableValue(BufferCustomerPTY."MICA Market Code", TableValue."Table Type"::MarketCode) then
            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("MICA Market Code")), '');

        if CheckSingleFromTableValue(BufferCustomerPTY."MICA Channel", TableValue."Table Type"::CustChannel) then
            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("MICA Channel")), '');

        if CheckSingleFromTableValue(BufferCustomerPTY."MICA Business Orientation", TableValue."Table Type"::CustBusinessOrientation) then
            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("MICA Business Orientation")), '');

        if CheckSingleFromTableValue(BufferCustomerPTY."MICA Partnership", TableValue."Table Type"::CustPartnership) then
            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("MICA Partnership")), '');

        if CheckRPLStatus(BufferCustomerPTY."MICA RPL Status") then
            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("MICA RPL Status")), '');

        if CheckSingleFromTableValue(BufferCustomerPTY."MICA Segmentation Code", TableValue."Table Type"::CustSegment) then
            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(MissingValueLbl, BufferCustomerPTY.FieldCaption("MICA Segmentation Code")), '')
    end;

    local procedure CheckSingleFromTableValue(NewTableValue: Code[20]; TypeOfTableValue: Integer): Boolean
    var
        TableValue: Record "MICA Table Value";
    begin
        if NewTableValue <> '' then begin
            if not TableValue.Get(TypeOfTableValue, NewTableValue) then
                exit(true);

            if TableValue.Blocked then
                exit(true);
        end;
    end;

    local procedure CheckRPLStatus(NewTableValue: Code[20]): Boolean
    var
        TableValue: Record "MICA Table Value";
    begin
        if NewTableValue <> '' then begin
            TableValue.SetRange("Table Type", TableValue."Table Type"::RestrictedSite);
            TableValue.SetFilter(Code, NewTableValue);
            exit(TableValue.IsEmpty());
        end;
    end;

    local procedure CheckRawValues(var BufferCustomerPTY: Record "MICA Flow Buffer Cust. PTY"; NewFlowEntry: Record "MICA Flow Entry")
    begin
        CheckSingleRawValueOption(NewFlowEntry, BufferCustomerPTY."MICA Type", BufferCustomerPTY."MICA Type Raw", BufferCustomerPTY."Entry No.", 0);
        CheckSingleRawValueOption(NewFlowEntry, BufferCustomerPTY."MICA Status", BufferCustomerPTY."MICA Status Raw", BufferCustomerPTY."Entry No.", 1);
        CheckSingleRawValueOption(NewFlowEntry, BufferCustomerPTY."MICA Party Ownership", BufferCustomerPTY."MICA Party Ownership Raw", BufferCustomerPTY."Entry No.", 2);

        if BufferCustomerPTY."MICA TimeZone Raw" <> '' then
            if not Evaluate(BufferCustomerPTY."MICA TimeZone", BufferCustomerPTY."MICA TimeZone Raw", 9) then
                NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, BufferCustomerPTY."Entry No.", StrSubstNo(IncorrectValueLbl, BufferCustomerPTY.FieldCaption(BufferCustomerPTY."MICA TimeZone"), BufferCustomerPTY."MICA TimeZone Raw"), '');
    end;

    local procedure CheckSingleRawValueOption(NewFlowEntry: Record "MICA Flow Entry"; var NonRawValue: Option; RawValue: Text; FlowEntryNo: Integer; RawValueType: Integer)
    var
        BufferCustomerPTY: Record "MICA Flow Buffer Cust. PTY";
        MICAType: Option Direct,Indirect;
        MICAStatus: Option Active,Inactive;
        MICAPartyOwnership: Option "Non Group",Group,"Group Network",Internal;
    begin
        if RawValue <> '' then
            case RawValueType of
                0:
                    begin
                        if not Evaluate(MICAType, RawValue) then
                            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, FlowEntryNo, StrSubstNo(IncorrectValueLbl, BufferCustomerPTY.FieldCaption(BufferCustomerPTY."MICA Type"), RawValue), '');
                        NonRawValue := MICAType;
                    end;
                1:
                    begin
                        if not Evaluate(MICAStatus, RawValue) then
                            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, FlowEntryNo, StrSubstNo(IncorrectValueLbl, BufferCustomerPTY.FieldCaption(BufferCustomerPTY."MICA Status"), RawValue), '');
                        NonRawValue := MICAStatus;
                    end;
                2:
                    begin
                        if not Evaluate(MICAPartyOwnership, RawValue) then
                            NewFlowEntry.AddInformation(FlowInfo."Info Type"::Error, FlowEntryNo, StrSubstNo(IncorrectValueLbl, BufferCustomerPTY.FieldCaption(BufferCustomerPTY."MICA Party Ownership"), RawValue), '');
                        NonRawValue := MICAPartyOwnership;
                    end;
            end;
    end;

    var
        FlowInfo: Record "MICA Flow Information";
        GeneralLedgerSetup: Record "General Ledger Setup";
        MissingValueLbl: Label 'Missing value: Field %1';
        IncorrectValueLbl: Label 'Incorrect Value: Field %1 value %2.';
}