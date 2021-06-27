xmlport 81800 "MICA MonthlyIntercoInvoices"
{
    Caption = 'Monthly Statement of Interco Invoices';
    Direction = Export;
    Format = FixedText;
    RecordSeparator = '<NewLine>';
    TableSeparator = '<None>';
    UseRequestPage = false;
    TextEncoding = MSDOS;

    schema
    {
        textelement(Root)
        {
            tableelement(CustomerBuffer; Customer)
            {
                UseTemporary = true;

                textelement(First_BlockType)
                {
                    Width = 2;
                }
                textelement(First_SellingCompanyConsCode)
                {
                    Width = 3;
                }
                textelement(First_BuyingCompanyConsCode)
                {
                    Width = 3;
                }
                textelement(First_InvoicingMonth)
                {
                    Width = 6;
                }
                textelement(First_SendingPelicanCode)
                {
                    Width = 8;
                }
                textelement(First_AppPelicanCode)
                {
                    Width = 4;
                }
                textelement(First_InvCenter)
                {
                    Width = 2;
                }
                textelement(First_Reserve)
                {
                    Width = 28;
                }
                textelement(FirstEndOfLine)
                {
                    Width = 2;
                }
                textelement(CustomerCurrency)
                {
                    tableelement(CustomerCurrencyBuffer; "MICA Customer Currency Buffer")
                    {
                        UseTemporary = true;
                        LinkTable = CustomerBuffer;
                        LinkFields = "Customer No." = field("No.");

                        textelement(Second_BlockType)
                        {
                            Width = 2;
                        }
                        textelement(Second_SellingCompanyConsCode)
                        {
                            Width = 3;
                        }
                        textelement(Second_BuyingCompanyConsCode)
                        {
                            Width = 3;
                        }
                        textelement(Second_InvoicingCurrencyCode)
                        {
                            Width = 3;
                        }
                        textelement(Second_Sign)
                        {
                            Width = 1;
                        }
                        textelement(Second_MonthlyTotal)
                        {
                            Width = 15;
                        }
                        textelement(Second_Reserve)
                        {
                            Width = 29;
                        }
                        textelement(SecondEndOfLine)
                        {
                            Width = 2;
                        }
                        textelement(Details)
                        {
                            tableelement(DocumentBuffer; "Sales Line")
                            {
                                UseTemporary = true;
                                LinkTable = CustomerCurrencyBuffer;
                                LinkFields = "Bill-To Customer No." = field("Customer No."),
                                             "Currency Code" = field("Currency Code");
                                textelement(Third_BlockType)
                                {
                                    Width = 2;
                                }
                                textelement(Third_SellingCompanyConsCode)
                                {
                                    Width = 3;
                                }
                                textelement(Third_BuyingCompanyConsCode)
                                {
                                    Width = 3;
                                }
                                textelement(Third_DocumentDate)
                                {
                                    Width = 8;
                                }
                                textelement(Third_DocumentType)
                                {
                                    Width = 3;
                                }
                                textelement(Third_DocumentNumber)
                                {
                                    Width = 12;
                                }
                                textelement(Third_DocumentCurrencyCode)
                                {
                                    Width = 3;
                                }
                                textelement(Third_ProductTypeCode)
                                {
                                    Width = 2;
                                }
                                textelement(Third_Sign)
                                {
                                    Width = 1;
                                }
                                textelement(Third_InvoiceAmount)
                                {
                                    Width = 15;
                                }
                                textelement(Third_Reserve)
                                {
                                    Width = 4;
                                }

                                trigger OnAfterGetRecord()
                                begin
                                    Third_BlockType := '03';
                                    Third_SellingCompanyConsCode := MICAFinancialReportingSetup."Company Code";
                                    Third_BuyingCompanyConsCode := CustomerBuffer."No.";
                                    Third_DocumentDate := Format(DocumentBuffer."FA Posting Date", 0, '<Year4,4><Month,2><Day,2>');
                                    case DocumentBuffer."Document Type" of
                                        DocumentBuffer."Document Type"::Invoice:
                                            begin
                                                Third_DocumentType := 'INV';
                                                clear(Third_Sign);
                                            end;
                                        DocumentBuffer."Document Type"::"Credit Memo":
                                            begin
                                                Third_DocumentType := 'AVO';
                                                Third_Sign := 'N';
                                            end;

                                    end;
                                    if MICAFinancialReportingSetup."RelFact Extract Ext. Doc." then begin
                                        Third_DocumentNumber := DocumentBuffer."Purchase Order No."; // "External Document No."
                                        if Third_DocumentNumber = '' then
                                            Third_DocumentNumber := DocumentBuffer."Document No.";
                                    end else
                                        Third_DocumentNumber := DocumentBuffer."Document No.";
                                    Third_DocumentCurrencyCode := DocumentBuffer."Currency Code";
                                    Third_ProductTypeCode := DocumentBuffer."MICA Product Type Code";
                                    Third_InvoiceAmount := DelChr(Format(ABS(DocumentBuffer.Amount), 0, '<Precision,2:2><Integer><Decimals>'), '=', '.,').PadLeft(15, '0');
                                end;
                            }
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Second_BlockType := '02';
                            Second_SellingCompanyConsCode := MICAFinancialReportingSetup."Company Code";
                            Second_BuyingCompanyConsCode := CustomerBuffer."No.";
                            Second_InvoicingCurrencyCode := CustomerCurrencyBuffer."Currency Code";
                            if CustomerCurrencyBuffer.Amount < 0 then
                                Second_Sign := 'N';
                            Second_MonthlyTotal := DelChr(Format(ABS(CustomerCurrencyBuffer.Amount), 0, '<Precision,2:2><Integer><Decimals>'), '=', '.,').PadLeft(15, '0');

                            SecondEndOfLine := EOL;
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    First_BlockType := '01';
                    First_SellingCompanyConsCode := MICAFinancialReportingSetup."Company Code";
                    First_BuyingCompanyConsCode := CustomerBuffer."No.";
                    First_InvoicingMonth := InvoicingMonth;
                    First_SendingPelicanCode := MICAFinancialReportingSetup."Pelican Code-Sending Company";
                    First_AppPelicanCode := 'F322';

                    FirstEndOfLine := EOL;
                end;
            }
        }
    }

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        EOL: Text[2];
        InvoicingMonth: Text[6];
        MonthStartDate: Date;
        MonthEndDate: Date;

    trigger OnPreXmlPort()
    begin
        EOL[1] := 13;
        EOL[2] := 10;
        MICAFinancialReportingSetup.Get();
        GenerateData();
    end;

    procedure SetInvoicingMonth(NewInvoicingMonth: Text[6])
    var
        EvaluationInt: array[2] of Integer;
    begin
        InvoicingMonth := NewInvoicingMonth;

        Evaluate(EvaluationInt[1], NewInvoicingMonth.Substring(5));
        Evaluate(EvaluationInt[2], NewInvoicingMonth.Substring(1, 4));

        MonthStartDate := DMY2Date(1, EvaluationInt[1], EvaluationInt[2]);
        MonthEndDate := CalcDate('<CM>', MonthStartDate);
    end;

    local procedure GenerateData()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Customer: Record Customer;
        CustConsolidationCode: Code[20];
    begin
        SalesInvoiceHeader.SetCurrentKey("Bill-to Customer No.");
        SalesInvoiceHeader.SetRange("Posting Date", MonthStartDate, MonthEndDate);
        if SalesInvoiceHeader.FindSet() then
            repeat
                IF Customer.GET(SalesInvoiceHeader."Bill-to Customer No.") AND (Customer."MICA Party Ownership" = Customer."MICA Party Ownership"::Group) then begin
                    CustConsolidationCode := GetCustomerDimValueFromCLE(SalesInvoiceHeader."Bill-to Customer No.", false, SalesInvoiceHeader."No.");
                    UpdateCustomerBuffer(CustConsolidationCode);

                    SalesInvoiceHeader.CalcFields("Amount Including VAT");
                    UpdateCustCurrBuffer(CustConsolidationCode, SalesInvoiceHeader."Currency Code", SalesInvoiceHeader."Amount Including VAT");
                    UpdateDocumentBufferFromInvoice(CustConsolidationCode, SalesInvoiceHeader);
                end;
            until SalesInvoiceHeader.Next() = 0;

        SalesCrMemoHeader.SetCurrentKey("Bill-to Customer No.");
        SalesCrMemoHeader.SetRange("Posting Date", MonthStartDate, MonthEndDate);
        if SalesCrMemoHeader.FindSet() then
            repeat
                IF Customer.GET(SalesCrMemoHeader."Bill-to Customer No.") AND (Customer."MICA Party Ownership" = Customer."MICA Party Ownership"::Group) then begin
                    CustConsolidationCode := GetCustomerDimValueFromCLE(SalesInvoiceHeader."Bill-to Customer No.", false, SalesInvoiceHeader."No.");
                    UpdateCustomerBuffer(CustConsolidationCode);

                    SalesCrMemoHeader.CalcFields("Amount Including VAT");
                    UpdateCustCurrBuffer(CustConsolidationCode, SalesCrMemoHeader."Currency Code", -SalesCrMemoHeader."Amount Including VAT");
                    UpdateDocumentBufferFromCrMemo(CustConsolidationCode, SalesCrMemoHeader);
                end;
            until SalesCrMemoHeader.Next() = 0;
    end;

    local procedure GetCustomerDimValueFromCLE(CustomerNo: Code[20]; IsCrMemo: Boolean; DocumentNo: Code[20]): Code[20]
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TempDimensionSetEntry: Record "Dimension Set Entry" Temporary;
        DimensionManagement: Codeunit DimensionManagement;
    begin
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        if not IsCrMemo then
            CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice)
        else
            CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        if CustLedgerEntry.FindFirst() then begin
            DimensionManagement.GetDimensionSet(TempDimensionSetEntry, CustLedgerEntry."Dimension Set ID");
            TempDimensionSetEntry.SetRange("Dimension Code", MICAFinancialReportingSetup."Intercompany Dimension");
            if TempDimensionSetEntry.FindFirst() then
                exit(TempDimensionSetEntry."Dimension Value Code");
        end;
    end;

    local procedure UpdateCustomerBuffer(CustomerNo: Code[20])
    begin
        if not CustomerBuffer.get(CustomerNo) then begin
            CustomerBuffer.Init();
            CustomerBuffer."No." := CustomerNo;
            CustomerBuffer.Insert();
        end;
    end;

    local procedure UpdateCustCurrBuffer(CustomerNo: Code[20]; CurrencyCode: Code[20]; Amount: Decimal)
    begin
        if not CustomerCurrencyBuffer.get(CustomerNo, CurrencyCode) then begin
            CustomerCurrencyBuffer.Init();
            CustomerCurrencyBuffer."Customer No." := CustomerNo;
            CustomerCurrencyBuffer."Currency Code" := CurrencyCode;
            CustomerCurrencyBuffer.Insert();
        end;
        CustomerCurrencyBuffer.Amount += Amount;
        CustomerCurrencyBuffer.Modify();
    end;

    local procedure UpdateDocumentBufferFromInvoice(CustConsolidationCode: Code[20]; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
    begin
        if not DocumentBuffer.get(DocumentBuffer."Document Type"::Invoice, SalesInvoiceHeader."No.") then begin
            DocumentBuffer.Init();
            DocumentBuffer."Bill-to Customer No." := CustConsolidationCode;
            DocumentBuffer."FA Posting Date" := SalesInvoiceHeader."Posting Date";
            DocumentBuffer."Document Type" := DocumentBuffer."Document Type"::Invoice;
            DocumentBuffer."Document No." := SalesInvoiceHeader."No.";
            DocumentBuffer."Currency Code" := SalesInvoiceHeader."Currency Code";
            DocumentBuffer."Purchase Order No." := CopyStr(SalesInvoiceHeader."External Document No.", 1, MaxStrLen(DocumentBuffer."Purchase Order No."));
            SalesInvoiceLine.Setrange("Document No.", SalesInvoiceHeader."No.");
            SalesInvoiceLine.SetFilter(Type, '<>%1', SalesInvoiceLine.Type::" ");
            if SalesInvoiceLine.FindFirst() And GenProductPostingGroup.GET(SalesInvoiceLine."Gen. Prod. Posting Group") then
                DocumentBuffer."MICA Product Type Code" := CopyStr(GenProductPostingGroup."MICA Product Type", 1, 2);

            DocumentBuffer.Amount := SalesInvoiceHeader."Amount Including VAT";
            DocumentBuffer.Insert(false);
        end;
    end;

    local procedure UpdateDocumentBufferFromCrMemo(CustConsolidationCode: Code[20]; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
    begin
        if not DocumentBuffer.get(DocumentBuffer."Document Type"::"Credit Memo", SalesCrMemoHeader."No.") then begin
            DocumentBuffer.Init();
            DocumentBuffer."Bill-to Customer No." := CustConsolidationCode;
            DocumentBuffer."FA Posting Date" := SalesCrMemoHeader."Posting Date";
            DocumentBuffer."Document Type" := DocumentBuffer."Document Type"::"Credit Memo";
            DocumentBuffer."Document No." := SalesCrMemoHeader."No.";
            DocumentBuffer."Currency Code" := SalesCrMemoHeader."Currency Code";
            DocumentBuffer."Purchase Order No." := CopyStr(SalesCrMemoHeader."External Document No.", 1, MaxStrLen(DocumentBuffer."Purchase Order No."));
            SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
            SalesCrMemoLine.SetFilter(Type, '<>%1', SalesCrMemoLine.Type::" ");
            if SalesCrMemoLine.FindFirst() And GenProductPostingGroup.GET(SalesCrMemoLine."Gen. Prod. Posting Group") then
                DocumentBuffer."MICA Product Type Code" := CopyStr(GenProductPostingGroup."MICA Product Type", 1, 2);

            DocumentBuffer.Amount := SalesCrMemoHeader."Amount Including VAT";
            DocumentBuffer.Insert(false);
        end;
    end;
}