/// <summary>
/// PageExtension ISA_SalesOrderList_Ext (ID 50101) extends Record Sales Order List.
/// </summary>
pageextension 50120 ISA_SalesOrderList_Ext extends "Sales Order List"
{
    layout
    {
        addafter("Amount Including VAT")
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