page 80239 "MICA Test Page For Next Truck"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Test Page For Next Truck';
    SourceTable = "MICA TableForSana";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(GroupName1)
            {
                Caption = 'Setup';
                field(LocationOutboundWhseHandling; LocationOutboundWhseHandlingValue)
                {
                    ApplicationArea = All;
                    Caption = 'Location Outbound Whse Handling';
                }

                field(LocationBaseCalendar; LocationBaseCalendarValue)
                {
                    ApplicationArea = All;
                    Caption = 'Location Base Calendar';
                    TableRelation = "Base Calendar";
                }

                field(ShippingAgentShippingTime; ShippingAgentShippingTimeValue)
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Agent Shipping Time';
                }

                field(ShippingAgentBaseCalendar; ShippingAgentBaseCalendarValue)
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Agent Base Calendar';
                    TableRelation = "Base Calendar";
                }

                field(ShipToBaseCalendar; ShipToBaseCalendarValue)
                {
                    ApplicationArea = All;
                    Caption = 'Ship-To/Customer Base Calendar';
                    TableRelation = "Base Calendar";
                }

                field(NextTrucksPeriod; NextTrucksPeriodValue)
                {
                    ApplicationArea = All;
                    Caption = 'SANA Next Trucks Period';
                }

            }
            group(SalesHeader)
            {
                Caption = 'Sales Header';

                Editable = false;
                field(DateSana; Rec."DateSana")
                {
                    ApplicationArea = All;
                }


            }
            group(SalesLineEX1)
            {
                Caption = 'Sales Line EX1';
                field(RequestedDeliveryDate1; RequestedDeliveryDate1Value)
                {
                    ApplicationArea = All;
                    Caption = 'Requested Delivery Date';
                    trigger OnValidate()
                    var
                        NextTruckManagement: Codeunit "MICA Next Truck Management";
                    begin
                        NextTruckManagement.CalculateDateLineOnHand(RequestedDeliveryDate1Value, LocationOutboundWhseHandlingValue, LocationBaseCalendarValue, ShippingAgentShippingTimeValue, ShippingAgentBaseCalendarValue, ShipToBaseCalendarValue, ShippingDateLine1Value, PlannedShipmentDateLine1Value, PlannedDeliveryDateLine1Value);
                    end;
                }

                field(ShippingDateLine1; ShippingDateLine1Value)
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Date';
                    Editable = false;
                }

                field(PlannedShipmentDateLine1; PlannedShipmentDateLine1Value)
                {
                    ApplicationArea = All;
                    Caption = 'Planned Shipment Date';
                    Editable = false;
                }

                field(PlannedDeliveryDateLine1; PlannedDeliveryDateLine1Value)
                {
                    ApplicationArea = All;
                    Caption = 'Planned Delivery Date';
                    Editable = false;
                }
            }
            group(SalesLineEX21)
            {
                Caption = 'Sales Line EX2.1';

                field(ShippingDateLine21; ShippingDateLine21Value)
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Date';
                    trigger OnValidate()
                    var
                        NextTruckManagement: Codeunit "MICA Next Truck Management";
                    begin
                        NextTruckManagement.CalculateDateLineTransit(ShippingDateLine21Value, LocationOutboundWhseHandlingValue, LocationBaseCalendarValue, ShippingAgentShippingTimeValue, ShippingAgentBaseCalendarValue, ShipToBaseCalendarValue, NewShippingDateLine21Value, PlannedShipmentDateLine21Value, PlannedDeliveryDateLine21Value);
                    end;
                }

                field(NewShippingDateLine21; NewShippingDateLine21Value)
                {
                    ApplicationArea = All;
                    Caption = 'New Shipping Date';
                    Editable = false;
                }

                field(PlannedShipmentDateLine21; PlannedShipmentDateLine21Value)
                {
                    ApplicationArea = All;
                    Caption = 'Planned Shipment Date';
                    Editable = false;
                }

                field(PlannedDeliveryDateLine21; PlannedDeliveryDateLine21Value)
                {
                    ApplicationArea = All;
                    Caption = 'Planned Delivery Date';
                    Editable = false;
                }

            }
            /*            group(SalesLineEX22)
                        {
                            Caption = 'Sales Line EX2.2';
                            
                                field(ShippingDateLine22; "ShippingDateLine22")
                                {
                                    ApplicationArea = All;
                                    Caption = 'Shipping Date';
                                    Editable = false;
                                }

                                field(PlannedShipmentDateLine22; "PlannedShipmentDateLine22")
                                {
                                    ApplicationArea = All;
                                    Caption = 'Planned Shipment Date';
                                    Editable = false;
                                }

                                field(PlannedDeliveryDateLine22; "PlannedDeliveryDateLine22")
                                {
                                    ApplicationArea = All;
                                    Caption = 'Planned Delivery Date';
                                    trigger OnValidate()
                                    var
                                        NextTruckManagement: Codeunit "MICA Next Truck Management";
                                    begin

                                    end;
                                }
                            
                        }*/
        }
    }

    actions
    {
        area(Processing)
        {
            action("Calculate Sales Header")
            {
                ApplicationArea = All;
                Image = "8ball";

                trigger OnAction()
                var
                    TempMICATableForSana: Record "MICA TableForSana" temporary;
                    NextTruckManagement: Codeunit "MICA Next Truck Management";
                    DateWork: Date;
                    FinishDate: Date;

                begin
                    Rec.DeleteAll();
                    DateWork := WorkDate();
                    FinishDate := CalcDate(NextTrucksPeriodValue, DateWork);
                    repeat
                        TempMICATableForSana.DateSana := NextTruckManagement.CalculateRequestedDeliveryDate(DateWork, LocationOutboundWhseHandlingValue, LocationBaseCalendarValue, ShippingAgentShippingTimeValue, ShippingAgentBaseCalendarValue, ShipToBaseCalendarValue, false);
                        if TempMICATableForSana.DateSana <= FinishDate then
                            if TempMICATableForSana.Insert() then;
                        DateWork := CalcDate('<+1D>', DateWork);
                    until DateWork > FinishDate;
                    if TempMICATableForSana.FindSet() then
                        repeat
                            Rec := TempMICATableForSana;
                            Rec.Insert();
                        until TempMICATableForSana.Next() = 0;
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        LocationOutboundWhseHandlingValue: DateFormula;
        ShippingAgentShippingTimeValue: DateFormula;
        NextTrucksPeriodValue: DateFormula;
        LocationBaseCalendarValue: Code[10];
        ShippingAgentBaseCalendarValue: Code[10];
        ShipToBaseCalendarValue: Code[10];
        ShippingDateLine1Value: Date;
        PlannedShipmentDateLine1Value: Date;
        PlannedDeliveryDateLine1Value: Date;
        RequestedDeliveryDate1Value: Date;
        ShippingDateLine21Value: Date;
        NewShippingDateLine21Value: Date;
        PlannedShipmentDateLine21Value: Date;
        PlannedDeliveryDateLine21Value: Date;
    //ShippingDateLine22: Date;
    //PlannedShipmentDateLine22: Date;
    //PlannedDeliveryDateLine22: Date;

}