xmlport 80640 "MICA F300 Export"
{
    Caption = 'F300 Export';
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
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                SourceTableView = sorting(Number) order(ascending);
                textelement(PeriodExport)
                {

                }
                Textelement(Company)
                {

                }
                textelement(CAI)
                {

                }
                textelement(Type)
                {

                }
                textelement(Quantity)
                {

                }
                textelement(StockValue)
                {

                }
                trigger OnPreXmlItem()
                var
                    TextNoData_Err: Label 'No data to export.';
                begin
                    TempItemBudgetBuffer.RESET();
                    Integer.SETFILTER(Number, '%1..%2', 1, TempItemBudgetBuffer.COUNT());
                    TotalRecs := TempItemBudgetBuffer.COUNT();
                    CurrTotal := 0;

                    IF NOT TempItemBudgetBuffer.FINDSET(FALSE, FALSE) THEN
                        MESSAGE(TextNoData_Err);
                end;

                trigger OnAfterGetRecord()
                begin
                    Company := '';
                    CAI := '';
                    Type := '';
                    Quantity := '';
                    StockValue := '';

                    PeriodExport := Period;
                    Company := TempItemBudgetBuffer."Location Code";
                    CAI := TempItemBudgetBuffer."Item No.";
                    Type := TempItemBudgetBuffer."Source No.";
                    Quantity := FORMAT(TempItemBudgetBuffer.Quantity, 0, '<Sign><Integer>');
                    StockValue := FORMAT(Round(TempItemBudgetBuffer."Cost Amount", 1), 0, '<Sign><Integer>');
                    CurrTotal += 1;

                    Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));

                    TempItemBudgetBuffer.NEXT(1);
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    var
        TxtExport_Lbl: label 'Export data';
        TxtDial_Lbl: label 'Phase #1########## \';
        TxtDialProcess_Lbl: label 'Progress @2@@@@@@@@@@';
        TxtDialPrepareData_Lbl: label 'Prepare Data';
    begin
        EndingPeriod := 0D;
        CheckPeriodFormat();

        MICAFinancialReportingSetup.GET();

        CheckInventoryPeriod();

        Dialog.OPEN(TxtDial_Lbl + TxtDialProcess_Lbl);
        Dialog.UPDATE(1, TxtDialPrepareData_Lbl);

        MICAFinancialReportingSetup.TESTFIELD("Company Code");

        PrepareData();

        Dialog.UPDATE(1, TxtExport_Lbl);

        currXMLport.FILENAME := 'F300_' + MICAFinancialReportingSetup."Company Code" + '_' + Period + '.csv';
    end;

    trigger OnPostXmlPort()
    begin
        Dialog.Close();
    end;

    local procedure CheckInventoryPeriod()
    var
        InventoryPeriod: record "Inventory Period";
        TxtCheckInvPeriod_Err: Label 'No inventory period closed has been found for the selected period %1';
    begin
        InventoryPeriod.RESET();
        InventoryPeriod.SetRange("Ending Date", EndingPeriod);
        InventoryPeriod.setrange(closed, true);
        if InventoryPeriod.IsEmpty() then
            error(TxtCheckInvPeriod_Err, Period);
    end;

    local procedure CheckPeriodFormat()
    var
        Err: Boolean;
        Year: Integer;
        Month: Integer;
        CheckPeriod_Err: Label 'The period format should be YYYYMM';
    begin
        Err := FALSE;
        Year := 0;
        Month := 0;

        IF STRLEN(Period) < 6 THEN
            Err := TRUE
        ELSE BEGIN
            IF NOT EVALUATE(Year, COPYSTR(Period, 1, 4)) THEN
                Err := TRUE;

            IF NOT EVALUATE(Month, COPYSTR(Period, 5, 2)) THEN
                Err := TRUE;
        END;

        IF Err THEN
            ERROR(CheckPeriod_Err);

        EndingPeriod := CALCDATE('<CM>', DMY2DATE(1, Month, Year));
    end;

    Local procedure PrepareData()
    var
        Item: record Item;
    begin
        TempItemBudgetBuffer.RESET();
        IF NOT TempItemBudgetBuffer.ISEMPTY() THEN
            TempItemBudgetBuffer.DELETEALL();

        Item.RESET();
        TotalRecs := Item.COUNT();
        CurrTotal := 0;
        Item.SETRANGE("MICA Exclude from Report. Grp.", FALSE);
        IF Item.FINDSET(FALSE, FALSE) THEN
            REPEAT
                PhysicalInventory(Item."No.", Item."No. 2", MICAFinancialReportingSetup."Company Code");
                InTransitInventory(Item."No.", Item."No. 2", MICAFinancialReportingSetup."Company Code");
                //InventoryDifference(Item."No. 2",Item."No. 2", FinancialReportingSetup."Company Code");
                CurrTotal += 1;
                Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
            UNTIL Item.NEXT() = 0;
        TempItemBudgetBuffer.Reset();
        TempItemBudgetBuffer.SetRange(Quantity, 0);
        TempItemBudgetBuffer.SetRange("Cost Amount", 0);
        if TempItemBudgetBuffer.Count() > 0 then
            TempItemBudgetBuffer.DeleteAll();
    end;

    local procedure PhysicalInventory(ItemNo: Code[20]; ItemNo2: Code[20]; CompanyCode: code[10])
    var
        TotalCost: Decimal;
        Qty: Decimal;
        FindILE: Boolean;
    begin
        Qty := 0;
        TotalCost := 0;

        FindItemLedgerEntries(ItemNo, EntryTypeFilter::"P (Main)", Qty, TotalCost, FindILE);
        if FindILE THEN BEGIN
            TempItemBudgetBuffer.Reset();
            TempItemBudgetBuffer.SetRange("Item No.", ItemNo2);
            TempItemBudgetBuffer.SetRange("Source No.", 'P');
            if TempItemBudgetBuffer.FindFirst() then begin
                TempItemBudgetBuffer.Quantity += Qty;
                TempItemBudgetBuffer."Cost Amount" += TotalCost;
                TempItemBudgetBuffer.MODIFY();
            END ELSE begin
                TempItemBudgetBuffer.INIT();
                TempItemBudgetBuffer."Item No." := ItemNo2;
                TempItemBudgetBuffer."Location Code" := CompanyCode;
                TempItemBudgetBuffer."Source No." := 'P';
                TempItemBudgetBuffer.Quantity := Qty;
                TempItemBudgetBuffer."Cost Amount" := TotalCost;
                TempItemBudgetBuffer.INSERT();
            end;
        end;
    end;

    local procedure IntransitInventory(ItemNo: Code[20]; ItemNo2: Code[20]; CompanyCode: code[10])
    var
        TotalCost: Decimal;
        Qty: Decimal;
        FindILE: Boolean;
    begin
        Qty := 0;
        TotalCost := 0;
        FindItemLedgerEntries(ItemNo, EntryTypeFilter::"C (transit)", Qty, TotalCost, FindILE);
        if FindILE then begin
            TempItemBudgetBuffer.Reset();
            TempItemBudgetBuffer.SetRange("Item No.", ItemNo2);
            TempItemBudgetBuffer.SetRange("Source No.", 'C');
            if TempItemBudgetBuffer.FindFirst() then begin
                TempItemBudgetBuffer.Quantity += Qty;
                TempItemBudgetBuffer."Cost Amount" += TotalCost;
                TempItemBudgetBuffer.MODIFY();
            END ELSE begin
                TempItemBudgetBuffer.INIT();
                TempItemBudgetBuffer."Item No." := ItemNo2;
                TempItemBudgetBuffer."Location Code" := CompanyCode;
                TempItemBudgetBuffer."Source No." := 'C';
                TempItemBudgetBuffer.Quantity := Qty;
                TempItemBudgetBuffer."Cost Amount" := TotalCost;
                TempItemBudgetBuffer.INSERT();
            end;
        end;
    end;

    local procedure FindItemLedgerEntries(ItemNo: Code[20]; EntryType: Option " ","P (Main)","C (transit)"; var Qty: Decimal; var TotalCost: Decimal; var FindILE: Boolean)
    var
        ItemLedgerEntry: record "Item Ledger Entry";
        Location: Record Location;
    begin
        if EntryType = EntryType::" " THEN
            Location.SETFILTER("MICA Entry Type", '%1|%2', EntryType::"P (Main)", EntryType::"C (transit)")
        ELSE
            Location.SetRange("MICA Entry Type", EntryType);
        IF Location.FINDSET() then
            REPEAT
                ItemLedgerEntry.RESET();
                ItemLedgerEntry.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                ItemLedgerEntry.SETRANGE("Item No.", ItemNo);
                ItemLedgerEntry.SETRANGE("Location Code", Location.Code);
                if EntryType = EntryType::"C (transit)" then
                    ItemLedgerEntry.SetRange("Posting Date", 0D, CalcDate('<+1M>', EndingPeriod))
                else
                    ItemLedgerEntry.SetRange("Posting Date", 0D, EndingPeriod);
                IF ItemLedgerEntry.FINDSET(FALSE, FALSE) THEN begin
                    FindILE := True;
                    REPEAT
                        if EntryType = EntryType::"C (transit)" then begin
                            if (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Purchase) and
                            (ItemLedgerEntry."Posting Date" > EndingPeriod) then begin
                                if FindValueEntriesInNextMonth(ItemLedgerEntry."Entry No.", ItemLedgerEntry."Entry Type"::Purchase.AsInteger()) then
                                    Qty += ItemLedgerEntry.Quantity;
                            end else
                                if ItemLedgerEntry."Posting Date" <= EndingPeriod then
                                    Qty += ItemLedgerEntry.Quantity;
                        end else
                            Qty += ItemLedgerEntry.Quantity;

                        TotalCost += CalcStockValue(ItemLedgerEntry."Entry No.");
                    UNTIL ItemLedgerEntry.NEXT() = 0;
                end;
            UNTIL Location.NEXT() = 0;
    end;

    local procedure CalcStockValue(ItemLedgerEntryNo: Integer): Decimal
    var
        ValueEntry: Record "Value Entry";
        TotalCost: Decimal;
    begin
        TotalCost := 0;

        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
        ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
        ValueEntry.SETFILTER("Posting Date", '..%1', EndingPeriod);
        IF ValueEntry.FINDSET(FALSE, FALSE) THEN
            REPEAT
                TotalCost += ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
            UNTIL ValueEntry.NEXT() = 0;

        EXIT(TotalCost);
    end;

    local procedure FindValueEntriesInNextMonth(NewItemLedgerEntryNo: Integer; NewItemLedgerEntryType: Integer): Boolean
    var
        PurchaseValueEntry: Record "Value Entry";
        FoundPurchaseValueEntry: Record "Value Entry";
        StartDate: Date;
        EndDate: Date;
    begin
        StartDate := CalcDate('<+1D>', EndingPeriod);
        EndDate := CalcDate('<+1M>', EndingPeriod);

        PurchaseValueEntry.SetCurrentKey("Item Ledger Entry No.");
        PurchaseValueEntry.SetRange("Item Ledger Entry No.", NewItemLedgerEntryNo);
        PurchaseValueEntry.SetRange("Item Ledger Entry Type", NewItemLedgerEntryType);
        PurchaseValueEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        if not PurchaseValueEntry.IsEmpty() then begin
            FoundPurchaseValueEntry.SetRange("Item Ledger Entry No.", NewItemLedgerEntryNo);
            FoundPurchaseValueEntry.SetFilter("Posting Date", '%1..%2', CalcDate('<-1M>', StartDate), EndingPeriod);
            exit(not FoundPurchaseValueEntry.IsEmpty());
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

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        TempItemBudgetBuffer: record "Item Budget Buffer" Temporary;
        Period: Code[6];
        EndingPeriod: Date;
        CurrTotal: Integer;
        TotalRecs: Integer;
        Dialog: Dialog;
        EntryTypeFilter: Option " ","P (Main)","C (transit)";
}