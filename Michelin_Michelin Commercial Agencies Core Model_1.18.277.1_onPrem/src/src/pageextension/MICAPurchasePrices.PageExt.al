pageextension 80940 "MICA Purchase Prices" extends "Purchase Prices" //MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
            {
                ApplicationArea = All;
            }
            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                ApplicationArea = All;
            }
        }
        Addlast(FactBoxes)
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

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}
