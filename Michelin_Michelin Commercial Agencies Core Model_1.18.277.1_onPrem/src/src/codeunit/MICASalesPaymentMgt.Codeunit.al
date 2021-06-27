codeunit 80240 "MICA Sales Payment Mgt."
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterSetFieldsBilltoCustomer', '', false, false)]
    local procedure OnAfterSetFieldsBilltoCustomeUpdateSellToPayment(var SalesHeader: Record "Sales Header")
    var
        SellToCustomer: Record "Customer";
    begin
        with SalesHeader do begin
            if "Sell-to Customer No." = "Bill-to Customer No." then
                exit;
            if not SellToCustomer.Get("Sell-to Customer No.") then
                exit;

            UpdateSellToPaymentTermsAndMethod(SalesHeader, SellToCustomer);
        end;
    end;

    local procedure UpdateSellToPaymentTermsAndMethod(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    var
        PaymentTerms: Record "Payment Terms";
    begin
        with SalesHeader do begin
            "Payment Terms Code" := SellToCustomer."Payment Terms Code";
            "Prepmt. Payment Terms Code" := SellToCustomer."Payment Terms Code";

            if "Document Type" = "Document Type"::"Credit Memo" then begin
                "Payment Method Code" := '';
                if PaymentTerms.GET("Payment Terms Code") then
                    if PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then
                        "Payment Method Code" := SellToCustomer."Payment Method Code"
            end else
                "Payment Method Code" := SellToCustomer."Payment Method Code";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnGetCustNoForSalesHeader', '', false, false)]
    local procedure SalesPriceMgtOnGetCustNoForSalesHeader(var SalesHeader: Record "Sales Header"; var CustomerNo: Code[20])
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if not SalesReceivablesSetup.get() then
            exit;
        if SalesReceivablesSetup."MICA Type of Cust. for Prices" = SalesReceivablesSetup."MICA Type of Cust. for Prices"::"Sell-to Customer" then
            CustomerNo := SalesHeader."Sell-to Customer No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Bill-to Customer No.', false, false)]
    local procedure OnAfterValidateEventBIllToCustomerNoSalesHeader(var Rec: Record "Sales Header")
    begin
        CopyFieldsFromSellToCustomer(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEventSellToCustomerNoSalesHeader(var Rec: Record "Sales Header")
    begin
        CopyFieldsFromSellToCustomer(Rec);
    end;

    local procedure CopyFieldsFromSellToCustomer(var SalesHeader: Record "Sales Header")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
    begin
        if not SalesReceivablesSetup.get() then
            exit;
        if SalesReceivablesSetup."MICA Type of Cust. for Prices" = SalesReceivablesSetup."MICA Type of Cust. for Prices"::"Sell-to Customer" then
            if Customer.Get(SalesHeader."Sell-to Customer No.") then begin
                SalesHeader.Validate("Currency Code", Customer."Currency Code");
                SalesHeader.Validate("Prices Including VAT", Customer."Prices Including VAT");
                SalesHeader.Validate("Customer Price Group", Customer."Customer Price Group");
                SalesHeader.Validate("Customer Disc. Group", Customer."Customer Disc. Group");
                SalesHeader.Validate("Language Code", Customer."Language Code");
                SalesHeader.Validate("Salesperson Code", Customer."Salesperson Code");
                SalesHeader.Validate("Combine Shipments", Customer."Combine Shipments");
                SalesHeader.Validate("Payment Terms Code", Customer."Payment Terms Code");
                SalesHeader.Validate("Payment Method Code", Customer."Payment Method Code");
            end;
    end;
}