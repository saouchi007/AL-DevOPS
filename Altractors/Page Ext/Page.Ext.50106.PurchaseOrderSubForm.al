/// <summary>
/// PageExtension ISA_PurchaseOrderSubForm_Ext (ID 50106) extends Record Purchase Order Subform.
/// </summary>
pageextension 50106 ISA_PurchaseOrderSubForm_Ext extends "Purchase Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field(ISA_CustomsFees; Rec.ISA_CustomsFees)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Customs Fees';
            }
        }
    }

}