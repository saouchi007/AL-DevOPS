pageextension 80380 "MICA Posted SalesShpt. Subform" extends "Posted Sales Shpt. Subform"
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
            field("MICA 3PL Whse Shpt. Comment"; Rec."MICA 3PL Whse Shpt. Comment")
            {
                ApplicationArea = All;
            }
            field("MICA Transport Instruction"; Rec."MICA Transport Instruction")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}