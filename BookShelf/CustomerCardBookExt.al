pageextension 50200 CustomerBookCardExtension extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Favorite Book No."; "Favorite Book No.")
            {
                ApplicationArea = All;
            }
        }
    }

}