pageextension 81822 "MICA Sales Order Archives" extends "Sales Order Archives"
{
    layout
    {
        addafter("External Document No.")
        {
            field("MICA Unique Webshop Doc. Id"; Rec."MICA Unique Webshop Doc. Id")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("MICA Order type"; Rec."MICA Order Type")
            {
                ApplicationArea = All;
            }
        }
    }
}
