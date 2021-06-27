codeunit 81610 "MICA SalesPurchOrdDeletEvents"
{
    /*

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure c80OnBeforeDeleteAfterPosting(VAR SalesHeader: Record "Sales Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VAR SkipDelete: Boolean; CommitIsSuppressed: Boolean)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."MICA Keep order when invoiced" then
            SkipDelete := SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"];
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure c90OnBeforeDeleteAfterPosting(VAR PurchaseHeader: Record "Purchase Header"; VAR PurchInvHeader: Record "Purch. Inv. Header"; VAR PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; VAR SkipDelete: Boolean; CommitIsSupressed: Boolean)
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get();
        if PurchasesPayablesSetup."MICA Keep order when invoiced" then
            SkipDelete := PurchaseHeader."Document Type" in [PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::"Return Order"];
    end;
    */
}