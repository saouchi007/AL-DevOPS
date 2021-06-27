pageextension 81940 "MICA Countries/Regions" extends "Countries/Regions" //MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Group Code"; Rec."MICA Group Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}