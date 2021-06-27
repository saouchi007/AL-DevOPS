pageextension 81123 "MICA Posted Return Receipt" extends "Posted Return Receipt" //MyTargetPageId
{
    layout
    {
        addlast(General)
        {
            field("MICA Return Order With Collect"; Rec."MICA Return Order With Collect")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("MICA Retrieve-From Address Code"; Rec."MICA Retrieve-From Addr. Code")
            {
                ApplicationArea = All;
            }
            field("MICA Retrieve-From Address"; Rec."MICA Retrieve-From Address")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}