codeunit 80760 "MICA Calculate Accrual Rates"
{
    trigger OnRun()
    begin
        Code();
    end;

    local procedure Code();
    begin
        InitDeferredRebates();
        CalculateRates();
    end;

    local procedure CalculateRates();
    var
        MICACustomerAccrualRates: Record "MICA Customer Accrual Rates";
        FoundMICACustomerAccrualRates: Record "MICA Customer Accrual Rates";
        ValueEntry: Record "Value Entry";
        TempCustomer: Record Customer temporary;
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        AccrualPercentage: Decimal;
        FoundAccrualPct: Decimal;
        UpdateTable: Boolean;
        SinglCustomer: Boolean;
        c001Txt: Label 'Calculation Date cannot be less than %1 in %2.';
    begin
        MICAFinancialReportingSetup.Get();
        if WORKDATE() < MICAFinancialReportingSetup."Accr. Last Date Calculation" then
            Error(c001Txt, MICAFinancialReportingSetup.FieldCaption("Accr. Last Date Calculation"), MICAFinancialReportingSetup.TableCaption());

        CurrDateTime := CurrentDateTime();
        // clear contents of table
        MICACustomerAccrualRates.Reset();
        MICACustomerAccrualRates.DeleteAll();

        // read the setup
        MICAAccrualSetup.Reset();
        MICAAccrualSetup.setrange(Closed, false);
        if MICAAccrualSetup.FindSet() then
            repeat
                TempCustomer.Reset();
                TempCustomer.DeleteAll();
                Clear(SinglCustomer);

                // get Value Entries
                ValueEntry.Reset();
                ValueEntry.SetCurrentKey("Source Type", "Source No.", "Item No.", "Posting Date", "Entry Type");
                ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
                ValueEntry.SetFilter("Document Type", '%1|%2', ValueEntry."Document Type"::"Sales Invoice", ValueEntry."Document Type"::"Sales Credit Memo");
                if (MICAAccrualSetup."Begin Date" <> 0D) AND (MICAAccrualSetup."Ending Date" <> 0D) then
                    ValueEntry.SetFilter("Posting Date", '%1..%2', MICAAccrualSetup."Begin Date", MICAAccrualSetup."Ending Date")
                else
                    if (MICAAccrualSetup."Begin Date" <> 0D) AND (MICAAccrualSetup."Ending Date" = 0D) then
                        ValueEntry.SetFilter("Posting Date", '%1..', MICAAccrualSetup."Begin Date")
                    else
                        if (MICAAccrualSetup."Begin Date" = 0D) AND (MICAAccrualSetup."Ending Date" <> 0D) then
                            ValueEntry.SetFilter("Posting Date", '..%1', MICAAccrualSetup."Ending Date");
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

                // Fill TmpCust table
                GetTempCustForCalculation(TempCustomer, ValueEntry, SinglCustomer);
                TempCustomer.Reset();

                // update table
                if TempCustomer.FindSet() then
                    repeat
                        UpdateTable := false;
                        if (MICAAccrualSetup."Calculation Type" = MICAAccrualSetup."Calculation Type"::Amount)
                            AND (TempCustomer.Amount <> 0) AND FindAccrualPct(MICAAccrualSetup.Code, TempCustomer.Amount + TempCustomer."Budgeted Amount", FoundAccrualPct) then
                            UpdateTable := true
                        else
                            if (MICAAccrualSetup."Calculation Type" = MICAAccrualSetup."Calculation Type"::Quantity)
                            AND (TempCustomer."Credit Limit (LCY)" <> 0) AND FindAccrualPct(MICAAccrualSetup.Code, TempCustomer."Credit Limit (LCY)", FoundAccrualPct) then
                                UpdateTable := true;

                        if UpdateTable then begin
                            // check if it is better rate - if better then update table
                            AccrualPercentage := FoundAccrualPct;

                            //Next filter uncomment during test review with Olivier
                            FoundMICACustomerAccrualRates.SetRange("Code", MICAAccrualSetup."Code");
                            FoundMICACustomerAccrualRates.SetRange("Customer No.", TempCustomer."No.");
                            if FoundMICACustomerAccrualRates.FindFirst() then begin
                                if FoundMICACustomerAccrualRates."% Accrual Rate" < AccrualPercentage then begin
                                    FoundMICACustomerAccrualRates.Delete();
                                    InsertAccrRate(TempCustomer, MICAAccrualSetup."Code", AccrualPercentage);
                                end
                            end
                            else
                                // no accrual rate exists - simply insert
                                InsertAccrRate(TempCustomer, MICAAccrualSetup."Code", AccrualPercentage);
                        end;
                    until TempCustomer.next() = 0;

                // update customer entries    
                if TempCustomer.FindSet() then
                    repeat
                        MICACustomerAccrualRates.SetRange("Code", MICAAccrualSetup."Code");
                        MICACustomerAccrualRates.SetRange("Customer No.", TempCustomer."No.");
                        if MICACustomerAccrualRates.FindSet() then
                            repeat
                                // update Customer Accruals Entries
                                UpdateCustAccrEntries(MICACustomerAccrualRates, MICAAccrualSetup);
                                // Update Customer Accruals Detailed Entries
                                UpdateCustAccrDtlEntries(MICACustomerAccrualRates, MICAAccrualSetup);
                            until MICACustomerAccrualRates.next() = 0;
                    until TempCustomer.next() = 0;
            until MICAAccrualSetup.Next() = 0;
    end;

    procedure FindAccrualPct(AccrualCode: Code[20]; Amt: Decimal; var AccrualPct: Decimal): Boolean
    var
        MICAAccrualSetupLine: Record "MICA Accrual Setup Line";
    begin
        Clear(AccrualPct);
        MICAAccrualSetupLine.Ascending(false);
        MICAAccrualSetupLine.SetRange("Accrual Code", AccrualCode);
        if MICAAccrualSetupLine.FindSet() then
            repeat
                if Amt >= MICAAccrualSetupLine.Minimum then begin
                    AccrualPct := MICAAccrualSetupLine."% Accrual";
                    exit(true)
                end;
            until MICAAccrualSetupLine.Next() = 0;
    end;

    local procedure InsertAccrRate(TempCustomer: record Customer Temporary; SetupCode: Code[20]; AccrualPerc: decimal)
    var
        MICACustomerAccrualRates: Record "MICA Customer Accrual Rates";
    begin
        MICACustomerAccrualRates.Init();
        MICACustomerAccrualRates."Code" := SetupCode;
        MICACustomerAccrualRates."Customer No." := TempCustomer."No.";
        MICACustomerAccrualRates.Amount := TempCustomer.Amount;
        MICACustomerAccrualRates.Quantity := TempCustomer."Credit Limit (LCY)";
        MICACustomerAccrualRates."% Accrual Rate" := AccrualPerc;
        MICACustomerAccrualRates."Calculation Date" := CurrDateTime;
        MICACustomerAccrualRates.Insert();
    end;

    local procedure UpdateCustAccrEntries(MICACustomerAccrualRates: Record "MICA Customer Accrual Rates"; LocMICAAccrualSetup: Record "MICA Accrual Setup");
    var
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
    begin
        MICACustomerAccrualEntry.Reset();
        MICACustomerAccrualEntry.SetCurrentKey("Customer No.", "Posting Date");
        MICACustomerAccrualEntry.SetRange("Customer No.", MICACustomerAccrualRates."Customer No.");
        MICACustomerAccrualEntry.SetFilter("Posting Date", '%1..%2', LocMICAAccrualSetup."Begin Date", LocMICAAccrualSetup."Ending Date");
        MICACustomerAccrualEntry.SetRange(Code, LocMICAAccrualSetup.Code);
        if MICACustomerAccrualEntry.FindSet(true, false) then
            repeat
                MICACustomerAccrualEntry."Accruals %" := MICACustomerAccrualRates."% Accrual Rate";
                MICACustomerAccrualEntry."Accruals Amount" := MICACustomerAccrualEntry."Base Amount" * MICACustomerAccrualEntry."Accruals %" / 100;
                MICACustomerAccrualEntry.Modify();
            until MICACustomerAccrualEntry.Next() = 0;

    end;

    local procedure UpdateCustAccrDtlEntries(MICACustomerAccrualRates: Record "MICA Customer Accrual Rates"; LocMICAAccrualSetup: Record "MICA Accrual Setup");
    var
        MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
    begin
        MICACustDetailAccrEntry.Reset();
        MICACustDetailAccrEntry.SetCurrentKey("Customer No.", "Posting Date");
        MICACustDetailAccrEntry.SetRange("Customer No.", MICACustomerAccrualRates."Customer No.");
        MICACustDetailAccrEntry.SetFilter("Posting Date", '%1..%2', LocMICAAccrualSetup."Begin Date", LocMICAAccrualSetup."Ending Date");
        MICACustDetailAccrEntry.SetRange(Code, LocMICAAccrualSetup.Code);
        if MICACustDetailAccrEntry.FindSet(true, false) then
            repeat
                MICACustDetailAccrEntry."Accruals %" := MICACustomerAccrualRates."% Accrual Rate";
                MICACustDetailAccrEntry."Accruals Amount" := (MICACustDetailAccrEntry."Sales Amount" - MICACustDetailAccrEntry."Discount Amount") * MICACustDetailAccrEntry."Accruals %" / 100;
                MICACustDetailAccrEntry.Modify();
            until MICACustDetailAccrEntry.Next() = 0;
    end;

    local procedure GetTempCustForCalculation(var Customer: record Customer; var ValueEntry: Record "Value Entry"; SinglCustomer: Boolean)
    begin
        if not Customer.IsTemporary() then
            exit;
        if SinglCustomer then begin
            if ValueEntry.FindFirst() then begin
                ValueEntry.CalcSums("Sales Amount (Actual)", "Invoiced Quantity", "Discount Amount");
                InsertTempCustomer(Customer, ValueEntry);
            end
        end else
            if ValueEntry.FindSet() then
                repeat
                    if not Customer.Get(ValueEntry."MICA Sell-to Customer No.") then begin
                        ValueEntry.SetRange("MICA Sell-to Customer No.", ValueEntry."MICA Sell-to Customer No.");
                        ValueEntry.CalcSums("Sales Amount (Actual)", "Invoiced Quantity", "Discount Amount");
                        InsertTempCustomer(Customer, ValueEntry);
                        ValueEntry.SetRange("MICA Sell-to Customer No.");
                    end;
                until ValueEntry.Next() = 0;
    end;

    local procedure InsertTempCustomer(var Customer: record Customer; ValueEntry: Record "Value Entry")
    begin
        Customer.Init();
        Customer."No." := ValueEntry."MICA Sell-to Customer No.";
        Customer.Amount := ValueEntry."Sales Amount (Actual)";
        Customer."Credit Limit (LCY)" := -ValueEntry."Invoiced Quantity";
        Customer."Budgeted Amount" := -ValueEntry."Discount Amount";
        Customer.Insert();
    end;

    local procedure InitDeferredRebates()
    begin
        Report.Run(Report::"MICA Init Accruals", false);
    end;

    var
        MICAAccrualSetup: Record "MICA Accrual Setup";
        CurrDateTime: DateTime;

}