codeunit 80580 "MICA SANA Get Stock Info"
{
    [EventSubscriber(ObjectType::Table, Database::"SC - Parameters Collection", 'OnInitParams', '', FALSE, FALSE)]
    local procedure OnBeforeInitParamCollection(var InXMLBuff: Record "SC - XML Buffer (dotNET)"; var Params: Record "SC - Parameters Collection")
    var
        Customer: Record Customer;
        ShiptoAddress: Record "Ship-to Address";
        TempAddressInfoSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        ShippingAddressValue: Text;
    begin
        with Params do
            if AccountType = 'Customer' then begin
                Customer.get(params.AccountId);
                if InXmlBuff.SelectSingleNode('//ShippingAddress', TempAddressInfoSCXMLBufferdotNET) then begin
                    ShippingAddressValue := TempAddressInfoSCXMLBufferdotNET.ReadFieldValueByName('Id');
                    "MICA Ship-to Address Code" := CopyStr(ShippingAddressValue, 1, 20);
                    if UpperCase(ShippingAddressValue) <> 'DEFAULT' then
                        ShiptoAddress.get(Customer."No.", ShippingAddressValue);
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Catalog Helper", 'OnGetAvailableStock', '', false, false)]
    local procedure OnGetAvailableStock(var Params: Record "SC - Parameters Collection")
    var
        Customer: Record Customer;
        Location: Record Location;
        Item: Record Item;
        ShiptoAddress: Record "Ship-to Address";
        ShippingAgentServices: Record "Shipping Agent Services";
        MICANextTruckManagement: Codeunit "MICA Next Truck Management";
        ItemAvailabilityFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShippingAgentShippingTime: DateFormula;
        LocationOutboundWhseHandling: DateFormula;
        LocationFilter: Text;
        RequestedDeliveryDate: Date;
        ShipmentDate: Date;
        PlannedShipmentDate: Date;
        PlannedDeliveryDate: Date;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
        GrossRequirement: Decimal;
        PlannedOrderRcpt: Decimal;
        ScheduledRcpt: Decimal;
        PlannedOrderReleases: Decimal;
        ProjAvailableBalance: Decimal;
        ExpectedInventory: Decimal;
        QtyAvailable: Decimal;
        AmountType: Option "Net Change","Balance at Date";


    begin
        RequestedDeliveryDate := params.RequestedDeliveryDate;
        Item.get(Params.ProductId);
        with Params do
            if (AccountType = 'Customer') and (AccountId <> '') and ("MICA OrderType" <> '') and (RequestedDeliveryDate <> 0D) and ("MICA Ship-to Address Code" <> '') then
                if Customer.get(AccountId) then begin
                    if UpperCase("MICA OrderType") = 'EXPRESS' then begin
                        Customer.TestField("MICA Express Order");
                        if ShiptoAddress.get(Customer."No.", "MICA Ship-to Address Code") then begin
                            ShiptoAddress.TestField("MICA Express Order");
                            ShipToBaseCalendar := ShiptoAddress."MICA Base Cal. Code Exp. Order";
                            if ShippingAgentServices.Get(ShiptoAddress."MICA Ship. Agent Exp. Order", ShiptoAddress."MICA Ship Agent Serv Exp Order") then begin
                                ShippingAgentBaseCalendar := ShippingAgentServices."Base Calendar Code";
                                ShippingAgentShippingTime := ShippingAgentServices."Shipping Time";
                            end else
                                ShippingAgentBaseCalendar := '';
                            if Location.Get(ShiptoAddress."Location Code") then begin
                                LocationBaseCalendar := Location."MICA Base Cal. Code Exp. Order";
                                LocationOutboundWhseHandling := Location."MICA Outb Whse Hand T Exp Ord";
                                LocationFilter := Location.Code;
                            end else
                                if Location.Get(Customer."Location Code") then begin
                                    LocationBaseCalendar := Location."MICA Base Cal. Code Exp. Order";
                                    LocationOutboundWhseHandling := Location."MICA Outb Whse Hand T Exp Ord";
                                    LocationFilter := Location.Code;
                                end else
                                    LocationBaseCalendar := '';
                        end else begin
                            ShipToBaseCalendar := Customer."MICA Base Cal. Code Exp. Order";
                            if ShippingAgentServices.Get(Customer."MICA Shipping Agent Exp. Order", Customer."MICA Ship Agent Serv Exp Order") then begin
                                ShippingAgentBaseCalendar := ShippingAgentServices."Base Calendar Code";
                                ShippingAgentShippingTime := ShippingAgentServices."Shipping Time";
                            end else
                                ShippingAgentBaseCalendar := '';
                            if Location.Get(Customer."Location Code") then begin
                                LocationBaseCalendar := Location."MICA Base Cal. Code Exp. Order";
                                LocationOutboundWhseHandling := Location."MICA Outb Whse Hand T Exp Ord";
                                LocationFilter := Location.Code;
                            end else
                                LocationBaseCalendar := '';
                        end;
                    end else
                        if ShiptoAddress.get(Customer."No.", "MICA Ship-to Address Code") then begin
                            ShipToBaseCalendar := ShiptoAddress."MICA Base Calendar Code";
                            if ShippingAgentServices.Get(ShiptoAddress."Shipping Agent Code", ShiptoAddress."Shipping Agent Service Code") then begin
                                ShippingAgentBaseCalendar := ShippingAgentServices."Base Calendar Code";
                                ShippingAgentShippingTime := ShippingAgentServices."Shipping Time";
                            end else
                                ShippingAgentBaseCalendar := '';
                            if Location.Get(ShiptoAddress."Location Code") then begin
                                LocationBaseCalendar := Location."Base Calendar Code";
                                LocationOutboundWhseHandling := Location."Outbound Whse. Handling Time";
                                LocationFilter := Location.Code;
                            end else
                                if Location.Get(Customer."Location Code") then begin
                                    LocationBaseCalendar := Location."Base Calendar Code";
                                    LocationOutboundWhseHandling := Location."Outbound Whse. Handling Time";
                                    LocationFilter := Location.Code;
                                end else
                                    LocationBaseCalendar := '';
                        end else begin
                            ShipToBaseCalendar := Customer."Base Calendar Code";
                            if ShippingAgentServices.Get(Customer."Shipping Agent Code", Customer."Shipping Agent Service Code") then begin
                                ShippingAgentBaseCalendar := ShippingAgentServices."Base Calendar Code";
                                ShippingAgentShippingTime := ShippingAgentServices."Shipping Time";
                            end else
                                ShippingAgentBaseCalendar := '';
                            if Location.Get(Customer."Location Code") then begin
                                LocationBaseCalendar := Location."Base Calendar Code";
                                LocationOutboundWhseHandling := Location."Outbound Whse. Handling Time";
                                LocationFilter := Location.Code;
                            end else
                                LocationBaseCalendar := '';
                        end;

                    MICANextTruckManagement.CalculateDateLineOnHand(RequestedDeliveryDate,
                                                            LocationOutboundWhseHandling,
                                                            LocationBaseCalendar,
                                                            ShippingAgentShippingTime,
                                                            ShippingAgentBaseCalendar,
                                                            ShipToBaseCalendar,
                                                            ShipmentDate,
                                                            PlannedShipmentDate,
                                                            PlannedDeliveryDate);

                    Item.SetFilter("Date Filter", '..' + Format(ShipmentDate));
                    Item.SetFilter("Location Filter", LocationFilter);
                    ItemAvailabilityFormsMgt.CalcAvailQuantities(Item, AmountType = AmountType::"Balance at Date", GrossRequirement, PlannedOrderRcpt, ScheduledRcpt, PlannedOrderReleases, ProjAvailableBalance, ExpectedInventory, QtyAvailable);
                    Inventory := QtyAvailable;
                end;
    end;
}