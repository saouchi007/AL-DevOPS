/// <summary>
/// TableExtension ISA_SalesLine_Ext (ID 50102) extends Record Sales Line.
/// </summary>
tableextension 50115 ISA_SalesLine_Ext extends "Sales Line"
{
    fields
    {
        field(50100; ISA_StampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty';
            Editable = false;
        }
        field(50101; ISA_AmountIncludingStampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Amount Including Stamp Duty', FRA = 'Montant incluant droit de timbre';
            Editable = false;
        }
    }

}