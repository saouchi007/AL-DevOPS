codeunit 80761 "MICA Calc Accrual Ledger Entry"
{
    trigger OnRun()
    begin
        Code();
    end;

    local procedure Code();
    var
        ValueEntry: Record "Value Entry";
        TempCustomer: Record Customer temporary;
        CreatedEntryNo: Integer;
        WindowDialog: Dialog;
        PaidInvoices: Decimal;
        GlobalRebateAmt: Decimal;
        TotalEntries: Integer;
        Progress: Integer;
        SinglCustomer: Boolean;
        c001Lbl: Label 'Creating entries...\\';
        c002Lbl: Label 'Accrual Setup        #1###################\';
        c003Lbl: Label 'Customers            @2@@@@@@@@@@@@@@@@@@@\';
        DateAfterLastDateErr: Label 'Calculation Date must be after the last Calculation Date (%1)';
    begin
        // get Financial Reporting Setup
        MICAFinancialReportingSetup.Get();
        if MICAFinancialReportingSetup."Accr. Last Date Calculation" <> 0D then
            if MICAFinancialReportingSetup."Accr. Last Date Calculation" > CalculationDate then
                Error(DateAfterLastDateErr, MICAFinancialReportingSetup."Accr. Last Date Calculation");

        CalculateRebatesRates();

        WindowDialog.Open(c001Lbl + c002Lbl + c003Lbl);

        // read setup
        MICAAccrualSetup.Reset();
        MICAAccrualSetup.SetRange(Closed, false);

        if MICAAccrualSetup.FindSet() then
            repeat
                WindowDialog.UPDATE(1, MICAAccrualSetup."Code");
                Clear(Progress);

                TempCustomer.Reset();
                TempCustomer.DeleteAll();
                Clear(SinglCustomer);
                Clear(GlobalRebateAmt);
                Clear(PaidInvoices);
                // get Value Entries
                ValueEntry.Reset();
                ValueEntry.SetCurrentKey("Source Type", "Source No.", "Item No.", "Posting Date", "Entry Type");
                ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                ValueEntry.SetFilter("Document Type", '%1|%2', ValueEntry."Document Type"::"Sales Invoice", ValueEntry."Document Type"::"Sales Credit Memo");
                if CalculationDate < MICAAccrualSetup."Ending Date" then
                    ValueEntry.SetFilter("Posting Date", '%1..%2', MICAAccrualSetup."Begin Date", CalculationDate)
                else
                    ValueEntry.SetFilter("Posting Date", '%1..%2', MICAAccrualSetup."Begin Date", MICAAccrualSetup."Ending Date");
                ValueEntry.SetFilter("MICA Accr. Item Grp.", MICAAccrualSetup."Accr. Item  Grp.");
                case MICAAccrualSetup."Sales Type" of
                    MICAAccrualSetup."Sales Type"::Customer:
                        begin
                            ValueEntry.SetRange("Source Type", ValueEntry."Source Type"::Customer);
                            ValueEntry.SetFilter("MICA Sell-to Customer No.", MICAAccrualSetup."Sales Code");
                            SinglCustomer := true;
                        end;
                    MICAAccrualSetup."Sales Type"::"Accr. Cust. Grp.":
                        ValueEntry.SetFilter("MICA Accr. Customer Grp.", MICAAccrualSetup."Sales Code");
                    MICAAccrualSetup."Sales Type"::"All Customers":
                        ValueEntry.SetFilter("MICA Accr. Customer Grp.", '<>%1', '');
                end;
                // Fill TempCust table
                GetTempCustForCalculation(TempCustomer, ValueEntry, SinglCustomer, GlobalRebateAmt);

                TempCustomer.Reset();
                TotalEntries := TempCustomer.Count();
                //Get paid invoices for Accrual Setup
                if not MICAAccrualSetup."Is Deferred" then
                    PaidInvoices := CalcPaidInvoices(MICAAccrualSetup);

                // create accrual ledger entries    
                if TempCustomer.FindSet() then
                    repeat
                        // update Customer Accruals Entries
                        CreatedEntryNo := CreateCustAccrEntries(TempCustomer, MICAAccrualSetup, PaidInvoices, GlobalRebateAmt);
                        // create Customer Accruals Detailed Entries
                        CreateCustAccrDtlEntries(CreatedEntryNo, TempCustomer, MICAAccrualSetup);
                        Progress += 1;
                        IF Progress MOD 2 = 0 THEN
                            WindowDialog.UPDATE(2, ROUND(Progress / TotalEntries * 100, 1));
                    until TempCustomer.Next() = 0;
            until MICAAccrualSetup.Next() = 0;
        WindowDialog.Close();

        // update Fin. Reporting Setup
        MICAFinancialReportingSetup."Accr. Last Date Calculation" := CalculationDate;
        MICAFinancialReportingSetup.Modify();
    end;

    procedure SetCalcDate(ToSet: Date)
    begin
        CalculationDate := ToSet;
    end;

    local procedure CreateCustAccrEntries(Customer: Record "Customer" temporary; LocMICAAccrualSetup: Record "MICA Accrual Setup"; PaidInvoices: Decimal; GlobalRebateAmt: Decimal): Integer;
    var
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
        FoundMICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
        MICACustomerAccrualRates: Record "MICA Customer Accrual Rates";
        FoundCustomer: Record Customer;
        EntryNo: Integer;
    begin
        if MICACustomerAccrualEntry.IsEmpty() then
            EntryNo := 1
        else begin
            FoundMICACustomerAccrualEntry.FindLast();
            EntryNo := FoundMICACustomerAccrualEntry."Entry No." + 1;
        End;

        FoundCustomer.Get(Customer."No.");

        MICACustomerAccrualEntry.Init();
        MICACustomerAccrualEntry."Entry No." := EntryNo;
        MICACustomerAccrualEntry."Code" := LocMICAAccrualSetup."Code";
        MICACustomerAccrualEntry.Description := LocMICAAccrualSetup.Description;
        MICACustomerAccrualEntry."Description 2" := LocMICAAccrualSetup."Description 2";
        MICACustomerAccrualEntry."Rebate Code Ending Date" := LocMICAAccrualSetup."Ending Date";
        MICACustomerAccrualEntry."Customer No." := Customer."No.";
        MICACustomerAccrualEntry."Customer Name" := FoundCustomer.Name;
        MICACustomerAccrualEntry.Quantity := Customer."Credit Limit (LCY)";
        MICACustomerAccrualEntry."Base Amount" := Customer.Amount + Customer."Budgeted Amount";
        MICACustomerAccrualEntry."Posting Date" := WorkDate();
        MICACustomerAccrualEntry."Calculation Date" := CalculationDate;
        MICACustomerAccrualEntry."Calculation Type" := LocMICAAccrualSetup."Calculation Type";
        MICACustomerAccrualEntry."Is Deffered" := LocMICAAccrualSetup."Is Deferred";
        if not MICACustomerAccrualEntry."Is Deffered" then begin
            MICACustomerAccrualEntry."Paid Invoices" := Round(CalcPaidCrMemo(Customer."No.", LocMICAAccrualSetup));
            if GlobalRebateAmt <> 0 then
                MICACustomerAccrualEntry."Paid AP Invoice" := Round((PaidInvoices / GlobalRebateAmt) * MICACustomerAccrualEntry."Base Amount");
        end;
        MICACustomerAccrualRates.SetRange("Code", LocMICAAccrualSetup."Code");
        MICACustomerAccrualRates.SetRange("Customer No.", Customer."No.");
        if MICACustomerAccrualRates.FindFirst() then
            MICACustomerAccrualEntry."Accruals %" := MICACustomerAccrualRates."% Accrual Rate";
        MICACustomerAccrualEntry.Open := true;
        MICACustomerAccrualEntry."Include in Fin. Report" := LocMICAAccrualSetup."Include in Fin. Report";
        MICACustomerAccrualEntry.Insert();
        exit(MICACustomerAccrualEntry."Entry No.");
    end;

    local procedure CreateCustAccrDtlEntries(CustAccrEntryNo: Decimal; Customer: Record "Customer"; LocMICAAccrualSetup: Record "MICA Accrual Setup");
    var
        MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
        FoundMICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
        MICACustomerAccrualRates: Record "MICA Customer Accrual Rates";
        FoundCustomer: Record Customer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        FoundMICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
        Item: Record Item;
        EntryNo: Integer;
    begin
        FoundMICAFinancialReportingSetup.Get();
        if FoundMICACustDetailAccrEntry.IsEmpty() then
            EntryNo := 0
        else begin
            FoundMICACustDetailAccrEntry.FindLast();
            EntryNo := FoundMICACustDetailAccrEntry."Entry No.";
        End;

        FoundCustomer.Get(Customer."No.");
        MICACustomerAccrualEntry.Get(CustAccrEntryNo);
        // create detailed entry for each item entry
        ValueEntry.Reset();
        ValueEntry.SetCurrentKey("Source Type", "Source No.", "Item No.", "Posting Date", "Entry Type");
        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntry.SetFilter("Document Type", '%1|%2', ValueEntry."Document Type"::"Sales Invoice", ValueEntry."Document Type"::"Sales Credit Memo");
        if CalculationDate < LocMICAAccrualSetup."Ending Date" then
            ValueEntry.SetFilter("Posting Date", '%1..%2', LocMICAAccrualSetup."Begin Date", CalculationDate)
        else
            ValueEntry.SetFilter("Posting Date", '%1..%2', LocMICAAccrualSetup."Begin Date", LocMICAAccrualSetup."Ending Date");
        ValueEntry.SetFilter("MICA Accr. Item Grp.", LocMICAAccrualSetup."Accr. Item  Grp.");
        ValueEntry.SetRange("Source Type", ValueEntry."Source Type"::Customer);
        ValueEntry.SetRange("MICA Sell-to Customer No.", Customer."No.");
        if ValueEntry.FindSet() then
            repeat
                if not Item.Get(ValueEntry."Item No.") then
                    Item.Init();
                MICACustDetailAccrEntry.Init();
                EntryNo += 1;
                MICACustDetailAccrEntry."Entry No." := EntryNo;
                MICACustDetailAccrEntry."Code" := LocMICAAccrualSetup."Code";
                MICACustDetailAccrEntry."Customer No." := Customer."No.";
                MICACustDetailAccrEntry."Customer Name" := FoundCustomer.Name;
                MICACustDetailAccrEntry."Entry Type" := MICACustDetailAccrEntry."Entry Type"::"Initial Entry";
                MICACustDetailAccrEntry."Calculation Type" := LocMICAAccrualSetup."Calculation Type";
                MICACustDetailAccrEntry."Calculation Date" := CalculationDate;
                MICACustDetailAccrEntry."Item No." := ValueEntry."Item No.";
                MICACustDetailAccrEntry."Item Category Code" := Item."Item Category Code";
                MICACustDetailAccrEntry."Accr. Customer Group" := FoundCustomer."MICA Accr. Customer Grp.";
                MICACustDetailAccrEntry."Accr. Item Group" := ValueEntry."MICA Accr. Item Grp.";
                MICACustDetailAccrEntry."Sales Amount" := ValueEntry."Sales Amount (Actual)";
                MICACustDetailAccrEntry."Discount Amount" := ValueEntry."Discount Amount";
                MICACustDetailAccrEntry.Quantity := -ValueEntry."Invoiced Quantity";
                MICACustomerAccrualRates.SetRange("Code", LocMICAAccrualSetup."Code");
                MICACustomerAccrualRates.SetRange("Customer No.", Customer."No.");
                if MICACustomerAccrualRates.FindFirst() then
                    MICACustDetailAccrEntry."Accruals %" := MICACustomerAccrualRates."% Accrual Rate";
                MICACustDetailAccrEntry."Accruals Amount" := (ValueEntry."Sales Amount (Actual)" - ValueEntry."Discount Amount") * MICACustDetailAccrEntry."Accruals %" / 100;
                if not MICACustomerAccrualEntry."Is Deffered" then
                    if MICACustomerAccrualEntry."Base Amount" <> 0 then begin
                        MICACustDetailAccrEntry."Paid AR Credit Memo" :=
                            Round(((MICACustDetailAccrEntry."Sales Amount" - MICACustDetailAccrEntry."Discount Amount") / MICACustomerAccrualEntry."Base Amount") * MICACustomerAccrualEntry."Paid Invoices");
                        MICACustDetailAccrEntry."Paid AP Invoice" :=
                            Round(((MICACustDetailAccrEntry."Sales Amount" - MICACustDetailAccrEntry."Discount Amount") / MICACustomerAccrualEntry."Base Amount") * MICACustomerAccrualEntry."Paid AP Invoice");
                    end;
                MICACustDetailAccrEntry."Reforecast Percentage" := LocMICAAccrualSetup."Reforecast Percentage";
                MICACustDetailAccrEntry."Posting Date" := WorkDate();
                MICACustDetailAccrEntry."Is Deffered" := LocMICAAccrualSetup."Is Deferred";
                MICACustDetailAccrEntry."Global Dimension 1 Code" := ValueEntry."Global Dimension 1 Code";
                MICACustDetailAccrEntry."Global Dimension 2 Code" := ValueEntry."Global Dimension 2 Code";
                MICACustDetailAccrEntry."Document No." := ValueEntry."Document No.";
                MICACustDetailAccrEntry."Document Posting Date" := ValueEntry."Posting Date";
                MICACustDetailAccrEntry."User ID" := Copystr(UserId(), 1, 50);
                MICACustDetailAccrEntry."Value Entry No." := ValueEntry."Entry No.";
                MICACustDetailAccrEntry."Include in Fin. Report" := LocMICAAccrualSetup."Include in Fin. Report";
                MICACustDetailAccrEntry."Customer Accruals Entry No." := CustAccrEntryNo;
                MICACustDetailAccrEntry."Value Entry Document Type" := ValueEntry."Document Type".AsInteger();
                ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.");
                MICACustDetailAccrEntry."Country-of Sales" := ItemLedgerEntry."Country/Region Code";
                MICACustDetailAccrEntry."Market Code" := FoundCustomer."MICA Market Code";
                if FoundMICAFinancialReportingSetup."Intercompany Dimension" <> '' then
                    MICACustDetailAccrEntry."Intercompany Dimension" := GetDimValueCode(ValueEntry."Dimension Set ID", FoundMICAFinancialReportingSetup."Intercompany Dimension");
                MICACustDetailAccrEntry."Forecast Code" := GetForecastCode(FoundCustomer."No.", ValueEntry."Item No.");
                MICACustDetailAccrEntry."Accruals Dimension" := GetAccrualDimValue(LocMICAAccrualSetup."Code");
                if FoundMICAFinancialReportingSetup."Site Dimension Code" <> '' then
                    MICACustDetailAccrEntry."Site Dimension" := GetDimValueCode(ValueEntry."Dimension Set ID", FoundMICAFinancialReportingSetup."Site Dimension Code");
                MICACustDetailAccrEntry.Insert();
            until ValueEntry.Next() = 0;
    end;

    local procedure GetDimValueCode(DimensionSetID: Integer; DimCode: Code[20]): Code[20]
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        if DimensionSetEntry.Get(DimensionSetID, DimCode) then
            exit(DimensionSetEntry."Dimension Value Code");
    end;

    local procedure GetAccrualDimValue(DimensionCode: Code[20]): Code[20]
    var
        //DimeSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
        FoundMICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
    begin
        FoundMICAFinancialReportingSetup.Get();
        IF FoundMICAFinancialReportingSetup."Accrual Dimension Code" = '' then
            exit;
        if DimensionValue.Get(FoundMICAFinancialReportingSetup."Accrual Dimension Code", DimensionCode) then
            exit(DimensionValue.Code);
        //if DimeSetEntry.Get(DimensionSetID, FinReportingSetup."Accrual Dimension Code") then
        //    exit(DimeSetEntry."Dimension Value Code");
    end;

    local procedure GetForecastCode(CustomerNo: Code[20]; ItemNo: Code[20]): Code[5]
    var
        MICAForecastCustomerCode: Record "MICA Forecast Customer Code";
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        IF MICAForecastCustomerCode.Get(CustomerNo, Item."Item Category Code") then
            exit(MICAForecastCustomerCode."Forecast Code");
    end;

    local procedure GetTempCustForCalculation(var Customer: record Customer; var ValueEntry: Record "Value Entry"; SinglCustomer: Boolean; var RebateAmt: Decimal)
    begin
        if not Customer.IsTemporary() then
            exit;
        if SinglCustomer then begin
            if ValueEntry.FindFirst() then begin
                ValueEntry.CalcSums("Sales Amount (Actual)", "Invoiced Quantity", "Discount Amount");
                InsertTempCustomer(Customer, ValueEntry, RebateAmt);
            end
        end else
            if ValueEntry.FindSet() then
                repeat
                    if not Customer.Get(ValueEntry."MICA Sell-to Customer No.") then begin
                        ValueEntry.SetRange("MICA Sell-to Customer No.", ValueEntry."MICA Sell-to Customer No.");
                        ValueEntry.CalcSums("Sales Amount (Actual)", "Invoiced Quantity", "Discount Amount");
                        InsertTempCustomer(Customer, ValueEntry, RebateAmt);
                        ValueEntry.SetRange("MICA Sell-to Customer No.");
                    end;
                until ValueEntry.Next() = 0;
    end;

    local procedure InsertTempCustomer(var Customer: record Customer; ValueEntry: Record "Value Entry"; var RebateAmt: Decimal)
    begin
        Customer.Init();
        Customer."No." := ValueEntry."MICA Sell-to Customer No.";
        Customer.Amount := ValueEntry."Sales Amount (Actual)";
        Customer."Credit Limit (LCY)" := -ValueEntry."Invoiced Quantity";
        Customer."Budgeted Amount" := -ValueEntry."Discount Amount";
        Customer.Insert();
        RebateAmt += Customer.Amount + Customer."Budgeted Amount";
    end;

    local procedure CalcPaidCrMemo(CustNo: Code[20]; LocMICAAccrualSetup: Record "MICA Accrual Setup"): Decimal
    var
        GLEntry: Record "G/L Entry";
        PaidCrMemo: Decimal;
    begin
        GLEntry.SetCurrentKey("MICA No. 2", "MICA Rebate Code");
        GLEntry.SetFilter("MICA No. 2", MICAFinancialReportingSetup."Deferred Group Account");
        GLEntry.SetRange("MICA Rebate Code", LocMICAAccrualSetup.Code);
        GLEntry.SetRange("Posting Date", LocMICAAccrualSetup."Begin Date", CalculationDate);
        GLEntry.SetRange("Gen. Posting Type", GLEntry."Gen. Posting Type"::Sale);
        GLEntry.SetRange("Source Type", GLEntry."Source Type"::Customer);
        GLEntry.SetRange("Source No.", CustNo);
        if GLEntry.FindSet() then
            repeat
                PaidCrMemo += GLEntry.Amount;
            until GLEntry.Next() = 0;
        exit(PaidCrMemo);
    end;

    local procedure CalcPaidInvoices(LocMICAAccrualSetup: Record "MICA Accrual Setup"): Decimal
    var
        GLEntry: Record "G/L Entry";
        PaidInvoices: Decimal;
    begin
        GLEntry.SetCurrentKey("MICA No. 2", "MICA Rebate Code");
        GLEntry.SetFilter("MICA No. 2", MICAFinancialReportingSetup."Deferred Group Account");
        GLEntry.SetRange("MICA Rebate Code", LocMICAAccrualSetup.Code);
        GLEntry.SetRange("Posting Date", LocMICAAccrualSetup."Begin Date", CalculationDate);
        GLEntry.SetRange("Gen. Posting Type", GLEntry."Gen. Posting Type"::Purchase);
        GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
        if GLEntry.FindSet() then
            repeat
                PaidInvoices += GLEntry.Amount;
            until GLEntry.Next() = 0;
        exit(PaidInvoices);
    end;

    local procedure CalculateRebatesRates()
    begin
        if MICAFinancialReportingSetup."Calc. Rebate Rates Codeunit ID" > 0 then
            Codeunit.Run(MICAFinancialReportingSetup."Calc. Rebate Rates Codeunit ID");

    end;

    var
        MICAAccrualSetup: Record "MICA Accrual Setup";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        CalculationDate: Date;
}