codeunit 81170 "MICA Currency On GL"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlobalGLEntry', '', false, false)]
    local procedure c12OnBeforeInsertGLEntryBuffer(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        Currency: Record Currency;
    begin
        IF GenJournalLine."Source Currency Code" <> '' then begin
            GlobalGLEntry."MICA Currency Code" := GenJournalLine."Source Currency Code";
            IF Currency.Get(GenJournalLine."Source Currency Code") then
                CalculateAmountFCY(GlobalGLEntry, GenJournalLine, Currency)
        end else begin
            GlobalGLEntry."MICA Currency Code" := GenJournalLine."Source Currency Code";
            GlobalGLEntry."MICA Amount (FCY)" := GlobalGLEntry.Amount;
        end;
    end;

    local procedure CalculateAmountFCY(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Currency: Record Currency)
    begin
        if GenJournalLine."Applies-to ID" = '' then
            if GenJournalLine."Allow Zero-Amount Posting" then
                AssignAmtFCYForCloseIncomeStatement(GlobalGLEntry, GenJournalLine)
            else
                GlobalGLEntry."MICA Amount (FCY)" := PopulateAmountFCYWhenEmptyApplieToId(GlobalGLEntry, GenJournalLine, Currency)
        else
            if not CheckIfExistGLEntry(GlobalGLEntry) then
                GlobalGLEntry."MICA Amount (FCY)" := 0
            else
                if GetCustVendPostGroupAcc(GlobalGLEntry) = GlobalGLEntry."G/L Account No." then
                    GlobalGLEntry."MICA Amount (FCY)" := GetAmountWithCorrectSign(GlobalGLEntry.Amount, GenJournalLine.Amount)
                else
                    if CheckCurrencyGainLossAccounts(Currency, GlobalGLEntry) then
                        GlobalGLEntry."MICA Amount (FCY)" := 0;
    end;

    local procedure PopulateAmountFCYWhenEmptyApplieToId(GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Currency: Record Currency): Decimal
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get();
        case true of
            SourceCodeSetup."Exchange Rate Adjmt." = GenJournalLine."Source Code":
                exit(0);
            SourceCodeSetup."Cash Receipt Journal" = GenJournalLine."Source Code", SourceCodeSetup."Payment Journal" = GenJournalLine."Source Code":
                if (not CheckIfExistGLEntry(GlobalGLEntry)) or CheckCurrencyGainLossAccounts(Currency, GlobalGLEntry) then
                    exit(0)
                else
                    Exit(Round(
                    CurrencyExchangeRate.ExchangeAmtLCYToFCYOnlyFactor(
                        GlobalGLEntry.Amount, GenJournalLine."Currency Factor"), Currency."Amount Rounding Precision"))
            else
                Exit(Round(
                    CurrencyExchangeRate.ExchangeAmtLCYToFCYOnlyFactor(
                        GlobalGLEntry.Amount, GenJournalLine."Currency Factor"), Currency."Amount Rounding Precision"))
        end;
    end;

    local procedure AssignAmtFCYForCloseIncomeStatement(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."Currency Code" <> '' then
            if GenJournalLine."Bal. Account No." = GlobalGLEntry."G/L Account No." then
                GlobalGLEntry."MICA Amount (FCY)" := -GenJournalLine.Amount
            else
                GlobalGLEntry."MICA Amount (FCY)" := 0;
    end;

    local procedure GetCustVendPostGroupAcc(GlobalGLEntry: Record "G/L Entry"): Code[20]
    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
    begin
        case GlobalGLEntry."Source Type" of
            GlobalGLEntry."Source Type"::Vendor:
                begin
                    if not Vendor.Get(GlobalGLEntry."Source No.") then
                        exit;
                    if not VendorPostingGroup.Get(Vendor."Vendor Posting Group") then
                        exit;
                    exit(VendorPostingGroup."Payables Account");
                end;
            GlobalGLEntry."Source Type"::Customer:
                begin
                    if not Customer.Get(GlobalGLEntry."Source No.") then
                        exit;
                    if not CustomerPostingGroup.Get(Customer."Customer Posting Group") then
                        exit;
                    exit(CustomerPostingGroup."Receivables Account");
                end;
            GlobalGLEntry."Source Type"::"Bank Account":
                begin
                    if not BankAccount.Get(GlobalGLEntry."Source No.") then
                        exit;
                    if not BankAccountPostingGroup.Get(BankAccount."Bank Acc. Posting Group") then
                        exit;
                    exit(BankAccountPostingGroup."G/L Account No.");
                end;
        end;
    end;

    local procedure CheckCurrencyGainLossAccounts(Currency: Record Currency; GlobalGLEntry: Record "G/L Entry"): Boolean
    begin
        exit((Currency."Realized Losses Acc." = GlobalGLEntry."G/L Account No.") or
            (Currency."Realized Gains Acc." = GlobalGLEntry."G/L Account No.") or
            (Currency."Unrealized Losses Acc." = GlobalGLEntry."G/L Account No.") or
            (Currency."Unrealized Gains Acc." = GlobalGLEntry."G/L Account No."));
    end;

    local procedure GetAmountWithCorrectSign(GlobalGLEntryAmount: Decimal; GeneralJournalLineAmount: Decimal): Decimal
    begin
        case true of
            GlobalGLEntryAmount > 0:
                begin
                    if GeneralJournalLineAmount < 0 then
                        exit(-GeneralJournalLineAmount);
                    exit(GeneralJournalLineAmount);
                end;
            GlobalGLEntryAmount < 0:
                begin
                    if GeneralJournalLineAmount < 0 then
                        exit(GeneralJournalLineAmount);
                    exit(-GeneralJournalLineAmount);
                end;
            GlobalGLEntryAmount = 0:
                exit(0);
        end
    end;

    local procedure CheckIfExistGLEntry(GlobalGLEntry: Record "G/L Entry"): Boolean
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
        GLEntry.SetRange("G/L Account No.", GlobalGLEntry."G/L Account No.");
        GLEntry.SetRange("Document Type", GlobalGLEntry."Document Type");
        GLEntry.SetRange("Bal. Account Type", GlobalGLEntry."Bal. Account Type"::"Bank Account");
        GLEntry.SetRange("Document No.", GlobalGLEntry."Document No.");
        GLEntry.SetFilter("Source Type", '%1|%2', GlobalGLEntry."Source Type"::Customer, GlobalGLEntry."Source Type"::Vendor);
        GLEntry.SetRange("MICA Currency Code", GlobalGLEntry."MICA Currency Code");
        GLEntry.SetFilter("MICA Amount (FCY)", '<>%1', 0);
        exit(GLEntry.IsEmpty());
    end;

    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
}