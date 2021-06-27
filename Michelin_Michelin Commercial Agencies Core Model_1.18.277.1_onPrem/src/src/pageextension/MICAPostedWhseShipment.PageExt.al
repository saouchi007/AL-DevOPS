pageextension 81061 "MICA Posted Whse. Shipment" extends "Posted Whse. Shipment"
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
        }

        addlast(General)
        {
            field("MICA Customer Transport"; Rec."MICA Customer Transport")
            {
                ApplicationArea = ALL;
                Editable = false;
            }
            field("MICA 3PL Update Status"; Rec."MICA 3PL Update Status")
            {
                ApplicationArea = All;
            }
            field("MICA Truck Driver Info"; Rec."MICA Truck Driver Info")
            {
                ApplicationArea = All;
            }
            field("MICA Truck License Plate"; Rec."MICA Truck License Plate")
            {
                ApplicationArea = All;
            }
            group("MICA HeaderFlowIntegration")
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
            part(FlowIntegration; "MICA FlowInt-Pst.Whs.Ship Line")
            {
                Provider = WhseShptLines;
                ApplicationArea = All;
                SubPageLink = "No." = field("No."), "Line No." = field("Line No.");
            }
            part(FlowResult; "MICA Flow Result")
            {
                caption = 'Flow Result (Header)';
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}