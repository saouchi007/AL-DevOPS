pageextension 82811 "MICA Posted Transfer Receipts" extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("Posting Date")
        {
            field("MICA ASN No."; Rec."MICA ASN No.")
            {
                ApplicationArea = All;
            }
            field("MICA Container ID"; Rec."MICA Container ID")
            {
                ApplicationArea = All;
            }
            field("MICA Seal No."; Rec."MICA Seal No.")
            {
                ApplicationArea = All;
            }
            field("MICA Port of Arrival"; Rec."MICA Port of Arrival")
            {
                ApplicationArea = All;
            }
            field("MICA Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}