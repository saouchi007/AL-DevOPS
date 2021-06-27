pageextension 80041 "MICA Dimension Values" extends "Dimension Values" //MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Michelin Code"; Rec."MICA Michelin Code")
            {
                ApplicationArea = All;
            }
            /*field("MICA LB Michelin Code"; "MICA Michelin Code")
            {
                ApplicationArea = All;
            }*/

        }
    }

    actions
    {
    }
}