pageextension 81301 "MICA Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA AL Line No."; Rec."MICA AL Line No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA SRD"; Rec."MICA SRD")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("MICA Location-To Code"; Rec."MICA Location-To Code")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("MICA ASN No."; Rec."MICA ASN No.")
            {
                ApplicationArea = All;
            }
            field("MICA ASN Line No."; Rec."MICA ASN Line No.")
            {
                ApplicationArea = All;
            }
            field("MICA Country of Origin"; Rec."MICA Country of Origin")
            {
                ApplicationArea = All;
            }
            field("MICA DC14"; Rec."MICA DC14")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}