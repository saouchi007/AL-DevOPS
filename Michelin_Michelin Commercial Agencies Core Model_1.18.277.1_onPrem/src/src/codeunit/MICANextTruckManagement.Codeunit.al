codeunit 80220 "MICA Next Truck Management"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnBeforeValidateSellToCustomerNoSalesHeader(var Rec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if not Rec.CheckThereIsNoLine() then
                Error(CantChangeOrderTypeCauseSalesLineErr, Rec.FieldCaption("Sell-to Customer No."));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateSellToCustomerNoSalesHeader(var Rec: Record "Sales Header")
    var
        ShiptoAddress: Record "Ship-to Address";
        Customer: Record Customer;
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") then begin
                Rec.CanBeAnExpressOrder();
                if ShiptoAddress.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code") then begin
                    Rec.Validate("Shipping Agent Code", ShiptoAddress."MICA Ship. Agent Exp. Order");
                    Rec.Validate("Shipping Agent Service Code", ShiptoAddress."MICA Ship Agent Serv Exp Order");
                end else begin
                    Customer.Get(Rec."Sell-to Customer No.");
                    Rec.Validate("Shipping Agent Code", Customer."MICA Shipping Agent Exp. Order");
                    Rec.Validate("Shipping Agent Service Code", Customer."MICA Ship Agent Serv Exp Order");
                end;
            end;
            if (Rec."Sell-to Customer No." <> '') and (Rec."Location Code" <> '') then
                CalculateRequestedDeliveryDateSalesHeader(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Location Code', false, false)]
    local procedure OnBeforeValidateLocationCodeSalesHeader(var Rec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if not Rec.CheckThereIsNoLine() then
                Error(CantChangeOrderTypeCauseSalesLineErr, Rec.FieldCaption("Location Code"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnAfterValidateLocationCodeSalesHeader(var Rec: Record "Sales Header")
    var
        Location: Record Location;
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin

            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (Rec."Location Code" <> '') then begin
                Location.Get(Rec."Location Code");
                Rec.Validate("Outbound Whse. Handling Time", Location."MICA Outb Whse Hand T Exp Ord");
            end;
            if (Rec."Sell-to Customer No." <> '') and (Rec."Location Code" <> '') then
                CalculateRequestedDeliveryDateSalesHeader(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to Code', false, false)]
    local procedure OnBeforeValidateShipToCodeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if not Rec.CheckThereIsNoLine() then
                Error(CantChangeOrderTypeCauseSalesLineErr, Rec.FieldCaption("Ship-to Code"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Ship-to Code', false, false)]
    local procedure OnAfterValidateShipToCodeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        ShiptoAddress: Record "Ship-to Address";
        Customer: Record Customer;
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") then begin
                Rec.CanBeAnExpressOrder();
                if ShiptoAddress.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code") then begin
                    Rec.Validate("Shipping Agent Code", ShiptoAddress."MICA Ship. Agent Exp. Order");
                    Rec.Validate("Shipping Agent Service Code", ShiptoAddress."MICA Ship Agent Serv Exp Order");
                end else begin
                    Customer.Get(Rec."Sell-to Customer No.");
                    Rec.Validate("Shipping Agent Code", Customer."MICA Shipping Agent Exp. Order");
                    Rec.Validate("Shipping Agent Service Code", Customer."MICA Ship Agent Serv Exp Order");
                end;
            end;
        if (Rec."Ship-to Code" <> xRec."Ship-to Code") and (Rec."Location Code" <> '') and (Rec."Sell-to Customer No." <> '') then
            CalculateRequestedDeliveryDateSalesHeader(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterValidateEvent', 'Requested Delivery Date', false, false)]
    local procedure OnAfterValidateRequestedDeliveryDateSalesOrder(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        RequestedDeliveryDate: Date;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
        CutOff: Boolean;
    begin
        if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (Rec."Requested Delivery Date" <> xRec."Requested Delivery Date") then
            Error(CanNotModifyRequestedDeliveryDateManuallyExpressOrderErr);
        GetBasCalendars(Rec, LocationBaseCalendar, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff, Rec."Location Code");
        RequestedDeliveryDate := CalculateRequestedDeliveryDate(WorkDate(), Rec."Outbound Whse. Handling Time", LocationBaseCalendar, Rec."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff);
        if Rec."Requested Delivery Date" < RequestedDeliveryDate then
            Error(DoesNotMatchErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Requested Delivery Date', false, false)]
    local procedure OnAfterValidateRequestedDeliveryDateSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")

    begin
        if Rec.GetCountOftSalesLineSplitted() > 0 then
            Error(CanNotModifyRequestedDeliveryDateLineCommittedErr);
        if rec."Requested Delivery Date" <> 0D then
            CalculateShippingDateSalesHeader(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Outbound Whse. Handling Time', false, false)]
    local procedure OnBeforeValidateOutboundWhseHandlingTimeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if not Rec.CheckThereIsNoLine() then
                Error(CantChangeOrderTypeCauseSalesLineErr, Rec.FieldCaption("Outbound Whse. Handling Time"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Outbound Whse. Handling Time', false, false)]
    local procedure OnAfterValidateOutboundWhseHandlingTimeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if (Rec."Outbound Whse. Handling Time" <> xRec."Outbound Whse. Handling Time") and (Rec."Location Code" <> '') and (Rec."Sell-to Customer No." <> '') then
                CalculateRequestedDeliveryDateSalesHeader(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Shipping Time', false, false)]
    local procedure OnBeforeValidateShippingTimeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if not Rec.CheckThereIsNoLine() then
                Error(CantChangeOrderTypeCauseSalesLineErr, Rec.FieldCaption("Shipping Time"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Shipping Time', false, false)]
    local procedure OnAfterValidateShippingTimeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if (Rec."Shipping Time" <> xRec."Shipping Time") and (Rec."Location Code" <> '') and (Rec."Sell-to Customer No." <> '') then
                CalculateRequestedDeliveryDateSalesHeader(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Shipping Agent Service Code', false, false)]
    local procedure OnBeforeValidateShippingAgentServiceCodeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if not Rec.CheckThereIsNoLine() then
                Error(CantChangeOrderTypeCauseSalesLineErr, Rec.FieldCaption("Shipping Agent Service Code"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Shipping Agent Service Code', false, false)]
    local procedure OnAfterValidateShippingAgentServiceCodeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if (Rec."Shipping Agent Service Code" <> xRec."Shipping Agent Service Code") and (Rec."Location Code" <> '') and (Rec."Sell-to Customer No." <> '') then
                CalculateRequestedDeliveryDateSalesHeader(Rec);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Shipping Agent Code', false, false)]
    local procedure OnBeforeValidateShippingAgentCodeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if not Rec.CheckThereIsNoLine() then
                Error(CantChangeOrderTypeCauseSalesLineErr, Rec.FieldCaption("Shipping Agent Code"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Shipping Agent Code', false, false)]
    local procedure OnAfterValidateShippingAgentCodeSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if (Rec."Shipping Agent Code" <> xRec."Shipping Agent Code") and (Rec."Location Code" <> '') and (Rec."Sell-to Customer No." <> '') then
                CalculateRequestedDeliveryDateSalesHeader(Rec);
    end;

    procedure CalculateRequestedDeliveryDate(StartDate: Date; LocationOutboundWhseHandling: DateFormula; LocationBaseCalendar: Code[10]; ShippingAgentShippingTime: DateFormula; ShippingAgentBaseCalendar: Code[10]; ShipToBaseCalendar: Code[10]; CutOff: Boolean): Date
    var
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        MyDateFormula: DateFormula;
        DateWork: Date;
    begin
        DateWork := StartDate;
        Evaluate(MyDateFormula, '<1D>');
        if CutOff then
            DateWork := CalcDate('<+1D>', DateWork);
        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::Location, '', '', LocationBaseCalendar);
        if CalendarManagement.IsNonworkingDay(DateWork, CustomizedCalendarChange) then
            DateWork := CalculDateBOCPositive(DateWork, MyDateFormula, LocationBaseCalendar);
        DateWork := CalculDateBOCPositive(DateWork, LocationOutboundWhseHandling, LocationBaseCalendar);
        //ShippingDate := DateWork;
        DateWork := CalculDateBOCPositive(DateWork, ShippingAgentShippingTime, ShippingAgentBaseCalendar);
        //PlannedShipmentDate := DateWork;
        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::"Shipping Agent", '', '', ShipToBaseCalendar);
        while CalendarManagement.IsNonworkingDay(DateWork, CustomizedCalendarChange) do
            DateWork := CalcDate('<+1D>', DateWork);
        exit(DateWork);

    end;

    procedure CalculateDateLineOnHand(RequestedDeliveryDate: Date; LocationOutboundWhseHandling: DateFormula; LocationBaseCalendar: Code[10]; ShippingAgentShippingTime: DateFormula; ShippingAgentBaseCalendar: Code[10]; ShipToBaseCalendar: Code[10]; var ShippingDate: Date; var PlannedShipmentDate: Date; var PlannedDeliveryDate: Date)
    var
        DateWork: Date;
    begin
        DateWork := RequestedDeliveryDate;
        PlannedDeliveryDate := DateWork;

        DateWork := CalculDateBOCNegative(DateWork, ShippingAgentShippingTime, ShippingAgentBaseCalendar);
        PlannedShipmentDate := DateWork;

        DateWork := CalculDateBOCNegative(DateWork, LocationOutboundWhseHandling, LocationBaseCalendar);
        ShippingDate := DateWork;

    end;

    procedure CalculateDateLineTransit(ShippingDate: Date; LocationOutboundWhseHandling: DateFormula; LocationBaseCalendar: Code[10]; ShippingAgentShippingTime: DateFormula; ShippingAgentBaseCalendar: Code[10]; ShipToBaseCalendar: Code[10]; var NewShippingDate: Date; var PlannedShipmentDate: Date; var PlannedDeliveryDate: Date)
    var
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        DateWork: Date;
    begin
        DateWork := ShippingDate;
        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::"Shipping Agent", '', '', LocationBaseCalendar);
        while CalendarManagement.IsNonworkingDay(DateWork, CustomizedCalendarChange) do
            DateWork := CalcDate('<+1D>', DateWork);

        DateWork := CalculDateBOCPositive(DateWork, LocationOutboundWhseHandling, LocationBaseCalendar);
        PlannedShipmentDate := DateWork;
        DateWork := CalculDateBOCPositive(DateWork, ShippingAgentShippingTime, ShippingAgentBaseCalendar);
        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::"Shipping Agent", '', '', ShipToBaseCalendar);
        while CalendarManagement.IsNonworkingDay(DateWork, CustomizedCalendarChange) do
            DateWork := CalcDate('<+1D>', DateWork);
        PlannedDeliveryDate := DateWork;

        DateWork := CalculDateBOCNegative(DateWork, ShippingAgentShippingTime, ShippingAgentBaseCalendar);
        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::"Shipping Agent", '', '', LocationBaseCalendar);
        while CalendarManagement.IsNonworkingDay(DateWork, CustomizedCalendarChange) do
            DateWork := CalcDate('<-1D>', DateWork);
        PlannedShipmentDate := DateWork;
        DateWork := CalculDateBOCNegative(DateWork, LocationOutboundWhseHandling, LocationBaseCalendar);
        NewShippingDate := DateWork;

    end;

    local procedure CalculDateBOCPositive(DateWork: Date; Formula: DateFormula; BaseCalendar: Code[10]): Date
    var
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        DateCalc: Date;
    begin
        DateCalc := CalcDate('<+1D>', DateWork);
        if Format(Formula) <> '' then
            DateWork := CalcDate('+' + Format(Formula), DateWork);
        while DateCalc <= DateWork do begin
            if BaseCalendar <> '' then begin
                CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::"Shipping Agent", '', '', BaseCalendar);
                if CalendarManagement.IsNonworkingDay(DateCalc, CustomizedCalendarChange) then
                    DateWork := CalcDate('<+1D>', DateWork);
            end;
            DateCalc := CalcDate('<+1D>', DateCalc);
        end;
        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::"Shipping Agent", '', '', BaseCalendar);
        while CalendarManagement.IsNonworkingDay(DateWork, CustomizedCalendarChange) do
            DateWork := CalcDate('<+1D>', DateWork);
        exit(DateWork);
    end;

    local procedure CalculDateBOCNegative(DateWork: Date; Formula: DateFormula; BaseCalendar: Code[10]): Date
    var
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        DateCalc: Date;
    begin
        DateCalc := CalcDate('<-1D>', DateWork);
        if Format(Formula) <> '' then
            DateWork := CalcDate('-' + Format(Formula), DateWork);
        while DateCalc >= DateWork do begin
            if BaseCalendar <> '' then begin
                CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::"Shipping Agent", '', '', BaseCalendar);
                if CalendarManagement.IsNonworkingDay(DateCalc, CustomizedCalendarChange) then
                    DateWork := CalcDate('<-1D>', DateWork);
            end;
            DateCalc := CalcDate('<-1D>', DateCalc);
        end;
        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::"Shipping Agent", '', '', BaseCalendar);
        while CalendarManagement.IsNonworkingDay(DateWork, CustomizedCalendarChange) do
            DateWork := CalcDate('<-1D>', DateWork);
        exit(DateWork);
    end;

    procedure CalculateRequestedDeliveryDateSalesHeader(var SalesHeader: Record "Sales Header")
    var
        RequestedDeliveryDate: Date;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
        CutOff: Boolean;
    begin
        GetBasCalendars(SalesHeader, LocationBaseCalendar, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff, SalesHeader."Location Code");
        RequestedDeliveryDate := CalculateRequestedDeliveryDate(WorkDate(), SalesHeader."Outbound Whse. Handling Time", LocationBaseCalendar, SalesHeader."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff);
        SalesHeader.Validate("Requested Delivery Date", RequestedDeliveryDate);
    end;

    local procedure CalculateShippingDateSalesHeader(SalesHeader: Record "Sales Header")
    var
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        SanaContext: Codeunit "SC - Execution Context";
        ShipmentDate: Date;
        PlannedShipmentDate: Date;
        PlannedDeliveryDate: Date;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
        CutOff: Boolean;
    begin
        GetBasCalendars(SalesHeader, LocationBaseCalendar, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff, SalesHeader."Location Code");
        CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::"Shipping Agent", '', '', ShipToBaseCalendar);
        if CalendarManagement.IsNonworkingDay(SalesHeader."Requested Delivery Date", CustomizedCalendarChange) and (IsNullGuid(SalesHeader."SC Unique Webshop Document Id")) then
            Error(RequestedDeliveryDateImpossibleErr, SalesHeader."Requested Delivery Date", ShipToBaseCalendar);
        CalculateDateLineOnHand(SalesHeader."Requested Delivery Date", SalesHeader."Outbound Whse. Handling Time", LocationBaseCalendar, SalesHeader."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, ShipmentDate, PlannedShipmentDate, PlannedDeliveryDate);
        if (ShipmentDate < WorkDate()) and (SanaContext.GetCurrentOperationName() <> 'SaveOrder') then
            Error(DoesNotMatchErr);
    end;

    procedure GetBasCalendars(SalesHeader: Record "Sales Header"; var LocationBaseCalendar: Code[10]; var ShippingAgentBaseCalendar: Code[10]; var ShipToBaseCalendar: Code[10]; var CutOff: Boolean; LocationCode: Code[20])
    var
        Customer: Record Customer;
        ShippingAgentServices: Record "Shipping Agent Services";
        ShiptoAddress: Record "Ship-to Address";
        Location: Record Location;
    begin
        if LocationCode <> '' then
            Location.Get(LocationCode)
        else
            Location.Get(SalesHeader."Location Code");
        Customer.Get(SalesHeader."Sell-to Customer No.");
        if ShippingAgentServices.Get(SalesHeader."Shipping Agent Code", SalesHeader."Shipping Agent Service Code") then
            ShippingAgentBaseCalendar := ShippingAgentServices."Base Calendar Code"
        else
            ShippingAgentBaseCalendar := '';
        if SalesHeader."MICA Order Type" = SalesHeader."MICA Order Type"::"Standard Order" then begin
            if ShiptoAddress.Get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then
                ShipToBaseCalendar := ShiptoAddress."MICA Base Calendar Code"
            else
                ShipToBaseCalendar := Customer."Base Calendar Code";
            LocationBaseCalendar := Location."Base Calendar Code";
            if SalesHeader."MICA Customer Transport" then
                ShipToBaseCalendar := Location."MICA Pick-Up Calendar";

            CutOff := false;
            if (Time() > Location."MICA Regular Cut Off") and (Location."MICA Regular Cut Off" <> 0T) then
                CutOff := true;
        end else
            if SalesHeader."MICA Order Type" = SalesHeader."MICA Order Type"::"Express Order" then begin
                if ShiptoAddress.Get(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") then
                    ShipToBaseCalendar := ShiptoAddress."MICA Base Cal. Code Exp. Order"
                else
                    ShipToBaseCalendar := Customer."MICA Base Cal. Code Exp. Order";
                LocationBaseCalendar := Location."MICA Base Cal. Code Exp. Order";
                CutOff := false;
                if (Time() > Location."MICA Express Cut Off") and (Location."MICA Express Cut Off" <> 0T) then
                    CutOff := true;
            end;
    end;

    var
        DoesNotMatchErr: Label 'Date does not match Customer / Ship-to Address calendar” / “Customer / Ship-to address cannot be delivered because of lead time';
        RequestedDeliveryDateImpossibleErr: Label 'The Requested Delivery Date %1 is not a working day in the base calendar %2.';
        CanNotModifyRequestedDeliveryDateManuallyExpressOrderErr: Label 'It''s not possible to modify Requested Delivery Date manually when Order Type is Express';
        CanNotModifyRequestedDeliveryDateLineCommittedErr: Label 'It''s impossible to modify Requested Delivery Date if there is at least one line committed';
        CantChangeOrderTypeCauseSalesLineErr: Label 'It is not possible to change %1 if sales order lines exist';
}