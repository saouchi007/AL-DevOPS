report 82140 "MICA Suggest Vendor Payments"
{
    Caption = 'Suggest Vendor Payments';
    ProcessingOnly = true;
    UsageCategory = None;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING(Blocked) WHERE(Blocked = FILTER(= " "));
            RequestFilterFields = "No.", "Payment Method Code", "Vendor Posting Group";

            trigger OnAfterGetRecord()
            begin
                CLEAR(VendorBalance);
                CALCFIELDS("Balance (LCY)");
                VendorBalance := "Balance (LCY)";

                IF StopPayments THEN
                    CurrReport.BREAK();
                Window.UPDATE(1, "No.");
                IF VendorBalance > 0 THEN BEGIN
                    GetVendLedgEntries(TRUE, FALSE);
                    GetVendLedgEntries(FALSE, FALSE);
                    CheckAmounts(FALSE);
                    ClearNegative();
                END;
            end;

            trigger OnPostDataItem()
            begin
                IF UsePriority AND NOT StopPayments THEN BEGIN
                    Reset();
                    COPYFILTERS(Vend2);
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 0);
                    IF FindSet() THEN
                        REPEAT
                            CLEAR(VendorBalance);
                            CALCFIELDS("Balance (LCY)");
                            VendorBalance := "Balance (LCY)";
                            IF VendorBalance > 0 THEN BEGIN
                                Window.UPDATE(1, "No.");
                                GetVendLedgEntries(TRUE, FALSE);
                                GetVendLedgEntries(FALSE, FALSE);
                                CheckAmounts(FALSE);
                                ClearNegative();
                            END;
                        UNTIL (Next() = 0) OR StopPayments;
                END;

                IF UsePaymentDisc AND NOT StopPayments THEN BEGIN
                    Reset();
                    COPYFILTERS(Vend2);
                    Window2.OPEN(Text007Lbl);
                    IF FindSet() THEN
                        REPEAT
                            CLEAR(VendorBalance);
                            CALCFIELDS("Balance (LCY)");
                            VendorBalance := "Balance (LCY)";
                            Window2.UPDATE(1, "No.");
                            TempPayableVendLedgEntry.SETRANGE("Vendor No.", "No.");
                            IF VendorBalance > 0 THEN BEGIN
                                GetVendLedgEntries(TRUE, TRUE);
                                GetVendLedgEntries(FALSE, TRUE);
                                CheckAmounts(TRUE);
                                ClearNegative();
                            END;
                        UNTIL (Next() = 0) OR StopPayments;
                    Window2.Close();
                END ELSE
                    IF FindSet() THEN
                        REPEAT
                            ClearNegative();
                        UNTIL Next() = 0;

                DimSetEntry.Locktable();
                GenJnlLine.Locktable();
                GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
                GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                GenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                IF GenJnlLine.FindLast() THEN BEGIN
                    LastLineNo := GenJnlLine."Line No.";
                    GenJnlLine.Init();
                END;

                Window2.OPEN(Text008Lbl);

                TempPayableVendLedgEntry.Reset();
                TempPayableVendLedgEntry.SETRANGE(Priority, 1, 2147483647);
                MakeGenJnlLines();
                TempPayableVendLedgEntry.Reset();
                TempPayableVendLedgEntry.SETRANGE(Priority, 0);
                MakeGenJnlLines();
                TempPayableVendLedgEntry.Reset();
                TempPayableVendLedgEntry.DeleteAll();

                Window2.Close();
                Window.Close();
                ShowMessage(MessageText);
            end;

            trigger OnPreDataItem()
            begin
                IF LastDueDateToPayReq = 0D THEN
                    ERROR(Text000Lbl);
                IF (PostingDateValue = 0D) AND (NOT UseDueDateAsPostingDateValue) THEN
                    ERROR(Text001Lbl);

                BankPmtType := GenJnlLine2."Bank Payment Type";
                BalAccType := GenJnlLine2."Bal. Account Type";
                BalAccNo := GenJnlLine2."Bal. Account No.";
                GenJnlLineInserted := FALSE;
                SeveralCurrencies := FALSE;
                MessageText := '';

                IF ((BankPmtType = GenJnlLine2."Bank Payment Type"::" ") OR
                    SummarizePerVend) AND
                   (NextDocNo = '')
                THEN
                    ERROR(Text002Lbl);

                IF ((BankPmtType = GenJnlLine2."Bank Payment Type"::"Manual Check") AND
                    NOT SummarizePerVend AND
                    NOT DocNoPerLine)
                THEN
                    ERROR(Text017Lbl, GenJnlLine2.FIELDCAPTION("Bank Payment Type"), FORMAT(GenJnlLine2."Bank Payment Type"::"Manual Check"));

                IF UsePaymentDisc AND (LastDueDateToPayReq < WorkDate()) THEN
                    IF GuiAllowed() and not Confirm(StrSubstNo(Text003Lbl, WorkDate()), TRUE) THEN
                        ERROR(Text005Lbl);

                Vend2.COPYFILTERS(Vendor);

                OriginalAmtAvailable := AmountAvailable;
                IF UsePriority THEN BEGIN
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 1, 2147483647);
                    UsePriority := TRUE;
                END;
                Window.OPEN(Text006Lbl);

                SelectedDim.SETRANGE("User ID", UserID());
                SelectedDim.SETRANGE("Object Type", 3);
                SelectedDim.SETRANGE("Object ID", REPORT::"Suggest Vendor Payments");
                SummarizePerDim := (NOT SelectedDim.IsEmpty()) AND SummarizePerVend;

                NextEntryNo := 1;
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
                    field(SetDefaultPmtMethod; SetDefaultPmtMethodValue)
                    {
                        ApplicationArea = All;
                        Caption = 'Set Default Payment Method';
                    }
                    group("Find Payments")
                    {
                        Caption = 'Find Payments';
                        field(LastPaymentDate; LastDueDateToPayReq)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Last Payment Date';
                            ToolTip = 'Specifies the latest payment date that can appear on the vendor ledger entries to be included in the batch job. Only entries that have a due date or a payment discount date before or on this date will be included. If the payment date is earlier than the system date, a warning will be displayed.';
                        }
                        field(FindPaymentDiscounts; UsePaymentDisc)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Find Payment Discounts';
                            Importance = Additional;
                            MultiLine = true;
                            ToolTip = 'Specifies if you want the batch job to include vendor ledger entries for which you can receive a payment discount.';

                            trigger OnValidate()
                            begin
                                IF UsePaymentDisc AND UseDueDateAsPostingDateValue THEN
                                    ERROR(PmtDiscUnavailableErr);
                            end;
                        }
                        field(UseVendorPriority; UsePriority)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Use Vendor Priority';
                            Importance = Additional;
                            ToolTip = 'Specifies if the Priority field on the vendor cards will determine in which order vendor entries are suggested for payment by the batch job. The batch job always prioritizes vendors for payment suggestions if you specify an available amount in the Available Amount (LCY) field.';

                            trigger OnValidate()
                            begin
                                IF NOT UsePriority AND (AmountAvailable <> 0) THEN
                                    ERROR(Text011Lbl);
                            end;
                        }
                        field("Available Amount (LCY)"; AmountAvailable)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Available Amount (LCY)';
                            Importance = Additional;
                            ToolTip = 'Specifies a maximum amount (in LCY) that is available for payments. The batch job will then create a payment suggestion on the basis of this amount and the Use Vendor Priority check box. It will only include vendor entries that can be paid fully.';

                            trigger OnValidate()
                            begin
                                IF AmountAvailable <> 0 THEN
                                    UsePriority := TRUE;
                            end;
                        }
                        field(SkipExportedPayments; SkipExportedPaymentsValue)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Skip Exported Payments';
                            Importance = Additional;
                            ToolTip = 'Specifies if you do not want the batch job to insert payment journal lines for documents for which payments have already been exported to a bank file.';
                        }
                        field(CheckOtherJournalBatches; CheckOtherJournalBatchesValue)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Check Other Journal Batches';
                            ToolTip = 'Specifies whether to exclude payments that are already included in another journal batch from new suggested payments. This helps avoid duplicate payments.';
                        }
                    }
                    group("Summarize Results")
                    {
                        Caption = 'Summarize Results';
                        field(SummarizePerVendor; SummarizePerVend)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Summarize per Vendor';
                            ToolTip = 'Specifies if you want the batch job to make one line per vendor for each currency in which the vendor has ledger entries. If, for example, a vendor uses two currencies, the batch job will create two lines in the payment journal for this vendor. The batch job then uses the Applies-to ID field when the journal lines are posted to apply the lines to vendor ledger entries. If you do not select this check box, then the batch job will make one line per invoice.';

                            trigger OnValidate()
                            begin
                                IF SummarizePerVend AND UseDueDateAsPostingDateValue THEN
                                    ERROR(PmtDiscUnavailableErr);
                            end;
                        }
                        field(SummarizePerDimText; SummarizePerDimTextValue)
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'By Dimension';
                            Editable = false;
                            Enabled = SummarizePerDimTextEnable;
                            Importance = Additional;
                            ToolTip = 'Specifies the dimensions that you want the batch job to consider.';

                            trigger OnAssistEdit()
                            var
                                DimSelectionBuf: Record "Dimension Selection Buffer";
                            begin
                                DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"Suggest Vendor Payments", SummarizePerDimTextValue);
                            end;
                        }
                    }
                    group("Fill in Journal Lines")
                    {
                        Caption = 'Fill in Journal Lines';
                        field(PostingDate; PostingDateValue)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posting Date';
                            Editable = UseDueDateAsPostingDateValue = FALSE;
                            Importance = Promoted;
                            ToolTip = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.';

                            trigger OnValidate()
                            begin
                                ValidatePostingDate();
                            end;
                        }
                        field(UseDueDateAsPostingDate; UseDueDateAsPostingDateValue)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Calculate Posting Date from Applies-to-Doc. Due Date';
                            Importance = Additional;
                            ToolTip = 'Specifies if the due date on the purchase invoice will be used as a basis to calculate the payment posting date.';

                            trigger OnValidate()
                            begin
                                IF UseDueDateAsPostingDateValue AND (SummarizePerVend OR UsePaymentDisc) THEN
                                    ERROR(PmtDiscUnavailableErr);
                                IF NOT UseDueDateAsPostingDateValue THEN
                                    CLEAR(DueDateOffsetValue);
                            end;
                        }
                        field(DueDateOffset; DueDateOffsetValue)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Applies-to-Doc. Due Date Offset';
                            Editable = UseDueDateAsPostingDateValue;
                            Enabled = UseDueDateAsPostingDateValue;
                            Importance = Additional;
                            ToolTip = 'Specifies a period of time that will separate the payment posting date from the due date on the invoice. Example 1: To pay the invoice on the Friday in the week of the due date, enter CW-2D (current week minus two days). Example 2: To pay the invoice two days before the due date, enter -2D (minus two days).';
                        }
                        field(StartingDocumentNo; NextDocNo)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Document No.';
                            ToolTip = 'Specifies the next available number in the number series for the journal batch that is linked to the payment journal. When you run the batch job, this is the document number that appears on the first payment journal line. You can also fill in this field manually.';

                            trigger OnValidate()
                            var
                                UnincrementableStringErr: Label '%1 contains no number and cannot be incremented.';
                            begin
                                if NextDocNo <> '' then
                                    if IncStr(NextDocNo) = '' then
                                        Error(UnincrementableStringErr, StartingDocumentNoErr);
                            end;
                        }
                        field(NewDocNoPerLine; DocNoPerLine)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'New Doc. No. per Line';
                            Importance = Additional;
                            ToolTip = 'Specifies if you want the batch job to fill in the payment journal lines with consecutive document numbers, starting with the document number specified in the Starting Document No. field.';

                            trigger OnValidate()
                            begin
                                IF NOT UsePriority AND (AmountAvailable <> 0) THEN
                                    ERROR(Text013Lbl);
                            end;
                        }
                        field(BalAccountType; GenJnlLine2."Bal. Account Type")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account Type';
                            Importance = Additional;
                            ToolTip = 'Specifies the balancing account type that payments on the payment journal are posted to.';

                            trigger OnValidate()
                            begin
                                GenJnlLine2."Bal. Account No." := '';
                            end;
                        }
                        field(BalAccountNo; GenJnlLine2."Bal. Account No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account No.';
                            Importance = Additional;
                            ToolTip = 'Specifies the balancing account number that payments on the payment journal are posted to.';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                CASE GenJnlLine2."Bal. Account Type" OF
                                    GenJnlLine2."Bal. Account Type"::"G/L Account":
                                        IF PAGE.RUNMODAL(0, GLAcc) = ACTION::LookupOK THEN
                                            GenJnlLine2."Bal. Account No." := GLAcc."No.";
                                    GenJnlLine2."Bal. Account Type"::Customer, GenJnlLine2."Bal. Account Type"::Vendor:
                                        ERROR(Text009Lbl, GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
                                    GenJnlLine2."Bal. Account Type"::"Bank Account":
                                        IF PAGE.RUNMODAL(0, BankAcc) = ACTION::LookupOK THEN
                                            GenJnlLine2."Bal. Account No." := BankAcc."No.";
                                END;
                            end;

                            trigger OnValidate()
                            begin
                                IF GenJnlLine2."Bal. Account No." <> '' THEN
                                    CASE GenJnlLine2."Bal. Account Type" OF
                                        GenJnlLine2."Bal. Account Type"::"G/L Account":
                                            GLAcc.GET(GenJnlLine2."Bal. Account No.");
                                        GenJnlLine2."Bal. Account Type"::Customer, GenJnlLine2."Bal. Account Type"::Vendor:
                                            ERROR(Text009Lbl, GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
                                        GenJnlLine2."Bal. Account Type"::"Bank Account":
                                            BankAcc.GET(GenJnlLine2."Bal. Account No.");
                                    END;
                            end;
                        }
                        field(BankPaymentType; GenJnlLine2."Bank Payment Type")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bank Payment Type';
                            Importance = Additional;
                            ToolTip = 'Specifies the check type to be used, if you use Bank Account as the balancing account type.';

                            trigger OnValidate()
                            begin
                                IF (GenJnlLine2."Bal. Account Type" <> GenJnlLine2."Bal. Account Type"::"Bank Account") AND
                                   (GenJnlLine2."Bank Payment Type".AsInteger() > 0)
                                THEN
                                    ERROR(
                                      Text010Lbl,
                                      GenJnlLine2.FIELDCAPTION("Bank Payment Type"),
                                      GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
                            end;
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SummarizePerDimTextEnable := TRUE;
            SkipExportedPaymentsValue := TRUE;
        end;

        trigger OnOpenPage()
        begin
            IF LastDueDateToPayReq = 0D THEN
                LastDueDateToPayReq := Workdate();
            IF PostingDateValue = 0D THEN
                PostingDateValue := Workdate();
            ValidatePostingDate();
            SetDefaults();
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        EnvironmentInformation: Codeunit "Environment Information";
    begin
        IF EnvironmentInformation.IsSaaS() THEN
            CheckOtherJournalBatchesValue := TRUE;
    end;

    trigger OnPostReport()
    begin
        Commit();
        IF NOT TempVendorLedgEntryTemp.IsEmpty() THEN
            IF GuiAllowed() and Confirm(Text024Lbl, true) THEN
                PAGE.RUNMODAL(0, TempVendorLedgEntryTemp);

        IF NOT TempErrorMessage.IsEmpty() THEN
            IF GuiAllowed() and Confirm(ReviewNotSuggestedLinesQstLbl, true) THEN
                TempErrorMessage.ShowErrorMessages(false);
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.GET();
        TempVendorLedgEntryTemp.DeleteAll();
        ShowPostingDateWarning := FALSE;
    end;

    var
        Vend2: Record Vendor;
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        DimSetEntry: Record "Dimension Set Entry";
        GenJnlLine2: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLAcc: Record "G/L Account";
        BankAcc: Record "Bank Account";
        TempPayableVendLedgEntry: Record "Payable Vendor Ledger Entry" temporary;
        CompanyInformation: Record "Company Information";
        TempPaymentBuffer: Record "Payment Buffer" temporary;
        TempOldTempPaymentBuffer: Record "Payment Buffer" temporary;
        SelectedDim: Record "Selected Dimension";
        TempVendorLedgEntryTemp: Record "Vendor Ledger Entry" temporary;
        TempErrorMessage: Record "Error Message" temporary;
        FinancialReportingSetup: Record "MICA Financial Reporting Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        DimMgt: Codeunit "DimensionManagement";
        DimBufMgt: Codeunit "Dimension Buffer Management";
        DueDateOffsetValue: DateFormula;
        Window: Dialog;
        Window2: Dialog;
        UsePaymentDisc: Boolean;
        PostingDateValue: Date;
        LastDueDateToPayReq: Date;
        NextDocNo: Code[20];
        AmountAvailable: Decimal;
        OriginalAmtAvailable: Decimal;
        UsePriority: Boolean;
        SummarizePerVend: Boolean;
        SummarizePerDim: Boolean;
        SummarizePerDimTextValue: Text[250];
        LastLineNo: Integer;
        NextEntryNo: Integer;
        UseDueDateAsPostingDateValue: Boolean;
        StopPayments: Boolean;
        DocNoPerLine: Boolean;
        BankPmtType: Enum "Bank Payment Type";
        BalAccType: Enum "Gen. Journal Account Type";
        BalAccNo: Code[20];
        GenJnlLineInserted: Boolean;
        SeveralCurrencies: Boolean;
        MessageText: Text;
        Text024Lbl: Label 'There are one or more entries for which no payment suggestions have been made because the posting dates of the entries are later than the requested posting date. Do you want to see the entries?';
        [InDataSet]
        SummarizePerDimTextEnable: Boolean;
        Text025Lbl: Label 'The %1 with the number %2 has a %3 with the number %4.';
        ShowPostingDateWarning: Boolean;
        VendorBalance: Decimal;
        ReplacePostingDateMsg: Label 'For one or more entries, the requested posting date is before the work date.\\These posting dates will use the work date.';
        PmtDiscUnavailableErr: Label 'You cannot use Find Payment Discounts or Summarize per Vendor together with Calculate Posting Date from Applies-to-Doc. Due Date, because the resulting posting date might not match the payment discount date.';
        SkipExportedPaymentsValue: Boolean;
        MessageToRecipientMsg: Label 'Payment of %1 %2 ', Comment = '%1 document type, %2 Document No.';
        StartingDocumentNoErr: Label 'Starting Document No.';
        CheckOtherJournalBatchesValue: Boolean;
        SetDefaultPmtMethodValue: Boolean;
        ReviewNotSuggestedLinesQstLbl: Label 'There are payments in other journal batches that are not suggested here. This helps avoid duplicate payments. To add them to this batch, remove the payment from the other batch, and then suggest payments again.\\Do you want to review the payments from the other journal batches now?';
        NotSuggestedPaymentInfoTxt: Label 'There are payments in %1 %2, %3 %4, %5 %6', Comment = 'There are payments in Journal Template Name PAYMENT, Journal Batch Name GENERAL, Applies-to Doc. No. 101321';
        Text000Lbl: Label 'In the Last Payment Date field, specify the last possible date that payments must be made.';
        Text001Lbl: Label 'In the Posting Date field, specify the date that will be used as the posting date for the journal entries.';
        Text002Lbl: Label 'In the Starting Document No. field, specify the first document number to be used.';
        Text003Lbl: Label 'The payment date is earlier than %1.\\Do you still want to run the batch job?', Comment = '%1 is a date';
        Text005Lbl: Label 'The batch job was interrupted.';
        Text006Lbl: Label 'Processing vendors     #1##########';
        Text007Lbl: Label 'Processing vendors for payment discounts #1##########';
        Text008Lbl: Label 'Inserting payment journal lines #1##########';
        Text009Lbl: Label '%1 must be G/L Account or Bank Account.';
        Text010Lbl: Label '%1 must be filled only when %2 is Bank Account.';
        Text011Lbl: Label 'Use Vendor Priority must be activated when the value in the Amount Available field is Record "Gen. Journal Batch"not 0.';
        Text013Lbl: Label 'Use Vendor Priority must be activated when the value in the Amount Available Amount (LCY) field is not 0.';
        Text017Lbl: Label 'If %1 = %2 and you have not selected the Summarize per Vendor field,\ then you must select the New Doc. No. per Line.', Comment = 'If Bank Payment Type = Computer Check and you have not selected the Summarize per Vendor field,\ then you must select the New Doc. No. per Line.';
        Text020Lbl: Label 'You have only created suggested vendor payment lines for the %1 %2.\ However, there are other open vendor ledger entries in currencies other than %2.\\', Comment = 'You have only created suggested vendor payment lines for the Currency Code EUR.\ However, there are other open vendor ledger entries in currencies other than EUR.';
        Text021Lbl: Label 'You have only created suggested vendor payment lines for the %1 %2.\ There are no other open vendor ledger entries in other currencies.\\', Comment = 'You have only created suggested vendor payment lines for the Currency Code EUR\ There are no other open vendor ledger entries in other currencies.\\';
        Text022Lbl: Label 'You have created suggested vendor payment lines for all currencies.\\';

    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine := NewGenJnlLine;
    end;

    local procedure ValidatePostingDate()
    begin
        GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        IF GenJnlBatch."No. Series" = '' THEN
            NextDocNo := ''
        ELSE BEGIN
            NextDocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", PostingDateValue, FALSE);
            CLEAR(NoSeriesMgt);
        END;
    end;

    procedure InitializeRequest(LastPmtDate: Date; FindPmtDisc: Boolean; NewAvailableAmount: Decimal; NewSkipExportedPayments: Boolean; NewPostingDate: Date; NewStartDocNo: Code[20]; NewSummarizePerVend: Boolean; BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; BankPmtType: Enum "Bank Payment Type")
    begin
        LastDueDateToPayReq := LastPmtDate;
        UsePaymentDisc := FindPmtDisc;
        AmountAvailable := NewAvailableAmount;
        SkipExportedPaymentsValue := NewSkipExportedPayments;
        PostingDateValue := NewPostingDate;
        NextDocNo := NewStartDocNo;
        SummarizePerVend := NewSummarizePerVend;
        GenJnlLine2."Bal. Account Type" := BalAccType;
        GenJnlLine2."Bal. Account No." := BalAccNo;
        GenJnlLine2."Bank Payment Type" := BankPmtType;
    end;

    local procedure GetVendLedgEntries(Positive: Boolean; Future: Boolean)
    var
        IsHandled: Boolean;
    begin
        VendLedgEntry.Reset();
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendLedgEntry.SETRANGE(Open, TRUE);
        VendLedgEntry.SETRANGE(Positive, Positive);
        VendLedgEntry.SETRANGE("Applies-to ID", '');
        IF Future THEN BEGIN
            VendLedgEntry.SETRANGE("Due Date", LastDueDateToPayReq + 1, DMY2DATE(31, 12, 9999));
            VendLedgEntry.SETRANGE("Pmt. Discount Date", PostingDateValue, LastDueDateToPayReq);
            VendLedgEntry.SETFILTER("Remaining Pmt. Disc. Possible", '<>0');
        END ELSE
            VendLedgEntry.SETRANGE("Due Date", 0D, LastDueDateToPayReq);
        IF SkipExportedPaymentsValue THEN
            VendLedgEntry.SETRANGE("Exported to Payment File", FALSE);
        VendLedgEntry.SETRANGE("On Hold", '');
        VendLedgEntry.SETFILTER("Currency Code", Vendor.GETFILTER("Currency Filter"));
        VendLedgEntry.SETFILTER("Global Dimension 1 Code", Vendor.GETFILTER("Global Dimension 1 Filter"));
        VendLedgEntry.SETFILTER("Global Dimension 2 Code", Vendor.GETFILTER("Global Dimension 2 Filter"));

        IF VendLedgEntry.FindSet() THEN
            REPEAT
                IsHandled := FALSE;
                OnGetVendLedgEntriesOnBeforeLoop(VendLedgEntry, PostingDateValue, LastDueDateToPayReq, Future, IsHandled);
                IF NOT IsHandled THEN BEGIN
                    SaveAmount();
                    IF VendLedgEntry."Accepted Pmt. Disc. Tolerance" OR (VendLedgEntry."Accepted Payment Tolerance" <> 0) THEN BEGIN
                        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
                        VendLedgEntry."Accepted Payment Tolerance" := 0;
                        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                    END;
                END;
            UNTIL VendLedgEntry.Next() = 0;
    end;

    local procedure SaveAmount()
    var
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    begin
        WITH GenJnlLine DO BEGIN
            Init();
            SetPostingDate(GenJnlLine, VendLedgEntry."Due Date", PostingDateValue);
            "Document Type" := "Document Type"::Payment;
            "Account Type" := "Account Type"::Vendor;
            Vend2.GET(VendLedgEntry."Vendor No.");
            Vend2.CheckBlockedVendOnJnls(Vend2, "Document Type", FALSE);
            Description := Vend2.Name;
            "Posting Group" := Vend2."Vendor Posting Group";
            "Salespers./Purch. Code" := Vend2."Purchaser Code";
            "Payment Terms Code" := Vend2."Payment Terms Code";
            VALIDATE("Bill-to/Pay-to No.", "Account No.");
            VALIDATE("Sell-to/Buy-from No.", "Account No.");
            "Gen. Posting Type" := "General Posting Type"::" ";
            "Gen. Bus. Posting Group" := '';
            "Gen. Prod. Posting Group" := '';
            "VAT Bus. Posting Group" := '';
            "VAT Prod. Posting Group" := '';
            VALIDATE("Currency Code", VendLedgEntry."Currency Code");
            VALIDATE("Payment Terms Code");
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, FALSE) THEN
                Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
            ELSE
                Amount := -VendLedgEntry."Remaining Amount";
            VALIDATE(Amount);
        END;

        IF UsePriority THEN
            TempPayableVendLedgEntry.Priority := Vendor.Priority
        ELSE
            TempPayableVendLedgEntry.Priority := 0;
        TempPayableVendLedgEntry."Vendor No." := VendLedgEntry."Vendor No.";
        TempPayableVendLedgEntry."Entry No." := NextEntryNo;
        TempPayableVendLedgEntry."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
        TempPayableVendLedgEntry.Amount := GenJnlLine.Amount;
        TempPayableVendLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
        TempPayableVendLedgEntry.Positive := (TempPayableVendLedgEntry.Amount > 0);
        TempPayableVendLedgEntry.Future := (VendLedgEntry."Due Date" > LastDueDateToPayReq);
        TempPayableVendLedgEntry."Currency Code" := VendLedgEntry."Currency Code";
        TempPayableVendLedgEntry.Insert();
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure CheckAmounts(Future: Boolean)
    var
        CurrencyBalance: Decimal;
        PrevCurrency: Code[10];
    begin
        PrevCurrency := '';
        CurrencyBalance := 0;
        TempPayableVendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        TempPayableVendLedgEntry.SETRANGE(Future, Future);

        IF TempPayableVendLedgEntry.FindSet() THEN BEGIN
            REPEAT
                IF TempPayableVendLedgEntry."Currency Code" <> PrevCurrency THEN BEGIN
                    IF CurrencyBalance > 0 THEN
                        AmountAvailable := AmountAvailable - CurrencyBalance;
                    CurrencyBalance := 0;
                    PrevCurrency := TempPayableVendLedgEntry."Currency Code";
                END;
                IF (OriginalAmtAvailable = 0) OR
                   (AmountAvailable >= CurrencyBalance + TempPayableVendLedgEntry."Amount (LCY)")
                THEN
                    CurrencyBalance := CurrencyBalance + TempPayableVendLedgEntry."Amount (LCY)"
                ELSE
                    TempPayableVendLedgEntry.Delete();
            UNTIL TempPayableVendLedgEntry.Next() = 0;
            IF OriginalAmtAvailable > 0 THEN
                AmountAvailable := AmountAvailable - CurrencyBalance;
            IF (OriginalAmtAvailable > 0) AND (AmountAvailable <= 0) THEN
                StopPayments := TRUE;
        END;
        TempPayableVendLedgEntry.Reset();
    end;

    local procedure MakeGenJnlLines()
    var
        GenJnlLine1: Record "Gen. Journal Line";
        DimBuf: Record "Dimension Buffer";
        Vendor: Record "Vendor";
        RemainingAmtAvailable: Decimal;
    begin
        TempPaymentBuffer.Reset();
        TempPaymentBuffer.DeleteAll();

        IF BalAccType = BalAccType::"Bank Account" THEN BEGIN
            CheckCurrencies(BalAccType, BalAccNo, TempPayableVendLedgEntry);
            SetBankAccCurrencyFilter(BalAccType, BalAccNo, TempPayableVendLedgEntry);
        END;

        IF OriginalAmtAvailable <> 0 THEN BEGIN
            RemainingAmtAvailable := OriginalAmtAvailable;
            RemovePaymentsAboveLimit(TempPayableVendLedgEntry, RemainingAmtAvailable);
        END;
        IF TempPayableVendLedgEntry.FIND('-') THEN
            REPEAT
                TempPayableVendLedgEntry.SETRANGE("Vendor No.", TempPayableVendLedgEntry."Vendor No.");
                TempPayableVendLedgEntry.FIND('-');
                REPEAT
                    VendLedgEntry.GET(TempPayableVendLedgEntry."Vendor Ledg. Entry No.");
                    SetPostingDate(GenJnlLine1, VendLedgEntry."Due Date", PostingDateValue);
                    IF VendLedgEntry."Posting Date" <= GenJnlLine1."Posting Date" THEN BEGIN
                        TempPaymentBuffer."Vendor No." := VendLedgEntry."Vendor No.";
                        TempPaymentBuffer."Currency Code" := VendLedgEntry."Currency Code";
                        TempPaymentBuffer."Payment Method Code" := VendLedgEntry."Payment Method Code";
                        TempPaymentBuffer."Creditor No." := VendLedgEntry."Creditor No.";
                        TempPaymentBuffer."Payment Reference" := VendLedgEntry."Payment Reference";
                        TempPaymentBuffer."Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                        TempPaymentBuffer."Applies-to Ext. Doc. No." := VendLedgEntry."External Document No.";
                        OnUpdateTempBufferFromVendorLedgerEntry(TempPaymentBuffer, VendLedgEntry);

                        SetTempPaymentBufferDims(DimBuf);

                        VendLedgEntry.CALCFIELDS("Remaining Amount");

                        IF SummarizePerVend THEN BEGIN
                            TempPaymentBuffer."Vendor Ledg. Entry No." := 0;
                            IF TempPaymentBuffer.Find() THEN BEGIN
                                TempPaymentBuffer.Amount := TempPaymentBuffer.Amount + TempPayableVendLedgEntry.Amount;
                                TempPaymentBuffer.Modify();
                            END ELSE BEGIN
                                TempPaymentBuffer."Document No." := NextDocNo;
                                NextDocNo := INCSTR(NextDocNo);
                                TempPaymentBuffer.Amount := TempPayableVendLedgEntry.Amount;
                                Window2.UPDATE(1, VendLedgEntry."Vendor No.");
                                TempPaymentBuffer.Insert();
                            END;
                            VendLedgEntry."Applies-to ID" := TempPaymentBuffer."Document No.";
                        END ELSE
                            IF NOT IsEntryAlreadyApplied(GenJnlLine, VendLedgEntry) THEN BEGIN
                                TempPaymentBuffer."Vendor Ledg. Entry Doc. Type" := VendLedgEntry."Document Type";
                                TempPaymentBuffer."Vendor Ledg. Entry Doc. No." := VendLedgEntry."Document No.";
                                TempPaymentBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                                TempPaymentBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                                TempPaymentBuffer."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                                TempPaymentBuffer."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
                                TempPaymentBuffer.Amount := TempPayableVendLedgEntry.Amount;
                                Window2.UPDATE(1, VendLedgEntry."Vendor No.");
                                TempPaymentBuffer.Insert();
                            END;

                        VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                    END ELSE BEGIN
                        TempVendorLedgEntryTemp := VendLedgEntry;
                        TempVendorLedgEntryTemp.Insert();
                    END;

                    TempPayableVendLedgEntry.Delete();
                    IF OriginalAmtAvailable <> 0 THEN BEGIN
                        RemainingAmtAvailable := RemainingAmtAvailable - TempPayableVendLedgEntry."Amount (LCY)";
                        RemovePaymentsAboveLimit(TempPayableVendLedgEntry, RemainingAmtAvailable);
                    END;

                UNTIL NOT TempPayableVendLedgEntry.FindSet();
                TempPayableVendLedgEntry.DeleteAll();
                TempPayableVendLedgEntry.SETRANGE("Vendor No.");
            UNTIL NOT TempPayableVendLedgEntry.FIND('-');

        CLEAR(TempOldTempPaymentBuffer);
        TempPaymentBuffer.SETCURRENTKEY("Document No.");
        TempPaymentBuffer.SETFILTER(
          "Vendor Ledg. Entry Doc. Type", '<>%1&<>%2', TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Refund,
          TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Payment);

        CollectExistingPaymentLines();

        IF TempPaymentBuffer.FIND('-') THEN
            REPEAT
                WITH GenJnlLine DO BEGIN
                    Init();
                    Window2.UPDATE(1, TempPaymentBuffer."Vendor No.");
                    LastLineNo := LastLineNo + 10000;
                    "Line No." := LastLineNo;
                    "Document Type" := "Document Type"::Payment;
                    "Posting No. Series" := GenJnlBatch."Posting No. Series";
                    IF SummarizePerVend THEN
                        "Document No." := TempPaymentBuffer."Document No."
                    ELSE
                        IF DocNoPerLine THEN BEGIN
                            IF TempPaymentBuffer.Amount < 0 THEN
                                "Document Type" := "Document Type"::Refund;

                            "Document No." := NextDocNo;
                            NextDocNo := INCSTR(NextDocNo);
                        END ELSE
                            IF (TempPaymentBuffer."Vendor No." = TempOldTempPaymentBuffer."Vendor No.") AND
                               (TempPaymentBuffer."Currency Code" = TempOldTempPaymentBuffer."Currency Code")
                            THEN
                                "Document No." := TempOldTempPaymentBuffer."Document No."
                            ELSE BEGIN
                                "Document No." := NextDocNo;
                                NextDocNo := INCSTR(NextDocNo);
                                TempOldTempPaymentBuffer := TempPaymentBuffer;
                                TempOldTempPaymentBuffer."Document No." := "Document No.";
                            END;
                    "Account Type" := "Account Type"::Vendor;
                    SetHideValidation(TRUE);
                    ShowPostingDateWarning := ShowPostingDateWarning OR
                      SetPostingDate(GenJnlLine, GetApplDueDate(TempPaymentBuffer."Vendor Ledg. Entry No."), PostingDateValue);
                    VALIDATE("Account No.", TempPaymentBuffer."Vendor No.");
                    Vendor.GET(TempPaymentBuffer."Vendor No.");
                    IF (Vendor."Pay-to Vendor No." <> '') AND (Vendor."Pay-to Vendor No." <> "Account No.") THEN
                        MESSAGE(Text025Lbl, Vendor.TableCaption(), Vendor."No.", Vendor.FIELDCAPTION("Pay-to Vendor No."),
                          Vendor."Pay-to Vendor No.");
                    "Bal. Account Type" := BalAccType;
                    VALIDATE("Bal. Account No.", BalAccNo);
                    VALIDATE("Currency Code", TempPaymentBuffer."Currency Code");
                    "Message to Recipient" := GetMessageToRecipient(SummarizePerVend);
                    "Bank Payment Type" := BankPmtType;
                    IF SummarizePerVend THEN
                        "Applies-to ID" := "Document No.";
                    Description := Vendor.Name;
                    "Source Line No." := TempPaymentBuffer."Vendor Ledg. Entry No.";
                    "Shortcut Dimension 1 Code" := TempPaymentBuffer."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := TempPaymentBuffer."Global Dimension 2 Code";
                    "Dimension Set ID" := TempPaymentBuffer."Dimension Set ID";
                    "Source Code" := GenJnlTemplate."Source Code";
                    "Reason Code" := GenJnlBatch."Reason Code";
                    VALIDATE(Amount, TempPaymentBuffer.Amount);
                    "Applies-to Doc. Type" := TempPaymentBuffer."Vendor Ledg. Entry Doc. Type";
                    "Applies-to Doc. No." := TempPaymentBuffer."Vendor Ledg. Entry Doc. No.";
                    "Payment Method Code" := TempPaymentBuffer."Payment Method Code";
                    "Creditor No." := TempPaymentBuffer."Creditor No.";
                    "Payment Reference" := TempPaymentBuffer."Payment Reference";
                    "Exported to Payment File" := TempPaymentBuffer."Exported to Payment File";
                    "Applies-to Ext. Doc. No." := TempPaymentBuffer."Applies-to Ext. Doc. No.";
                    OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(GenJnlLine, TempPaymentBuffer);
                    UpdateDimensions(GenJnlLine);
                    if FinancialReportingSetup.Get() then
                        if SetDefaultPmtMethodValue then
                            if "Amount (LCY)" <= FinancialReportingSetup."Mass Payment Amount" then
                                Validate("Payment Method Code", FinancialReportingSetup."Dynamic Pay. Mtd. Code Value 1")
                            else
                                Validate("Payment Method Code", FinancialReportingSetup."Dynamic Pay. Mtd. Code Value 2");
                    Insert();
                    GenJnlLineInserted := TRUE;
                END;
            UNTIL TempPaymentBuffer.Next() = 0;
    end;

    local procedure UpdateDimensions(var GenJnlLine: Record "Gen. Journal Line")
    var
        DimBuf: Record "Dimension Buffer";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempDimSetEntry2: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
        NewDimensionID: Integer;
        DimSetIDArr: array[10] of Integer;
    begin
        WITH GenJnlLine DO BEGIN
            NewDimensionID := "Dimension Set ID";
            IF SummarizePerVend THEN BEGIN
                DimBuf.Reset();
                DimBuf.DeleteAll();
                DimBufMgt.GetDimensions(TempPaymentBuffer."Dimension Entry No.", DimBuf);
                IF DimBuf.FindSet() THEN
                    REPEAT
                        DimVal.GET(DimBuf."Dimension Code", DimBuf."Dimension Value Code");
                        TempDimSetEntry."Dimension Code" := DimBuf."Dimension Code";
                        TempDimSetEntry."Dimension Value Code" := DimBuf."Dimension Value Code";
                        TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                        TempDimSetEntry.Insert();
                    UNTIL DimBuf.Next() = 0;
                NewDimensionID := DimMgt.GetDimensionSetID(TempDimSetEntry);
                "Dimension Set ID" := NewDimensionID;
            END;
            CreateDim(
              DimMgt.TypeToTableID1("Account Type".AsInteger()), "Account No.",
              DimMgt.TypeToTableID1("Bal. Account Type".AsInteger()), "Bal. Account No.",
              DATABASE::Job, "Job No.",
              DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code",
              DATABASE::Campaign, "Campaign No.");
            IF NewDimensionID <> "Dimension Set ID" THEN BEGIN
                DimSetIDArr[1] := "Dimension Set ID";
                DimSetIDArr[2] := NewDimensionID;
                "Dimension Set ID" :=
                  DimMgt.GetCombinedDimensionSetID(DimSetIDArr, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            END;

            IF SummarizePerVend THEN BEGIN
                DimMgt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
                IF AdjustAgainstSelectedDim(TempDimSetEntry, TempDimSetEntry2) THEN
                    "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry2);
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code",
                  "Shortcut Dimension 2 Code");
            END;
        END;
    end;

    local procedure SetBankAccCurrencyFilter(BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; var TmpPayableVendLedgEntry: Record "Payable Vendor Ledger Entry")
    var
        BankAccValue: Record "Bank Account";
    begin
        IF BalAccType = BalAccType::"Bank Account" THEN
            IF BalAccNo <> '' THEN BEGIN
                BankAccValue.GET(BalAccNo);
                IF BankAccValue."Currency Code" <> '' THEN
                    TmpPayableVendLedgEntry.SETRANGE("Currency Code", BankAccValue."Currency Code");
            END;
    end;

    local procedure ShowMessage(Text: Text)
    begin
        IF GenJnlLineInserted THEN BEGIN
            IF ShowPostingDateWarning THEN
                Text += ReplacePostingDateMsg;
            IF Text <> '' THEN
                MESSAGE(Text);
        END;
    end;

    local procedure CheckCurrencies(BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; var TmpPayableVendLedgEntry: Record "Payable Vendor Ledger Entry")
    var
        BankAccValue: Record "Bank Account";
        TempPayableVendLedgEntry2: Record "Payable Vendor Ledger Entry" temporary;
    begin
        IF BalAccType = BalAccType::"Bank Account" THEN
            IF BalAccNo <> '' THEN BEGIN
                BankAccValue.GET(BalAccNo);
                IF BankAccValue."Currency Code" <> '' THEN BEGIN
                    TempPayableVendLedgEntry2.Reset();
                    TempPayableVendLedgEntry2.DeleteAll();
                    IF TmpPayableVendLedgEntry.FindSet() THEN
                        REPEAT
                            TempPayableVendLedgEntry2 := TmpPayableVendLedgEntry;
                            TempPayableVendLedgEntry2.Insert();
                        UNTIL TmpPayableVendLedgEntry.Next() = 0;

                    TempPayableVendLedgEntry2.SETFILTER("Currency Code", '<>%1', BankAccValue."Currency Code");
                    SeveralCurrencies := SeveralCurrencies OR not TempPayableVendLedgEntry2.IsEmpty();

                    IF SeveralCurrencies THEN
                        MessageText :=
                          STRSUBSTNO(Text020Lbl, BankAccValue.FIELDCAPTION("Currency Code"), BankAccValue."Currency Code")
                    ELSE
                        MessageText :=
                          STRSUBSTNO(Text021Lbl, BankAccValue.FIELDCAPTION("Currency Code"), BankAccValue."Currency Code");
                END ELSE
                    MessageText := Text022Lbl;
            END;
    end;

    local procedure ClearNegative()
    var
        TempCurrency: Record "Currency" temporary;
        TempPayableVendorLedgerEntry: Record "Payable Vendor Ledger Entry" temporary;
        CurrencyBalance: Decimal;
    begin
        CLEAR(TempPayableVendLedgEntry);
        TempPayableVendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");

        WHILE TempPayableVendLedgEntry.next() <> 0 DO BEGIN
            TempCurrency.Code := TempPayableVendLedgEntry."Currency Code";
            CurrencyBalance := 0;
            IF TempCurrency.Insert() THEN BEGIN
                TempPayableVendorLedgerEntry := TempPayableVendLedgEntry;
                TempPayableVendLedgEntry.SETRANGE("Currency Code", TempPayableVendLedgEntry."Currency Code");
                REPEAT
                    CurrencyBalance := CurrencyBalance + TempPayableVendLedgEntry."Amount (LCY)"
                UNTIL TempPayableVendLedgEntry.Next() = 0;
                IF CurrencyBalance < 0 THEN BEGIN
                    TempPayableVendLedgEntry.DeleteAll();
                    AmountAvailable += CurrencyBalance;
                END;
                TempPayableVendLedgEntry.SETRANGE("Currency Code");
                TempPayableVendLedgEntry := TempPayableVendorLedgerEntry;
            END;
        END;
        TempPayableVendLedgEntry.Reset();
    end;

    local procedure DimCodeIsInDimBuf(DimCode: Code[20]; DimBuf: Record "Dimension Buffer"): Boolean
    begin
        DimBuf.Reset();
        DimBuf.SETRANGE("Dimension Code", DimCode);
        EXIT(NOT DimBuf.IsEmpty());
    end;

    local procedure RemovePaymentsAboveLimit(var PayableVendLedgEntry: Record "Payable Vendor Ledger Entry"; RemainingAmtAvailable: Decimal)
    begin
        PayableVendLedgEntry.SETFILTER("Amount (LCY)", '>%1', RemainingAmtAvailable);
        PayableVendLedgEntry.DeleteAll();
        PayableVendLedgEntry.SETRANGE("Amount (LCY)");
    end;

    local procedure InsertDimBuf(var DimBuf: Record "Dimension Buffer"; TableID: Integer; EntryNo: Integer; DimCode: Code[20]; DimValue: Code[20])
    begin
        DimBuf.Init();
        DimBuf."Table ID" := TableID;
        DimBuf."Entry No." := EntryNo;
        DimBuf."Dimension Code" := DimCode;
        DimBuf."Dimension Value Code" := DimValue;
        DimBuf.Insert();
    end;

    local procedure GetMessageToRecipient(SummarizePerVend: Boolean): Text[140]
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        IF SummarizePerVend THEN
            EXIT(CompanyInformation.Name);

        VendorLedgerEntry.GET(TempPaymentBuffer."Vendor Ledg. Entry No.");
        IF VendorLedgerEntry."Message to Recipient" <> '' THEN
            EXIT(VendorLedgerEntry."Message to Recipient");

        EXIT(
          STRSUBSTNO(
            MessageToRecipientMsg,
            TempPaymentBuffer."Vendor Ledg. Entry Doc. Type",
            TempPaymentBuffer."Applies-to Ext. Doc. No."));
    end;

    local procedure SetPostingDate(var GenJnlLine: Record "Gen. Journal Line"; DueDate: Date; PostingDate: Date): Boolean
    begin
        IF NOT UseDueDateAsPostingDateValue THEN BEGIN
            GenJnlLine.VALIDATE("Posting Date", PostingDate);
            EXIT(FALSE);
        END;

        IF DueDate = 0D THEN
            DueDate := GenJnlLine.GetAppliesToDocDueDate();
        EXIT(GenJnlLine.SetPostingDateAsDueDate(DueDate, DueDateOffsetValue));
    end;

    local procedure GetApplDueDate(VendLedgEntryNo: Integer): Date
    var
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
    begin
        IF AppliedVendLedgEntry.GET(VendLedgEntryNo) THEN
            EXIT(AppliedVendLedgEntry."Due Date");

        EXIT(PostingDateValue);
    end;

    local procedure AdjustAgainstSelectedDim(var TempDimSetEntry: Record "Dimension Set Entry" temporary; var TempDimSetEntry2: Record "Dimension Set Entry" temporary): Boolean
    begin
        IF SelectedDim.FindSet() THEN BEGIN
            REPEAT
                TempDimSetEntry.SETRANGE("Dimension Code", SelectedDim."Dimension Code");
                IF TempDimSetEntry.FindFirst() THEN BEGIN
                    TempDimSetEntry2.TRANSFERFIELDS(TempDimSetEntry, TRUE);
                    TempDimSetEntry2.Insert();
                END;
            UNTIL SelectedDim.Next() = 0;
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    local procedure SetTempPaymentBufferDims(var DimBuf: Record "Dimension Buffer")
    var
        GLSetup: Record "General Ledger Setup";
        EntryNo: Integer;
    begin
        IF SummarizePerDim THEN BEGIN
            DimBuf.Reset();
            DimBuf.DeleteAll();
            IF SelectedDim.FindSet() THEN
                REPEAT
                    IF DimSetEntry.GET(VendLedgEntry."Dimension Set ID", SelectedDim."Dimension Code") THEN
                        InsertDimBuf(DimBuf, DATABASE::"Dimension Buffer", 0, DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
                UNTIL SelectedDim.Next() = 0;
            EntryNo := DimBufMgt.FindDimensions(DimBuf);
            IF EntryNo = 0 THEN
                EntryNo := DimBufMgt.InsertDimensions(DimBuf);
            TempPaymentBuffer."Dimension Entry No." := EntryNo;
            IF TempPaymentBuffer."Dimension Entry No." <> 0 THEN BEGIN
                GLSetup.Get();
                IF DimCodeIsInDimBuf(GLSetup."Global Dimension 1 Code", DimBuf) THEN
                    TempPaymentBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code"
                ELSE
                    TempPaymentBuffer."Global Dimension 1 Code" := '';
                IF DimCodeIsInDimBuf(GLSetup."Global Dimension 2 Code", DimBuf) THEN
                    TempPaymentBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code"
                ELSE
                    TempPaymentBuffer."Global Dimension 2 Code" := '';
            END ELSE BEGIN
                TempPaymentBuffer."Global Dimension 1 Code" := '';
                TempPaymentBuffer."Global Dimension 2 Code" := '';
            END;
            TempPaymentBuffer."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
        END ELSE BEGIN
            TempPaymentBuffer."Dimension Entry No." := 0;
            TempPaymentBuffer."Global Dimension 1 Code" := '';
            TempPaymentBuffer."Global Dimension 2 Code" := '';
            TempPaymentBuffer."Dimension Set ID" := 0;
        END;
    end;

    local procedure IsEntryAlreadyApplied(GenJnlLine3: Record "Gen. Journal Line"; VendLedgEntry2: Record "Vendor Ledger Entry"): Boolean
    var
        GenJnlLine4: Record "Gen. Journal Line";
    begin
        GenJnlLine4.SETRANGE("Journal Template Name", GenJnlLine3."Journal Template Name");
        GenJnlLine4.SETRANGE("Journal Batch Name", GenJnlLine3."Journal Batch Name");
        GenJnlLine4.SETRANGE("Account Type", GenJnlLine4."Account Type"::Vendor);
        GenJnlLine4.SETRANGE("Account No.", VendLedgEntry2."Vendor No.");
        GenJnlLine4.SETRANGE("Applies-to Doc. Type", VendLedgEntry2."Document Type");
        GenJnlLine4.SETRANGE("Applies-to Doc. No.", VendLedgEntry2."Document No.");
        EXIT(NOT GenJnlLine4.IsEmpty());
    end;

    local procedure SetDefaults()
    begin
        GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
            GenJnlLine2."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
            GenJnlLine2."Bal. Account No." := GenJnlBatch."Bal. Account No.";
        END;
        SetDefaultPmtMethodValue := true;
    end;

    local procedure CollectExistingPaymentLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
        LineFound: Boolean;
    begin
        IF NOT CheckOtherJournalBatchesValue THEN
            EXIT;

        IF TempPaymentBuffer.FindSet() THEN
            REPEAT
                LineFound := FALSE;
                GenJournalLine.SETRANGE("Document Type", GenJournalLine."Document Type"::Payment);
                GenJournalLine.SETRANGE("Account Type", GenJournalLine."Account Type"::Vendor);
                GenJournalLine.SETRANGE("Account No.", TempPaymentBuffer."Vendor No.");
                GenJournalLine.SETRANGE("Applies-to Doc. Type", TempPaymentBuffer."Vendor Ledg. Entry Doc. Type");
                GenJournalLine.SETRANGE("Applies-to Doc. No.", TempPaymentBuffer."Vendor Ledg. Entry Doc. No.");
                IF GenJournalLine.FindSet() THEN
                    REPEAT
                        IF (GenJournalLine."Journal Batch Name" <> GenJnlLine."Journal Batch Name") OR
                           (GenJournalLine."Journal Template Name" <> GenJnlLine."Journal Template Name")
                        THEN BEGIN
                            TempErrorMessage.LogMessage(
                              GenJournalLine, GenJournalLine.FIELDNO("Applies-to ID"),
                              TempErrorMessage."Message Type"::Warning,
                              STRSUBSTNO(
                                NotSuggestedPaymentInfoTxt,
                                GenJournalLine.FIELDCAPTION("Journal Template Name"),
                                GenJournalLine."Journal Template Name",
                                GenJournalLine.FIELDCAPTION("Journal Batch Name"),
                                GenJournalLine."Journal Batch Name",
                                GenJournalLine.FIELDCAPTION("Applies-to Doc. No."),
                                GenJournalLine."Applies-to Doc. No."));
                            LineFound := TRUE;
                        END;
                    UNTIL GenJournalLine.Next() = 0;
                IF LineFound THEN
                    TempPaymentBuffer.Delete();
            UNTIL TempPaymentBuffer.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateTempBufferFromVendorLedgerEntry(var TempPaymentBuffer: Record "Payment Buffer" temporary; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempPaymentBuffer: Record "Payment Buffer" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetVendLedgEntriesOnBeforeLoop(var VendorLedgerEntry: Record "Vendor Ledger Entry"; PostingDate: Date; LastDueDateToPayReq: Date; Future: Boolean; var IsHandled: Boolean)
    begin
    end;
}

