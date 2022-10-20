/// <summary>
/// PageExtension ISA_PostedServiceInvoice_Ext (ID 50122).
/// </summary>
pageextension 50122 ISA_PostedServiceInvoice_Ext extends "Posted Service Invoices"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field(ISA_AmountIncludingStampDuty; Rec.ISA_AmountIncludingStampDuty)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTipML = ENU = 'Specifies the amount that includes VAT and Stamp duty', FRA = 'Spécifie le montant incluant la TVA et le droit de timbre';
                CaptionML = ENU = 'Amount Including S.Duty', FRA = 'Montant includant D.Timbre';
            }
        }
    }
}