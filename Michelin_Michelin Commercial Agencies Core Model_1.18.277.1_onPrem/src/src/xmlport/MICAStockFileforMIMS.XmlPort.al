xmlport 81320 "MICA Stock File for MIMS"
{
    Caption = 'Stock File for MIMS';
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

                textelement(PelicanCode)
                {
                    Width = 4;
                }

                textelement(Filler01)
                {
                    Width = 4;
                }
                textelement(ApplicationCode)
                {
                    Width = 6;
                }
                textelement(CreationDate)
                {
                    Width = 6;
                }

                textelement(OCCode)
                {
                    Width = 2;
                }

                textelement(ReferenceMonth)
                {
                    Width = 2;
                }
                textelement(TransmissionLotNo)
                {
                    Width = 3;
                }
                trigger OnAfterGetRecord()
                var
                    FlowSetup: Record "MICA Flow Setup";
                    tempMonth: integer;
                    PelicanErroLbl: Label 'No PELICANCCODE setup';
                    OCCodeErroLbl: Label 'No OCCode setup';
                begin
                    StartBlock := '1';
                    PelicanCode := FlowSetup.GetFlowTextParam(FlowEntry."Flow Code", 'PELICANCODE');
                    if (PelicanCode = '') then
                        Error(PelicanErroLbl);
                    Filler01 := Padstr(' ', 4);
                    ApplicationCode := 'UTDSTO';
                    CreationDate := Format(Today(), 0, '<Year,2><Month,2><Day,2>');
                    OCCode := FlowSetup.GetFlowTextParam(FlowEntry."Flow Code", 'COUNTRYOFORIGIN');
                    if (OCCode = '') then
                        Error(OCCodeErroLbl);
                    tempMonth := Date2DMY(Today(), 2);
                    IF tempMonth < 10 then
                        ReferenceMonth := '0' + Format(tempMonth)
                    else
                        ReferenceMonth := Format(tempMonth);
                    TransmissionLotNo := '001';
                end;
            }
            tableelement(InventoryBufferStock; "Inventory Buffer")
            {
                UseTemporary = true;
                textelement(StartDataBlock)
                {
                    Width = 1;
                }
                textelement(CAI)
                {
                    Width = 6;
                }

                textelement(CCID)
                {
                    Width = 4;
                }
                textelement(MarketCode)
                {
                    Width = 4;
                }

                textelement(SignOfPhysicalStock)
                {
                    Width = 1;
                }

                textelement(PhysicalStock)
                {
                    Width = 7;
                }

                textelement(SignOfDCL)
                {
                    Width = 1;
                }

                textelement(LocalCommercialAvailDCL)
                {
                    Width = 7;
                }
                textelement(SignOfDNR)
                {
                    Width = 1;
                }
                textelement(GITDNR)
                {
                    Width = 7;
                }
                textelement(SignOfOpenAl)
                {
                    Width = 1;
                }
                textelement(AttributionNotOrderedDNC)
                {
                    Width = 7;
                }
                textelement(CountryOfOrigin01)
                {
                    Width = 2;
                }
                textelement(SignONQ01)
                {
                    Width = 1;
                }
                textelement(GIT01)
                {
                    Width = 7;
                }
                textelement(CountryOfOrigin02)
                {
                    Width = 2;
                }
                textelement(SignONQ02)
                {
                    Width = 1;
                }
                textelement(GIT02)
                {
                    Width = 7;
                }
                textelement(CountryOfOrigin03)
                {
                    Width = 2;
                }
                textelement(SignONQ03)
                {
                    Width = 1;
                }
                textelement(GIT03)
                {
                    Width = 7;
                }
                textelement(CountryOfOrigin04)
                {
                    Width = 2;
                }
                textelement(SignONQ04)
                {
                    Width = 1;
                }
                textelement(GIT04)
                {
                    Width = 7;
                }
                textelement(CountryOfOrigin05)
                {
                    Width = 2;
                }
                textelement(SignONQ05)
                {
                    Width = 1;
                }
                textelement(GIT05)
                {
                    Width = 7;
                }
                textelement(CountryOfOrigin06)
                {
                    Width = 2;
                }
                textelement(SignONQ06)
                {
                    Width = 1;
                }
                textelement(GIT06)
                {
                    Width = 7;
                }
                textelement(CountryOfOrigin07)
                {
                    Width = 2;
                }
                textelement(SignONQ07)
                {
                    Width = 1;
                }
                textelement(GIT07)
                {
                    Width = 7;
                }
                textelement(CountryOfOrigin08)
                {
                    Width = 2;
                }
                textelement(SignONQ08)
                {
                    Width = 1;
                }
                textelement(GIT08)
                {
                    Width = 7;
                }
                textelement(CountryOfOrigin09)
                {
                    Width = 2;
                }
                textelement(SignONQ09)
                {
                    Width = 1;
                }
                textelement(GIT09)
                {
                    Width = 7;
                }

                trigger OnAfterGetRecord()
                var
                    FlowSetup: Record "MICA Flow Setup";
                    tempStock: Decimal;
                    tempDNR: Decimal;
                begin
                    StartDataBlock := '2';
                    CAI := InventoryBufferStock."Item No.";
                    CCID := InventoryBufferStock."Variant Code";
                    MarketCode := '  ' + InventoryBufferStock."Serial No.";
                    SignOfPhysicalStock := '+';

                    tempStock := InventoryBufferStock.Quantity;
                    TempInventoryBuffer.SetRange("Item No.", InventoryBufferStock."Item No.");
                    TempInventoryBuffer.SetRange("Variant Code", InventoryBufferStock."Variant Code");
                    if TempInventoryBuffer.FindFirst() then
                        tempDNR := TempInventoryBuffer.Quantity
                    else
                        tempDNR := 0;

                    if tempDNR + tempStock = 0 then
                        currXMLport.Skip();

                    PhysicalStock := FillZero(FORMAT(tempStock, 0, 2), 7);
                    SignOfDCL := '+';

                    LocalCommercialAvailDCL := FillZero(FORMAT(
                        tempStock + tempDNR + 0, 0, 2)
                        , 7);

                    SignOfDNR := '+';
                    // GITDNR := FillZero(Format(tempDNR, 0, 2), 7);
                    GITDNR := FillZero('', 7);
                    SignOfOpenAl := '+';
                    AttributionNotOrderedDNC := FillZero('', 7);

                    CountryOfOrigin01 := PadStr(' ', 2);
                    SignONQ01 := '+';
                    // GIT01 := FillZero(Format(tempDNR, 0, 2), 7);
                    GIT01 := FillZero('', 7);

                    CountryOfOrigin02 := PadStr(' ', 2);
                    SignONQ02 := '+';
                    GIT02 := FillZero('', 7);

                    CountryOfOrigin03 := PadStr(' ', 2);
                    SignONQ03 := '+';
                    GIT03 := FillZero('', 7);

                    CountryOfOrigin04 := PadStr(' ', 2);
                    SignONQ04 := '+';
                    GIT04 := FillZero('', 7);

                    CountryOfOrigin05 := PadStr(' ', 2);
                    SignONQ05 := '+';
                    GIT05 := FillZero('', 7);

                    CountryOfOrigin06 := PadStr(' ', 2);
                    SignONQ06 := '+';
                    GIT06 := FillZero('', 7);

                    CountryOfOrigin07 := PadStr(' ', 2);
                    SignONQ07 := '+';
                    GIT07 := FillZero('', 7);

                    CountryOfOrigin08 := PadStr(' ', 2);
                    SignONQ08 := '+';
                    GIT08 := FillZero('', 7);

                    CountryOfOrigin09 := FlowSetup.GetFlowTextParam(FlowEntry."Flow Code", 'COUNTRYOFORIGIN');
                    SignONQ09 := '+';
                    GIT09 := FillZero(Format(tempDNR, 0, 2), 7);

                    ExportedRecordCount += 1;
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
                textelement(TransmissionLot)
                {
                    Width = 3;
                }

                trigger OnAfterGetRecord()
                begin
                    EndBlock := '9';
                    NumberOfBlocks := FillZero(FORMAT(ExportedRecordCount), 5);
                    TransmissionLot := '001';
                end;
            }
        }
    }

    var
        FlowEntry: Record "MICA Flow Entry";
        FlowSetup: Record "MICA Flow Setup";
        ItemStock: record Item;
        ItemGit: record Item;
        TempInventoryBuffer: Record "Inventory Buffer" Temporary;
        StockInventoryLocationFilter: text;
        GoodsInTranstitLocationFilter: text;
        ExportedRecordCount: Integer;
        ItemSetupMissingLbl: label '%1 is not fill for %2 %3.';

    trigger OnPreXmlPort()
    var

    begin
        SetData();
    end;

    local procedure FillZero(textvar: Text; Spacing: Integer): Text
    begin
        exit(Padstr('', Spacing - StrLen(textvar), '0') + textvar);
    end;

    local procedure SetData()
    var
        Location: record Location;
        FlowInfo: Record "MICA Flow Information";
        UserItemType: Code[10];
        UserItemTypeErrorLbl: Label 'No User Item Type setup';
        StockInvLocationErrorLbl: label 'Stock location for DRP not set';
        GITLocationErrorLbl: label 'In-transit location for DRP not set';
        FilterReturnNoItemLbl: label '%1 doest not return an item list';
    begin

        StockInventoryLocationFilter := '';
        GoodsInTranstitLocationFilter := '';

        Location.SetFilter(Location."MICA DRP IN Location Code", '<>%1', '');
        Location.SetRange(Location."Use As In-Transit", false);
        Location.SetFilter(Location."MICA Entry Type", '<>%1', Location."MICA Entry Type"::"C (Transit)");
        if Location.FindSet() then
            repeat
                if StockInventoryLocationFilter <> '' then
                    StockInventoryLocationFilter += '|';
                StockInventoryLocationFilter += Location.Code;
            until Location.Next() = 0;
        if StockInventoryLocationFilter = '' then
            Error(StockInvLocationErrorLbl);

        Location.SetRange(Location."Use As In-Transit", true);
        Location.SetFilter(Location."MICA Entry Type", '=%1', Location."MICA Entry Type"::"C (Transit)");
        if Location.FindSet() then
            repeat
                if GoodsInTranstitLocationFilter <> '' then
                    GoodsInTranstitLocationFilter += '|';
                GoodsInTranstitLocationFilter += Location.Code;
            until Location.Next() = 0;
        if GoodsInTranstitLocationFilter = '' then
            Error(GITLocationErrorLbl);

        UserItemType := CopyStr(FlowSetup.GetFlowTextParam(FlowEntry."Flow Code", 'USERITEMTYPE'), 1, 10);
        if (UserItemType = '') then
            Error(UserItemTypeErrorLbl);
        with ItemStock Do begin
            // Set filters on items
            SetRange("MICA User Item Type", UserItemType);
            Setrange(Blocked, false);
            SetRange(Type, Type::Inventory);
            ItemGit.CopyFilters(ItemStock);
            SetFilter("Location Filter", StockInventoryLocationFilter);
            ItemGit.SetFilter("Location Filter", GoodsInTranstitLocationFilter);
            // Loop on Items
            if FindSet(false, false) then
                repeat
                    if "No. 2" = '' then
                        FlowEntry.AddInformation(FlowInfo."Info Type"::Warning, StrSubstNo(ItemSetupMissingLbl, fieldcaption("No. 2"), TableCaption(), "No."), '');
                    if "MICA CCID Code" = '' then
                        FlowEntry.AddInformation(FlowInfo."Info Type"::Warning, StrSubstNo(ItemSetupMissingLbl, fieldcaption("MICA CCID Code"), TableCaption(), "No."), '');
                    if "MICA Market Code" = '' then
                        FlowEntry.AddInformation(FlowInfo."Info Type"::Warning, StrSubstNo(ItemSetupMissingLbl, fieldcaption("MICA Market Code"), TableCaption(), "No."), '');

                    if ("No. 2" <> '') and ("MICA CCID Code" <> '') and ("MICA Market Code" <> '') then begin
                        InventoryBufferStock.SetRange("Item No.", CopyStr("No. 2", 1, 6));
                        InventoryBufferStock.SetRange("Variant Code", "MICA CCID Code");
                        if not InventoryBufferStock.FindFirst() then begin
                            // Stock inventory
                            InventoryBufferStock.init();
                            InventoryBufferStock."Item No." := CopyStr("No. 2", 1, 6);
                            InventoryBufferStock."Variant Code" := "MICA CCID Code";
                            InventoryBufferStock."Serial No." := "MICA Market Code";
                            InventoryBufferStock.Insert(false);
                            // Goods in transit quantities
                            TempInventoryBuffer.init();
                            TempInventoryBuffer.TransferFields(InventoryBufferStock);
                            TempInventoryBuffer.Insert(false);
                        end;
                        // Update Stock inventory
                        CalcFields(Inventory);
                        InventoryBufferStock.Quantity += Inventory;
                        InventoryBufferStock.Modify(false);
                        // Update Goods in transit quantities
                        ItemGit.get("No.");
                        ItemGit.CalcFields(Inventory);
                        TempInventoryBuffer.Quantity += ItemGit.Inventory;
                        TempInventoryBuffer.Modify(false);
                    end;
                until Next() = 0
            else
                FlowEntry.AddInformation(FlowInfo."Info Type"::Error, StrSubstNo(FilterReturnNoItemLbl, ItemStock.GetFilters()), '');
        end;
    end;

    procedure SetFlowEntry(FlowEntryNo: Integer)
    var
    begin
        FlowEntry.Get(FlowEntryNo);
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    procedure GetFileName(): Text
    var
        FlowSetupLocal: Record "MICA Flow Setup";
        FileName: Text;
        NoFileNameSetupLbl: Label 'No FileName Flow setup';
    begin
        FileName := StrSubstNo(FlowSetupLocal.GetFlowTextParam(FlowEntry."Flow Code", 'FILENAMING'),
                                                FlowSetupLocal.GetFlowTextParam(FlowEntry."Flow Code", 'COUNTRYOFORIGIN'),//change first argument
                                                  Format(Today(), 6, '<Year4><Month,2>'),
                                                  Format(CurrentDateTime(), 14, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
        if FileName = '' then
            Error(NoFileNameSetupLbl);
        exit(FileName);
    end;
}