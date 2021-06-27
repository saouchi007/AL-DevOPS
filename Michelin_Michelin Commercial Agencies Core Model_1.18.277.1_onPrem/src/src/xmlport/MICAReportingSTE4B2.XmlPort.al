xmlport 81021 "MICA Reporting STE4B2"
{
    Caption = 'STE4B2 Export';
    Direction = Export;
    Format = VariableText;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    RecordSeparator = '<NewLine>';
    TableSeparator = '<<NewLine><NewLine>>';
    UseRequestPage = false;
    TextEncoding = MSDOS;
    schema
    {
        textelement(Root)
        {
            tableelement(Cust; Customer)
            {
                XmlName = 'Cust';
                SourceTableView = sorting("No.");

                fieldelement(CustNo; Cust."No.")
                {

                }
                textelement(CustCreditLimit)
                {

                }
                textelement(ARTotalBalance)
                {

                }
                textelement(TotalOverdue)
                {

                }
                textelement(OD)
                {

                }
                fieldelement(MarketExport; cust."MICA Market Code")
                {

                }
                textelement(TopYear)
                {

                }
                textelement(TopMonth)
                {

                }
                fieldelement(GroupRiskCode; Cust."MICA Credit Classification")
                {

                }
                trigger OnPreXmlItem()
                var
                    TempKeyAllocation: Record "MICA STE4 Key Allocation" temporary;
                    TextNoData_Err: Label 'No data to export.';
                begin
                    Cust.Setfilter("MICA Party Ownership", '%1|%2', cust."MICA Party Ownership"::"Non Group", Cust."MICA Party Ownership"::"Group Network");
                    TotalRecs := Cust.COUNT();
                    CurrTotal := 0;
                    IF Cust.count() = 0 then
                        MESSAGE(TextNoData_Err);
                    //StartingPeriodTemp := DMY2Date(1, 1, Date2DMY(EndingPeriod, 3));
                    PrepareDataSTE4B1Temp(TempKeyAllocation);
                end;

                trigger OnAfterGetRecord()
                var
                    STE4Extraction: record "MICA STE4 Extraction";
                    TotalAmtWithDays: Decimal;
                    TotalAmt: Decimal;
                    ResultAmt: Decimal;
                begin
                    InitVar();

                    STE4Extraction.SetCurrentKey("Customer No.", "Document Type", "Posting Date", Open, "Due Date", UserId);
                    STE4Extraction.SetRange("Customer No.", Cust."No.");
                    STE4Extraction.SetRange(UserId, Database.UserId());
                    if not STE4Extraction.isempty() THEN BEGIN
                        //* Customer.Credit Limit
                        CustCreditLimit := FORMAT(Cust."Credit Limit (LCY)", 0, '<Sign><Integer>');

                        //* ARTotal Balance
                        STE4Extraction.CalcSums("Remaining Amount (LCY)");
                        ARTotalBalance := FORMAT(STE4Extraction."Remaining Amount (LCY)", 0, '<Sign><Integer>');

                        //* Total Overdue
                        STE4Extraction.Setfilter("Due Date", '..%1', EndingPeriod);
                        STE4Extraction.CalcSums("Remaining Amount (LCY)");
                        TotalOverdue := FORMAT(STE4Extraction."Remaining Amount (LCY)", 0, '<Sign><Integer>');

                        //* OD>1 Month
                        STE4Extraction.Setfilter("Due Date", '..%1', CALCDATE('<-30D>', EndingPeriod));
                        STE4Extraction.CalcSums("Remaining Amount (LCY)");
                        OD := FORMAT(STE4Extraction."Remaining Amount (LCY)", 0, '<Sign><Integer>');

                        //* Top Granted Year to Date
                        TotalAmtWithDays := 0;
                        TotalAmt := 0;
                        ResultAmt := 0;
                        TempMICASTE4Extraction.SetCurrentKey("Customer No.", "Document Type", "Posting Date", Open, "Due Date", UserId);
                        TempMICASTE4Extraction.SetRange("Customer No.", Cust."No.");
                        TempMICASTE4Extraction.SetRange(UserId, Database.UserId());
                        TempMICASTE4Extraction.SetRange("Due Date");
                        TempMICASTE4Extraction.SetRange("Document Type", TempMICASTE4Extraction."Document Type"::Invoice);
                        TempMICASTE4Extraction.SetRange("Posting Date", DMY2Date(1, 1, Date2DMY(EndingPeriod, 3)), EndingPeriod);
                        if TempMICASTE4Extraction.FindSet() then
                            repeat
                                TotalAmtWithDays += TempMICASTE4Extraction."Initial Amount (LCY)" * TempMICASTE4Extraction.NDCA;
                                TotalAmt += TempMICASTE4Extraction."Initial Amount (LCY)";
                            until TempMICASTE4Extraction.Next() = 0;
                        IF (TotalAmtWithDays <> 0) AND (TotalAmt <> 0) then
                            ResultAmt := (TotalAmtWithDays / TotalAmt) * 1000;
                        TopYear := Format(ResultAmt, 0, '<Sign><Integer>');

                        //* Top Granted Month
                        TotalAmtWithDays := 0;
                        TotalAmt := 0;
                        ResultAmt := 0;
                        STE4Extraction.SetRange("Due Date");
                        STE4Extraction.SetRange("Document Type", STE4Extraction."Document Type"::Invoice);
                        STE4Extraction.SetRange("Posting Date", StartingPeriod, EndingPeriod);
                        if STE4Extraction.FindSet() then
                            repeat
                                TotalAmtWithDays += STE4Extraction."Initial Amount (LCY)" * STE4Extraction.NDCA;
                                TotalAmt += STE4Extraction."Initial Amount (LCY)";
                            until STE4Extraction.Next() = 0;
                        IF (TotalAmtWithDays <> 0) AND (TotalAmt <> 0) then
                            ResultAmt := (TotalAmtWithDays / TotalAmt) * 1000;
                        TopMonth := Format(ResultAmt, 0, '<Sign><Integer>');
                    end else
                        currXMLport.Skip();

                    CurrTotal += 1;

                    Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
                end;
            }
        }
    }

    local procedure PrepareDataSTE4B1Temp(MICASTE4KeyAllocation: Record "MICA STE4 Key Allocation")
    var
        EntryType: Option All,Open;
        DialPrepareDataLbl: Label 'Prepare data %1';
    begin
        //Step 0 - Delete Key Allocation table & Reporting Buffer

        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, '0/19'));
        Dialog.UPDATE(2, 0);
        InitKeyAllocation(MICASTE4KeyAllocation);

        //Step 1 - Key Allocation Calculation (method 2)
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, '1/19'));
        Dialog.UPDATE(2, 0);
        MICAExportSTE4.UpdateCustomerKeyAllocation(MICASTE4KeyAllocation);

        //Step 2 - Key Allocation Calculation (method 3)
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, '2/19'));
        Dialog.UPDATE(2, 0);
        MICAExportSTE4.UpdateGlobalKeyAllocation(MICASTE4KeyAllocation);

        //Step 3 - Fill STE4 Extraction table from the beginning
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, '3/19'));
        Dialog.UPDATE(2, 0);
        InitSTE4Extraction(EntryType::Open);

        //Step 4 - Fill STE4 Extraction table with All Cust. Ledger Entries for the period
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, '4/19'));
        Dialog.UPDATE(2, 0);
        InitSTE4Extraction(EntryType::All);
    end;

    procedure InitKeyAllocation(var MICASTE4KeyAllocation: Record "MICA STE4 Key Allocation")
    var
        TempGlobalMICASTE4KeyAllocation: Record "MICA STE4 Key Allocation" temporary;
        DimensionValue: Record "Dimension Value";
        QueryMICASTE4KeyAllocation: Query "MICA STE4 Key Allocation";
        myCustNo: Code[20];
        TotalAmtByCust: Decimal;
        TotalAmtByLB: Decimal;
        TotalAmtByGlobal: Decimal;
    begin
        QueryMICASTE4KeyAllocation.SetRange(PostingDate, CALCDATE('<-12M>', EndingPeriod), EndingPeriod);
        QueryMICASTE4KeyAllocation.SetFilter(GlobalDimension2Code, '<>%1', '');
        QueryMICASTE4KeyAllocation.SetFilter(SalesAmActualSum, '<>0');
        QueryMICASTE4KeyAllocation.Open();
        while QueryMICASTE4KeyAllocation.Read() do begin
            DimensionValue.GET(MICAFinancialReportingSetup."LB Dimension", QueryMICASTE4KeyAllocation.GlobalDimension2Code);
            DimensionValue.TestField("MICA Michelin Code");
            myCustNo := QueryMICASTE4KeyAllocation.SourceNo;

            //1.1 Init For Customer Key Allocation
            IF MICASTE4KeyAllocation.GET(MICASTE4KeyAllocation.Type::Customer,
                                 myCustNo,
                                 DimensionValue."MICA Michelin Code",
                                 Database.UserId())
            then begin
                MICASTE4KeyAllocation."LB Amount" += QueryMICASTE4KeyAllocation.SalesAmActualSum;
                MICASTE4KeyAllocation.Modify();
            end else begin
                MICASTE4KeyAllocation.Init();
                MICASTE4KeyAllocation.Type := MICASTE4KeyAllocation.Type::Customer;
                MICASTE4KeyAllocation."Customer No." := myCustNo;
                MICASTE4KeyAllocation."LB Code" := DimensionValue."MICA Michelin Code";
                MICASTE4KeyAllocation.UserId := Format(Database.UserId());
                MICASTE4KeyAllocation."Date Of Calculation" := EndingPeriod;
                MICASTE4KeyAllocation."LB Amount" := QueryMICASTE4KeyAllocation.SalesAmActualSum;
                MICASTE4KeyAllocation.Insert();
            end;
        end;

        //1.2 Calculate Total Amount for Customer
        MICASTE4KeyAllocation.Reset();
        MICASTE4KeyAllocation.SetCurrentKey(Type, "Customer No.", UserId);
        MICASTE4KeyAllocation.SetRange(Type, MICASTE4KeyAllocation.Type::Customer);
        MICASTE4KeyAllocation.SetRange(UserId, Database.UserId());
        if MICASTE4KeyAllocation.FindSet() then
            repeat
                //Set filter for current Customer Group
                MICASTE4KeyAllocation.SetRange("Customer No.", MICASTE4KeyAllocation."Customer No.");

                MICASTE4KeyAllocation.CalcSums("LB Amount");
                TotalAmtByCust := MICASTE4KeyAllocation."LB Amount";
                MICASTE4KeyAllocation.ModifyAll("Total Amount", TotalAmtByCust);

                //release current group of Customer
                MICASTE4KeyAllocation.FindLast();
                MICASTE4KeyAllocation.SetRange("Customer No.");
            until MICASTE4KeyAllocation.Next() = 0;

        //2.1 Init For Global Key Allocation
        MICASTE4KeyAllocation.Reset();
        MICASTE4KeyAllocation.SetCurrentKey("Type", "LB Code", UserId);
        MICASTE4KeyAllocation.SetRange(Type, MICASTE4KeyAllocation.Type::Customer);
        MICASTE4KeyAllocation.SetRange(UserId, Database.UserId());
        IF MICASTE4KeyAllocation.FindSet() then
            repeat
                //Set filter for current LB Group
                MICASTE4KeyAllocation.SetRange("LB Code", MICASTE4KeyAllocation."LB Code");

                MICASTE4KeyAllocation.CalcSums("LB Amount");
                TotalAmtByLB := MICASTE4KeyAllocation."LB Amount";
                MICASTE4KeyAllocation.FindFirst();

                //Insert for Global data
                TempGlobalMICASTE4KeyAllocation.Init();
                TempGlobalMICASTE4KeyAllocation.Type := TempGlobalMICASTE4KeyAllocation.Type::Global;
                TempGlobalMICASTE4KeyAllocation."Customer No." := '';
                TempGlobalMICASTE4KeyAllocation."LB Code" := MICASTE4KeyAllocation."LB Code";
                TempGlobalMICASTE4KeyAllocation.UserId := Format(Database.UserId());
                TempGlobalMICASTE4KeyAllocation."Date Of Calculation" := EndingPeriod;
                TempGlobalMICASTE4KeyAllocation."LB Amount" := TotalAmtByLB;
                TempGlobalMICASTE4KeyAllocation.Insert();

                //release current group of LB
                MICASTE4KeyAllocation.FindLast();
                MICASTE4KeyAllocation.SetRange("LB Code");
            until MICASTE4KeyAllocation.Next() = 0;

        //2.2 Calculate Total Amount for Global
        TempGlobalMICASTE4KeyAllocation.Reset();
        TempGlobalMICASTE4KeyAllocation.SetCurrentKey(Type, "Customer No.", UserId);
        TempGlobalMICASTE4KeyAllocation.SetRange(Type, MICASTE4KeyAllocation.Type::Global);
        TempGlobalMICASTE4KeyAllocation.SetRange(UserId, Database.UserId());
        TempGlobalMICASTE4KeyAllocation.CalcSums("LB Amount");
        TotalAmtByGlobal := TempGlobalMICASTE4KeyAllocation."LB Amount";
        TempGlobalMICASTE4KeyAllocation.ModifyAll("Total Amount", TotalAmtByGlobal);
    end;

    local Procedure InitSTE4Extraction(EntryType: Option All,Open)
    var
        MICASTE4KeyAllocation: Record "MICA STE4 Key Allocation";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        IsDone: Boolean;
        Customer_Err: label 'Customer does not exist.';
    begin
        CustLedgerEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
        IF EntryType = EntryType::Open then
            CustLedgerEntry.SETRANGE("Posting Date", 0D, calcdate('<-1D>', StartingPeriod))
        else
            CustLedgerEntry.SETRANGE("Posting Date", StartingPeriod, EndingPeriod);
        IF CustLedgerEntry.FINDSET() then
            repeat
                IF CustLedgerEntry."Customer No." <> Customer."No." then
                    IF NOT Customer.GET(CustLedgerEntry."Customer No.") THEN
                        ERROR(Customer_Err);

                IF (Customer."MICA Party Ownership" IN [Customer."MICA Party Ownership"::"Group Network", Customer."MICA Party Ownership"::"Non Group"]) then begin
                    CustLedgerEntry.TestField("Due Date");
                    IsDone := false;
                    IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice then
                        IsDone := InitSTE4ExtractionMethod1ForInv(CustLedgerEntry, Customer)
                    else
                        IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::"Credit Memo" then
                            IsDone := InitSTE4ExtractionMethod1ForCrM(CustLedgerEntry, Customer);

                    IF NOT IsDone then
                        if ExistCustKeyAllocation(Customer."No.", MICASTE4KeyAllocation) then
                            InitSTE4ExtractionWithKeyAllocation(CustLedgerEntry, Customer, MICASTE4KeyAllocation.Type::Customer, MICASTE4KeyAllocation)
                        else
                            InitSTE4ExtractionWithKeyAllocation(CustLedgerEntry, Customer, MICASTE4KeyAllocation.Type::Global, MICASTE4KeyAllocation);
                end;
            until CustLedgerEntry.NEXT() = 0;
    end;

    local procedure ExistCustKeyAllocation(CustNo: Code[20]; MICASTE4KeyAllocation: record "MICA STE4 Key Allocation"): Boolean
    begin
        with MICASTE4KeyAllocation do begin
            SetRange(Type, MICASTE4KeyAllocation.Type::Customer);
            SetRange("Customer No.", CustNo);
            SetRange(UserId, database.UserId());
            SetFilter("% Allocation", '<>0');
            exit(NOT IsEmpty());
        end;
    end;

    local procedure InitSTE4ExtractionMethod1ForCrM(CustLedgerEntry: Record "Cust. Ledger Entry"; Customer: Record Customer): Boolean
    var
        SalesCrMemoLine: record "Sales Cr.Memo Line";
        TempSalesCrMemoLine: Record "Sales Cr.Memo Line" temporary;
        DimensionValue: record "Dimension value";
        Currency: Record Currency;
        NextLineNo: Integer;
        TotalAmount: Decimal;
        RemainPercent: Decimal;
        RemainAmt1: Decimal;
        RemainAmt2: Decimal;
    begin
        RemainPercent := 0;
        RemainAmt1 := 0;
        RemainAmt2 := 0;
        SalesCrMemoLine.setrange("Document No.", CustLedgerEntry."Document No.");
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.type::Item);
        SalesCrMemoLine.SetFilter("Shortcut Dimension 2 Code", '<>%1', '');
        IF NOT SalesCrMemoLine.FindSet() then
            exit(false);

        //Init Key Allocation for this document
        repeat
            DimensionValue.get(MICAFinancialReportingSetup."LB Dimension", SalesCrMemoLine."Shortcut Dimension 2 Code");
            DimensionValue.TestField("MICA Michelin Code");
            TotalAmount += SalesCrMemoLine."Line Amount";

            TempSalesCrMemoLine.Reset();
            TempSalesCrMemoLine.SetRange("Shortcut Dimension 2 Code", DimensionValue."MICA Michelin Code");
            IF TempSalesCrMemoLine.FindFirst() then begin
                TempSalesCrMemoLine."Line Amount" += SalesCrMemoLine."Line Amount";
                TempSalesCrMemoLine.Modify();
            end else begin
                NextLineNo += 1;
                TempSalesCrMemoLine.Init();
                TempSalesCrMemoLine."Document No." := SalesCrMemoLine."Document No.";
                TempSalesCrMemoLine."Line No." := NextLineNo;
                TempSalesCrMemoLine."Shortcut Dimension 2 Code" := DimensionValue."MICA Michelin Code";
                TempSalesCrMemoLine."Line Amount" := SalesCrMemoLine."Line Amount";
                TempSalesCrMemoLine.Insert();
            end;
        until SalesCrMemoLine.Next() = 0;

        // Calculate % Allocation
        TempSalesCrMemoLine.Reset();
        TempSalesCrMemoLine.SetFilter("Line Amount", '<>0');
        IF (NOT TempSalesCrMemoLine.FindSet()) OR (TotalAmount = 0) then
            exit(false);

        //Use Amount fields to store % Allocation by LB
        repeat
            TempSalesCrMemoLine.Amount := Round(RemainPercent + (TempSalesCrMemoLine."Line Amount" / TotalAmount * 100), 1);
            RemainPercent := (RemainPercent + (TempSalesCrMemoLine."Line Amount" / TotalAmount * 100)) - TempSalesCrMemoLine.Amount;
            TempSalesCrMemoLine.Modify();
        until TempSalesCrMemoLine.Next() = 0;

        TempSalesCrMemoLine.Reset();
        TempSalesCrMemoLine.SetFilter(Amount, '<>0');
        if NOT TempSalesCrMemoLine.FindSet() then
            EXIT(false);

        //Extract this document
        Currency.Init();
        CustLedgerEntry.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
        repeat
            TempMICASTE4Extraction.Init();
            TempMICASTE4Extraction."Document Type" := CustLedgerEntry."Document Type".AsInteger();
            TempMICASTE4Extraction."Document No." := CustLedgerEntry."Document No.";
            TempMICASTE4Extraction."Customer No." := CustLedgerEntry."Customer No.";
            TempMICASTE4Extraction."Posting Date" := CustLedgerEntry."Posting Date";
            TempMICASTE4Extraction."Due Date" := CustLedgerEntry."Due Date";
            TempMICASTE4Extraction.LB := TempSalesCrMemoLine."Shortcut Dimension 2 Code";

            TempMICASTE4Extraction."Initial Amount (LCY)" := Round(RemainAmt1 + CustLedgerEntry."Amount (LCY)" * TempSalesCrMemoLine.Amount / 100, Currency."Amount Rounding Precision");
            RemainAmt1 := (RemainAmt1 + CustLedgerEntry."Amount (LCY)" * TempSalesCrMemoLine.Amount / 100) - TempMICASTE4Extraction."Initial Amount (LCY)";

            TempMICASTE4Extraction."Remaining Amount (LCY)" := Round(RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * TempSalesCrMemoLine.Amount / 100, Currency."Amount Rounding Precision");
            RemainAmt2 := (RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * TempSalesCrMemoLine.Amount / 100) - TempMICASTE4Extraction."Remaining Amount (LCY)";

            TempMICASTE4Extraction."Customer Posting Group" := CustLedgerEntry."Customer Posting Group";
            TempMICASTE4Extraction.Open := CustLedgerEntry.Open;
            TempMICASTE4Extraction.NDCA := CustLedgerEntry."Due Date" - CustLedgerEntry."Posting Date";
            TempMICASTE4Extraction."Party Ownership" := customer."MICA Party Ownership";
            TempMICASTE4Extraction."Market Code" := Customer."MICA Market Code";
            TempMICASTE4Extraction.userid := COPYSTR(Database.UserId(), 1, 50);
            TempMICASTE4Extraction."Origin Entry No." := CustLedgerEntry."Entry No.";
            TempMICASTE4Extraction.INSERT()
        until TempSalesCrMemoLine.Next() = 0;
        Exit(true);
    end;

    local procedure InitSTE4ExtractionMethod1ForInv(CustLedgerEntry: Record "Cust. Ledger Entry"; Customer: Record Customer): Boolean
    var
        SalesInvoiceLine: record "Sales Invoice Line";
        TempSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        DimensionValue: record "Dimension value";
        Currency: Record Currency;
        NextLineNo: Integer;
        TotalAmount: Decimal;
        RemainPercent: Decimal;
        RemainAmt1: Decimal;
        RemainAmt2: Decimal;
    begin
        RemainPercent := 0;
        RemainAmt1 := 0;
        RemainAmt2 := 0;
        SalesInvoiceLine.setrange("Document No.", CustLedgerEntry."Document No.");
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.type::Item);
        SalesInvoiceLine.SetFilter("Shortcut Dimension 2 Code", '<>%1', '');
        IF NOT SalesInvoiceLine.FindSet() then
            exit(false);

        //Init Key Allocation for this document
        repeat
            DimensionValue.get(MICAFinancialReportingSetup."LB Dimension", SalesInvoiceLine."Shortcut Dimension 2 Code");
            DimensionValue.TestField("MICA Michelin Code");
            TotalAmount += SalesInvoiceLine."Line Amount";

            TempSalesInvoiceLine.Reset();
            TempSalesInvoiceLine.SetRange("Shortcut Dimension 2 Code", DimensionValue."MICA Michelin Code");
            IF TempSalesInvoiceLine.FindFirst() then begin
                TempSalesInvoiceLine."Line Amount" += SalesInvoiceLine."Line Amount";
                TempSalesInvoiceLine.Modify();
            end else begin
                NextLineNo += 1;
                TempSalesInvoiceLine.Init();
                TempSalesInvoiceLine."Document No." := SalesInvoiceLine."Document No.";
                TempSalesInvoiceLine."Line No." := NextLineNo;
                TempSalesInvoiceLine."Shortcut Dimension 2 Code" := DimensionValue."MICA Michelin Code";
                TempSalesInvoiceLine."Line Amount" := SalesInvoiceLine."Line Amount";
                TempSalesInvoiceLine.Insert();
            end;
        until SalesInvoiceLine.Next() = 0;

        // Calculate % Allocation
        TempSalesInvoiceLine.Reset();
        TempSalesInvoiceLine.SetFilter("Line Amount", '<>0');
        IF (NOT TempSalesInvoiceLine.FindSet()) OR (TotalAmount = 0) then
            exit(false);

        //Use Amount fields to store % Allocation by LB
        repeat
            TempSalesInvoiceLine.Amount := Round(RemainPercent + (TempSalesInvoiceLine."Line Amount" / TotalAmount * 100), 1);
            RemainPercent := (RemainPercent + (TempSalesInvoiceLine."Line Amount" / TotalAmount * 100)) - TempSalesInvoiceLine.Amount;
            TempSalesInvoiceLine.Modify();
        until TempSalesInvoiceLine.Next() = 0;

        TempSalesInvoiceLine.Reset();
        TempSalesInvoiceLine.SetFilter(Amount, '<>0');
        if NOT TempSalesInvoiceLine.FindSet() then
            EXIT(false);

        //Extract this document
        Currency.Init();
        CustLedgerEntry.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
        repeat
            TempMICASTE4Extraction.Init();
            TempMICASTE4Extraction."Document Type" := CustLedgerEntry."Document Type".AsInteger();
            TempMICASTE4Extraction."Document No." := CustLedgerEntry."Document No.";
            TempMICASTE4Extraction."Customer No." := CustLedgerEntry."Customer No.";
            TempMICASTE4Extraction."Posting Date" := CustLedgerEntry."Posting Date";
            TempMICASTE4Extraction."Due Date" := CustLedgerEntry."Due Date";
            TempMICASTE4Extraction.LB := TempSalesInvoiceLine."Shortcut Dimension 2 Code";

            TempMICASTE4Extraction."Initial Amount (LCY)" := Round(RemainAmt1 + CustLedgerEntry."Amount (LCY)" * TempSalesInvoiceLine.Amount / 100, Currency."Amount Rounding Precision");
            RemainAmt1 := (RemainAmt1 + CustLedgerEntry."Amount (LCY)" * TempSalesInvoiceLine.Amount / 100) - TempMICASTE4Extraction."Initial Amount (LCY)";

            TempMICASTE4Extraction."Remaining Amount (LCY)" := Round(RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * TempSalesInvoiceLine.Amount / 100, Currency."Amount Rounding Precision");
            RemainAmt2 := (RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * TempSalesInvoiceLine.Amount / 100) - TempMICASTE4Extraction."Remaining Amount (LCY)";

            TempMICASTE4Extraction."Customer Posting Group" := CustLedgerEntry."Customer Posting Group";
            TempMICASTE4Extraction.Open := CustLedgerEntry.Open;
            TempMICASTE4Extraction.NDCA := CustLedgerEntry."Due Date" - CustLedgerEntry."Posting Date";
            TempMICASTE4Extraction."Party Ownership" := customer."MICA Party Ownership";
            TempMICASTE4Extraction."Market Code" := Customer."MICA Market Code";
            TempMICASTE4Extraction.userid := COPYSTR(Database.UserId(), 1, 50);
            TempMICASTE4Extraction."Origin Entry No." := CustLedgerEntry."Entry No.";
            TempMICASTE4Extraction.INSERT();
        until TempSalesInvoiceLine.Next() = 0;
        Exit(true);
    end;

    local procedure InitSTE4ExtractionWithKeyAllocation(CustLedgerEntry: Record "Cust. Ledger Entry"; Customer: Record Customer; AllocationType: Option Global,Customer; CustMICASTE4KeyAllocation: record "MICA STE4 Key Allocation")
    var
        Currency: Record Currency;
        RemainAmt1: Decimal;
        RemainAmt2: Decimal;
    begin
        RemainAmt1 := 0;
        RemainAmt2 := 0;
        CustMICASTE4KeyAllocation.setrange(Type, AllocationType);
        IF AllocationType = AllocationType::Customer then
            CustMICASTE4KeyAllocation.SetRange("Customer No.", CustLedgerEntry."Customer No.");
        CustMICASTE4KeyAllocation.SetRange(UserId, Database.UserId());
        if CustMICASTE4KeyAllocation.findset() then begin
            Currency.Init();
            CustLedgerEntry.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
            repeat
                TempMICASTE4Extraction.Init();
                TempMICASTE4Extraction."Document Type" := CustLedgerEntry."Document Type".AsInteger();
                TempMICASTE4Extraction."Document No." := CustLedgerEntry."Document No.";
                TempMICASTE4Extraction."Customer No." := CustLedgerEntry."Customer No.";
                TempMICASTE4Extraction."Posting Date" := CustLedgerEntry."Posting Date";
                TempMICASTE4Extraction."Due Date" := CustLedgerEntry."Due Date";
                TempMICASTE4Extraction.LB := CustMICASTE4KeyAllocation."LB Code";

                TempMICASTE4Extraction."Initial Amount (LCY)" := ROUND(RemainAmt1 + CustLedgerEntry."Amount (LCY)" * CustMICASTE4KeyAllocation."% Allocation" / 100, Currency."Amount Rounding Precision");
                RemainAmt1 := (RemainAmt1 + CustLedgerEntry."Amount (LCY)" * CustMICASTE4KeyAllocation."% Allocation" / 100) - TempMICASTE4Extraction."Initial Amount (LCY)";

                TempMICASTE4Extraction."Remaining Amount (LCY)" := ROUND(RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * CustMICASTE4KeyAllocation."% Allocation" / 100, Currency."Amount Rounding Precision");
                RemainAmt2 := (RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * CustMICASTE4KeyAllocation."% Allocation" / 100) - TempMICASTE4Extraction."Remaining Amount (LCY)";

                TempMICASTE4Extraction."Customer Posting Group" := CustLedgerEntry."Customer Posting Group";
                TempMICASTE4Extraction.Open := CustLedgerEntry.Open;
                TempMICASTE4Extraction.NDCA := CustLedgerEntry."Due Date" - CustLedgerEntry."Posting Date";
                TempMICASTE4Extraction."Party Ownership" := customer."MICA Party Ownership";
                TempMICASTE4Extraction."Market Code" := Customer."MICA Market Code";
                TempMICASTE4Extraction.userid := COPYSTR(Database.UserId(), 1, 50);
                TempMICASTE4Extraction."Origin Entry No." := CustLedgerEntry."Entry No.";
                TempMICASTE4Extraction.Insert();
            until CustMICASTE4KeyAllocation.Next() = 0;
        end;
    end;

    procedure InitPeriod(NewPeriod: date)
    var
        IntYear: Code[4];
        IntMonth: code[2];
        PeriodLbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        EVALUATE(IntYear, FORMAT(Date2DMY(NewPeriod, 3)));
        EVALUATE(IntMonth, FORMAT(Date2DMY(NewPeriod, 2)));
        if StrLen(IntMonth) < 2 then
            IntMonth := COPYSTR(InsStr(IntMonth, '0', 1), 1, 2);
        Period := COPYSTR(STRSUBSTNO(PeriodLbl, IntYear, IntMonth), 1, 6);
    end;

    procedure InitVar()
    begin
        ARTotalBalance := '';
        TotalOverdue := '';
        OD := '';
        TopMonth := '';
        TopYear := '';
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        MICAReportingBuffer: Record "MICA Reporting Buffer";
        TempMICASTE4Extraction: record "MICA STE4 Extraction" temporary;
        MICAExportSTE4: Page "MICA Export STE4";
        Period: Code[6];
        CurrTotal: Integer;
        TotalRecs: Integer;
        Dialog: Dialog;
        StartingPeriod: Date;
        EndingPeriod: Date;

    trigger OnPreXmlPort()
    var
        DialPhase_Msg: Label 'Phase #1############### \';
        DialProgr_Msg: Label 'Progress @2@@@@@@@@@@';
        DialExportData_Msg: Label 'Export data';
    begin
        StartingPeriod := 0D;
        EndingPeriod := 0D;
        MICAReportingBuffer.CheckPeriodFormat(Period, StartingPeriod, EndingPeriod);

        MICAFinancialReportingSetup.GET();
        GeneralLedgerSetup.GET();

        Dialog.OPEN(DialPhase_Msg + DialProgr_Msg);
        Dialog.UPDATE(1, DialExportData_Msg);

        currXMLport.FILENAME := 'STE4B2_' + MICAFinancialReportingSetup."Company Code" + '_' + Period + '.csv';
    end;

    trigger OnPostXmlPort()
    begin
        Dialog.close();
    end;
}