pageextension 81151 "MICA Pstd Purch. Inv Lines" extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }
            field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;

            }
            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }

            field("MICA Record ID"; Rec."MICA Record ID")
            {
                Visible = false;
                ApplicationArea = All;
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
    trigger OnAfterGetRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}
