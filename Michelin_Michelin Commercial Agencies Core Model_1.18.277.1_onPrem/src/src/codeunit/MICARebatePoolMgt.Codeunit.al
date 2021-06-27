codeunit 83000 "MICA Rebate Pool Mgt."
{
    Permissions = tabledata "G/L Entry" = rim;
    trigger OnRun()
    begin

    end;

    // #### Create Deffered Credit Memo

    procedure CreateDefferedCreditMemo(NewMICAAccrualSetup: Record "MICA Accrual Setup")
    var
        CloseDeffered: Codeunit "MICA Close Deffered";
        RebateMenagement: Codeunit "MICA Rebate Menagement";
        InputPage: Page "MICA Rebate Date Input Page";
        CalculationDate: Date;
        CreateRabatesQst: Label 'Do you want to create Rebates Sales Credit Memo?';
        EndingDateIsNotExpiredErr: Label 'The ending date is not expired: Sales Credit Memos can’t be created.';
    begin
        NewMICAAccrualSetup.TestField(Closed, false);
        NewMICAAccrualSetup.TestField("Is Deferred");
        if WorkDate() <= NewMICAAccrualSetup."Ending Date" then
            Error(EndingDateIsNotExpiredErr);
        if not Confirm(CreateRabatesQst) then
            exit;
        if InputPage.RUNMODAL() <> Action::OK then
            exit;
        InputPage.GetCalcDate(CalculationDate);
        if CalculationDate = 0D then
            exit;
        CloseDeffered.SetCalculationDate(CalculationDate);
        CloseDeffered.Close(NewMICAAccrualSetup.Code);
        RebateMenagement.DeleteRelatedDetailRebateLedgerEntries(NewMICAAccrualSetup);
    end;

    // #### Close Rebate Pool with Sales Credit Memo

    procedure CloseRebatePoolEntry(SalesLine: Record "Sales Line"; SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        MICARebatePoolEntry: Record "MICA Rebate Pool Entry";
        MICARebatePoolDtldEntry: Record "MICA Rebate Pool Dtld. Entry";
        VariantRec: Variant;
    begin
        if not MICARebatePoolEntry.Get(SalesLine."MICA Rebate Pool Entry No.") then
            exit;

        FillRebatePoolDtldEntry(MICARebatePoolDtldEntry, MICARebatePoolEntry);
        MICARebatePoolDtldEntry."Entry Type" := MICARebatePoolDtldEntry."Entry Type"::Closing;
        MICARebatePoolDtldEntry.Amount := -SalesLine.Amount;
        MICARebatePoolDtldEntry."Document No." := SalesCrMemoLine."Document No.";
        MICARebatePoolDtldEntry."Document Line No." := SalesCrMemoLine."Line No.";
        MICARebatePoolDtldEntry.Modify();
        VariantRec := MICARebatePoolDtldEntry;
        CreateGLEntries(VariantRec, true, 2);
        CloseCurrentRebatePoolEntry(MICARebatePoolEntry, 2);
    end;

    procedure SetRecord(SalesHeader: Record "Sales Header")
    begin
        SalesCrMemoHeader := SalesHeader;
    end;

    procedure CreateCrMemoLinesFromRebPoolEntries()
    var
        MICARebatePoolEntry: Record "MICA Rebate Pool Entry";
        MICARebatePoolEntries: Page "MICA Rebate Pool Entries";
        RebatePoolEntriesFilter: Text;
    begin
        MICAFinancialReportingSetup.Get();

        MICARebatePoolEntry.SetCurrentKey(Open, "Customer No.", "Item Category Code", "Business Line");
        MICARebatePoolEntry.SetRange("Customer No.", SalesCrMemoHeader."Sell-to Customer No.");
        MICARebatePoolEntry.SetRange(Open, true);
        MICARebatePoolEntries.LookupMode(true);
        MICARebatePoolEntries.SetTableView(MICARebatePoolEntry);

        if MICARebatePoolEntries.RunModal() <> Action::LookupOK then
            exit;

        RebatePoolEntriesFilter := MICARebatePoolEntries.GetSelectionFilter(MICARebatePoolEntry);

        MICARebatePoolEntry.SetAutoCalcFields("Remaining Amount");
        MICARebatePoolEntry.SetFilter("Entry No.", RebatePoolEntriesFilter);
        if MICARebatePoolEntry.FindSet() then
            repeat
                CreateSalesCrMemoLine(MICARebatePoolEntry);
            until MICARebatePoolEntry.Next() = 0;
    end;

    local procedure CreateSalesCrMemoLine(MICARebatePoolEntry: Record "MICA Rebate Pool Entry")
    var
        SalesLine: Record "Sales Line";
        DimensionValue: Record "Dimension Value";
    begin
        SalesLine.SetRange("MICA Rebate Pool Entry No.", MICARebatePoolEntry."Entry No.");
        if not SalesLine.IsEmpty() then
            exit;

        if not MICARebatePoolItemSetup.Get(MICARebatePoolEntry."Item Category Code", MICARebatePoolEntry."Business Line") then
            exit;

        DimensionValue.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
        DimensionValue.SetRange("MICA Michelin Code", MICARebatePoolEntry."Business Line");
        if not DimensionValue.FindFirst() then
            DimensionValue.Init();

        SalesLine.Init();
        SalesLine."Document Type" := SalesCrMemoHeader."Document Type";
        SalesLine."Document No." := SalesCrMemoHeader."No.";
        SalesLine."Line No." := FindLastSalesLine(SalesCrMemoHeader."Document Type".AsInteger(), SalesCrMemoHeader."No.");
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", MICARebatePoolItemSetup."Rebate Pool Item No.");
        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Item Category Code", MICARebatePoolEntry."Item Category Code");
        SalesLine.Validate("Shortcut Dimension 2 Code", DimensionValue.Code);
        SalesLine.ValidateShortcutDimCode(6, MICARebatePoolItemSetup."Rebate Dim. Value Code");
        SalesLine.Validate("Unit Price", MICARebatePoolEntry."Remaining Amount");
        SalesLine."MICA Rebate Pool Entry No." := MICARebatePoolEntry."Entry No.";
        SalesLine.Insert(true);
    end;

    // #### Create Rebate Consumption Rebate Pool (Invoices) ####

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MICA CustomerAssortment", 'OnBeforeCheckCustomerAssortment', '', false, false)]
    local procedure SkipRebatePoolItemOnBeforeCheckCustomerAssortmant(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        if not (SalesLine."Document Type" in [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) or
            (SalesLine.Type <> SalesLine.Type::Item)
        then
            exit;

        IsHandled := MICAItemWithoutPrice.IsRebatePoolItem(SalesLine."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MICA Transient Top Management", 'OnBeforeCheckSalesAgreement', '', false, false)]
    local procedure SkipRebatePoolItemOnBeforeCheckSalesAgreement(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        if not (SalesLine."Document Type" in [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) or
            (SalesLine.Type <> SalesLine.Type::Item)
        then
            exit;

        IsHandled := MICAItemWithoutPrice.IsRebatePoolItem(SalesLine."No.");
    end;

    [EventSubscriber(ObjectType::Report, report::"MICA Combine Shipments2", 'OnBeforeSalesInvHeaderModify', '', false, false)]
    local procedure SetCreatedFromCombineShipments(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."MICA Created From Comb. Ship." := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeGetTotalAmountLCYCommon', '', false, false)]
    local procedure T18OnBeforeGetTotalAmountLCYCommon(var Customer: Record Customer; var AdditionalAmountLCY: Decimal; var IsHandled: Boolean)
    begin
        if not Customer."MICA Rebate Pool" then
            exit;

        Customer.CalcFields("MICA Rebate Pool Rem. Amount");
        AdditionalAmountLCY := -Customer."MICA Rebate Pool Rem. Amount";
    end;

    procedure CheckRebatePoolItemSetupAndConsumRebatePool(var TempSalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        BusinessLine: Code[10];
        CurrentBusinessLine: Code[20];
        AppliedAmount: Decimal;
        LineNo: Integer;
        RebatePoolItemSetupDoesntExistErr: Label 'No Rebate Pool Item Setup for this Product Line/Business Line combination: %1/%2.';
    begin
        MICAFinancialReportingSetup.Get();
        MICAFinancialReportingSetup.TestField("Rebate Pool Application %");

        CurrentBusinessLine := '';

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if not SalesHeader."MICA Created From Comb. Ship." then
            SalesLine.SetRange("MICA Status", SalesLine."MICA Status"::"Send to Execution");
        if SalesLine.FindSet() then
            repeat
                AppliedAmount := 0;

                if CurrentBusinessLine <> SalesLine."Shortcut Dimension 2 Code" then
                    BusinessLine := GetMichelinCodeStructureDimension(SalesLine."Shortcut Dimension 2 Code");

                if not MICARebatePoolItemSetup.Get(SalesLine."Item Category Code", BusinessLine) then
                    Error(RebatePoolItemSetupDoesntExistErr, SalesLine."Item Category Code", BusinessLine);

                ConsumeRebatePool(SalesLine, BusinessLine, AppliedAmount, SalesHeader."MICA Created From Comb. Ship.");

                if AppliedAmount <> 0 then
                    CreateAdditionalSalesLines(TempSalesLine, SalesLine, MICARebatePoolItemSetup, AppliedAmount, LineNo);

                CurrentBusinessLine := SalesLine."Shortcut Dimension 2 Code";
            until SalesLine.Next() = 0;
    end;

    procedure ConsumeRebatePool(SalesLine: Record "Sales Line"; BusinessLine: Code[10]; var AppliedAmount: Decimal; CreatedFromCombineShipment: Boolean)
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        MICARebatePoolEntry: Record "MICA Rebate Pool Entry";
        MICARebatePoolDtldEntry: Record "MICA Rebate Pool Dtld. Entry";
        VariantRec: Variant;
        SalesLineAmount: Decimal;
        RemainingAmountOK: Boolean;
    begin
        MICARebatePoolEntry.SetAutoCalcFields("Remaining Amount");
        MICARebatePoolEntry.Ascending(true);
        MICARebatePoolEntry.SetCurrentKey(Open, "Customer No.", "Item Category Code", "Business Line");
        MICARebatePoolEntry.SetRange(Open, true);
        MICARebatePoolEntry.SetRange("Customer No.", SalesLine."Sell-to Customer No.");
        MICARebatePoolEntry.SetRange("Item Category Code", SalesLine."Item Category Code");
        MICARebatePoolEntry.SetRange("Business Line", BusinessLine);
        if MICARebatePoolEntry.FindSet() then
            repeat
                SalesLineAmount := (SalesLine.Amount * MICAFinancialReportingSetup."Rebate Pool Application %") / 100;
                RemainingAmountOK := (MICARebatePoolEntry."Remaining Amount" > 0) and (MICARebatePoolEntry."Remaining Amount" > SalesLineAmount);

                FillRebatePoolDtldEntry(MICARebatePoolDtldEntry, MICARebatePoolEntry);
                MICARebatePoolDtldEntry."Entry Type" := MICARebatePoolDtldEntry."Entry Type"::Invoice;
                if CreatedFromCombineShipment then begin
                    if SalesShipmentLine.Get(SalesLine."Shipment No.", SalesLine."Shipment Line No.") then begin
                        MICARebatePoolDtldEntry."Order No." := SalesShipmentLine."Order No.";
                        MICARebatePoolDtldEntry."Order Line No." := SalesShipmentLine."Order Line No.";
                    end;
                end else begin
                    MICARebatePoolDtldEntry."Order No." := SalesLine."Document No.";
                    MICARebatePoolDtldEntry."Order Line No." := SalesLine."Line No.";
                end;

                if RemainingAmountOK then begin
                    MICARebatePoolDtldEntry.Amount := -SalesLineAmount;
                    SalesLineAmount := 0;
                end else begin
                    MICARebatePoolDtldEntry.Amount := -MICARebatePoolEntry."Remaining Amount";
                    CloseCurrentRebatePoolEntry(MICARebatePoolEntry, 1);
                end;

                AppliedAmount += MICARebatePoolDtldEntry.Amount;
                MICARebatePoolDtldEntry.Modify();

                VariantRec := MICARebatePoolDtldEntry;
                CreateGLEntries(VariantRec, true, 1);
            until (MICARebatePoolEntry.Next() = 0) or (SalesLineAmount = 0);
    end;

    local procedure CloseCurrentRebatePoolEntry(MICARebatePoolEntry: Record "MICA Rebate Pool Entry"; EntryType: Integer)
    var
        UpdateMICARebatePoolEntry: Record "MICA Rebate Pool Entry";
        ClosedBySystemLbl: Label 'SYSTEM', Locked = true;
    begin
        if not UpdateMICARebatePoolEntry.Get(MICARebatePoolEntry."Entry No.") then
            exit;

        UpdateMICARebatePoolEntry.Open := false;
        case EntryType of
            1:
                UpdateMICARebatePoolEntry."Closed By" := ClosedBySystemLbl;
            2:
                UpdateMICARebatePoolEntry."Closed By" := CopyStr(UserId(), 1, MaxStrLen(UpdateMICARebatePoolEntry."Closed By"));
        end;
        UpdateMICARebatePoolEntry.Modify();
    end;

    local procedure CreateAdditionalSalesLines(var TempSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line"; MICARebatePoolItemSetup: Record "MICA Rebate Pool Item Setup"; AppliedAmount: Decimal; var LineNo: Integer)
    begin
        TempSalesLine.SetRange("Document Type", SalesLine."Document Type");
        TempSalesLine.SetRange("Document No.", SalesLine."Document No.");
        TempSalesLine.SetRange("Item Category Code", SalesLine."Item Category Code");
        TempSalesLine.SetRange("Shortcut Dimension 2 Code", SalesLine."Shortcut Dimension 2 Code");
        if not TempSalesLine.FindFirst() then begin
            TempSalesLine.Init();
            TempSalesLine."Document Type" := SalesLine."Document Type";
            TempSalesLine."Document No." := SalesLine."Document No.";
            if LineNo = 0 then begin
                TempSalesLine."Line No." := FindLastSalesLine(SalesLine."Document Type".AsInteger(), SalesLine."Document No.");
                LineNo := TempSalesLine."Line No.";
            end else
                TempSalesLine."Line No." := LineNo;
            TempSalesLine."No." := MICARebatePoolItemSetup."Rebate Pool Item No.";
            TempSalesLine."Item Category Code" := SalesLine."Item Category Code";
            TempSalesLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
            TempSalesLine.Amount := AppliedAmount;
            TempSalesLine."Posting Group" := MICARebatePoolItemSetup."Rebate Dim. Value Code";
            TempSalesLine.Insert();
            LineNo += 10000;
        end else begin
            TempSalesLine.Amount += AppliedAmount;
            TempSalesLine.Modify();
        end;
    end;

    procedure CreateRebatePoolSalesLines(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var TempSalesLine: Record "Sales Line")
    begin
        TempSalesLine.Reset();
        TempSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        TempSalesLine.SetRange("Document No.", SalesHeader."No.");
        if TempSalesLine.FindSet() then
            repeat
                if not SalesLine.Get(TempSalesLine."Document Type", TempSalesLine."Document No.", TempSalesLine."Line No.") then begin
                    SalesLine.Init();
                    SalesLine.SuspendStatusCheck(true);
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Line No." := TempSalesLine."Line No.";
                    SalesLine.Insert(true);
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine.Validate("No.", TempSalesLine."No.");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", TempSalesLine.Amount);
                    SalesLine.Validate("Line Discount %", 0);
                    SalesLine.Validate("Item Category Code", TempSalesLine."Item Category Code");
                    SalesLine.Validate("Shortcut Dimension 2 Code", TempSalesLine."Shortcut Dimension 2 Code");
                    SalesLine.ValidateShortcutDimCode(6, TempSalesLine."Posting Group");
                    SalesLine."MICA Rebate Pool Line" := true;
                    SalesLine.Modify(true);
                end;
            until TempSalesLine.Next() = 0;
    end;

    local procedure FindLastSalesLine(DocumentType: Integer; DocumentNo: Code[20]): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", DocumentType);
        SalesLine.SetRange("Document No.", DocumentNo);
        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000);
        exit(10000);
    end;

    procedure PopulatePostedDocumentDataOnRebatePoolDtldEntries(SalesHeader: Record "Sales Header"; SalesInvLine: Record "Sales Invoice Line")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("MICA Rebate Pool Line", false);
        if SalesLine.FindSet() then
            repeat
                UpdatePostedDocumentNoOnRebatePoolDtldEntries(SalesLine, SalesInvLine, SalesHeader."MICA Created From Comb. Ship.");
            until SalesLine.Next() = 0;
    end;

    procedure UpdatePostedDocumentNoOnRebatePoolDtldEntries(SalesLine: Record "Sales Line"; SalesInvoiceLine: Record "Sales Invoice Line"; CombineShipment: Boolean)
    var
        MICARebatePoolDtldEntry: Record "MICA Rebate Pool Dtld. Entry";
    begin
        if not CombineShipment then
            FindPostedSalesInvoiceLine(SalesInvoiceLine, SalesLine)
        else
            FindPostedSalesInvoiceLineFromShipment(SalesInvoiceLine, SalesLine);

        MICARebatePoolDtldEntry.SetRange("Order No.", SalesInvoiceLine."Order No.");
        MICARebatePoolDtldEntry.SetRange("Order Line No.", SalesInvoiceLine."Order Line No.");
        if MICARebatePoolDtldEntry.FindSet() then
            repeat
                MICARebatePoolDtldEntry."Document No." := SalesInvoiceLine."Document No.";
                MICARebatePoolDtldEntry."Document Line No." := SalesInvoiceLine."Line No.";
                MICARebatePoolDtldEntry.Modify();
            until MICARebatePoolDtldEntry.Next() = 0;
    end;

    local procedure FindPostedSalesInvoiceLine(var SalesInvoiceLine: Record "Sales Invoice Line"; SalesLine: Record "Sales Line")
    begin
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Order No.", SalesLine."Document No.");
        SalesInvoiceLine.SetRange("Order Line No.", SalesLine."Line No.");
        if SalesInvoiceLine.FindFirst() then;
    end;

    local procedure FindPostedSalesInvoiceLineFromShipment(var SalesInvoiceLine: Record "Sales Invoice Line"; SalesLine: Record "Sales Line")
    var
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        if not SalesShipmentLine.Get(SalesLine."Shipment No.", SalesLine."Shipment Line No.") then
            exit;

        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Order No.", SalesShipmentLine."Order No.");
        SalesInvoiceLine.SetRange("Order Line No.", SalesShipmentLine."Order Line No.");
        if SalesInvoiceLine.FindFirst() then;
    end;


    // #### Create Rebate Pool manually (populate and post Rebate Pool Journal) ####
    procedure CreateManuallyRebatePoolJournal()
    var
        MICARebatePoolJournalLine: Record "MICA Rebate Pool Journal Line";
    begin
        if MICARebatePoolJournalLine.FindSet() then
            repeat
                CreateOrUpdateRebatePoolEntry(MICARebatePoolJournalLine);
            until MICARebatePoolJournalLine.Next() = 0;
        MICARebatePoolJournalLine.DeleteAll();
    end;

    // #### Create Rebate Pool from Rebate Setup Card ####
    procedure CreateRebatePoolFromRebateSetupCard(ExportToExcel: Boolean)
    var
        RebateJournalDocumentNo: Code[20];
    begin
        SetAndTestSetup(RebateJournalDocumentNo);
        PopulateRebatePoolJournal(RebateJournalDocumentNo, ExportToExcel);
        PostRebatePoolJournal();

        if not ExportToExcel then
            exit;
        if TempExcelBuffer.IsEmpty() then
            exit;
        CreateAndSaveExcel();
    end;

    local procedure SetAndTestSetup(var DocumentNo: Code[20])
    var
        EndingDateIsNotExpiredErr: Label 'The offer is still open. The ending date is in the future and therefore the Rebate Pool cannot be created.';
    begin
        MICAAccrualSetup.TestField("Is Deferred", true);
        if WorkDate() < MICAAccrualSetup."Ending Date" then
            Error(EndingDateIsNotExpiredErr);

        MICAFinancialReportingSetup.Get();
        MICAFinancialReportingSetup.TestField("Structure Dimension");

        if not MICARebatePoolPostingSetup.Get(MICAAccrualSetup."Rebate Pool Posting Setup") then
            MICARebatePoolPostingSetup.Init();

        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.TestField("MICA Reb. Pool Jnl. Serie No.");
        DocumentNo := NoSeriesManagement.GetNextNo(SalesReceivablesSetup."MICA Reb. Pool Jnl. Serie No.", Today(), false);
    end;

    local procedure PopulateRebatePoolJournal(RebateJournalDocumentNo: Code[20]; ExportToExcel: Boolean)
    var
        Customer: Record Customer;
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
        MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
        MICARebatePoolJournalLine: Record "MICA Rebate Pool Journal Line";
        VariantRec: Variant;
        GlobalRebatePoolAmt: Decimal;
        MichelinCodeDimensionValue: Code[10];
        CurrentGlobalDim2CodeValue: Code[20];
    begin
        CurrentGlobalDim2CodeValue := '';

        FilterCustomer(Customer);
        if Customer.IsEmpty() then
            exit;

        if Customer.FindSet() then
            repeat
                MICACustomerAccrualEntry.Ascending(true);
                MICACustomerAccrualEntry.SetCurrentKey("Customer No.", "Posting Date");
                MICACustomerAccrualEntry.SetRange("Customer No.", Customer."No.");
                MICACustomerAccrualEntry.SetRange(Open, false);
                MICACustomerAccrualEntry.SetRange(Code, MICAAccrualSetup.Code);
                if MICACustomerAccrualEntry.FindLast() then begin
                    MICACustDetailAccrEntry.SetRange("Customer Accruals Entry No.", MICACustomerAccrualEntry."Entry No.");
                    GlobalRebatePoolAmt := 0;
                    if MICACustDetailAccrEntry.FindSet() then
                        repeat
                            if CurrentGlobalDim2CodeValue <> MICACustDetailAccrEntry."Global Dimension 2 Code" then
                                MichelinCodeDimensionValue := GetMichelinCodeStructureDimension(MICACustDetailAccrEntry."Global Dimension 2 Code");

                            MICARebatePoolJournalLine.SetCurrentKey("Rebate Code", "Customer No.", "Item Category Code", "Business Line");
                            MICARebatePoolJournalLine.SetRange("Rebate Code", MICACustDetailAccrEntry.Code);
                            MICARebatePoolJournalLine.SetRange("Customer No.", MICACustDetailAccrEntry."Customer No.");
                            MICARebatePoolJournalLine.SetRange("Item Category Code", MICACustDetailAccrEntry."Item Category Code");
                            MICARebatePoolJournalLine.SetRange("Business Line", MichelinCodeDimensionValue);
                            if not MICARebatePoolJournalLine.FindFirst() then
                                CreateOrUpdateRebatePoolJournalLine(MICARebatePoolJournalLine, MICACustDetailAccrEntry, RebateJournalDocumentNo, MichelinCodeDimensionValue, true)
                            else
                                CreateOrUpdateRebatePoolJournalLine(MICARebatePoolJournalLine, MICACustDetailAccrEntry, RebateJournalDocumentNo, MichelinCodeDimensionValue, false);

                            GlobalRebatePoolAmt += MICACustDetailAccrEntry."Accruals Amount";
                            CurrentGlobalDim2CodeValue := MICACustDetailAccrEntry."Global Dimension 2 Code";

                            if ExportToExcel then
                                MICACustDetailAccrEntry.Mark(true);
                        until MICACustDetailAccrEntry.Next() = 0;
                    MICACustDetailAccrEntry.SetRange("Customer Accruals Entry No.");

                    MICACustomerAccrualEntry."Rebate Pool Amount" := GlobalRebatePoolAmt;
                    MICACustomerAccrualEntry.Modify();

                    VariantRec := MICACustomerAccrualEntry;
                    CreateGLEntries(VariantRec, false, 0);
                end;
                MICACustomerAccrualEntry.SetRange("Customer No.");
                MICACustomerAccrualEntry.SetRange(Open);
            until Customer.Next() = 0;

        if ExportToExcel then
            FillExcelWithCustDtldRebateEntries(MICACustDetailAccrEntry);
    end;

    local procedure FilterCustomer(var Customer: Record Customer)
    begin
        Customer.SetCurrentKey("MICA Rebate Pool");
        Customer.SetRange("MICA Rebate Pool", true);
        case MICAAccrualSetup."Sales Type" of
            MICAAccrualSetup."Sales Type"::"All Customers":
                Customer.SetFilter("MICA Accr. Customer Grp.", '<>%1', '');
            MICAAccrualSetup."Sales Type"::"Accr. Cust. Grp.":
                Customer.SetFilter("MICA Accr. Customer Grp.", MICAAccrualSetup."Sales Code");
            MICAAccrualSetup."Sales Type"::Customer:
                Customer.SetFilter("No.", MICAAccrualSetup."Sales Code");
        end;
    end;

    procedure PostRebatePoolJournal()
    var
        MICARebatePoolJournalLine: Record "MICA Rebate Pool Journal Line";
        MICARebatePoolEntry: Record "MICA Rebate Pool Entry";
    begin
        MICARebatePoolJournalLine.SetFilter(Amount, '<>%1', 0);
        if MICARebatePoolJournalLine.IsEmpty() then
            exit;
        if MICARebatePoolJournalLine.FindSet() then
            repeat
                CreateOrUpdateRebatePoolEntry(MICARebatePoolJournalLine);
            until MICARebatePoolJournalLine.Next() = 0;

        MICARebatePoolJournalLine.Reset();
        MICARebatePoolJournalLine.DeleteAll();

        MICARebatePoolEntry.SetAutoCalcFields(MICARebatePoolEntry."Remaining Amount");
        MICARebatePoolEntry.SetFilter("Remaining Amount", '>%1&<%2', 0, 1); //for now, check if Remaining Amount is less then 1 (to be confirmed with Michelin this case)
        if MICARebatePoolEntry.FindSet() then
            repeat
                MICARebatePoolEntry.Open := false;
                MICARebatePoolEntry.Modify();
            until MICARebatePoolEntry.Next() = 0;
    end;

    procedure CreateOrUpdateRebatePoolJournalLine(var MICARebatePoolJournalLine: Record "MICA Rebate Pool Journal Line"; MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry"; DocumentNo: Code[20]; BusinessLine: Code[10]; CreateOrUpdate: Boolean)
    begin
        if CreateOrUpdate then begin
            MICARebatePoolJournalLine.Init();
            MICARebatePoolJournalLine."Customer No." := MICACustDetailAccrEntry."Customer No.";
            MICARebatePoolJournalLine.Validate("Rebate Code", MICACustDetailAccrEntry.Code);
            MICARebatePoolJournalLine."Item Category Code" := MICACustDetailAccrEntry."Item Category Code";
            MICARebatePoolJournalLine."Business Line" := BusinessLine;
            MICARebatePoolJournalLine."Document No." := DocumentNo;
            MICARebatePoolJournalLine."Posting Date" := WorkDate();
            MICARebatePoolJournalLine."Line No." := GetRebateJournalLineNo(DocumentNo);
            MICARebatePoolJournalLine.Amount := MICACustDetailAccrEntry."Accruals Amount";
            MICARebatePoolJournalLine.Insert();
        end else begin
            MICARebatePoolJournalLine.Amount += MICACustDetailAccrEntry."Accruals Amount";
            MICARebatePoolJournalLine.Modify();
        end;
    end;

    procedure CreateOrUpdateRebatePoolEntry(MICARebatePoolJournalLine: Record "MICA Rebate Pool Journal Line")
    var
        MICARebatePoolEntry: Record "MICA Rebate Pool Entry";
    begin
        MICARebatePoolEntry.SetRange("Rebate Code", MICARebatePoolJournalLine."Rebate Code");
        MICARebatePoolEntry.SetRange("Customer No.", MICARebatePoolJournalLine."Customer No.");
        MICARebatePoolEntry.SetRange("Item Category Code", MICARebatePoolJournalLine."Item Category Code");
        MICARebatePoolEntry.SetRange("Business Line", MICARebatePoolJournalLine."Business Line");
        if not MICARebatePoolEntry.FindFirst() then begin
            MICARebatePoolEntry.Init();
            MICARebatePoolEntry."Entry No." := FindLastEntryNo(0);
            MICARebatePoolEntry."Posting Date" := WorkDate();
            MICARebatePoolEntry."Customer No." := MICARebatePoolJournalLine."Customer No.";
            MICARebatePoolEntry."Rebate Code" := MICARebatePoolJournalLine."Rebate Code";
            MICARebatePoolEntry."Customer Description" := MICARebatePoolJournalLine."Customer Description";
            MICARebatePoolEntry."Item Category Code" := MICARebatePoolJournalLine."Item Category Code";
            MICARebatePoolEntry."Business Line" := MICARebatePoolJournalLine."Business Line";
            MICARebatePoolEntry."Original Amount" := MICARebatePoolJournalLine.Amount;
            MICARebatePoolEntry.Open := true;
            MICARebatePoolEntry.Insert();
        end else begin
            MICARebatePoolEntry."Original Amount" += MICARebatePoolJournalLine.Amount;
            MICARebatePoolEntry.Modify();
        end;
        CreateOrUpdateRebatePoolDtldEntry(MICARebatePoolEntry);
    end;

    local procedure CreateOrUpdateRebatePoolDtldEntry(MICARebatePoolEntry: Record "MICA Rebate Pool Entry")
    var
        MICARebatePoolDtldEntry: Record "MICA Rebate Pool Dtld. Entry";
    begin
        MICARebatePoolDtldEntry.SetRange("Entry Type", MICARebatePoolDtldEntry."Entry Type"::"Initial Entry");
        MICARebatePoolDtldEntry.SetRange("Rebate Pool Entry No.", MICARebatePoolEntry."Entry No.");
        if not MICARebatePoolDtldEntry.FindFirst() then
            FillRebatePoolDtldEntry(MICARebatePoolDtldEntry, MICARebatePoolEntry)
        else begin
            MICARebatePoolDtldEntry.Amount += MICARebatePoolEntry."Original Amount";
            MICARebatePoolDtldEntry.Modify();
        end;
    end;

    local procedure FillRebatePoolDtldEntry(var MICARebatePoolDtldEntry: Record "MICA Rebate Pool Dtld. Entry"; MICARebatePoolEntry: Record "MICA Rebate Pool Entry")
    begin
        MICARebatePoolDtldEntry.Init();
        MICARebatePoolDtldEntry."Entry No." := FindLastEntryNo(1);
        MICARebatePoolDtldEntry."Posting Date" := MICARebatePoolEntry."Posting Date";
        MICARebatePoolDtldEntry."Entry Type" := MICARebatePoolDtldEntry."Entry Type"::"Initial Entry";
        MICARebatePoolDtldEntry."Rebate Pool Entry No." := MICARebatePoolEntry."Entry No.";
        MICARebatePoolDtldEntry."Rebate Code" := MICARebatePoolEntry."Rebate Code";
        MICARebatePoolDtldEntry."Customer No." := MICARebatePoolEntry."Customer No.";
        MICARebatePoolDtldEntry."Item Category Code" := MICARebatePoolEntry."Item Category Code";
        MICARebatePoolDtldEntry."Business Line" := MICARebatePoolEntry."Business Line";
        MICARebatePoolDtldEntry.Amount := MICARebatePoolEntry."Original Amount";
        MICARebatePoolDtldEntry.Insert();
    end;

    local procedure FindLastEntryNo(TypeOfEntryTable: Integer): Integer
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        EntryNo: Integer;
    begin
        case TypeOfEntryTable of
            0:
                RecRef.Open(Database::"MICA Rebate Pool Entry");
            1:
                RecRef.Open(Database::"MICA Rebate Pool Dtld. Entry");
            2:
                RecRef.Open(Database::"G/L Entry");
        end;

        if RecRef.IsEmpty() then
            exit(1);
        RecRef.FindLast();
        FldRef := RecRef.FieldIndex(1);
        EntryNo := FldRef.Value();
        exit(EntryNo + 1);
    end;

    local procedure CreateGLEntries(VariantRec: Variant; AmountSignPositiveNegative: Boolean; RebatePoolEntryType: Integer)
    begin
        PopulateGLEntry(MICARebatePoolPostingSetup."Balancing Rebate Account No.", VariantRec, AmountSignPositiveNegative, RebatePoolEntryType);
        PopulateGLEntry(MICARebatePoolPostingSetup."Rebate Account No.", VariantRec, not AmountSignPositiveNegative, RebatePoolEntryType);
    end;

    local procedure PopulateGLEntry(AccountNo: Code[20]; VariantRec: Variant; AmountSignPositiveNegative: Boolean; RebatePoolEntryType: Integer)
    var
        GLEntry: Record "G/L Entry";
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
        MICARebatePoolDtldEntry: Record "MICA Rebate Pool Dtld. Entry";
        CustomerNo: Code[20];
        RebateCode: Code[20];
        RebatePoolAmount: Decimal;
        RebatePoolInitialGLEntryDescriptionLbl: Label 'REBATE POOL INITIAL', Locked = true;
        RebatePoolInvoiceGLEntryDescriptionLbl: Label 'REBATE POOL INVOICE CONSUMPTION', Locked = true;
        RebatePoolClosingGLEntryDescriptionLbl: Label 'REBATE POOL CLOSING', Locked = true;
    begin
        case RebatePoolEntryType of
            0:
                begin
                    MICACustomerAccrualEntry := VariantRec;
                    RebatePoolAmount := MICACustomerAccrualEntry."Rebate Pool Amount";
                    CustomerNo := MICACustomerAccrualEntry."Customer No.";
                    RebateCode := MICACustomerAccrualEntry.Code;
                end;
            1, 2:
                begin
                    MICARebatePoolDtldEntry := VariantRec;
                    MICAAccrualSetup.Get(MICARebatePoolDtldEntry."Rebate Code");
                    if not MICARebatePoolPostingSetup.Get(MICAAccrualSetup."Rebate Pool Posting Setup") then
                        exit;
                    if AmountSignPositiveNegative then
                        AccountNo := MICARebatePoolPostingSetup."Balancing Rebate Account No."
                    else
                        AccountNo := MICARebatePoolPostingSetup."Rebate Account No.";

                    RebatePoolAmount := -MICARebatePoolDtldEntry.Amount;
                    CustomerNo := MICARebatePoolDtldEntry."Customer No.";
                    RebateCode := MICARebatePoolDtldEntry."Rebate Code";
                end;
        end;

        GLEntry.Init();
        GLEntry."Entry No." := FindLastEntryNo(2);
        GLEntry.Insert();
        GLEntry.Validate("G/L Account No.", AccountNo);
        GLEntry.Validate("Posting Date", WorkDate());
        GLEntry.Validate("Document Type", GLEntry."Document Type"::" ");
        if AmountSignPositiveNegative then begin
            GLEntry.Validate(Amount, RebatePoolAmount);
            GLEntry.Validate("Debit Amount", RebatePoolAmount);
        end else begin
            GLEntry.Validate(Amount, -RebatePoolAmount);
            GLEntry.Validate("Credit Amount", RebatePoolAmount);
        end;
        GLEntry.Validate("Bal. Account Type", GLEntry."Bal. Account Type"::Customer);
        GLEntry.Validate("Bal. Account No.", CustomerNo);
        GLEntry.Validate("Source Type", GLEntry."Source Type"::Customer);
        GLEntry.Validate("Source No.", CustomerNo);
        GLEntry.Validate("MICA Rebate Code", RebateCode);
        case RebatePoolEntryType of
            0:
                GLEntry.Validate(Description, RebatePoolInitialGLEntryDescriptionLbl);
            1:
                GLEntry.Validate(Description, RebatePoolInvoiceGLEntryDescriptionLbl);
            2:
                GLEntry.Validate(Description, RebatePoolClosingGLEntryDescriptionLbl);
        end;
        GLEntry.Validate("MICA No. 2", GetGLEntryNo2(GLEntry."G/L Account No."));
        GLEntry.Validate("MICA Amount (FCY)", GLEntry.Amount);
        GLEntry.Modify();
    end;

    local procedure GetGLEntryNo2(GLAccountNo: Code[20]): Code[20]
    var
        GLAccount: Record "G/L Account";
    begin
        if not GLAccount.Get(GLAccountNo) then
            GLAccount.Init();

        exit(GLAccount."No. 2");
    end;

    local procedure FillExcelWithCustDtldRebateEntries(var MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry")
    var
        CustDtldRebEntriescordRef: RecordRef;
    begin
        MICACustDetailAccrEntry.MarkedOnly(true);
        if MICACustDetailAccrEntry.IsEmpty() then
            exit;
        if MICACustDetailAccrEntry.FindSet() then begin
            FillExcelHeader();
            repeat
                CustDtldRebEntriescordRef.GetTable(MICACustDetailAccrEntry);
                FillExcelLines(CustDtldRebEntriescordRef);
                MICACustDetailAccrEntry.Delete();
            until MICACustDetailAccrEntry.Next() = 0;
        end;
    end;

    local procedure FillExcelHeader()
    var
        TableField: Record Field;
        CustDtldRebEntriesRecordRef: RecordRef;
        FieldsCustDtldRebateEntriesFieldRef: FieldRef;
    begin
        CustDtldRebEntriesRecordRef.Open(Database::"MICA Cust. Detail. Accr. Entry");
        TempExcelBuffer.NewRow();

        TableField.SetRange(TableNo, CustDtldRebEntriesRecordRef.Number());
        TableField.SetRange(ObsoleteState, TableField.ObsoleteState::No, TableField.ObsoleteState::Pending);
        if TableField.FindSet() then
            repeat
                FieldsCustDtldRebateEntriesFieldRef := CustDtldRebEntriesRecordRef.Field(TableField."No.");
                TempExcelBuffer.AddColumn(FieldsCustDtldRebateEntriesFieldRef.Caption(), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until TableField.Next() = 0;
        CustDtldRebEntriesRecordRef.Close();
    end;

    local procedure FillExcelLines(CustDtldRebEntriesRecordRef: RecordRef)
    var
        TableField: Record Field;
        FieldsCustDtldRebateEntriesFieldRef: FieldRef;
    begin
        TempExcelBuffer.NewRow();

        TableField.SetRange(TableNo, CustDtldRebEntriesRecordRef.Number());
        TableField.SetRange(ObsoleteState, TableField.ObsoleteState::No, TableField.ObsoleteState::Pending);
        if TableField.FindSet() then
            repeat
                FieldsCustDtldRebateEntriesFieldRef := CustDtldRebEntriesRecordRef.Field(TableField."No.");

                if FieldsCustDtldRebateEntriesFieldRef.Class = FieldsCustDtldRebateEntriesFieldRef.Class::FlowField then
                    FieldsCustDtldRebateEntriesFieldRef.CalcField();

                if FieldsCustDtldRebateEntriesFieldRef.Active then
                    case FieldsCustDtldRebateEntriesFieldRef.Type of
                        FieldsCustDtldRebateEntriesFieldRef.Type::Code, FieldsCustDtldRebateEntriesFieldRef.Type::Text, FieldsCustDtldRebateEntriesFieldRef.Type::Option, FieldsCustDtldRebateEntriesFieldRef.Type::Decimal,
                        FieldsCustDtldRebateEntriesFieldRef.Type::Boolean:
                            TempExcelBuffer.AddColumn(FieldsCustDtldRebateEntriesFieldRef.Value(), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        FieldsCustDtldRebateEntriesFieldRef.Type::Date:
                            TempExcelBuffer.AddColumn(FieldsCustDtldRebateEntriesFieldRef.Value(), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                        FieldsCustDtldRebateEntriesFieldRef.Type::Integer:
                            TempExcelBuffer.AddColumn(FieldsCustDtldRebateEntriesFieldRef.Value(), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    end;
            until TableField.Next() = 0;
    end;

    local procedure CreateAndSaveExcel()
    var
        SelectedOptionExcelBook: Text[50];
        SelectedOptionWorksheet: Text[50];
        SelectedFriendlyName: Text[80];
        CustDltdRebLedgerEntriesExcelBookLbl: Label 'Customer Detail Rebate Ledger Entries';
        CustDltdRebLedgerEntriesExcelSheetLbl: Label 'Customer Detail Rebate Ledger Entries';
        CustDltdRebLedgerEntriesDataLbl: Label 'Customer Detail Rebate Ledger Entries_%1';
    begin
        SelectedOptionExcelBook := CustDltdRebLedgerEntriesExcelBookLbl;
        SelectedOptionWorksheet := CustDltdRebLedgerEntriesExcelSheetLbl;
        SelectedFriendlyName := StrSubstNo(CustDltdRebLedgerEntriesDataLbl, Format(CurrentDateTime(), 0, '<Year4><Month,2><Day,2>_<Hours24,2><Minutes,2><Seconds,2>'));

        TempExcelBuffer.CreateNewBook(CustDltdRebLedgerEntriesExcelBookLbl);
        TempExcelBuffer.WriteSheet(SelectedOptionWorksheet, CompanyName(), UserId());
        TempExcelBuffer.SetFriendlyFilename(SelectedFriendlyName);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();
    end;

    local procedure GetRebateJournalLineNo(DocumentNo: Code[20]): Integer
    var
        MICARebatePoolJournalLine: Record "MICA Rebate Pool Journal Line";
    begin
        MICARebatePoolJournalLine.SetRange("Document No.", DocumentNo);
        if MICARebatePoolJournalLine.FindLast() then
            exit(MICARebatePoolJournalLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetMichelinCodeStructureDimension(DimensionCode: Code[20]): Code[10]
    var
        DimensionValue: Record "Dimension Value";
    begin
        if not DimensionValue.Get(MICAFinancialReportingSetup."Structure Dimension", DimensionCode) then
            exit;

        exit(DimensionValue."MICA Michelin Code");
    end;

    procedure SetRebateSetup(NewMICAAccrualSetup: Record "MICA Accrual Setup")
    begin
        MICAAccrualSetup := NewMICAAccrualSetup;
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        MICAAccrualSetup: Record "MICA Accrual Setup";
        MICARebatePoolPostingSetup: Record "MICA Rebate Pool Posting Setup";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        MICARebatePoolItemSetup: Record "MICA Rebate Pool Item Setup";
        SalesCrMemoHeader: Record "Sales Header";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        MICAItemWithoutPrice: Codeunit "MICA ItemWithoutPrice";
}