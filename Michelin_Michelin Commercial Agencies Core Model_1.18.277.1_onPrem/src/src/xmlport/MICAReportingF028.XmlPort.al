xmlport 80900 "MICA Reporting F028"
{
    Caption = 'Reporting F028';
    Direction = Export;
    Format = FixedText;
    RecordSeparator = '<NewLine>';
    TableSeparator = '<NewLine>';
    UseRequestPage = false;
    TextEncoding = MSDOS;

    schema
    {
        textelement(root)
        {
            tableelement(Block1; Integer)
            {
                XmlName = 'Block1';
                SourceTableView = SORTING(Number);
                textelement(BlockType1)
                {
                    Width = 1;
                }
                textelement(ReceivingCode)
                {
                    Width = 4;
                }
                textelement(CompanyCode)
                {
                    Width = 3;
                }
                textelement(SalesPeriod)
                {
                    Width = 6;
                }
                textelement(ApplicationCode)
                {
                    Width = 6;
                }
                textelement(FileEditionDate)
                {
                    Width = 8;
                }
                textelement(ReportingCurrency)
                {
                    Width = 3;
                }
                textelement(VAL2)
                {
                    Width = 4;
                }
                textelement(TransfertLotNo)
                {
                    Width = 3;
                }
                textelement(Block1Filler)
                {
                    Width = 32;
                }
                trigger OnAfterGetRecord()
                begin
                    BlockType1 := '1';
                    ReceivingCode := 'SGX ';
                    CompanyCode := MICAFinancialReportingSetup."Company Code";
                    SalesPeriod := Period;
                    ApplicationCode := 'VENTIG';
                    FileEditionDate := FORMAT(WORKDATE(), 0, '<Year4><Month,2><Day,2>');
                    if GeneralLedgerSetup."Additional Reporting Currency" = '' THEN
                        ReportingCurrency := GeneralLedgerSetup."LCY Code"
                    else
                        ReportingCurrency := GeneralLedgerSetup."Additional Reporting Currency";
                    VAL2 := 'VAL2';
                    if MICAFinancialReportingSetup."F028 Last Export No." = '' then
                        TransfertLotNo := '001'
                    else
                        TransfertLotNo := INCSTR(MICAFinancialReportingSetup."F028 Last Export No.");
                    Block1Filler := PADSTR(' ', 32);
                end;

                trigger OnPreXmlItem()
                begin
                    Block1.SetRange(Number, 1);
                end;
            }
            tableelement(Block2; Integer)
            {
                XmlName = 'Block2';
                SourceTableView = SORTING(Number);

                textelement(BlockType2)
                {
                    Width = 1;
                }
                textelement(CompanyCode2)
                {
                    Width = 3;
                }
                textelement(CAI)
                {
                    Width = 6;
                }
                textelement(TypeOfRecipient)
                {
                    Width = 1;
                }
                textelement(QuantitySign)
                {
                    Width = 1;
                }
                textelement(Quantity)
                {
                    Width = 6;
                }
                textelement(NetSalesSign)
                {
                    Width = 1;
                }
                textelement(NetSales)
                {
                    Width = 13;
                }
                textelement(CRVSign)
                {
                    Width = 1;
                }
                textelement(CRV)
                {
                    Width = 13;
                }
                textelement(Block2Filler)
                {
                    Width = 24;
                }
                trigger OnAfterGetRecord()
                begin
                    BlockType2 := '2';
                    CAI := TempGrpMICAReportingBuffer.CAI;
                    if TempGrpMICAReportingBuffer."Company Code" <> '' then
                        CompanyCode2 := TempGrpMICAReportingBuffer."Company Code"
                    else
                        CompanyCode2 := MICAFinancialReportingSetup."Company Code";
                    TypeOfRecipient := TempGrpMICAReportingBuffer.Code;
                    if TempGrpMICAReportingBuffer.Quantity < 0 then
                        QuantitySign := '-'
                    else
                        QuantitySign := '+';
                    Quantity := FORMAT(ABS(TempGrpMICAReportingBuffer.Quantity), 0, '<Integer,6><Filler Character,0>');

                    if TempGrpMICAReportingBuffer."Sales Amount" < 0 then
                        NetSalesSign := '-'
                    else
                        NetSalesSign := '+';
                    NetSales := FORMAT(ROUND(TempGrpMICAReportingBuffer."Sales Amount", 1, '='), 0, '<Integer,13><Filler Character,0>');
                    if TempGrpMICAReportingBuffer."Cost Amount" < 0 then
                        CRVSign := '-'
                    else
                        CRVSign := '+';
                    CRV := FORMAT(ROUND(TempGrpMICAReportingBuffer."Cost Amount", 1, '='), 0, '<Integer,13><Filler Character,0>');
                    Block2Filler := PadStr(' ', 24);

                    CurrTotal += 1;
                    Dialog.Update(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
                    TempGrpMICAReportingBuffer.NEXT(1);
                end;

                trigger OnPreXmlItem()
                begin
                    TempGrpMICAReportingBuffer.RESET();
                    TotalLinesBlock2 := TempGrpMICAReportingBuffer.COUNT();

                    Block2.SETFILTER(Number, '%1..%2', 1, TotalLinesBlock2);

                    TotalRecs := TotalLinesBlock2;
                    CurrTotal := 0;

                    IF TempGrpMICAReportingBuffer.FINDSET() THEN;
                end;
            }
            tableelement(Block9; Integer)
            {
                XmlName = 'Block9';
                SourceTableView = SORTING(Number);

                textelement(BlockType9)
                {
                    Width = 1;
                }
                textelement(NumberLinesBlock2)
                {
                    Width = 5;
                }
                textelement(FileLotNo)
                {
                    Width = 3;
                }
                trigger OnAfterGetRecord()
                begin
                    BlockType9 := '9';
                    NumberLinesBlock2 := FORMAT(TotalLinesBlock2, 0, '<Integer,5><Filler Character,0>');
                    FileLotNo := INCSTR(MICAFinancialReportingSetup."F028 Last Export No.");
                end;

                trigger OnPreXmlItem()
                begin
                    Block9.SetRange(Number, 1);
                end;
            }
        }
    }
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempGrpMICAReportingBuffer: record "MICA Reporting Buffer" temporary;
        Period: Code[6];
        StartingPeriod: Date;
        EndingPeriod: Date;
        Dialog: Dialog;
        TotalRecs: Integer;
        CurrTotal: Integer;
        TotalLinesBlock2: Integer;

    trigger OnPreXmlPort()
    var
        MICAReportingBuffer: record "MICA Reporting Buffer";
        DialPhase_Msg: Label 'Phase #1############### \';
        DialProgr_Msg: Label 'Progress @2@@@@@@@@@@';
        DialExportData_Msg: Label 'Export data';
    begin
        StartingPeriod := 0D;
        EndingPeriod := 0D;
        MICAReportingBuffer.CheckPeriodFormat(Period, StartingPeriod, EndingPeriod);

        Dialog.OPEN(DialPhase_Msg + DialProgr_Msg);

        MICAFinancialReportingSetup.RESET();
        MICAFinancialReportingSetup.GET();
        MICAFinancialReportingSetup.TESTFIELD("Company Code");

        GeneralLedgerSetup.GET();
        GeneralLedgerSetup.TESTFIELD("LCY Code");

        PrepareData();
        currXMLport.FILENAME := 'F028_' + MICAFinancialReportingSetup."Company Code" + '_' + Period + '.txt';

        Dialog.UPDATE(1, DialExportData_Msg);
    end;

    trigger OnPostXmlPort()
    begin
        if MICAFinancialReportingSetup."F028 Last Export No." = '' then
            MICAFinancialReportingSetup."F028 Last Export No." := '001'
        else
            MICAFinancialReportingSetup."F028 Last Export No." := CopyStr(INCSTR(MICAFinancialReportingSetup."F028 Last Export No."), 1, 3);
        MICAFinancialReportingSetup.MODIFY();
        Dialog.close();
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

    local procedure PrepareData()
    var
        ValueEntry: Record "Value Entry";
        Item: Record Item;
        Customer: Record Customer;
        myMICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        DefaultDimension: Record "Default Dimension";
        BufferEntryNo: Integer;
    begin
        TempGrpMICAReportingBuffer.RESET();
        TempGrpMICAReportingBuffer.DELETEALL();

        BufferEntryNo := 0;

        ValueEntry.RESET();
        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntry.SETRANGE("Posting Date", StartingPeriod, EndingPeriod);
        ValueEntry.SetFilter("Document Type", '%1|%2', ValueEntry."Document Type"::"Sales Invoice", ValueEntry."Document Type"::"Sales Credit Memo");
        IF ValueEntry.FINDSET(FALSE, FALSE) THEN
            REPEAT
                Item.GET(ValueEntry."Item No.");
                Customer.GET(ValueEntry."Source No.");
                IF (NOT Item."MICA Exclude from Report. Grp.") THEN
                    IF Customer."MICA Party Ownership" = Customer."MICA Party Ownership"::Group THEN BEGIN
                        TempGrpMICAReportingBuffer.Reset();
                        TempGrpMICAReportingBuffer.SetRange(CAI, COPYSTR(ValueEntry."Item No.", 1, 6));
                        if not TempGrpMICAReportingBuffer.FindFirst() then begin
                            BufferEntryNo += 1;
                            TempGrpMICAReportingBuffer.INIT();
                            TempGrpMICAReportingBuffer."Entry No." := BufferEntryNo;
                            TempGrpMICAReportingBuffer.CAI := COPYSTR(ValueEntry."Item No.", 1, 6);

                            if myMICAFinancialReportingSetup.Get() then
                                if DefaultDimension.Get(Database::Customer, Customer."No.", myMICAFinancialReportingSetup."Intercompany Dimension") then
                                    TempGrpMICAReportingBuffer."Company Code" := CopyStr(DefaultDimension."Dimension Value Code", 1, MaxStrLen(TempGrpMICAReportingBuffer."Company Code"));

                            CASE Customer."MICA Market Code" OF
                                '10':
                                    TempGrpMICAReportingBuffer.code := '1';
                                '20':
                                    TempGrpMICAReportingBuffer.code := '2';
                                '99':
                                    TempGrpMICAReportingBuffer.Code := ' ';
                            END;
                            TempGrpMICAReportingBuffer.INSERT();

                            UpdateReportingGrpBufferAmounts(TempGrpMICAReportingBuffer, ValueEntry, true);
                        end else
                            UpdateReportingGrpBufferAmounts(TempGrpMICAReportingBuffer, ValueEntry, false);
                    END;
            UNTIL ValueEntry.NEXT() = 0;
    end;

    local procedure UpdateReportingGrpBufferAmounts(var TempMICAReportingBuffer: Record "MICA Reporting Buffer"; ValueEntry: Record "Value Entry"; InsertOrUpdate: Boolean)
    begin
        if InsertOrUpdate then begin
            TempMICAReportingBuffer.Quantity := -ValueEntry."Invoiced Quantity";
            TempMICAReportingBuffer."Cost Amount" := -ValueEntry."Cost Amount (Actual)";
            TempMICAReportingBuffer."Sales Amount" := ValueEntry."Sales Amount (Actual)";
        end else begin
            TempMICAReportingBuffer.Quantity += -ValueEntry."Invoiced Quantity";
            TempMICAReportingBuffer."Cost Amount" += -ValueEntry."Cost Amount (Actual)";
            TempMICAReportingBuffer."Sales Amount" += ValueEntry."Sales Amount (Actual)";
        end;
        TempMICAReportingBuffer.MODIFY();
    end;
}