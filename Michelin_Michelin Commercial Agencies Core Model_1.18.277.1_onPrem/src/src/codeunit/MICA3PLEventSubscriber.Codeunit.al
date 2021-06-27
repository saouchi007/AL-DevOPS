codeunit 81624 "MICA 3PL Event Subscriber"
{
    //3PL-009: Whse. Shipment BSC to 3PL

    [EventSubscriber(ObjectType::Page, 7335, 'OnNewRecordEvent', '', true, true)]
    local procedure P7339OnNewRecordEvent(VAR Rec: Record "Warehouse Shipment Header"; BelowxRec: Boolean; VAR xRec: Record "Warehouse Shipment Header")
    var
        ManualCreateErr: label 'Warehouse Shipment not allowed to create manually.\Use action Create Warehouse Shipment instead.';
    begin
        Error(ManualCreateErr);
    end;

    [EventSubscriber(ObjectType::Codeunit, 7310, 'OnBeforeReopen', '', true, true)]
    LOCAL procedure C7310OnBeforeReopen(VAR WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        Location: Record Location;
        MICAFlowEntry: Record "MICA Flow Entry";
        MICASingleInstanceVariables: Codeunit "MICA SingleInstanceVariables";
        EntryMICAFlowMgt: Codeunit "MICA Flow Mgt";
        ReopenConfirmMsg: Label '3PL Confirmation is required to Reopen Whse. Shipment. Do you want to Continue?';
    begin
        if MICASingleInstanceVariables.Get_Skip3PLExportStatus(false) then
            exit;

        with WarehouseShipmentHeader do begin
            Location.Get("Location Code");
            EntryMICAFlowMgt.GetFlowEntry("MICA Send Last Flow Entry No.", MICAFlowEntry);
            if (MICAFlowEntry."Send Status" = MICAFlowEntry."Send Status"::Sent) and (not "MICA Skip 3PL Message") then
                if not Confirm(ReopenConfirmMsg, false) then
                    Error('');
            if (Location."MICA 3PL Location Code" <> '') and (not "MICA Skip 3PL Message") then
                if not Confirm(ReopenConfirmMsg, false) then
                    Error('');
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5750, 'OnBeforeCreateShptLineFromSalesLine', '', false, false)]
    LOCAL procedure C5750OnBeforeCreateShptLineFromSalesLine(VAR WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        With WarehouseShipmentLine do begin
            "MICA Planed Shipm. Date in SO" := SalesLine."Planned Shipment Date";
            "MICA Planned Deliv. Date in SO" := SalesLine."Planned Delivery Date";
            "MICA Shipment Date in SO" := SalesLine."Shipment Date";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5750, 'OnBeforeCreateShptLineFromTransLine', '', false, false)]
    LOCAL procedure C5750OnBeforeCreateShptLineFromTransLine(VAR WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; TransferLine: Record "Transfer Line"; TransferHeader: Record "Transfer Header")
    begin
        with WarehouseShipmentLine do begin
            "MICA Planed Shipm. Date in SO" := 0D;
            "MICA Planned Deliv. Date in SO" := 0D;
            "MICA Shipment Date in SO" := TransferLine."Shipment Date";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostSourceDocument', '', false, false)]
    local procedure WhsePostShipmentOnBeforePostSourceDocument(var SalesHeader: Record "Sales Header"; var WhseShptLine: Record "Warehouse Shipment Line")
    var
        ToSalesHeader: record "Sales Header";
        FromWarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if not ToSalesHeader.Get(ToSalesHeader."Document Type"::Order, SalesHeader."No.") then
            exit;
        if not FromWarehouseShipmentHeader.Get(WhseShptLine."No.") then
            exit;
        SalesHeader."MICA Truck Driver Info" := FromWarehouseShipmentHeader."MICA Truck Driver Info";
        SalesHeader."MICA Truck License Plate" := FromWarehouseShipmentHeader."MICA Truck License Plate";
    end;
}