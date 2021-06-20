pageextension 50101 GLEntriesSourceName extends "General Ledger Entries"
{
    layout
    {
        addafter("Document Type")
        {
            field(CustomerName; Rec.CustomerName)
            {
                ApplicationArea = all;
            }
            field(VendorName; Rec.VendorName)
            {
                ApplicationArea = all;
            }
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = all;
            }
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = all;
            }
        }
    }
}
