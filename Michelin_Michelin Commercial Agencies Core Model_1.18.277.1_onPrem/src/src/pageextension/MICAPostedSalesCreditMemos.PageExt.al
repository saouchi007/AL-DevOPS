pageextension 80783 "MICA Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Visible = false;
                Editable = false;
            }
            field("MICA Credit Memo Reason Code"; Rec."MICA Credit Memo Reason Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}