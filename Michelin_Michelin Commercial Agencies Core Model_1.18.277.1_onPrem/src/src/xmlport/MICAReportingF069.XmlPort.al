xmlport 80680 "MICA Reporting F069"
{
    Caption = 'Reporting F069';
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
            tableelement(TempVendor; Vendor)
            {
                XmlName = 'Vendor';
                SourceTableView = sorting("No.");
                UseTemporary = true;

                tableelement(Block1; Integer)
                {
                    XmlName = 'Block1';
                    SourceTableView = SORTING(Number);

                    textelement(BlockType1)
                    {
                        Width = 1;
                    }
                    textelement(ReceiverCode)
                    {
                        Width = 4;
                    }
                    textelement(VendorNo)
                    {
                        Width = 3;
                    }
                    textelement(PurchasePeriod)
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
                    textelement(LocalCurrency)
                    {
                        Width = 3;
                    }
                    textelement(CompanyCode)
                    {
                        Width = 3;
                    }
                    textelement(TransferLotNo)
                    {
                        Width = 3;
                    }
                    textelement(Block1Filler)
                    {
                        Width = 13;
                    }
                    trigger OnAfterGetRecord()
                    begin
                        BlockType1 := '1';
                        ReceiverCode := 'SGX ';
                        VendorNo := TempVendor."No.";
                        PurchasePeriod := Period;
                        ApplicationCode := 'ACHATS';
                        FileEditionDate := FORMAT(WORKDATE(), 0, '<Year4><Month,2><Day,2>');
                        LocalCurrency := GeneralLedgerSetup."LCY Code";
                        CompanyCode := MICAFinancialReportingSetup."Company Code";
                        TransferLotNo := '001';
                        Block1Filler := PADSTR(' ', 13);
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
                    textelement(QuantitySign)
                    {
                        Width = 1;
                    }
                    textelement(Quantity)
                    {
                        Width = 6;
                    }
                    textelement(AmountSign)
                    {
                        Width = 1;
                    }
                    textelement(Amount)
                    {
                        Width = 13;
                    }
                    textelement(Block2Filler)
                    {
                        Width = 22;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        BlockType2 := '2';
                        CAI := TempGrpMICAReportingBuffer.CAI;
                        if TempGrpMICAReportingBuffer.Quantity < 0 then
                            QuantitySign := '-'
                        else
                            QuantitySign := '+';
                        Quantity := FORMAT(ABS(TempGrpMICAReportingBuffer.Quantity), 0, '<Integer,6><Filler Character,0>');
                        if TempGrpMICAReportingBuffer."Cost Amount" < 0 then
                            AmountSign := '-'
                        else
                            AmountSign := '+';
                        Amount := FORMAT(ROUND(TempGrpMICAReportingBuffer."Cost Amount", 1, '='), 0, '<Integer,13><Filler Character,0>');
                        Block2Filler := PadStr(' ', 22);

                        CurrTotal += 1;
                        Dialog.Update(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
                        TempGrpMICAReportingBuffer.NEXT(1);
                    end;

                    trigger OnPreXmlItem()
                    begin
                        TempGrpMICAReportingBuffer.RESET();
                        TempGrpMICAReportingBuffer.SETCURRENTKEY("Supplier Code", CAI);
                        TempGrpMICAReportingBuffer.SETRANGE("Supplier Code", TempVendor."No.");
                        TotalLinesBlock2 := TempGrpMICAReportingBuffer.COUNT();

                        Block2.SETFILTER(Number, '%1..%2', 1, TotalLinesBlock2);

                        TotalRecs := TotalLinesBlock2;
                        CurrTotal := 0;

                        TempGrpMICAReportingBuffer.FINDSET();
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
                        FileLotNo := '001';
                    end;

                    trigger OnPreXmlItem()
                    begin
                        Block9.SetRange(Number, 1);
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    totalLinesBlock2 := 0;
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
        MICAFinancialReportingSetup.TestField("Intercompany Dimension");

        GeneralLedgerSetup.GET();
        GeneralLedgerSetup.TESTFIELD("LCY Code");

        PrepareData();

        Dialog.UPDATE(1, DialExportData_Msg);

        currXMLport.Filename := Period + '_' + MICAFinancialReportingSetup."Company Code" + '_F069.txt';
    end;

    trigger OnPostXmlPort()
    begin
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
        ItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
        Vendor: Record Vendor;
        //DefDim: Record "Default Dimension";
        BufferEntryNo: Integer;
    begin
        TempGrpMICAReportingBuffer.RESET();
        TempGrpMICAReportingBuffer.DELETEALL();

        TempVendor.RESET();
        TempVendor.DELETEALL();

        BufferEntryNo := 0;

        ItemLedgerEntry.RESET();
        ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SETRANGE("Posting Date", StartingPeriod, EndingPeriod);
        ItemLedgerEntry.SETAUTOCALCFIELDS("Cost Amount (Actual)", "Cost Amount (Expected)");
        IF ItemLedgerEntry.FINDSET(FALSE, FALSE) THEN
            REPEAT
                Item.GET(ItemLedgerEntry."Item No.");
                Vendor.GET(ItemLedgerEntry."Source No.");
                IF (NOT Item."MICA Exclude from Report. Grp.") THEN
                    //IF NOT DefDim.GET(DATABASE::Vendor, Vend."No.", FinSetup."Intercompany Dimension") THEN 
                    IF Vendor."MICA Party Ownership" = Vendor."MICA Party Ownership"::"Non Group" THEN BEGIN
                        TempGrpMICAReportingBuffer.RESET();
                        TempGrpMICAReportingBuffer.SETCURRENTKEY("Supplier Code", CAI);
                        TempGrpMICAReportingBuffer.SETRANGE("Supplier Code", Vendor."MICA Offtaker Code");
                        TempGrpMICAReportingBuffer.SETRANGE(CAI, COPYSTR(ItemLedgerEntry."Item No.", 1, 6));
                        IF NOT TempGrpMICAReportingBuffer.FINDFIRST() THEN BEGIN
                            BufferEntryNo += 1;
                            TempGrpMICAReportingBuffer.INIT();
                            TempGrpMICAReportingBuffer."Entry No." := BufferEntryNo;
                            TempGrpMICAReportingBuffer."Supplier Code" := Vendor."MICA Offtaker Code";
                            TempGrpMICAReportingBuffer.CAI := COPYSTR(ItemLedgerEntry."Item No.", 1, 6);
                            TempGrpMICAReportingBuffer.INSERT();

                            TempVendor.RESET();
                            IF NOT TempVendor.GET(Vendor."MICA Offtaker Code") THEN BEGIN
                                TempVendor.INIT();
                                TempVendor."No." := Vendor."MICA Offtaker Code";
                                TempVendor.INSERT();
                            END;
                        END;
                        TempGrpMICAReportingBuffer.Quantity += ItemLedgerEntry.Quantity;
                        TempGrpMICAReportingBuffer."Cost Amount" += ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)";
                        TempGrpMICAReportingBuffer.MODIFY();
                    END;
            //end;
            UNTIL ItemLedgerEntry.NEXT() = 0;
    end;
}