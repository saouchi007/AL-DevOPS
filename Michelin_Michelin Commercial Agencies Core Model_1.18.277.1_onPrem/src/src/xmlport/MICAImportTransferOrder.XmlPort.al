xmlport 82320 "MICA Import Transfer Order"
{
    Caption = 'Import Transfer Order';
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
                textelement(AsnDateRaw) { }
                textelement(AsnNo) { }
                textelement(CarrierDocNo) { }
                textelement(ContainerID) { }
                textelement(DirectTransferRaw) { }
                textelement(ETARaw) { }
                textelement(InitialETARaw) { }
                textelement(InitialSRDRaw) { }
                textelement(InTransitCode) { }
                textelement(PortOfArrival) { }
                textelement(PostingDateRaw) { }
                textelement(ReceiptDateRaw) { }
                textelement(SealNo) { }
                textelement(ShipmentDateRaw) { }
                textelement(ShipmentMethodCode) { }
                textelement(ShippingAgentCode) { }
                textelement(ShippingAgentServiceCode) { }
                textelement(ShippingTimeRaw) { }
                textelement(SRDRaw) { }
                textelement(Status) { }
                textelement(TransferFromCode) { }
                textelement(TransferToCode) { }
                textelement(ItemNo) { }
                textelement(QuantityRaw) { }
                textelement(TransLineShipmentDateRaw) { }
                textelement(TransLineReceiptDateRaw) { }
                textelement(TransLineAsnNo) { }
                textelement(TransLineAsnLineNoRaw) { }
                textelement(TransLineAlNo) { }
                textelement(TransLineAlLineNo) { }
                textelement(PurchOrderNo) { }
                textelement(PurchOrderLineNoRaw) { }
                textelement(TransLineContainerID) { }
                textelement(TransLineASNDateRaw) { }
                textelement(TransLineETARaw) { }
                textelement(TransLineSRDRaw) { }
                textelement(TransLineInitialETARaw) { }
                textelement(TransLineInitialSRDRaw) { }
                textelement(TransLineSealNo) { }
                textelement(TransLInePortOfArrival) { }
                textelement(TransLineCarrierDocNo) { }
                textelement(CountryOfOrigin) { }

                trigger OnBeforeInsertRecord()
                begin
                    FileLineNo += 1;
                    if FileLineNo = 1 then
                        currXMLport.Skip();
                    CheckImportedData();
                    if PreviousASNNo <> AsnNo then
                        CreateTempTransHeader()
                    else
                        CreateTempTransLine();
                    PreviousASNNo := AsnNo;
                end;
            }
        }
    }
    trigger OnPreXmlPort()
    begin
        DocumentNo := 'DOC0';
    end;

    trigger OnPostXmlPort()
    var
        FileNameTxt: Label 'TransOrderError.pdf';
        ReportSubtitleTxt: Label 'Transfer Orders';
    begin
        if MICAImportDataErrorMgt.ErrorExist() then
            MICAImportDataErrorMgt.ExportFileWithErrors(DateFormat, DecimalSeparator, FileNameTxt, ReportSubtitleTxt)
        else
            CreateTransOrder();
    end;

    var
        TempTransferHeader: Record "Transfer Header" temporary;
        TempTransferLine: Record "Transfer Line" temporary;
        MICAImportDataErrorMgt: Codeunit "MICA Import Data Error Mgt";
        ShippingTime: DateFormula;
        Dialog: Dialog;
        DateFormat: Option "MM/DD/YYYYY","DD/MM/YYYY";
        DecimalSeparator: Option Comma,Dot;
        FileLineNo: Integer;
        AsnLineNo: Integer;
        PurchOrderLineNo: integer;
        AsnDate: Date;
        ETA: Date;
        InitialETA: Date;
        InitialSRD: Date;
        PostingDate: Date;
        ReceiptDate: Date;
        ShipmentDate: Date;
        SRD: Date;
        TransLineShipmentDate: Date;
        TransLineReceiptDate: Date;
        TransLineASNDate: Date;
        TransLineETA: Date;
        TransLineSRD: Date;
        TransLineInitETA: Date;
        TransLineInitSRD: Date;
        Quantity: Decimal;
        PreviousASNNo: Code[20];
        DocumentNo: Code[20];
        DirectTransfer: Boolean;
        FormatIsNotValidErr: Label 'The value %1 for the field %2 is not in a valid format.';
        NotExistInDatabaseErr: Label 'The value %1 for the field %2 does not exist in the related table %3.';
        OptionStringNotValidErr: Label 'Option String: %1 for the field %2 is not valid.';
        DialImportMsg: Label 'Any error has not found and Transfer Order will be created.\';
        DialProgr_Msg: Label 'Progress @2@@@@@@@@@@';

    local procedure CreateTransOrder()
    var
        TransferHeader: Record "Transfer Header";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        CurrTotal: Integer;
        TotalRecs: Integer;
        TransDocumentNo: Code[20];
    begin
        Dialog.Open(DialImportMsg + DialProgr_Msg);
        TempTransferHeader.Reset();
        TotalRecs := TempTransferHeader.Count();
        if TempTransferHeader.FindSet() then
            repeat
                CopyTempTransHeaderToPhysical(TempTransferHeader, TransDocumentNo);
                TempTransferLine.Reset();
                TempTransferLine.SetRange("Document No.", TempTransferHeader."No.");
                if TempTransferLine.FindSet() then
                    repeat
                        CopyTempTransLineToPhysical(TempTransferLine, TransDocumentNo);
                    until TempTransferLine.Next() = 0;
                if TempTransferHeader.Status = TempTransferHeader.Status::Released then begin
                    TransferHeader.Get(TransDocumentNo);
                    ReleaseTransferDocument.Run(TransferHeader);
                end;
                CurrTotal += 1;
                Dialog.UPDATE(2, ROUND(CurrTotal / TotalRecs * 10000, 1));
            until TempTransferHeader.Next() = 0
    end;

    local procedure CopyTempTransHeaderToPhysical(FromTransferHeader: Record "Transfer Header"; var DocNo: Code[20]);
    var
        TransferHeader: Record "Transfer Header";
    begin
        TransferHeader.Init();
        TransferHeader."No." := '';
        TransferHeader.Insert(true);
        TransferHeader.Validate("Transfer-from Code", FromTransferHeader."Transfer-from Code");
        TransferHeader.Validate("Transfer-to Code", FromTransferHeader."Transfer-to Code");
        TransferHeader.Validate("In-Transit Code", FromTransferHeader."In-Transit Code");
        TransferHeader.Validate("MICA ASN Date", FromTransferHeader."MICA ASN Date");
        TransferHeader.Validate("MICA ASN No.", FromTransferHeader."MICA ASN No.");
        TransferHeader.Validate("MICA Carrier Doc. No.", FromTransferHeader."MICA Carrier Doc. No.");
        TransferHeader.Validate("MICA Container ID", FromTransferHeader."MICA Container ID");
        TransferHeader.Validate("Direct Transfer", FromTransferHeader."Direct Transfer");
        TransferHeader.Validate("MICA ETA", FromTransferHeader."MICA ETA");
        TransferHeader.Validate("MICA Initial ETA", FromTransferHeader."MICA Initial ETA");
        TransferHeader.Validate("MICA Initial SRD", FromTransferHeader."MICA Initial SRD");
        TransferHeader.Validate("MICA Port of Arrival", FromTransferHeader."MICA Port of Arrival");
        TransferHeader.Validate("Posting Date", FromTransferHeader."Posting Date");
        TransferHeader.Validate("Receipt Date", FromTransferHeader."Receipt Date");
        TransferHeader.Validate("MICA Seal No.", FromTransferHeader."MICA Seal No.");
        TransferHeader.Validate("Shipment Date", FromTransferHeader."Shipment Date");
        TransferHeader.Validate("Shipment Method Code", FromTransferHeader."Shipment Method Code");
        TransferHeader.Validate("Shipping Agent Code", FromTransferHeader."Shipping Agent Code");
        TransferHeader.Validate("Shipping Agent Service Code", FromTransferHeader."Shipping Agent Service Code");
        TransferHeader.Validate("Shipping Time", FromTransferHeader."Shipping Time");
        TransferHeader.Validate("MICA SRD", FromTransferHeader."MICA SRD");
        TransferHeader.Modify();
        DocNo := TransferHeader."No.";
    end;

    local procedure CopyTempTransLineToPhysical(FromTransferLine: Record "Transfer Line"; DocNo: Code[20])
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.Init();
        TransferLine.Validate("Document No.", DocNo);
        TransferLine.Validate("Line No.", FromTransferLine."Line No.");
        TransferLine.Insert(true);
        TransferLine.Validate("Item No.", FromTransferLine."Item No.");
        TransferLine.Validate(Quantity, FromTransferLine.Quantity);
        TransferLine.Validate("Shipment Date", FromTransferLine."Shipment Date");
        TransferLine.Validate("Receipt Date", FromTransferLine."Receipt Date");
        TransferLine.Validate("MICA ASN No.", FromTransferLine."MICA ASN No.");
        TransferLine.Validate("MICA ASN Line No.", FromTransferLine."MICA ASN Line No.");
        TransferLine.Validate("MICA AL No.", FromTransferLine."MICA AL No.");
        TransferLine.Validate("MICA AL Line No.", FromTransferLine."MICA AL Line No.");
        TransferLine.Validate("MICA Purchase Order No.", FromTransferLine."MICA Purchase Order No.");
        TransferLine.Validate("MICA Purchase Order Line No.", FromTransferLine."MICA Purchase Order Line No.");
        TransferLine.Validate("MICA Container ID", FromTransferLine."MICA Container ID");
        TransferLine.Validate("MICA ASN Date", FromTransferLine."MICA ASN Date");
        TransferLine.Validate("MICA ETA", FromTransferLine."MICA ETA");
        TransferLine.Validate("MICA SRD", FromTransferLine."MICA SRD");
        TransferLine.Validate("MICA Initial ETA", FromTransferLine."MICA Initial ETA");
        TransferLine.Validate("MICA Initial SRD", FromTransferLine."MICA Initial SRD");
        TransferLine.Validate("MICA Seal No.", FromTransferLine."MICA Seal No.");
        TransferLine.Validate("MICA Port of Arrival", FromTransferLine."MICA Port of Arrival");
        TransferLine.Validate("MICA Carrier Doc. No.", FromTransferLine."MICA Carrier Doc. No.");
        TransferLine.Validate("MICA Country of Origin", FromTransferLine."MICA Country of Origin");
        TransferLine.Modify();
    end;

    local procedure CreateTempTransHeader()
    begin
        DocumentNo := IncStr(DocumentNo);
        TempTransferHeader.Init();
        TempTransferHeader."No." := DocumentNo;
        TempTransferHeader."MICA ASN Date" := AsnDate;
        TempTransferHeader."MICA ASN No." := CopyStr(AsnNo, 1, MaxStrLen(TempTransferHeader."MICA ASN No."));
        TempTransferHeader."MICA Carrier Doc. No." := CopyStr(CarrierDocNo, 1, MaxStrLen(TempTransferHeader."MICA Carrier Doc. No."));
        TempTransferHeader."MICA Container ID" := CopyStr(ContainerID, 1, MaxStrLen(TempTransferHeader."MICA Container ID"));
        TempTransferHeader."Direct Transfer" := DirectTransfer;
        TempTransferHeader."MICA ETA" := ETA;
        TempTransferHeader."MICA Initial ETA" := InitialETA;
        TempTransferHeader."MICA Initial SRD" := InitialSRD;
        TempTransferHeader."In-Transit Code" := CopyStr(InTransitCode, 1, MaxStrLen(TempTransferHeader."In-Transit Code"));
        TempTransferHeader."MICA Port of Arrival" := CopyStr(PortOfArrival, 1, MaxStrLen(TempTransferHeader."MICA Port of Arrival"));
        TempTransferHeader."Posting Date" := PostingDate;
        TempTransferHeader."Receipt Date" := ReceiptDate;
        TempTransferHeader."MICA Seal No." := CopyStr(SealNo, 1, MaxStrLen(TempTransferHeader."MICA Seal No."));
        TempTransferHeader."Shipment Date" := ShipmentDate;
        TempTransferHeader."Shipment Method Code" := CopyStr(ShipmentMethodCode, 1, MaxStrLen(TempTransferHeader."Shipment Method Code"));
        TempTransferHeader."Shipping Agent Code" := CopyStr(ShippingAgentCode, 1, MaxStrLen(TempTransferHeader."Shipping Agent Code"));
        TempTransferHeader."Shipping Agent Service Code" := CopyStr(ShippingAgentServiceCode, 1, MaxStrLen(TempTransferHeader."Shipping Agent Service Code"));
        TempTransferHeader."Shipping Time" := ShippingTime;
        TempTransferHeader."MICA SRD" := SRD;
        case Status of
            'Open':
                TempTransferHeader.Status := TempTransferHeader.Status::Open;
            'Released':
                TempTransferHeader.Status := TempTransferHeader.Status::Released;
        end;
        TempTransferHeader."Transfer-from Code" := CopyStr(TransferFromCode, 1, MaxStrLen(TempTransferHeader."Transfer-from Code"));
        TempTransferHeader."Transfer-to Code" := CopyStr(TransferToCode, 1, MaxStrLen(TempTransferHeader."Transfer-to Code"));
        TempTransferHeader.Insert();
        CreateTempTransLine();
    end;

    local procedure CreateTempTransLine()
    var
        LineNo: Integer;
    begin
        LineNo := 10000;
        TempTransferLine.Reset();
        TempTransferLine.SetRange("Document No.", DocumentNo);
        if TempTransferLine.FindLast() then
            LineNo += TempTransferLine."Line No.";

        TempTransferLine.Reset();
        TempTransferLine.Init();
        TempTransferLine."Document No." := DocumentNo;
        TempTransferLine."Line No." := LineNo;
        TempTransferLine."Item No." := CopyStr(ItemNo, 1, MaxStrLen(TempTransferLine."Item No."));
        TempTransferLine.Quantity := Quantity;
        TempTransferLine."Shipment Date" := TransLineShipmentDate;
        TempTransferLine."Receipt Date" := TransLineReceiptDate;
        TempTransferLine."MICA ASN No." := CopyStr(TransLineAsnNo, 1, MaxStrLen(TempTransferLine."MICA AL No."));
        if Evaluate(AsnLineNo, TransLineAsnLineNoRaw) then
            TempTransferLine."MICA ASN Line No." := AsnLineNo;
        TempTransferLine."MICA AL No." := CopyStr(TransLineAlNo, 1, MaxStrLen(TempTransferLine."MICA AL No."));
        TempTransferLine."MICA AL Line No." := CopyStr(TransLineAlLineNo, 1, MaxStrLen(TempTransferLine."MICA AL Line No."));
        TempTransferLine."MICA Purchase Order No." := CopyStr(PurchOrderNo, 1, MaxStrLen(TempTransferLine."MICA Purchase Order No."));
        if Evaluate(PurchOrderLineNo, PurchOrderLineNoRaw) then
            TempTransferLine."MICA Purchase Order Line No." := PurchOrderLineNo;
        TempTransferLine."MICA Container ID" := CopyStr(TransLineContainerID, 1, MaxStrLen(TempTransferLine."MICA Container ID"));
        TempTransferLine."MICA ASN Date" := TransLineASNDate;
        TempTransferLine."MICA ETA" := TransLineETA;
        TempTransferLine."MICA SRD" := TransLineSRD;
        TempTransferLine."MICA Initial ETA" := TransLineInitETA;
        TempTransferLine."MICA Initial SRD" := TransLineInitSRD;
        TempTransferLine."MICA Seal No." := CopyStr(TransLineSealNo, 1, MaxStrLen(TempTransferLine."MICA Seal No."));
        TempTransferLine."MICA Port of Arrival" := CopyStr(TransLInePortOfArrival, 1, MaxStrLen(TempTransferLine."MICA Port of Arrival"));
        TempTransferLine."MICA Carrier Doc. No." := CopyStr(TransLineCarrierDocNo, 1, MaxStrLen(TempTransferLine."MICA Carrier Doc. No."));
        TempTransferLine."MICA Country of Origin" := CopyStr(CountryOfOrigin, 1, MaxStrLen(TempTransferLine."MICA Country of Origin"));
        TempTransferLine.Insert();
    end;

    local procedure CheckImportedData()
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        Location: Record Location;
        ShippingAgent: Record "Shipping Agent";
        ShipmentMethod: Record "Shipment Method";
        ShippingAgentServices: Record "Shipping Agent Services";
        CountryRegion: Record "Country/Region";
        Item: Record Item;
    begin
        // Validation fields with relation
        if (InTransitCode <> '') and (not Location.Get(InTransitCode)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("In-Transit Code"), StrSubstNo(NotExistInDatabaseErr, InTransitCode, TransferHeader.FieldCaption("In-Transit Code"), Location.TableCaption()));
        if (ShipmentMethodCode <> '') and (not ShipmentMethod.Get(ShipmentMethodCode)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Shipment Method Code"), StrSubstNo(NotExistInDatabaseErr, ShipmentMethodCode, TransferHeader.FieldCaption("Shipment Method Code"), ShipmentMethod.TableCaption()));
        if (ShippingAgentCode <> '') and (not ShippingAgent.Get(ShippingAgentCode)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Shipping Agent Code"), StrSubstNo(NotExistInDatabaseErr, ShippingAgentCode, TransferHeader.FieldCaption("Shipping Agent Code"), ShippingAgent.TableCaption()));
        if (ShippingAgentServiceCode <> '') and (not ShippingAgentServices.Get(ShippingAgentCode, ShippingAgentServiceCode)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Shipping Agent Service Code"), StrSubstNo(NotExistInDatabaseErr, ShippingAgentServiceCode, TransferHeader.FieldCaption("Shipping Agent Service Code"), ShippingAgentServices.TableCaption()));
        if (Status <> 'Open') and (Status <> 'Released') then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption(Status), StrSubstNo(OptionStringNotValidErr, Status, TransferHeader.FieldCaption(Status)));
        if not Location.Get(TransferFromCode) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Transfer-from Code"), StrSubstNo(NotExistInDatabaseErr, TransferFromCode, TransferHeader.FieldCaption("Transfer-from Code"), Location.TableCaption()));
        if not Location.Get(TransferToCode) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Transfer-to Code"), StrSubstNo(NotExistInDatabaseErr, TransferToCode, TransferHeader.FieldCaption("Transfer-to Code"), Location.TableCaption()));
        if not Item.Get(ItemNo) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption("Item No."), StrSubstNo(NotExistInDatabaseErr, ItemNo, TransferLine.FieldCaption("Item No."), Item.TableCaption()));
        if (CountryOfOrigin <> '') and (not CountryRegion.Get(CountryOfOrigin)) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption("MICA Country of Origin"), StrSubstNo(NotExistInDatabaseErr, CountryOfOrigin, TransferLine.FieldCaption("MICA Country of Origin"), CountryRegion.TableCaption()));
        if not Evaluate(DirectTransfer, DirectTransferRaw) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Direct Transfer"), StrSubstNo(FormatIsNotValidErr, DirectTransferRaw, TransferHeader.FieldCaption("Direct Transfer")));
        if not Evaluate(ShippingTime, ShippingTimeRaw) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Shipping Time"), StrSubstNo(FormatIsNotValidErr, ShippingTimeRaw, TransferHeader.FieldCaption("Shipping Time")));

        // Validation of Date fields
        if not MICAImportDataErrorMgt.ValidDateFormat(AsnDateRaw, AsnDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("MICA ASN Date"), StrSubstNo(FormatIsNotValidErr, AsnDateRaw, TransferHeader.FieldCaption("MICA ASN Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(ETARaw, ETA, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("MICA ETA"), StrSubstNo(FormatIsNotValidErr, ETARaw, TransferHeader.FieldCaption("MICA ETA")));
        if not MICAImportDataErrorMgt.ValidDateFormat(InitialETARaw, InitialETA, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("MICA Initial ETA"), StrSubstNo(FormatIsNotValidErr, InitialETARaw, TransferHeader.FieldCaption("MICA Initial ETA")));
        if not MICAImportDataErrorMgt.ValidDateFormat(InitialSRDRaw, InitialSRD, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("MICA Initial SRD"), StrSubstNo(FormatIsNotValidErr, InitialSRDRaw, TransferHeader.FieldCaption("MICA Initial SRD")));
        if not MICAImportDataErrorMgt.ValidDateFormat(PostingDateRaw, PostingDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Posting Date"), StrSubstNo(FormatIsNotValidErr, PostingDateRaw, TransferHeader.FieldCaption("Posting Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(REceiptDateRaw, ReceiptDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Receipt Date"), StrSubstNo(FormatIsNotValidErr, REceiptDateRaw, TransferHeader.FieldCaption("Receipt Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(ShipmentDateRaw, ShipmentDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("Shipment Date"), StrSubstNo(FormatIsNotValidErr, ShipmentDateRaw, TransferHeader.FieldCaption("Shipment Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(SRDRaw, SRD, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferHeader.FieldCaption("MICA SRD"), StrSubstNo(FormatIsNotValidErr, SRDRaw, TransferHeader.FieldCaption("MICA SRD")));
        if not MICAImportDataErrorMgt.ValidDateFormat(TransLineShipmentDateRaw, TransLineShipmentDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption("Shipment Date"), StrSubstNo(FormatIsNotValidErr, TransLineShipmentDateRaw, TransferLine.FieldCaption("Shipment Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(TransLineReceiptDateRaw, TransLineReceiptDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption("Receipt Date"), StrSubstNo(FormatIsNotValidErr, REceiptDateRaw, TransferLine.FieldCaption("Receipt Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(TransLineETARaw, TransLineETA, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption("MICA ETA"), StrSubstNo(FormatIsNotValidErr, TransLineETARaw, TransferLine.FieldCaption("MICA ETA")));
        if not MICAImportDataErrorMgt.ValidDateFormat(TransLineSRDRaw, TransLineSRD, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption("MICA SRD"), StrSubstNo(FormatIsNotValidErr, TransLineSRDRaw, TransferLine.FieldCaption("MICA SRD")));
        if not MICAImportDataErrorMgt.ValidDateFormat(TransLineASNDateRaw, TransLineASNDate, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption("MICA ASN Date"), StrSubstNo(FormatIsNotValidErr, TransLineASNDateRaw, TransferLine.FieldCaption("MICA ASN Date")));
        if not MICAImportDataErrorMgt.ValidDateFormat(TransLineInitialETARaw, TransLineInitETA, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption("MICA Initial ETA"), StrSubstNo(FormatIsNotValidErr, TransLineInitialETARaw, TransferLine.FieldCaption("MICA Initial ETA")));
        if not MICAImportDataErrorMgt.ValidDateFormat(TransLineInitialSRDRaw, TransLineInitSRD, DateFormat) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption("MICA Initial SRD"), StrSubstNo(FormatIsNotValidErr, TransLineInitialSRDRaw, TransferLine.FieldCaption("MICA Initial SRD")));

        // Validation of decimal fields
        if not MICAImportDataErrorMgt.ValidDecimalSeparator(QuantityRaw, Quantity, DecimalSeparator) then
            MICAImportDataErrorMgt.InsertErrorMsg(FileLineNo, TransferLine.FieldCaption(Quantity), StrSubstNo(FormatIsNotValidErr, QuantityRaw, TransferLine.FieldCaption(Quantity)));

    end;

    procedure SetInputData(InputDateFormat: Option; InputDecimalSeparator: Option)
    begin
        DateFormat := InputDateFormat;
        DecimalSeparator := InputDecimalSeparator;
    end;

}