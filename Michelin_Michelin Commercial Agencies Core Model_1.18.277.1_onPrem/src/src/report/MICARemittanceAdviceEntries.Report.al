report 82300 "MICA Remittance Advice Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep82300.MICARemittanceAdviceEntries.rdl';
    Caption = 'Remittance Advice - Entries';
    UsageCategory = Documents;
    ApplicationArea = All;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Vendor No.")
                                WHERE("Document Type" = CONST(Payment));
            RequestFilterFields = "Vendor No.", "Document No.", "Posting Date", "Currency Code", "Entry No.";
            column(CompanyInfoPicture; CompanyInformation.Picture)
            {
            }
            column(PostingDateTxt; PostingDate)
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(VendorAddr1; VendorAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(VendorAddr2; VendorAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(VendorAddr3; VendorAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(VendorAddr4; VendorAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            column(VendorAddr5; VendorAddr[5])
            {
            }
            column(VendorAddr6; VendorAddr[6])
            {
            }
            column(CompanyInfoPhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(VendorAddr7; VendorAddr[7])
            {
            }
            column(CompanyInfoVATRegNo; CompanyInformation."VAT Registration No.")
            {
            }
            column(CompanyInfoFaxNo; CompanyInformation."Fax No.")
            {
            }
            column(VendorAddr8; VendorAddr[8])
            {
            }
            column(CompanyInfoBankName; CompanyInformation."Bank Name")
            {
            }
            column(CompanyInfoBankAccNo; CompanyInformation."Bank Account No.")
            {
            }
            column(CompanyInfoBankBranchNo; CompanyInformation."Bank Branch No.")
            {
            }
            column(DocNo_VendLedgEntry; "Document No.")
            {
            }
            column(EntryNo_VendLedgEntry; "Entry No.")
            {
            }
            column(VendorLedgerEntryVendorNo; "Vendor No.")
            {
            }
            column(RemittanceAdviceCaption; RemittanceAdvCaptionLbl)
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
            column(BankNameCaption; BankCaptionLbl)
            {
            }
            column(BankAccountNoCaption; AccNoCaptionLbl)
            {
            }
            column(SortCodeCaption; SortCodeCaptionLbl)
            {
            }
            column(AmountCaption; AmtCaptionLbl)
            {
            }
            column(PmtDiscTakenCaption; PmtDiscTakenCaptionLbl)
            {
            }
            column(RemainingAmtCaption; RemAmtCaptionLbl)
            {
            }
            column(OriginalAmountCaption; OriginalAmtCaptionLbl)
            {
            }
            column(YourDocNoCaption; YourDocNoCaptionLbl)
            {
            }
            column(DocTypeCaption_VendLedgEntry2; VendLedgEntry2.FIELDCAPTION("Document Type"))
            {
            }
            column(OurDocNoCaption; OurDocNoCaptionLbl)
            {
            }
            column(CurrCodeCaption; CurrCodeCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocDateCaptionLbl)
            {
            }
            dataitem(VendLedgEntry2; "Vendor Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.");
                column(LineAmtLineDiscCurr; -LineAmount - LineDiscount)
                {
                    AutoFormatExpression = "Vendor Ledger Entry"."Currency Code";
                    AutoFormatType = 1;
                }
                column(NegAmount_VendLedgEntry2; -Amount)
                {
                    AutoFormatExpression = "Vendor Ledger Entry"."Currency Code";
                    AutoFormatType = 1;
                }
                column(RemAmt_VendLedgEntry2; -"Remaining Amount")
                {
                    AutoFormatExpression = "Vendor Ledger Entry"."Currency Code";
                    AutoFormatType = 1;
                }
                column(DocType_VendLedgEntry2; "Document Type")
                {
                }
                column(ExtDocNo_VendLedgEntry2; "External Document No.")
                {
                }
                column(LineDiscount_VendLedgEntry2; -LineDiscount)
                {
                    AutoFormatExpression = "Vendor Ledger Entry"."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrCode_VendLedgEntry2; CurrencyCode("Currency Code"))
                {
                }
                column(DocDateFormat_VendLedgEntry2; FORMAT("Document Date"))
                {
                }
                column(LAmountWDiscCur; LAmountWDiscCur)
                {
                }
                column(EntryNo_VendLedgEntry2; "Entry No.")
                {
                }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No." = FIELD("Entry No."),
                                   "Initial Document Type" = FIELD("Document Type");
                    DataItemTableView = SORTING("Vendor Ledger Entry No.", "Entry Type", "Posting Date")
                                        WHERE("Entry Type" = CONST(Application),
                                              "Document Type" = CONST("Credit Memo"));
                    column(LineDisc_DtldVendLedgEntry; -LineDiscount)
                    {
                        AutoFormatExpression = "Vendor Ledger Entry"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntry3RemAmt; -FoundVendorLedgerEntry."Remaining Amount")
                    {
                        AutoFormatExpression = "Vendor Ledger Entry"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Amt_DtldVendLedgEntry; -Amount)
                    {
                        AutoFormatExpression = "Vendor Ledger Entry"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntry3CurrCode; CurrencyCode(FoundVendorLedgerEntry."Currency Code"))
                    {
                    }
                    column(VendLedgEntry3DocDateFormat; FORMAT(FoundVendorLedgerEntry."Document Date"))
                    {
                    }
                    column(VendLedgEntry3ExtDocNo; FoundVendorLedgerEntry."External Document No.")
                    {
                    }
                    column(DocType_DtldVendLedgEntry; "Document Type")
                    {
                    }
                    column(VendLedgerEntryNo_DtldVendLedgEntry; "Vendor Ledger Entry No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        FoundVendorLedgerEntry.GET("Applied Vend. Ledger Entry No.");
                        IF "Vendor Ledger Entry No." = "Applied Vend. Ledger Entry No." THEN
                            CurrReport.SKIP();
                        FoundVendorLedgerEntry.CALCFIELDS(Amount, "Remaining Amount");
                        LineAmount := FoundVendorLedgerEntry.Amount - FoundVendorLedgerEntry."Remaining Amount";
                        LineDiscount :=
                          CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                            "Posting Date", '', "Currency Code",
                            FoundVendorLedgerEntry."Pmt. Disc. Rcd.(LCY)");
                        LineDiscountCurr :=
                          CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                            FoundVendorLedgerEntry."Posting Date", '', "Vendor Ledger Entry"."Currency Code",
                            FoundVendorLedgerEntry."Pmt. Disc. Rcd.(LCY)");

                        FoundVendorLedgerEntry.Amount :=
                          FoundVendorLedgerEntry.Amount + LineDiscountCurr;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                begin
                    CALCFIELDS(Amount, "Remaining Amount");
                    DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", "Entry No.");
                    DtldVendLedgEntry.SETRANGE("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
                    DtldVendLedgEntry.SETRANGE("Document Type", DtldVendLedgEntry."Document Type"::Payment);
                    DtldVendLedgEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                    IF NOT DtldVendLedgEntry.FINDFIRST() THEN
                        CurrReport.SKIP();
                    LineAmount := DtldVendLedgEntry.Amount;
                    LineDiscount := CurrencyExchangeRate.ExchangeAmtFCYToFCY("Posting Date", '', "Currency Code", "Pmt. Disc. Rcd.(LCY)");

                    "Vendor Ledger Entry".Amount += LineDiscount;

                    LAmountWDiscCur := -LineAmount - LineDiscount;
                end;

                trigger OnPreDataItem()
                begin
                    CreateVendorLedgerEntry := "Vendor Ledger Entry";
                    FindApplnEntriesDtldtLedgEntry();
                    SETCURRENTKEY("Entry No.");
                    SETRANGE("Entry No.");

                    IF CreateVendorLedgerEntry."Closed by Entry No." <> 0 THEN BEGIN
                        "Entry No." := CreateVendorLedgerEntry."Closed by Entry No.";
                        MARK(TRUE);
                    END;

                    SETCURRENTKEY("Closed by Entry No.");
                    SETRANGE("Closed by Entry No.", CreateVendorLedgerEntry."Entry No.");
                    IF FIND('-') THEN
                        REPEAT
                            MARK(TRUE);
                        UNTIL NEXT() = 0;

                    SETCURRENTKEY("Entry No.");
                    SETRANGE("Closed by Entry No.");
                    MARKEDONLY(TRUE);
                end;
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(Amount_VendLedgEntry; "Vendor Ledger Entry".Amount)
                {
                    AutoFormatExpression = "Vendor Ledger Entry"."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrCode_VendLedgEntry; CurrencyCode("Vendor Ledger Entry"."Currency Code"))
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(TotalRemainingAmount; TotalRemainingAmt)
                {
                }
                column(TotalPmdDiscReceived; TotalPmdDiscRec)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                PostingDateLbl: Label ' %1 %2   %3', Comment = '%1%2%3', Locked = true;
            begin
                FoundVendor.GET("Vendor No.");
                FormatAddress.Vendor(VendorAddr, FoundVendor);
                CALCFIELDS(Amount);

                PostingDate := STRSUBSTNO(PostingDateLbl,
                  FORMAT("Posting Date", 3, '<Day,2>'),
                  FORMAT("Posting Date", 4, '<Month,2>'),
                  FORMAT("Posting Date", 4, '<Year4>'));
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
        GeneralLedgerSetup.TESTFIELD("LCY Code");
    end;

    var
        FoundVendor: Record Vendor;
        CompanyInformation: Record "Company Information";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CreateVendorLedgerEntry: Record "Vendor Ledger Entry";
        FoundVendorLedgerEntry: Record "Vendor Ledger Entry";
        FormatAddress: Codeunit "Format Address";
        VendorAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        LineDiscountCurr: Decimal;
        LAmountWDiscCur: Decimal;
        RemittanceAdvCaptionLbl: Label 'Remittance Advice';
        PhoneNoCaptionLbl: Label 'Phone No.';
        FaxNoCaptionLbl: Label 'Fax No.';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        BankCaptionLbl: Label 'Bank';
        AccNoCaptionLbl: Label 'Account No.';
        SortCodeCaptionLbl: Label 'Sort Code';
        AmtCaptionLbl: Label 'Amount';
        PmtDiscTakenCaptionLbl: Label 'Pmt. Disc. Taken';
        RemAmtCaptionLbl: Label 'Remaining Amount';
        OriginalAmtCaptionLbl: Label 'Original Amount';
        YourDocNoCaptionLbl: Label 'Your Document No.';
        OurDocNoCaptionLbl: Label 'Our Document No.';
        CurrCodeCaptionLbl: Label 'Curr. Code';
        DocDateCaptionLbl: Label 'Document Date';
        TotalCaptionLbl: Label 'Total';
        PostingDate: Text;
        TotalRemainingAmt: Decimal;
        TotalPmdDiscRec: Decimal;

    procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        IF SrcCurrCode = '' THEN
            EXIT(GeneralLedgerSetup."LCY Code");

        EXIT(SrcCurrCode);
    end;

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        FoundDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        SetDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        FoundDetailedVendorLedgEntry.RESET();
        FoundDetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.");
        FoundDetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.", CreateVendorLedgerEntry."Entry No.");
        FoundDetailedVendorLedgEntry.SETRANGE(Unapplied, FALSE);
        IF FoundDetailedVendorLedgEntry.FIND('-') THEN
            REPEAT
                IF FoundDetailedVendorLedgEntry."Vendor Ledger Entry No." =
                   FoundDetailedVendorLedgEntry."Applied Vend. Ledger Entry No."
                THEN BEGIN
                    SetDetailedVendorLedgEntry.RESET();
                    SetDetailedVendorLedgEntry.SETCURRENTKEY("Applied Vend. Ledger Entry No.", "Entry Type");
                    SetDetailedVendorLedgEntry.SETRANGE(
                      "Applied Vend. Ledger Entry No.", FoundDetailedVendorLedgEntry."Applied Vend. Ledger Entry No.");
                    SetDetailedVendorLedgEntry.SETRANGE("Entry Type", SetDetailedVendorLedgEntry."Entry Type"::Application);
                    SetDetailedVendorLedgEntry.SETRANGE(Unapplied, FALSE);
                    IF SetDetailedVendorLedgEntry.FIND('-') THEN
                        REPEAT
                            IF SetDetailedVendorLedgEntry."Vendor Ledger Entry No." <>
                               SetDetailedVendorLedgEntry."Applied Vend. Ledger Entry No."
                            THEN BEGIN
                                VendLedgEntry2.SETCURRENTKEY("Entry No.");
                                VendLedgEntry2.SETRANGE("Entry No.", SetDetailedVendorLedgEntry."Vendor Ledger Entry No.");
                                IF VendLedgEntry2.FIND('-') THEN
                                    VendLedgEntry2.MARK(TRUE);
                            END;
                        UNTIL SetDetailedVendorLedgEntry.NEXT() = 0;
                END ELSE BEGIN
                    VendLedgEntry2.SETCURRENTKEY("Entry No.");
                    VendLedgEntry2.SETRANGE("Entry No.", FoundDetailedVendorLedgEntry."Applied Vend. Ledger Entry No.");
                    IF VendLedgEntry2.FIND('-') THEN
                        VendLedgEntry2.MARK(TRUE);
                END;
            UNTIL FoundDetailedVendorLedgEntry.NEXT() = 0;
    end;
}

