pageextension 80961 "MICA Posted Whse.Shipment List" extends "Posted Whse. Shipment List"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA 3PL Update Status"; Rec."MICA 3PL Update Status")
            {
                ApplicationArea = All;
                Visible = false;
            }
            //Flow Integration
            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("MICA Send Ack. Received"; Rec."MICA Send Ack. Received")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Truck Driver Info"; Rec."MICA Truck Driver Info")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Truck License Plate"; Rec."MICA Truck License Plate")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addfirst(FactBoxes)
        {
            part(FlowResult; "MICA Flow Result")
            {
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