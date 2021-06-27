report 80720 "MICA StatementCustom"
{
    // version NAVW113.02,SPLN1.00

    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rdl80720.MICAStatement.rdl';
    WordLayout = './src/report/Wrd80720.MicaStatement.docx';
    Caption = 'Statement Custom';
    UsageCategory = None;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Print Statements", "Currency Filter";
            column(No_Cust; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                PrintOnlyIfDetail = true;
                column(CompanyInfo1Picture; FoundCompanyInformation.Picture)
                {
                }
                column(CompanyInfo2Picture; PicCompanyInformation.Picture)
                {
                }
                column(CompanyInfo3Picture; SetLogoCompanyInformation.Picture)
                {
                }
                column(CurrencyCodeCaption; CurrencyCodeCaptionLbl)
                {
                }
                column(CustomerStatementCaption; CustomerStatementCaptionLbl)
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(PhoneNo_CompanyInfo; CompanyInformation."Phone No.")
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CompanyInfoEmail; CompanyInformation."E-Mail")
                {
                }
                column(CompanyInfoHomePage; CompanyInformation."Home Page")
                {
                }
                column(VATRegNo_CompanyInfo; CompanyInformation."VAT Registration No.")
                {
                }
                column(GiroNo_CompanyInfo; CompanyInformation."Giro No.")
                {
                }
                column(BankName_CompanyInfo; CompanyInformation."Bank Name")
                {
                }
                column(BankAccNo_CompanyInfo; CompanyInformation."Bank Account No.")
                {
                }
                column(No1_Cust; Customer."No.")
                {
                }
                column(TodayFormatted; Format(Today()))
                {
                }
                column(StartDate; Format(StartDate))
                {
                }
                column(EndDate; Format(EndDate))
                {
                }
                column(LastStatmntNo_Cust; Format(Customer."Last Statement No."))
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(CompanyAddr7; CompanyAddr[7])
                {
                }
                column(CompanyAddr8; CompanyAddr[8])
                {
                }
                column(StatementCaption; StatementCaptionLbl)
                {
                }
                column(PhoneNo_CompanyInfoCaption; PhoneNo_CompanyInfoCaptionLbl)
                {
                }
                column(VATRegNo_CompanyInfoCaption; VATRegNo_CompanyInfoCaptionLbl)
                {
                }
                column(GiroNo_CompanyInfoCaption; GiroNo_CompanyInfoCaptionLbl)
                {
                }
                column(BankName_CompanyInfoCaption; BankName_CompanyInfoCaptionLbl)
                {
                }
                column(BankAccNo_CompanyInfoCaption; BankAccNo_CompanyInfoCaptionLbl)
                {
                }
                column(No1_CustCaption; No1_CustCaptionLbl)
                {
                }
                column(StartDateCaption; StartDateCaptionLbl)
                {
                }
                column(EndDateCaption; EndDateCaptionLbl)
                {
                }
                column(LastStatmntNo_CustCaption; LastStatmntNo_CustCaptionLbl)
                {
                }
                column(PostDate_DtldCustLedgEntriesCaption; PostDate_DtldCustLedgEntriesCaptionLbl)
                {
                }
                column(DocNo_DtldCustLedgEntriesCaption; DtldCustLedgEntries.FieldCaption("Document No."))
                {
                }
                column(Desc_CustLedgEntry2Caption; CustLedgEntry2.FieldCaption(Description))
                {
                }
                column(DueDate_CustLedgEntry2Caption; DueDate_CustLedgEntry2CaptionLbl)
                {
                }
                column(RemainAmtCustLedgEntry2Caption; RemaigningAmountLbl)
                {
                }
                column(CustBalanceCaption; CustBalanceCaptionLbl)
                {
                }
                column(OriginalAmt_CustLedgEntry2Caption; OriginalAmountLbl)
                {
                }
                column(CompanyInfoHomepageCaption; CompanyInfoHomepageCaptionLbl)
                {
                }
                column(CompanyInfoEmailCaption; CompanyInfoEmailCaptionLbl)
                {
                }
                column(DocDateCaption; DocDateCaptionLbl)
                {
                }
                column(Total_Caption2; Total_CaptionLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(CompanyInfoBIC; CompanyInformation."SWIFT Code")
                {
                }
                column(BICCaption; BICCaptionLbl)
                {
                }
                column(CompanyInfoIBAN; CompanyInformation.IBAN)
                {
                }
                column(IBANCaption; IBANLbl)
                {
                }
                column(InfoMsgCaption; StrSubstNo(InfoMsgLbl, Format(EndDate)))
                {
                }
                column(IncludeAgingBand; IncludeAgingBandValue) //DMT
                {
                }
                column(CompanyLegalOffice; CompanyInformation.GetLegalOffice())
                {
                }
                column(CompanyLegalOffice_Lbl; CompanyInformation.GetLegalOfficeLbl())
                {
                }
                dataitem(CurrencyLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    PrintOnlyIfDetail = true;
                    dataitem(CustLedgEntryHdr; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(Currency2Code_CustLedgEntryHdr; StrSubstNo(c001Lbl, CurrencyCode3))
                        {
                        }
                        column(StartBalance; StartBalance)
                        {
                            AutoFormatExpression = TempFoundCurrency.Code;
                            AutoFormatType = 1;
                        }
                        column(CurrencyCode3; CurrencyCode3)
                        {
                        }
                        column(CustBalance_CustLedgEntryHdr; CustBalance)
                        {
                        }
                        column(PrintLine; PrintLine)
                        {
                        }
                        column(DtldCustLedgEntryType; Format(DtldCustLedgEntries."Entry Type", 0, 2))
                        {
                        }
                        column(EntriesExists; EntriesExists)
                        {
                        }
                        column(IsNewCustCurrencyGroup; IsNewCustCurrencyGroup)
                        {
                        }
                        dataitem(DtldCustLedgEntries; "Detailed Cust. Ledg. Entry")
                        {
                            DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code");
                            column(PostDate_DtldCustLedgEntries; Format("Posting Date"))
                            {
                            }
                            column(DocNo_DtldCustLedgEntries; "Document No.")
                            {
                            }
                            column(Description; Description)
                            {
                            }
                            column(DueDate_DtldCustLedgEntries; Format(DueDate))
                            {
                            }
                            //column(CurrCode_DtldCustLedgEntries; "Currency Code")
                            column(CurrCode_DtldCustLedgEntries; CurrencyCode3) //DMT
                            {
                            }
                            column(Amt_DtldCustLedgEntries; Amount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(RemainAmt_DtldCustLedgEntries; RemainingAmount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(CustBalance; CustBalance)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(Currency2Code; TempFoundCurrency.Code)
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                CustLedgerEntry: Record "Cust. Ledger Entry";
                            begin
                                if SkipReversedUnapplied(DtldCustLedgEntries) or (Amount = 0) then
                                    CurrReport.Skip();
                                RemainingAmount := 0;
                                PrintLine := true;
                                case "Entry Type" of
                                    "Entry Type"::"Initial Entry":
                                        begin
                                            CustLedgerEntry.Get("Cust. Ledger Entry No.");
                                            Description := CopyStr(CustLedgerEntry.Description, 1, 50);
                                            DueDate := CustLedgerEntry."Due Date";
                                            CustLedgerEntry.SetRange("Date Filter", 0D, EndDate);
                                            CustLedgerEntry.CalcFields("Remaining Amount");
                                            RemainingAmount := CustLedgerEntry."Remaining Amount";
                                        end;
                                    "Entry Type"::Application:
                                        begin
                                            FoundDetailedCustLedgEntry.SetCurrentKey("Customer No.", "Posting Date", "Entry Type");
                                            FoundDetailedCustLedgEntry.SetRange("Customer No.", "Customer No.");
                                            FoundDetailedCustLedgEntry.SetRange("Posting Date", "Posting Date");
                                            FoundDetailedCustLedgEntry.SetRange("Entry Type", "Entry Type"::Application);
                                            FoundDetailedCustLedgEntry.SetRange("Transaction No.", "Transaction No.");
                                            FoundDetailedCustLedgEntry.SetFilter("Currency Code", '<>%1', "Currency Code");
                                            if not FoundDetailedCustLedgEntry.IsEmpty() then begin
                                                Description := c005Lbl;
                                                DueDate := 0D;
                                            end else
                                                PrintLine := false;
                                        end;
                                    "Entry Type"::"Payment Discount",
                                    "Entry Type"::"Payment Discount (VAT Excl.)",
                                    "Entry Type"::"Payment Discount (VAT Adjustment)",
                                    "Entry Type"::"Payment Discount Tolerance",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                                        begin
                                            Description := c006Lbl;
                                            DueDate := 0D;
                                        end;
                                    "Entry Type"::"Payment Tolerance",
                                    "Entry Type"::"Payment Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Tolerance (VAT Adjustment)":
                                        begin
                                            Description := c014Lbl;
                                            DueDate := 0D;
                                        end;
                                    "Entry Type"::"Appln. Rounding",
                                    "Entry Type"::"Correction of Remaining Amount":
                                        begin
                                            Description := c007Lbl;
                                            DueDate := 0D;
                                        end;
                                end;

                                if PrintLine then begin
                                    CustBalance := CustBalance + Amount;
                                    IsNewCustCurrencyGroup := IsFirstPrintLine;
                                    IsFirstPrintLine := false;
                                    ClearCompanyPicture();
                                end;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange("Customer No.", Customer."No.");
                                SetRange("Posting Date", StartDate, EndDate);
                                SetRange("Currency Code", TempFoundCurrency.Code);

                                if TempFoundCurrency.Code = '' then begin
                                    GeneralLedgerSetup.TestField("LCY Code");
                                    CurrencyCode3 := GeneralLedgerSetup."LCY Code"
                                end else
                                    CurrencyCode3 := TempFoundCurrency.Code;

                                IsFirstPrintLine := true;
                            end;
                        }
                    }
                    dataitem(CustLedgEntryFooter; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(CurrencyCode3_CustLedgEntryFooter; CurrencyCode3)
                        {
                        }
                        column(Total_Caption; Total_CaptionLbl)
                        {
                        }
                        column(CustBalance_CustLedgEntryHdrFooter; CustBalance)
                        {
                            AutoFormatExpression = TempFoundCurrency.Code;
                            AutoFormatType = 1;
                        }
                        column(EntriesExistsl_CustLedgEntryFooterCaption; EntriesExists)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ClearCompanyPicture();
                        end;
                    }
                    dataitem(CustLedgEntry2; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Customer No." = FIELD("No.");
                        DataItemLinkReference = Customer;
                        DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date");
                        //column(OverDueEntries; StrSubstNo(c002Lbl, Currency2.Code))
                        column(OverDueEntries; StrSubstNo(c002Lbl, CurrencyCode3)) //DMT
                        {
                        }
                        column(RemainAmt_CustLedgEntry2; "Remaining Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PostDate_CustLedgEntry2; Format("Posting Date"))
                        {
                        }
                        column(DocNo_CustLedgEntry2; "Document No.")
                        {
                        }
                        column(Desc_CustLedgEntry2; Description)
                        {
                        }
                        column(DueDate_CustLedgEntry2; Format("Due Date"))
                        {
                        }
                        column(OriginalAmt_CustLedgEntry2; "Original Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                        }
                        column(CurrCode_CustLedgEntry2; "Currency Code")
                        {
                        }
                        column(PrintEntriesDue; PrintEntriesDue)
                        {
                        }
                        column(Currency2Code_CustLedgEntry2; TempFoundCurrency.Code)
                        {
                        }
                        column(CurrencyCode3_CustLedgEntry2; CurrencyCode3)
                        {
                        }
                        column(CustNo_CustLedgEntry2; "Customer No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            CustLedgEntry: Record "Cust. Ledger Entry";
                        begin
                            if IncludeAgingBandValue then begin
                                if ("Posting Date" > EndDate) and ("Due Date" >= EndDate) then
                                    CurrReport.Skip();
                                if DateChoice = DateChoice::"Due Date" then
                                    if "Due Date" >= EndDate then
                                        CurrReport.Skip();
                            end;
                            CustLedgEntry := CustLedgEntry2;
                            CustLedgEntry.SetRange("Date Filter", 0D, EndDate);
                            CustLedgEntry.CalcFields("Remaining Amount");
                            "Remaining Amount" := CustLedgEntry."Remaining Amount";
                            if PrintOnlyOpenEntries and (CustLedgEntry."Remaining Amount" = 0) then
                                CurrReport.Skip();

                            if IncludeAgingBandValue and ("Posting Date" <= EndDate) then
                                UpdateBuffer(TempFoundCurrency.Code, GetDate("Posting Date", "Due Date"), "Remaining Amount");
                            if "Due Date" >= EndDate then
                                CurrReport.Skip();

                            ClearCompanyPicture();
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals("Remaining Amount");
                            if not IncludeAgingBandValue then
                                SetRange("Due Date", 0D, EndDate - 1);
                            SetRange("Currency Code", TempFoundCurrency.Code);
                            if (not PrintEntriesDue) and (not IncludeAgingBandValue) then
                                CurrReport.Break();
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                    begin
                        if Number = 1 then
                            TempFoundCurrency.FindFirst();

                        repeat
                            if not IsFirstLoop then
                                IsFirstLoop := true
                            else
                                if TempFoundCurrency.Next() = 0 then
                                    CurrReport.Break();
                            CustLedgerEntry.SetRange("Customer No.", Customer."No.");
                            CustLedgerEntry.SetRange("Posting Date", 0D, EndDate);
                            CustLedgerEntry.SetRange("Currency Code", TempFoundCurrency.Code);
                            EntriesExists := not CustLedgerEntry.IsEmpty();
                        until EntriesExists;
                        FoundCustomer := Customer;
                        FoundCustomer.SetRange("Date Filter", 0D, StartDate - 1);
                        FoundCustomer.SetRange("Currency Filter", TempFoundCurrency.Code);
                        FoundCustomer.CalcFields("Net Change");
                        StartBalance := FoundCustomer."Net Change";
                        CustBalance := FoundCustomer."Net Change";
                    end;

                    trigger OnPreDataItem()
                    begin
                        Customer.CopyFilter("Currency Filter", TempFoundCurrency.Code);
                    end;
                }
                dataitem(AgingBandLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    column(LessCaption; LessCaptionLbl)
                    {
                    }
                    column(MoreCaptgion; MoreCaptionLbl)
                    {
                    }
                    column(DashCaption; DashCaptionLbl)
                    {
                    }
                    column(BalanceDue; BalanceDueLbl)
                    {
                    }
                    column(AgingDate1; FORMAT(AgingDate4__AgingDate31 + AgingDate3__AgingDate21 + AgingDate2__AgingDate1))
                    {
                    }
                    column(AgingDate2; Format(AgingDate[2]))
                    {
                    }
                    column(AgingDate21; FORMAT(AgingDate4__AgingDate31 + AgingDate3__AgingDate21))
                    {
                    }
                    column(AgingDate211; FORMAT(AgingDate4__AgingDate31 + AgingDate3__AgingDate21 + 1))
                    {
                    }
                    column(AgingDate3; Format(AgingDate[3]))
                    {
                    }
                    column(AgingDate31; FORMAT(AgingDate4__AgingDate31))
                    {
                    }
                    column(AgingDate4; Format(AgingDate[4]))
                    {
                    }
                    column(AgingBandEndingDate; StrSubstNo(c011Lbl, AgingBandEndingDate, PeriodLength, SelectStr(DateChoice + 1, c013Lbl)))
                    {
                    }
                    column(AgingDate41; Format(AgingDate[4] + 1))
                    {
                    }
                    column(AgingDate5; Format(AgingDate[5]))
                    {
                    }
                    column(AgingBandBufCol1Amt; TempAgingBandBuffer."Column 1 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuffer."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol2Amt; TempAgingBandBuffer."Column 2 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuffer."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol3Amt; TempAgingBandBuffer."Column 3 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuffer."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol4Amt; TempAgingBandBuffer."Column 4 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuffer."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol5Amt; TempAgingBandBuffer."Column 5 Amt.")
                    {
                        AutoFormatExpression = TempAgingBandBuffer."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandCurrencyCode; AgingBandCurrencyCode)
                    {
                    }
                    column(beforeCaption; beforeCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                            ClearCompanyPicture();
                            if not TempAgingBandBuffer.Find('-') then
                                CurrReport.Break();
                        end else
                            if TempAgingBandBuffer.Next() = 0 then
                                CurrReport.Break();
                        AgingBandCurrencyCode := TempAgingBandBuffer."Currency Code";
                        if AgingBandCurrencyCode = '' then
                            AgingBandCurrencyCode := GeneralLedgerSetup."LCY Code";
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not IncludeAgingBandValue then
                            CurrReport.Break();
                    end;
                }
                dataitem(LetterText; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(GreetingText; GreetingLbl)
                    {
                    }
                    column(BodyText; BodyLbl)
                    {
                    }
                    column(ClosingText; ClosingLbl)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            var
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                TempAgingBandBuffer.DeleteAll();
                if "Language Code" <> '' then
                    CurrReport.Language := Language.GetLanguageID("Language Code")
                else
                    CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");
                PrintLine := false;
                FoundCustomer := Customer;
                CopyFilter("Currency Filter", TempFoundCurrency.Code);
                if PrintAllHavingBal then
                    if TempFoundCurrency.Find('-') then
                        repeat
                            FoundCustomer.SetRange("Date Filter", 0D, EndDate);
                            FoundCustomer.SetRange("Currency Filter", TempFoundCurrency.Code);
                            FoundCustomer.CalcFields("Net Change");
                            PrintLine := FoundCustomer."Net Change" <> 0;
                        until (TempFoundCurrency.Next() = 0) or PrintLine;

                if (not PrintLine) and PrintAllHavingEntry then begin
                    CustLedgerEntry.SetRange("Customer No.", "No.");
                    CustLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
                    CopyFilter("Currency Filter", CustLedgerEntry."Currency Code");
                    PrintLine := not CustLedgerEntry.IsEmpty();
                end;
                if not PrintLine then
                    CurrReport.Skip();

                FormatAddress.Customer(CustAddr, Customer);
                CurrReport.PageNo := 1;

                if not IsReportInPreviewMode() then begin
                    LockTable();
                    Find();
                    "Last Statement No." := "Last Statement No." + 1;
                    Modify();
                    Commit();
                end else
                    "Last Statement No." := "Last Statement No." + 1;

                IsFirstLoop := false;
            end;

            trigger OnPreDataItem()
            begin
                VerifyDates();
                AgingBandEndingDate := EndDate;
                CalcAgingBandDates();

                CompanyInformation.Get();
                WITH CompanyInformation DO
                    FormatAddress.FormatAddr(CompanyAddr, Name, "Name 2", '', Address, "Address 2",
                    City, "Post Code", County, "Country/Region Code");

                TempFoundCurrency.Code := '';
                TempFoundCurrency.Insert();
                CopyFilter("Currency Filter", Currency.Code);
                if Currency.Find('-') then
                    repeat
                        TempFoundCurrency := Currency;
                        TempFoundCurrency.Insert();
                    until Currency.Next() = 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Start Date"; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field("End Date"; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(ShowOverdueEntries; PrintEntriesDue)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Overdue Entries';
                        ToolTip = 'Specifies if you want overdue entries to be shown separately for each currency.';
                    }
                    group(Include)
                    {
                        Caption = 'Include';
                        field(IncludeAllCustomerswithLE; PrintAllHavingEntry)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include All Customers with Ledger Entries';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for customers that have ledger entries at the end of the selected period.';

                            trigger OnValidate()
                            begin
                                if not PrintAllHavingEntry then
                                    PrintAllHavingBal := true;
                            end;
                        }
                        field(IncludeAllCustomerswithBalance; PrintAllHavingBal)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include All Customers with a Balance';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for customers that have a balance at the end of the selected period.';

                            trigger OnValidate()
                            begin
                                if not PrintAllHavingBal then
                                    PrintAllHavingEntry := true;
                            end;
                        }
                        field(IncludeReversedEntries; PrintReversedEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Reversed Entries';
                            ToolTip = 'Specifies if you want to include reversed entries in the report.';
                        }
                        field(IncludeUnappliedEntries; PrintUnappliedEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Unapplied Entries';
                            ToolTip = 'Specifies if you want to include unapplied entries in the report.';
                        }
                        field(IncludeOpenEntries; PrintOnlyOpenEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Only Open Entries';
                            ToolTip = 'Specifies if you want to include only open entries in the report.';
                        }
                    }
                    group("Aging Band")
                    {
                        Caption = 'Aging Band';
                        field(IncludeAgingBand; IncludeAgingBandValue)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Aging Band';
                            ToolTip = 'Specifies if you want an aging band to be included in the document. If you place a check mark here, you must also fill in the Aging Band Period Length and Aging Band by fields.';
                        }
                        field(AgingBandPeriodLengt; PeriodLength)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Aging Band Period Length';
                            ToolTip = 'Specifies the length of each of the four periods in the aging band, for example, enter "1M" for one month. The most recent period will end on the last day of the period in the Date Filter field.';
                        }
                        field(AgingBandby; DateChoice)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Aging Band by';
                            OptionCaption = 'Due Date,Posting Date';
                            ToolTip = 'Specifies if the aging band will be calculated from the due date or from the posting date.';
                        }
                    }
                    field(LogInteraction; LogInteractionValue)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                }
                group("Output Options")
                {
                    Caption = 'Output Options';
                    field(ReportOutput; SupportedOutputMethod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Report Output';
                        OptionCaption = 'Print,Preview,Word,PDF,Email,XML - RDLC layouts only'; //DMT 'Print,Preview,PDF,Email,Excel,XML';

                        ToolTip = 'Specifies the output of the scheduled report, such as PDF or Word.';

                        trigger OnValidate()
                        var
                            CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                        begin
                            ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);

                            case SupportedOutputMethod of
                                SupportedOutputMethod::Print:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPrintOption();
                                SupportedOutputMethod::Preview:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPreviewOption();
                                SupportedOutputMethod::Word:
                                    ChosenOutputMethod := CustomLayoutReporting.GetWordOption();
                                SupportedOutputMethod::PDF:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPDFOption();
                                SupportedOutputMethod::Email:
                                    ChosenOutputMethod := CustomLayoutReporting.GetEmailOption();
                                SupportedOutputMethod::XML:
                                    ChosenOutputMethod := CustomLayoutReporting.GetXMLOption();
                            end;
                        end;
                    }
                    field(ChosenOutput; ChosenOutputMethod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Chosen Output';
                        ToolTip = 'Specifies how to output the report, such as Print or Excel.';
                        Visible = false;
                    }
                    group(EmailOptions)
                    {
                        Caption = 'Email Options';
                        Visible = ShowPrintRemaining;
                        field(PrintMissingAddresses; PrintRemaining)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Print remaining statements';
                            ToolTip = 'Specifies if you want to print remaining statements.';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            InitRequestPageDataInternal();
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GeneralLedgerSetup.Get();
        SalesReceivablesSetup.Get();

        case SalesReceivablesSetup."Logo Position on Documents" of
            SalesReceivablesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesReceivablesSetup."Logo Position on Documents"::Left:
                begin
                    FoundCompanyInformation.Get();
                    FoundCompanyInformation.CalcFields(Picture);
                end;
            SalesReceivablesSetup."Logo Position on Documents"::Center:
                begin
                    PicCompanyInformation.Get();
                    PicCompanyInformation.CalcFields(Picture);
                end;
            SalesReceivablesSetup."Logo Position on Documents"::Right:
                begin
                    SetLogoCompanyInformation.Get();
                    SetLogoCompanyInformation.CalcFields(Picture);
                end;
        end;

        LogInteractionEnable := true;
    end;

    trigger OnPostReport()
    begin
        if LogInteractionValue and not IsReportInPreviewMode() then
            if Customer.FindSet() then
                repeat
                    SegManagement.LogDocument(
                      7, Copystr(Format(Customer."Last Statement No."), 1, 20), 0, 0, DATABASE::Customer, Customer."No.", Customer."Salesperson Code", '',
                      c003Lbl + Format(Customer."Last Statement No."), '');
                until Customer.Next() = 0;
    end;

    trigger OnPreReport()
    begin
        InitRequestPageDataInternal();
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CompanyInformation: Record "Company Information";
        FoundCompanyInformation: Record "Company Information";
        PicCompanyInformation: Record "Company Information";
        SetLogoCompanyInformation: Record "Company Information";
        FoundCustomer: Record Customer;
        Currency: Record Currency;
        TempFoundCurrency: Record Currency temporary;
        FoundDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        TempAgingBandBuffer: Record "Aging Band Buffer" temporary;
        Language: Codeunit Language;
        FormatAddress: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        PeriodLength: DateFormula;
        PeriodLength2: DateFormula;
        StartDate: Date;
        EndDate: Date;
        DueDate: Date;
        AgingDate: array[5] of Date;
        AgingBandEndingDate: Date;
        CurrencyCode3: Code[10];
        AgingBandCurrencyCode: Code[20];
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        Description: Text[50];
        StartBalance: Decimal;
        CustBalance: Decimal;
        RemainingAmount: Decimal;
        DateChoice: Option "Due Date","Posting Date";
        SupportedOutputMethod: Option Print,Preview,Word,PDF,Email,XML; //DMT Print,Preview,PDF,Email,Excel,XML;

        ChosenOutputMethod: Integer;

        PrintAllHavingEntry: Boolean;
        PrintAllHavingBal: Boolean;
        PrintEntriesDue: Boolean;
        PrintUnappliedEntries: Boolean;
        PrintReversedEntries: Boolean;
        PrintOnlyOpenEntries: Boolean;
        PrintLine: Boolean;
        LogInteractionValue: Boolean;
        EntriesExists: Boolean;
        IncludeAgingBandValue: Boolean;

        [InDataSet]
        LogInteractionEnable: Boolean;
        isInitialized: Boolean;
        IsFirstLoop: Boolean;
        IsFirstPrintLine: Boolean;
        IsNewCustCurrencyGroup: Boolean;
        PrintRemaining: Boolean;
        [InDataSet]
        ShowPrintRemaining: Boolean;
        FirstCustomerPrinted: Boolean;

        c008Lbl: Label 'You must specify the Aging Band Period Length.';
        StatementCaptionLbl: Label 'Statement';
        c036Lbl: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
        PhoneNo_CompanyInfoCaptionLbl: Label 'Phone No.';
        VATRegNo_CompanyInfoCaptionLbl: Label 'VAT Registration No.';
        GiroNo_CompanyInfoCaptionLbl: Label 'Giro No.';
        BankName_CompanyInfoCaptionLbl: Label 'Bank';
        BankAccNo_CompanyInfoCaptionLbl: Label 'Account No.';
        No1_CustCaptionLbl: Label 'Customer No.';
        StartDateCaptionLbl: Label 'Starting Date';
        EndDateCaptionLbl: Label 'Ending Date';
        LastStatmntNo_CustCaptionLbl: Label 'Statement No.';
        PostDate_DtldCustLedgEntriesCaptionLbl: Label 'Posting Date';
        DueDate_CustLedgEntry2CaptionLbl: Label 'Due Date';
        CurrencyCodeCaptionLbl: Label 'Currency Code';
        CustBalanceCaptionLbl: Label 'Balance';
        beforeCaptionLbl: Label '..before';

        CompanyInfoHomepageCaptionLbl: Label 'Home Page';
        CompanyInfoEmailCaptionLbl: Label 'Email';
        DocDateCaptionLbl: Label 'Document Date';
        Total_CaptionLbl: Label 'Total';
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
        c005Lbl: Label 'Multicurrency Application';
        c006Lbl: Label 'Payment Discount';
        c007Lbl: Label 'Rounding';
        c001Lbl: Label 'Entries %1';
        c002Lbl: Label 'Overdue Entries %1';
        C003Lbl: Label 'Statement ';
        c010Lbl: Label 'You must specify Aging Band Ending Date.';
        c011Lbl: Label 'Aged Summary by %1 (%2 by %3)';
        c012Lbl: Label 'Period Length is out of range.';
        c013Lbl: Label 'Due Date,Posting Date';
        c014Lbl: Label 'Application Writeoffs';
        CurrReportPageNoCaptionLbl: Label 'Page';
        BICCaptionLbl: Label 'BIC';
        InfoMsgLbl: Label 'This statement shows all open items until %1.';
        CustomerStatementCaptionLbl: Label 'Customer Statement';
        IBANLbl: Label 'IBAN';
        OriginalAmountLbl: Label 'Original Amount';
        RemaigningAmountLbl: Label 'Remaining Amount';
        AgingDate4__AgingDate31: Integer;
        AgingDate3__AgingDate21: Integer;
        AgingDate2__AgingDate1: Integer;
        LessCaptionLbl: Label ' > ';
        MoreCaptionLbl: Label ' < ';
        DashCaptionLbl: Label ' - ';
        BalanceDueLbl: Label 'Balance Due';
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        BodyLbl: Label 'Thank you for your business. Your statement is attached to this message.';

    local procedure GetDate(PostingDate: Date; DueDate: Date): Date
    begin
        if DateChoice = DateChoice::"Posting Date" then
            exit(PostingDate);

        exit(DueDate);
    end;

    local procedure CalcAgingBandDates()
    begin
        if not IncludeAgingBandValue then
            exit;
        if AgingBandEndingDate = 0D then
            Error(c010Lbl);
        if Format(PeriodLength) = '' then
            Error(c008Lbl);
        Evaluate(PeriodLength2, StrSubstNo(c036Lbl, PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CalcDate(PeriodLength2, AgingDate[5]);
        AgingDate[3] := CalcDate(PeriodLength2, AgingDate[4]);
        AgingDate[2] := CalcDate(PeriodLength2, AgingDate[3]);
        AgingDate[1] := CalcDate(PeriodLength2, AgingDate[2]);
        if AgingDate[2] <= AgingDate[1] then
            Error(c012Lbl);

        AgingDate4__AgingDate31 := AgingDate[4] - AgingDate[3];
        AgingDate3__AgingDate21 := AgingDate[3] - AgingDate[2];
        AgingDate2__AgingDate1 := AgingDate[2] - AgingDate[1];
    end;

    local procedure UpdateBuffer(CurrencyCode: Code[10]; Date: Date; Amount: Decimal)
    var
        I: Integer;
        GoOn: Boolean;
    begin
        TempAgingBandBuffer.Init();
        TempAgingBandBuffer."Currency Code" := CurrencyCode;
        if not TempAgingBandBuffer.Find() then
            TempAgingBandBuffer.Insert();
        I := 1;
        GoOn := true;
        while (I <= 5) and GoOn do begin
            if Date <= AgingDate[I] then
                if I = 1 then begin
                    TempAgingBandBuffer."Column 1 Amt." := TempAgingBandBuffer."Column 1 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 2 then begin
                    TempAgingBandBuffer."Column 2 Amt." := TempAgingBandBuffer."Column 2 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 3 then begin
                    TempAgingBandBuffer."Column 3 Amt." := TempAgingBandBuffer."Column 3 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 4 then begin
                    TempAgingBandBuffer."Column 4 Amt." := TempAgingBandBuffer."Column 4 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 5 then begin
                    TempAgingBandBuffer."Column 5 Amt." := TempAgingBandBuffer."Column 5 Amt." + Amount;
                    GoOn := false;
                end;
            I := I + 1;
        end;
        TempAgingBandBuffer.Modify();
    end;

    procedure SkipReversedUnapplied(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"): Boolean
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        if PrintReversedEntries and PrintUnappliedEntries and not PrintOnlyOpenEntries then
            exit(false);
        if not PrintUnappliedEntries then
            if DetailedCustLedgEntry.Unapplied then
                exit(true);
        if not PrintReversedEntries then begin
            CustLedgerEntry.Get(DetailedCustLedgEntry."Cust. Ledger Entry No.");
            if CustLedgerEntry.Reversed then
                exit(true);
        end;
        if PrintOnlyOpenEntries then begin
            CustLedgerEntry.CalcFields("Remaining Amount");
            if CustLedgerEntry."Remaining Amount" = 0 then
                exit(true);
        end;
        exit(false);
    end;

    procedure InitializeRequest(NewPrintEntriesDue: Boolean; NewPrintAllHavingEntry: Boolean; NewPrintAllHavingBal: Boolean; NewPrintReversedEntries: Boolean; NewPrintUnappliedEntries: Boolean; NewPrintOnlyOpenEntries: Boolean; NewIncludeAgingBand: Boolean; NewPeriodLength: Text[30]; NewDateChoice: Option; NewLogInteraction: Boolean; NewStartDate: Date; NewEndDate: Date)
    begin
        InitRequestPageDataInternal();

        PrintEntriesDue := NewPrintEntriesDue;
        PrintAllHavingEntry := NewPrintAllHavingEntry;
        PrintAllHavingBal := NewPrintAllHavingBal;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
        PrintOnlyOpenEntries := NewPrintOnlyOpenEntries;
        IncludeAgingBandValue := NewIncludeAgingBand;
        Evaluate(PeriodLength, NewPeriodLength);
        DateChoice := NewDateChoice;
        LogInteractionValue := NewLogInteraction;
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    procedure InitRequestPageDataInternal()
    begin
        if isInitialized then
            exit;

        isInitialized := true;

        if (not PrintAllHavingEntry) and (not PrintAllHavingBal) then
            PrintAllHavingBal := true;

        LogInteractionValue := SegManagement.FindInteractTmplCode(7) <> '';
        LogInteractionEnable := LogInteractionValue;

        if Format(PeriodLength) = '' then
            Evaluate(PeriodLength, '<1M+CM>');

        ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);
    end;

    local procedure VerifyDates()
    begin
        if StartDate = 0D then
            Error(BlankStartDateErr);
        if EndDate = 0D then
            Error(BlankEndDateErr);
        if StartDate > EndDate then
            Error(StartDateLaterTheEndDateErr);
    end;

    local procedure ClearCompanyPicture()
    begin
        if FirstCustomerPrinted then begin
            Clear(CompanyInformation.Picture);
            Clear(FoundCompanyInformation.Picture);
            Clear(PicCompanyInformation.Picture);
            Clear(SetLogoCompanyInformation.Picture);
        end;
        FirstCustomerPrinted := true;
    end;
}

