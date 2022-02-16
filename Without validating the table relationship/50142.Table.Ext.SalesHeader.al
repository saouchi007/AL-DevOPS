/// <summary>
/// TableExtension SalesHeader_Ext (ID 50142) extends Record Sales Header.
/// </summary>
tableextension 50142 SalesHeader_Ext extends "Sales Header"
{
    fields
    {
        field(50142; "End User Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'End User Name';
            TableRelation = Customer."No.";
            ValidateTableRelation = true;
        }
    }


}