codeunit 81940 "MICA Report F336 Mgt."
{
    trigger OnRun()
    begin
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        StartingPeriod: Date;
        EndingPeriod: Date;
        Type: Option "VAL 0 Bis","VAL 2";
        Dialog: Dialog;
        TxtDial_Lbl: label 'Phase #1########## \';
        TxtDialProcess_Lbl: label 'Progress @2@@@@@@@@@@';
        TxtDialPrepareData_Lbl: label 'Preparing the data';

    procedure SetPeriod(NewStartingPeriod: Date; NewEndingPeriod: Date)
    begin
        StartingPeriod := NewStartingPeriod;
        EndingPeriod := NewEndingPeriod;
    end;

    procedure GetF336Data(var ExportMICAF336Buffer: Record "MICA F336 Buffer")
    var
        Customer: Record Customer;
        ValueEntry: Record "Value Entry";
        TempMICAServiceItemCalcCost: Record "MICA Service Item Calc. Cost" temporary;
        TempMICADeferredCalcBuffer: Record "MICA Deferred Calc Buffer" temporary;
        RebateCalcDate: Date;
        CurrTotal: Integer;
        TotalRecs: Integer;
        LocationFilter: Text;
        CustomerFilter: Text;
        CustomerFilterLbl: Label '%1|%2', Comment = '%1,%2';
    begin
        if not ExportMICAF336Buffer.IsTemporary() then
            exit;
        MICAFinancialReportingSetup.Get();
        GeneralLedgerSetup.Get();

        TestSetup();

        RebateCalcDate := GetLastRebateCalcDate();
        ExportMICAF336Buffer.Reset();
        if not ExportMICAF336Buffer.IsEmpty() then
            ExportMICAF336Buffer.DeleteAll();

        Dialog.OPEN(TxtDial_Lbl + TxtDialProcess_Lbl);
        Dialog.UPDATE(1, TxtDialPrepareData_Lbl);

        Customer.SetFilter("MICA Party Ownership", '%1|%2', Customer."MICA Party Ownership"::"Non Group", Customer."MICA Party Ownership"::"Group Network");
        TotalRecs := Customer.Count();
        IF Customer.FindSet() then begin
            LocationFilter := GetLocationFilter(1);
            repeat
                if CustomerFilter = '' then
                    CustomerFilter := Customer."No."
                else
                    CustomerFilter := StrSubstNo(CustomerFilterLbl, CustomerFilter, Customer."No.");

                if ExistValueEntries(Customer."No.", ValueEntry, LocationFilter) then
                    GetF336BufferFromValueEntry(ExportMICAF336Buffer, ValueEntry);
                CurrTotal += 1;
                Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
            until Customer.Next() = 0;

            GetDeferredCalcData(CustomerFilter, TempMICADeferredCalcBuffer, RebateCalcDate);
            GetServiceItemCalcCostData(ExportMICAF336Buffer, TempMICAServiceItemCalcCost);
            FillF336FromServiceItemCalcCost(ExportMICAF336Buffer, TempMICAServiceItemCalcCost);
            FillF336BufferWithDefferedGroupAccount(ExportMICAF336Buffer, TempMICADeferredCalcBuffer);
        end;
        Dialog.Close();
    end;

    local procedure FillF336FromServiceItemCalcCost(var MICAF336Buffer: Record "MICA F336 Buffer"; var MICAServiceItemCalcCost: Record "MICA Service Item Calc. Cost")
    var
        GLAccount: Record "G/L Account";
        TotalNetChange: Decimal;
        RemainNetChange: Decimal;
        CurrTotal: Integer;
        TotalRecs: Integer;
    begin

        MICAF336Buffer.Reset();
        MICAServiceItemCalcCost.Reset();
        MICAServiceItemCalcCost.SetCurrentKey("Structure Dimension");
        TotalRecs := MICAServiceItemCalcCost.Count();
        if MICAServiceItemCalcCost.FindSet() then
            repeat
                //filter current group (item, Structure Dimension)
                MICAServiceItemCalcCost.SetRange("Structure Dimension", MICAServiceItemCalcCost."Structure Dimension");
                MICAServiceItemCalcCost.FindSet();

                //Calculate Total Net change for a Structure Group
                Clear(TotalNetChange);
                Clear(RemainNetChange);
                GLAccount.SetFilter("No. 2", MICAFinancialReportingSetup."F336 G/L Acc. No.2 Filter");
                GLAccount.SetRange("Date Filter", StartingPeriod, EndingPeriod);
                GLAccount.SetFilter("Global Dimension 1 Filter", GetGlobalDimValue(1, MICAServiceItemCalcCost."Structure Dimension"));
                GLAccount.SetFilter("Global Dimension 2 Filter", GetGlobalDimValue(2, MICAServiceItemCalcCost."Structure Dimension"));
                GLAccount.SetAutoCalcFields("Net Change");
                if GLAccount.FindSet() then
                    repeat
                        TotalNetChange += GLAccount."Net Change";
                    until GLAccount.Next() = 0;

                repeat
                    IF MICAF336Buffer.get(MICAServiceItemCalcCost."Item No.",
                                        MICAServiceItemCalcCost."Country-of Sales",
                                        MICAServiceItemCalcCost."Market Code",
                                        MICAServiceItemCalcCost."Client Code",
                                        MICAServiceItemCalcCost."Invoicing Currency",
                                        MICAServiceItemCalcCost."Intercompany Dimension",
                                        MICAServiceItemCalcCost."Structure Dimension")
                    then begin
                        MICAF336Buffer.Quantity := 1;
                        MICAF336Buffer."Net Turnover Invoiced" := MICAServiceItemCalcCost."Net Turnover Invoiced";
                        MICAF336Buffer.CRV := Round(RemainNetChange + (TotalNetChange * MICAServiceItemCalcCost."% of cost" / 100), 1);
                        RemainNetChange := RemainNetChange + (TotalNetChange * MICAServiceItemCalcCost."% of cost" / 100) - MICAF336Buffer.CRV;
                        MICAF336Buffer.Modify();
                    end;

                    CurrTotal += 1;
                    Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
                until MICAServiceItemCalcCost.Next() = 0;

                //release filter of current group to go to next group
                MICAServiceItemCalcCost.FindLast();
                MICAServiceItemCalcCost.SetRange("Structure Dimension");
            until MICAServiceItemCalcCost.Next() = 0;
    end;

    local procedure GetGlobalDimValue(GlobalDimId: Integer; StructureDimValue: Code[20]): Text[20];
    begin
        case GlobalDimId of
            1:
                begin
                    if GeneralLedgerSetup."Global Dimension 1 Code" = MICAFinancialReportingSetup."Structure Dimension" then
                        exit(StructureDimValue);
                    if GeneralLedgerSetup."Global Dimension 1 Code" = MICAFinancialReportingSetup."Section Dimension" then
                        exit(MICAFinancialReportingSetup."F336 Dimension Section Filter");
                end;
            2:
                begin
                    if GeneralLedgerSetup."Global Dimension 2 Code" = MICAFinancialReportingSetup."Structure Dimension" then
                        exit(StructureDimValue);
                    if GeneralLedgerSetup."Global Dimension 2 Code" = MICAFinancialReportingSetup."Section Dimension" then
                        exit(MICAFinancialReportingSetup."F336 Dimension Section Filter");
                end;
        end;
    end;

    local procedure FillF336BufferWithDefferedGroupAccount(var F336Buffer: Record "MICA F336 Buffer"; var DeferredCalcBuffer: Record "MICA Deferred Calc Buffer")
    var
        AccrualAmt: Decimal;
        RemainGLAmount: Decimal;
    begin
        GetReversalRebateAmounts(DeferredCalcBuffer);

        DeferredCalcBuffer.Reset();
        IF DeferredCalcBuffer.IsEmpty() then
            exit;

        F336Buffer.Reset();
        DeferredCalcBuffer.Reset();
        IF DeferredCalcBuffer.FindSet() then
            repeat
                Clear(RemainGLAmount);
                AccrualAmt := 0;
                //Filter current group of Accrual Code
                DeferredCalcBuffer.SetRange("Accruals Code", DeferredCalcBuffer."Accruals Code");
                DeferredCalcBuffer.FindSet();
                repeat
                    if DeferredCalcBuffer."Total G/L Amount" <> 0 then begin
                        AccrualAmt := Round(RemainGLAmount + (DeferredCalcBuffer."Total G/L Amount" * DeferredCalcBuffer."Accruals %" / 100), 1);
                        RemainGLAmount := (RemainGLAmount + (DeferredCalcBuffer."Total G/L Amount" * DeferredCalcBuffer."Accruals %" / 100)) - AccrualAmt;
                    end;

                    if not F336Buffer.Get(DeferredCalcBuffer."Item No.",
                                          DeferredCalcBuffer."Country-of Sales",
                                          DeferredCalcBuffer."Market Code",
                                          DeferredCalcBuffer."Forecast Code",
                                          DeferredCalcBuffer."Currency Code",
                                          DeferredCalcBuffer."Intercompany Dimension",
                                          DeferredCalcBuffer."Structure Dimension")
                    then
                        InsertF336FromDeferredCalc(F336Buffer, DeferredCalcBuffer, AccrualAmt)
                    else
                        UpdateF336FromDefferedCalc(F336Buffer, DeferredCalcBuffer."Accruals Amount", AccrualAmt);
                until DeferredCalcBuffer.Next() = 0;
                //release filter current group of Accrual Code
                DeferredCalcBuffer.FindLast();
                DeferredCalcBuffer.SetRange("Accruals Code");
            until DeferredCalcBuffer.Next() = 0;
    end;

    local procedure UpdateF336FromDefferedCalc(var F336Buffer: Record "MICA F336 Buffer"; AccrualAmt: Decimal; GLAccrualAmt: Decimal)
    var
        Currency: Record Currency;
        CurrencyFactor: Decimal;
    begin
        F336Buffer."Net Sales" := F336Buffer."Net Sales" - AccrualAmt - GLAccrualAmt;
        if F336Buffer."Invoicing Currency" <> '' then begin
            Currency.Get(F336Buffer."Invoicing Currency");
            CurrencyFactor := CurrencyExchangeRate.ExchangeRate(EndingPeriod, F336Buffer."Invoicing Currency");
            F336Buffer."Net Sales In The Inv. Currency" +=
                        Round(CurrencyExchangeRate.ExchangeAmtLCYToFCYOnlyFactor(F336Buffer."Net Sales", CurrencyFactor), Currency."Invoice Rounding Precision");
        end else
            F336Buffer."Net Sales In The Inv. Currency" := F336Buffer."Net Sales";
        F336Buffer.Modify();
    end;

    local procedure InsertF336FromDeferredCalc(var F336Buffer: Record "MICA F336 Buffer"; DeferredCalcBuffer: Record "MICA Deferred Calc Buffer"; AccrualAmt: Decimal)
    var
        Currency: Record Currency;
        CurrencyFactor: Decimal;
    begin
        clear(F336Buffer);
        F336Buffer."Item No." := DeferredCalcBuffer."Item No.";
        F336Buffer."Country-of Sales" := DeferredCalcBuffer."Country-of Sales";
        F336Buffer."Market Code" := DeferredCalcBuffer."Market Code";
        F336Buffer."Client Code" := DeferredCalcBuffer."Forecast Code";
        F336Buffer."Invoicing Currency" := CopyStr(DeferredCalcBuffer."Currency Code", 1, 10);
        F336Buffer."Intercompany Dimension" := DeferredCalcBuffer."Intercompany Dimension";
        F336Buffer."Structure Dimension" := DeferredCalcBuffer."Structure Dimension";
        F336Buffer."Net Sales" := F336Buffer."Net Sales" - DeferredCalcBuffer."Accruals Amount" - AccrualAmt;
        if F336Buffer."Invoicing Currency" <> '' then begin
            Currency.Get(DeferredCalcBuffer."Currency Code");
            CurrencyFactor := CurrencyExchangeRate.ExchangeRate(EndingPeriod, F336Buffer."Invoicing Currency");
            F336Buffer."Net Sales In The Inv. Currency" :=
                        Round(CurrencyExchangeRate.ExchangeAmtLCYToFCYOnlyFactor(F336Buffer."Net Sales", CurrencyFactor), Currency."Invoice Rounding Precision");
        end else
            F336Buffer."Net Sales In The Inv. Currency" := F336Buffer."Net Sales";
        F336Buffer.Insert();
    end;

    local procedure GetServiceItemCalcCostData(var MICAF336Buffer: Record "MICA F336 Buffer"; var MICAServiceItemCalcCost: Record "MICA Service Item Calc. Cost")
    var
        TotalNetTurnoverInvoiced: Decimal;
        CurrTotal: Integer;
        TotalRecs: Integer;
        RemainCostPercent: Decimal;
    begin
        IF NOT MICAServiceItemCalcCost.IsTemporary() then
            EXIT;

        with MICAF336Buffer do begin
            Reset();
            SetRange("Service Item", true);
            TotalRecs := MICAF336Buffer.Count();
            if MICAF336Buffer.FindSet() then
                repeat
                    MICAServiceItemCalcCost.Reset();
                    IF MICAServiceItemCalcCost.GET("Item No.", "Country-of Sales", "Market Code", "Client Code", "Invoicing Currency", "Intercompany Dimension", "Structure Dimension") then begin
                        MICAServiceItemCalcCost."Net Turnover Invoiced" += MICAF336Buffer."Net Turnover Invoiced";
                        MICAServiceItemCalcCost.Modify();
                    end else begin
                        MICAServiceItemCalcCost.Init();
                        MICAServiceItemCalcCost."Item No." := "Item No.";
                        MICAServiceItemCalcCost."Country-of Sales" := CopyStr("Country-of Sales", 1, 10);
                        MICAServiceItemCalcCost."Market Code" := "Market Code";
                        MICAServiceItemCalcCost."Client Code" := "Client Code";
                        MICAServiceItemCalcCost."Invoicing Currency" := "Invoicing Currency";
                        MICAServiceItemCalcCost."Intercompany Dimension" := "Intercompany Dimension";
                        MICAServiceItemCalcCost."Structure Dimension" := "Structure Dimension";
                        MICAServiceItemCalcCost."Net Turnover Invoiced" := "Net Turnover Invoiced";
                        MICAServiceItemCalcCost.Insert();
                    end;
                    CurrTotal += 1;
                    Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
                until MICAF336Buffer.Next() = 0;
        end;

        //Calculate % of Cost
        with MICAServiceItemCalcCost do begin
            Reset();
            SetCurrentKey("Country-of Sales", "Market Code", "Client Code", "Invoicing Currency", "Intercompany Dimension", "Structure Dimension");
            IF FindSet(false, false) then
                repeat
                    //filter current group
                    SetRange("Country-of Sales", MICAServiceItemCalcCost."Country-of Sales");
                    SetRange("Market Code", MICAServiceItemCalcCost."Market Code");
                    SetRange("Client Code", MICAServiceItemCalcCost."Client Code");
                    SetRange("Invoicing Currency", MICAServiceItemCalcCost."Invoicing Currency");
                    SetRange("Intercompany Dimension", MICAServiceItemCalcCost."Intercompany Dimension");
                    SetRange("Structure Dimension", MICAServiceItemCalcCost."Structure Dimension");
                    CalcSums("Net Turnover Invoiced");
                    TotalNetTurnoverInvoiced := MICAServiceItemCalcCost."Net Turnover Invoiced";
                    Clear(RemainCostPercent);
                    IF TotalNetTurnoverInvoiced <> 0 then begin
                        FindSet(false, false);
                        repeat
                            "% of cost" := Round(RemainCostPercent + ("Net Turnover Invoiced" / TotalNetTurnoverInvoiced) * 100, 1);
                            RemainCostPercent := (RemainCostPercent + ("Net Turnover Invoiced" / TotalNetTurnoverInvoiced) * 100) - "% of cost";
                            Modify();
                        until Next() = 0;
                    end;

                    //release filter of current group to go to next group
                    FindLast();
                    SetRange("Country-of Sales");
                    SetRange("Market Code");
                    SetRange("Client Code");
                    SetRange("Invoicing Currency");
                    SetRange("Intercompany Dimension");
                    SetRange("Structure Dimension");
                until Next() = 0;
        end;
    end;

    local procedure GetF336BufferFromValueEntry(var MICAF336Buffer: Record "MICA F336 Buffer"; var ValueEntry: Record "Value Entry")
    var
        MICAForecastCustomerCode: Record "MICA Forecast Customer Code";
        Item: Record Item;
        Customer: Record Customer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        CountryRegion: Record "Country/Region";
        MICAGroupCode: Code[20];
        MICAMarketCode: Code[2];
        MICAClientCode: Code[5];
        CurrencyCode: Code[20];
        CurrencyFactor: Decimal;
        IntercompDimCode: Code[20];
        StructureDimCode: Code[20];
    begin
        ValueEntry.FindSet();
        repeat
            Item.Get(ValueEntry."Item No.");
            if not Item."MICA Exclude from Report. Grp." then begin
                ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.");
                Customer.Get(ItemLedgerEntry."Source No.");
                IF NOT CountryRegion.GET(Customer."Country/Region Code") then
                    CountryRegion.Init();
                MICAGroupCode := CountryRegion."MICA Group Code";
                MICAMarketCode := Customer."MICA Market Code";
                if not MICAForecastCustomerCode.Get(Customer."No.", Item."Item Category Code") then
                    MICAForecastCustomerCode.Init();
                MICAClientCode := MICAForecastCustomerCode."Forecast Code";

                case ValueEntry."Document Type" of
                    ValueEntry."Document Type"::"Sales Credit Memo":
                        GetCurrencyCodeAndFactor(1, ValueEntry."Document No.", CurrencyCode, CurrencyFactor);
                    ValueEntry."Document Type"::"Sales Invoice":
                        GetCurrencyCodeAndFactor(0, ValueEntry."Document No.", CurrencyCode, CurrencyFactor);
                end;

                IntercompDimCode := GetDefaultDimValue(ValueEntry."Dimension Set ID", MICAFinancialReportingSetup."Intercompany Dimension");
                StructureDimCode := GetDefaultDimValue(ValueEntry."Dimension Set ID", MICAFinancialReportingSetup."Structure Dimension");

                if not MICAF336Buffer.Get(ValueEntry."Item No.", MICAGroupCode, MICAMarketCode, MICAClientCode, CurrencyCode, IntercompDimCode, StructureDimCode) then begin
                    MICAF336Buffer.Init();
                    MICAF336Buffer."Item No." := ValueEntry."Item No.";
                    MICAF336Buffer."Country-of Sales" := MICAGroupCode;
                    MICAF336Buffer."Market Code" := MICAMarketCode;
                    MICAF336Buffer."Client Code" := MICAClientCode;
                    MICAF336Buffer."Invoicing Currency" := CopyStr(CurrencyCode, 1, 10);
                    MICAF336Buffer."Intercompany Dimension" := IntercompDimCode;
                    MICAF336Buffer."Structure Dimension" := StructureDimCode;
                    IF Item.Type = Item.Type::Service then
                        MICAF336Buffer."Service Item" := true;

                    UpdateF336BufferFromValueEntry(MICAF336Buffer, ValueEntry, CurrencyFactor, true);
                end else
                    UpdateF336BufferFromValueEntry(MICAF336Buffer, ValueEntry, CurrencyFactor, false);
            end;
        until ValueEntry.Next() = 0;
    end;

    local procedure UpdateF336BufferFromValueEntry(var MICAF336Buffer: Record "MICA F336 Buffer"; ValueEntry: Record "Value Entry"; CurrencyFactor: Decimal; IsForInsert: Boolean)
    var
        Currency: Record Currency;
    begin
        IF NOT Currency.get(MICAF336Buffer."Invoicing Currency") then
            Currency.Init();
        MICAF336Buffer.Quantity += ValueEntry."Invoiced Quantity" * (-1);
        MICAF336Buffer."Net Turnover Invoiced" += ValueEntry."Sales Amount (Actual)";
        MICAF336Buffer."Gross Annual Turnover" += ValueEntry."Sales Amount (Actual)" - ValueEntry."Discount Amount";
        MICAF336Buffer.CRV += ValueEntry."Cost Amount (Actual)" * (-1);
        MICAF336Buffer."Net Sales" += ValueEntry."Sales Amount (Actual)";
        IF MICAF336Buffer."Invoicing Currency" = '' then
            MICAF336Buffer."Net Sales In The Inv. Currency" += ValueEntry."Sales Amount (Actual)"
        else
            MICAF336Buffer."Net Sales In The Inv. Currency" +=
                        Round(CurrencyExchangeRate.ExchangeAmtLCYToFCYOnlyFactor(ValueEntry."Sales Amount (Actual)", CurrencyFactor), Currency."Invoice Rounding Precision");
        IF IsForInsert then
            MICAF336Buffer.Insert()
        else
            MICAF336Buffer.Modify();
    end;

    local procedure GetCurrencyCodeAndFactor(DocType: Option SalesInvoice,SalesCrMemo; DocNo: Code[20]; var CurrCode: code[20]; var CurrFactor: Decimal);
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        Clear(CurrCode);
        Clear(CurrFactor);
        case DocType of
            DocType::SalesInvoice:
                begin
                    SalesInvoiceHeader.Get(DocNo);
                    CurrCode := SalesInvoiceHeader."Currency Code";
                    CurrFactor := SalesInvoiceHeader."Currency Factor";
                end;
            DocType::SalesCrMemo:
                begin
                    SalesCrMemoHeader.Get(DocNo);
                    CurrCode := SalesCrMemoHeader."Currency Code";
                    CurrFactor := SalesCrMemoHeader."Currency Factor";
                end;
        end;
    end;

    local procedure GetDefaultDimValue(DimensionSetId: Integer; Code: Code[20]): Code[20]
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        if DimensionSetEntry.Get(DimensionSetId, Code) then
            exit(DimensionSetEntry."Dimension Value Code");
    end;

    local procedure ExistValueEntries(CustomerNo: Code[20]; var ValueEntry: Record "Value Entry"; LocationFilter: Text): Boolean
    var
        ValueEntryLbl: Label '%1|''''', Comment = '%1', Locked = true;
    begin
        ValueEntry.SetCurrentKey("Source Type", "Source No.", "Item No.", "Posting Date", "Entry Type");
        ValueEntry.SetRange("Source Type", ValueEntry."Source Type"::Customer);
        ValueEntry.SetRange("Source No.", CustomerNo);
        ValueEntry.SetRange("Posting Date", StartingPeriod, EndingPeriod);
        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        if LocationFilter <> '' then
            ValueEntry.SetFilter("Location Code", StrSubstNo(ValueEntryLbl, LocationFilter))
        else
            ValueEntry.SetFilter("Location Code", '');
        //ValueEntry.SetFilter("Invoiced Quantity", '<>0');
        exit(not ValueEntry.IsEmpty());
    end;

    procedure GetLocationFilter(EntryType: Integer): Text
    var
        Location: Record Location;
        LocationFilter: Text;
    begin
        Location.SetRange("MICA Entry Type", EntryType);
        IF Location.FindSet() then
            repeat
                if LocationFilter = '' then
                    LocationFilter := Location.Code
                else
                    LocationFilter += '|' + Location.Code;
            until Location.Next() = 0;
        exit(LocationFilter);
    end;

    procedure GetDeferredCalcData(CustomerNo: Text; var MICADeferredCalcBuffer: Record "MICA Deferred Calc Buffer"; CalcDate: Date)
    var
        MICACustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
        CountryRegion: Record "Country/Region";
        StructureDim: Code[20];
        GroupCode: Code[10];
        CurrencyCode: Code[20];
        CurrencyFactor: Decimal;
        CurrTotal: Integer;
        TotalRecs: Integer;
        TotalAccrualAmount: Decimal;
    begin
        if not MICADeferredCalcBuffer.IsTemporary() then
            exit;

        MICADeferredCalcBuffer.Reset();
        with MICACustDetailAccrEntry do begin
            SetFilter("Customer No.", CustomerNo);
            SetRange("Calculation Date", CalcDate);
            SetRange("Include in Fin. Report", true);
            TotalRecs := Count();
            if FindSet() then
                repeat
                    SetRange(Code, MICACustDetailAccrEntry.Code);
                    CalcSums("Accruals Amount");
                    TotalAccrualAmount := "Accruals Amount";

                    if FindSet() then
                        repeat
                            if not CountryRegion.Get(MICACustDetailAccrEntry."Country-of Sales") then
                                CountryRegion.Init();
                            GroupCode := CopyStr(CountryRegion."MICA Group Code", 1, MaxStrLen(GroupCode));
                            case MICAFinancialReportingSetup."Structure Dimension" of
                                GeneralLedgerSetup."Global Dimension 1 Code":
                                    StructureDim := MICACustDetailAccrEntry."Global Dimension 1 Code";
                                GeneralLedgerSetup."Global Dimension 2 Code":
                                    StructureDim := MICACustDetailAccrEntry."Global Dimension 2 Code";
                            end;

                            case "Value Entry Document Type" of
                                "Value Entry Document Type"::"Sales Credit Memo":
                                    GetCurrencyCodeAndFactor(1, "Document No.", CurrencyCode, CurrencyFactor);
                                "Value Entry Document Type"::"Sales Invoice":
                                    GetCurrencyCodeAndFactor(0, "Document No.", CurrencyCode, CurrencyFactor);
                            end;

                            MICADeferredCalcBuffer.Reset();
                            if not MICADeferredCalcBuffer.Get(Code, GroupCode, "Market Code", "Forecast Code", "Intercompany Dimension", StructureDim, "Item No.", CurrencyCode) then
                                InsertDefferedCalc(MICADeferredCalcBuffer, TotalAccrualAmount, MICACustDetailAccrEntry, StructureDim, GroupCode, CurrencyCode)
                            else
                                UpdateDefferedCalc(MICADeferredCalcBuffer, MICACustDetailAccrEntry."Accruals Amount" - MICACustDetailAccrEntry."Paid AP Invoice" - MICACustDetailAccrEntry."Paid AR Credit Memo");
                            CurrTotal += 1;
                            Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
                        until Next() = 0;
                    UpdateAccrualPercentForDeferredBuffer(MICADeferredCalcBuffer, MICACustDetailAccrEntry.Code);
                    //release filter of current Accrual Group to go to next Accrual Group.
                    if FindLast() then;
                    SetRange(Code);
                until Next() = 0;
        end;
    end;

    local procedure InsertDefferedCalc(var DeferredCalcBuffer: Record "MICA Deferred Calc Buffer"; TotalAccrAmt: decimal; CustDetailAccrEntry: Record "MICA Cust. Detail. Accr. Entry"; StructureDim: Code[20]; GroupCode: Code[10]; CurrencyCode: Code[20]);
    begin
        DeferredCalcBuffer.Init();
        DeferredCalcBuffer."Accruals Code" := CustDetailAccrEntry.Code;
        DeferredCalcBuffer."Item No." := CustDetailAccrEntry."Item No.";
        DeferredCalcBuffer."Country-of Sales" := GroupCode;
        DeferredCalcBuffer."Market Code" := CustDetailAccrEntry."Market Code";
        DeferredCalcBuffer."Forecast Code" := CustDetailAccrEntry."Forecast Code";
        DeferredCalcBuffer."Intercompany Dimension" := CustDetailAccrEntry."Intercompany Dimension";
        DeferredCalcBuffer."Structure Dimension" := StructureDim;
        DeferredCalcBuffer."Total Accruals Amount" := TotalAccrAmt;
        DeferredCalcBuffer."Accruals Amount" := CustDetailAccrEntry."Accruals Amount" - CustDetailAccrEntry."Paid AP Invoice" - CustDetailAccrEntry."Paid AR Credit Memo";
        DeferredCalcBuffer."Currency Code" := CurrencyCode;
        DeferredCalcBuffer.Insert();
    end;

    local procedure UpdateDefferedCalc(var MICADeferredCalcBuffer: Record "MICA Deferred Calc Buffer"; AccrAmt: Decimal)
    begin
        MICADeferredCalcBuffer."Accruals Amount" += AccrAmt;
        MICADeferredCalcBuffer.Modify();
    end;

    local procedure TestSetup()
    begin
        MICAFinancialReportingSetup.TestField("Structure Dimension");
        MICAFinancialReportingSetup.TestField("Intercompany Dimension");
        MICAFinancialReportingSetup.TestField("F336 G/L Acc. No.2 Filter");
        MICAFinancialReportingSetup.TestField("F336 Dimension Section Filter");
        MICAFinancialReportingSetup.TestField("Deferred Group Account");
        MICAFinancialReportingSetup.TestField("Accrual Dimension Code");
    end;

    local procedure GetLastRebateCalcDate(): Date
    var
        MICACustomerAccrualEntry: Record "MICA Customer Accrual Entry";
    begin
        MICACustomerAccrualEntry.SetRange("Calculation Date", StartingPeriod, EndingPeriod);
        if MICACustomerAccrualEntry.FindLast() then
            exit(MICACustomerAccrualEntry."Calculation Date");
    end;

    procedure SetType(NewType: Option)
    begin
        Type := NewType;
    end;

    local procedure GetReversalRebateAmounts(var MICADeferredCalcBuffer: Record "MICA Deferred Calc Buffer")
    var
        GLEntry: Record "G/L Entry";
        DimensionSetEntry: Record "Dimension Set Entry";
        EntryNo: Integer;
    begin
        EntryNo := 0;

        GLEntry.SetCurrentKey("MICA Type Of Transaction");
        GLEntry.SetFilter("MICA Type Of Transaction", '%1|%2', GLEntry."MICA Type Of Transaction"::"Manual Adjustment", GLEntry."MICA Type Of Transaction"::"Rebate Reversal");
        GLEntry.SetFilter("MICA No. 2", MICAFinancialReportingSetup."Deferred Group Account");
        GLEntry.SetRange("Posting Date", StartingPeriod, EndingPeriod);
        if GLEntry.FindSet() then
            repeat
                if DimensionSetEntry.Get(GLEntry."Dimension Set ID", MICAFinancialReportingSetup."Accrual Dimension Code") then begin
                    MICADeferredCalcBuffer.SetCurrentKey("Accruals Code", "Country-of Sales", "Market Code", "Forecast Code", "Intercompany Dimension", "Structure Dimension", "Item No.");
                    MICADeferredCalcBuffer.SetRange("Accruals Code", DimensionSetEntry."Dimension Value Code");
                    if MICADeferredCalcBuffer.FindSet() then
                        repeat
                            if EntryNo <> GLEntry."Entry No." then begin
                                MICADeferredCalcBuffer.Validate("Total G/L Amount", MICADeferredCalcBuffer."Total G/L Amount" + GLEntry.Amount);
                                MICADeferredCalcBuffer.Modify();
                            end;
                        until MICADeferredCalcBuffer.Next() = 0;
                    EntryNo := GLEntry."Entry No.";
                end;
            until GLEntry.Next() = 0;
    end;

    local procedure UpdateAccrualPercentForDeferredBuffer(var DeferredCalcBuffer: Record "MICA Deferred Calc Buffer"; AccrualCode: Code[20])
    var
        RemainAccrualPercent: Decimal;
    begin
        //Remaining Accural Percent will be included for next line.
        RemainAccrualPercent := 0;

        DeferredCalcBuffer.Reset();
        DeferredCalcBuffer.SetRange("Accruals Code", AccrualCode);
        DeferredCalcBuffer.SetFilter("Total Accruals Amount", '<>0');
        IF DeferredCalcBuffer.FindSet() then
            repeat
                DeferredCalcBuffer."Accruals %" := Round((DeferredCalcBuffer."Accruals Amount" / DeferredCalcBuffer."Total Accruals Amount") * 100 + RemainAccrualPercent, 1);
                RemainAccrualPercent := ((DeferredCalcBuffer."Accruals Amount" / DeferredCalcBuffer."Total Accruals Amount") * 100 + RemainAccrualPercent) - DeferredCalcBuffer."Accruals %";
                DeferredCalcBuffer.Modify();
            until DeferredCalcBuffer.Next() = 0;
    end;

    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
}

