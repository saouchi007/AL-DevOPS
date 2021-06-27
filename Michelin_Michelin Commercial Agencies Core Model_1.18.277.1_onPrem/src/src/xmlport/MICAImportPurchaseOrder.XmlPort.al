xmlport 82260 "MICA Import Purchase Order"
{
    Caption = 'Import Purchase Order';
    Direction = Import;
    TextEncoding = UTF8;
    Format = VariableText;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    UseRequestPage = false;
    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {

                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                textelement(AlNo) { }
                textelement(AsnNo) { }
                textelement(CarrierDocNo) { }
                textelement(ContainerID) { }
                textelement(CurrencyCode) { }
                textelement(DocumentDateRaw) { }
                textelement(DocumentType) { }
                textelement(DueDateRaw) { }
                textelement(ETARaw) { }
                textelement(ExpectedReceiptDateRaw) { }
                textelement(LocationCode) { }
                textelement(LocationToCode) { }
                textelement(DocumentNo) { }
                textelement(OrderDateRaw) { }
                textelement(PortOfArrival) { }
                textelement(PostingDateRaw) { }
                textelement(RequestedReceiptDateRaw) { }
                textelement(SealNo) { }
                textelement(ShipTo) { }
                textelement(SRDRaw) { }
                textelement(VendorInvoiceNo) { }
                textelement(VendorNo) { }
                textelement(Type) { }
                textelement(No) { }
                textelement(LineLocationCode) { }
                textelement(QuantityRaw) { }
                textelement(DirectUnitCostExclVATRaw) { }
                textelement(ASNNo2) { }
                textelement(ASNLineNoRaw) { }
                textelement(CountryOfOrigin) { }

                trigger OnBeforeInsertRecord()
                begin
                    // Skip first row(Header)
                    FileLineNo += 1;
                    if FileLineNo = 1 then
                        currXMLport.Skip();

                    CheckImportedData();
                    if PreviousDocumentNo <> DocumentNo then
                        CreateTempPurchHeader()
                    else
                        CreateTempPurchLine();
                    PreviousDocumentNo := DocumentNo;
                end;

            }
        }
    }
    trigger OnPostXmlPort()
    var
        FileNameTxt: Label 'PurchOrderError.pdf';
        ReportSubtitleTxt: Label 'Purchase Orders';
    begin
        if MICAImportDataErrorMgt.ErrorExist() then
            MICAImportDataErrorMgt.ExportFileWithErrors(DateFormat, DecimalSeparator, FileNameTxt, ReportSubtitleTxt)
        else
            CreatePurchaseOrder();
    end;

    var
        TempPurchaseHeader: Record "Purchase Header" temporary;
        TempPurchaseLine: Record "Purchase Line" temporary;
        MICAImportDataErrorMgt: Codeunit "MICA Import Data Error Mgt";
        Dialog: Dialog;
        DateFormat: Option "MM/DD/YYYYY","DD/MM/YYYY";
        DecimalSeparator: Option Comma,Dot;
        PreviousDocumentNo: Code[20];
        DocumentDate: Date;
        DueDate: Date;
        ExpectedReceiptDate: Date;
        PostingDate: Date;
        OrderDate: Date;
        ETA: Date;
        RequestedReceiptDate: Date;
        SRD: Date;
        DirectUnitCostExclVAT: decimal;
        Quantity: decimal;
        FileLineNo: Integer;
        FormatIsNotValidErr: Label 'The value %1 for the field %2 is not in a valid format.';
        NotExistInDatabaseErr: Label 'The value %1 for the field %2 does not exist in the related table %3.';
        DocAlreadyExistErr: Label 'Document already exist: Document type: %1, Document No: %2.';
        OptionStringNotValidErr: Label 'Option String: %1 for the field %2 is not valid.';
        DialImportMsg: Label 'Any error has not found and Purchase Order will be created.\';
        DialProgr_Msg: Label 'Progress @2@@@@@@@@@@';

    local procedure CreatePurchaseOrder()
    var
        PurchaseHeader: Record "Purchase Header";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        CurrTotal: Integer;
        TotalRecs: Integer;
    begin
        Dialog.Open(DialImportMsg + DialProgr_Msg);
        TempPurchaseHeader.Reset();
        TotalRecs := TempPurchaseHeader.Count();
        If TempPurchaseHeader.FindSet() then
            repeat
                CopyTempPurchHeaderToPhysical(TempPurchaseHeader);
                TempPurchaseLine.Reset();
                TempPurchaseLine.SetRange("Document No.", TempPurchaseHeader."No.");
                IF TempPurchaseLine.FindSet() then
                    repeat
                        CopyTempPurchLineToPhysical(TempPurchaseLine);
                    until TempPurchaseLine.Next() = 0;
                PurchaseHeader.get(TempPurchaseHeader."Document Type", TempPurchaseHeader."No.");
                ReleasePurchaseDocument.PerformManualRelease(PurchaseHeader);
                CurrTotal += 1;
                Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
            until TempPurchaseHeader.Next() = 0;
        Dialog.Close();
    end;

    local procedure CopyTempPurchHeaderToPhysical(FromPurchaseHeader: Record "Purchase Header")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Init();
        PurchaseHeader.Validate("Document Type", FromPurchaseHeader."Document Type");
        PurchaseHeader.Validate("No.", FromPurchaseHeader."No.");
        PurchaseHeader.Validate("Buy-from Vendor No.", FromPurchaseHeader."Buy-from Vendor No.");
        PurchaseHeader.Validate("Document Date", FromPurchaseHeader."Document Date");
        PurchaseHeader.Validate("Posting Date", FromPurchaseHeader."Posting Date");
        PurchaseHeader.Validate("MICA AL No.", FromPurchaseHeader."MICA AL No.");
        PurchaseHeader.Validate("MICA ASN No.", FromPurchaseHeader."MICA ASN No.");
        PurchaseHeader.Validate("MICA Carrier Doc. No.", FromPurchaseHeader."MICA Carrier Doc. No.");
        PurchaseHeader.Validate("MICA Container ID", FromPurchaseHeader."MICA Container ID");
        PurchaseHeader.Validate("Currency Code", FromPurchaseHeader."Currency Code");
        PurchaseHeader.Validate("Due Date", FromPurchaseHeader."Due Date");
        PurchaseHeader.Validate("MICA ETA", FromPurchaseHeader."MICA ETA");
        PurchaseHeader.validate("Expected Receipt Date", FromPurchaseHeader."Expected Receipt Date");
        PurchaseHeader.Validate("Location Code", FromPurchaseHeader."Location Code");
        PurchaseHeader.Validate("MICA Location-To Code", FromPurchaseHeader."MICA Location-To Code");
        PurchaseHeader.Validate("Order Date", FromPurchaseHeader."Order Date");
        PurchaseHeader.Validate("MICA Port of Arrival", FromPurchaseHeader."MICA Port of Arrival");
        PurchaseHeader.Validate("Requested Receipt Date", FromPurchaseHeader."Requested Receipt Date");
        PurchaseHeader.Validate("MICA SRD", FromPurchaseHeader."MICA SRD");
        PurchaseHeader.Validate("Vendor Invoice No.", FromPurchaseHeader."Vendor Invoice No.");
        PurchaseHeader.Validate("MICA Seal No.", FromPurchaseHeader."MICA Seal No.");
        PurchaseHeader.Insert();
    end;

    local procedure CopyTempPurchLineToPhysical(FromPurchaseLine: Record "Purchase Line")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Init();
        PurchaseLine.Validate("Document Type", FromPurchaseLine."Document Type");
        PurchaseLine.Validate("Document No.", FromPurchaseLine."Document No.");
        PurchaseLine."Line No." := FromPurchaseLine."Line No.";
        PurchaseLine.Validate(Type, FromPurchaseLine.Type);
        PurchaseLine.Validate("No.", FromPurchaseLine."No.");
        PurchaseLine.Validate("Location Code", FromPurchaseLine."Location Code");
        PurchaseLine.Validate(Quantity, FromPurchaseLine.Quantity);
        PurchaseLine.Validate("Direct Unit Cost", FromPurchaseLine."Direct Unit Cost");
        PurchaseLine.Validate("MICA ASN No.", FromPurchaseLine."MICA ASN No.");
        PurchaseLine.Validate("MICA ASN Line No.", FromPurchaseLine."MICA ASN Line No.");
        PurchaseLine.Validate("MICA Country of Origin", FromPurchaseLine."MICA Country of Origin");
        PurchaseLine.Insert();
    end;

    local procedure CheckImportedData()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Location: Record Location;
        Currency: Record Currency;
        Vendor: Record Vendor;
        Item: Record Item;
        GLAccount: Record "G/L Account";
        CountryRegion: Record "Country/Region";
    begin
        if DocumentType <> 'Order' then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseLine.FieldCaption("Document Type"), StrSubstNo(OptionStringNotValidErr, DocumentType, PurchaseHeader.FieldCaption("Document Type")));
        if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, DocumentNo) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseLine.FieldCaption("Document No."), StrSubstNo(DocAlreadyExistErr, DocumentType, DocumentNo));

        // Validation of fields with relation
        if not Location.Get(LocationCode) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("Location Code"), StrSubstNo(NotExistInDatabaseErr, LocationCode, PurchaseHeader.FieldCaption("Location Code"), Location.TableCaption()));
        if (LocationToCode <> '') and (not Location.Get(LocationToCode)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("MICA Location-To Code"), StrSubstNo(NotExistInDatabaseErr, LocationToCode, PurchaseHeader.FieldCaption("MICA Location-To Code"), Location.TableCaption()));
        if (LineLocationCode <> '') and (not Location.Get(LineLocationCode)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseLine.FieldCaption("Location Code"), StrSubstNo(NotExistInDatabaseErr, LineLocationCode, PurchaseLine.FieldCaption("Location Code"), Location.TableCaption()));
        if (CurrencyCode <> '') and (not Currency.Get(CurrencyCode)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("Currency Code"), StrSubstNo(NotExistInDatabaseErr, CurrencyCode, PurchaseHeader.FieldCaption("Currency Code"), Currency.TableCaption()));
        if (VendorNo <> '') and (not Vendor.Get(VendorNo)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("Buy-from Vendor No."), StrSubstNo(NotExistInDatabaseErr, VendorNo, PurchaseHeader.FieldCaption("Buy-from Vendor No."), Vendor.TableCaption()));
        case Type of
            'Item':
                if (No <> '') and (not Item.Get(No)) then
                    MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseLine.FieldCaption("No."), StrSubstNo(NotExistInDatabaseErr, No, PurchaseLine.FieldCaption("No."), Item.TableCaption()));
            'G/L Account':
                if (No <> '') and (not GLAccount.Get(No)) then
                    MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseLine.FieldCaption("No."), StrSubstNo(NotExistInDatabaseErr, No, PurchaseLine.FieldCaption("No."), GLAccount.TableCaption()));
            else
                MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseLine.FieldCaption(Type), StrSubstNo(OptionStringNotValidErr, Type, PurchaseLine.FieldCaption(Type)));
        end;
        if (CountryOfOrigin <> '') and (not CountryRegion.Get(CountryOfOrigin)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseLine.FieldCaption("MICA Country of Origin"), StrSubstNo(NotExistInDatabaseErr, CountryOfOrigin, PurchaseLine.FieldCaption("MICA Country of Origin"), CountryRegion.TableCaption()));

        // Validation of Date fields
        if not MICAImportDataErrorMgt.ValidDateFormat(DocumentDateRaw, DocumentDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("Document Date"), StrSubstNo(FormatIsNotValidErr, DocumentDateRaw, PurchaseHeader.FieldCaption("Document Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(DueDateRaw, DueDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("Due Date"), StrSubstNo(FormatIsNotValidErr, DueDateRaw, PurchaseHeader.FieldCaption("Due Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(ExpectedReceiptDateRaw, ExpectedReceiptDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("Expected Receipt Date"), StrSubstNo(FormatIsNotValidErr, ExpectedReceiptDateRaw, PurchaseHeader.FieldCaption("Expected Receipt Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(OrderDateRaw, OrderDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("Order Date"), StrSubstNo(FormatIsNotValidErr, OrderDateRaw, PurchaseHeader.FieldCaption("Order Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(PostingDateRaw, PostingDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("Posting Date"), StrSubstNo(FormatIsNotValidErr, PostingDateRaw, PurchaseHeader.FieldCaption("Posting Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(ETARaw, ETA, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("MICA ETA"), StrSubstNo(FormatIsNotValidErr, ETARaw, PurchaseHeader.FieldCaption("MICA ETA")));
        if not MICAImportDataErrorMgt.ValidDateFormat(RequestedReceiptDateRaw, RequestedReceiptDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("Requested Receipt Date"), StrSubstNo(FormatIsNotValidErr, RequestedReceiptDateRaw, PurchaseHeader.FieldCaption("Requested Receipt Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(SRDRaw, SRD, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseHeader.FieldCaption("MICA SRD"), StrSubstNo(FormatIsNotValidErr, SRDRaw, PurchaseHeader.FieldCaption("MICA SRD")));

        // Validation of Decimal fields
        if not MICAImportDataErrorMgt.ValidDecimalSeparator(QuantityRaw, Quantity, DecimalSeparator) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseLine.FieldCaption(Quantity), StrSubstNo(FormatIsNotValidErr, QuantityRaw, PurchaseLine.FieldCaption(Quantity)));
        if not MICAImportDataErrorMgt.ValidDecimalSeparator(DirectUnitCostExclVATRaw, DirectUnitCostExclVAT, DecimalSeparator) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, PurchaseLine.FieldCaption("Direct Unit Cost"), StrSubstNo(FormatIsNotValidErr, DirectUnitCostExclVATRaw, PurchaseLine.FieldCaption("Direct Unit Cost")));


    end;

    procedure CreateTempPurchHeader()
    begin
        TempPurchaseHeader.Init();
        TempPurchaseHeader."Document Type" := TempPurchaseHeader."Document Type"::Order;
        TempPurchaseHeader."No." := CopyStr(DocumentNo, 1, MaxStrLen(TempPurchaseHeader."No."));
        TempPurchaseHeader."Buy-from Vendor No." := CopyStr(VendorNo, 1, MaxStrLen(TempPurchaseHeader."Buy-from Vendor No."));
        TempPurchaseHeader."MICA AL No." := CopyStr(AlNo, 1, MaxStrLen(TempPurchaseHeader."MICA AL No."));
        TempPurchaseHeader."MICA ASN No." := CopyStr(AsnNo, 1, MaxStrLen(TempPurchaseHeader."MICA ASN No."));
        TempPurchaseHeader."MICA Carrier Doc. No." := CopyStr(CarrierDocNo, 1, MaxStrLen(TempPurchaseHeader."MICA Carrier Doc. No."));
        TempPurchaseHeader."MICA Container ID" := CopyStr(ContainerID, 1, MaxStrLen(TempPurchaseHeader."MICA Container ID"));
        TempPurchaseHeader."Currency Code" := CurrencyCode;
        TempPurchaseHeader."Document Date" := DocumentDate;
        TempPurchaseHeader."Due Date" := DueDate;
        TempPurchaseHeader."MICA ETA" := ETA;
        TempPurchaseHeader."Expected Receipt Date" := ExpectedReceiptDate;
        TempPurchaseHeader."Location Code" := LocationCode;
        TempPurchaseHeader."MICA Location-To Code" := LocationToCode;
        TempPurchaseHeader."Order Date" := OrderDate;
        TempPurchaseHeader."MICA Port of Arrival" := CopyStr(PortOfArrival, 1, MaxStrLen(TempPurchaseHeader."MICA Port of Arrival"));
        TempPurchaseHeader."Posting Date" := PostingDate;
        TempPurchaseHeader."Requested Receipt Date" := RequestedReceiptDate;
        TempPurchaseHeader."MICA SRD" := SRD;
        TempPurchaseHeader."Vendor Invoice No." := CopyStr(VendorInvoiceNo, 1, MaxStrLen(TempPurchaseHeader."Vendor Invoice No."));
        TempPurchaseHeader."MICA Seal No." := CopyStr(SealNo, 1, MaxStrLen(TempPurchaseHeader."MICA Seal No."));
        TempPurchaseHeader."Ship-to Code" := CopyStr(ShipTo, 1, MaxStrLen(TempPurchaseHeader."Ship-to Code"));
        TempPurchaseHeader.Insert();
        CreateTempPurchLine();
    end;

    procedure CreateTempPurchLine()
    var
        LineNo: Integer;
        ASNLineNo: Integer;
    begin
        LineNo := 10000;
        TempPurchaseLine.Reset();
        TempPurchaseLine.SetRange("Document No.", DocumentNo);
        if TempPurchaseLine.FindLast() then
            LineNo += TempPurchaseLine."Line No.";

        TempPurchaseLine.Init();
        TempPurchaseLine."Document Type" := TempPurchaseLine."Document Type"::Order;
        TempPurchaseLine."Document No." := DocumentNo;
        TempPurchaseLine."Line No." := LineNo;
        case Type of
            'Item':
                TempPurchaseLine.Type := TempPurchaseLine.Type::Item;
            'G/L Account':
                TempPurchaseLine.Type := TempPurchaseLine.Type::"G/L Account";
        end;
        TempPurchaseLine."No." := No;
        if LineLocationCode <> '' then
            TempPurchaseLine."Location Code" := LineLocationCode
        else
            TempPurchaseLine."Location Code" := LocationCode;
        TempPurchaseLine.Quantity := Quantity;
        TempPurchaseLine."Direct Unit Cost" := DirectUnitCostExclVAT;
        TempPurchaseLine."MICA ASN No." := CopyStr(ASNNo2, 1, MaxStrLen(TempPurchaseLine."MICA ASN No."));
        Evaluate(ASNLineNo, ASNLineNoRaw);
        TempPurchaseLine."MICA ASN Line No." := ASNLineNo;
        TempPurchaseLine."MICA Country of Origin" := CountryOfOrigin;
        TempPurchaseLine.Insert();
    end;

    procedure SetInputData(InputDateFormat: Option; InputDecimalSeparator: Option)
    begin
        DateFormat := InputDateFormat;
        DecimalSeparator := InputDecimalSeparator;
    end;

}