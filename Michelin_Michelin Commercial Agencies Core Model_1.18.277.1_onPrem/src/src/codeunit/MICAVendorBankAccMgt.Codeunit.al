codeunit 82120 "MICA Vendor Bank Acc Mgt."
{

    [EventSubscriber(ObjectType::Table, DATABASE::Vendor, 'OnAfterValidateEvent', 'Preferred Bank Account Code', false, false)]
    local procedure OnAfterValidateVendorPreferredBankAccCode(VAR Rec: Record Vendor; VAR xRec: Record Vendor; CurrFieldNo: Integer)
    begin
        if Rec."Preferred Bank Account Code" <> '' then
            CheckVendorBlockedBankAcc(Rec."No.", Rec."Preferred Bank Account Code")
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Gen. Journal Line", 'OnAfterValidateEvent', 'Recipient Bank Account', false, false)]
    local procedure OnAfterValidateReceiptBankAccOnPaymentJournal(VAR Rec: Record "Gen. Journal Line"; VAR xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        if Rec.IsTemporary() then
            exit;
        if (Rec."Journal Template Name" <> '') and (Rec."Journal Batch Name" <> '') and
                (Rec."Document Type" = Rec."Document Type"::Payment) and (Rec."Account Type" = Rec."Account Type"::Vendor)
        then
            CheckVendorBlockedBankAcc(Rec."Account No.", Rec."Recipient Bank Account");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeStartOrContinuePosting', '', false, false)]
    local procedure OnBeforeStartOrContinuePostingCheckVendorBankAcc(VAR GenJnlLine: Record "Gen. Journal Line")
    begin
        if (GenJnlLine."Journal Template Name" <> '') and (GenJnlLine."Journal Batch Name" <> '') and
                (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) and (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor)
        then
            CheckVendorBlockedBankAcc(GenJnlLine."Account No.", GenJnlLine."Recipient Bank Account");
    end;

    procedure CheckBankAccBeforeExportPaymentFile(GenJournalLine: Record "Gen. Journal Line")
    var
        FoundGenJournalLine: Record "Gen. Journal Line";
    begin
        FoundGenJournalLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        FoundGenJournalLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        FoundGenJournalLine.SetRange("Exported to Payment File", false);
        FoundGenJournalLine.SetFilter("Payment Method Code", '<>%1', '');
        if FoundGenJournalLine.FindSet() then
            repeat
                CheckVendorBlockedBankAcc(FoundGenJournalLine."Account No.", FoundGenJournalLine."Recipient Bank Account");
            until FoundGenJournalLine.Next() = 0;
    end;

    local procedure CheckVendorBlockedBankAcc(VendorNo: Code[20]; VendBankAccCode: Code[20])
    var
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        if VendorBankAccount.Get(VendorNo, VendBankAccCode) then
            VendorBankAccount.TestField("MICA Blocked", false);
    end;
}