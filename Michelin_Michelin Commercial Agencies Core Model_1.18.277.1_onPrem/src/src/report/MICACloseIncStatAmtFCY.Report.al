report 81170 "MICA Close Inc. Stat. Amt. FCY"
{
    AdditionalSearchTerms = 'year closing statement,close accounting period statement,close fiscal year statement';
    ApplicationArea = Basic, Suite;
    Caption = 'Close Income Statement - Including Amount FCY';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.") WHERE("Account Type" = CONST(Posting), "Income/Balance" = CONST("Income Statement"));
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No.");
                DataItemTableView = SORTING("G/L Account No.", "Posting Date");

                trigger OnAfterGetRecord()
                var
                    TempDimBuf: Record "Dimension Buffer" temporary;
                    TempDimBuf2: Record "Dimension Buffer" temporary;
                    DimensionBufferID: Integer;
                    RowOffset: Integer;
                begin
                    EntryCount := EntryCount + 1;
                    if CurrentDateTime - LastWindowUpdateDateTime > 1000 then begin
                        LastWindowUpdateDateTime := CurrentDateTime;
                        WindowDialog.Update(3, Round(EntryCount / MaxEntry * 10000, 1));
                    end;

                    if GroupSum() then begin
                        CalcSumsInFilter("G/L Entry", RowOffset);
                        GetGLEntryDimensions("Entry No.", TempDimBuf, "Dimension Set ID");
                    end;

                    if Amount <> 0 then begin
                        if not GroupSum() then begin
                            TotalAmount += Amount;
                            if GeneralLedgerSetup."Additional Reporting Currency" <> '' then
                                TotalAmountAddCurr += "Additional-Currency Amount";

                            GetGLEntryDimensions("Entry No.", TempDimBuf, "Dimension Set ID");
                        end;

                        if TempSelectedDimension.Find('-') then
                            repeat
                                if TempDimBuf.Get(DATABASE::"G/L Entry", "Entry No.", TempSelectedDimension."Dimension Code")
                                then begin
                                    TempDimBuf2."Table ID" := TempDimBuf."Table ID";
                                    TempDimBuf2."Dimension Code" := TempDimBuf."Dimension Code";
                                    TempDimBuf2."Dimension Value Code" := TempDimBuf."Dimension Value Code";
                                    TempDimBuf2.Insert();
                                end;
                            until TempSelectedDimension.Next() = 0;

                        DimensionBufferID := DimensionBufferManagement.GetDimensionId(TempDimBuf2);

                        CreateGenJournalLines(FoundGenJournalLine, LineNo, "G/L Entry", DimensionBufferID);
                    end;

                    if GroupSum() then
                        Next(RowOffset);
                end;

                trigger OnPostDataItem()
                begin
                    TempEntryNoAmountBuffer.Reset();
                    MaxEntry := TempEntryNoAmountBuffer.Count();
                    EntryCount := 0;
                    WindowDialog.Update(2, Text012Lbl);
                    WindowDialog.Update(3, 0);
                end;

                trigger OnPreDataItem()
                begin
                    WindowDialog.Update(2, Text013Lbl);
                    WindowDialog.Update(3, 0);

                    if ClosePerGlobalDimOnly or ClosePerBusUnit then
                        case true of
                            ClosePerBusUnit and (ClosePerGlobalDim1 or ClosePerGlobalDim2):
                                SetCurrentKey(
                                  "G/L Account No.", "Business Unit Code",
                                  "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                            ClosePerBusUnit and not (ClosePerGlobalDim1 or ClosePerGlobalDim2):
                                SetCurrentKey(
                                  "G/L Account No.", "Business Unit Code", "Posting Date");
                            not ClosePerBusUnit and (ClosePerGlobalDim1 or ClosePerGlobalDim2):
                                SetCurrentKey(
                                  "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                        end;

                    SetRange("Posting Date", FiscalYearStartDate, FiscYearClosingDate);

                    MaxEntry := Count;

                    TempEntryNoAmountBuffer.DeleteAll();
                    EntryCount := 0;

                    LastWindowUpdateDateTime := CurrentDateTime;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ThisAccountNo := ThisAccountNo + 1;
                WindowDialog.Update(1, "No.");
                WindowDialog.Update(4, Round(ThisAccountNo / NoOfAccounts * 10000, 1));
                WindowDialog.Update(2, '');
                WindowDialog.Update(3, 0);
            end;

            trigger OnPostDataItem()
            begin
                if ((TotalAmount <> 0) or ((TotalAmountAddCurr <> 0) and (GeneralLedgerSetup."Additional Reporting Currency" <> ''))) and
                   (PostToRetainedEarningsAcc = PostToRetainedEarningsAcc::Balance)
                then begin
                    FoundGenJournalLine."Business Unit Code" := '';
                    FoundGenJournalLine."Shortcut Dimension 1 Code" := '';
                    FoundGenJournalLine."Shortcut Dimension 2 Code" := '';
                    FoundGenJournalLine."Dimension Set ID" := 0;
                    FoundGenJournalLine."Line No." := FoundGenJournalLine."Line No." + 10000;
                    FoundGenJournalLine."Account No." := RetainedEarningsGLAccount."No.";
                    FoundGenJournalLine."Source Code" := SourceCodeSetup."Close Income Statement";
                    FoundGenJournalLine."Reason Code" := FoundGenJournalBatch."Reason Code";
                    FoundGenJournalLine."Currency Code" := '';
                    FoundGenJournalLine."Additional-Currency Posting" :=
                      FoundGenJournalLine."Additional-Currency Posting"::None;
                    FoundGenJournalLine.Validate(Amount, TotalAmount);
                    FoundGenJournalLine."Source Currency Amount" := TotalAmountAddCurr;
                    HandleGenJnlLine();
                    WindowDialog.Update(1, FoundGenJournalLine."Account No.");
                end;
            end;

            trigger OnPreDataItem()
            begin
                NoOfAccounts := Count;
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
                    field(FiscalYearEndingDate; EndDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fiscal Year Ending Date';
                        ToolTip = 'Specifies the last date in the closed fiscal year. This date is used to determine the closing date.';

                        trigger OnValidate()
                        begin
                            ValidateEndDate(true);
                        end;
                    }
                    field(GenJournalTemplate; FoundGenJournalLine."Journal Template Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Journal Template';
                        TableRelation = "Gen. Journal Template";
                        ToolTip = 'Specifies the general journal template that is used by the batch job.';

                        trigger OnValidate()
                        begin
                            FoundGenJournalLine."Journal Batch Name" := '';
                            DocNo := '';
                        end;
                    }
                    field(GenJournalBatch; FoundGenJournalLine."Journal Batch Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Journal Batch';
                        Lookup = true;
                        ToolTip = 'Specifies the general journal batch that is used by the batch job.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            FoundGenJournalLine.TestField("Journal Template Name");
                            FoundGenJournalTemplate.Get(FoundGenJournalLine."Journal Template Name");
                            FoundGenJournalBatch.FilterGroup(2);
                            FoundGenJournalBatch.SetRange("Journal Template Name", FoundGenJournalLine."Journal Template Name");
                            FoundGenJournalBatch.FilterGroup(0);
                            FoundGenJournalBatch."Journal Template Name" := FoundGenJournalLine."Journal Template Name";
                            FoundGenJournalBatch.Name := FoundGenJournalLine."Journal Batch Name";
                            if PAGE.RunModal(0, FoundGenJournalBatch) = ACTION::LookupOK then begin
                                Text := FoundGenJournalBatch.Name;
                                exit(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            if FoundGenJournalLine."Journal Batch Name" <> '' then begin
                                FoundGenJournalLine.TestField("Journal Template Name");
                                FoundGenJournalBatch.Get(FoundGenJournalLine."Journal Template Name", FoundGenJournalLine."Journal Batch Name");
                            end;
                            ValidateJnl();
                        end;
                    }
                    field(DocumentNo; DocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the number of the document that is processed by the report or batch job.';
                    }
                    field(RetainedEarningsAcc; RetainedEarningsGLAccount."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Retained Earnings Acc.';
                        TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                             "Account Category" = FILTER(" " | Equity),
                                                             "Income/Balance" = CONST("Balance Sheet"));
                        ToolTip = 'Specifies the retained earnings account that the batch job posts to. This account should be the same as the account that is used by the Close Income Statement batch job.';

                        trigger OnValidate()
                        begin
                            if RetainedEarningsGLAccount."No." <> '' then begin
                                RetainedEarningsGLAccount.Find();
                                RetainedEarningsGLAccount.CheckGLAcc();
                            end;
                        end;
                    }
                    field(PostToRetainedEarningsAccount; PostToRetainedEarningsAcc)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post to Retained Earnings Acc.';
                        OptionCaption = 'Balance,Details';
                        ToolTip = 'Specifies if the resulting entries are posted with the Retained Earnings account as a balancing account on each line (Details) or if retained earnings are posted as an extra line with a summarized amount (Balance).';
                    }
                    field(PostingDescriptionReqParam; PostingDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Description';
                        ToolTip = 'Specifies the description that accompanies the posting.';
                    }
                    group("Close by")
                    {
                        Caption = 'Close by';
                        field(ClosePerBusUnitReqParam; ClosePerBusUnit)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Business Unit Code';
                            ToolTip = 'Specifies the code for the business unit, in a company group structure.';
                        }
                        field(Dimensions; ColumnDim)
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Dimensions';
                            Editable = false;
                            ToolTip = 'Specifies dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                            trigger OnAssistEdit()
                            var
                                TempSelectedDim2: Record "Selected Dimension" temporary;
                                s: Text[1024];
                            begin
                                DimensionSelectionBuffer.SetDimSelectionMultiple(3, REPORT::"Close Income Statement", ColumnDim);

                                SelectedDimension.GetSelectedDim(CopyStr(UserId(), 1, 50), 3, REPORT::"Close Income Statement", '', TempSelectedDim2);
                                s := CheckDimPostingRules(TempSelectedDim2);
                                if s <> '' then
                                    Message(s);
                            end;
                        }
                    }
                    field(InventoryPeriodClosed; IsInvtPeriodClosed())
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Period Closed';
                        ToolTip = 'Specifies that the inventory period has been closed.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            GLAccount: Record "G/L Account";
            GLAccountCategory: Record "G/L Account Category";
        begin
            if PostingDescription = '' then
                PostingDescription :=
                  CopyStr(ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Report, REPORT::"Close Income Statement"), 1, 30);
            EndDateReq := 0D;
            AccountingPeriod.SetRange("New Fiscal Year", true);
            AccountingPeriod.SetRange("Date Locked", true);
            if AccountingPeriod.FindLast() then begin
                EndDateReq := AccountingPeriod."Starting Date" - 1;
                if not ValidateEndDate(false) then
                    EndDateReq := 0D;
            end else
                if EndDateReq = 0D then
                    Error(NoFiscalYearsErr);
            ValidateJnl();
            ColumnDim := DimensionSelectionBuffer.GetDimSelectionText(3, REPORT::"Close Income Statement", '');
            if RetainedEarningsGLAccount."No." = '' then begin
                GLAccountCategory.SetRange("Account Category", GLAccountCategory."Account Category"::Equity);
                GLAccountCategory.SetRange(
                  "Additional Report Definition", GLAccountCategory."Additional Report Definition"::"Retained Earnings");
                if GLAccountCategory.FindFirst() then begin
                    GLAccount.SetRange("Account Subcategory Entry No.", GLAccountCategory."Entry No.");
                    if GLAccount.FindFirst() then
                        RetainedEarningsGLAccount."No." := GLAccount."No.";
                end;
            end;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        WindowDialog.Close();
        Commit();
        if GeneralLedgerSetup."Additional Reporting Currency" <> '' then begin
            Message(Text016Msg);
            UpdateAnalysisView.UpdateAll(0, true);
        end else
            Message(Text017Lbl);
    end;

    trigger OnPreReport()
    var
        s: Text[1024];
        IsHandled: Boolean;
    begin
        if EndDateReq = 0D then
            Error(Text000Err);
        ValidateEndDate(true);
        if DocNo = '' then
            Error(Text001Err);

        SelectedDimension.GetSelectedDim(CopyStr(UserId(), 1, 50), 3, REPORT::"Close Income Statement", '', TempSelectedDimension);
        IsHandled := false;
        OnPreReportOnBeforeCheckDimPostingRules(IsHandled);
        if not IsHandled then begin
            s := CheckDimPostingRules(TempSelectedDimension);
            if s <> '' then
                if not Confirm(s + Text007Qst, false) then
                    Error('');
        end;

        FoundGenJournalBatch.Get(FoundGenJournalLine."Journal Template Name", FoundGenJournalLine."Journal Batch Name");
        SourceCodeSetup.Get();
        GeneralLedgerSetup.Get();
        if GeneralLedgerSetup."Additional Reporting Currency" <> '' then begin
            if RetainedEarningsGLAccount."No." = '' then
                Error(Text002Err);
            if not Confirm(
                 Text003Qst +
                 Text005Qst +
                 Text007Qst, false)
            then
                Error('');
        end;

        WindowDialog.Open(Text008Lbl + Text009Lbl + Text019Lbl + Text010Lbl + Text011Lbl);

        ClosePerGlobalDim1 := false;
        ClosePerGlobalDim2 := false;
        ClosePerGlobalDimOnly := true;

        if TempSelectedDimension.Find('-') then
            repeat
                if TempSelectedDimension."Dimension Code" = GeneralLedgerSetup."Global Dimension 1 Code" then
                    ClosePerGlobalDim1 := true;
                if TempSelectedDimension."Dimension Code" = GeneralLedgerSetup."Global Dimension 2 Code" then
                    ClosePerGlobalDim2 := true;
                if (TempSelectedDimension."Dimension Code" <> GeneralLedgerSetup."Global Dimension 1 Code") and
                   (TempSelectedDimension."Dimension Code" <> GeneralLedgerSetup."Global Dimension 2 Code")
                then
                    ClosePerGlobalDimOnly := false;
            until TempSelectedDimension.Next() = 0;

        FoundGenJournalLine.SetRange("Journal Template Name", FoundGenJournalLine."Journal Template Name");
        FoundGenJournalLine.SetRange("Journal Batch Name", FoundGenJournalLine."Journal Batch Name");
        if not FoundGenJournalLine.FindLast() then;
        FoundGenJournalLine.Init();
        FoundGenJournalLine."Posting Date" := FiscYearClosingDate;
        FoundGenJournalLine."Document No." := DocNo;
        FoundGenJournalLine.Description := PostingDescription;
        FoundGenJournalLine."Posting No. Series" := FoundGenJournalBatch."Posting No. Series";
        Clear(GenJnlPostLine);

        LineNo := 0;
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        SourceCodeSetup: Record "Source Code Setup";
        FoundGenJournalTemplate: Record "Gen. Journal Template";
        FoundGenJournalBatch: Record "Gen. Journal Batch";
        FoundGenJournalLine: Record "Gen. Journal Line";
        RetainedEarningsGLAccount: Record "G/L Account";
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionSelectionBuffer: Record "Dimension Selection Buffer";
        ObjectTranslation: Record "Object Translation";
        SelectedDimension: Record "Selected Dimension";
        TempSelectedDimension: Record "Selected Dimension" temporary;
        TempEntryNoAmountBuffer: Record "Entry No. Amount Buffer" temporary;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DimensionManagement: Codeunit DimensionManagement;
        DimensionBufferManagement: Codeunit "Dimension Buffer Management";
        WindowDialog: Dialog;
        FiscalYearStartDate: Date;
        FiscYearClosingDate: Date;
        EndDateReq: Date;
        DocNo: Code[20];
        PostingDescription: Text[100];
        ClosePerBusUnit: Boolean;
        ClosePerGlobalDim1: Boolean;
        ClosePerGlobalDim2: Boolean;
        ClosePerGlobalDimOnly: Boolean;
        TotalAmount: Decimal;
        TotalAmountAddCurr: Decimal;
        ColumnDim: Text[250];
        NoOfAccounts: Integer;
        ThisAccountNo: Integer;
        LineNo: Integer;
        Text000Err: Label 'Enter the ending date for the fiscal year.';
        Text001Err: Label 'Enter a Document No.';
        Text002Err: Label 'Enter Retained Earnings Account No.';
        Text003Qst: Label 'By using an additional reporting currency, this batch job will post closing entries directly to the general ledger.  ';
        Text005Qst: Label 'These closing entries will not be transferred to a general journal before the program posts them to the general ledger.\\ ';
        Text007Qst: Label '\Do you want to continue?';
        Text008Lbl: Label 'Creating general journal lines...\\';
        Text009Lbl: Label 'Account No.         #1##################\';
        Text010Lbl: Label 'Now performing      #2##################\';
        Text011Lbl: Label '                    @3@@@@@@@@@@@@@@@@@@\';
        Text019Lbl: Label '                    @4@@@@@@@@@@@@@@@@@@\';
        Text012Lbl: Label 'Creating Gen. Journal lines';
        Text013Lbl: Label 'Calculating Amounts';
        Text014Err: Label 'The fiscal year must be closed before the income statement can be closed.';
        Text015Err: Label 'The fiscal year does not exist.';
        Text017Lbl: Label 'The journal lines have successfully been created.';
        Text016Msg: Label 'The closing entries have successfully been posted.';
        Text020Err: Label 'The following G/L Accounts have mandatory dimension codes that have not been selected:';
        Text021Msg: Label '\\In order to post to these accounts you must also select these dimensions:';
        MaxEntry: Integer;
        EntryCount: Integer;
        LastWindowUpdateDateTime: DateTime;
        NoFiscalYearsErr: Label 'No closed fiscal year exists.';
        PostToRetainedEarningsAcc: Option Balance,Details;

    local procedure ValidateEndDate(RealMode: Boolean): Boolean
    var
        OK: Boolean;
    begin
        if EndDateReq = 0D then
            exit;

        OK := AccountingPeriod.Get(EndDateReq + 1);
        if OK then
            OK := AccountingPeriod."New Fiscal Year";
        if OK then begin
            if not AccountingPeriod."Date Locked" then begin
                if not RealMode then
                    exit;
                Error(Text014Err);
            end;
            FiscYearClosingDate := ClosingDate(EndDateReq);
            AccountingPeriod.SetRange("New Fiscal Year", true);
            OK := AccountingPeriod.Find('<');
            FiscalYearStartDate := AccountingPeriod."Starting Date";
        end;
        if not OK then begin
            if not RealMode then
                exit;
            Error(Text015Err);
        end;
        exit(true);
    end;

    local procedure ValidateJnl()
    begin
        DocNo := '';
        if FoundGenJournalBatch.Get(FoundGenJournalLine."Journal Template Name", FoundGenJournalLine."Journal Batch Name") then
            if FoundGenJournalBatch."No. Series" <> '' then
                DocNo := NoSeriesManagement.TryGetNextNo(FoundGenJournalBatch."No. Series", EndDateReq);
    end;

    local procedure HandleGenJnlLine()
    begin
        OnBeforeHandleGenJnlLine(FoundGenJournalLine);

        FoundGenJournalLine."Additional-Currency Posting" :=
          FoundGenJournalLine."Additional-Currency Posting"::None;
        if GeneralLedgerSetup."Additional Reporting Currency" <> '' then begin
            FoundGenJournalLine."Source Currency Code" := GeneralLedgerSetup."Additional Reporting Currency";
            if ZeroGenJnlAmount() then begin
                FoundGenJournalLine."Additional-Currency Posting" :=
                  FoundGenJournalLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                FoundGenJournalLine.Validate(Amount, FoundGenJournalLine."Source Currency Amount");
                FoundGenJournalLine."Source Currency Amount" := 0;
            end;
            if FoundGenJournalLine.Amount <> 0 then begin
                GenJnlPostLine.Run(FoundGenJournalLine);
                if DocNo = NoSeriesManagement.GetNextNo(FoundGenJournalBatch."No. Series", EndDateReq, false) then
                    NoSeriesManagement.SaveNoSeries();
            end;
        end else
            if not ZeroGenJnlAmount() then
                FoundGenJournalLine.Insert();
    end;

    local procedure CalcSumsInFilter(var SourceGLEntry: Record "G/L Entry"; var Offset: Integer)
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.CopyFilters(SourceGLEntry);
        if ClosePerBusUnit then begin
            GLEntry.SetRange("Business Unit Code", SourceGLEntry."Business Unit Code");
            FoundGenJournalLine."Business Unit Code" := SourceGLEntry."Business Unit Code";
        end;
        if ClosePerGlobalDim1 then begin
            GLEntry.SetRange("Global Dimension 1 Code", SourceGLEntry."Global Dimension 1 Code");
            if ClosePerGlobalDim2 then
                GLEntry.SetRange("Global Dimension 2 Code", SourceGLEntry."Global Dimension 2 Code");
        end;

        GLEntry.CalcSums(Amount);
        SourceGLEntry.Amount := GLEntry.Amount;
        TotalAmount += SourceGLEntry.Amount;
        if GeneralLedgerSetup."Additional Reporting Currency" <> '' then begin
            GLEntry.CalcSums("Additional-Currency Amount");
            SourceGLEntry."Additional-Currency Amount" := GLEntry."Additional-Currency Amount";
            TotalAmountAddCurr += SourceGLEntry."Additional-Currency Amount";
        end;
        Offset := GLEntry.Count - 1;
    end;

    local procedure GetGLEntryDimensions(EntryNo: Integer; var DimensionBuffer: Record "Dimension Buffer"; DimensionSetID: Integer)
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        DimensionSetEntry.SetRange("Dimension Set ID", DimensionSetID);
        if DimensionSetEntry.FindSet() then
            repeat
                DimensionBuffer."Table ID" := DATABASE::"G/L Entry";
                DimensionBuffer."Entry No." := EntryNo;
                DimensionBuffer."Dimension Code" := DimensionSetEntry."Dimension Code";
                DimensionBuffer."Dimension Value Code" := DimensionSetEntry."Dimension Value Code";
                DimensionBuffer.Insert();
            until DimensionSetEntry.Next() = 0;
    end;

    local procedure CheckDimPostingRules(var LocSelectedDimension: Record "Selected Dimension"): Text[1024]
    var
        DefaultDimension: Record "Default Dimension";
        ErrorText: Text[1024];
        DimText: Text[1024];
        PrevAcc: Code[20];
        Handled: Boolean;
    begin
        PrevAcc := '';

        OnBeforeCheckDimPostingRules(LocSelectedDimension, ErrorText, Handled, FoundGenJournalLine);
        if Handled then
            exit(ErrorText);

        DefaultDimension.SetRange("Table ID", DATABASE::"G/L Account");
        DefaultDimension.SetFilter(
          "Value Posting", '%1|%2',
          DefaultDimension."Value Posting"::"Same Code", DefaultDimension."Value Posting"::"Code Mandatory");

        if DefaultDimension.Find('-') then
            repeat
                LocSelectedDimension.SetRange("Dimension Code", DefaultDimension."Dimension Code");
                if not LocSelectedDimension.Find('-') then begin
                    if StrPos(DimText, DefaultDimension."Dimension Code") < 1 then
                        DimText := CopyStr((DimText + ' ' + Format(DefaultDimension."Dimension Code")), 1, MaxStrLen(DimText));
                    if PrevAcc <> DefaultDimension."No." then begin
                        PrevAcc := DefaultDimension."No.";
                        if ErrorText = '' then
                            ErrorText := Text020Err;
                        ErrorText := CopyStr((ErrorText + ' ' + Format(DefaultDimension."No.")), 1, MaxStrLen(ErrorText));
                    end;
                end;
                LocSelectedDimension.SetRange("Dimension Code");
            until (DefaultDimension.Next() = 0) or (StrLen(ErrorText) > MaxStrLen(ErrorText) - MaxStrLen(DefaultDimension."No.") - StrLen(Text021Msg) - 1);
        if ErrorText <> '' then
            ErrorText := CopyStr(ErrorText + Text021Msg + DimText, 1, MaxStrLen(ErrorText));
        exit(ErrorText);
    end;

    local procedure IsInvtPeriodClosed(): Boolean
    var
        FoundAccountingPeriod: Record "Accounting Period";
        GetInventoryPeriod: Record "Inventory Period";
    begin
        if EndDateReq = 0D then
            exit;
        FoundAccountingPeriod.Get(EndDateReq + 1);
        FoundAccountingPeriod.Next(-1);
        exit(GetInventoryPeriod.IsInvtPeriodClosed(FoundAccountingPeriod."Starting Date"));
    end;

    procedure InitializeRequestTest(EndDate: Date; GenJournalLine: Record "Gen. Journal Line"; GLAccount: Record "G/L Account"; CloseByBU: Boolean)
    begin
        EndDateReq := EndDate;
        FoundGenJournalLine := GenJournalLine;
        ValidateJnl();
        RetainedEarningsGLAccount := GLAccount;
        ClosePerBusUnit := CloseByBU;
    end;

    local procedure CreateGenJournalLines(var GenJournalLine: Record "Gen. Journal Line"; var LineNo: Integer; GLEntry: Record "G/L Entry"; DimID: Integer)
    begin
        LineNo += 10000;

        if GLEntry.Amount <> 0 then begin
            GenJournalLine.SetRange("Account No.", GLEntry."G/L Account No.");
            GenJournalLine.SetRange("Currency Code", GLEntry."MICA Currency Code");
            if not GenJournalLine.FindFirst() then begin
                PopulateGenJnlLineTable(GenJournalLine, LineNo, GLEntry, true);

                UpdateDimensions(GenJournalLine, DimID);

                GenJournalLine."Allow Zero-Amount Posting" := true; //Used to separate Gen. Jnl. Lines when this report is run and only in this case

                GenJournalLine.Insert();
            end else begin
                FillAmtFields(GenJournalLine, GLEntry, false);
                GenJournalLine.Modify();
            end;
        end;
    end;

    local procedure PopulateGenJnlLineTable(var GenJournalLine: Record "Gen. Journal Line"; LineNo: Integer; GLEntry: Record "G/L Entry"; InsertOrModify: Boolean)
    begin
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account No." := GLEntry."G/L Account No.";
        GenJournalLine."Source Code" := SourceCodeSetup."Close Income Statement";
        GenJournalLine."Reason Code" := FoundGenJournalBatch."Reason Code";
        GenJournalLine."Currency Code" := GLEntry."MICA Currency Code";

        FillAmtFields(GenJournalLine, GLEntry, InsertOrModify);

        GenJournalLine."Source Currency Amount" := -GLEntry."Additional-Currency Amount";
        if ClosePerBusUnit and GLEntry.FieldActive("Business Unit Code") then
            GenJournalLine."Business Unit Code" := GLEntry."Business Unit Code"
        else
            GenJournalLine."Business Unit Code" := '';

        if PostToRetainedEarningsAcc = PostToRetainedEarningsAcc::Details then begin
            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
            GenJournalLine."Bal. Account No." := RetainedEarningsGLAccount."No.";
            GenJournalLine.UpdateLineBalance();
        end;
    end;

    local procedure FillAmtFields(var GenJournalLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; InsertOrModify: Boolean)
    begin
        if InsertOrModify then begin
            if GLEntry."MICA Currency Code" = '' then
                GenJournalLine.Validate(Amount, -GLEntry.Amount)
            else begin
                GenJournalLine.Amount := -GLEntry."MICA Amount (FCY)";
                GenJournalLine."Amount (LCY)" := -GLEntry.Amount;
                FillDebitCreditAmounts(GenJournalLine, GLEntry, InsertOrModify);
            end;
        end else
            if GLEntry."MICA Currency Code" = '' then
                GenJournalLine.Validate(Amount, GenJournalLine.Amount + (-GLEntry.Amount))
            else begin
                GenJournalLine.Amount += -GLEntry."MICA Amount (FCY)";
                GenJournalLine."Amount (LCY)" += -GLEntry.Amount;
                FillDebitCreditAmounts(GenJournalLine, GLEntry, InsertOrModify);
            end;
    end;

    local procedure FillDebitCreditAmounts(var GenJournalLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; InsertOrModify: Boolean)
    begin
        if InsertOrModify then
            if GenJournalLine.Amount > 0 then
                GenJournalLine."Debit Amount" := -GLEntry."MICA Amount (FCY)"
            else
                GenJournalLine."Credit Amount" := GLEntry."MICA Amount (FCY)"
        else
            if GenJournalLine.Amount > 0 then
                GenJournalLine."Debit Amount" += -GLEntry."MICA Amount (FCY)"
            else
                GenJournalLine."Credit Amount" += GLEntry."MICA Amount (FCY)";
    end;

    local procedure UpdateDimensions(var GenJournalLine: Record "Gen. Journal Line"; DimID: Integer)
    var
        TempFoundDimensionBuffer: Record "Dimension Buffer" temporary;
        GlobalDimVal1: Code[20];
        GlobalDimVal2: Code[20];
        NewDimensionID: Integer;
    begin
        TempFoundDimensionBuffer.DeleteAll();
        DimensionBufferManagement.RetrieveDimensions(DimID, TempFoundDimensionBuffer);
        NewDimensionID := DimensionManagement.CreateDimSetIDFromDimBuf(TempFoundDimensionBuffer);
        GenJournalLine."Dimension Set ID" := NewDimensionID;
        DimensionManagement.UpdateGlobalDimFromDimSetID(NewDimensionID, GlobalDimVal1, GlobalDimVal2);
        GenJournalLine."Shortcut Dimension 1 Code" := '';
        if ClosePerGlobalDim1 then
            GenJournalLine."Shortcut Dimension 1 Code" := GlobalDimVal1;
        GenJournalLine."Shortcut Dimension 2 Code" := '';
        if ClosePerGlobalDim2 then
            GenJournalLine."Shortcut Dimension 2 Code" := GlobalDimVal2;
    end;

    local procedure ZeroGenJnlAmount(): Boolean
    begin
        exit((FoundGenJournalLine.Amount = 0) and (FoundGenJournalLine."Source Currency Amount" <> 0))
    end;

    local procedure GroupSum(): Boolean
    begin
        exit(ClosePerGlobalDimOnly and (ClosePerBusUnit or ClosePerGlobalDim1));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckDimPostingRules(var SelectedDimension: Record "Selected Dimension"; var ErrorText: Text[1024]; var Handled: Boolean; TerGenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeHandleGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPreReportOnBeforeCheckDimPostingRules(var IsHandled: Boolean)
    begin
    end;
}

