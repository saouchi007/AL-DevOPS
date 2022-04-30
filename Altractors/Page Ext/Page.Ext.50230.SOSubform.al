/// <summary>
/// PageExtension ISA_SalesOrderSubform (ID 50230) extends Record Sales Order Subform.
/// </summary>
pageextension 50230 ISA_SalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        addafter(Control28)
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
                ToolTip = 'Processes 1% of amount including VAT';
            }
        }
    }


}