pageextension 80781 "MICA Posted Sales Credit Memo" extends "Posted Sales Credit Memo" //MyTargetPageId
{
    layout
    {
        addlast(General)
        {
            field("MICA Email Status"; Rec."MICA Email Status")
            {
                ApplicationArea = All;
            }
            field("MICA Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = All;
            }
            field("MICA Credit Memo Reason Code"; Rec."MICA Credit Memo Reason Code")
            {
                ApplicationArea = All;
            }
            field("MICA Credit Memo Reason Desc."; Rec."MICA Credit Memo Reason Desc.")
            {
                ApplicationArea = All;
            }


        }
    }

    actions
    {
    }
}