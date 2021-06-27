codeunit 81060 "MICA ShipToAddrOnExecEvent"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Warehouse Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure t7321OnAfterInsertEvent(var Rec: record "Warehouse Shipment Line")
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        SalesHeader: Record "Sales Header";
    begin
        IF NOT WarehouseShipmentHeader.Get(Rec."No.") then
            exit;
        if not SalesHeader.Get(REc."Source Document", REc."Source No.") then
            exit;
        WarehouseShipmentHeader."MICA Ship to City" := SalesHeader."Ship-to City";
        WarehouseShipmentHeader."MICA Ship to code" := SalesHeader."Ship-to Code";
        WarehouseShipmentHeader."MICA Ship to Name" := SalesHeader."Ship-to Name";
        WarehouseShipmentHeader."MICA Ship-to Address" := SalesHeader."Ship-to Address";
        WarehouseShipmentHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostedWhseShptHeaderInsert', '', false, false)]
    local procedure C5763OnBeforePostUpdateWhseDocuments(VAR PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShipmentHeader."MICA Ship to City" := WarehouseShipmentHeader."MICA Ship to City";
        PostedWhseShipmentHeader."MICA Ship to code" := WarehouseShipmentHeader."MICA Ship to code";
        PostedWhseShipmentHeader."MICA Ship to Name" := WarehouseShipmentHeader."MICA Ship to Name";
        PostedWhseShipmentHeader."MICA Ship-to Address" := WarehouseShipmentHeader."MICA Ship-to Address";
    end;
}