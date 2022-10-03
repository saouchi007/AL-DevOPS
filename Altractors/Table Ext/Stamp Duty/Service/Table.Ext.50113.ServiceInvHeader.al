/// <summary>
/// TableExtension ISA_ServiceInvHeader_Ext (ID 50113) extends Record Service Invoice Header.
/// </summary>
tableextension 50113 ISA_ServiceInvHeader_Ext extends "Service Invoice Header"
{
    fields
    {
        field(50111; ISA_StampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Stamp Duty', FRA = 'Droit de timbre';
            Editable = false;
        }
        field(50112; ISA_AmountIncludingStampDuty; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Amount Including Stamp Duty', FRA = 'Montant incluant droit de timbre';
            Editable = false;
        }
    }
}