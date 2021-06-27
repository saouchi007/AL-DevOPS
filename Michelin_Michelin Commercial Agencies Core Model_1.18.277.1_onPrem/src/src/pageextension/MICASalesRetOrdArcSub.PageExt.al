pageextension 82144 "MICA Sales Ret. Ord. Arc Sub" extends "Sales Return Order Arc Subform"
{
    layout
    {
        addafter(Description)
        {
            field("MICA Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }

}