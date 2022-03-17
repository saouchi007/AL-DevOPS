/// <summary>
/// PageExtension ISA_CustomersList (ID 50173) extends Record Customer List.
/// </summary>
pageextension 50173 ISA_PostedSalesInvoicesList extends "Posted Sales Invoices"
{


    actions
    {
        addlast(processing)
        {
            action(IsSame)
            {
                Caption = 'Is Same ?';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Calculate;

                trigger OnAction()
                var
                    SalesInvoiceHeaderRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SalesInvoiceHeaderRec);
                    if SalesInvoiceHeaderRec.FindSet() then
                        CheckDistinctCustomerNo(SalesInvoiceHeaderRec);
                end;
            }
        }
    }

    local procedure CheckDistinctCustomerNo(var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
    begin
        SalesInvoiceHeader.SetFilter("Sell-to Customer No.", '<>%1', SalesInvoiceHeader."Sell-to Customer No.");
        if not SalesInvoiceHeader.IsEmpty then
            Error(DistinctCustomerErr)
        else
            Message('OK');
        SalesInvoiceHeader.SetRange("Sell-to Customer No.");
    end;

    var
        DistinctCustomerErr: Label 'The customer must be same value on all lines you selected.';
}
