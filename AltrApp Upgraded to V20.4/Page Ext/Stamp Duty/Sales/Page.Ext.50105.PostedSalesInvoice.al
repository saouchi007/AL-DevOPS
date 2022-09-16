/// <summary>
/// PageExtension ISA_PostedSalesInv_Ext (ID 50233) extends Record MyTargetPage.
/// </summary>
pageextension 50105 ISA_SalesInvoiceStats_Ext extends "Sales Invoice Statistics"
{
    layout
    {
        addafter(AmountInclVAT)
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
            }
        }
    }


}