/// <summary>
/// TableExtension ISA_SalesReceivables (ID 50183) extends Record Sales  Receivables Setup.
/// </summary>
tableextension 50183 ISA_SalesReceivables extends "Sales & Receivables Setup"
{
    fields
    {
        field(50183; "Book Nos."; Code[20])
        {
            Caption = 'Book Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }

}