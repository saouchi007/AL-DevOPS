pageextension 81551 "MICA Payment Methods" extends "Payment Methods" //MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Payment Type"; Rec."MICA Payment Type")
            {
                ApplicationArea = All;
            }
            field("MICA Payment Code"; Rec."MICA Payment Code")
            {
                ApplicationArea = All;
            }
            field("MICA Pmt. Method Filename"; Rec."MICA Pmt. Method Filename")
            {
                ApplicationArea = All;
            }
            field("MICA Payment Priority Code"; Rec."MICA Payment Priority Code")
            {
                ApplicationArea = all;
            }
        }
    }
}