#pragma implicitwith disable
pageextension 82921 "MICA Blank. Purch. Order SF" extends "Blanket Purchase Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA 3rd Party"; Rec."MICA 3rd Party")
            {
                ApplicationArea = All;
            }
            field("MICA Reserved Quantity"; Rec."Reserved Quantity")
            {
                ApplicationArea = All;
            }
        }
    }
}

#pragma implicitwith restore
