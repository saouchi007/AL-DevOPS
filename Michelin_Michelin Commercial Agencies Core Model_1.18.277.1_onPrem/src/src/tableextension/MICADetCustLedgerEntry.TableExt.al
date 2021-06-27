tableextension 82740 "MICA Det. Cust. Ledger Entry" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(82740; "MICA Initial Due Date (Buffer)"; Date)
        {
            Caption = 'Initial Due Date (Buffer)';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

}