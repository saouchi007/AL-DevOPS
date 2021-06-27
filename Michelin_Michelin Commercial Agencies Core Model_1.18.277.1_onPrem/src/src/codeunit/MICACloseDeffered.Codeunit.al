codeunit 81880 "MICA Close Deffered"
{
    trigger OnRun()
    begin

    end;

    procedure Close(AccrualSetupCode: Code[20]);
    var
        TempSalesLine: Record "Sales Line" temporary;
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
        CrMemoNo: code[20];
        TotalBlockedCustomers: Integer;
        NonBlockedCustomersFilter: Text;
        BlockedCustomersFilter: Text;
        BlockedCustomersQst: Label 'Transaction(s) cannot be processed for %1 Blocked Customer(s): %2. Do you want to continue?';
    begin
        MICAFinancialReportingSetup.Get();
        GeneralLedgerSetup.get();
        MICAFinancialReportingSetup.TestField("Deferred Nos.");
        CheckPostingAccountSetup(AccrualSetupCode);

        TotalBlockedCustomers := CheckBlockedSellToCustomers(AccrualSetupCode, NonBlockedCustomersFilter, BlockedCustomersFilter);
        if TotalBlockedCustomers > 0 then
            if not Confirm(StrSubstNo(BlockedCustomersQst, TotalBlockedCustomers, BlockedCustomersFilter), true) then
                Error('');

        MICACustomerAccrualEntry.SetAutoCalcFields("Accruals Amount");
        MICACustomerAccrualEntry.SetRange(Code, AccrualSetupCode);
        if NonBlockedCustomersFilter <> '' then
            MICACustomerAccrualEntry.SetFilter("Customer No.", NonBlockedCustomersFilter);
        MICACustomerAccrualEntry.Ascending(false);
        if MICACustomerAccrualEntry.FindSet() then begin
            MICACustomerAccrualEntry.SetRange("Calculation Date", MICACustomerAccrualEntry."Calculation Date");
            repeat
                if MICACustomerAccrualEntry."Accruals Amount" <> 0 then begin
                    Clear(CrMemoNo);
                    if not TempSalesLine.IsEmpty() then
                        TempSalesLine.DeleteAll();
                    GroupAccrualsIntoTemp(MICACustomerAccrualEntry, TempSalesLine);
                    CreateCreditMemoDocument(TempSalesLine, CrMemoNo);
                    ClosingCustAccrualEntry(MICACustomerAccrualEntry."Entry No.", CrMemoNo);
                end;
            until (MICACustomerAccrualEntry.Next() = 0);
        end;
    end;

    local procedure ClosingCustAccrualEntry(ClosingCustAccrualEntryNo: Integer; ClosingDocNo: Code[20])
    var
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
    begin

        if MICACustomerAccrualEntry.Get(ClosingCustAccrualEntryNo) then begin
            MICACustomerAccrualEntry.CalcFields("Accruals Amount");
            MICACustomerAccrualEntry."Closed By Document No." := ClosingDocNo;
            MICACustomerAccrualEntry."Closed At Date" := Today();
            MICACustomerAccrualEntry.Open := false;
            MICACustomerAccrualEntry."Paid Amount" := MICACustomerAccrualEntry."Accruals Amount";
            MICACustomerAccrualEntry."Sales Credit Memo No." := ClosingDocNo;
            MICACustomerAccrualEntry."Sales Cr. Memo Creation Date" := Today();
            MICACustomerAccrualEntry.Modify();
        end;
    end;

    local procedure CheckPostingAccountSetup(AccrualCode: Code[20])
    begin
        if MICAAccrualSetup.Get(AccrualCode) then begin
            MICAAccrualSetup.testfield("Accruals Posting Code");
            MICAAccrualPostingSetup.get(MICAAccrualSetup."Accruals Posting Code");
            MICAAccrualPostingSetup.TestField("Accrual Account No.");
            MICAAccrualPostingSetup.TestField("Receivable Accr. Account No.");
        end;
    end;

    local procedure GroupAccrualsIntoTemp(MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry"; var SalesLine: Record "Sales Line")
    var
        MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
        StructureDim: Code[20];
        SectionDim: Code[20];
        LineNo: Integer;
    begin
        if not SalesLine.IsTemporary() then
            exit;
        MICACustDetailAccrEntry.SetRange("Customer Accruals Entry No.", MICACustomerAccrualEntry."Entry No.");
        if MICACustDetailAccrEntry.FindSet() then
            repeat
                GetGlobalDimensions(StructureDim, SectionDim, MICACustDetailAccrEntry);
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", MICACustomerAccrualEntry.Code);
                SalesLine.SetRange("No.", StructureDim);
                if SalesLine.FindFirst() then begin
                    SalesLine."Unit Price" += MICACustDetailAccrEntry."Accruals Amount";
                    SalesLine.Modify();
                end else
                    InsertTempSalesLine(MICACustDetailAccrEntry, LineNo, StructureDim, SectionDim, SalesLine);
            until MICACustDetailAccrEntry.Next() = 0;
    end;

    local procedure GetGlobalDimensions(var StructureDim: Code[20]; var SectionDim: Code[20]; MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry")
    begin
        Clear(StructureDim);
        Clear(SectionDim);
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
    end;

    local procedure InsertTempSalesLine(MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry"; var LineNo: Integer; StructDim: Code[20]; SectionDim: Code[20]; var SalesLine: Record "Sales Line")
    begin
        LineNo += 1;
        SalesLine."Document No." := MICACustDetailAccrEntry.Code;
        SalesLine."No." := StructDim;
        SalesLine."Line No." := LineNo;
        SalesLine."Sell-to Customer No." := MICACustDetailAccrEntry."Customer No.";
        SalesLine.Description := CopyStr(MICAAccrualSetup.Description, 1, MaxStrLen(SalesLine.Description));
        SalesLine."Posting Group" := MICAAccrualPostingSetup."Receivable Accr. Account No.";
        SalesLine.Quantity := 1;
        SalesLine."Unit Price" := MICACustDetailAccrEntry."Accruals Amount";
        SalesLine."Shortcut Dimension 2 Code" := SectionDim;
        SalesLine."Job No." := MICACustDetailAccrEntry."Intercompany Dimension";
        SalesLine."Shipment No." := MICACustDetailAccrEntry."Site Dimension";
        SalesLine.Insert();
    end;

    local procedure CreateCreditMemoDocument(var SalesLine: Record "Sales Line"; var CrMemoNo: Code[20])
    begin
        SalesLine.Reset();
        if SalesLine.FindSet() then begin
            CreateCreditMemoHeader(SalesLine, CrMemoNo);
            repeat
                CreateCreditMemoLine(SalesLine, CrMemoNo);
            until SalesLine.Next() = 0;
        end;
    end;

    local procedure CreateCreditMemoHeader(SalesLine: Record "Sales Line"; var DocNo: Code[20]);
    var
        SalesHeader: Record "Sales Header";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::"Credit Memo");
        SalesHeader."No." := NoSeriesManagement.GetNextNo(MICAFinancialReportingSetup."Deferred Nos.", Today(), true);
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
        SalesHeader.Validate("Posting Date", CalculationDate);
        SalesHeader.Validate("Document Date", CalculationDate);
        SalesHeader.Validate("Due Date", CalculationDate);
        SalesHeader.Modify();
        DocNo := SalesHeader."No.";
    end;

    local procedure CreateCreditMemoLine(FromSalesLine: Record "Sales Line"; DocNo: Code[20])
    var
        SalesLine: Record "Sales Line";
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionManagement: Codeunit DimensionManagement;
    begin
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesLine."Document Type"::"Credit Memo");
        SalesLine.Validate("Document No.", DocNo);
        SalesLine."Line No." := GetNextLineNo(DocNo);
        SalesLine.Insert(true);
        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
        SalesLine.Validate("No.", FromSalesLine."Posting Group");
        SalesLine.Description := FromSalesLine.Description;
        SalesLine.Validate("Location Code", '');
        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", Round(FromSalesLine."Unit Price", 1, '='));
        DimensionManagement.GetDimensionSet(TempDimensionSetEntry, SalesLine."Dimension Set ID");
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Accrual Dimension Code", FromSalesLine."Document No.");
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Intercompany Dimension", FromSalesLine."Job No.");
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Structure Dimension", FromSalesLine."No.");
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Section Dimension", FromSalesLine."Shortcut Dimension 2 Code");
        CreateDimensionEntry(TempDimensionSetEntry, MICAFinancialReportingSetup."Site Dimension Code", FromSalesLine."Shipment No.");
        SalesLine."Dimension Set ID" := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);
        DimensionManagement.UpdateGlobalDimFromDimSetID(SalesLine."Dimension Set ID", SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code");
        SalesLine.Modify();
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

    local procedure GetNextLineNo(DocNo: Code[20]): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Credit Memo");
        SalesLine.SetRange("Document No.", DocNo);
        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000);
        exit(10000);
    end;

    procedure SetCalculationDate(NewCalculationDate: Date)
    begin
        CalculationDate := NewCalculationDate;
    end;

    procedure CheckBlockedSellToCustomers(AccrualSetupCode: Code[20]; var NonBlockedCustomers: Text; var BlockedCustomers: Text): Integer
    var
        Customer: Record Customer;
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
        TotalBlockedCustomers: Integer;
    begin
        TotalBlockedCustomers := 0;

        MICACustomerAccrualEntry.SetAutoCalcFields("Accruals Amount");
        MICACustomerAccrualEntry.SetRange(Code, AccrualSetupCode);
        MICACustomerAccrualEntry.Ascending(false);
        if MICACustomerAccrualEntry.FindSet() then
            repeat
                if MICACustomerAccrualEntry."Accruals Amount" <> 0 then
                    if (MICACustomerAccrualEntry."Customer No." <> Customer."No.") and (Customer.Get(MICACustomerAccrualEntry."Customer No.")) then
                        if not Customer."MICA Rebate Pool" then
                            if Customer.Blocked = Customer.Blocked::All then begin
                                TotalBlockedCustomers += 1;
                                CreateCustomersFilter(BlockedCustomers, MICACustomerAccrualEntry."Customer No.");
                            end else
                                CreateCustomersFilter(NonBlockedCustomers, MICACustomerAccrualEntry."Customer No.");
            until MICACustomerAccrualEntry.Next() = 0;

        exit(TotalBlockedCustomers);
    end;

    local procedure CreateCustomersFilter(var CustomerFilter: Text; NewCustomerNo: Code[20])
    begin
        if CustomerFilter = '' then
            CustomerFilter := NewCustomerNo
        else
            CustomerFilter += '|' + NewCustomerNo;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MICA Transient Top Management", 'OnBeforeCheckSalesAgreement', '', false, false)]
    local procedure Cu81641OnBeforeCheckSalesAgreement(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        if SalesLine."Document Type" <> SalesLine."Document Type"::"Credit Memo" then
            exit;

        if SalesLine.Type = SalesLine.Type::"G/L Account" then
            IsHandled := true;
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        MICAAccrualSetup: Record "MICA Accrual Setup";
        MICAAccrualPostingSetup: Record "MICA Accrual Posting Setup";
        CalculationDate: Date;
}