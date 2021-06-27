codeunit 81553 "MICA MP CT-Check Line"
{
    // version MIC01.00.18

    // MIC:EDD029:1:0      21/02/2017 COSMO.CCO
    //   # New codeunit to manage Mass Payment File creation

    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        Rec.DeletePaymentFileErrors();
        CheckGenJnlLine(Rec);
        CheckBank(Rec);
        CheckCustVend(Rec);
    end;

    var
        MustBeBankAccErr: Label 'The balancing account must be a bank account.';
        MustBeVendorOrCustomerErr: Label 'The account must be a vendor or customer account.';
        MustBeVendPmtOrCustRefundErr: Label 'Only vendor payments and customer refunds are allowed.';
        MustBePositiveErr: Label 'The amount must be positive.';
        TransferDateErr: Label 'The earliest possible transfer date is today.';
        //EuroCurrErr: Label 'Only transactions in euro (EUR) are allowed.';
        FieldBlankErr: Label '%1 must have a value in %2.', Comment = '%1=table name, %2=field name. Example: Customer must have a value in Name.';
        FieldKeyBlankErr: Label '%1 %2 must have a value in %3.', Comment = '%1=table name, %2=key field value, %3=field name. Example: Customer 10000 must have a value in Name.';

    procedure CheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        SetupGenJournalLine: Record "Gen. Journal Line";
    begin
        SetupGenJournalLine.Get();
        WITH GenJournalLine DO BEGIN
            IF "Bal. Account Type" <> "Bal. Account Type"::"Bank Account" THEN
                InsertPaymentFileError(MustBeBankAccErr);

            IF "Bal. Account No." = '' THEN
                AddFieldEmptyError(GenJournalLine, TableCaption(), FIELDCAPTION("Bal. Account No."), '');

            IF "Recipient Bank Account" = '' THEN
                AddFieldEmptyError(GenJournalLine, TableCaption(), FIELDCAPTION("Recipient Bank Account"), '');

            IF NOT ("Account Type" IN ["Account Type"::Vendor, "Account Type"::Customer]) THEN
                InsertPaymentFileError(MustBeVendorOrCustomerErr);

            IF (("Account Type" = "Account Type"::Vendor) AND ("Document Type" <> "Document Type"::Payment)) OR
               (("Account Type" = "Account Type"::Customer) AND ("Document Type" <> "Document Type"::Refund))
            THEN
                InsertPaymentFileError(STRSUBSTNO(MustBeVendPmtOrCustRefundErr));

            IF Amount <= 0 THEN
                InsertPaymentFileError(MustBePositiveErr);

            //IF "Currency Code" <> GLSetup.GetCurrencyCode('EUR') THEN
            //  InsertPaymentFileError(EuroCurrErr);

            IF "Posting Date" < Today() THEN
                InsertPaymentFileError(TransferDateErr);
        END;
    end;

    procedure CheckBank(var GenJournalLine: Record "Gen. Journal Line")
    var
        BankAccount: Record "Bank Account";
    begin
        WITH GenJournalLine DO
            IF BankAccount.GET("Bal. Account No.") THEN
                IF (BankAccount.IBAN = '') AND (BankAccount."Bank Account No." = '') THEN
                    AddFieldEmptyError(GenJournalLine, BankAccount.TableCaption(), BankAccount.FIELDCAPTION(IBAN) + ' ' + BankAccount.FIELDCAPTION("Bank Account No."), "Bal. Account No.");
    end;

    procedure CheckCustVend(var GenJournalLine: Record "Gen. Journal Line")
    var
        Customer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        WITH GenJournalLine DO BEGIN
            IF "Account No." = '' THEN BEGIN
                InsertPaymentFileError(MustBeVendorOrCustomerErr);
                EXIT;
            END;
            CASE "Account Type" OF
                "Account Type"::Customer:
                    BEGIN
                        Customer.GET("Account No.");
                        IF Customer.Name = '' THEN
                            AddFieldEmptyError(GenJournalLine, Customer.TableCaption(), Customer.FIELDCAPTION(Name), "Account No.");
                        IF "Recipient Bank Account" <> '' THEN BEGIN
                            CustomerBankAccount.GET(Customer."No.", "Recipient Bank Account");
                            IF CustomerBankAccount.IBAN = '' THEN
                                AddFieldEmptyError(
                                  GenJournalLine, CustomerBankAccount.TableCaption(), CustomerBankAccount.FIELDCAPTION(IBAN), "Recipient Bank Account");
                        END;
                    END;
                "Account Type"::Vendor:
                    BEGIN
                        Vendor.GET("Account No.");
                        IF Vendor.Name = '' THEN
                            AddFieldEmptyError(GenJournalLine, Vendor.TableCaption(), Vendor.FIELDCAPTION(Name), "Account No.");
                        IF "Recipient Bank Account" <> '' THEN BEGIN
                            VendorBankAccount.GET(Vendor."No.", "Recipient Bank Account");
                            IF VendorBankAccount.IBAN = '' THEN
                                AddFieldEmptyError(
                                  GenJournalLine, VendorBankAccount.TableCaption(), VendorBankAccount.FIELDCAPTION(IBAN), "Recipient Bank Account");
                        END;
                    END;
            END;
        END;
    end;

    procedure AddFieldEmptyError(var GenJournalLine: Record "Gen. Journal Line";
            TableCaption:
                Text;
            FieldCaption:
                Text;
            KeyValue:
                Text)
    var
        ErrorText:
            Text;
    begin
        IF KeyValue = '' THEN
            ErrorText := STRSUBSTNO(FieldBlankErr, TableCaption, FieldCaption)
        ELSE
            ErrorText := STRSUBSTNO(FieldKeyBlankErr, TableCaption, KeyValue, FieldCaption);
        GenJournalLine.InsertPaymentFileError(ErrorText);
    end;
}

