xmlport 81340 "MICA Confirmed Order For MIMS"
{
    Caption = 'Confirmed Order For MIMS';
    Direction = Export;
    Format = VariableText;
    FieldSeparator = ',';
    RecordSeparator = '<NewLine>';
    TableSeparator = '<NewLine>';
    UseRequestPage = false;
    TextEncoding = MSDOS;
    FieldDelimiter = '';

    schema
    {
        textelement(root)
        {
            tableelement(ItemBufferHeader; Integer)
            {
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));
                textelement(ORCodeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ORCodeTitle := 'OR'
                    end;
                }
                textelement(CAITitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CAITitle := 'CAI'
                    end;
                }
                textelement(CCIDTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CCIDTitle := 'CCID'
                    end;
                }
                textelement(MarketCodeTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        MarketCodeTitle := 'Market Code'
                    end;
                }
                textelement(FACTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        FACTitle := 'FAC'
                    end;
                }
                textelement(DateTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DateTitle := 'DATE'
                    end;
                }
                textelement(QuantityTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        QuantityTitle := 'QTY'
                    end;
                }
            }
            tableelement(ItemBuffer; "Inventory Buffer")
            {
                UseTemporary = true;
                textelement(ORCode)
                {
                }
                textelement(CAI)
                {
                }
                textelement(CCID)
                {
                }
                textelement(MarketCode)
                {
                }
                textelement(FAC)
                {
                }
                textelement(Date)
                {
                }
                textelement(Quantity)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ORCode := CountryOfOrign;

                    CAI := ItemBuffer."Item No.";
                    CCID := ItemBuffer."Variant Code";
                    MarketCode := ItemBuffer."Serial No.";
                    FAC := '';
                    Date := ItemBuffer."Lot No.";
                    Quantity := FORMAT(ItemBuffer.Quantity, 0, '<Integer>');
                    ExportedRecordCount += 1;
                end;
            }
        }
    }
    var
        MICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        FileNaming: Text[250];
        UserItemType: Code[10];
        CountryOfOrign: Code[10];
        ExportedRecordCount: Integer;
        ErrorSetupLbl: Label 'Flow setup not completed';

    trigger OnPreXmlPort()
    begin
        UserItemType := CopyStr(GetCheckFlowTextParameter('USERITEMTYPE'), 1, 10);
        FileNaming := CopyStr(GetCheckFlowTextParameter('FILENAMING'), 1, 250);
        CountryOfOrign := CopyStr(GetCheckFlowTextParameter('COUNTRYOFORIGIN'), 1, 2);

        if (UserItemType = '') or (FileNaming = '') or (CountryOfOrign = '') then
            error(ErrorSetupLbl);

        SetData();
    end;

    local procedure SetData()
    var
        SalesHeader: record "Sales Header";
        SalesLine: record "Sales Line";
        Location: record Location;
        Item: record Item;
        LocationFilter: Text;
        RequestedDeliveryDateText: Text;
        LocationFilterErrorLbl: Label 'Stock location for DRP not set';
    begin

        Location.SetFilter("MICA DRP IN Location Code", '<>%1', '');
        Location.SetRange("Use As In-Transit", false);
        Location.SetFilter("MICA Entry Type", '<>%1', Location."MICA Entry Type"::"C (Transit)");
        if Location.FindSet() then
            repeat
                if LocationFilter <> '' then
                    LocationFilter += '|';
                LocationFilter += Location.Code;
            until Location.Next() = 0;
        if LocationFilter = '' then
            Error(LocationFilterErrorLbl);

        SalesLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Outstanding Quantity", '<>0');
        SalesLine.SetFilter("Location Code", LocationFilter);
        SalesLine.SetFilter("No.", '<>%1', '');
        if SalesLine.FindSet(false, false) then
            repeat
                if SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") and
                (SalesHeader.Status IN [SalesHeader.Status::Released, SalesHeader.Status::"Pending Approval"]) and
                Item.get(SalesLine."No.") and (Item."MICA User Item Type" = UserItemType) then begin
                    Item.Testfield("No. 2");
                    Item.Testfield("MICA CCID Code");
                    Item.TestField("MICA Market Code");
                    RequestedDeliveryDateText := StrSubstNo('%1/%2/%3', Date2DMY(SalesLine."Requested Delivery Date", 2), Date2DMY(SalesLine."Requested Delivery Date", 1), Date2DMY(SalesLine."Requested Delivery Date", 3));
                    // Fill buffer for export (summary by CAI)
                    ItemBuffer.SetRange("Item No.", CopyStr(Item."No. 2", 1, 6));
                    ItemBuffer.SetRange("Variant Code", Item."MICA CCID Code");
                    ItemBuffer.SetRange("Lot No.", RequestedDeliveryDateText);
                    if not ItemBuffer.FindFirst() then begin
                        ItemBuffer.init();
                        ItemBuffer."Item No." := CopyStr(Item."No. 2", 1, 6);
                        ItemBuffer."Variant Code" := Item."MICA CCID Code";
                        ItemBuffer."Serial No." := Item."MICA Market Code";
                        ItemBuffer."Lot No." := CopyStr(RequestedDeliveryDateText, 1, MaxStrLen(ItemBuffer."Lot No."));
                        ItemBuffer.Insert(false);
                    end;
                    ItemBuffer.Quantity += SalesLine."Outstanding Qty. (Base)";
                    ItemBuffer.Modify(false);
                end;
            until SalesLine.Next() = 0;
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
        FileName := StrSubstNo(FileNaming, CountryOfOrign, Format(CurrentDateTime(), 14, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
        exit(FileName);
    end;

    local procedure GetCheckFlowTextParameter(FlowParameter: Text): Text
    var
        MissingFlowSetupLbl: Label 'Missing flow setup: Flow Code %1 with Parameter: %2';
        tempText: Text;
    begin
        tempText := MICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", CopyStr(FlowParameter, 1, 20));
        if tempText = '' then begin// simulate error on business data (not exported))
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error,
                                     MICAFlowEntry.RecordId(),
                                     StrSubstNo(MissingFlowSetupLbl, MICAFlowEntry."Flow Code", FlowParameter),
                                     Format(MICAFlowEntry.RecordId()));
            currXMLport.Skip();
        end;
        exit(tempText);
    end;
}
