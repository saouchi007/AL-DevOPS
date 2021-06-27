pageextension 81121 "MICA Sales Return Order Arch" extends "Sales Return Order Archive" //MyTargetPageId
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
        }
    }

    actions
    {
    }
}