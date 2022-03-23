/// <summary>
/// PageExtension ISA_SalesReceivables (ID 50183) extends Record Sales Receivables Setup.
/// </summary>
pageextension 50183 ISA_SalesReceivables extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Customer Nos.")
        {
            field("Book Nos."; Rec."Book Nos.")
            {
                ApplicationArea = All;
            }
        }
    }


}