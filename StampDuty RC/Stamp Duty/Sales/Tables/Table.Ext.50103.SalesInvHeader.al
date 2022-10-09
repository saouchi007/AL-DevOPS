/// <summary>
/// TableExtension ISA_SalesInvHeader_Ext (ID 50233) extends Record Sales Invoice Header.
/// </summary>
tableextension 50103 ISA_SalesInvHeader_Ext extends "Sales Invoice Header"
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