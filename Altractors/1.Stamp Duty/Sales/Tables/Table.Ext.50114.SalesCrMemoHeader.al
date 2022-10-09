/// <summary>
/// TableExtension ISA_SalesCreditMemo_Ext (ID 50114) extends Record Sales Cr.Memo Header.
/// </summary>
tableextension 50114 ISA_SalesCreditMemo_Ext extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50230; ISA_StampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty';
            Editable = false;
        }
    }
}