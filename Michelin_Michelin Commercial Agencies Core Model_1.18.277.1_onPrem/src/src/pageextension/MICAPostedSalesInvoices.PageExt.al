pageextension 81860 "MICA Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Due Date")
        {
            field("MICA Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("MICA Truck Driver Info"; Rec."MICA Truck Driver Info")
            {
                ApplicationArea = All;
            }
            field("MICA Truck License Plate"; Rec."MICA Truck License Plate")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}