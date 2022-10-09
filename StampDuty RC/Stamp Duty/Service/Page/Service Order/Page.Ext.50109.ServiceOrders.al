/// <summary>
/// PageExtension ISA_ServiceOrders_Ext (ID 50109) extends Record Service Orders.
/// </summary>
pageextension 50109 ISA_ServiceOrders_Ext extends "Service Orders"
{
    layout
    {
       addafter("Release Status")
        {
            field(ISA_AmountIncludingStampDuty;Rec.ISA_AmountIncludingStampDuty)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTipML = ENU = 'Specifies the amount that includes VAT and Stamp duty', FRA = 'Spécifie le montant incluant la TVA et le droit de timbre';
                CaptionML = ENU = 'Amount Including S.Duty', FRA = 'Montant includant D.Timbre';
            }
        }
    }
}