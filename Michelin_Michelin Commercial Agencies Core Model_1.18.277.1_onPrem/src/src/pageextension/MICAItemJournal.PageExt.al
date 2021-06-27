pageextension 82200 "MICA Item Journal" extends "Item Journal"
{
    layout
    {
        addafter("Bin Code")
        {
            field("MICA Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }

    }
}