pageextension 82741 "MICA Det. Cust. Ledg. Entries" extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Initial Entry Due Date")
        {
            field("MICA Initial Due Date (Buffer)"; Rec."MICA Initial Due Date (Buffer)")
            {
                ApplicationArea = All;
            }

        }
    }
}