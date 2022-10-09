/// <summary>
/// TableExtension ISA_SalesHeader_Ext (ID 50100) extends Record Sales Header.
/// </summary>
tableextension 50100 ISA_SalesHeader_Ext extends "Sales Header"
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