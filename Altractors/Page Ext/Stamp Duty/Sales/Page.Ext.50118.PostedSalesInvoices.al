/// <summary>
/// PageExtension ISA_PostedSalesInvoice_Ext (ID 50121) extends Record Posted Sales Invoices.
/// </summary>
pageextension 50121 ISA_PostedSalesInvoice_Ext extends "Posted Sales Invoices"
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