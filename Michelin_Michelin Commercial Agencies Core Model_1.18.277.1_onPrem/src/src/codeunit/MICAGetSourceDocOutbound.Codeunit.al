codeunit 81622 "MICA Get Source Doc. Outbound"
{
    //3PL-009: Whse. Shipment BSC to 3PL
    // Based on standard codeunit "Get Source Doc. Outbound"

    var
        MICAGetSourceDocumentbyShp: Report "MICA Get Source Document byShp";
        Text003Err: Label 'The warehouse shipment was not created because an open warehouse shipment exists for the Sales Header and Shipping Advice is %1.\\You must add the item(s) as new line(s) to the existing warehouse shipment or change Shipping Advice to Partial.';
        Text004Err: Label 'No %1 was found. The warehouse shipment could not be created.';

    procedure CreateFromSalesOrder(SalesHeader: Record "Sales Header")
    var
        MICAWhseSalesReleasebyShp: Codeunit "MICA Whse.-Sales Release byShp";
        ResultToShow: Boolean;
    begin
        MICAWhseSalesReleasebyShp.CreateAllWhseRqst(SalesHeader);
        ResultToShow := CreateFromSalesOrderHideDialog(SalesHeader);
        ShowResult(ResultToShow);
    end;

    LOCAL procedure GetRequireShipRqst(VAR MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship")
    var
        Location: Record Location;
        LocationCode: Text;
    begin
        IF MICAWarehouseRequestbyShip.FINDSET() THEN BEGIN
            REPEAT
                IF Location.RequireShipment(MICAWarehouseRequestbyShip."Location Code") THEN
                    LocationCode += MICAWarehouseRequestbyShip."Location Code" + '|';
            UNTIL MICAWarehouseRequestbyShip.NEXT() = 0;
            IF LocationCode <> '' THEN BEGIN
                LocationCode := COPYSTR(LocationCode, 1, STRLEN(LocationCode) - 1);
                IF LocationCode[1] = '|' THEN
                    LocationCode := '''''' + LocationCode;
            END;
            MICAWarehouseRequestbyShip.SETFILTER("Location Code", LocationCode);
        END;
    end;

    LOCAL procedure FindWarehouseRequestForSalesOrder(VAR MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship"; SalesHeader: Record "Sales Header")
    var
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
    begin
        WITH SalesHeader DO BEGIN
            TESTFIELD(Status, Status::Released);
            IF WhseShpmntConflict("Document Type".AsInteger(), "No.", "Shipping Advice".AsInteger()) THEN
                ERROR(Text003Err, FORMAT("Shipping Advice"));
            GetSourceDocOutbound.CheckSalesHeader(SalesHeader, TRUE);
            MICAWarehouseRequestbyShip.SETRANGE(Type, MICAWarehouseRequestbyShip.Type::Outbound);
            MICAWarehouseRequestbyShip.SetSourceFilter(DATABASE::"Sales Line", "Document Type".AsInteger(), "No.");
            MICAWarehouseRequestbyShip.SETRANGE("Document Status", MICAWarehouseRequestbyShip."Document Status"::Released);
            GetRequireShipRqst(MICAWarehouseRequestbyShip);
        END;
    end;

    LOCAL procedure CreateWhseShipmentHeaderFromWhseRequest(VAR MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship"): Boolean
    begin
        IF MICAWarehouseRequestbyShip.ISEMPTY() THEN
            EXIT(FALSE);

        CLEAR(MICAGetSourceDocumentbyShp);
        MICAGetSourceDocumentbyShp.USEREQUESTPAGE(FALSE);
        MICAGetSourceDocumentbyShp.SETTABLEVIEW(MICAWarehouseRequestbyShip);
        MICAGetSourceDocumentbyShp.SetHideDialog(TRUE);
        MICAGetSourceDocumentbyShp.RUNMODAL();
        exit(true);
    end;

    procedure CreateFromSalesOrderHideDialog(SalesHeader: Record "Sales Header"): Boolean
    var
        MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        FindWarehouseRequestForSalesOrder(MICAWarehouseRequestbyShip, SalesHeader);

        IF MICAWarehouseRequestbyShip.ISEMPTY() THEN
            EXIT(FALSE);

        CreateWhseShipmentHeaderFromWhseRequest(MICAWarehouseRequestbyShip);
        WarehouseShipmentLine.SetRange("Source Type", Database::"Sales Line");
        WarehouseShipmentLine.SetRange("Source No.", SalesHeader."No.");
        if WarehouseShipmentLine.IsEmpty() then
            exit(false);
        exit(true);
    end;


    LOCAL procedure OpenWarehouseShipmentPage()
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        MICAGetSourceDocumentbyShp.GetLastShptHeader(WarehouseShipmentHeader);
        PAGE.RUN(PAGE::"Warehouse Shipment", WarehouseShipmentHeader);
    end;

    LOCAL procedure ShowResult(WhseShipmentCreated: Boolean)
    var
        MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship";
    begin
        IF WhseShipmentCreated THEN BEGIN
            MICAGetSourceDocumentbyShp.ShowShipmentDialog();
            OpenWarehouseShipmentPage();
        END ELSE
            MESSAGE(Text004Err, MICAWarehouseRequestbyShip.TABLECAPTION());
    end;

    procedure CreateFromOutbndTransferOrder(TransferHeader: Record "Transfer Header")
    begin
        ShowResult(CreateFromOutbndTransferOrderHideDialog(TransferHeader));
    end;

    procedure CreateFromOutbndTransferOrderHideDialog(TransferHeader: Record "Transfer Header"): Boolean
    var
        MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship";
    begin
        FindWarehouseRequestForOutbndTransferOrder(MICAWarehouseRequestbyShip, TransferHeader);
        EXIT(CreateWhseShipmentHeaderFromWhseRequest(MICAWarehouseRequestbyShip));
    end;

    LOCAL procedure FindWarehouseRequestForOutbndTransferOrder(VAR MICAWarehouseRequestbyShip: Record "MICA Warehouse Request by Ship"; TransferHeader: Record "Transfer Header")
    var
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
    begin
        WITH TransferHeader DO BEGIN
            TESTFIELD(Status, Status::Released);
            GetSourceDocOutbound.CheckTransferHeader(TransferHeader, TRUE);
            MICAWarehouseRequestbyShip.SETRANGE(Type, MICAWarehouseRequestbyShip.Type::Outbound);
            MICAWarehouseRequestbyShip.SetSourceFilter(DATABASE::"Transfer Line", 0, "No.");
            MICAWarehouseRequestbyShip.SETRANGE("Document Status", MICAWarehouseRequestbyShip."Document Status"::Released);
            GetRequireShipRqst(MICAWarehouseRequestbyShip);
        END;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterSalesHeaderOnAfterGetRecord', '', false, false)]
    local procedure OnAfterSalesHeaderOnAfterGetRecordReportGetSourceDocuments(SalesHeader: Record "Sales Header"; var SkipRecord: Boolean)
    var
        SalesLine: Record "Sales Line";
        Location: Record Location;
        OneLineOk: Boolean;
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange("MICA Status", SalesLine."MICA Status"::"Reserve OnHand");
            if not SalesLine.FindSet() then begin
                SkipRecord := true;
                exit;
            end else
                repeat
                    if Location.Get(SalesLine."Location Code") then
                        if format(Location."MICA 3PL Anticipation Period") <> '' then
                            if SalesLine."Shipment Date" <= CalcDate(Location."MICA 3PL Anticipation Period", WorkDate()) then
                                OneLineOk := true
                            else
                                if SalesHeader."Shipping Advice" = SalesHeader."Shipping Advice"::Complete then begin
                                    SkipRecord := true;
                                    exit;
                                end;
                until SalesLine.Next() = 0;
            if not OneLineOk then
                SkipRecord := true;
        end;
    end;
}