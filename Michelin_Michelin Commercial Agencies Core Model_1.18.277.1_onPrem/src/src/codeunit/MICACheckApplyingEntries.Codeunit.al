codeunit 82140 "MICA CheckApplyingEntries"
{


    [EventSubscriber(objectType::Table, Database::"Sales Header", 'OnBeforeSalesLineInsert', '', false, false)]
    local procedure TransferDiscountFieldsSales(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    var
    begin
        with SalesLine do
            if "Document Type" in ["Document Type"::"Credit Memo", "Document Type"::Invoice, "Document Type"::Order] then
                Validate("Line Discount %", TempSalesLine."Line Discount %");

    end;

    [EventSubscriber(objectType::Table, Database::"Purchase Header", 'OnRecreatePurchLinesOnBeforeInsertPurchLine', '', false, false)]
    local procedure TransferDiscountFieldsPurchase(var PurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary)
    var
    begin
        with PurchaseLine do
            if "Document Type" in ["Document Type"::"Credit Memo", "Document Type"::Invoice, "Document Type"::Order] then
                Validate("Line Discount %", TempPurchaseLine."Line Discount %");
    end;

    [EventSubscriber(objectType::Table, Database::"Vendor Ledger Entry", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyVendorEvent(var Rec: Record "Vendor Ledger Entry"; xRec: Record "Vendor Ledger Entry"; RunTrigger: Boolean)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin

        if Rec."Applies-to ID" = '' then
            exit;

        GenJournalLine.SetRange("Document No.", Rec."Applies-to ID");
        /*
        if GenJournalLine.FindFirst() then
            if GenJournalLine."Posting Group" <> Rec."Vendor Posting Group" then
                Error(PostingGroupErr,
                  GenJournalLine.TableCaption(), GenJournalLine."Document No.", GenJournalLine.FieldCaption("Posting Group"), GenJournalLine."Posting Group",
                  Rec.TableCaption(), Rec."Document No.", Rec.FieldCaption("Vendor Posting Group"), Rec."Vendor Posting Group");
                  */
    End;

    [EventSubscriber(objectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyCustomerEvent(var Rec: Record "Cust. Ledger Entry"; xRec: Record "Cust. Ledger Entry"; RunTrigger: Boolean)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin

        if Rec."Applies-to ID" = '' then
            exit;

        GenJournalLine.SetRange("Document No.", Rec."Applies-to ID");
        if GenJournalLine.FindFirst() then
            if GenJournalLine."Posting Group" <> Rec."Customer Posting Group" then
                Error(PostingGroupErr,
                  GenJournalLine.TableCaption(), GenJournalLine."Document No.", GenJournalLine.FieldCaption("Posting Group"), GenJournalLine."Posting Group",
                  Rec.TableCaption(), Rec."Document No.", Rec.FieldCaption("Customer Posting Group"), Rec."Customer Posting Group");
    End;

    [EventSubscriber(objectType::Table, Database::"Employee Ledger Entry", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyEmployeeEvent(var Rec: Record "Employee Ledger Entry"; xRec: Record "Employee Ledger Entry"; RunTrigger: Boolean)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin

        if Rec."Applies-to ID" = '' then
            exit;

        GenJournalLine.SetRange("Document No.", Rec."Applies-to ID");
        if GenJournalLine.FindFirst() then
            if GenJournalLine."Posting Group" <> Rec."Employee Posting Group" then
                Error(PostingGroupErr,
                  GenJournalLine.TableCaption(), GenJournalLine."Document No.", GenJournalLine.FieldCaption("Posting Group"), GenJournalLine."Posting Group",
                  Rec.TableCaption(), Rec."Document No.", Rec.FieldCaption("Employee Posting Group"), Rec."Employee Posting Group");
    End;

    var
        PostingGroupErr: Label 'Posting groups should be identical. For %1 %2 %3 is %4 and for %5 %6 %7 is %8.';

}