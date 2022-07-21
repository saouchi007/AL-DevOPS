/// <summary>
/// TableExtension ISA_PurchaseLine_Ext (ID 50106) extends Record Purchase Line.
/// </summary>
tableextension 50106 ISA_PurchaseLine_Ext extends "Purchase Line"
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