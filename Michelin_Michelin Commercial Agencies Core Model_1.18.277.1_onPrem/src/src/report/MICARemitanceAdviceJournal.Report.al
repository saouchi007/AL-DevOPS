report 82301 "MICA Remitance Advice Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep82301.MICARemitanceAdviceJournal.rdl';
    Caption = 'Remittance Advice - Journal';
    UsageCategory = Documents;
    ApplicationArea = All;

    dataset
    {
        dataitem(FindVendors; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.";

            trigger OnAfterGetRecord()
            begin
                if ("Account Type" = "Account Type"::Vendor) and
                   ("Account No." <> '')
                then
                    if not TempVendor.Get("Account No.") then begin
                        FoundVendor.Get("Account No.");
                        TempVendor := FoundVendor;
                        TempVendor.Insert();
                    end;
            end;
        }
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                // Dataitem is here just to display request form - filters set by the user will be used later.
                CurrReport.BREAK();
            end;
        }
        dataitem(VendLoop; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(VendAddr1; VendorAddr[1])
            {
            }
            column(VendAddr2; VendorAddr[2])
            {
            }
            column(CompAddr1; CompanyAddr[1])
            {
            }
            column(CompAddr2; CompanyAddr[2])
            {
            }
            column(VendAddr3; VendorAddr[3])
            {
            }
            column(CompAddr3; CompanyAddr[3])
            {
            }
            column(VendorAddr4; VendorAddr[4])
            {
            }
            column(CompAddr4; CompanyAddr[4])
            {
            }
            column(VendAddr5; VendorAddr[5])
            {
            }
            column(CompAddr5; CompanyAddr[5])
            {
            }
            column(VendAddr6; VendorAddr[6])
            {
            }
            column(CompAddr6; CompanyAddr[6])
            {
            }
            column(VendAddr7; VendorAddr[7])
            {
            }
            column(CompInfoPhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(VendAddr8; VendorAddr[8])
            {
            }
            column(CompInfoFaxNo; CompanyInformation."Fax No.")
            {
            }
            column(CompInfoVATRegNo; CompanyInformation."VAT Registration No.")
            {
            }
            column(CompInfoBankName; CompanyInformation."Bank Name")
            {
            }
            column(CompInfoBankBranchNo; CompanyInformation."Bank Branch No.")
            {
            }
            column(CompInfoBankAccNo; CompanyInformation."Bank Account No.")
            {
            }
            column(VendLoopNumber; Number)
            {
            }
            column(RemittanceAdviceCaption; RemittanceAdviceCaptionLbl)
            {
            }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            column(FaxNoCaption; FaxNoCaptionLbl)
            {
            }
            column(VATRegNoCaption; VATRegNoCaptionLbl)
            {
            }
            column(BankCaption; BankCaptionLbl)
            {
            }
            column(SortCodeCaption; SortCodeCaptionLbl)
            {
            }
            column(AccNoCaption; AccNoCaptionLbl)
            {
            }
            column(OriginalAmtCaption; OriginalAmtCaptionLbl)
            {
            }
            column(DocDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(DocNoCaption; YourDocumentNoCaptionLbl)
            {
            }
            column(DocTypeCaption; DocTypeCaptionLbl)
            {
            }
            column(CheckNoCaption; OurDocumentNoCaptionLbl)
            {
            }
            column(RemainingAmtCaption; RemainingAmountCaptionLbl)
            {
            }
            column(PmdDiscRecCaption; PmtDiscReceivedCaptionLbl)
            {
            }
            column(PaidAmtCaption; PaymentCurrAmtCaptionLbl)
            {
            }
            column(CurrCodeCaption; CurrCodeCaptionLbl)
            {
            }
            dataitem("Gen. Journal Line"; "Gen. Journal Line")
            {
                DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.")
                                WHERE("Account Type" = CONST(Vendor));
                column(PostingDateTxt; PostingDate)
                {
                }
                column(GenJrnlLineNo; "Line No.")
                {
                }
                column(CompanyInfoPicture; CompanyInformation.Picture)
                {
                }
                column(CheckNo; CheckNo)
                {
                }
                column(Amt_GenJournalLine; Amount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrCode; CurrencyCode("Currency Code"))
                {
                }
                column(JnlBatchName_GenJournalLine; "Journal Batch Name")
                {
                }
                column(DocNo_GenJnlLine; "Document No.")
                {
                }
                column(AccNo_GenJournalLine; "Account No.")
                {
                }
                column(AppliestoDocType_GenJnlLine; "Applies-to Doc. Type")
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(PostingDateCaptionLbl; PostingDateCaptionLbl)
                {

                }
                column(Posting_Date; "Posting Date")
                {

                }
                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemLink = "Applies-to ID" = FIELD("Applies-to ID"),
                               "Vendor No." = FIELD("Account No.");
                    DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code")
                                    WHERE(Open = CONST(true));
                    dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                    {
                        DataItemLink = "Vendor Ledger Entry No." = FIELD("Entry No."),
                                   "Initial Document Type" = FIELD("Document Type");
                        DataItemTableView = SORTING("Vendor Ledger Entry No.", "Entry Type", "Posting Date")
                                        WHERE("Entry Type" = CONST(Application),
                                              "Document Type" = CONST("Credit Memo"));
                        trigger OnAfterGetRecord()
                        begin
                            FoundVendorLedgerEntry.GET("Applied Vend. Ledger Entry No.");
                            IF "Vendor Ledger Entry No." <> "Applied Vend. Ledger Entry No." THEN
                                InsertTempEntry(FoundVendorLedgerEntry);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        InsertTempEntry("Vendor Ledger Entry")
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF "Gen. Journal Line"."Applies-to ID" = '' THEN
                            CurrReport.BREAK();
                    end;
                }
                dataitem(VendLedgEntry2; "Vendor Ledger Entry")
                {
                    DataItemLink = "Document No." = FIELD("Applies-to Doc. No."),
                               "Vendor No." = FIELD("Account No."),
                               "Document Type" = FIELD("Applies-to Doc. Type");
                    DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date")
                                    WHERE(Open = CONST(true));
                    dataitem(DetailVendLedgEntry2; "Detailed Vendor Ledg. Entry")
                    {
                        DataItemLink = "Vendor Ledger Entry No." = FIELD("Entry No."),
                                   "Initial Document Type" = FIELD("Document Type");
                        DataItemTableView = SORTING("Vendor Ledger Entry No.", "Entry Type", "Posting Date")
                                        WHERE("Entry Type" = CONST(Application),
                                              "Document Type" = CONST("Credit Memo"));
                        trigger OnAfterGetRecord()
                        begin
                            FoundVendorLedgerEntry.GET("Applied Vend. Ledger Entry No.");
                            IF "Vendor Ledger Entry No." <> "Applied Vend. Ledger Entry No." THEN
                                InsertTempEntry(FoundVendorLedgerEntry);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        InsertTempEntry(VendLedgEntry2);
                    end;
                }
                dataitem(PrintLoop; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(AppliedVendLedgEntryTempDocType; FORMAT(TempAppliedVendorLedgerEntry."Document Type"))
                    {
                    }
                    column(AppliedVendLedgEntryTempExternalDocNo; TempAppliedVendorLedgerEntry."External Document No.")
                    {
                    }
                    column(AppliedVendLedgEntryTempDocDate; FORMAT(TempAppliedVendorLedgerEntry."Document Date"))
                    {
                    }
                    column(AppliedVendLedgEntryTempCurrCode; TempAppliedVendorLedgerEntry."Currency Code")
                    {
                    }
                    column(AppliedVendLedgEntryTempOriginalAmt; -TempAppliedVendorLedgerEntry."Original Amount")
                    {
                    }
                    column(AppliedVendLedgEntryTempRemainingAmt; -TempAppliedVendorLedgerEntry."Remaining Amount")
                    {
                    }
                    column(PmdDiscRec; PmdDiscRec)
                    {
                    }
                    column(PaidAmount; PaidAmount)
                    {
                    }
                    column(PrintLoopNumber; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Number = 1 THEN
                            TempAppliedVendorLedgerEntry.FIND('-')
                        ELSE
                            TempAppliedVendorLedgerEntry.NEXT();
                        IF JnlLineRemainingAmount < 0 THEN
                            CurrReport.SKIP();
                        TempAppliedVendorLedgerEntry.CALCFIELDS("Remaining Amount", "Original Amount");

                        // Currency
                        IF TempAppliedVendorLedgerEntry."Currency Code" <> "Gen. Journal Line"."Currency Code" THEN BEGIN
                            TempAppliedVendorLedgerEntry."Remaining Amount" :=
                              CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                                "Gen. Journal Line"."Posting Date",
                                TempAppliedVendorLedgerEntry."Currency Code",
                                "Gen. Journal Line"."Currency Code",
                                TempAppliedVendorLedgerEntry."Remaining Amount");
                            TempAppliedVendorLedgerEntry."Remaining Amount" := ROUND(TempAppliedVendorLedgerEntry."Remaining Amount", AmountRoundingPrecision);

                            TempAppliedVendorLedgerEntry."Amount to Apply" :=
                              CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                                "Gen. Journal Line"."Posting Date",
                                TempAppliedVendorLedgerEntry."Currency Code",
                                "Gen. Journal Line"."Currency Code",
                                TempAppliedVendorLedgerEntry."Amount to Apply");
                            TempAppliedVendorLedgerEntry."Amount to Apply" := ROUND(TempAppliedVendorLedgerEntry."Amount to Apply", AmountRoundingPrecision);

                            PmtDiscInvCurr := TempAppliedVendorLedgerEntry."Remaining Pmt. Disc. Possible";
                            TempAppliedVendorLedgerEntry."Remaining Pmt. Disc. Possible" :=
                              CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                                "Gen. Journal Line"."Posting Date",
                                TempAppliedVendorLedgerEntry."Currency Code", "Gen. Journal Line"."Currency Code",
                                TempAppliedVendorLedgerEntry."Original Pmt. Disc. Possible");
                            TempAppliedVendorLedgerEntry."Original Pmt. Disc. Possible" :=
                              ROUND(TempAppliedVendorLedgerEntry."Original Pmt. Disc. Possible", AmountRoundingPrecision);
                        END;

                        // Payment Discount
                        IF ("Gen. Journal Line"."Document Type" = "Gen. Journal Line"."Document Type"::Payment) AND
                           (TempAppliedVendorLedgerEntry."Document Type" IN
                            [TempAppliedVendorLedgerEntry."Document Type"::Invoice, TempAppliedVendorLedgerEntry."Document Type"::"Credit Memo"]) AND
                           ("Gen. Journal Line"."Posting Date" <= TempAppliedVendorLedgerEntry."Pmt. Discount Date") AND
                           (ABS(TempAppliedVendorLedgerEntry."Remaining Amount") >= ABS(TempAppliedVendorLedgerEntry."Remaining Pmt. Disc. Possible"))
                        THEN
                            PmdDiscRec := TempAppliedVendorLedgerEntry."Remaining Pmt. Disc. Possible"
                        ELSE
                            PmdDiscRec := 0;

                        TempAppliedVendorLedgerEntry."Remaining Amount" := TempAppliedVendorLedgerEntry."Remaining Amount" - PmdDiscRec;
                        TempAppliedVendorLedgerEntry."Amount to Apply" := TempAppliedVendorLedgerEntry."Amount to Apply" - PmdDiscRec;

                        IF TempAppliedVendorLedgerEntry."Remaining Amount" > 0 THEN
                            IF TempAppliedVendorLedgerEntry."Amount to Apply" < 0 THEN BEGIN
                                PaidAmount := -TempAppliedVendorLedgerEntry."Amount to Apply";
                                TempAppliedVendorLedgerEntry."Remaining Amount" := TempAppliedVendorLedgerEntry."Remaining Amount" - PaidAmount;
                            END ELSE BEGIN
                                PaidAmount := -TempAppliedVendorLedgerEntry."Amount to Apply";
                                TempAppliedVendorLedgerEntry."Remaining Amount" := TempAppliedVendorLedgerEntry."Remaining Amount" + PaidAmount;
                            END
                        ELSE BEGIN
                            IF ABS(TempAppliedVendorLedgerEntry."Remaining Amount") > ABS(JnlLineRemainingAmount) THEN
                                IF TempAppliedVendorLedgerEntry."Amount to Apply" < 0 THEN
                                    PaidAmount := ABS(TempAppliedVendorLedgerEntry."Amount to Apply")
                                ELSE
                                    PaidAmount := ABS(JnlLineRemainingAmount)
                            ELSE
                                IF TempAppliedVendorLedgerEntry."Amount to Apply" < 0 THEN
                                    PaidAmount := ABS(TempAppliedVendorLedgerEntry."Amount to Apply")
                                ELSE
                                    PaidAmount := ABS(TempAppliedVendorLedgerEntry."Remaining Amount");
                            TempAppliedVendorLedgerEntry."Remaining Amount" := TempAppliedVendorLedgerEntry."Remaining Amount" + PaidAmount;
                            JnlLineRemainingAmount := JnlLineRemainingAmount - PaidAmount;
                            IF JnlLineRemainingAmount < 0 THEN BEGIN
                                TempAppliedVendorLedgerEntry."Remaining Amount" := TempAppliedVendorLedgerEntry."Remaining Amount" + JnlLineRemainingAmount;
                                PaidAmount := PaidAmount + TempAppliedVendorLedgerEntry."Remaining Amount";
                            END;
                        END;

                        // Numbers to print
                        IF TempAppliedVendorLedgerEntry."Currency Code" <> "Gen. Journal Line"."Currency Code" THEN
                            IF PmdDiscRec <> 0 THEN
                                PmdDiscRec := PmtDiscInvCurr;
                        TempAppliedVendorLedgerEntry."Remaining Amount" :=
                          CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                            "Gen. Journal Line"."Posting Date",
                            "Gen. Journal Line"."Currency Code",
                            TempAppliedVendorLedgerEntry."Currency Code",
                            TempAppliedVendorLedgerEntry."Remaining Amount");

                    end;

                    trigger OnPostDataItem()
                    begin
                        TempAppliedVendorLedgerEntry.DELETEALL();
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE(Number, 1, TempAppliedVendorLedgerEntry.COUNT());
                        JnlLineRemainingAmount := JnlLineRemainingAmount + AppliedDebitAmounts;
                    end;
                }


                trigger OnAfterGetRecord()
                var
                    PostingDateLbl: Label ' %1 %2   %3', Comment = '%1%2%3', Locked = true;
                begin
                    IF "Document No." <> CheckNo THEN BEGIN
                        JnlLineRemainingAmount := 0;
                        AppliedDebitAmounts := 0;
                    END;

                    PostingDate := STRSUBSTNO(PostingDateLbl,
                      FORMAT("Gen. Journal Line"."Posting Date", 3, '<Day,2>'),
                      FORMAT("Gen. Journal Line"."Posting Date", 4, '<Month,2>'),
                      FORMAT("Gen. Journal Line"."Posting Date", 4, '<Year4>'));

                    CheckNo := "Document No.";
                    JnlLineRemainingAmount := JnlLineRemainingAmount + Amount;

                    FindAmountRounding();
                    AppliedDebitAmounts := 0;
                end;

                trigger OnPreDataItem()
                begin
                    CopyFilters(FindVendors);
                    SetRange("Account No.", TempVendor."No.");
                end;
            }
            dataitem(PrintTotal; Integer)
            {
                DataItemTableView = WHERE(Number = CONST(1));
                column(PrintTotalNumber; PrintTotal.Number)
                {
                }
                column(TotalCurrCode; CurrencyCode("Gen. Journal Line"."Currency Code"))
                {
                }

            }
            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempVendor.Find('-')
                else
                    TempVendor.Next();

                FormatAddress.Vendor(VendorAddr, TempVendor);

                JnlLineRemainingAmount := 0;
            end;

            trigger OnPreDataItem()
            begin
                TempVendor.CopyFilters(Vendor);
                SetRange(Number, 1, TempVendor.Count());
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        VendorLbl = 'Vendor:';
        DateLbl = 'DAY  MONTH YEAR';
        ReferenceLbl = 'Reference';
    }

    trigger OnPreReport()
    begin
        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);
        FormatAddress.Company(CompanyAddr, CompanyInformation);
        GeneralLedgerSetup.GET();
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        CompanyInformation: Record "Company Information";
        FoundVendor: Record Vendor;
        TempVendor: Record Vendor temporary;
        TempAppliedVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        FoundVendorLedgerEntry: Record "Vendor Ledger Entry";
        FormatAddress: Codeunit "Format Address";
        JnlLineRemainingAmount: Decimal;
        AmountRoundingPrecision: Decimal;
        PmdDiscRec: Decimal;
        PmtDiscInvCurr: Decimal;
        PaidAmount: Decimal;
        AppliedDebitAmounts: Decimal;
        VendorAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        CheckNo: Code[20];
        RemittanceAdviceCaptionLbl: Label 'Remittance Advice';
        PhoneNoCaptionLbl: Label 'Phone No.';
        FaxNoCaptionLbl: Label 'Fax No.';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        BankCaptionLbl: Label 'Bank';
        SortCodeCaptionLbl: Label 'Sort Code';
        AccNoCaptionLbl: Label 'Account No.';
        OriginalAmtCaptionLbl: Label 'Original Amount';
        DocumentDateCaptionLbl: Label 'Document Date';
        YourDocumentNoCaptionLbl: Label 'Your Document No.';
        DocTypeCaptionLbl: Label 'Doc. Type';
        OurDocumentNoCaptionLbl: Label 'Our Document No.';
        RemainingAmountCaptionLbl: Label 'Remaining Amount';
        PmtDiscReceivedCaptionLbl: Label 'Pmt. Disc. Received';
        PaymentCurrAmtCaptionLbl: Label 'Payment Curr. Amount';
        CurrCodeCaptionLbl: Label 'Curr. Code';
        TotalCaptionLbl: Label 'Total';
        PostingDateCaptionLbl: Label 'Posting Date';
        PostingDate: Text;

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        IF SrcCurrCode = '' THEN
            EXIT(GeneralLedgerSetup."LCY Code");

        EXIT(SrcCurrCode);
    end;

    local procedure FindAmountRounding()
    begin
        IF "Gen. Journal Line"."Currency Code" = '' THEN BEGIN
            Currency.INIT();
            Currency.Code := '';
            Currency.InitRoundingPrecision();
        END ELSE
            IF "Gen. Journal Line"."Currency Code" <> Currency.Code THEN
                Currency.GET("Gen. Journal Line"."Currency Code");

        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;

    local procedure InsertTempEntry(ToInsertVendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        AppAmt: Decimal;
    begin
        TempAppliedVendorLedgerEntry := ToInsertVendorLedgerEntry;
        IF TempAppliedVendorLedgerEntry.INSERT() THEN BEGIN
            // Find Debit amounts, e.g. credit memos
            TempAppliedVendorLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
            IF TempAppliedVendorLedgerEntry."Remaining Amt. (LCY)" > 0 THEN BEGIN
                JnlLineRemainingAmount += TempAppliedVendorLedgerEntry."Amount to Apply";
                AppAmt := TempAppliedVendorLedgerEntry."Remaining Amt. (LCY)";
                IF "Gen. Journal Line"."Currency Code" <> '' THEN BEGIN
                    AppAmt :=
                      CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                        "Gen. Journal Line"."Posting Date",
                        "Gen. Journal Line"."Currency Code",
                        AppAmt,
                        "Gen. Journal Line"."Currency Factor");
                    AppAmt := ROUND(AppAmt, AmountRoundingPrecision);
                END;
                AppliedDebitAmounts := AppliedDebitAmounts + AppAmt;
            END;
        END;
    end;
}

