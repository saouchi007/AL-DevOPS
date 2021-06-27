codeunit 82640 "MICA Sales Order Dates Mgt."
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            RecalculateRequestedDeliveryDate(SalesHeader);
    end;

    local procedure RecalculateRequestedDeliveryDate(var SalesHeader: Record "Sales Header")
    var
        MICANextTruckMgt: Codeunit "MICA Next Truck Management";
        FirstTruckDay: Date;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
        CutOff: Boolean;
    begin
        MICANextTruckMgt.GetBasCalendars(SalesHeader, LocationBaseCalendar, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff, SalesHeader."Location Code");
        FirstTruckDay := MICANextTruckMgt.CalculateRequestedDeliveryDate(WorkDate(), SalesHeader."Outbound Whse. Handling Time", LocationBaseCalendar, SalesHeader."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff);
        RecaluclateDatesOnSalesLines(SalesHeader, FirstTruckDay);
    end;

    local procedure RecaluclateDatesOnSalesLines(SalesHeader: Record "Sales Header"; FirstTruckDay: Date)
    var
        SalesLine: Record "Sales Line";
        CommitSplitLineSetup: Record "MICA Commit/Split Line Setup";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        MICANextTruckMgt: Codeunit "MICA Next Truck Management";
        RequestedDeliveryDate: Date;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
        CutOff: Boolean;
    begin
        CommitSplitLineSetup.Get();

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("MICA Status", '%1|%2|%3', SalesLine."MICA Status"::Open, SalesLine."MICA Status"::"Reserve InTransit", SalesLine."MICA Status"::"Reserve OnHand");
        if SalesLine.FindSet() then
            repeat
                WarehouseShipmentLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.", "Assemble to Order");
                WarehouseShipmentLine.SetRange("Source Type", Database::"Sales Line");
                WarehouseShipmentLine.SetRange("Source Subtype", SalesLine."Document Type");
                WarehouseShipmentLine.SetRange("Source No.", SalesLine."Document No.");
                WarehouseShipmentLine.SetRange("Source Line No.", SalesLine."Line No.");
                if WarehouseShipmentLine.IsEmpty then
                    if SalesLine."Location Code" = SalesHeader."Location Code" then begin
                        if SalesLine."Planned Delivery Date" < FirstTruckDay then begin
                            SalesLine.SuspendStatusCheck(true);
                            if SalesLine."Planned Delivery Date" < CommitSplitLineSetup."Back Order Default Ship. Date" then
                                SalesLine.Validate("MICA Prev. Planned Del. Date", SalesLine."Planned Delivery Date");
                            SalesLine.Validate("MICA Delivery Date Modified", Today());
                            SalesLine.Validate("Planned Delivery Date", FirstTruckDay);
                            SalesLine.Modify(true);
                        end;
                    end else begin
                        MICANextTruckMgt.GetBasCalendars(SalesHeader, LocationBaseCalendar, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff, SalesLine."Location Code");
                        RequestedDeliveryDate := MICANextTruckMgt.CalculateRequestedDeliveryDate(
                                                        WorkDate(),
                                                        SalesLine."Outbound Whse. Handling Time",
                                                        LocationBaseCalendar,
                                                        SalesLine."Shipping Time",
                                                        ShippingAgentBaseCalendar,
                                                        ShipToBaseCalendar,
                                                        CutOff);
                        if SalesLine."Planned Delivery Date" < RequestedDeliveryDate then begin
                            SalesLine.SuspendStatusCheck(true);
                            if SalesLine."Planned Delivery Date" < CommitSplitLineSetup."Back Order Default Ship. Date" then
                                SalesLine.Validate("MICA Prev. Planned Del. Date", SalesLine."Planned Delivery Date");
                            SalesLine.Validate("MICA Delivery Date Modified", Today());
                            SalesLine.Validate("Planned Delivery Date", RequestedDeliveryDate);
                            SalesLine.Modify(true);
                        end;
                    end;
            until SalesLine.Next() = 0;
    end;
}