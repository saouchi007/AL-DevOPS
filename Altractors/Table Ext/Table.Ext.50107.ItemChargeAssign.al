/// <summary>
/// TableExtension ISA_ItemChargeAssign (ID 50107) extends Record Item Charge Assignment (Purch).
/// </summary>
tableextension 50107 ISA_ItemChargeAssign extends "Item Charge Assignment (Purch)"
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