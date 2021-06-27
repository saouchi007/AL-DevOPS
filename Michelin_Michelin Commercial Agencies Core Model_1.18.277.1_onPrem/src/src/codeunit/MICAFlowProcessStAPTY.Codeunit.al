codeunit 82840 "MICA Flow Process StA PTY"
{
    TableNo = "MICA Flow Entry";

    trigger OnRun()
    var
        MICAFlowRecord: Record "MICA Flow Record";
        ShiptoAddress: Record "Ship-to Address";
        MICAFlowBufferStAPTY: Record "MICA Flow Buffer StA PTY";
        ProcessStartedLbl: Label 'Process started.';
        ProcessFinishedLbl: Label 'Process terminated : %1 record(s) processed / %2';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';
        BufferCountLbl: Label '%1 buffer record(s) to process.';
        UpdateErrorLbl: Label 'Error while updating record %1.';
        UpdateCount: Integer;
        BufferCount: Integer;
    begin
        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, ProcessStartedLbl, ''));
        MICAFlow.Get(Rec."Flow Code");

        MICAFlowBufferStAPTY.Reset();
        MICAFlowBufferStAPTY.SetRange("Flow Code", Rec."Flow Code");
        MICAFlowBufferStAPTY.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufferStAPTY.SetRange("Skip Line", false);
        MICAFlowInformation."Description 2" := StrSubstNo(BufferCountLbl, MICAFlowBufferStAPTY.Count());
        if MICAFlowBufferStAPTY.FindSet() then
            repeat
                CheckAndEvaluateFields(MICAFlowBufferStAPTY, Rec);
                MICAFlowBufferStAPTY.Modify();
            until MICAFlowBufferStAPTY.Next() = 0;

        Rec.CalcFields("Error Count");
        if not MICAFlow."Allow Partial Processing" then
            if Rec."Error Count" > 0 then begin
                MICAFlowInformation.Update('', '');
                Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
                exit;
            end;

        MICAFlowBufferStAPTY.Reset();
        MICAFlowBufferStAPTY.SetAutoCalcFields("Error Count");
        MICAFlowBufferStAPTY.SetRange("Flow Code", Rec."Flow Code");
        MICAFlowBufferStAPTY.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowBufferStAPTY.SetRange("Skip Line", false);
        if MICAFlowBufferStAPTY.FindSet() then
            repeat
                if MICAFlowBufferStAPTY."Error Count" = 0 then begin
                    BufferCount += 1;
                    Commit();
                    if Codeunit.Run(Codeunit::"MICA Flow Update ShipTo Addr.", MICAFlowBufferStAPTY) then
                        UpdateCount += 1
                    else
                        if ShiptoAddress.Get(MICAFlowBufferStAPTY."Customer No.", MICAFlowBufferStAPTY.Code) then begin
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, ShiptoAddress.RecordId(), StrSubstNo(UpdateErrorLbl, Format(ShiptoAddress.RecordId())), GetLastErrorText());
                            MICAFlowRecord.UpdateReceiveRecord(Rec."Entry No.", ShiptoAddress.RecordId(), Rec."Receive Status"::Loaded);
                        end else
                            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferStAPTY."Entry No.", StrSubstNo(UpdateErrorLbl, MICAFlowBufferStAPTY.Code), GetLastErrorText());
                end;
            until MICAFlowBufferStAPTY.Next() = 0;

        Rec.AddInformation(MICAFlowInformation."Info Type"::information, StrSubstNo(ProcessFinishedLbl, Format(UpdateCount), Format(BufferCount)), '');
        MICAFlowInformation.Update('', '');
    end;

    local procedure CheckAndEvaluateFields(var MICAFlowBufferStAPTY: Record "MICA Flow Buffer StA PTY"; MICAFlowEntry: Record "MICA Flow Entry")
    var
        MICATableValue: Record "MICA Table Value";
        MissingValuesLbl: Label 'Missing values for fields : Field %1 and Field %2.';
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
        CustomerDoesntExistLbl: Label 'Customer with %1: %2 does not exist.';
    begin
        if MICAFlowBufferStAPTY."Customer No." <> '' then
            if CustomerExists(MICAFlowBufferStAPTY."Customer No.") then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferStAPTY."Entry No.", StrSubstNo(CustomerDoesntExistLbl, MICAFlowBufferStAPTY.FieldCaption("Customer No."),
                    MICAFlowBufferStAPTY."Customer No."), '');

        if (MICAFlowBufferStAPTY."MICA MDM Ship-to Use ID" = '') and (MICAFlowBufferStAPTY."Customer No." = '') then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferStAPTY."Entry No.", StrSubstNo(MissingValuesLbl, MICAFlowBufferStAPTY.FieldCaption("MICA MDM Ship-to Use ID"),
                                MICAFlowBufferStAPTY.FieldCaption("Customer No.")), '');

        if MICAFlowBufferStAPTY."MICA Time Zone Raw" <> '' then
            if not Evaluate(MICAFlowBufferStAPTY."MICA Time Zone", MICAFlowBufferStAPTY."MICA Time Zone Raw") then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferStAPTY."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferStAPTY.FieldCaption("MICA Time Zone"), MICAFlowBufferStAPTY."MICA Time Zone Raw"), '')
            else
                CheckTimeZone(MICAFlowEntry, MICAFlowBufferStAPTY."Entry No.", MICAFlowBufferStAPTY.FieldCaption("MICA Time Zone"), MICAFlowBufferStAPTY."MICA Time Zone");

        if MICAFlowBufferStAPTY."MICA Status Raw" <> '' then
            if not Evaluate(MICAFlowBufferStAPTY."MICA Status", MICAFlowBufferStAPTY."MICA Status Raw") then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferStAPTY."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferStAPTY.FieldCaption("MICA Status"), MICAFlowBufferStAPTY."MICA Status Raw"), '');

        CheckCountryRegion(MICAFlowEntry, MICAFlowBufferStAPTY."Entry No.", MICAFlowBufferStAPTY.FieldCaption("Country/Region Code"), MICAFlowBufferStAPTY."Country/Region Code");
        CheckTablevalue(MICAFlowEntry, MICAFlowBufferStAPTY."Entry No.", MICATableValue."Table Type"::RestrictedSite, MICAFlowBufferStAPTY.FieldCaption("MICA RPL Status"), MICAFlowBufferStAPTY."MICA RPL Status");

        if not Evaluate(MICAFlowBufferStAPTY."Ship-to Addr. Nos.", CheckShipToNosParameterValue(MICAFlowEntry)) then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBufferStAPTY."Entry No.", StrSubstNo(IncorrectValueLbl, MICAFlowBufferStAPTY.FieldCaption("Ship-to Addr. Nos."), MICAFlowBufferStAPTY."Ship-to Addr. Nos."), '');
    end;

    local procedure CustomerExists(BillToUseSiteID: Code[20]): Boolean
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("MICA MDM Bill-to Site Use ID", BillToUseSiteID);
        exit(Customer.IsEmpty());
    end;

    local procedure CheckTablevalue(var MICAFlowEntry: Record "MICA Flow Entry"; EntryNo: Integer; TableType: Integer; BufferFieldCaption: Text; BufferCode: Code[20]);
    var
        MICATableValue: Record "MICA Table Value";
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
    begin
        if BufferCode <> '' then begin
            MICATableValue.SetRange("Table Type", TableType);
            MICATableValue.SetFilter(Code, BufferCode);
            if MICATableValue.IsEmpty() then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, EntryNo, StrSubstNo(IncorrectValueLbl, BufferFieldCaption, BufferCode), '')
        end;
    end;

    local procedure CheckCountryRegion(var MICAFlowEntry: Record "MICA Flow Entry"; EntryNo: integer; BufferFieldCaption: Text; BufferCode: Code[10]);
    var
        CountryRegion: Record "Country/Region";
        MissingValueLbl: Label 'Missing value : Field %1.';
    begin
        if BufferCode <> '' then
            if not CountryRegion.Get(BufferCode) then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, EntryNo, StrSubstNo(MissingValueLbl, BufferFieldCaption), '');
    end;

    local procedure CheckTimeZone(var MICAFlowEntry: Record "MICA Flow Entry"; EntryNo: Integer; BufferFieldCaption: Text; BufferCode: Integer)
    var
        TimeZone: Record "Time Zone";
        MissingValueLbl: Label 'Missing value : Field %1.';
    begin
        if BufferCode <> 0 then
            if not TimeZone.Get(BufferCode) then
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, EntryNo, StrSubstNo(MissingValueLbl, BufferFieldCaption), '');
    end;

    local procedure CheckShipToNosParameterValue(var MICAFlowEntry: Record "MICA Flow Entry"): Text
    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        ParamTxtValue: Text;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        EmptyParamValueMsg: Label 'Empty value in parameter %1 in Flow Parameters';
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param_ShipToAddrNosLbl) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param_ShipToAddrNosLbl), '');
            exit;
        end;

        ParamTxtValue := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param_ShipToAddrNosLbl);

        if ParamTxtValue = '' then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(EmptyParamValueMsg, Param_ShipToAddrNosLbl), '');
            exit('');
        end;

        exit(ParamTxtValue);
    end;

    var
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlow: Record "MICA Flow";
        Param_ShipToAddrNosLbl: Label 'SHIPTOADDRNOS', Locked = true;

}