codeunit 80500 "MICA SANA Get Delivery Dates"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Customer Functions", 'OnRunCustomerFunctions', '', false, false)]
    local procedure OnRunCustomerFunctions(var Rec: Record "SC - Operation"; var RequestBuff: Record "SC - XML Buffer (dotNET)"; var ResponseBuff: Record "SC - XML Buffer (dotNET)")
    begin
        if rec.Code = UPPERCASE('GetDeliveryDates') then
            GetDeliveryDates(RequestBuff, ResponseBuff);
    end;

    local procedure GetDeliveryDates(var InSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)")
    var
        TempSalesHeader: Record "Sales Header" temporary;
        Customer: Record Customer;
        ShiptoAddress: Record "Ship-to Address";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
        TempAddressInfoSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        TempPossibleDeliveryDatesSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        TempResultSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        MICANextTruckManagement: Codeunit "MICA Next Truck Management";
        LocationOutboundWhseHandling: DateFormula;
        ShippingAgentShippingTime: DateFormula;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
        CutOff: Boolean;
        FindShippingAddress: Boolean;
        ShippingAddressValue: Text;
        OrderType: Text;
        DateWork: Date;
        FinishDate: Date;
        RequestedDeliveryDate: Date;
        NewRequestedDeliveryDate: Date;

    begin
        RequestedDeliveryDate := 0D;
        SalesReceivablesSetup.Get();
        TempSCParametersCollection.InitParams(InSCXMLBufferdotNET, 0);
        if TempSCParametersCollection.AccountType = 'Customer' then begin
            Customer.get(TempSCParametersCollection.AccountId);
            OrderType := InSCXMLBufferdotNET.SelectSingleNodeText('OrderType');
            if InSCXMLBufferdotNET.SelectSingleNode('//AddressInfo', TempAddressInfoSCXMLBufferdotNET) then begin
                ShippingAddressValue := TempAddressInfoSCXMLBufferdotNET.CutFieldValueByName('Id');
                if ShippingAddressValue <> 'DEFAULT' then begin
                    ShiptoAddress.get(Customer."No.", ShippingAddressValue);
                    FindShippingAddress := true;
                end;
            end;

            TempSalesHeader.Init();
            TempSalesHeader.Validate("Document Type", TempSalesHeader."Document Type"::Order);
            TempSalesHeader."No." := 'TMPREC001';
            TempSalesHeader.InitRecord();
            TempSalesHeader.Validate(TempSalesHeader."Sell-to Customer No.", Customer."No.");
            if FindShippingAddress then
                TempSalesHeader.Validate("Ship-to Code", ShiptoAddress.Code);
            if OrderType = 'Express' then
                TempSalesHeader.VALIDATE("MICA Order Type", TempSalesHeader."MICA Order Type"::"Express Order");
            MICANextTruckManagement.GetBasCalendars(TempSalesHeader, LocationBaseCalendar, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff, TempSalesHeader."Location Code");
            LocationOutboundWhseHandling := TempSalesHeader."Outbound Whse. Handling Time";
            ShippingAgentShippingTime := TempSalesHeader."Shipping Time";

            OutSCXMLBufferdotNET.AddElement(TempPossibleDeliveryDatesSCXMLBufferdotNET, 'PossibleDeliveryDates', '');
            DateWork := WorkDate();
            FinishDate := CalcDate(SalesReceivablesSetup."MICA SANA Next Trucks Period", DateWork);
            repeat
                NewRequestedDeliveryDate := MICANextTruckManagement.CalculateRequestedDeliveryDate(DateWork,
                                                                                                LocationOutboundWhseHandling,
                                                                                                LocationBaseCalendar,
                                                                                                ShippingAgentShippingTime,
                                                                                                ShippingAgentBaseCalendar,
                                                                                                ShipToBaseCalendar,
                                                                                                CutOff);

                if (NewRequestedDeliveryDate <= FinishDate) and (NewRequestedDeliveryDate <> RequestedDeliveryDate) then begin
                    TempPossibleDeliveryDatesSCXMLBufferdotNET.AddElement(TempResultSCXMLBufferdotNET, 'PossibleDeliveryDate', '');
                    TempResultSCXMLBufferdotNET.AddFieldElement('Date', copystr(format(NewRequestedDeliveryDate), 1, 1024));
                    RequestedDeliveryDate := NewRequestedDeliveryDate;
                end;
                DateWork := CalcDate('<+1D>', DateWork);
            until (DateWork > FinishDate) or (OrderType = 'Express');
        end;
    end;
}