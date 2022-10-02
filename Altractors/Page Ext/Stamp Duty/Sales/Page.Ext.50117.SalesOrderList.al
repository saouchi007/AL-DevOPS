/// <summary>
/// PageExtension ISA_SalesOrderList_Ext (ID 50118) extends Record Sales Order List.
/// </summary>
pageextension 50118 ISA_SalesOrderList_Ext extends "Sales Order List"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field(ISA_AmountIncludingStampDuty; Rec.ISA_AmountIncludingStampDuty)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTipML = ENU = 'Processes 1% of amount including VAT', FRA = 'Calcule 1% du TTC';
                CaptionML = ENU = 'Amount Including SDuty', FRA = 'Montant includant DTimbre';
            }
        }
    }


}