pageextension 81800 "MICA Gen. Prod. Posting Groups" extends "Gen. Product Posting Groups"
{
    layout
    {
        addafter(Code)
        {
            field("MICA Product Type"; Rec."MICA Product Type")
            {
                ApplicationArea = All;
            }
        }
    }
}