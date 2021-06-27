pageextension 80383 "MICA Sales Quote Arch. Subform" extends "Sales Quote Archive Subform"
{
    layout
    {
        modify("Cross-Reference No.")
        {
            ApplicationArea = All;
            Visible = true;
        }

        addlast(Control1)
        {
            field("MICA Courntermark"; Rec."MICA Countermark")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}