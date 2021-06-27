codeunit 81551 "MICA MP CT-Fill Export Buffer"
{
    // version MIC01.00.18

    // MIC:EDD029:1:0      21/02/2017 COSMO.CCO
    //   # New codeunit to manage Mass Payment File creation
    // MIC:EDD MASS-CH:1:1 29/03/2017 COSMO.JMO
    //   # Get the currency of the invoices instead of the default bank account currency
    //   # Moved the function "SetBankAsSenderBank"

    Permissions = TableData "Payment Export Data" = rimd;
    TableNo = "Payment Export Data";

    trigger OnRun()
    begin
    end;

    var
        HasErrorsErr: Label 'The file export has one or more errors. For each of the lines to be exported, resolve any errors that are displayed in the File Export Errors FactBox.';
        FieldIsBlankErr: Label 'Field %1 must be specified.', Comment = '%1=field name, e.g. Post Code.';
        SameBankErr: Label 'All lines must have the same bank account as the balancing account.';
        RemitMsg: Label '%1 %2', Comment = '%1=Document type, %2=Document no., e.g. Invoice A123';
        CurrencyErr: Label 'The file can''t contain several currency';

    procedure FillExportBuffer(var GenJnlLine: Record 81; var PaymentExportData: Record 1226; var TmpVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; var TmpCustLedgerEntry: Record "Cust. Ledger Entry" temporary)
    var
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        GeneralLedgerSetup: Record "General Ledger Setup";
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Employee: Record Employee;
        VendorBankAccount: Record "Vendor Bank Account";
        CustomerBankAccount: Record "Customer Bank Account";
        CreditTransferRegister: Record "Credit Transfer Register";
        CreditTransferEntry: Record "Credit Transfer Entry";
        BankExportImportSetup: Record "Bank Export/Import Setup";
        PmtMethod: Record "Payment Method";
        //PurchInvHdr: Record "Purch. Inv. Header";
        VendLedgEntry: Record "Vendor Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        MessageID: Code[20];
        //FinancialReportingSetup: Record 80010;
        PaymentCurrencyCode: Code[10];
        UseBankExportImportSetup: Boolean;
    begin
        TempGenJnlLine.COPYFILTERS(GenJnlLine);
        CODEUNIT.RUN(CODEUNIT::"MICA MP CT-Prepare Source", TempGenJnlLine);

        TempGenJnlLine.Reset();
        TempGenJnlLine.FindSet();
        PaymentCurrencyCode := TempGenJnlLine."Currency Code";
        BankAccount.GET(TempGenJnlLine."Bal. Account No.");
        //BankAccount.TESTFIELD(IBAN);
        if BankAccount."Payment Export Format" <> '' then begin
            UseBankExportImportSetup := true;
            BankAccount.GetBankExportImportSetup(BankExportImportSetup);
            BankExportImportSetup.TESTFIELD("Check Export Codeunit");
        end;
        TempGenJnlLine.DeletePaymentFileBatchErrors();
        REPEAT
            if UseBankExportImportSetup then
                CODEUNIT.RUN(BankExportImportSetup."Check Export Codeunit", TempGenJnlLine);
            IF (PaymentCurrencyCode <> TempGenJnlLine."Currency Code") THEN
                ERROR(CurrencyErr);

            IF TempGenJnlLine."Bal. Account No." <> BankAccount."No." THEN
                TempGenJnlLine.InsertPaymentFileError(SameBankErr);
        UNTIL TempGenJnlLine.Next() = 0;

        IF TempGenJnlLine.HasPaymentFileErrorsInBatch() THEN BEGIN
            Commit();
            ERROR(HasErrorsErr);
        END;

        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TESTFIELD("LCY Code");

        MessageID := BankAccount.GetCreditTransferMessageNo();
        CreditTransferRegister.CreateNew(MessageID, BankAccount."No.");

        WITH PaymentExportData DO BEGIN
            Reset();
            IF FindLast() THEN;

            TempGenJnlLine.FindSet();
            REPEAT
                Init();
                "Entry No." += 1;
                if UseBankExportImportSetup then
                    SetPreserveNonLatinCharacters(BankExportImportSetup."Preserve Non-Latin Characters")
                else
                    SetPreserveNonLatinCharacters(true);
                TempGenJnlLine.TESTFIELD("Payment Method Code");
                if PmtMethod.Get(TempGenJnlLine."Payment Method Code") then begin
                    "Payment Type" := PmtMethod."MICA Payment Type" + '|' + PmtMethod."MICA Payment Code";
                    "MICA Payment Priority Code" := PmtMethod."MICA Payment Priority Code";
                end;
                SetBankAsSenderBank(BankAccount);
                "Transfer Date" := TempGenJnlLine."Posting Date";
                "Document No." := TempGenJnlLine."Document No.";
                "Applies-to Ext. Doc. No." := TempGenJnlLine."Applies-to Ext. Doc. No.";
                Amount := TempGenJnlLine.Amount;
                IF TempGenJnlLine."Currency Code" = '' THEN
                    "Currency Code" := GeneralLedgerSetup."LCY Code"
                ELSE
                    "Currency Code" := TempGenJnlLine."Currency Code";
                CASE TempGenJnlLine."Account Type" OF
                    TempGenJnlLine."Account Type"::Customer:
                        BEGIN
                            Customer.GET(TempGenJnlLine."Account No.");
                            CustomerBankAccount.GET(Customer."No.", TempGenJnlLine."Recipient Bank Account");
                            SetCustomerAsRecipient(Customer, CustomerBankAccount);
                            "Recipient Acc. No." := Customer."No.";
                            if TempGenJnlLine."Applies-to ID" <> '' then begin
                                CustLedgEntry.Reset();
                                CustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
                                CustLedgEntry.SETRANGE("Customer No.", TempGenJnlLine."Account No.");
                                CustLedgEntry.SetRange("Applies-to ID", TempGenJnlLine."Applies-to ID");
                                if CustLedgEntry.FindSet() then
                                    repeat
                                        TmpCustLedgerEntry.TransferFields(CustLedgEntry);
                                        TmpCustLedgerEntry.Insert();
                                    until CustLedgEntry.Next() = 0;
                            end;
                        END;
                    TempGenJnlLine."Account Type"::Vendor:
                        BEGIN
                            Vendor.GET(TempGenJnlLine."Account No.");
                            VendorBankAccount.GET(Vendor."No.", TempGenJnlLine."Recipient Bank Account");
                            SetVendorAsRecipient(Vendor, VendorBankAccount);
                            "Recipient Name" := Vendor."MICA English Name";
                            "Transit No." := VendorBankAccount."Transit No.";
                            "Recipient Bank Clearing Code" := VendorBankAccount."Bank Clearing Code";
                            "Recipient Email Address" += '|' + Vendor."Fax No.";
                            "Recipient Acc. No." := Vendor."No.";
                            if TempGenJnlLine."Applies-to ID" <> '' then begin
                                VendLedgEntry.Reset();
                                VendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                                VendLedgEntry.SETRANGE("Vendor No.", TempGenJnlLine."Account No.");
                                VendLedgEntry.SetRange("Applies-to ID", TempGenJnlLine."Applies-to ID");
                                if VendLedgEntry.FindSet() then
                                    repeat
                                        TmpVendorLedgerEntry.TransferFields(VendLedgEntry);
                                        TmpVendorLedgerEntry.Insert();
                                    until VendLedgEntry.Next() = 0;
                            end;
                        END;
                    TempGenJnlLine."Account Type"::Employee:
                        if Employee.Get(TempGenJnlLine."Account No.") then begin
                            SetEmployeeAsRecipient(Employee);
                            "Recipient Bank Clearing Code" := Employee."MICA Ctry Credit Agent No.";
                            "Recipient Bank Country/Region" := Employee."MICA NCC";
                            "Recipient Email Address" += '|' + Employee."Fax No.";
                            "Recipient Acc. No." := Employee."No.";
                        end;
                END;

                //VALIDATE("SEPA Instruction Priority","SEPA Instruction Priority"::NORMAL);
                //VALIDATE("SEPA Payment Method","SEPA Payment Method"::TRF);
                //VALIDATE("SEPA Charge Bearer","SEPA Charge Bearer"::SLEV);
                //"SEPA Batch Booking" := FALSE;
                SetCreditTransferIDs(MessageID);

                IF "Applies-to Ext. Doc. No." <> '' THEN
                    AddRemittanceText(STRSUBSTNO(RemitMsg, TempGenJnlLine."Applies-to Doc. Type", "Applies-to Ext. Doc. No."))
                ELSE
                    AddRemittanceText(TempGenJnlLine.Description);
                IF TempGenJnlLine."Message to Recipient" <> '' THEN
                    AddRemittanceText(TempGenJnlLine."Message to Recipient");

                if (TempGenJnlLine."MICA Tax Payment") then
                    PaymentExportData."MICA Explanation" := TempGenJnlLine."MICA Explanation (VN)";

                ValidatePaymentExportData(PaymentExportData, TempGenJnlLine);

                INSERT(TRUE);
                CreditTransferEntry.CreateNew(
                  CreditTransferRegister."No.", "Entry No.",
                  TempGenJnlLine."Account Type", TempGenJnlLine."Account No.",
                  TempGenJnlLine.GetAppliesToDocEntryNo(),
                  "Transfer Date", "Currency Code", Amount, CopyStr("End-to-End ID", 1, /*MaxStrLen("End-to-End ID")*/35),
                  TempGenJnlLine."Recipient Bank Account", TempGenJnlLine."Message to Recipient");
            UNTIL TempGenJnlLine.Next() = 0;
        END;
    end;

    local procedure ValidatePaymentExportData(var PaymentExportData: Record "Payment Export Data"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Sender Bank Account No."));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Recipient Name"));
        if PaymentExportData."MICA Recipient IBAN" = '' then
            ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Recipient Bank Acc. No."));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Transfer Date"));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Payment Information ID"));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("End-to-End ID"));
    end;

    local procedure ValidatePaymentExportDataField(var PaymentExportData: Record "Payment Export Data"; var GenJnlLine: Record "Gen. Journal Line"; FieldName: Text)
    var
        "Field": Record Field;
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.GETTABLE(PaymentExportData);
        Field.SETRANGE(TableNo, RecRef.Number());
        Field.SETRANGE(FieldName, FieldName);
        Field.FindFirst();
        FieldRef := RecRef.FIELD(Field."No.");
        IF (Field.Type = Field.Type::Text) AND (FORMAT(FieldRef.Value()) <> '') THEN
            EXIT;
        IF (Field.Type = Field.Type::Code) AND (FORMAT(FieldRef.Value()) <> '') THEN
            EXIT;
        IF (Field.Type = Field.Type::Decimal) AND (FORMAT(FieldRef.Value()) <> '0') THEN
            EXIT;
        IF (Field.Type = Field.Type::Integer) AND (FORMAT(FieldRef.Value()) <> '0') THEN
            EXIT;
        IF (Field.Type = Field.Type::Date) AND (FORMAT(FieldRef.Value()) <> '0D') THEN
            EXIT;

        PaymentExportData.AddGenJnlLineErrorText(GenJnlLine, STRSUBSTNO(FieldIsBlankErr, Field."Field Caption"));
    end;
}

