/// <summary>
/// TableExtension ISA_ServiceHeader_Ext (ID 50105) extends Record Service Header.
/// </summary>
tableextension 50105 ISA_ServiceHeader_Ext extends "Service Header"
{
    fields
    {
        field(50101; ISA_StampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty', FRA = 'Droit de timbre';
            Editable = false;
        }
        field(50102; ISA_AmountIncludingStampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Amount Including Stamp Duty', FRA = 'Montant incluant droit de timbre';
            Editable = false;
        }
    }

}