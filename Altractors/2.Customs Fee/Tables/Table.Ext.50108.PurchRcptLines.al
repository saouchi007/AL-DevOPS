/// <summary>
/// TableExtension ISA_PurchaseRcptLines_Ext (ID 50108) extends Record Purch. Rcpt. Line.
/// </summary>
tableextension 50108 ISA_PurchaseRcptLines_Ext extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50107; ISA_CustomsFees; Decimal)
        {
            Caption = 'Customs Fees';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
    }
}