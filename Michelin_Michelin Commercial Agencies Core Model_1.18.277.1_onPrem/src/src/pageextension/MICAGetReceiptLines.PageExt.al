pageextension 81700 "MICA Get Receipt Lines" extends "Get Receipt Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("MICA Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Purchase Order No.';
            }

        }

    }

    actions
    {
    }


}