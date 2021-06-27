xmlport 80660 "MICA Reporting FLUX2"
{
    Caption = 'Reporting FLUX2';
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
            tableelement(TempFlux2BufferG0; "MICA FLUX2 Buffer2")
            {
                XmlName = 'Block2G0';
                UseTemporary = true;

                textelement(BlocTypeBlock2G0)
                {
                    Width = 2;
                }
                textelement(ConsolidationTypeBlock2G0)
                {
                    Width = 3;
                }
                textelement(ConsolidationDateBlock2G0)
                {
                    Width = 8;
                }
                textelement(CompanyCodeBlock2G0)
                {
                    Width = 3;
                }
                textelement(TypeBlock2G0)
                {
                    Width = 1;
                }
                textelement(AccountNoBlock2G0)
                {
                    Width = 4;
                }
                textelement(DebitCreditBlock2G0)
                {
                    Width = 1;
                }
                textelement(CodeBlock2G0)
                {
                    Width = 1;
                }
                textelement(IntercoBlock2G0)
                {
                    Width = 3;
                }
                textelement(AmountLCYBlock2G0)
                {
                    Width = 18;
                }
                textelement(InvoiceCurrencyBlock2G0)
                {
                    Width = 3;
                }
                textelement(InvoiceAmountBlock2G0)
                {
                    Width = 18;
                }
                textelement(SectionBlock2G0)
                {
                    Width = 12;
                }
                textelement(StructureBlock2G0)
                {
                    Width = 8;
                }
                textelement(FillerBlock2G0)
                {
                    Width = 43;
                }
                trigger OnAfterGetRecord()
                begin
                    CurrTotal += 1;
                    Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));

                    BlocTypeBlock2G0 := '40';
                    ConsolidationTypeBlock2G0 := '001';
                    ConsolidationDateBlock2G0 := FORMAT(TempFlux2BufferG0."Consolidation Date", 0, '<Year4><Month,2><Day,2>');
                    CompanyCodeBlock2G0 := TempFlux2BufferG0."Company Code";
                    TypeBlock2G0 := 'G';

                    AccountNoBlock2G0 := TempFlux2BufferG0."Group Account No.";

                    IF TempFlux2BufferG0."Amount LCY" > 0 THEN
                        DebitCreditBlock2G0 := '1'
                    ELSE
                        DebitCreditBlock2G0 := '2';

                    CodeBlock2G0 := '0';
                    IntercoBlock2G0 := '000';

                    AmountLCYBlock2G0 := CONVERTSTR(FORMAT(TempFlux2BufferG0."Amount LCY", 0, '<Integer,15><Filler Character, >') +
                                            FORMAT(TempFlux2BufferG0."Amount LCY", 0, '<Decimal,3>'), ',', '.');

                    //InvoiceCurrencyBlock2G0 := TempFlux2BufferG0."Invoice Currency";
                    //IF InvoiceCurrencyBlock2G0 = GLSetup."LCY Code" then
                    InvoiceCurrencyBlock2G0 := '';
                    TempFlux2BufferG0."Invoice Amount" := 0;
                    InvoiceAmountBlock2G0 := CONVERTSTR(FORMAT(TempFlux2BufferG0."Invoice Amount", 0, '<Integer,15><Filler Character, >') +
                                            FORMAT(TempFlux2BufferG0."Invoice Amount", 0, '<Decimal,3>'), ',', '.');

                    SectionBlock2G0 := TempFlux2BufferG0.Section;
                    StructureBlock2G0 := CopyStr(TempFlux2BufferG0.Structure, 1, 8);

                    FillerBlock2G0 := '';
                end;

                trigger OnPreXmlItem()
                var
                    DialText01_Msg: Label 'Export data Flux 2 Code 0';
                begin
                    Dialog.UPDATE(1, DialText01_Msg);

                    TempFlux2BufferG0.RESET();
                    TempFlux2BufferG0.SETFILTER("Group Account No.", '<>%1', '');
                    TempFlux2BufferG0.SETFILTER("Amount LCY", '<>0');

                    TotalRecs := TempFlux2BufferG0.COUNT();
                    CurrTotal := 0;
                end;
            }
            tableelement(TempFlux2BufferG1; "MICA FLUX2 Buffer2")
            {
                XmlName = 'Block2G1';
                UseTemporary = true;

                textelement(BlocTypeBlock2G1)
                {
                    Width = 2;
                }
                textelement(ConsolidationTypeBlock2G1)
                {
                    Width = 3;
                }
                textelement(ConsolidationDateBlock2G1)
                {
                    Width = 8;
                }
                textelement(CompanyCodeBlock2G1)
                {
                    Width = 3;
                }
                textelement(TypeBlock2G1)
                {
                    Width = 1;
                }
                textelement(AccountNoBlock2G1)
                {
                    Width = 4;
                }
                textelement(DebitCreditBlock2G1)
                {
                    Width = 1;
                }
                textelement(CodeBlock2G1)
                {
                    Width = 1;
                }
                textelement(IntercoBlock2G1)
                {
                    Width = 3;
                }
                textelement(AmountLCYBlock2G1)
                {
                    Width = 18;
                }
                textelement(InvoiceCurrencyBlock2G1)
                {
                    Width = 3;
                }
                textelement(InvoiceAmountBlock2G1)
                {
                    Width = 18;
                }
                textelement(SectionBlock2G1)
                {
                    Width = 12;
                }
                textelement(StructureBlock2G1)
                {
                    Width = 8;
                }
                textelement(FillerBlock2G1)
                {
                    Width = 43;
                }
                trigger OnAfterGetRecord()
                begin
                    CurrTotal += 1;
                    Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));

                    BlocTypeBlock2G1 := '40';
                    ConsolidationTypeBlock2G1 := '001';
                    ConsolidationDateBlock2G1 := FORMAT(TempFlux2BufferG1."Consolidation Date", 0, '<Year4><Month,2><Day,2>');
                    CompanyCodeBlock2G1 := TempFlux2BufferG1."Company Code";
                    TypeBlock2G1 := 'G';
                    AccountNoBlock2G1 := TempFlux2BufferG1."Group Account No.";
                    IF TempFlux2BufferG1."Amount LCY" > 0 THEN
                        DebitCreditBlock2G1 := '1'
                    ELSE
                        DebitCreditBlock2G1 := '2';

                    CodeBlock2G1 := '1';
                    IntercoBlock2G1 := CopyStr(TempFlux2BufferG1.Interco, 1, 3);
                    AmountLCYBlock2G1 := CONVERTSTR(FORMAT(TempFlux2BufferG1."Amount LCY", 0, '<Integer,15><Filler Character, >') +
                                          FORMAT(TempFlux2BufferG1."Amount LCY", 0, '<Decimal,3>'), ',', '.');
                    InvoiceCurrencyBlock2G1 := TempFlux2BufferG1."Invoice Currency";
                    InvoiceAmountBlock2G1 := CONVERTSTR(FORMAT(TempFlux2BufferG1."Invoice Amount", 0, '<Integer,15><Filler Character, >') +
                                               FORMAT(TempFlux2BufferG1."Invoice Amount", 0, '<Decimal,3>'), ',', '.');
                    SectionBlock2G1 := TempFlux2BufferG1.Section;
                    StructureBlock2G1 := CopyStr(TempFlux2BufferG1.Structure, 1, 8);
                    FillerBlock2G1 := '';
                end;

                trigger OnPreXmlItem()
                var
                    DialText01_Msg: Label 'Export data Flux 2 Code 1';
                begin
                    Dialog.UPDATE(1, DialText01_Msg);

                    TempFlux2BufferG1.RESET();
                    TempFlux2BufferG1.SETFILTER("Group Account No.", '<>%1', '');
                    TempFlux2BufferG1.SETFILTER("Amount LCY", '<>0');

                    TotalRecs := TempFlux2BufferG1.COUNT();
                    CurrTotal := 0;
                end;
            }
            tableelement(TempFlux2BufferG3; "MICA FLUX2 Buffer2")
            {
                XmlName = 'Block2G3';
                UseTemporary = true;

                textelement(BlocTypeBlock2G3)
                {
                    Width = 2;
                }
                textelement(ConsolidationTypeBlock2G3)
                {
                    Width = 3;
                }
                textelement(ConsolidationDateBlock2G3)
                {
                    Width = 8;
                }
                textelement(CompanyCodeBlock2G3)
                {
                    Width = 3;
                }
                textelement(TypeBlock2G3)
                {
                    Width = 1;
                }
                textelement(AccountNoBlock2G3)
                {
                    Width = 4;
                }
                textelement(DebitCreditBlock2G3)
                {
                    Width = 1;
                }
                textelement(CodeBlock2G3)
                {
                    Width = 1;
                }
                textelement(IntercoBlock2G3)
                {
                    Width = 3;
                }
                textelement(AmountLCYBlock2G3)
                {
                    Width = 18;
                }
                textelement(InvoiceCurrencyBlock2G3)
                {
                    Width = 3;
                }
                textelement(InvoiceAmountBlock2G3)
                {
                    Width = 18;
                }
                textelement(SectionBlock2G3)
                {
                    Width = 12;
                }
                textelement(StructureBlock2G3)
                {
                    Width = 8;
                }
                textelement(FillerBlock2G3)
                {
                    Width = 43;
                }


                trigger OnAfterGetRecord()
                begin
                    CurrTotal += 1;
                    Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));

                    BlocTypeBlock2G3 := '40';
                    ConsolidationTypeBlock2G3 := '001';
                    ConsolidationDateBlock2G3 := FORMAT(TempFlux2BufferG3."Consolidation Date", 0, '<Year4><Month,2><Day,2>');
                    CompanyCodeBlock2G3 := TempFlux2BufferG3."Company Code";
                    TypeBlock2G3 := 'G';
                    AccountNoBlock2G3 := TempFlux2BufferG3."Group Account No.";
                    IF TempFlux2BufferG3."Amount LCY" > 0 THEN
                        DebitCreditBlock2G3 := '1'
                    ELSE
                        DebitCreditBlock2G3 := '2';

                    CodeBlock2G3 := '3';
                    IntercoBlock2G3 := CopyStr(TempFlux2BufferG3.Interco, 1, 3);
                    AmountLCYBlock2G3 := CONVERTSTR(FORMAT(TempFlux2BufferG3."Amount LCY", 0, '<Integer,15><Filler Character, >') +
                                          FORMAT(TempFlux2BufferG3."Amount LCY", 0, '<Decimal,3>'), ',', '.');
                    InvoiceCurrencyBlock2G3 := TempFlux2BufferG3."Invoice Currency";
                    InvoiceAmountBlock2G3 := CONVERTSTR(FORMAT(TempFlux2BufferG3."Invoice Amount", 0, '<Integer,15><Filler Character, >') +
                                               FORMAT(TempFlux2BufferG3."Invoice Amount", 0, '<Decimal,3>'), ',', '.');
                    SectionBlock2G3 := '';  //TempFlux2BufferG3.Section;
                    StructureBlock2G3 := '';    //CopyStr(TempFlux2BufferG3.Structure, 1, 8);
                    FillerBlock2G3 := '';
                end;

                trigger OnPreXmlItem()
                var
                    DialText_Msg: Label 'Export data Flux 2 Code 3';
                begin
                    Dialog.UPDATE(1, DialText_Msg);

                    TempFlux2BufferG3.RESET();
                    TempFlux2BufferG3.SETFILTER("Group Account No.", '<>%1', '');
                    TempFlux2BufferG3.SETFILTER("Amount LCY", '<>0');

                    TotalRecs := TempFlux2BufferG3.COUNT();
                    CurrTotal := 0;
                end;
            }
        }
    }
    trigger OnPreXmlPort()
    var
        DialPhase_Msg: Label 'Phase #1############### \';
        DialProgr_Msg: Label 'Progress @2@@@@@@@@@@';
    begin
        Dialog.OPEN(DialPhase_Msg + DialProgr_Msg);

        MICAFinancialReportingSetup.Get();
        MICAFinancialReportingSetup.TestField("Non Group Interco Code");

        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TestField("LCY Code");

        PrepareData();

        currXMLport.FILENAME := 'FLUX2_' + MICAFinancialReportingSetup."Company Code" + '_' + Period + '.txt';
    end;

    trigger OnPostXmlPort()
    begin
        Dialog.Close();
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Period: Code[6];
        Dialog: Dialog;
        TotalRecs: Integer;
        CurrTotal: Integer;

    local procedure PrepareData()
    var
        GLAccount: Record "G/L Account";
        MICAFLUX2Buffer: Record "MICA FLUX2 Buffer2";
        DialText_Lbl: Label 'Prepare data Flux 2 Code 0, Code 1 and Code 3';
    begin
        TempFlux2BufferG0.DELETEALL();
        TempFlux2BufferG1.DELETEALL();
        TempFlux2BufferG3.DELETEALL();

        Dialog.UPDATE(1, DialText_Lbl);
        MICAFLUX2Buffer.Reset();
        TotalRecs := MICAFLUX2Buffer.COUNT();
        MICAFLUX2Buffer.FindSet();
        Period := Format(MICAFLUX2Buffer."Consolidation Date", 0, '<Year4><Month,2>');
        repeat
            TempFlux2BufferG0 := MICAFLUX2Buffer;
            TempFlux2BufferG0.Insert();

            IF MICAFLUX2Buffer.Interco <> MICAFinancialReportingSetup."Non Group Interco Code" then begin
                TempFlux2BufferG1 := MICAFLUX2Buffer;
                TempFlux2BufferG1.Insert();
            end else
                if (MICAFLUX2Buffer."Invoice Currency" <> GeneralLedgerSetup."LCY Code") then begin
                    GLAccount.Get(MICAFLUX2Buffer."G/L Account");
                    if GLAccount."MICA Incl. on Flux2 Code3 Rpt." then begin
                        TempFlux2BufferG3 := MICAFLUX2Buffer;
                        TempFlux2BufferG3.Insert();
                    end;
                end;
            CurrTotal += 1;
            Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
        until MICAFLUX2Buffer.Next() = 0;
    END;
}