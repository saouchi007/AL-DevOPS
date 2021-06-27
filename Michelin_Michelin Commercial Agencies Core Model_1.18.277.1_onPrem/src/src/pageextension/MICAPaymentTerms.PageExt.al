pageextension 82020 "MICA Payment Terms" extends "Payment Terms"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA GIS Payment Term Code"; Rec."MICA GIS Payment Term Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}