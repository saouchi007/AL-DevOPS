report 81880 "MICA Create Accrual"
{
    Caption = 'Create Deferred Rebates';
    ProcessingOnly = true;
    UsageCategory = None;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    Caption = 'Options';
                    field("Posting Date"; InputPostingDate)
                    {
                        Caption = 'Posting Date';
                        ToolTip = 'The date value will define the posting date for Deferred Rebates entries';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
    begin
        CheckPostingAccountSetup();

        MICAFinancialReportingSetup.Get();
        GeneralLedgerSetup.Get();
        Clear(ClosingDocNo);

        GetGnlJnlBatch();
        CheckGenJnlLine();

        LastDayInMonthForPosting := CalcDate('<CM>', InputPostingDate);
        FirstDayInNextMonth := CalcDate('<CM+1D>', InputPostingDate);

        //Grouping accrual entries and create General Journal
        MICACustomerAccrualEntry.SetAutoCalcFields("Accruals Amount");
        MICACustomerAccrualEntry.SetRange(Open, true);
        MICACustomerAccrualEntry.SetRange("Is Deffered", IsDeferred);
        if MICACustomerAccrualEntry.FindSet() then
            repeat
                if MICACustomerAccrualEntry."Accruals Amount" <> 0 then
                    GroupCustDetailAccrEntries(MICACustomerAccrualEntry);
            until MICACustomerAccrualEntry.Next() = 0;

        CreateGeneralJournal();
        ModifyOpenNonProcessedEntries(MICACustomerAccrualEntry);
        // Posting Accrual Journal
        // PostGenJournalBatch();

        //Closing Accrual Entries and Delete Detail Accrual Entries
        ClosingCustomerAccrualEntry();

        //Commented because, currently, we don't know does it will be used Rebate Global Amount
        //UpdateAccrualGlobalAmtOnAccrualSetup();

    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GenJournalBatch: Record "Gen. Journal Batch";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempMICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry" temporary;
        TempMICACustomerAccrualEntry: Record "MICA Customer Accrual Entry" temporary;
        ClosingDocNo: Code[20];
        LastDayInMonthForPosting: Date;
        FirstDayInNextMonth: Date;
        InputPostingDate: Date;
        IsDeferred: Boolean;
        JnlIsNotEmptyErr: Label 'Deferred Rebates Batch Journal is not empty. Please, check it first.';

    local procedure CheckGenJnlLine()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if not GenJournalLine.IsEmpty() then
            Error(JnlIsNotEmptyErr);
    end;

    local procedure CreateGeneralJournal()
    var
        LineNo: Integer;
    begin
        TempMICACustDetailAccrEntry.Reset();
        if TempMICACustDetailAccrEntry.FindSet() then
            repeat
                CreateAccrualJnlLine(LineNo, false, LastDayInMonthForPosting);
                CreateAccrualJnlLine(LineNo, true, FirstDayInNextMonth);
            until TempMICACustDetailAccrEntry.Next() = 0;
    end;

    local procedure CreateAccrualJnlLine(var LineNo: Integer; Cancel: Boolean; PostingDate: Date)
    var
        GenJournalLine: Record "Gen. Journal Line";
        LastGenJournalLine: Record "Gen. Journal Line";
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionManagement: Codeunit DimensionManagement;
    begin
        LineNo += 1;
        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if GenJournalLine.FindLast() then;
        LastGenJournalLine := GenJournalLine;
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := GenJournalBatch."Journal Template Name";
        GenJournalLine."Journal Batch Name" := GenJournalBatch.Name;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine.SetUpNewLine(LastGenJournalLine, 0, false);
        GenJournalLine.Insert(true);
        GenJournalLine.Validate("Posting Date", PostingDate);
        GenJournalLine.Validate("Document Date", PostingDate);
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.Validate("Account No.", TempMICACustDetailAccrEntry."Global Dimension 1 Code");
        if Cancel then begin
            GenJournalLine.Validate("Credit Amount", Round(TempMICACustDetailAccrEntry."Accruals Amount", 1, '='));
            GenJournalLine.Validate("MICA Type Of Transaction", GenJournalLine."MICA Type Of Transaction"::"Rebate Reversal");
        end else begin
            GenJournalLine.Validate("Debit Amount", Round(TempMICACustDetailAccrEntry."Accruals Amount", 1, '='));
            GenJournalLine.Validate("MICA Type Of Transaction", GenJournalLine."MICA Type Of Transaction"::"Rebate Creation");
        end;
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Bal. Account No." := TempMICACustDetailAccrEntry."Global Dimension 2 Code";
        DimensionManagement.GetDimensionSet(TempDimensionSetEntry, GenJournalLine."Dimension Set ID");
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Accrual Dimension Code", TempMICACustDetailAccrEntry.Code);
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Intercompany Dimension", TempMICACustDetailAccrEntry."Intercompany Dimension");
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Structure Dimension", TempMICACustDetailAccrEntry."Item No.");
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Section Dimension", TempMICACustDetailAccrEntry."Customer No.");
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Site Dimension Code", TempMICACustDetailAccrEntry."Site Dimension");
        GenJournalLine."Dimension Set ID" := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);
        DimensionManagement.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID", GenJournalLine."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 2 Code");
        GenJournalLine.Modify();
        if ClosingDocNo = '' then
            ClosingDocNo := GenJournalLine."Document No.";
    end;

    local procedure CreateDimensionEntry(var DimensionSetEntry: Record "Dimension Set Entry"; DimCode: Code[20]; DimValueCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
    begin
        if not DimensionValue.Get(DimCode, DimValueCode) then
            exit;

        DimensionSetEntry.Reset();
        DimensionSetEntry.SetRange("Dimension Code", DimCode);
        if DimensionSetEntry.FindFirst() then begin
            DimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
            DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
            DimensionSetEntry.Modify();
        end else begin
            DimensionSetEntry.Init();
            DimensionSetEntry."Dimension Code" := DimensionValue."Dimension Code";
            DimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
            DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
            DimensionSetEntry.Insert();
        end;
    end;

    local procedure GroupCustDetailAccrEntries(MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry")
    var
        MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
        StructureDim: Code[20];
        SectionDim: Code[20];
        PaidInvoices: Decimal;
    begin
        MICACustDetailAccrEntry.SetRange("Customer Accruals Entry No.", MICACustomerAccrualEntry."Entry No.");
        if MICACustDetailAccrEntry.FindSet() then
            repeat
                Clear(StructureDim);
                Clear(SectionDim);
                PaidInvoices := (MICACustDetailAccrEntry."Paid AR Credit Memo" + MICACustDetailAccrEntry."Paid AP Invoice");
                //Commented because, currently, we don't know does it will be used Rebate Global Amount
                //FillTempAccrualSetup(CustDtlAccrEntry,PaidInvoicesAvg);
                FillTempCustomerAccrualEntry(MICACustDetailAccrEntry, PaidInvoices);
                case MICAFinancialReportingSetup."Structure Dimension" of
                    GeneralLedgerSetup."Global Dimension 1 Code":
                        begin
                            StructureDim := MICACustDetailAccrEntry."Global Dimension 1 Code";
                            SectionDim := MICACustDetailAccrEntry."Global Dimension 2 Code";
                        end;
                    GeneralLedgerSetup."Global Dimension 2 Code":
                        begin
                            StructureDim := MICACustDetailAccrEntry."Global Dimension 2 Code";
                            SectionDim := MICACustDetailAccrEntry."Global Dimension 1 Code";
                        end;
                end;
                TempMICACustDetailAccrEntry.SetRange(Code, MICACustDetailAccrEntry.Code);
                TempMICACustDetailAccrEntry.SetRange("Item No.", StructureDim);
                if TempMICACustDetailAccrEntry.FindFirst() then
                    UpdateTempCustDtlAccrEntry(MICACustDetailAccrEntry."Accruals Amount" - PaidInvoices)
                else
                    InsertTempCustDtlAccrEntry(MICACustDetailAccrEntry, StructureDim, SectionDim, PaidInvoices);
            until MICACustDetailAccrEntry.Next() = 0;
    end;

    local procedure InsertTempCustDtlAccrEntry(MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry"; StructDim: Code[20]; SectionDim: Code[20]; PaidInvoices: Decimal)
    var
        MICAAccrualSetup: Record "MICA Accrual Setup";
        MICAAccrualPostingSetup: Record "MICA Accrual Posting Setup";
    begin
        if not MICAAccrualSetup.Get(MICACustDetailAccrEntry.Code) then
            MICAAccrualSetup.Init();
        if not MICAAccrualPostingSetup.Get(MICAAccrualSetup."Accruals Posting Code") then
            MICAAccrualPostingSetup.Init();
        TempMICACustDetailAccrEntry.Init();
        TempMICACustDetailAccrEntry."Entry No." := MICACustDetailAccrEntry."Entry No.";
        TempMICACustDetailAccrEntry.Code := MICACustDetailAccrEntry.Code;
        TempMICACustDetailAccrEntry."Item No." := StructDim;
        TempMICACustDetailAccrEntry."Customer No." := SectionDim;
        TempMICACustDetailAccrEntry."Intercompany Dimension" := MICACustDetailAccrEntry."Intercompany Dimension";
        TempMICACustDetailAccrEntry."Accruals Amount" := MICACustDetailAccrEntry."Accruals Amount" - PaidInvoices;
        TempMICACustDetailAccrEntry."Global Dimension 1 Code" := MICAAccrualPostingSetup."Accrual Account No.";
        TempMICACustDetailAccrEntry."Global Dimension 2 Code" := MICAAccrualPostingSetup."Balancing Rebate Account No.";
        TempMICACustDetailAccrEntry."Site Dimension" := MICACustDetailAccrEntry."Site Dimension";
        TempMICACustDetailAccrEntry.Insert();
    end;

    local procedure UpdateTempCustDtlAccrEntry(Amt: Decimal)
    begin
        TempMICACustDetailAccrEntry."Accruals Amount" += Amt;
        TempMICACustDetailAccrEntry.Modify();
    end;

    local procedure FillTempCustomerAccrualEntry(MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry"; PaidInvoice: Decimal)
    begin
        if TempMICACustomerAccrualEntry.Get(MICACustDetailAccrEntry."Customer Accruals Entry No.") then begin
            TempMICACustomerAccrualEntry."Paid Amount" += MICACustDetailAccrEntry."Accruals Amount" - PaidInvoice;
            TempMICACustomerAccrualEntry.Modify();
        end else begin
            TempMICACustomerAccrualEntry.Init();
            TempMICACustomerAccrualEntry."Entry No." := MICACustDetailAccrEntry."Customer Accruals Entry No.";
            TempMICACustomerAccrualEntry."Paid Amount" := MICACustDetailAccrEntry."Accruals Amount" - PaidInvoice;
            TempMICACustomerAccrualEntry.Insert();
        end;
    end;

    local procedure ClosingCustomerAccrualEntry()
    var
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
    begin
        TempMICACustomerAccrualEntry.Reset();
        if TempMICACustomerAccrualEntry.FindSet() then
            repeat
                if MICACustomerAccrualEntry.Get(TempMICACustomerAccrualEntry."Entry No.") then begin
                    MICACustomerAccrualEntry."Paid Amount" := TempMICACustomerAccrualEntry."Paid Amount";
                    MICACustomerAccrualEntry.Open := false;
                    MICACustomerAccrualEntry."Closed At Date" := WorkDate();
                    MICACustomerAccrualEntry."Closed By Document No." := ClosingDocNo;
                    MICACustomerAccrualEntry.Modify();
                end;
            until TempMICACustomerAccrualEntry.Next() = 0;
    end;

    local procedure CheckPostingAccountSetup()
    var
        MICAAccrualSetup: Record "MICA Accrual Setup";
        MICAAccrualPostingSetup: Record "MICA Accrual Posting Setup";
    begin
        MICAAccrualSetup.Reset();
        MICAAccrualSetup.SetRange(Closed, false);
        MICAAccrualSetup.SetRange("Is Deferred", IsDeferred);
        if MICAAccrualSetup.FindSet() then
            repeat
                MICAAccrualSetup.testfield("Accruals Posting Code");
                MICAAccrualPostingSetup.get(MICAAccrualSetup."Accruals Posting Code");
                MICAAccrualPostingSetup.TestField("Accrual Account No.");
                MICAAccrualPostingSetup.TestField("Receivable Accr. Account No.");
            until MICAAccrualSetup.Next() = 0;
    end;

    procedure SetIsDeferred(NewIsDeferred: Boolean)
    begin
        IsDeferred := NewIsDeferred;
    end;

    local procedure GetGnlJnlBatch()
    begin
        if IsDeferred then begin
            MICAFinancialReportingSetup.TestField("Deferred Journal Name");
            MICAFinancialReportingSetup.TestField("Deferred Journal Batch Name");
            GenJournalBatch.Get(MICAFinancialReportingSetup."Deferred Journal Name", MICAFinancialReportingSetup."Deferred Journal Batch Name");
        end else begin
            MICAFinancialReportingSetup.TestField("Financial Journal Name");
            MICAFinancialReportingSetup.TestField("Financial Journal Batch Name");
            GenJournalBatch.Get(MICAFinancialReportingSetup."Financial Journal Name", MICAFinancialReportingSetup."Financial Journal Batch Name");
        end;
        GenJournalBatch.TestField("No. Series");
    end;

    local procedure ModifyOpenNonProcessedEntries(var MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry")
    begin
        MICACustomerAccrualEntry.Reset();
        MICACustomerAccrualEntry.SetRange(Open, true);
        MICACustomerAccrualEntry.SetRange("Is Deffered", IsDeferred);
        if MICACustomerAccrualEntry.FindSet() then
            repeat
                MICACustomerAccrualEntry.Validate(Open, false);
                MICACustomerAccrualEntry.Modify();
            until MICACustomerAccrualEntry.Next() = 0;
    end;
}