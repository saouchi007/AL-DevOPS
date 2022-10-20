/// <summary>
/// PageExtension ISA_SalesQuoteList_Ext (ID 50117) extends Record Sales Quotes.
/// </summary>
pageextension 50117 ISA_SalesQuoteList_Ext extends "Sales Quotes"
{
    layout
    {
        addafter(Amount)
        {
            field(ISA_AmountIncludingStampDuty; Rec.ISA_AmountIncludingStampDuty)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTipML = ENU = 'Specifies the amount that includes VAT and Stamp duty', FRA = 'Spécifie le montant incluant la TVA et ledroit de timbre';
                CaptionML = ENU = 'Amount Including S.Duty', FRA = 'Montant includant D.Timbre';
            }
        }
    }
}