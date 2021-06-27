page 81020 "MICA Export STE4"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    DataCaptionExpression = '';
    SourceTable = "MICA Reporting Buffer";
    Caption = 'Export STE4';

    layout
    {
        area(Content)
        {
            group("Option")
            {
                field(Period; PeriodValue)
                {
                    ApplicationArea = All;
                    Caption = 'Period';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExportSTE4B1)
            {
                ApplicationArea = All;
                Caption = 'Export STE4B1';
                Image = ExportFile;
                PromotedCategory = Process;
                PromotedOnly = true;
                Promoted = true;

                trigger OnAction()
                var
                    ExportSTE4B1: XmlPort "MICA Reporting STE4B1";
                    DialPhase_Msg: Label 'Phase #1############### \';
                    DialProgr_Msg: Label 'Progress @2@@@@@@@@@@';
                begin
                    CheckFinReportingSetup();
                    StartingPeriod := 0D;
                    EndingPeriod := 0D;

                    Dialog.OPEN(DialPhase_Msg + DialProgr_Msg);
                    InitPeriod2(PeriodValue);
                    ExportSTE4B1.InitPeriod(PeriodValue);

                    MICAReportingBuffer.CheckPeriodFormat(Period2, StartingPeriod, EndingPeriod);

                    PrepareDataSTE4B1();
                    ExportSTE4B1.Run();
                end;
            }
            action(ExportSTE4B2)
            {
                ApplicationArea = All;
                Caption = 'Export STE4B2';
                Image = ExportFile;
                PromotedCategory = Process;
                PromotedOnly = true;
                Promoted = true;

                trigger OnAction()
                var
                    STE4Extraction: Record "MICA STE4 Extraction";
                    ExportSTE4B2: XmlPort "MICA Reporting STE4B2";
                    ExtractionErr_Msg: Label 'STE4B1 must be exported first.';
                begin
                    STE4Extraction.SETRANGE(userid, COPYSTR(Database.UserId(), 1, 50));
                    IF STE4Extraction.IsEmpty() then
                        ERROR(ExtractionErr_Msg);
                    ExportSTE4B2.InitPeriod(PeriodValue);
                    ExportSTE4B2.Run();
                end;
            }
            action(DeleteExtractionData)
            {
                ApplicationArea = All;
                Caption = 'Delete Extraction Data';
                Image = RemoveLine;
                trigger OnAction()
                var
                    MICAReportingBuf: Record "MICA Reporting Buffer";
                    ExtractionDataDeletedMsg: Label 'Extraction Data deleted';
                begin
                    MICAReportingBuf.DeleteAll();
                    Message(ExtractionDataDeletedMsg);
                end;
            }
        }
        area(Navigation)
        {
            action(STE4KeyAllocationAction)
            {
                Caption = 'Key Allocation';
                ApplicationArea = all;
                Image = Allocations;
                RunObject = page "MICA STE4 Key Allocation";
            }
            action(STE4ExtractionAction)
            {
                Caption = 'STE4 Extraction';
                ApplicationArea = all;
                Image = CompleteLine;
                RunObject = page "MICA STE4 Extraction";
            }
        }
    }
    trigger OnClosePage()
    begin
        DeleteReportingBuffer();
        DeleteKeyAllocation();
        DeleteSTE4Extraction();
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        MICAReportingBuffer: Record "MICA Reporting Buffer";
        Period2: Code[6];
        PeriodValue: date;
        StartingPeriod: Date;
        EndingPeriod: Date;
        Dialog: Dialog;

    procedure InitPeriod2(NewPeriod: date)
    var
        IntYear: Code[4];
        IntMonth: code[2];
        Period2Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        EVALUATE(IntYear, FORMAT(Date2DMY(NewPeriod, 3)));
        EVALUATE(IntMonth, FORMAT(Date2DMY(NewPeriod, 2)));
        if StrLen(IntMonth) < 2 then
            IntMonth := COPYSTR(InsStr(IntMonth, '0', 1), 1, 2);
        Period2 := COPYSTR(STRSUBSTNO(Period2Lbl, IntYear, IntMonth), 1, 6);
    end;

    local procedure CheckFinReportingSetup()
    begin
        MICAFinancialReportingSetup.GET();
        MICAFinancialReportingSetup.TESTFIELD("Company Code");
        MICAFinancialReportingSetup.TestField("LB Dimension");
        MICAFinancialReportingSetup.TestField("STE4 Posting Group Filter");
        MICAFinancialReportingSetup.TestField("STE4 AR Pst. Group Filter");
        MICAFinancialReportingSetup.TestField("STE4 PROV Filter");
        MICAFinancialReportingSetup.TestField("STE4 Add LOSSES Filter");
        MICAFinancialReportingSetup.TestField("STE4 Sub LOSSES Filter");
        MICAFinancialReportingSetup.TestField("STE4 LOANS Filter");
        MICAFinancialReportingSetup.TestField("STE4 Region Code");
    end;

    local procedure PrepareDataSTE4B1()
    var
        MICASTE4KeyAllocation: Record "MICA STE4 Key Allocation";
        CustCrindicatorOpt: option TOPMONTH,NYDUE,ODM1LESS,ODM1M2,ODM3M4,ODM5,ODM6PLUS,ODGROSS,TOTALINV,NDEB0,LOANS,PROV,LOSSES,ARRES,ODRES,AR;
        DialPrepareDataLbl: Label 'Prepare data %1';
        LastEntryNo: Integer;
    begin
        //Step 0 - Delete Key Allocation table & Reporting Buffer
        DeleteReportingBuffer();
        DeleteKeyAllocation();
        DeleteSTE4Extraction();
        LastEntryNo := 0;

        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, '0/20'));
        Dialog.UPDATE(2, 0);
        InitKeyAllocation(MICASTE4KeyAllocation);

        //Step 1 - Key Allocation Calculation (method 2)
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, '1/20'));
        Dialog.UPDATE(2, 0);
        UpdateCustomerKeyAllocation(MICASTE4KeyAllocation);

        //Step 2 - Key Allocation Calculation (method 3)
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, '2/20'));
        Dialog.UPDATE(2, 0);
        UpdateGlobalKeyAllocation(MICASTE4KeyAllocation);

        //Step 4 - Fill STE4 Extraction table with All Cust. Ledger Entries for the period
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, '4/20'));
        Dialog.UPDATE(2, 0);
        InitSTE4Extraction();

        //* Step 5 -  Prepare Export per Indicator        
        //TOPMONTH
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::TOPMONTH) + '5/20'));
        Dialog.UPDATE(2, 0);
        TopMonth(LastEntryNo);

        //NYDUE
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::NYDUE) + '6/20'));
        Dialog.UPDATE(2, 0);
        Due(CustCrIndicatorOpt::NYDUE, LastEntryNo);

        //ODM1LESS
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::ODM1LESS) + '7/20'));
        Dialog.UPDATE(2, 0);
        DUE(CustCrIndicatorOpt::ODM1LESS, LastEntryNo);

        //ODM1M2
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::ODM1M2) + '8/20'));
        Dialog.UPDATE(2, 0);
        DUE(CustCrIndicatorOpt::ODM1M2, LastEntryNo);

        //ODM3M4
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::ODM3M4) + '9/20'));
        Dialog.UPDATE(2, 0);
        DUE(CustCrIndicatorOpt::ODM3M4, LastEntryNo);

        //ODM5
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::ODM5) + '10/20'));
        Dialog.UPDATE(2, 0);
        DUE(CustCrIndicatorOpt::ODM5, LastEntryNo);

        //ODM6PLUS
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::ODM6PLUS) + '11/20'));
        Dialog.UPDATE(2, 0);
        DUE(CustCrIndicatorOpt::ODM6PLUS, LastEntryNo);

        //ODGROSS
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::ODGROSS) + '12/20'));
        Dialog.UPDATE(2, 0);
        ODGROSS_ARRES_ODRES(CustCrIndicatorOpt::ODGROSS, LastEntryNo);

        //NDEB0
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::NDEB0) + '13/20'));
        Dialog.UPDATE(2, 0);
        NDB0_TOTALINV(CustCrIndicatorOpt::NDEB0, LastEntryNo);

        //TOTALINV
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::TOTALINV) + '14/20'));
        Dialog.UPDATE(2, 0);
        NDB0_TOTALINV(CustCrIndicatorOpt::TOTALINV, LastEntryNo);

        //AR
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::AR) + '15/20'));
        Dialog.UPDATE(2, 0);
        AR(LastEntryNo);

        //ARRES
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::ARRES) + '16/20'));
        Dialog.UPDATE(2, 0);
        ODGROSS_ARRES_ODRES(CustCrIndicatorOpt::ARRES, LastEntryNo);

        //ODRES
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::ODRES) + '17/20'));
        Dialog.UPDATE(2, 0);
        ODGROSS_ARRES_ODRES(CustCrIndicatorOpt::ODRES, LastEntryNo);

        //PROV
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::PROV) + '18/20'));
        Dialog.UPDATE(2, 0);
        PROV_LOSSES_LOANS(CustCrIndicatorOpt::PROV, LastEntryNo);

        //LOSSES
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::LOSSES) + '19/20'));
        Dialog.UPDATE(2, 0);
        PROV_LOSSES_LOANS(CustCrIndicatorOpt::LOSSES, LastEntryNo);

        //LOANS
        Dialog.UPDATE(1, STRSUBSTNO(DialPrepareDataLbl, FORMAT(CustCrIndicatorOpt::LOANS) + '20/20'));
        Dialog.UPDATE(2, 0);
        PROV_LOSSES_LOANS(CustCrIndicatorOpt::LOANS, LastEntryNo);
    end;

    local procedure InitKeyAllocation(var MICASTE4KeyAllocation: Record "MICA STE4 Key Allocation")
    var
        GlobalMICASTE4KeyAllocation: Record "MICA STE4 Key Allocation";
        DimensionValue: Record "Dimension Value";
        QueryMICASTE4KeyAllocation: Query "MICA STE4 Key Allocation";
        CustNo: Code[20];
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
            CustNo := QueryMICASTE4KeyAllocation.SourceNo;

            //1.1 Init For Customer Key Allocation
            IF MICASTE4KeyAllocation.GET(MICASTE4KeyAllocation.Type::Customer,
                                 CustNo,
                                 DimensionValue."MICA Michelin Code",
                                 Database.UserId())
            then begin
                MICASTE4KeyAllocation."LB Amount" += QueryMICASTE4KeyAllocation.SalesAmActualSum;
                MICASTE4KeyAllocation.Modify();
            end else begin
                MICASTE4KeyAllocation.Init();
                MICASTE4KeyAllocation.Type := MICASTE4KeyAllocation.Type::Customer;
                MICASTE4KeyAllocation."Customer No." := CustNo;
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
                GlobalMICASTE4KeyAllocation.Init();
                GlobalMICASTE4KeyAllocation.Type := GlobalMICASTE4KeyAllocation.Type::Global;
                GlobalMICASTE4KeyAllocation."Customer No." := '';
                GlobalMICASTE4KeyAllocation."LB Code" := MICASTE4KeyAllocation."LB Code";
                GlobalMICASTE4KeyAllocation.UserId := Format(Database.UserId());
                GlobalMICASTE4KeyAllocation."Date Of Calculation" := EndingPeriod;
                GlobalMICASTE4KeyAllocation."LB Amount" := TotalAmtByLB;
                GlobalMICASTE4KeyAllocation.Insert();

                //release current group of LB
                MICASTE4KeyAllocation.FindLast();
                MICASTE4KeyAllocation.SetRange("LB Code");
            until MICASTE4KeyAllocation.Next() = 0;

        //2.2 Calculate Total Amount for Global
        GlobalMICASTE4KeyAllocation.Reset();
        GlobalMICASTE4KeyAllocation.SetCurrentKey(Type, "Customer No.", UserId);
        GlobalMICASTE4KeyAllocation.SetRange(Type, MICASTE4KeyAllocation.Type::Global);
        GlobalMICASTE4KeyAllocation.SetRange(UserId, Database.UserId());
        GlobalMICASTE4KeyAllocation.CalcSums("LB Amount");
        TotalAmtByGlobal := GlobalMICASTE4KeyAllocation."LB Amount";
        GlobalMICASTE4KeyAllocation.ModifyAll("Total Amount", TotalAmtByGlobal);
    end;

    procedure UpdateCustomerKeyAllocation(var MICASTE4KeyAllocation: Record "MICA STE4 Key Allocation")
    var
        RemainPercent: Decimal;
    begin
        MICASTE4KeyAllocation.Reset();
        MICASTE4KeyAllocation.SetCurrentKey(Type, "Customer No.", UserId);
        MICASTE4KeyAllocation.SetRange(Type, MICASTE4KeyAllocation.Type::Customer);
        MICASTE4KeyAllocation.SetRange(UserId, Database.UserId());
        MICASTE4KeyAllocation.SetFilter("Total Amount", '<>0');
        MICASTE4KeyAllocation.SetFilter("LB Amount", '<>0');
        IF MICASTE4KeyAllocation.FindSet() then
            repeat
                //Filter current Customer Group
                MICASTE4KeyAllocation.SetRange("Customer No.", MICASTE4KeyAllocation."Customer No.");
                RemainPercent := 0;

                repeat
                    MICASTE4KeyAllocation."% Allocation" := Round(RemainPercent + (MICASTE4KeyAllocation."LB Amount" / MICASTE4KeyAllocation."Total Amount") * 100, 1);
                    RemainPercent := (RemainPercent + (MICASTE4KeyAllocation."LB Amount" / MICASTE4KeyAllocation."Total Amount") * 100) - MICASTE4KeyAllocation."% Allocation";
                    MICASTE4KeyAllocation.Modify();
                until MICASTE4KeyAllocation.Next() = 0;

                //Release current group of customer
                MICASTE4KeyAllocation.FindLast();
                MICASTE4KeyAllocation.SetRange("Customer No.");
            until MICASTE4KeyAllocation.Next() = 0;
    end;

    procedure UpdateGlobalKeyAllocation(var MICASTE4KeyAllocation: Record "MICA STE4 Key Allocation")
    var
        RemainPercent: Decimal;
    begin
        RemainPercent := 0;
        MICASTE4KeyAllocation.Reset();
        MICASTE4KeyAllocation.SetCurrentKey(Type, "LB Code", UserId);
        MICASTE4KeyAllocation.SetRange(Type, MICASTE4KeyAllocation.Type::Global);
        MICASTE4KeyAllocation.SetRange(UserId, Database.UserId());
        MICASTE4KeyAllocation.SetFilter("Total Amount", '<>0');
        MICASTE4KeyAllocation.SetFilter("LB Amount", '<>0');
        IF MICASTE4KeyAllocation.FindSet() then
            repeat
                MICASTE4KeyAllocation."% Allocation" := Round(RemainPercent + (MICASTE4KeyAllocation."LB Amount" / MICASTE4KeyAllocation."Total Amount") * 100, 1);
                RemainPercent := (RemainPercent + (MICASTE4KeyAllocation."LB Amount" / MICASTE4KeyAllocation."Total Amount") * 100) - MICASTE4KeyAllocation."% Allocation";
                MICASTE4KeyAllocation.Modify();
            until MICASTE4KeyAllocation.Next() = 0;
    end;

    local Procedure InitSTE4Extraction()
    var
        MICASTE4KeyAllocation: Record "MICA STE4 Key Allocation";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SearchCustomer: Record Customer;
        Customer: Record Customer;
        IsDone: Boolean;
        Customer_Err: label 'Customer does not exist.';
    begin
        CustLedgerEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
        CustLedgerEntry.SETRANGE("Posting Date", 0D, EndingPeriod);
        IF CustLedgerEntry.FINDSET() then
            repeat
                IF CustLedgerEntry."Customer No." <> Customer."No." then
                    IF NOT Customer.GET(CustLedgerEntry."Customer No.") THEN
                        ERROR(Customer_Err);

                SearchCustomer.SetRange("No.", Customer."No.");
                SearchCustomer.SetFilter("Customer Posting Group", MICAFinancialReportingSetup."STE4 Posting Group Filter");
                if not SearchCustomer.IsEmpty() then
                    IF (Customer."MICA Party Ownership" IN [Customer."MICA Party Ownership"::"Group Network", Customer."MICA Party Ownership"::"Non Group"]) then begin
                        CustLedgerEntry.TestField("Due Date");
                        IsDone := false;
                        IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice then
                            IsDone := InitSTE4ExtractionMethod1ForInv(CustLedgerEntry, Customer)
                        else
                            IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::"Credit Memo" then
                                IsDone := InitSTE4ExtractionMethod1ForCrM(CustLedgerEntry, Customer);

                        IF NOT IsDone then
                            if ExistCustKeyAllocation(Customer."No.") then
                                InitSTE4ExtractionWithKeyAllocation(CustLedgerEntry, Customer, MICASTE4KeyAllocation.Type::Customer)
                            else
                                InitSTE4ExtractionWithKeyAllocation(CustLedgerEntry, Customer, MICASTE4KeyAllocation.Type::Global);
                    end;
            until CustLedgerEntry.NEXT() = 0;
    end;

    local procedure ExistCustKeyAllocation(CustNo: Code[20]): Boolean
    var
        MICASTE4KeyAllocation: record "MICA STE4 Key Allocation";
    begin
        with MICASTE4KeyAllocation do begin
            SetRange(Type, MICASTE4KeyAllocation.Type::Customer);
            SetRange("Customer No.", CustNo);
            SetRange(UserId, database.UserId());
            SetFilter("% Allocation", '<>0');
            exit(NOT IsEmpty());
        end;
    end;

    local procedure InitSTE4ExtractionMethod1ForInv(CustLedgerEntry: Record "Cust. Ledger Entry"; Customer: Record Customer): Boolean
    var
        MICASTE4Extraction: record "MICA STE4 Extraction";
        SalesInvoiceLine: record "Sales Invoice Line";
        TempSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        DimensionValue: record "Dimension value";
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        NextLineNo: Integer;
        TotalAmount: Decimal;
        RemainPercent: Decimal;
        RemainAmt1: Decimal;
        RemainAmt2: Decimal;
        LineAmountLCY: Decimal;
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
            SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.");
            Currency.Initialize(SalesInvoiceHeader."Currency Code");
            LineAmountLCY := CurrencyExchangeRate.ExchangeAmtFCYToLCY(SalesInvoiceHeader."Document Date", Currency.Code, SalesInvoiceLine."Line Amount", SalesInvoiceHeader."Currency Factor");
            TotalAmount += LineAmountLCY;

            TempSalesInvoiceLine.Reset();
            TempSalesInvoiceLine.SetRange("Shortcut Dimension 2 Code", DimensionValue."MICA Michelin Code");
            IF TempSalesInvoiceLine.FindFirst() then begin
                TempSalesInvoiceLine."Line Amount" += LineAmountLCY;
                TempSalesInvoiceLine.Modify();
            end else begin
                NextLineNo += 1;
                TempSalesInvoiceLine.Init();
                TempSalesInvoiceLine."Document No." := SalesInvoiceLine."Document No.";
                TempSalesInvoiceLine."Line No." := NextLineNo;
                TempSalesInvoiceLine."Shortcut Dimension 2 Code" := DimensionValue."MICA Michelin Code";
                TempSalesInvoiceLine."Line Amount" := LineAmountLCY;
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
        Clear(Currency);
        Currency.Init();
        CustLedgerEntry.SetFilter("Date Filter", '<=%1', EndingPeriod);
        CustLedgerEntry.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
        repeat
            MICASTE4Extraction.Init();
            MICASTE4Extraction."Document Type" := CustLedgerEntry."Document Type".AsInteger();
            MICASTE4Extraction."Document No." := CustLedgerEntry."Document No.";
            MICASTE4Extraction."Customer No." := CustLedgerEntry."Customer No.";
            MICASTE4Extraction."Posting Date" := CustLedgerEntry."Posting Date";
            MICASTE4Extraction."Due Date" := CustLedgerEntry."Due Date";
            MICASTE4Extraction.LB := TempSalesInvoiceLine."Shortcut Dimension 2 Code";

            MICASTE4Extraction."Initial Amount (LCY)" := Round(RemainAmt1 + CustLedgerEntry."Amount (LCY)" * TempSalesInvoiceLine.Amount / 100, Currency."Amount Rounding Precision");
            RemainAmt1 := (RemainAmt1 + CustLedgerEntry."Amount (LCY)" * TempSalesInvoiceLine.Amount / 100) - MICASTE4Extraction."Initial Amount (LCY)";

            MICASTE4Extraction."Remaining Amount (LCY)" := Round(RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * TempSalesInvoiceLine.Amount / 100, Currency."Amount Rounding Precision");
            RemainAmt2 := (RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * TempSalesInvoiceLine.Amount / 100) - MICASTE4Extraction."Remaining Amount (LCY)";

            MICASTE4Extraction."Customer Posting Group" := CustLedgerEntry."Customer Posting Group";
            MICASTE4Extraction.Open := CustLedgerEntry.Open;
            MICASTE4Extraction.NDCA := CustLedgerEntry."Due Date" - CustLedgerEntry."Posting Date";
            MICASTE4Extraction."Party Ownership" := customer."MICA Party Ownership";
            MICASTE4Extraction."Market Code" := Customer."MICA Market Code";
            MICASTE4Extraction.userid := COPYSTR(Database.UserId(), 1, 50);
            MICASTE4Extraction."Origin Entry No." := CustLedgerEntry."Entry No.";
            MICASTE4Extraction.INSERT();
        until TempSalesInvoiceLine.Next() = 0;
        Exit(true);
    end;

    local procedure InitSTE4ExtractionMethod1ForCrM(CustLedgerEntry: Record "Cust. Ledger Entry"; Customer: Record Customer): Boolean
    var
        MICASTE4Extraction: record "MICA STE4 Extraction";
        SalesCrMemoLine: record "Sales Cr.Memo Line";
        TempSalesCrMemoLine: Record "Sales Cr.Memo Line" temporary;
        SalesCrMemoHeader: record "Sales Cr.Memo Header";
        DimensionValue: record "Dimension value";
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        NextLineNo: Integer;
        TotalAmount: Decimal;
        RemainPercent: Decimal;
        RemainAmt1: Decimal;
        RemainAmt2: Decimal;
        LineAmountLCY: Decimal;
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
            SalesCrMemoHeader.Get(SalesCrMemoLine."Document No.");
            Currency.Initialize(SalesCrMemoHeader."Currency Code");
            CurrencyExchangeRate.GetCurrentCurrencyFactor(Currency.Code);
            LineAmountLCY := CurrencyExchangeRate.ExchangeAmtFCYToLCY(SalesCrMemoHeader."Document Date", Currency.Code, SalesCrMemoLine."Line Amount", SalesCrMemoHeader."Currency Factor");
            TotalAmount += LineAmountLCY;

            TempSalesCrMemoLine.Reset();
            TempSalesCrMemoLine.SetRange("Shortcut Dimension 2 Code", DimensionValue."MICA Michelin Code");
            IF TempSalesCrMemoLine.FindFirst() then begin
                TempSalesCrMemoLine."Line Amount" += LineAmountLCY;
                TempSalesCrMemoLine.Modify();
            end else begin
                NextLineNo += 1;
                TempSalesCrMemoLine.Init();
                TempSalesCrMemoLine."Document No." := SalesCrMemoLine."Document No.";
                TempSalesCrMemoLine."Line No." := NextLineNo;
                TempSalesCrMemoLine."Shortcut Dimension 2 Code" := DimensionValue."MICA Michelin Code";
                TempSalesCrMemoLine."Line Amount" := LineAmountLCY;
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
        Clear(Currency);
        Currency.Init();
        CustLedgerEntry.SetFilter("Date Filter", '<=%1', EndingPeriod);
        CustLedgerEntry.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
        repeat
            MICASTE4Extraction.Init();
            MICASTE4Extraction."Document Type" := CustLedgerEntry."Document Type".AsInteger();
            MICASTE4Extraction."Document No." := CustLedgerEntry."Document No.";
            MICASTE4Extraction."Customer No." := CustLedgerEntry."Customer No.";
            MICASTE4Extraction."Posting Date" := CustLedgerEntry."Posting Date";
            MICASTE4Extraction."Due Date" := CustLedgerEntry."Due Date";
            MICASTE4Extraction.LB := TempSalesCrMemoLine."Shortcut Dimension 2 Code";

            MICASTE4Extraction."Initial Amount (LCY)" := Round(RemainAmt1 + CustLedgerEntry."Amount (LCY)" * TempSalesCrMemoLine.Amount / 100, Currency."Amount Rounding Precision");
            RemainAmt1 := (RemainAmt1 + CustLedgerEntry."Amount (LCY)" * TempSalesCrMemoLine.Amount / 100) - MICASTE4Extraction."Initial Amount (LCY)";

            MICASTE4Extraction."Remaining Amount (LCY)" := Round(RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * TempSalesCrMemoLine.Amount / 100, Currency."Amount Rounding Precision");
            RemainAmt2 := (RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * TempSalesCrMemoLine.Amount / 100) - MICASTE4Extraction."Remaining Amount (LCY)";

            MICASTE4Extraction."Customer Posting Group" := CustLedgerEntry."Customer Posting Group";
            MICASTE4Extraction.Open := CustLedgerEntry.Open;
            MICASTE4Extraction.NDCA := CustLedgerEntry."Due Date" - CustLedgerEntry."Posting Date";
            MICASTE4Extraction."Party Ownership" := customer."MICA Party Ownership";
            MICASTE4Extraction."Market Code" := Customer."MICA Market Code";
            MICASTE4Extraction.userid := COPYSTR(Database.UserId(), 1, 50);
            MICASTE4Extraction."Origin Entry No." := CustLedgerEntry."Entry No.";
            MICASTE4Extraction.INSERT();
        until TempSalesCrMemoLine.Next() = 0;
        Exit(true);
    end;

    local procedure InitSTE4ExtractionWithKeyAllocation(CustLedgerEntry: Record "Cust. Ledger Entry"; Customer: Record Customer; AllocationType: Option Global,Customer)
    var
        MICASTE4Extraction: record "MICA STE4 Extraction";
        CustMICASTE4KeyAllocation: record "MICA STE4 Key Allocation";
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
            CustLedgerEntry.SetFilter("Date Filter", '<=%1', EndingPeriod);
            CustLedgerEntry.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
            repeat
                MICASTE4Extraction.Init();
                MICASTE4Extraction."Document Type" := CustLedgerEntry."Document Type".AsInteger();
                MICASTE4Extraction."Document No." := CustLedgerEntry."Document No.";
                MICASTE4Extraction."Customer No." := CustLedgerEntry."Customer No.";
                MICASTE4Extraction."Posting Date" := CustLedgerEntry."Posting Date";
                MICASTE4Extraction."Due Date" := CustLedgerEntry."Due Date";
                MICASTE4Extraction.LB := CustMICASTE4KeyAllocation."LB Code";

                MICASTE4Extraction."Initial Amount (LCY)" := ROUND(RemainAmt1 + CustLedgerEntry."Amount (LCY)" * CustMICASTE4KeyAllocation."% Allocation" / 100, Currency."Amount Rounding Precision");
                RemainAmt1 := (RemainAmt1 + CustLedgerEntry."Amount (LCY)" * CustMICASTE4KeyAllocation."% Allocation" / 100) - MICASTE4Extraction."Initial Amount (LCY)";

                MICASTE4Extraction."Remaining Amount (LCY)" := ROUND(RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * CustMICASTE4KeyAllocation."% Allocation" / 100, Currency."Amount Rounding Precision");
                RemainAmt2 := (RemainAmt2 + CustLedgerEntry."Remaining Amt. (LCY)" * CustMICASTE4KeyAllocation."% Allocation" / 100) - MICASTE4Extraction."Remaining Amount (LCY)";

                MICASTE4Extraction."Customer Posting Group" := CustLedgerEntry."Customer Posting Group";
                MICASTE4Extraction.Open := CustLedgerEntry.Open;
                MICASTE4Extraction.NDCA := CustLedgerEntry."Due Date" - CustLedgerEntry."Posting Date";
                MICASTE4Extraction."Party Ownership" := customer."MICA Party Ownership";
                MICASTE4Extraction."Market Code" := Customer."MICA Market Code";
                MICASTE4Extraction.userid := COPYSTR(Database.UserId(), 1, 50);
                MICASTE4Extraction."Origin Entry No." := CustLedgerEntry."Entry No.";
                MICASTE4Extraction.Insert();
            until CustMICASTE4KeyAllocation.Next() = 0;
        end;
    end;

    local procedure TopMonth(var LastEntryNo: Integer)
    var
        MICASTE4Extraction: Record "MICA STE4 Extraction";
        NextEntryNo: Integer;
        TotalAmount: Decimal;
        SalesAmount: Decimal;
        ResultAmt: Decimal;
        IndicatorCodeTxt: Label 'TOPMONTH';
    begin
        NextEntryNo := LastEntryNo;

        //* Total Invoice Line
        MICASTE4Extraction.Reset();
        MICASTE4Extraction.SetCurrentKey(LB, "Market Code", "Document Type", "Posting Date", "Customer Posting Group", UserId);
        MICASTE4Extraction.SetRange("Document Type", MICASTE4Extraction."Document Type"::Invoice);  //Credit Memo
        MICASTE4Extraction.SetRange("Posting Date", StartingPeriod, EndingPeriod);
        MICASTE4Extraction.SetRange(UserId, Database.UserId());
        IF MICASTE4Extraction.FindSet() then
            repeat
                //Filter current LB, Market group
                MICASTE4Extraction.SetRange(LB, MICASTE4Extraction.LB);
                MICASTE4Extraction.SetRange("Market Code", MICASTE4Extraction."Market Code");

                SalesAmount := 0;
                TotalAmount := 0;
                MICASTE4Extraction.FindSet();
                repeat
                    SalesAmount += MICASTE4Extraction."Initial Amount (LCY)" * MICASTE4Extraction.NDCA;
                    TotalAmount += MICASTE4Extraction."Initial Amount (LCY)";
                until MICASTE4Extraction.Next() = 0;
                MICASTE4Extraction.FindLast();

                IF (SalesAmount <> 0) AND (TotalAmount <> 0) then begin
                    ResultAmt := (SalesAmount / TotalAmount) * 1000;
                    InsertReportingBuffer(NextEntryNo, IndicatorCodeTxt, MICASTE4Extraction.LB, MICASTE4Extraction."Market Code", ResultAmt);
                end;
                //release current group of LB, Market
                MICASTE4Extraction.FindLast();
                MICASTE4Extraction.SetRange(LB);
                MICASTE4Extraction.SetRange("Market Code");
            until MICASTE4Extraction.Next() = 0;

        LastEntryNo := NextEntryNo;
    end;

    local procedure Due(CustCrIndicator: option TOPMONTH,NYDUE,ODM1LESS,ODM1M2,ODM3M4,ODM5,ODM6PLUS,ODGROSS,TOTALINV,NDEB0,LOANS,PROV,LOSSES,ARRES,ODRES,AR; var LastEntryNo: Integer)
    var
        MICASTE4Extraction: Record "MICA STE4 Extraction";
        NextEntryNo: Integer;
        IndicatorCode: Code[10];
        NYDUETxt: Label 'NYDUE';
        ODM1LESSTxt: label 'ODM1LESS';
        ODM1M2Txt: label 'ODM1M2';
        ODM3M4Txt: Label 'ODM3M4';
        ODM5Txt: label 'ODM5';
        ODM6PLUSTxt: label 'ODM6PLUS';
        ODTxt: Label 'OD';
    begin
        NextEntryNo := LastEntryNo;

        MICASTE4Extraction.SetCurrentKey(LB, "Market Code", "Document Type", Open, "Due Date", "Customer Posting Group", "Party Ownership", UserId);
        case CustCrIndicator of
            CustCrIndicator::NYDUE:
                begin
                    MICASTE4Extraction.Setfilter("Due Date", '%1..', CalcDate('<1D>', EndingPeriod));
                    IndicatorCode := NYDUETxt;
                end;
            CustCrIndicator::ODM1LESS:
                begin
                    MICASTE4Extraction.Setrange("Due Date", CALCDATE('<-30D>', EndingPeriod), EndingPeriod);
                    IndicatorCode := ODM1LESStxt;
                end;
            CustCrIndicator::ODM1M2:
                begin
                    MICASTE4Extraction.Setrange("Due Date", CALCDATE('<-90D>', EndingPeriod), CALCDATE('<-31D>', EndingPeriod));
                    IndicatorCode := ODM1M2txt;
                end;
            CustCrIndicator::ODM3M4:
                begin
                    MICASTE4Extraction.Setrange("Due Date", CALCDATE('<-150D>', EndingPeriod), CALCDATE('<-91D>', EndingPeriod));
                    IndicatorCode := ODM3M4txt;
                end;
            CustCrIndicator::ODM5:
                begin
                    MICASTE4Extraction.Setrange("Due Date", CALCDATE('<-180D>', EndingPeriod), CALCDATE('<-151D>', EndingPeriod));
                    IndicatorCode := ODM5txt;
                end;
            CustCrIndicator::ODM6PLUS:
                begin
                    MICASTE4Extraction.Setrange("Due Date", 0D, CALCDATE('<-181D>', EndingPeriod));
                    IndicatorCode := ODM6PLUStxt;
                end;
        end;
        MICASTE4Extraction.SetFilter("Customer Posting Group", MICAFinancialReportingSetup."STE4 Posting Group Filter");
        MICASTE4Extraction.SetRange(UserId, Database.UserId());
        IF MICASTE4Extraction.FindSet() then
            repeat
                //filter current LB, Market group
                MICASTE4Extraction.SetRange(LB, MICASTE4Extraction.LB);
                MICASTE4Extraction.SetRange("Market Code", MICASTE4Extraction."Market Code");

                MICASTE4Extraction.CalcSums("Remaining Amount (LCY)");
                IF MICASTE4Extraction."Remaining Amount (LCY)" <> 0 then begin
                    InsertReportingBuffer(NextEntryNo, IndicatorCode, MICASTE4Extraction.LB, MICASTE4Extraction."Market Code", MICASTE4Extraction."Remaining Amount (LCY)");
                    if (CustCrIndicator = CustCrIndicator::ODM1LESS) or (CustCrIndicator = CustCrIndicator::ODM1M2) or (CustCrIndicator = CustCrIndicator::ODM3M4) or (CustCrIndicator = CustCrIndicator::ODM5) or (CustCrIndicator = CustCrIndicator::ODM6PLUS) then
                        if not ModifyReportingBuffer(ODTxt, MICASTE4Extraction.LB, MICASTE4Extraction."Market Code", MICASTE4Extraction."Remaining Amount (LCY)") then
                            InsertReportingBuffer(NextEntryNo, ODTxt, MICASTE4Extraction.LB, MICASTE4Extraction."Market Code", MICASTE4Extraction."Remaining Amount (LCY)");

                end;

                //release current group of LB, Market
                MICASTE4Extraction.FindLast();
                MICASTE4Extraction.SetRange(LB);
                MICASTE4Extraction.SetRange("Market Code");
            until MICASTE4Extraction.Next() = 0;
        LastEntryNo := NextEntryNo;
    end;

    local procedure ODGROSS_ARRES_ODRES(CustCrIndicator: option TOPMONTH,NYDUE,ODM1LESS,ODM1M2,ODM3M4,ODM5,ODM6PLUS,ODGROSS,TOTALINV,NDEB0,LOANS,PROV,LOSSES,ARRES,ODRES,AR; var LastEntryNo: Integer)
    var
        MICASTE4Extraction: Record "MICA STE4 Extraction";
        NextEntryNo: Integer;
        IndicatorCode: Code[10];
        ODGROSSTxt: Label 'ODGROSS';
        ARRESTxt: Label 'ARRES';
        ODRESTxt: Label 'ODRES';
    begin
        NextEntryNo := LastEntryNo;

        MICASTE4Extraction.SetCurrentKey(LB, "Market Code", "Document Type", Open, "Due Date", "Customer Posting Group", "Party Ownership", UserId);
        case CustCrIndicator of
            CustCrIndicator::ODGROSS:
                begin
                    MICASTE4Extraction.Setfilter("Document Type", '%1|%2', MICASTE4Extraction."Document Type"::"Finance Charge Memo", MICASTE4Extraction."Document Type"::Invoice);
                    MICASTE4Extraction.SetRange("Due Date", 0D, EndingPeriod);
                    IndicatorCode := ODGROSSTxt;
                end;
            CustCrIndicator::ARRES:
                begin
                    MICASTE4Extraction.setrange("Party Ownership", MICASTE4Extraction."Party Ownership"::"Group Network");
                    IndicatorCode := ARRESTxt;
                end;
            CustCrIndicator::ODRES:
                begin
                    MICASTE4Extraction.SetRange("Due Date", 0D, EndingPeriod);
                    MICASTE4Extraction.setrange("Party Ownership", MICASTE4Extraction."Party Ownership"::"Group Network");
                    IndicatorCode := ODRESTxt;
                end;
        end;
        MICASTE4Extraction.SetFilter("Customer Posting Group", MICAFinancialReportingSetup."STE4 Posting Group Filter");
        MICASTE4Extraction.SetRange(UserId, Database.UserId());
        IF MICASTE4Extraction.FindSet() then
            repeat
                //Filter current LB, Market Group
                MICASTE4Extraction.SetRange(LB, MICASTE4Extraction.LB);
                MICASTE4Extraction.SetRange("Market Code", MICASTE4Extraction."Market Code");

                MICASTE4Extraction.CalcSums("Remaining Amount (LCY)");
                IF MICASTE4Extraction."Remaining Amount (LCY)" <> 0 then
                    InsertReportingBuffer(NextEntryNo, IndicatorCode, MICASTE4Extraction.LB, MICASTE4Extraction."Market Code", MICASTE4Extraction."Remaining Amount (LCY)");

                //release current group of LB, Market
                MICASTE4Extraction.FindLast();
                MICASTE4Extraction.SetRange(LB);
                MICASTE4Extraction.SetRange("Market Code");
            until MICASTE4Extraction.Next() = 0;

        LastEntryNo := NextEntryNo;
    end;

    local procedure NDB0_TOTALINV(CustCrIndicator: option TOPMONTH,NYDUE,ODM1LESS,ODM1M2,ODM3M4,ODM5,ODM6PLUS,ODGROSS,TOTALINV,NDEB0,LOANS,PROV,LOSSES,ARRES,ODRES,AR; var LastEntryNo: Integer)
    var
        MICASTE4Extraction: Record "MICA STE4 Extraction";
        NextEntryNo: Integer;
        IndicatorCode: Code[10];
        ODGROSSTxt: Label 'NDEB0';
        TOTALINVTxt: label 'TOTALINV';
    begin
        NextEntryNo := LastEntryNo;

        MICASTE4Extraction.Reset();
        MICASTE4Extraction.SetCurrentKey(LB, "Market Code", "Document Type", "Posting Date", "Customer Posting Group", UserId);
        case CustCrIndicator of
            CustCrIndicator::NDEB0:
                begin
                    MICASTE4Extraction.Setfilter("Document Type", '%1|%2|%3|%4|%5', MICASTE4Extraction."Document Type"::Invoice, MICASTE4Extraction."Document Type"::"Credit Memo", MICASTE4Extraction."Document Type"::" ", MICASTE4Extraction."Document Type"::Refund, MICASTE4Extraction."Document Type"::"Finance Charge Memo");
                    IndicatorCode := ODGROSSTxt;
                end;
            CustCrIndicator::TOTALINV:
                begin
                    MICASTE4Extraction.Setrange("Document Type", MICASTE4Extraction."Document Type"::Invoice);
                    IndicatorCode := TOTALINVTxt;
                end;
        end;
        MICASTE4Extraction.Setrange("Posting Date", StartingPeriod, EndingPeriod);
        MICASTE4Extraction.SetFilter("Customer Posting Group", MICAFinancialReportingSetup."STE4 Posting Group Filter");
        MICASTE4Extraction.SetRange(UserId, Database.UserId());
        IF MICASTE4Extraction.FindSet() then
            repeat
                //filter current LB, Martket group
                MICASTE4Extraction.SetRange(LB, MICASTE4Extraction.LB);
                MICASTE4Extraction.SetRange("Market Code", MICASTE4Extraction."Market Code");

                MICASTE4Extraction.CalcSums("Initial Amount (LCY)");
                IF MICASTE4Extraction."Initial Amount (LCY)" <> 0 then
                    InsertReportingBuffer(NextEntryNo, IndicatorCode, MICASTE4Extraction.LB, MICASTE4Extraction."Market Code", MICASTE4Extraction."Initial Amount (LCY)");

                //release current group of LB, Market
                MICASTE4Extraction.FindLast();
                MICASTE4Extraction.SetRange(LB);
                MICASTE4Extraction.SetRange("Market Code");
            until MICASTE4Extraction.Next() = 0;

        LastEntryNo := NextEntryNo;
    end;

    local procedure AR(var LastEntryNo: Integer)
    var
        MICASTE4Extraction: Record "MICA STE4 Extraction";
        NextEntryNo: Integer;
        IndicatorCode: Code[10];
        ARTxt: Label 'AR';
    begin
        NextEntryNo := LastEntryNo;
        IndicatorCode := ARTxt;

        MICASTE4Extraction.SetCurrentKey(LB, "Market Code", "Document Type", Open, "Due Date", "Customer Posting Group", "Party Ownership", UserId);
        MICASTE4Extraction.SetFilter("Customer Posting Group", MICAFinancialReportingSetup."STE4 AR Pst. Group Filter");
        MICASTE4Extraction.SetRange(UserId, Database.UserId());
        IF MICASTE4Extraction.FindSet() then
            repeat
                //filter current LB, Martket Group
                MICASTE4Extraction.SetRange(LB, MICASTE4Extraction.LB);
                MICASTE4Extraction.SetRange("Market Code", MICASTE4Extraction."Market Code");

                MICASTE4Extraction.CalcSums("Remaining Amount (LCY)");
                IF MICASTE4Extraction."Remaining Amount (LCY)" <> 0 then
                    InsertReportingBuffer(NextEntryNo, IndicatorCode, MICASTE4Extraction.LB, MICASTE4Extraction."Market Code", MICASTE4Extraction."Remaining Amount (LCY)");
                //Release current group of LB, Martket
                MICASTE4Extraction.FindLast();
                MICASTE4Extraction.SetRange(LB);
                MICASTE4Extraction.SetRange("Market Code");
            until MICASTE4Extraction.Next() = 0;

        LastEntryNo := NextEntryNo;
    end;

    local procedure PROV_LOSSES_LOANS(CustCrIndicator: option TOPMONTH,NYDUE,ODM1LESS,ODM1M2,ODM3M4,ODM5,ODM6PLUS,ODGROSS,TOTALINV,NDEB0,LOANS,PROV,LOSSES,ARRES,ODRES,AR; var LastEntryNo: Integer)
    var
        GlobalMICASTE4KeyAllocation: record "MICA STE4 Key Allocation";
        GLEntry: record "G/L Entry";
        Currency: Record Currency;
        NextEntryNo: Integer;
        IndicatorCode: Code[10];
        PROVTxt: Label 'PROV';
        LOSSESTxt: label 'LOSSES';
        LOANSTxt: label 'LOANS';
        TotalAmt: Decimal;
        SplittedAmt: Decimal;
        RemainAmt: Decimal;
    begin
        RemainAmt := 0;
        NextEntryNo := LastEntryNo;

        GLEntry.SetRange("Posting Date", 0D, EndingPeriod);
        case CustCrIndicator of
            CustCrIndicator::PROV:
                begin
                    IndicatorCode := PROVTxt;

                    GLEntry.setfilter("MICA No. 2", MICAFinancialReportingSetup."STE4 PROV Filter");
                    GLEntry.CalcSums(Amount);
                    TotalAmt := GLEntry.Amount;
                end;
            CustCrIndicator::LOSSES:
                begin
                    IndicatorCode := LOSSESTxt;
                    GLEntry.SetRange("Posting Date", DMY2Date(1, 1, Date2DMY(EndingPeriod, 3)), EndingPeriod);
                    GLEntry.setfilter("MICA No. 2", MICAFinancialReportingSetup."STE4 Add LOSSES Filter");
                    if GLEntry.FindSet() then
                        repeat
                            TotalAmt += Abs(GLEntry.Amount);
                        until GLEntry.Next() = 0;

                    GLEntry.setfilter("MICA No. 2", MICAFinancialReportingSetup."STE4 Sub LOSSES Filter");
                    if GLEntry.FindSet() then
                        repeat
                            TotalAmt -= Abs(GLEntry.Amount);
                        until GLEntry.Next() = 0;
                end;
            CustCrIndicator::LOANS:
                begin
                    IndicatorCode := LOANSTxt;

                    GLEntry.SetFilter("MICA No. 2", MICAFinancialReportingSetup."STE4 LOANS Filter");
                    GLEntry.CalcSums(Amount);
                    TotalAmt := GLEntry.Amount;
                end;
        end;

        GlobalMICASTE4KeyAllocation.setrange(Type, GlobalMICASTE4KeyAllocation.Type::Global);
        GlobalMICASTE4KeyAllocation.SetRange(UserId, Database.UserId());
        GlobalMICASTE4KeyAllocation.SetFilter("% Allocation", '<>0');
        IF (TotalAmt = 0) OR (NOT GlobalMICASTE4KeyAllocation.FindSet()) then
            EXIT;

        Currency.Init();
        repeat
            SplittedAmt := Round(RemainAmt + TotalAmt * GlobalMICASTE4KeyAllocation."% Allocation" / 100, Currency."Amount Rounding Precision");
            RemainAmt := (RemainAmt + TotalAmt * GlobalMICASTE4KeyAllocation."% Allocation" / 100) - SplittedAmt;
            InsertReportingBuffer(NextEntryNo, IndicatorCode, GlobalMICASTE4KeyAllocation."LB Code", '20', SplittedAmt);
        until GlobalMICASTE4KeyAllocation.Next() = 0;

        LastEntryNo := NextEntryNo;
    end;

    local procedure InsertReportingBuffer(Var NextEntryNo: Integer; CustCrIndicator: Code[10]; LB: Code[20]; MarketCode: code[20]; SalesAmount: Decimal)
    begin
        NextEntryNo += 1;
        MICAReportingBuffer.INIT();
        MICAReportingBuffer."Entry No." := NextEntryNo;
        MICAReportingBuffer."Cust. Cr. Indicator" := CustCrIndicator;
        MICAReportingBuffer.Structure := LB;
        MICAReportingBuffer.Section := MarketCode;
        MICAReportingBuffer."Sales Amount" := SalesAmount;
        MICAReportingBuffer.UserId := COPYSTR(Database.UserId(), 1, 50);
        MICAReportingBuffer.INSERT();
    end;

    local procedure ModifyReportingBuffer(CustCrIndicator: Code[10]; LB: Code[20]; MarketCode: code[20]; SalesAmount: Decimal): Boolean
    var
        SearchMICAReportingBuffer: Record "MICA Reporting Buffer";
        ModifyMICAReportingBuffer: Record "MICA Reporting Buffer";
    begin
        SearchMICAReportingBuffer.SetRange("Cust. Cr. Indicator", CustCrIndicator);
        SearchMICAReportingBuffer.SetRange(Structure, LB);
        SearchMICAReportingBuffer.SetRange(Section, MarketCode);
        SearchMICAReportingBuffer.SetRange(UserId, COPYSTR(Database.UserId(), 1, 50));
        if SearchMICAReportingBuffer.FindFirst() then begin
            ModifyMICAReportingBuffer.Get(SearchMICAReportingBuffer."Entry No.");
            ModifyMICAReportingBuffer.Validate("Sales Amount", ModifyMICAReportingBuffer."Sales Amount" + SalesAmount);
            ModifyMICAReportingBuffer.Modify(true);
        end else
            exit(false);
        exit(true);
    end;

    local procedure DeleteReportingBuffer()
    begin
        MICAReportingBuffer.Reset();
        MICAReportingBuffer.SetCurrentKey(UserId);
        MICAReportingBuffer.SetRange(UserId, Database.UserId());
        if NOT MICAReportingBuffer.IsEmpty() then
            MICAReportingBuffer.DeleteAll();
    end;

    local procedure DeleteKeyAllocation()
    var
        MICASTE4KeyAllocation: Record "MICA STE4 Key Allocation";
    begin
        MICASTE4KeyAllocation.SetCurrentKey(UserId);
        MICASTE4KeyAllocation.SetRange(UserId, Database.UserId());
        if NOT MICASTE4KeyAllocation.IsEmpty() then
            MICASTE4KeyAllocation.DeleteAll();
    end;

    local procedure DeleteSTE4Extraction()
    var
        MICASTE4Extraction: Record "MICA STE4 Extraction";
    begin
        MICASTE4Extraction.Reset();
        MICASTE4Extraction.SetCurrentKey(UserId);
        MICASTE4Extraction.SetRange(UserId, Database.UserId());
        if NOT MICASTE4Extraction.IsEmpty() then
            MICASTE4Extraction.DeleteAll();
    end;
}