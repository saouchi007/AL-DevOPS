pageextension 82740 "MICA Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Due Date")
        {
            field("MICA Due Date (Buffer)"; Rec."MICA Due Date (Buffer)")
            {
                ApplicationArea = All;
            }

        }
    }

}