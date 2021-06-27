pageextension 82810 "MICA Posted Purchase Receipts" extends "Posted Purchase Receipts"
{
    layout
    {

        addafter("Buy-from Vendor Name")
        {
            field("MICA Container ID"; Rec."MICA Container ID")
            {
                ApplicationArea = All;
            }
            field("MICA Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
            field("MICA Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
            field("MICA ASN No."; Rec."MICA ASN No.")
            {
                ApplicationArea = All;
            }
            field("MICA Port of Arrival"; Rec."MICA Port of Arrival")
            {
                ApplicationArea = All;
            }
            field("MICA Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = All;
            }
            field("MICA Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = All;
            }
        }
    }
}