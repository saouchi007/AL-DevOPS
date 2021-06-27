pageextension 80780 "MICA Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("MICA Email Status"; Rec."MICA Email Status")
            {
                ApplicationArea = All;
            }
            field("MICA Sales Agreement No."; Rec."MICA Sales Agreement No.")
            {
                ApplicationArea = All;
            }
            field("MICA Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = All;
            }

        }
        addafter("Order No.")
        {
            field("MICA Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Work Description")
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