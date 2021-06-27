codeunit 81554 "MICA Mass Payment Fill Buffers"
{
    Permissions = TableData "Payment Export Data" = rimd, TableData "Ledger Entry Matching Buffer" = rimd;
    TableNo = "Payment Export Data";

    var
        Customer: Record Customer;
        CustomerBankAccount: record "Customer Bank Account";
        CustLedgerEntry: record "Cust. Ledger Entry";
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        VendorLedgerEntry: record "Vendor Ledger Entry";
        Employee: Record Employee;
        EmployeeLedgerEntry: record "Employee Ledger Entry";
        FieldIsBlankErr: Label 'Field %1 must be specified.', Comment = '%1=field name, e.g. Post Code.';
        RemitMsg: Label '%1 %2', Comment = '%1=Document type, %2=Document no., e.g. Invoice A123';
        CurrencyErr: Label 'The file cannot contain several currencies';
        SameBankErr: Label 'All lines must have the same bank account as the balancing account.';
        HasErrorsErr: Label 'The file export has one or more errors. For each of the lines to be exported, resolve any errors that are displayed in the File Export Errors FactBox.';


    procedure PrepareBuffers(var FromPaymentGenJournalLine: record "Gen. Journal Line"; var ToPaymentExportData: Record "Payment Export Data"; var TempLedgerEntryMatchingBuffer: record "Ledger Entry Matching Buffer" temporary)
    var
        BankAccount: Record "Bank Account";
        BankExportImportSetup: Record "Bank Export/Import Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CreditTransferRegister: Record "Credit Transfer Register";
        CreditTransferEntry: Record "Credit Transfer Entry";
        PaymentMethod: record "Payment Method";
        TempPaymentGenJournalLine: Record "Gen. Journal Line" temporary;
        PaymentCurrencyCode: Code[10];
        MessageID: Code[20];
        UseBankExportImportSetup: Boolean;
    begin
        TempPaymentGenJournalLine.CopyFilters(FromPaymentGenJournalLine);
        Codeunit.Run(Codeunit::"MICA MP CT-Prepare Source", TempPaymentGenJournalLine);

        TempPaymentGenJournalLine.Reset();
        TempPaymentGenJournalLine.FindFirst();
        PaymentCurrencyCode := TempPaymentGenJournalLine."Currency Code";
        BankAccount.GET(TempPaymentGenJournalLine."Bal. Account No.");
        if BankAccount."Payment Export Format" <> '' then begin
            UseBankExportImportSetup := true;
            BankAccount.GetBankExportImportSetup(BankExportImportSetup);
            BankExportImportSetup.TESTFIELD("Check Export Codeunit");
        end;
        TempPaymentGenJournalLine.DeletePaymentFileBatchErrors();
        repeat
            if UseBankExportImportSetup then
                Codeunit.Run(BankExportImportSetup."Check Export Codeunit", TempPaymentGenJournalLine);
            if (PaymentCurrencyCode <> TempPaymentGenJournalLine."Currency Code") then
                error(CurrencyErr);

            if TempPaymentGenJournalLine."Bal. Account No." <> BankAccount."No." then
                TempPaymentGenJournalLine.InsertPaymentFileError(SameBankErr);
        until TempPaymentGenJournalLine.Next() = 0;

        if TempPaymentGenJournalLine.HasPaymentFileErrorsInBatch() then begin
            Commit();
            ERROR(HasErrorsErr);
        end;

        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TestField("LCY Code");

        MessageID := BankAccount.GetCreditTransferMessageNo();
        CreditTransferRegister.CreateNew(MessageID, BankAccount."No.");

        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");

        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");

        EmployeeLedgerEntry.Reset();
        EmployeeLedgerEntry.SetCurrentKey("Employee No.", "Applies-to ID", Open, Positive);

        TempLedgerEntryMatchingBuffer.DeleteAll();

        with ToPaymentExportData do
            // Reset();
            // If FindLast() THEN;
            if ToPaymentExportData.FindSet() then
                repeat
                    Init();
                    "Entry No." += 1;
                    if UseBankExportImportSetup then
                        SetPreserveNonLatinCharacters(BankExportImportSetup."Preserve Non-Latin Characters")
                    else
                        SetPreserveNonLatinCharacters(true);
                    TempPaymentGenJournalLine.TestField("Payment Method Code");
                    if PaymentMethod.Get(TempPaymentGenJournalLine."Payment Method Code") then begin
                        "Payment Type" := PaymentMethod."MICA Payment Type" + '|' + PaymentMethod."MICA Payment Code";
                        "MICA Payment Priority Code" := PaymentMethod."MICA Payment Priority Code";
                    end;
                    "MICA Additional Information 1" := TempPaymentGenJournalLine."MICA Additional Information 1";
                    "MICA Additional Information 2" := TempPaymentGenJournalLine."MICA Additional Information 2";
                    "MICA Additional Information 3" := TempPaymentGenJournalLine."MICA Additional Information 3";
                    "MICA Additional Information 4" := TempPaymentGenJournalLine."MICA Additional Information 4";
                    SetBankAsSenderBank(BankAccount);
                    "Sender Bank Country/Region" := BankAccount."Country/Region Code";
                    "MICA Bank Branch No." := BankAccount."Bank Branch No.";
                    "Transfer Date" := TempPaymentGenJournalLine."Posting Date";
                    "Document No." := TempPaymentGenJournalLine."Document No.";
                    "Applies-to Ext. Doc. No." := TempPaymentGenJournalLine."Applies-to Ext. Doc. No.";
                    "MICA Applies-to ID" := TempPaymentGenJournalLine."Applies-to ID";
                    Amount := TempPaymentGenJournalLine.Amount;
                    IF TempPaymentGenJournalLine."Currency Code" = '' THEN
                        "Currency Code" := GeneralLedgerSetup."LCY Code"
                    ELSE
                        "Currency Code" := TempPaymentGenJournalLine."Currency Code";

                    case TempPaymentGenJournalLine."Account Type" OF
                        TempPaymentGenJournalLine."Account Type"::Customer:
                            SetCustomerBuffer(ToPaymentExportData, TempPaymentGenJournalLine, TempLedgerEntryMatchingBuffer);
                        TempPaymentGenJournalLine."Account Type"::Vendor:
                            SetVendorBuffer(ToPaymentExportData, TempPaymentGenJournalLine, TempLedgerEntryMatchingBuffer);
                        TempPaymentGenJournalLine."Account Type"::Employee:
                            SetEmployeeBuffer(ToPaymentExportData, TempPaymentGenJournalLine, TempLedgerEntryMatchingBuffer);
                    end;

                    SetCreditTransferIDs(MessageID);

                    IF "Applies-to Ext. Doc. No." <> '' THEN
                        AddRemittanceText(StrSubstNo(RemitMsg, TempPaymentGenJournalLine."Applies-to Doc. Type", "Applies-to Ext. Doc. No."))
                    ELSE
                        AddRemittanceText(TempPaymentGenJournalLine.Description);
                    IF TempPaymentGenJournalLine."Message to Recipient" <> '' THEN
                        AddRemittanceText(TempPaymentGenJournalLine."Message to Recipient");

                    "MICA Explanation" := TempPaymentGenJournalLine."MICA Explanation";
                    if (TempPaymentGenJournalLine."MICA Tax Payment") then
                        "MICA Explanation" := TempPaymentGenJournalLine."MICA Explanation (VN)";

                    ValidatePaymentExportData(ToPaymentExportData, TempPaymentGenJournalLine);

                    Insert(true);

                    CreditTransferEntry.CreateNew(
                      CreditTransferRegister."No.", "Entry No.",
                      TempPaymentGenJournalLine."Account Type", TempPaymentGenJournalLine."Account No.",
                      TempPaymentGenJournalLine.GetAppliesToDocEntryNo(),
                      "Transfer Date", "Currency Code", Amount, CopyStr("End-to-End ID", 1, 35),
                      TempPaymentGenJournalLine."Recipient Bank Account", TempPaymentGenJournalLine."Message to Recipient");
                until TempPaymentGenJournalLine.Next() = 0;
    end;

    local procedure SetCustomerBuffer(var FromPaymentExportData: Record "Payment Export Data"; var FromPaymentGenJournalLine: record "Gen. Journal Line"; var ToTempLedgerEntryMatchingBuffer: record "Ledger Entry Matching Buffer" temporary)
    begin
        Customer.Get(FromPaymentGenJournalLine."Account No.");
        CustomerBankAccount.GET(Customer."No.", FromPaymentGenJournalLine."Recipient Bank Account");
        FromPaymentExportData.SetCustomerAsRecipient(Customer, CustomerBankAccount);
        FromPaymentExportData."Recipient Acc. No." := Customer."No.";
        FromPaymentExportData."Invoice Amount" := FromPaymentGenJournalLine.Amount;
        FromPaymentExportData."MICA Recipient IBAN" := DelChr(CustomerBankAccount.IBAN, '=<>');
        if FromPaymentExportData."MICA Recipient IBAN" <> '' then
            FromPaymentExportData."Recipient Bank Acc. No." := ''
        else
            FromPaymentExportData."Recipient Bank Acc. No." := CustomerBankAccount."Bank Account No.";
        if FromPaymentGenJournalLine."Applies-to ID" <> '' then begin
            CustLedgerEntry.SETRANGE("Customer No.", FromPaymentGenJournalLine."Account No.");
            CustLedgerEntry.SetRange("Applies-to ID", FromPaymentGenJournalLine."Applies-to ID");
            if CustLedgerEntry.FindSet() then
                repeat
                    ToTempLedgerEntryMatchingBuffer.Init();
                    ToTempLedgerEntryMatchingBuffer."Entry No." := CustLedgerEntry."Entry No.";
                    ToTempLedgerEntryMatchingBuffer."Account Type" := ToTempLedgerEntryMatchingBuffer."Account Type"::Customer;
                    ToTempLedgerEntryMatchingBuffer."Account No." := FromPaymentGenJournalLine."Account No.";
                    ToTempLedgerEntryMatchingBuffer."Document No." := CustLedgerEntry."Document No.";
                    ToTempLedgerEntryMatchingBuffer."Posting Date" := CustLedgerEntry."Posting Date";
                    ToTempLedgerEntryMatchingBuffer."MICA Applies-to ID" := FromPaymentGenJournalLine."Applies-to ID";
                    CustLedgerEntry.CalcFields("Remaining Amount");
                    ToTempLedgerEntryMatchingBuffer."Remaining Amount" := Abs(CustLedgerEntry."Remaining Amount");
                    ToTempLedgerEntryMatchingBuffer.Insert();
                until CustLedgerEntry.Next() = 0;
        end;
    end;

    local procedure SetVendorBuffer(var FromPaymentExportData: Record "Payment Export Data"; var FromPaymentGenJournalLine: record "Gen. Journal Line"; var ToTempLedgerEntryMatchingBuffer: record "Ledger Entry Matching Buffer" temporary)
    begin
        Vendor.Get(FromPaymentGenJournalLine."Account No.");
        VendorBankAccount.GET(Vendor."No.", FromPaymentGenJournalLine."Recipient Bank Account");
        FromPaymentExportData.SetVendorAsRecipient(Vendor, VendorBankAccount);
        FromPaymentExportData."Recipient Name" := Vendor."MICA English Name";
        FromPaymentExportData."Transit No." := VendorBankAccount."Transit No.";
        FromPaymentExportData."MICA Bank Account Type" := VendorBankAccount."MICA Bank Account Type";
        FromPaymentExportData."MICA Recipient VAT Reg. No." := Vendor."VAT Registration No.";
        FromPaymentExportData."Recipient Bank Clearing Code" := VendorBankAccount."Bank Clearing Code";
        FromPaymentExportData."Recipient Email Address" += '|' + Vendor."Fax No.";
        FromPaymentExportData."Recipient Acc. No." := Vendor."No.";
        FromPaymentExportData."Invoice Amount" := FromPaymentGenJournalLine.Amount;
        FromPaymentExportData."MICA Recipient IBAN" := DelChr(VendorBankAccount.IBAN, '=<>');
        if FromPaymentExportData."MICA Recipient IBAN" <> '' then
            FromPaymentExportData."Recipient Bank Acc. No." := ''
        else
            FromPaymentExportData."Recipient Bank Acc. No." := VendorBankAccount."Bank Account No.";
        if FromPaymentGenJournalLine."Applies-to ID" <> '' then begin
            VendorLedgerEntry.SetRange("Vendor No.", FromPaymentGenJournalLine."Account No.");
            VendorLedgerEntry.SetRange("Applies-to ID", FromPaymentGenJournalLine."Applies-to ID");
            if VendorLedgerEntry.FindSet() then
                repeat
                    ToTempLedgerEntryMatchingBuffer.Init();
                    ToTempLedgerEntryMatchingBuffer."Entry No." := VendorLedgerEntry."Entry No.";
                    ToTempLedgerEntryMatchingBuffer."Account Type" := ToTempLedgerEntryMatchingBuffer."Account Type"::Vendor;
                    ToTempLedgerEntryMatchingBuffer."Account No." := FromPaymentGenJournalLine."Account No.";
                    ToTempLedgerEntryMatchingBuffer."Document No." := CopyStr(GetVendorInvoiceNo(VendorLedgerEntry."Document No."), 1, MaxStrLen(ToTempLedgerEntryMatchingBuffer."Document No."));
                    if ToTempLedgerEntryMatchingBuffer."Document No." = '' then
                        ToTempLedgerEntryMatchingBuffer."Document No." := VendorLedgerEntry."Document No.";
                    ToTempLedgerEntryMatchingBuffer."Posting Date" := VendorLedgerEntry."Posting Date";
                    ToTempLedgerEntryMatchingBuffer."MICA Applies-to ID" := FromPaymentGenJournalLine."Applies-to ID";
                    VendorLedgerEntry.CalcFields("Remaining Amount");
                    ToTempLedgerEntryMatchingBuffer."Remaining Amount" := Abs(VendorLedgerEntry."Remaining Amount");
                    ToTempLedgerEntryMatchingBuffer.Insert();
                until VendorLedgerEntry.Next() = 0;
        end;
    end;

    local procedure SetEmployeeBuffer(var FromPaymentExportData: Record "Payment Export Data"; var FromPaymentGenJournalLine: record "Gen. Journal Line"; var ToTempLedgerEntryMatchingBuffer: record "Ledger Entry Matching Buffer" temporary)
    begin
        if Employee.Get(FromPaymentGenJournalLine."Account No.") then begin
            FromPaymentExportData.SetEmployeeAsRecipient(Employee);
            FromPaymentExportData."Recipient Bank Clearing Code" := Employee."MICA Ctry Credit Agent No.";
            FromPaymentExportData."Recipient Bank Country/Region" := Employee."MICA NCC";
            FromPaymentExportData."Recipient Email Address" += '|' + Employee."Fax No.";
            FromPaymentExportData."Recipient Acc. No." := Employee."No.";
            FromPaymentExportData."Recipient Bank Name" := Employee."MICA Bank Beneficiary Name";
            FromPaymentExportData."MICA Bank Account Type" := Employee."MICA Bank Account Type";
            FromPaymentExportData."Invoice Amount" := FromPaymentGenJournalLine.Amount;
            FromPaymentExportData."MICA Recipient VAT Reg. No." := Employee."MICA Employee VAT Reg. No.";
            FromPaymentExportData."MICA Recipient IBAN" := DelChr(Employee.IBAN, '=<>');
            if FromPaymentExportData."MICA Recipient IBAN" <> '' then
                FromPaymentExportData."Recipient Bank Acc. No." := ''
            else
                FromPaymentExportData."Recipient Bank Acc. No." := Employee."Bank Account No.";
            if FromPaymentGenJournalLine."Applies-to ID" <> '' then begin
                EmployeeLedgerEntry.SetRange("Employee No.", FromPaymentGenJournalLine."Account No.");
                EmployeeLedgerEntry.SetRange("Applies-to ID", FromPaymentGenJournalLine."Applies-to ID");
                if EmployeeLedgerEntry.FindSet() then
                    repeat
                        ToTempLedgerEntryMatchingBuffer.Init();
                        ToTempLedgerEntryMatchingBuffer."Entry No." := EmployeeLedgerEntry."Entry No.";
                        ToTempLedgerEntryMatchingBuffer."Account Type" := ToTempLedgerEntryMatchingBuffer."Account Type"::"G/L Account"; // Fake because option Employee does not exists
                        ToTempLedgerEntryMatchingBuffer."Account No." := FromPaymentGenJournalLine."Account No.";
                        ToTempLedgerEntryMatchingBuffer."Document No." := CopyStr(GetEmployeeExternalDocNo(EmployeeLedgerEntry."Entry No."), 1, MaxStrLen(ToTempLedgerEntryMatchingBuffer."Document No."));
                        if ToTempLedgerEntryMatchingBuffer."Document No." = '' then
                            ToTempLedgerEntryMatchingBuffer."Document No." := EmployeeLedgerEntry."Document No.";
                        ToTempLedgerEntryMatchingBuffer."Posting Date" := EmployeeLedgerEntry."Posting Date";
                        ToTempLedgerEntryMatchingBuffer."MICA Applies-to ID" := FromPaymentGenJournalLine."Applies-to ID";
                        EmployeeLedgerEntry.CalcFields("Remaining Amount");
                        ToTempLedgerEntryMatchingBuffer."Remaining Amount" := Abs(EmployeeLedgerEntry."Remaining Amount");
                        ToTempLedgerEntryMatchingBuffer.Insert();
                    until EmployeeLedgerEntry.Next() = 0;
            end;
        end;
    end;

    local procedure ValidatePaymentExportData(var FromPaymentExportData: Record "Payment Export Data"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        ValidatePaymentExportDataField(FromPaymentExportData, GenJournalLine, FromPaymentExportData.FieldName("Sender Bank Account No."));
        ValidatePaymentExportDataField(FromPaymentExportData, GenJournalLine, FromPaymentExportData.FieldName("Recipient Name"));
        if FromPaymentExportData."MICA Recipient IBAN" = '' then
            ValidatePaymentExportDataField(FromPaymentExportData, GenJournalLine, FromPaymentExportData.FieldName("Recipient Bank Acc. No."));
        ValidatePaymentExportDataField(FromPaymentExportData, GenJournalLine, FromPaymentExportData.FieldName("Transfer Date"));
        ValidatePaymentExportDataField(FromPaymentExportData, GenJournalLine, FromPaymentExportData.FieldName("Payment Information ID"));
        ValidatePaymentExportDataField(FromPaymentExportData, GenJournalLine, FromPaymentExportData.FieldName("End-to-End ID"));
    end;

    local procedure ValidatePaymentExportDataField(var PaymentExportData: Record "Payment Export Data"; var GenJournalLine: Record "Gen. Journal Line"; FieldName: Text)
    var
        "Field": Record Field;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecordRef.GETTABLE(PaymentExportData);
        Field.SETRANGE(TableNo, RecordRef.Number());
        Field.SETRANGE(FieldName, FieldName);
        Field.FindFirst();
        FieldRef := RecordRef.FIELD(Field."No.");
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
        PaymentExportData.AddGenJnlLineErrorText(GenJournalLine, STRSUBSTNO(FieldIsBlankErr, Field."Field Caption"));
    end;

    local procedure GetVendorInvoiceNo(DocumentNo: code[20]): Text
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        if PurchInvHeader.Get(DocumentNo) then
            exit(PurchInvHeader."Vendor Invoice No.");
    end;

    local procedure GetEmployeeExternalDocNo(EmpLedgerEntryNo: Integer): Text
    var
        GLEntry: Record "G/L Entry";
    begin
        if GLEntry.Get(EmpLedgerEntryNo) then
            exit(GLEntry."External Document No.");
    end;
}