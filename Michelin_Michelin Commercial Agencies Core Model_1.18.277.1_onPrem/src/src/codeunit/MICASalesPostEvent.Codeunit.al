codeunit 81840 "MICA Sales Post Event"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLine', '', false, false)]
    local procedure CU80OnAfterPostSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; var SalesInvLine: Record "Sales Invoice Line"; var SalesCrMemoLine: Record "Sales Cr.Memo Line"; var xSalesLine: Record "Sales Line")
    var
        Customer: Record Customer;
    begin
        if not (SalesHeader."Document Type" in [SalesHeader."Document Type"::"Credit Memo", SalesHeader."Document Type"::Invoice]) then
            exit;
        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;
        if not Customer."MICA Rebate Pool" then
            exit;
        if SalesLine.Type <> SalesLine.Type::Item then
            exit;
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") and (SalesLine."MICA Rebate Pool Entry No." = 0) then
            exit;

        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::"Credit Memo":
                MICARebatePoolMgt.CloseRebatePoolEntry(SalesLine, SalesCrMemoLine);
            SalesHeader."Document Type"::Invoice:
                if SalesHeader."MICA Created From Comb. Ship." then
                    MICARebatePoolMgt.UpdatePostedDocumentNoOnRebatePoolDtldEntries(SalesLine, SalesInvLine, true);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostLines', '', false, false)]
    local procedure CU80OnBeforePostSalesInvoiceLines(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        Customer: Record Customer;
        TempSalesLine: Record "Sales Line" temporary;
    begin
        if not (((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and SalesHeader.Invoice) or
            (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)) then
            exit;

        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;

        if not Customer."MICA Rebate Pool" then
            exit;

        if not TempSalesLine.IsTemporary() then
            exit;

        TempSalesLine.DeleteAll();
        MICARebatePoolMgt.CheckRebatePoolItemSetupAndConsumRebatePool(TempSalesLine, SalesHeader);
        MICARebatePoolMgt.CreateRebatePoolSalesLines(SalesLine, SalesHeader, TempSalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeFinalizePosting', '', false, false)]
    local procedure CU80OnBeforeFinalizeSalesInvoicePosting(var SalesHeader: Record "Sales Header"; var TempSalesLineGlobal: Record "Sales Line"; var EverythingInvoiced: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        TempSalesLine: Record "Sales Line" temporary;
        Customer: Record Customer;
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        if not (((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and SalesHeader.Invoice) or
            (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)) then
            exit;

        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;

        if not Customer."MICA Rebate Pool" then
            exit;

        if not SalesHeader."MICA Created From Comb. Ship." then
            MICARebatePoolMgt.PopulatePostedDocumentDataOnRebatePoolDtldEntries(SalesHeader, SalesInvoiceLine);

        TempSalesLine.Reset();
        TempSalesLine.CopyFilters(TempSalesLineGlobal);

        TempSalesLineGlobal.SetRange("Document Type", SalesHeader."Document Type");
        TempSalesLineGlobal.SetRange("Document No.", SalesHeader."No.");
        TempSalesLineGlobal.SetRange("MICA Rebate Pool Line", true);
        if not TempSalesLineGlobal.IsEmpty() then
            TempSalesLineGlobal.DeleteAll();

        TempSalesLineGlobal.Reset();
        TempSalesLineGlobal.CopyFilters(TempSalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure c22OnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        ReallocateToBackOrder(ItemJournalLine);
    end;

    local procedure ReallocateToBackOrder(ItemJournalLine: Record "Item Journal Line")
    var
        MICAReallocBackOrderMgt: Codeunit "MICA Realloc. BackOrder Mgt";
    begin
        case ItemJournalLine."Entry Type" of
            ItemJournalLine."Entry Type"::"Positive Adjmt.", ItemJournalLine."Entry Type"::"Negative Adjmt.":
                MICAReallocBackOrderMgt.CommitItemsInsideCommitmentPeriod(ItemJournalLine."Item No.", ItemJournalLine."Location Code");
            ItemJournalLine."Entry Type"::Transfer:
                begin
                    if ItemJournalLine."Document Type" <> ItemJournalLine."Document Type"::" " then
                        exit;
                    MICAReallocBackOrderMgt.CommitItemsInsideCommitmentPeriod(ItemJournalLine."Item No.", ItemJournalLine."Location Code");
                    if (ItemJournalLine."Location Code" <> ItemJournalLine."New Location Code") and
                            (ItemJournalLine."New Location Code" <> '')
                    then
                        MICAReallocBackOrderMgt.CommitItemsInsideCommitmentPeriod(ItemJournalLine."Item No.", ItemJournalLine."New Location Code");
                end;
        end;
    end;

    var
        MICARebatePoolMgt: Codeunit "MICA Rebate Pool Mgt.";
}