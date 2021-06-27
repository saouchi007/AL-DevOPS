codeunit 82460 "MICA Whse. Shipment Events"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnBeforeCreateShptLineFromSalesLine', '', true, true)]
    local procedure cdu5750OnBeforeCreateShptLineFromSalesLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        CopyFieldsFromSalesOrder(WarehouseShipmentLine, SalesLine, SalesHeader);
    end;

    local procedure CopyFieldsFromSalesOrder(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        WarehouseSetup: Record "Warehouse Setup";
        Item: Record Item;
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;
        WarehouseSetup.Get();
        Item.Get(WarehouseShipmentLine."Item No.");
        WarehouseShipmentLine."MICA Shipping Agent Code" := SalesLine."Shipping Agent Code";
        WarehouseShipmentLine."MICA Shipp. Agent Service Code" := SalesLine."Shipping Agent Service Code";
        WarehouseShipmentLine."MICA 3PL Volume UoM" := WarehouseSetup."MICA 3PL Volume UoM";
        WarehouseShipmentLine."MICA 3PL Weight UoM" := WarehouseSetup."MICA 3PL Weight UoM";
        WarehouseShipmentLine."MICA 3PL Product Weight" := Item."MICA Product Weight";
        if WarehouseSetup."MICA 3PL to PS9 Weight Factor" <> 0 then
            WarehouseShipmentLine."MICA 3PL Product Weight" := Item."MICA Product Weight" / WarehouseSetup."MICA 3PL to PS9 Weight Factor";
        WarehouseShipmentLine."MICA 3PL Line Weight" := WarehouseShipmentLine."MICA 3PL Product Weight" * WarehouseShipmentLine.Quantity;
        WarehouseShipmentLine."MICA 3PL Product Volume" := SalesLine."Unit Volume";
        if WarehouseSetup."MICA 3PL to PS9 Volume Factor" <> 0 then
            WarehouseShipmentLine."MICA 3PL Product Volume" := SalesLine."Unit Volume" / WarehouseSetup."MICA 3PL to PS9 Volume Factor";
        WarehouseShipmentLine."MICA 3PL Line Volume" := WarehouseShipmentLine."MICA 3PL Product Volume" * WarehouseShipmentLine.Quantity;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnBeforeCreateShptLineFromTransLine', '', true, true)]
    local procedure cdu5750OnBeforeCreateShptLineFromTransLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; TransferLine: Record "Transfer Line"; TransferHeader: Record "Transfer Header")
    var
        WarehouseSetup: Record "Warehouse Setup";
        Item: Record Item;
    begin
        WarehouseSetup.Get();
        Item.Get(WarehouseShipmentLine."Item No.");
        WarehouseShipmentLine."MICA Shipping Agent Code" := TransferLine."Shipping Agent Code";
        WarehouseShipmentLine."MICA Shipp. Agent Service Code" := TransferLine."Shipping Agent Service Code";
        WarehouseShipmentLine."MICA 3PL Volume UoM" := WarehouseSetup."MICA 3PL Volume UoM";
        WarehouseShipmentLine."MICA 3PL Weight UoM" := WarehouseSetup."MICA 3PL Weight UoM";
        WarehouseShipmentLine."MICA 3PL Product Weight" := Item."MICA Product Weight";
        if WarehouseSetup."MICA 3PL to PS9 Weight Factor" <> 0 then
            WarehouseShipmentLine."MICA 3PL Product Weight" := Item."MICA Product Weight" / WarehouseSetup."MICA 3PL to PS9 Weight Factor";
        WarehouseShipmentLine."MICA 3PL Line Weight" := WarehouseShipmentLine."MICA 3PL Product Weight" * WarehouseShipmentLine.Quantity;
        WarehouseShipmentLine."MICA 3PL Product Volume" := TransferLine."Unit Volume";
        if WarehouseSetup."MICA 3PL to PS9 Volume Factor" <> 0 then
            WarehouseShipmentLine."MICA 3PL Product Volume" := TransferLine."Unit Volume" / WarehouseSetup."MICA 3PL to PS9 Volume Factor";
        WarehouseShipmentLine."MICA 3PL Line Volume" := WarehouseShipmentLine."MICA 3PL Product Volume" * WarehouseShipmentLine.Quantity;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostedWhseShptHeaderInsert', '', false, false)]
    local procedure OnBeforePostedWhseShptHeaderInsert(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        with PostedWhseShipmentHeader do begin
            "MICA 3PL Update Status" := WarehouseShipmentHeader."MICA 3PL Update Status";
            "MICA Customer Transport" := WarehouseShipmentHeader."MICA Customer Transport";
            "MICA Rcv. Last Flow Entry No." := WarehouseShipmentHeader."MICA Rcv. Last Flow Entry No.";
            "MICA Ship-to Address" := WarehouseShipmentHeader."MICA Ship-to Address";
            "MICA Ship to City" := WarehouseShipmentHeader."MICA Ship to City";
            "MICA Ship to Name" := WarehouseShipmentHeader."MICA Ship to Name";
            "MICA Ship to code" := WarehouseShipmentHeader."MICA Ship to code";
            "MICA Record ID" := WarehouseShipmentHeader."MICA Record ID";
            "MICA Send Last Flow Entry No." := WarehouseShipmentHeader."MICA Send Last Flow Entry No.";
            "MICA Send Ack. Received" := WarehouseShipmentHeader."MICA Send Ack. Received";
            "MICA Truck Driver Info" := WarehouseShipmentHeader."MICA Truck Driver Info";
            "MICA Truck License Plate" := WarehouseShipmentHeader."MICA Truck License Plate";
        end;
    end;

}