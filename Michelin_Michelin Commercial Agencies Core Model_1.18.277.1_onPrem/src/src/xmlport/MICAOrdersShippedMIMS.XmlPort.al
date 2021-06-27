xmlport 81360 "MICA Orders Shipped MIMS"
{
    Caption = 'Orders Shipped MIMS';
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
            tableelement(HeaderLine; Integer)
            {

                XmlName = 'Header';
                SourceTableView = SORTING(Number)
                                  WHERE(Number = CONST(1));
                textelement(StartBlock)
                {
                    Width = 1;
                }

                textelement(FileType)
                {
                    Width = 6;
                }

                textelement(ReferenceMonth)
                {
                    Width = 6;
                }
                textelement(CountryCode)
                {
                    Width = 2;
                }
                textelement(Filler)
                {
                    Width = 2;
                }

                textelement(VAL)
                {
                    Width = 4;
                }

                textelement(ReferenceMonth2)
                {
                    Width = 8;
                }

                textelement(Currency)
                {
                    Width = 3;
                }
                trigger OnAfterGetRecord()

                begin
                    StartBlock := '1';
                    FileType := 'UTDVEN';
                    ReferenceMonth := Format(Today(), 0, '<Year,4><Month,2>');
                    CountryCode := CountryOfOrigin;
                    Filler := PadStr('', 2, ' ');
                    VAL := VALValue;
                    ReferenceMonth2 := Format(Today(), 0, '<Year,4><Month,2><Day,2>');
                    Currency := LocalCurrency;
                end;
            }
            tableelement(BodyLine; Integer)
            {
                textelement(StartDataBlock)
                {
                    Width = 1;
                }
                textelement(CAI)
                {
                    Width = 6;
                }

                textelement(CompanyCode)
                {
                    Width = 3;
                }
                textelement(MarketCode)
                {
                    Width = 2;
                }
                textelement(CustomerCchCode)
                {
                    Width = 5;
                }
                textelement(DeliveryProfile)
                {
                    Width = 5;
                }

                textelement(Sign)
                {
                    Width = 1;
                }

                textelement(TotalQTYofSales)
                {
                    Width = 7;
                }

                textelement(Filler1)
                {
                    Width = 1;
                }

                textelement(Filler2)
                {
                    Width = 13;
                }
                textelement(Filler3)
                {
                    Width = 1;
                }
                textelement(Filler4)
                {
                    Width = 13;
                }
                textelement(Filler5)
                {
                    Width = 1;
                }
                textelement(Filler6)
                {
                    Width = 13;
                }
                textelement(Filler7)
                {
                    Width = 1;
                }
                textelement(Filler8)
                {
                    Width = 13;
                }

                trigger OnPreXmlItem()
                var
                    NoDataLbl: label 'No order shipped between the %1 and the %2.';

                begin
                    BodyLine.SetRange(Number, 1, TempMICAOrderShippedMIMSBuffer.Count());
                    if TempMICAOrderShippedMIMSBuffer.IsEmpty() then
                        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(NoDataLbl, FirstDayOfMonth, LastDayOfMonth), '')
                    else
                        TempMICAOrderShippedMIMSBuffer.FindSet();
                end;

                trigger OnAfterGetRecord()
                begin
                    StartDataBlock := '2';
                    CAI := TempMICAOrderShippedMIMSBuffer.CAI;
                    CompanyCode := SetupCompanyCode;
                    MarketCode := TempMICAOrderShippedMIMSBuffer."Market Code";
                    CustomerCchCode := TempMICAOrderShippedMIMSBuffer."Client Code";
                    DeliveryProfile := 'RTG';
                    TotalQTYofSales := FillSign(Format(Abs(TempMICAOrderShippedMIMSBuffer.TotalQtyOfSales), 0, 2), 7, '0');
                    if TempMICAOrderShippedMIMSBuffer.TotalQtyOfSales < 0 then
                        Sign := '-'
                    else
                        Sign := '+';
                    Filler1 := ' ';
                    Filler2 := FillSign('', 13, '0');
                    Filler3 := ' ';
                    Filler4 := FillSign('', 13, '0');
                    Filler5 := ' ';
                    Filler6 := FillSign('', 13, '0');
                    Filler7 := ' ';
                    Filler8 := FillSign('', 13, '0');

                    ExportedRecordCount += 1;

                    TempMICAOrderShippedMIMSBuffer.Next();
                end;

            }

            tableelement(EndBlockLine; Integer)
            {
                SourceTableView = SORTING(Number)
                                  WHERE(Number = CONST(1));
                textelement(EndBlock)
                {
                    Width = 1;
                }

                textelement(NumberOfBlocks)
                {
                    Width = 5;
                }

                trigger OnAfterGetRecord()
                begin
                    EndBlock := '9';
                    NumberOfBlocks := FillSign(FORMAT(ExportedRecordCount), 5, '0');
                end;
            }


        }
    }

    var

        MICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowInformation: Record "MICA Flow Information";
        Item: Record Item;
        TempMICAOrderShippedMIMSBuffer: record "MICA Order Shipped MIMS Buffer" temporary;
        UserItemType: Code[2];
        CountryOfOrigin: Code[2];
        LocalCurrency: Code[3];
        VALValue: Code[4];
        SetupCompanyCode: Code[3];
        FirstDayOfMonth: Date;
        LastDayOfMonth: Date;
        FileNaming: Text[250];
        LocationFilter: text;
        ExportedRecordCount: Integer;
        ErrorSetupLbl: Label 'Flow setup not completed';

    local procedure FillSign(textvar: Text; Spacing: Integer; Sig: Char): Text
    begin
        exit(Padstr('', Spacing - StrLen(textvar), Sig) + textvar);
    end;


    trigger OnPreXmlPort()
    var
        Location: Record Location;
        LocationErrorLbl: Label 'There are no locations within filters';
    begin

        UserItemType := CopyStr(GetCheckFlowTextParameter('USERITEMTYPE'), 1, 2);
        FileNaming := Copystr(GetCheckFlowTextParameter('FILENAMING'), 1, 250);
        CountryOfOrigin := CopyStr(GetCheckFlowTextParameter('COUNTRYOFORIGIN'), 1, 2);
        LocalCurrency := CopyStr(GetCheckFlowTextParameter('LOCALCURRENCY'), 1, 3);
        VALValue := CopyStr(GetCheckFlowTextParameter('VAL'), 1, 4);
        SetupCompanyCode := CopyStr(GetCheckFlowTextParameter('COMPANYCODE'), 1, 3);

        if (UserItemType = '') or (FileNaming = '') or (CountryOfOrigin = '') or (LocalCurrency = '') or (VALValue = '') or (SetupCompanyCode = '') then
            error(ErrorSetupLbl);

        LocationFilter := '';

        Location.SetFilter(Location."MICA DRP IN Location Code", '<>%1', '');

        Location.SetRange("Use As In-Transit", false);
        Location.SetFilter("MICA Entry Type", '<>%1', Location."MICA Entry Type"::"C (Transit)");

        if Location.FindSet() then begin
            LocationFilter := Location.Code;
            while Location.Next() <> 0 do
                LocationFilter += '|' + Location.Code;
        end;

        if LocationFilter = '' then
            Error(LocationErrorLbl);

        FillBuffer();
    end;

    procedure SetFlowEntry(FlowEntryNo: Integer)
    var
    begin
        MICAFlowEntry.Get(FlowEntryNo);
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    procedure GetFileName(): Text
    var
        FileName: Text;
    begin
        FileName := StrSubstNo(FileNaming, CountryOfOrigin, Format(CurrentDateTime(), 6, '<Year4><Month,2>'),
                                                Format(CurrentDateTime(), 14, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
        exit(FileName);
    end;

    local procedure GetCheckFlowTextParameter(FlowParameter: Text): Text
    var
        MissingFlowSetupLbl: Label 'Missing flow setup: Flow Code %1 with Parameter: %2';
        tempText: Text;
    begin
        tempText := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", CopyStr(FlowParameter, 1, 20));
        if tempText = '' then begin// simulate error on business data (not exported)
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, Item.RecordId(), StrSubstNo(MissingFlowSetupLbl, MICAFlowEntry."Flow Code", FlowParameter), Format(Item.RecordId()));
            currXMLport.Skip();
        end;
        exit(tempText);
    end;

    local procedure FillBuffer()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        CAIvar: Code[6];
        ClientCode: Text[5];
        MarketCode: Text[2];
    begin

        FirstDayOfMonth := CalcDate('<-CM>', Today());// WorkDate()
        LastDayOfMonth := CalcDate('<CM>', Today());// WorkDate()
        ItemLedgerEntry.SetFilter("Document Type", '%1|%2', ItemLedgerEntry."Document Type"::"Sales Shipment", ItemLedgerEntry."Document Type"::"Sales Return Receipt");
        ItemLedgerEntry.SetFilter(ItemLedgerEntry."Posting Date", '>=%1&<=%2', FirstDayOfMonth, LastDayOfMonth);
        ItemLedgerEntry.SetFilter(ItemLedgerEntry."Location Code", LocationFilter);
        ItemLedgerEntry.SetFilter("MICA User Item Type", UserItemType);

        if ItemLedgerEntry.FindSet() then
            repeat
                ClientCode := GetClientCode(ItemLedgerEntry);
                MarketCode := GetMarketCode(ItemLedgerEntry."Source No.");
                if GetCheckCAI(ItemLedgerEntry."Item No.", CAIvar) and not ((ClientCode = '') or (MarketCode = '')) then
                    AddLine(
                        CAIvar,
                        ClientCode,
                        MarketCode,
                        ItemLedgerEntry.Quantity);
            until ItemLedgerEntry.Next() = 0;

    end;

    local procedure AddLine(CAIvar: code[6]; ClientCodeVar: Text[5]; MarketCodeVar: Text[2]; Qty: Decimal)
    begin
        IF not TempMICAOrderShippedMIMSBuffer.get(CAIvar, ClientCodeVar, MarketCodeVar) then begin
            TempMICAOrderShippedMIMSBuffer.Init();
            TempMICAOrderShippedMIMSBuffer.CAI := CAIvar;
            TempMICAOrderShippedMIMSBuffer."Client Code" := ClientCodeVar;
            TempMICAOrderShippedMIMSBuffer."Market Code" := MarketCodeVar;
            TempMICAOrderShippedMIMSBuffer.Insert(true);
        end;
        TempMICAOrderShippedMIMSBuffer.TotalQtyOfSales += -Qty;
        TempMICAOrderShippedMIMSBuffer.Modify();
    end;

    procedure GetCheckCAI(ItemNo: code[20]; var CAIvar: Code[6]): Boolean
    var
        LocalItem: Record Item;
        ItemErrorLbl: Label 'Item %1 does not have No. 2 (CAI) code';
        ErrorText: Text;
    begin
        if LocalItem.Get(ItemNo) then begin
            if LocalItem."No. 2" = '' then begin
                ErrorText := StrSubstNo(ItemErrorLbl, LocalItem."No.");
                Error(ErrorText);
            end;
            MICAFlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", LocalItem.RecordId(), MICAFlowEntry."Send Status"::Prepared); // Update last send status on business data
            CAIvar := CopyStr(LocalItem."No. 2", 1, 6);
            exit(true);
        end else
            exit(false);
    end;

    local procedure GetClientCode(ItemLedgerEntry: Record "Item Ledger Entry"): text[5]
    var
        MICAForecastCustomerCode: Record "MICA Forecast Customer Code";
        CustomerLbl: Label 'Forecast customer code for customer %1 and item category %2 does not exist';
    begin
        MICAForecastCustomerCode.SetRange("Customer Code", ItemLedgerEntry."Source No.");
        MICAForecastCustomerCode.SetRange("Product Line", ItemLedgerEntry."Item Category Code");
        if MICAForecastCustomerCode.FindFirst() then
            exit(MICAForecastCustomerCode."Forecast Code")
        else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(CustomerLbl, ItemLedgerEntry."Source No.", ItemLedgerEntry."Item Category Code"), '');
    end;

    local procedure GetMarketCode(CustomerCode: Code[20]): text[2]
    var
        Customer: Record Customer;
        CustomerLbl: Label 'Customer %1 does not have market code';
    begin
        Customer.Get(CustomerCode);
        if Customer."MICA Market Code" = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(CustomerLbl, Customer."No."), '');
        exit(Customer."MICA Market Code")
    end;

}