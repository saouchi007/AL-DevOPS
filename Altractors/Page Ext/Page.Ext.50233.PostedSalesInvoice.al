/// <summary>
/// PageExtension ISA_PostedSalesInv_Ext (ID 50233) extends Record MyTargetPage.
/// </summary>
pageextension 50105 ISA_PostedSalesInv_Ext extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Currency Code")
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
            }
        }
    }


}