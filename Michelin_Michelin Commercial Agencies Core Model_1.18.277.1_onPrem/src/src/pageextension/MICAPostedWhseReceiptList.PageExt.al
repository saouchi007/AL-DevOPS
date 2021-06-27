pageextension 81210 "MICA Posted Whse. Receipt List" extends "Posted Whse. Receipt List"
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

            field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
            {
                Editable = false;
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
            {
                Editable = false;
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Send Ack. Received"; Rec."MICA Send Ack. Received")
            {
                Editable = false;
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                Editable = false;
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Record ID"; Rec."MICA Record ID")
            {
                ApplicationArea = All;
                Visible = false;
            }

        }
        addlast(FactBoxes)
        {
            part(FlowResult; "MICA Flow Result")
            {
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }
    }

    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}