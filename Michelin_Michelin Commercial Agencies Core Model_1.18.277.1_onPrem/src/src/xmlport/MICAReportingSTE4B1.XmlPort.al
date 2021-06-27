xmlport 81020 "MICA Reporting STE4B1"
{
    Caption = 'STE4B1 Export';
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
            tableelement(Block2; Integer)
            {
                SourceTableView = sorting(Number) order(ascending);
                textelement(PeriodExport)
                {

                }
                Textelement(Company)
                {

                }
                textelement(CurrencyCode)
                {

                }
                textelement(Indicator)
                {

                }
                textelement(LBExport)
                {

                }
                textelement(MarketExport)
                {

                }
                textelement(ValueExport)
                {

                }
                trigger OnPreXmlItem()
                var
                    TextNoData_Err: Label 'No data to export.';
                begin
                    MICAReportingBuffer.RESET();
                    MICAReportingBuffer.SetCurrentKey(UserId);
                    MICAReportingBuffer.SetRange(UserId, Database.UserId());
                    MICAReportingBuffer.Setfilter("Sales Amount", '<>0');
                    Block2.SetFilter(Number, '%1..%2', 1, MICAReportingBuffer.Count());
                    TotalRecs := MICAReportingBuffer.COUNT();
                    CurrTotal := 0;

                    IF NOT MICAReportingBuffer.FINDSET(FALSE, FALSE) THEN
                        MESSAGE(TextNoData_Err);
                end;

                trigger OnAfterGetRecord()
                var
                    TextNegSignTxt: label '-';
                begin
                    PeriodExport := Period;
                    Company := MICAFinancialReportingSetup."Company Code";
                    CurrencyCode := GeneralLedgerSetup."LCY Code";
                    Indicator := MICAReportingBuffer."Cust. Cr. Indicator";
                    LBExport := MICAReportingBuffer.Structure;
                    LBExport := LBExport + CopyStr(MICAFinancialReportingSetup."STE4 Region Code", 1, 1);
                    LBExport := LBExport + CopyStr(MICAFinancialReportingSetup."STE4 Region Code", StrLen(MICAFinancialReportingSetup."STE4 Region Code"), 1);
                    MarketExport := MICAReportingBuffer.Section;

                    IF (MICAReportingBuffer."Sales Amount" >= 0) or (MICAReportingBuffer."Cust. Cr. Indicator" = 'PROV') THEN
                        ValueExport := FORMAT(MICAReportingBuffer."Sales Amount", 0, '<Integer>')
                    ELSE
                        ValueExport := TextNegSignTxt + FORMAT(MICAReportingBuffer."Sales Amount", 0, '<Integer>');
                    CurrTotal += 1;

                    Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));

                    MICAReportingBuffer.NEXT(1);
                end;
            }
        }
    }
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
        GeneralLedgerSetup: Record "General Ledger Setup";
        MICAReportingBuffer: Record "MICA Reporting Buffer";
        Period: Code[6];
        CurrTotal: Integer;
        TotalRecs: Integer;
        Dialog: Dialog;


    trigger OnPreXmlPort()
    var
        DialPhase_Msg: Label 'Phase #1############### \';
        DialProgr_Msg: Label 'Progress @2@@@@@@@@@@';
        DialExportData_Msg: Label 'Export data';
    begin
        MICAFinancialReportingSetup.GET();
        MICAFinancialReportingSetup.TestField("Company Code");
        MICAFinancialReportingSetup.TestField("STE4 Region Code");

        GeneralLedgerSetup.GET();
        GeneralLedgerSetup.TestField("LCY Code");

        Dialog.OPEN(DialPhase_Msg + DialProgr_Msg);
        Dialog.UPDATE(1, DialExportData_Msg);

        currXMLport.FILENAME := 'STE4B1_' + MICAFinancialReportingSetup."Company Code" + '_' + Period + '.csv';
    end;

    trigger OnPostXmlPort()
    begin
        Dialog.close();
    end;
}