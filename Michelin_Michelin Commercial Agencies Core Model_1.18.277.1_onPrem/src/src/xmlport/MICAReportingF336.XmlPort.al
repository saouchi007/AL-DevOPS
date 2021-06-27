xmlport 81940 "MICA Reporting F336"
{
    Caption = 'Reporting F336';
    Direction = Export;
    Format = FixedText;
    RecordSeparator = '<CR/LF>';
    TableSeparator = '<CR/LF>';
    UseRequestPage = false;
    TextEncoding = WINDOWS;
    schema
    {
        textelement(root)
        {
            tableelement(Block1; Integer)
            {
                XmlName = 'Block1';
                SourceTableView = sorting(Number);
                textelement(BlockType1)
                {
                    Width = 1;
                }
                textelement(ApplicationCode)
                {
                    Width = 6;
                }
                textelement(SalesPeriod)
                {
                    Width = 6;
                }
                textelement(CommercialOrgCode)
                {
                    Width = 2;
                }
                textelement(Filler1)
                {
                    Width = 2;
                }
                textelement(TypeOfSalesFile)
                {
                    Width = 4;
                }
                textelement(FileEditionDate)
                {
                    Width = 8;
                }
                textelement(LocalCurrency)
                {
                    Width = 3;
                }
                textelement(Block1Filler)
                {
                    Width = 88;
                }
                trigger OnAfterGetRecord()
                begin
                    BlockType1 := '1';
                    ApplicationCode := 'VENTES';
                    SalesPeriod := Period;
                    CommercialOrgCode := MICAFinancialReportingSetup."Commercial Organization Code";
                    Filler1 := PADSTR(' ', 2);
                    TypeOfSalesFile := Format(Type);
                    FileEditionDate := FORMAT(WORKDATE(), 0, '<Year4><Month,2><Day,2>');
                    LocalCurrency := GeneralLedgerSetup."LCY Code";
                    Block1Filler := PADSTR(' ', 88);
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
                textelement(CAI)
                {
                    Width = 6;
                }
                textelement(CountryOfSale)
                {
                    Width = 3;
                }
                textelement(MarketCode)
                {
                    Width = 2;
                }
                textelement(ClientCode)
                {
                    Width = 5;
                }
                textelement(QuantitySign)
                {
                    Width = 1;
                }
                textelement(Quantity)
                {
                    Width = 7;
                }
                textelement(NetTurnoverSign)
                {
                    Width = 1;
                }
                textelement(NetTurnoverInvoiced)
                {
                    Width = 13;
                }
                textelement(GrossAnnualTurnoverSign)
                {
                    Width = 1;
                }
                textelement(GrossAnnualTurnover)
                {
                    Width = 13;
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
                textelement(NetSalesSignInTheInvoicedCurrency)
                {
                    Width = 1;
                }
                textelement(NetSalesInTheInvoicedCurrency)
                {
                    Width = 13;
                }
                textelement(InvoicingCurrency)
                {
                    Width = 3;
                }
                textelement(CompanyCodeForNetworkSales)
                {
                    Width = 3;
                }
                textelement(Block2Filler)
                {
                    Width = 19;
                }
                trigger OnPreXmlItem()
                begin
                    TempMICAF336Buffer.RESET();
                    TotalLinesBlock2 := TempMICAF336Buffer.COUNT();

                    Block2.SETFILTER(Number, '%1..%2', 1, TotalLinesBlock2);

                    TotalRecs := TotalLinesBlock2;
                    CurrTotal := 0;

                    IF TempMICAF336Buffer.FINDSET() THEN;
                end;

                trigger OnAfterGetRecord()
                begin
                    BlockType2 := '2';
                    CAI := TempMICAF336Buffer."Item No.";
                    CountryOfSale := TempMICAF336Buffer."Country-of Sales";
                    MarketCode := TempMICAF336Buffer."Market Code";
                    ClientCode := TempMICAF336Buffer."Client Code";
                    if TempMICAF336Buffer.Quantity < 0 then
                        QuantitySign := '-'
                    else
                        QuantitySign := '+';
                    Quantity := FORMAT(ABS(TempMICAF336Buffer.Quantity), 0, '<Integer,7><Filler Character,0>');

                    if TempMICAF336Buffer."Net Turnover Invoiced" < 0 then
                        NetTurnoverSign := '-'
                    else
                        NetTurnoverSign := '+';
                    NetTurnoverInvoiced := FORMAT(ROUND(TempMICAF336Buffer."Net Turnover Invoiced", 1, '='), 0, '<Integer,13><Filler Character,0>');

                    if TempMICAF336Buffer."Gross Annual Turnover" < 0 then
                        GrossAnnualTurnoverSign := '-'
                    else
                        GrossAnnualTurnoverSign := '+';
                    GrossAnnualTurnover := FORMAT(ROUND(TempMICAF336Buffer."Gross Annual Turnover", 1, '='), 0, '<Integer,13><Filler Character,0>');

                    if TempMICAF336Buffer."Net Sales" < 0 then
                        NetSalesSign := '-'
                    else
                        NetSalesSign := '+';
                    NetSales := FORMAT(ROUND(TempMICAF336Buffer."Net Sales", 1, '='), 0, '<Integer,13><Filler Character,0>');

                    if TempMICAF336Buffer.CRV < 0 then
                        CRVSign := '-'
                    else
                        CRVSign := '+';
                    CRV := FORMAT(ROUND(TempMICAF336Buffer.CRV, 1, '='), 0, '<Integer,13><Filler Character,0>');

                    if TempMICAF336Buffer."Net Sales In The Inv. Currency" < 0 then
                        NetSalesSignInTheInvoicedCurrency := '-'
                    else
                        NetSalesSignInTheInvoicedCurrency := '+';
                    NetSalesInTheInvoicedCurrency := FORMAT(ROUND(TempMICAF336Buffer."Net Sales In The Inv. Currency", 1, '='), 0, '<Integer,13><Filler Character,0>');

                    InvoicingCurrency := TempMICAF336Buffer."Invoicing Currency";
                    IF InvoicingCurrency = '' then
                        InvoicingCurrency := GeneralLedgerSetup."LCY Code";

                    CompanyCodeForNetworkSales := TempMICAF336Buffer."Intercompany Dimension";

                    Block2Filler := PadStr(' ', 19);

                    CurrTotal += 1;
                    Dialog.Update(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
                    TempMICAF336Buffer.NEXT(1);
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
                trigger OnAfterGetRecord()
                begin
                    BlockType9 := '9';
                    NumberLinesBlock2 := FORMAT(TotalLinesBlock2, 0, '<Integer,5><Filler Character,0>');
                end;

                trigger OnPreXmlItem()
                begin
                    Block9.SetRange(Number, 1);
                end;
            }
        }
    }

    var
        TempMICAF336Buffer: Record "MICA F336 Buffer" temporary;
        GeneralLedgerSetup: Record "General Ledger Setup";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        TotalLinesBlock2: Integer;
        Dialog: Dialog;
        Period: Code[6];
        StartingPeriod: Date;
        EndingPeriod: Date;
        Type: Option "VAL0","VAL2";
        TotalRecs: Integer;
        CurrTotal: Integer;

    trigger OnPreXmlPort()
    var
        MICAReportingBuffer: record "MICA Reporting Buffer";
        DialPhase_Msg: Label 'Phase #1############### \';
        DialProgr_Msg: Label 'Progress @2@@@@@@@@@@';
        DialExportData_Msg: Label 'Export data';
    begin
        clear(StartingPeriod);
        clear(EndingPeriod);
        MICAReportingBuffer.CheckPeriodFormat(Period, StartingPeriod, EndingPeriod);

        MICAFinancialReportingSetup.Get();
        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TestField("LCY Code");

        PrepareData();

        Dialog.OPEN(DialPhase_Msg + DialProgr_Msg);
        Dialog.UPDATE(1, DialExportData_Msg);
        currXMLport.FILENAME := 'F336' + Format(Type) + '_' + MICAFinancialReportingSetup."Company Code" + '_' + Period + '.txt';
    end;

    trigger OnPostXmlPort()
    begin
        if MICAFinancialReportingSetup."F336 Last Export No." = '' then
            MICAFinancialReportingSetup."F336 Last Export No." := '001'
        else
            MICAFinancialReportingSetup."F336 Last Export No." := CopyStr(INCSTR(MICAFinancialReportingSetup."F336 Last Export No."), 1, 3);
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

    procedure InitType(NewType: Option)
    begin
        Type := NewType;
    end;

    procedure PrepareData()
    var
        MICAReportF336Mgt: Codeunit "MICA Report F336 Mgt.";
    begin
        MICAReportF336Mgt.SetPeriod(StartingPeriod, EndingPeriod);
        MICAReportF336Mgt.SetType(Type);
        MICAReportF336Mgt.GetF336Data(TempMICAF336Buffer);
        TempMICAF336Buffer.Reset();
    end;

    procedure GetF336Buffer(var MICAF336Buffer: Record "MICA F336 Buffer")
    begin
        MICAF336Buffer.Reset();
        MICAF336Buffer.DeleteAll();

        TempMICAF336Buffer.Reset();
        IF TempMICAF336Buffer.FindSet() then
            repeat
                MICAF336Buffer := TempMICAF336Buffer;
                MICAF336Buffer.Insert();
            until TempMICAF336Buffer.Next() = 0;
    end;
}