pageextension 81100 "MICA Warehouse Shipment" extends "Warehouse Shipment"
{
    layout
    {

        addlast(Shipping)
        {
            field("MICA Ship to Address"; Rec."MICA Ship-to Address")
            {
                Caption = 'Address';
                ApplicationArea = ALL;
                Editable = false;
            }
            field("MICA Ship to City"; Rec."MICA Ship to City")
            {
                Caption = 'City';
                ApplicationArea = ALL;
                Editable = false;
            }
            field("MICA Ship to code"; Rec."MICA Ship to code")
            {
                Caption = 'Code';
                ApplicationArea = ALL;
                Editable = false;
            }
            field("MICA Ship to Name"; Rec."MICA Ship to Name")
            {
                Caption = 'Name';
                ApplicationArea = ALL;
                Editable = false;
            }
            field("MICA Shipping Advice"; Rec."MICA Shipping Advice")
            {
                ApplicationArea = All;
            }

        }

        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Customer Transport"; Rec."MICA Customer Transport")
                {
                    ApplicationArea = ALL;
                    Enabled = MICACustTransEnabled;
                }
                field("MICA 3PL Update Status"; Rec."MICA 3PL Update Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Shipment Date in SO"; Rec."MICA Shipment Date in SO")
                {
                    ApplicationArea = All;
                }
                field("MICA Planed Shipm. Date in SO"; Rec."MICA Planed Shipm. Date in SO")
                {
                    ApplicationArea = All;
                }
                field("MICA Planned Deliv. Date in SO"; Rec."MICA Planned Deliv. Date in SO")
                {
                    ApplicationArea = All;
                }
                field("MICA Truck Driver Info"; Rec."MICA Truck Driver Info")
                {
                    ApplicationArea = All;
                    Editable = Rec.Status = Rec.Status::Open;
                }
                field("MICA Truck License Plate"; Rec."MICA Truck License Plate")
                {
                    ApplicationArea = All;
                    Editable = Rec.Status = Rec.Status::Open;
                }
            }
            group("MICA Flow Integration")
            {
                Caption = 'Flow Integration';
                group("MICA Receive")
                {
                    field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
                    {
                        ApplicationArea = All;
                    }
                }

                group("MICA Send")
                {
                    field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                    {
                        ApplicationArea = All;
                    }
                    field("MICA Send Ack. Received"; Rec."MICA Send Ack. Received")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        addlast(FactBoxes)
        {
            part(FlowIntegration; "MICA FlowInt-Whs.Shipment Line")
            {
                Provider = WhseShptLines;
                ApplicationArea = All;
                SubPageLink = "No." = field("No."), "Line No." = field("Line No.");
            }
            part(FlowResult; "MICA Flow Result")
            {
                caption = 'Flow Integration (Header)';
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }

    }

    var
        MICACustTransEnabled: Boolean;

    trigger OnAfterGetRecord()
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        SalesHeader: Record "Sales Header";
    begin
        MICACustTransEnabled := false;
        WarehouseShipmentLine.Reset();
        WarehouseShipmentLine.SetRange("No.", Rec."No.");
        WarehouseShipmentLine.SetRange("Source Document", WarehouseShipmentLine."Source Document"::"Sales Order");
        iF WarehouseShipmentLine.FINDSET(false) then begin
            SalesHeader.Reset();
            repeat
                SalesHeader.SetRange("No.", WarehouseShipmentLine."Source No.");
                SalesHeader.SetRange("MICA Order Type", SalesHeader."MICA Order Type"::"Express Order");
                IF not SalesHeader.IsEmpty() then
                    MICACustTransEnabled := true;
            until WarehouseShipmentLine.Next() = 0;
        END;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;

}