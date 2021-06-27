codeunit 80780 "MICA Automatic Mail Inv. PDF"
{
    trigger OnRun();
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        WorkSalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        WorkSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        InvMICAEmailPDFMethod: Codeunit "MICA Email PDF Method";
    begin

        //SalesInvoiceHeader.SetRange("Posting Date", WorkDate());
        SalesInvoiceHeader.SetRange("MICA Email Status", SalesInvoiceHeader."MICA Email Status"::" ", SalesInvoiceHeader."MICA Email Status"::Failure);
        if SalesInvoiceHeader.FindSet() then
            repeat
                WorkSalesInvoiceHeader.Get(SalesInvoiceHeader."No.");
                WorkSalesInvoiceHeader.SetRange("No.", SalesInvoiceHeader."No.");
                if InvMICAEmailPDFMethod.EmailInvoiceAsPDF(WorkSalesInvoiceHeader) then begin
                    WorkSalesInvoiceHeader.Get(SalesInvoiceHeader."No.");
                    WorkSalesInvoiceHeader.Validate("MICA Email Status", WorkSalesInvoiceHeader."MICA Email Status"::Successful);
                end else begin
                    WorkSalesInvoiceHeader.Get(SalesInvoiceHeader."No.");
                    WorkSalesInvoiceHeader.Validate("MICA Email Status", WorkSalesInvoiceHeader."MICA Email Status"::Failure);
                end;
                WorkSalesInvoiceHeader.Modify();
            until SalesInvoiceHeader.Next() = 0;
        //SalesCreditMemos.SetRange("Posting Date", WorkDate());
        SalesCrMemoHeader.SetRange("MICA Email Status", SalesInvoiceHeader."MICA Email Status"::" ", SalesInvoiceHeader."MICA Email Status"::Failure);
        if SalesCrMemoHeader.FindSet() then
            repeat
                WorkSalesCrMemoHeader.Get(SalesCrMemoHeader."No.");
                WorkSalesCrMemoHeader.SetRange("No.", WorkSalesCrMemoHeader."No.");
                if InvMICAEmailPDFMethod.EmailSalesCreditMemosAsPDF(WorkSalesCrMemoHeader) then begin
                    WorkSalesCrMemoHeader.Get(WorkSalesCrMemoHeader."No.");
                    SalesCrMemoHeader.Validate("MICA Email Status", SalesCrMemoHeader."MICA Email Status"::Successful);
                end else begin
                    WorkSalesCrMemoHeader.Get(WorkSalesCrMemoHeader."No.");
                    SalesCrMemoHeader.Validate("MICA Email Status", SalesCrMemoHeader."MICA Email Status"::Failure);
                end;
                WorkSalesCrMemoHeader.Modify();
            until SalesCrMemoHeader.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoice", 'OnAfterActionEvent', 'Email', false, false)]
    local procedure OnAfterActionEmailPostedSalesInvoicePage(var Rec: Record "Sales Invoice Header")
    begin
        if Rec."MICA Email Status" <> Rec."MICA Email Status"::Successful then
            if Confirm(UpdateEmailStatusToSuccessfulQst) then
                Rec.Validate("MICA Email Status", Rec."MICA Email Status"::Successful)
            else
                Rec.Validate("MICA Email Status", Rec."MICA Email Status"::Failure);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoices", 'OnAfterActionEvent', 'Email', false, false)]
    local procedure OnAfterActionEmailPostedSalesInvoicesPage(var Rec: Record "Sales Invoice Header")
    begin
        if Rec."MICA Email Status" <> Rec."MICA Email Status"::Successful then
            if Confirm(UpdateEmailStatusToSuccessfulQst) then
                Rec.Validate("MICA Email Status", Rec."MICA Email Status"::Successful)
            else
                Rec.Validate("MICA Email Status", Rec."MICA Email Status"::Failure);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Credit Memo", 'OnAfterActionEvent', 'Send by &Email', false, false)]
    local procedure OnAfterActionSendByEmailPostedSalesCreditMemoPage(var Rec: Record "Sales Cr.Memo Header")
    begin
        if Rec."MICA Email Status" <> Rec."MICA Email Status"::Successful then
            if Confirm(UpdateEmailStatusToSuccessfulQst) then
                Rec.Validate("MICA Email Status", Rec."MICA Email Status"::Successful)
            else
                Rec.Validate("MICA Email Status", Rec."MICA Email Status"::Failure);
    end;

    var
        UpdateEmailStatusToSuccessfulQst: Label 'Do you want to update the Email Status to Successful?';
}