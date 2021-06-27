pageextension 80960 "MICA Posted Whse. Ship Subform" extends "Posted Whse. Shipment Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA 3PL Whse Shpt. Comment"; Rec."MICA 3PL Whse Shpt. Comment")
            {
                ApplicationArea = All;
            }
            field("MICA 3PL Qty. To Ship"; Rec."MICA 3PL Qty. To Ship")
            {
                ApplicationArea = All;
            }
        }
    }

}