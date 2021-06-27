codeunit 82400 "MICA Flow Send Sales Order SPD"
{
    //SPD-002
    TableNo = "MICA Flow";

    var
        StartMsg: Label 'Start preparing data';
        DataPrepLbl: Label 'Data Preparation executed.';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        ExportFailLbl: Label 'Export Failed (%1)';

    trigger OnRun()
    begin
        SalesOrderNotShipped(Rec);
        SalesOrderHistory(Rec);
    end;

    local procedure SalesOrderNotShipped(var EntryMICAFlow: Record "MICA Flow")
    var
        MICAFlowInformation: Record "MICA Flow Information";
        NewMICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";
        MICAExportSalesOrderOpenSPD: XmlPort "MICA Export SalesOrderOpen SPD";
        SetDestOutStream: OutStream;
        OutStream: OutStream;
        InStream: InStream;
        ExportedRecordCount: Integer;
    begin
        if not NewMICAFlowEntry.Get(EntryMICAFlow.CreateFlowEntry()) then begin
            EntryMICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error, 'Unable to create Flow entry', '');
            exit;
        end;

        MICAFlowInformation.Get(NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        TempBlob.CreateOutStream(SetDestOutStream);
        MICAExportSalesOrderOpenSPD.SetDestination(SetDestOutStream);
        MICAExportSalesOrderOpenSPD.SetFlowEntry(NewMICAFlowEntry);
        MICAExportSalesOrderOpenSPD.CheckAndRetrieveParameters();
        if not MICAExportSalesOrderOpenSPD.Export() then begin
            NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;

        ExportedRecordCount := MICAExportSalesOrderOpenSPD.GetRecordCount();
        NewMICAFlowEntry.Description := CopyStr(MICAExportSalesOrderOpenSPD.GetFileName(), 1, 100);

        clear(OutStream);
        clear(InStream);
        NewMICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        NewMICAFlowEntry.Validate(Blob);
        NewMICAFlowEntry.Modify(true);

        NewMICAFlowEntry.CalcFields("Error Count");
        If NewMICAFlowEntry."Error Count" = 0 then begin
            NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            NewMICAFlowEntry.PrepareToSend();
        end else
            NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, NewMICAFlowEntry.FieldCaption("Send Status"), NewMICAFlowEntry."Send Status"::Prepared, NewMICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;

    local procedure SalesOrderHistory(var EntryMICAFlow: Record "MICA Flow")
    var
        MICAFlowInformation: Record "MICA Flow Information";
        NewMICAFlowEntry: Record "MICA Flow Entry";
        TempBlob: Codeunit "Temp Blob";
        MICAExportSalesOrderHstSPD: XmlPort "MICA Export SalesOrder Hst.SPD";
        SetDestOutStream: OutStream;
        OutStream: OutStream;
        InStream: InStream;
        ExportedRecordCount: Integer;
    begin
        if not NewMICAFlowEntry.Get(EntryMICAFlow.CreateFlowEntry()) then begin
            EntryMICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error, 'Unable to create Flow entry', '');
            exit;
        end;

        MICAFlowInformation.Get(NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        TempBlob.CreateOutStream(SetDestOutStream);
        MICAExportSalesOrderHstSPD.SetDestination(SetDestOutStream);
        MICAExportSalesOrderHstSPD.SetFlowEntry(NewMICAFlowEntry);
        MICAExportSalesOrderHstSPD.CheckAndRetrieveParameters();
        if not MICAExportSalesOrderHstSPD.Export() then begin
            NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailLbl, GetLastErrorText()), '');
            exit;
        end;

        ExportedRecordCount := MICAExportSalesOrderHstSPD.GetRecordCount();
        NewMICAFlowEntry.Description := CopyStr(MICAExportSalesOrderHstSPD.GetFileName(), 1, MaxStrLen(NewMICAFlowEntry.Description));

        clear(OutStream);
        clear(InStream);
        NewMICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        NewMICAFlowEntry.Validate(Blob);
        NewMICAFlowEntry.Modify(true);

        NewMICAFlowEntry.CalcFields("Error Count");
        If NewMICAFlowEntry."Error Count" = 0 then begin
            NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            NewMICAFlowEntry.PrepareToSend();
        end else
            NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, NewMICAFlowEntry.FieldCaption("Send Status"), NewMICAFlowEntry."Send Status"::Prepared, NewMICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;

    procedure FormatDecimal(Dec: decimal): Text
    begin
        exit(DelChr(Format(Dec, 15, 9), '<'));
    end;

    procedure FormatInteger(Int: Integer): Text
    begin
        exit(DelChr(Format(Int, 10, 9), '<'));
    end;

    procedure FormatDate(DateToFormat: Date): Text
    begin
        exit(FORMAT(DateToFormat, 0, '<Day,2>-<Month,2>-<Year4>'));
    end;

    procedure FormatDateTime(DateToFormat: Date): Text
    var
        dt: DateTime;
    begin
        dt := CreateDateTime(DateToFormat, 0T);
        exit(FORMAT(dt, 0, '<Day,2>-<Month,2>-<Year4><Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>'));
    end;

    procedure FormatDateTimeTimeZone(DateToFormat: Date; TimeToFormat: Time; TimeZone: Text): Text
    var
        DateTimeString: Text;
    begin
        DateTimeString := FORMAT(CreateDateTime(DateToFormat, TimeToFormat), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');
        if DateTimeString <> '' then
            exit(DateTimeString + TimeZone)
    end;

    procedure GetCreditHoldFlag(DocumentNo: Code[20]; PrVal_CREDITLIMITWORKFLOW: Text): Text
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Table ID", 36);
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        ApprovalEntry.SetRange("Approval Code", PrVal_CREDITLIMITWORKFLOW);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        if ApprovalEntry.IsEmpty() then
            exit('N')
        else
            exit('Y');
    end;

    procedure GetForecastCustomerCode(CustomerNo: Code[20]; ItemCategoryCode: Code[20]): Code[5]
    var
        MICAForecastCustomerCode: Record "MICA Forecast Customer Code";
    begin
        IF MICAForecastCustomerCode.Get(CustomerNo, ItemCategoryCode) then
            exit(MICAForecastCustomerCode."Forecast Code");
    end;

    procedure GetItemMarketCode(ItemNo: Code[20]): Text;
    var
        MICATableValue: Record "MICA Table Value";
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit;
        if MICATableValue.Get(MICATableValue."Table Type"::MarketCode, Item."MICA Market Code") then
            exit(MICATableValue.Description);
    end;

    procedure GetDRPINLocationCode(LocationCode: Code[10]): Code[50]
    var
        Location: Record Location;
    begin
        if Location.Get(LocationCode) then
            exit(Location."MICA DRP IN Location Code");
    end;

}