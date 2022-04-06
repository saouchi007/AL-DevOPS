/// <summary>
/// Unknown ISA_SalesInvoice_Ext (ID 50100) extends Record MyTargetReport.
/// </summary>
reportextension 50100 ISA_SalesInvoice_Ext extends "Standard Sales - Invoice"
{
    RDLCLayout = './StdrSalesInvoiceExtended.rdlc';
    dataset
    {
        add(Line)
        {
            column(Order_Line_No_Lbl; Line.FieldCaption("Order Line No."))
            { }
            column(Order_No_Line; Line."Order No.")
            { }
            column(DisplayOrderInfo; DisplayOrderInfo)
            { }
        }
    }

    requestpage
    {
        layout
        {
            addlast(Options)
            {
                field(DisplayOrderInfo; DisplayOrderInfo)
                {
                    Caption = 'Show order information';
                    ApplicationArea = All;
                    ToolTip = 'Specifies if you want Order Information to be shown on the document';
                }
            }
        }
    }
    var
        DisplayOrderInfo: Boolean;
}