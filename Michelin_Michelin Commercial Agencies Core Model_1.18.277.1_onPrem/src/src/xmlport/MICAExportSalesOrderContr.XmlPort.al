xmlport 82380 "MICA Export Sales Order Contr."
{
    //FDM003 eFDM – Sales Order Interface Contract
    Caption = 'eFDM Sales Order Interface Contract';
    Direction = Export;
    Format = VariableText;
    FieldDelimiter = '';
    FieldSeparator = ';';
    RecordSeparator = '<LF>';
    TableSeparator = '<LF>';
    UseRequestPage = false;

    schema
    {
        textelement(NodeName1)
        {
            tableelement(BlockHeaderFile; Integer)
            {
                XmlName = 'HeaderFile';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(HeaderFile) { }
                textelement(Application) { }
                textelement(Instance) { }
                textelement(FlowName) { }
                textelement(AppMode) { }

                textelement(FileDate) { }
                textelement(Uniquekey) { }

                textelement(SourceDataFileName) { }
                textelement(SourceFileExtractDate) { }
                textelement(HeaderFileName) { }

                trigger OnAfterGetRecord()
                begin
                    ConstantRowCount += 1;
                    HeaderFile := ParamValue_HeaderFile;
                    Application := ParamValue_Application;
                    Instance := ParamValue_Instance + '_' + CountryRegion."ISO Code";
                    FlowName := ParamValue_FlowName;
                    AppMode := ParamValue_AppMode;
                    FileDate := FORMAT(CurrentDateTime(), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z');
                    Uniquekey := ParamValue_Application + '_' + CountryRegion."ISO Code" + '_' +
                                    FORMAT(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');
                    SourceDataFileName := ParamValue_Application + '_' + CountryRegion."ISO Code" + '_' + MICAFinancialReportingSetup."Company Code";
                    SourceFileExtractDate := FileDate;
                    FileName := GenerateFileName();
                    HeaderFileName := FileName;
                end;

            }
            tableelement(DataHeaderBlock; Integer)
            {
                XmlName = 'HeaderBlock';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(HeaderBlock) { }
                textelement(HeaderBlockName) { }

                trigger OnAfterGetRecord()
                begin
                    HeaderBlock := ParamValue_HeaderBlock;
                    HeaderBlockName := ParamValue_BlockName;
                end;
            }
            tableelement(DataBlock; Integer)
            {
                XmlName = 'DataBlock';
                SourceTableView = sorting(Number);
                textelement(RecordIdentifier) { } // 1
                textelement(OrganizationCode) { } // 2
                textelement(CustomerCountry) { } // 3
                textelement(WarehouseCountry) { } // 4
                textelement(CustomerLegalEntityCode) { } // 5
                textelement(SellToCustomerCode) { } // 6
                textelement(BillToCustomerCode) { } // 7
                textelement(ShipToCustomerCode) { } // 8
                textelement(ActualArrivalDate) { } // 9
                textelement(ActualShipmentDate) { } // 10
                textelement(CreditHoldApplyingDate) { } // 11
                textelement(CreditHoldFlag) { } // 12
                textelement(CreditHoldReleasingDate) { } // 13
                textelement(DeliveryNote) { } // 14
                textelement(DeliveryService) { } // 15
                textelement(DocumentNum) { } // 16
                textelement(LineNumber) { } // 17
                textelement(LineStatus) { } // 18
                textelement(LineStatusUpdateDate) { } // 19
                textelement(LogisticDate) { } // 20
                textelement(MarketCode) { } // 21
                textelement(DocumentDate) { } // 22
                textelement(DocumentHeaderStatus) { } // 23
                textelement(OriginalCommitmentDate) { } // 24
                textelement(OriginalCommitmentReceptionDate) { } // 25
                textelement(RequestDate) { } // 26
                textelement(RequestReceptionDate) { } // 27
                textelement(ScheduleArrivalDate) { } // 28
                textelement(ScheduleReceptionDate) { } // 29
                textelement(OCCode) { } // 30
                textelement(ItemCode) { } // 31
                textelement(ItemLineDescription) { } // 32
                textelement(OrderedQuantity) { } // 33
                textelement(DeliveredQuantity) { } // 34
                textelement(CanceledQuantity) { } // 35
                textelement(DocumentType) { } // 36
                textelement(OrderSource) { } // 37
                textelement(ShipFromOrganization) { } // 38
                textelement(CancellationFlag) { } // 39
                textelement(CancellationReason) { } // 40
                textelement(CountryOfOrigin) { } // 41
                textelement(Dot) { } // 42
                textelement(ProductLine) { } // 43
                textelement(ForecastCustCode) { } // 44
                textelement(BillToSiteUseCode) { } // 45
                textelement(ShipToSiteUseCode) { } // 45
                textelement(InventoryOrganization) { }
                textelement(CancellationResonRef) { }
                textelement(PlannedShipmentDate) { }
                textelement(ShipConfirmationDate) { }

                trigger OnPreXmlItem()
                begin
                    TempSalesLineArchive.Reset();
                    TempSalesLineArchive.SetCurrentKey("Document Type", "Document No.", "Line No.", "Doc. No. Occurrence", "Version No.");
                    ExportedRecordCount := TempSalesLineArchive.Count();

                    DataBlock.SetFilter(Number, '%1..%2', 1, ExportedRecordCount);
                end;

                trigger OnAfterGetRecord()
                var
                    ApprowalEntry: Record "Approval Entry";
                    SOLineDoesntExist: Boolean;
                begin
                    if DataBlock.Number = 1 then
                        TempSalesLineArchive.FindFirst()
                    else
                        TempSalesLineArchive.Next();
                    RecordIdentifier := ParamValue_Recordidentifier;
                    OrganizationCode := MICAFinancialReportingSetup."Company Code";
                    CustomerCountry := CountryRegion."ISO Code";
                    WarehouseCountry := GetLocationCountryISOCode(TempSalesLineArchive."Location Code");
                    CustomerLegalEntityCode := GetCustomerMDMIDLE(TempSalesLineArchive."Bill-to Customer No.");
                    SellToCustomerCode := GetCustomerMDMIDBT(TempSalesLineArchive."Sell-to Customer No.");
                    BillToCustomerCode := GetCustomerMDMIDLE(TempSalesLineArchive."Bill-to Customer No.");
                    BillToSiteUseCode := GetCustomerUseID(TempSalesLineArchive."Bill-to Customer No.");
                    ShipToCustomerCode := GetAddressMDMID(TempSalesLineArchive."Work Type Code", TempSalesLineArchive."Sell-to Customer No.");
                    ShipToSiteUseCode := GetAddressUseID(TempSalesLineArchive."Work Type Code", TempSalesLineArchive."Sell-to Customer No.");
                    ApprowalEntry.SetRange("Table ID", 36);
                    ApprowalEntry.SetRange("Document No.", TempSalesLineArchive."Document No.");
                    ApprowalEntry.SetRange("Approval Code", SalesReceivablesSetup."MICA Approval Workflow");
                    ApprowalEntry.SetRange(Status, ApprowalEntry.Status::Open);
                    if not ApprowalEntry.IsEmpty() then begin
                        CreditHoldFlag := 'Y';
                        CreditHoldApplyingDate := '';
                        CreditHoldReleasingDate := '';
                    end else begin
                        CreditHoldFlag := 'N';

                        if GetLastApprovalEntryForCreditDates(ApprowalEntry) then begin
                            CreditHoldApplyingDate := Format(ApprowalEntry."Date-Time Sent for Approval", 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z');
                            CreditHoldReleasingDate := Format(ApprowalEntry."Last Date-Time Modified", 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z');
                        end else begin
                            CreditHoldApplyingDate := '';
                            CreditHoldReleasingDate := '';
                        end;
                    end;

                    DeliveryService := TempSalesLineArchive."Unit of Measure";
                    DocumentNum := TempSalesLineArchive."Document No.";
                    LineNumber := Format(TempSalesLineArchive."Line No.");
                    LineStatus := GetLineStatus(TempSalesLineArchive);
                    if TempSalesLineArchive."MICA Last Date Update Status" <> 0DT then
                        LineStatusUpdateDate := Format(TempSalesLineArchive."MICA Last Date Update Status", 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z')
                    else
                        LineStatusUpdateDate := Format(ExecutionDateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z');
                    LogisticDate := Format(CreateDateTime(TempSalesLineArchive."Shipment Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z');
                    MarketCode := GetItemMarketCode(TempSalesLineArchive."No.");
                    DocumentDate := Format(CreateDateTime(TempSalesLineArchive."FA Posting Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z');
                    DocumentHeaderStatus := TempSalesLineArchive."Description 2";
                    OCCode := CountryRegion."ISO Code";
                    ItemCode := TempSalesLineArchive."No.";
                    ItemLineDescription := TempSalesLineArchive.Description;
                    OrderedQuantity := Format(TempSalesLineArchive.Quantity, 0, 1);
                    if LineStatus = Format(TempSalesLineArchive."MICA Status"::Closed) then
                        DeliveredQuantity := Format(TempSalesLineArchive.Quantity, 0, 1)
                    else
                        DeliveredQuantity := Format(TempSalesLineArchive."Quantity Shipped", 0, 1);

                    ShipConfirmationDate := GetShipmentDate(TempSalesLineArchive."Document No.", TempSalesLineArchive."Line No.");
                    If TempSalesLineArchive."MICA Cancelled" and (TempSalesLineArchive."MICA Cancel. Reason" <> '') then begin
                        CanceledQuantity := Format(TempSalesLineArchive."Outstanding Quantity", 0, 1);
                        CancellationFlag := 'Y';
                        CancellationResonRef := GetCancellationReasonRef(TempSalesLineArchive."MICA Cancel. Reason");
                    end else begin
                        CanceledQuantity := Format(0);
                        SOLineDoesntExist := (ShipConfirmationDate = '') and (not SOLineExists(TempSalesLineArchive));
                        if SOLineDoesntExist then begin
                            CancellationFlag := 'Y';
                            CancellationResonRef := 'ATI';
                        end else begin
                            CancellationFlag := 'N';
                            CancellationResonRef := '';
                        end;
                    end;

                    case TempSalesLineArchive."Document Type" of
                        TempSalesLineArchive."Document Type"::Order:
                            DocumentType := ParamValue_DocumentTypeSO;
                        TempSalesLineArchive."Document Type"::"Return Order":
                            DocumentType := ParamValue_DocumentTypeSOR;
                    end;
                    OrderSource := TempSalesLineArchive."MICA Countermark";
                    ShipFromOrganization := TempSalesLineArchive."Location Code";
                    if not SOLineDoesntExist then
                        CancellationReason := TempSalesLineArchive."MICA Cancel. Reason"
                    else
                        CancellationReason := 'TECHNICAL_REASON';
                    CountryOfOrigin := TempSalesLineArchive."MICA 3PL Country Of Origin";
                    Dot := TempSalesLineArchive."MICA 3PL DOT Value";
                    ProductLine := TempSalesLineArchive."Item Category Code";
                    ForecastCustCode := GetForecastCode(TempSalesLineArchive."Bill-to Customer No.", TempSalesLineArchive."Item Category Code");
                    ActualArrivalDate := GetActualArrivalDate(TempSalesLineArchive);
                    if LineStatus = Format(TempSalesLineArchive."MICA Status"::Closed) then
                        ActualShipmentDate := GetShipmentDate(TempSalesLineArchive."Document No.", TempSalesLineArchive."Line No.")
                    else
                        ActualShipmentDate := '';
                    if TempSalesLineArchive."Promised Delivery Date" <> 0D then
                        OriginalCommitmentDate := Format(CreateDateTime(TempSalesLineArchive."Promised Delivery Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z')
                    else
                        OriginalCommitmentDate := '';

                    if TempSalesLineArchive."MICA Promised Receipt Date" <> 0D then
                        OriginalCommitmentReceptionDate := Format(CreateDateTime(TempSalesLineArchive."Promised Delivery Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z')
                    else
                        OriginalCommitmentReceptionDate := '';

                    if TempSalesLineArchive."Requested Delivery Date" <> 0D then
                        RequestDate := Format(CreateDateTime(TempSalesLineArchive."Requested Delivery Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z')
                    else
                        RequestDate := '';

                    if TempSalesLineArchive."MICA Requested Receipt Date" <> 0D then
                        RequestReceptionDate := Format(CreateDateTime(TempSalesLineArchive."MICA Requested Receipt Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z')
                    else
                        RequestReceptionDate := '';

                    if TempSalesLineArchive."Planned Delivery Date" <> 0D then
                        ScheduleArrivalDate := Format(CreateDateTime(TempSalesLineArchive."Planned Delivery Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z')
                    else
                        ScheduleArrivalDate := '';

                    if TempSalesLineArchive."Shipment Date" <> 0D then
                        ScheduleReceptionDate := Format(CreateDateTime(TempSalesLineArchive."Shipment Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z')
                    else
                        ScheduleReceptionDate := '';

                    InventoryOrganization := GetLocationInventoryOrg(TempSalesLineArchive."Location Code");
                    if TempSalesLineArchive."Planned Shipment Date" <> 0D then
                        PlannedShipmentDate := Format(CreateDateTime(TempSalesLineArchive."Planned Shipment Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z')
                    else
                        PlannedShipmentDate := '';
                    CheckMandatoryFields(TempSalesLineArchive);
                end;

            }
            tableelement(FooterDataBlock; Integer)
            {
                XmlName = 'FooterBlock';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(FooterBlock) { }
                textelement(FooterBlockName) { }
                textelement(NbData) { }
                trigger OnAfterGetRecord()
                begin
                    ConstantRowCount += 1;
                    FooterBlock := ParamValue_FooterBlock;
                    FooterBlockName := ParamValue_BlockName;
                    NbData := FORMAT(ExportedRecordCount, 0, 1);
                end;
            }
            tableelement(FileFooter; Integer)
            {
                XmlName = 'FooterBlock';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(FooterFile) { }
                textelement(FileNbData) { }
                trigger OnAfterGetRecord()
                begin
                    FooterFile := ParamValue_FooterFile;
                    FileNbData := Format(ExportedRecordCount + ConstantRowCount, 0, 1);// ConstantRowCount need to increment every time when new constant row is added
                end;
            }
            tableelement(LastEmptyRow; Integer)
            {
                SourceTableView = sorting(Number) where(Number = const(1));
            }
        }
    }
    trigger OnPreXmlPort()

    begin
        MICAFinancialReportingSetup.Get();
        SalesReceivablesSetup.Get();
        CheckIfFieldIsEmpty(
            MICAFinancialReportingSetup."Company Code",
            StrSubstNo(MissingFieldValueTxt, OrganizationCodeTok),
            StrSubstNo(MissingFieldValueKeyTxt, MICAFinancialReportingSetup.FieldCaption("Company Code"), MICAFinancialReportingSetup.TableCaption(), ''));

        CompanyInformation.Get();
        ExecutionDateTime := CurrentDateTime();
        if not CountryRegion.Get(CompanyInformation."Country/Region Code") then
            CountryRegion.Init();
        CheckIfFieldIsEmpty(
            CountryRegion."ISO Code",
            StrSubstNo(MissingFieldValueTxt, CustomerCountryTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                CountryRegion.FieldCaption("ISO Code"),
                CountryRegion.TableCaption(),
                StrSubstNo(NoKeyTxt, CountryRegion.Code)));
        if ParamValue_DateFilter <> '' then
            if not ValidDateFilter(ParamValue_DateFilter) then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(DateFilterMsg, ParamValue_DateFilter, Param_DATEFILTERTxt), '');
                currXMLport.Break();
            end;
        SetData();
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        CompanyInformation: Record "Company Information";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CountryRegion: Record "Country/Region";
        MICAFlowEntry: Record "MICA Flow Entry";
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
        TempSalesLineArchive: Record "Sales Line Archive" Temporary;
        LastProcessedDateTime: DateTime;
        ExecutionDateTime: DateTime;
        ExportedRecordCount: Integer;
        ParamValue_FileName: Text;
        ParamValue_DocumentType: Text;
        ParamValue_Instance: Text;
        ParamValue_HeaderFile: Text;
        ParamValue_Application: Text;
        ParamValue_FlowName: Text;
        ParamValue_AppMode: Text;
        ParamValue_HeaderBlock: Text;
        ParamValue_BlockName: Text;
        ParamValue_FooterBlock: Text;
        ParamValue_FooterFile: Text;
        ParamValue_Recordidentifier: Text;
        ParamValue_DocumentTypeSO: Text;
        ParamValue_DocumentTypeSOR: Text;
        ParamValue_ORDERSOURCEBC: Text;
        ParamValue_ORDERSOURCEBIBNET: Text;
        ParamValue_CREDITLIMITWORKFLOW: Text;
        ParamValue_DATEFILTER: Text;
        FileName: Text;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingParamValueMsg: Label 'Missing value for parameter %1';
        Param_FileNameTxt: Label 'FILENAME', Locked = true;
        Param_DocumentTypeTxt: Label 'DOCUMENTTYPE', Locked = true;
        Param_InstanceTxt: Label 'INSTANCE', Locked = true;
        Param_HeaderFileTxt: Label 'HEADERFILE', Locked = true;
        Param_ApplicationTxt: Label 'APPLICATION', Locked = true;
        Param_FlowNameTxt: Label 'FLOWNAME', Locked = true;
        Param_AppModeTxt: Label 'APPMODE', Locked = true;
        Param_HeaderBlockTxt: Label 'HEADERBLOCK', Locked = true;
        Param_BlockNameTxt: Label 'BLOCKNAME', Locked = true;
        Param_FooterBlockTxt: Label 'FOOTERBLOCK', Locked = true;
        Param_FooterFileTxt: Label 'FOOTERFILE', locked = true;
        Param_RecordidentifierTxt: Label 'RECORDIDENTIFIER', Locked = true;
        Param_DocumentTypeSOTxt: Label 'DOCUMENTTYPESO', Locked = true;
        Param_DocumentTypeSORTxt: Label 'DOCUMENTTYPESOR', Locked = true;
        Param_ORDERSOURCEBCTxt: Label 'ORDERSOURCEBC', Locked = true;
        Param_ORDERSOURCEBIBNETTxt: Label 'ORDERSOURCEBIBNET', Locked = true;
        Param_CREDITLIMITWORKFLOWTxt: Label 'CREDITLIMITWORKFLOW', Locked = true;
        Param_DATEFILTERTxt: Label 'DATEFILTER', Locked = true;
        DateFilterMsg: Label 'Parameter value: %1, for Parameter: %2, is not valid.';
        MissingFieldValueTxt: Label 'Missing Value for %1. ';
        MissingFieldValueKeyTxt: Label '%1 is empty in the record %2 where: %3';
        BSCLbl: Label 'BSC', Locked = true;
        NoKeyTxt: Label 'No: %1', Locked = true;
        ShipToAddressKeyTxt: Label 'Code: %1, Customer No: %2';
        DocKeyTxt: Label 'Document No: %1, Line No: %2';
        OrganizationCodeTok: Label 'ORGANIZATION CODE', Locked = true;
        CustomerCountryTok: Label 'CUSTOMER_COUNTRY', Locked = true;
        WarehouseCountryTok: Label 'WAREHOUSE_COUNTRY', Locked = true;
        CustLegalEntityCodeTok: Label 'CUSTOMER_LEGAL_ENTITY_CODE', Locked = true;
        SellToCustCodeTok: Label 'SELL_TO_CUSTOMER_CODE', Locked = true;
        ShipToCustCodeTok: Label 'SHIP_TO_CUSTOMER_CODE', Locked = true;
        MarketCodeTok: Label 'MARKET_CODE', Locked = true;
        DocumentDateTok: Label 'DOCUMENT_DATE', Locked = true;
        ShipFromOrganizationTok: Label 'SHIP_FROM_ORGANIZATION', Locked = true;
        ConstantRowCount: Integer;

    local procedure CheckMandatoryFields(SalesLineArchive: Record "Sales Line Archive")
    var
        Location: Record Location;
        Customer: Record Customer;
        ShiptoAddress: Record "Ship-to Address";
        Item: Record Item;
        SalesHeaderArchive: record "Sales Header Archive";
    begin
        if not Location.Get(SalesLineArchive."Location Code") then
            Location.Init();
        CheckIfFieldIsEmpty(
            WarehouseCountry,
            StrSubstNo(MissingFieldValueTxt, WarehouseCountryTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                CountryRegion.FieldCaption("ISO Code"),
                CountryRegion.TableCaption(),
                StrSubstNo(NoKeyTxt, Location."Country/Region Code")));
        CheckIfFieldIsEmpty(
            CustomerLegalEntityCode,
            StrSubstNo(MissingFieldValueTxt, CustLegalEntityCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                Customer.FieldCaption("MICA MDM ID LE"),
                Customer.TableCaption(),
                StrSubstNo(NoKeyTxt, SalesLineArchive."Bill-to Customer No.")));
        CheckIfFieldIsEmpty(
            SellToCustomerCode,
            StrSubstNo(MissingFieldValueTxt, SellToCustCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                Customer.FieldCaption("MICA MDM ID LE"),
                Customer.TableCaption(),
                StrSubstNo(NoKeyTxt, SalesLineArchive."Sell-to Customer No.")));
        CheckIfFieldIsEmpty(
            ShipToCustomerCode,
            StrSubstNo(MissingFieldValueTxt, ShipToCustCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                ShiptoAddress.FieldCaption("MICA MDM ID"),
                ShiptoAddress.TableCaption(),
                StrSubstNo(ShipToAddressKeyTxt, SalesLineArchive."Work Type Code", SalesLineArchive."Sell-to Customer No.")));
        CheckIfFieldIsEmpty(
            MarketCode,
            StrSubstNo(MissingFieldValueTxt, MarketCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                Item.FieldCaption("MICA Market Code"),
                Item.TableCaption(),
                StrSubstNo(NoKeyTxt, SalesLineArchive."No.")));
        CheckIfFieldIsEmpty(
            Format(TempSalesLineArchive."FA Posting Date"),
            StrSubstNo(MissingFieldValueTxt, DocumentDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesHeaderArchive.FieldCaption("Order Date"),
                SalesHeaderArchive.TableCaption(),
                StrSubstNo(NoKeyTxt, SalesLineArchive."Document No.")));
        CheckIfFieldIsEmpty(
            ShipFromOrganization,
            StrSubstNo(MissingFieldValueTxt, ShipFromOrganizationTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesLineArchive.FieldCaption("Location Code"),
                SalesLineArchive.TableCaption(),
                StrSubstNo(DocKeyTxt, SalesLineArchive."Document No.", SalesLineArchive."Line No.")));

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
    begin
        exit(FileName);
    end;

    procedure GenerateFileName(): Text
    var
        FoundCompanyInformation: Record "Company Information";
        FileNameLocal: Text;
        InstanceID: Text;
    begin
        FoundCompanyInformation.Get();
        InstanceID := BSCLbl + '_' + FoundCompanyInformation."Country/Region Code";

        FileNameLocal := StrSubstNo(ParamValue_FileName,
                                    ParamValue_DocumentType,
                                    ParamValue_Instance + '_' + CountryRegion."ISO Code",
                                    MICAFinancialReportingSetup."Company Code",
                                    FORMAT(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
        exit(FileNameLocal);
    end;

    procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParameters(Param_FileNameTxt, ParamValue_FileName, true);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentTypeTxt, ParamValue_DocumentType, true);
        CheckPrerequisitesAndRetrieveParameters(Param_InstanceTxt, ParamValue_Instance, true);
        CheckPrerequisitesAndRetrieveParameters(Param_HeaderFileTxt, ParamValue_HeaderFile, true);
        CheckPrerequisitesAndRetrieveParameters(Param_ApplicationTxt, ParamValue_Application, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FlowNameTxt, ParamValue_FlowName, true);
        CheckPrerequisitesAndRetrieveParameters(Param_AppModeTxt, ParamValue_AppMode, true);
        CheckPrerequisitesAndRetrieveParameters(Param_HeaderBlockTxt, ParamValue_HeaderBlock, true);
        CheckPrerequisitesAndRetrieveParameters(Param_BlockNameTxt, ParamValue_BlockName, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FooterBlockTxt, ParamValue_FooterBlock, true);
        CheckPrerequisitesAndRetrieveParameters(Param_RecordidentifierTxt, ParamValue_Recordidentifier, true);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentTypeSOTxt, ParamValue_DocumentTypeSO, true);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentTypeSORTxt, ParamValue_DocumentTypeSOR, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FooterFileTxt, ParamValue_FooterFile, true);

        CheckPrerequisitesAndRetrieveParameters(Param_ORDERSOURCEBCTxt, ParamValue_ORDERSOURCEBC, true);
        CheckPrerequisitesAndRetrieveParameters(Param_ORDERSOURCEBIBNETTxt, ParamValue_ORDERSOURCEBIBNET, true);
        CheckPrerequisitesAndRetrieveParameters(Param_CREDITLIMITWORKFLOWTxt, ParamValue_CREDITLIMITWORKFLOW, true);
        CheckPrerequisitesAndRetrieveParameters(Param_DATEFILTERTxt, ParamValue_DATEFILTER, false);
    end;

    procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20]; var ParamValue: Text; Mandatory: Boolean)
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        ParamValue := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if (ParamValue = '') and Mandatory then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamValueMsg, Param), '');
    end;

    procedure SetLastProcessedDateTime(NewLastProcessedDateTime: DateTime)
    begin
        LastProcessedDateTime := NewLastProcessedDateTime;
    end;

    local procedure SetData()
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        FirstSalesLineArchive: Record "Sales Line Archive";
        LastDocType: Integer;
        LastDocNo: Code[20];
        FoundSalesLineArchive: Boolean;
    begin
        LastDocType := 0;
        LastDocNo := '';

        SalesHeaderArchive.Ascending(false);
        SalesHeaderArchive.SetFilter("Document Type", '%1|%2', SalesHeaderArchive."Document Type"::Order, SalesHeaderArchive."Document Type"::"Return Order");
        if ParamValue_DATEFILTER <> '' then
            SalesHeaderArchive.SetFilter("Date Archived", ParamValue_DATEFILTER)
        else begin
            SalesHeaderArchive.SetFilter("Date Archived", '>%1', DT2Date(LastProcessedDateTime));
            SalesHeaderArchive.SetFilter("Time Archived", '>%1', DT2Time(LastProcessedDateTime));
        end;
        if SalesHeaderArchive.FindSet() then
            repeat
                FoundSalesLineArchive := false;
                if (LastDocType <> SalesHeaderArchive."Document Type".AsInteger()) or (LastDocNo <> SalesHeaderArchive."No.") then
                    if FindFirstSalesLineArchiveWithLine(SalesHeaderArchive, FirstSalesLineArchive) then begin
                        GetSalesLineArchive(SalesHeaderArchive, FirstSalesLineArchive);
                        FoundSalesLineArchive := true;
                    end;
                if FoundSalesLineArchive then begin
                    LastDocType := SalesHeaderArchive."Document Type".AsInteger();
                    LastDocNo := SalesHeaderArchive."No.";
                end;
            until SalesHeaderArchive.Next() = 0;
    end;

    local procedure FindFirstSalesLineArchiveWithLine(SalesHeaderArchive: Record "Sales Header Archive"; var SalesLineArchive: Record "Sales Line Archive"): Boolean;
    begin
        SalesLineArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
        SalesLineArchive.SetRange(SalesLineArchive."Document No.", SalesHeaderArchive."No.");
        SalesLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
        SalesLineArchive.SetRange("Version No.", SalesHeaderArchive."Version No.");
        SalesLineArchive.SetRange(Type, SalesLineArchive.Type::Item);
        SalesLineArchive.SetFilter("No.", '<>%1', '');
        exit(not SalesLineArchive.IsEmpty());
    end;

    local procedure GetSalesLineArchive(SalesHeaderArchive: Record "Sales Header Archive"; var FirstSalesLineArchive: Record "Sales Line Archive")
    begin
        if FirstSalesLineArchive.FindSet() then
            repeat
                CopyToTempSalesLineArchive(FirstSalesLineArchive, SalesHeaderArchive);
            until FirstSalesLineArchive.Next() = 0;

        if FindMissingSalesLineArchiveWithLine(SalesHeaderArchive, FirstSalesLineArchive) then
            if FirstSalesLineArchive.FindSet() then
                repeat
                    CopyToTempSalesLineArchive(FirstSalesLineArchive, SalesHeaderArchive);
                until FirstSalesLineArchive.Next() = 0;
    end;

    local procedure FindMissingSalesLineArchiveWithLine(SalesHeaderArchive: Record "Sales Header Archive"; var SalesLineArchive: Record "Sales Line Archive"): Boolean;
    begin
        SalesLineArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
        SalesLineArchive.SetRange("Document No.", SalesHeaderArchive."No.");
        SalesLineArchive.SetRange("Doc. No. Occurrence", SalesHeaderArchive."Doc. No. Occurrence");
        SalesLineArchive.SetFilter("Version No.", '<%1', SalesHeaderArchive."Version No.");
        SalesLineArchive.SetRange(Type, SalesLineArchive.Type::Item);
        SalesLineArchive.SetFilter("No.", '<>%1', '');
        exit(not SalesLineArchive.IsEmpty());
    end;

    local procedure CopyToTempSalesLineArchive(FromSalesLineArchive: Record "Sales Line Archive"; SalesHeaderArchive: Record "Sales Header Archive")
    begin
        If TempSalesArchiveLineExist(FromSalesLineArchive) then
            exit;

        TempSalesLineArchive.Init();
        TempSalesLineArchive.TransferFields(FromSalesLineArchive);
        TempSalesLineArchive."Work Type Code" := SalesHeaderArchive."Ship-to Code";
        case SalesHeaderArchive."MICA Order Type" of
            SalesHeaderArchive."MICA Order Type"::"Express Order":
                TempSalesLineArchive."Unit of Measure" := 'Express';
            SalesHeaderArchive."MICA Order Type"::"Standard Order":
                TempSalesLineArchive."Unit of Measure" := 'Standard';
        end;
        TempSalesLineArchive."FA Posting Date" := SalesHeaderArchive."Order Date";
        TempSalesLineArchive."Description 2" := Format(SalesHeaderArchive.Status);

        if IsNullGuid(SalesHeaderArchive."MICA Unique Webshop Doc. Id") then
            TempSalesLineArchive."MICA Countermark" := CopyStr(ParamValue_ORDERSOURCEBC, 1, 80)
        else
            TempSalesLineArchive."MICA Countermark" := CopyStr(ParamValue_ORDERSOURCEBIBNET, 1, 80);
        TempSalesLineArchive.Insert();
    end;

    local procedure TempSalesArchiveLineExist(FromSalesLineArchive: Record "Sales Line Archive"): Boolean
    begin
        TempSalesLineArchive.SetRange("Document Type", FromSalesLineArchive."Document Type");
        TempSalesLineArchive.SetRange("Document No.", FromSalesLineArchive."Document No.");
        TempSalesLineArchive.SetRange(Type, FromSalesLineArchive.Type::Item);
        TempSalesLineArchive.SetRange("Line No.", FromSalesLineArchive."Line No.");
        exit(not TempSalesLineArchive.IsEmpty());
    end;

    local procedure GetLocationCountryISOCode(LocationCode: Code[20]): Code[2]
    var
        Location: Record Location;
        LocalCountryRegion: Record "Country/Region";
    begin
        if not Location.Get(LocationCode) then
            exit;
        if LocalCountryRegion.Get(Location."Country/Region Code") then
            exit(LocalCountryRegion."ISO Code");
    end;

    local procedure GetCustomerMDMIDLE(CustomerNo: Code[20]): Code[40]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then
            exit(Customer."MICA MDM ID LE");
    end;

    local procedure GetCustomerMDMIDBT(CustomerNo: Code[20]): Code[40]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then
            exit(Customer."MICA MDM ID BT");
    end;

    local procedure GetCustomerUseID(CustomerNo: Code[20]): Code[40]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then
            exit(Customer."MICA MDM Bill-to Site Use ID")
        else
            exit('');
    end;

    local procedure GetAddressMDMID(ShipToAddressCode: Code[20]; CustomerNo: code[20]): Code[40]
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        if ShiptoAddress.Get(CustomerNo, ShipToAddressCode) then
            exit(ShiptoAddress."MICA MDM ID")
    end;

    local procedure GetAddressUseID(ShipToAddressCode: Code[20]; CustomerNo: code[20]): Code[40]
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        if ShiptoAddress.Get(CustomerNo, ShipToAddressCode) then
            exit(ShiptoAddress."MICA MDM Ship-to Use ID")
        else
            exit('');
    end;

    local procedure GetItemMarketCode(ItemNo: Code[20]): Code[2]
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            exit(Item."MICA Market Code")
    end;


    [TryFunction]
    local procedure ValidDateFilter(var DateFilter: Text)
    var
        LocalItem: Record Item;
        TextMgtFilterTokens: Codeunit "Filter Tokens";
    begin
        TextMgtFilterTokens.MakeDateFilter(DateFilter);
        LocalItem.SETFILTER("Date Filter", DateFilter);
        DateFilter := LocalItem.GETFILTER("Date Filter");
    end;

    local procedure GetForecastCode(CustCode: code[20]; ProductLine: Code[20]): Code[5]
    var
        MICAForecastCustomerCode: Record "MICA Forecast Customer Code";
    begin
        if MICAForecastCustomerCode.Get(CustCode, ProductLine) then
            exit(MICAForecastCustomerCode."Forecast Code");
    end;

    local procedure CheckIfFieldIsEmpty(FieldValue: Text; Description: Text; Description2: Text)
    begin
        if FieldValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, Description, Description2);
    end;

    local procedure GetLocationInventoryOrg(LocationCode: Code[20]): code[3]
    var
        Location: Record Location;
    begin
        if not Location.Get(LocationCode) then
            exit;
        exit(Location."MICA Inventory Organization");
    end;

    local procedure GetCancellationReasonRef(ReasonCode: Code[20]): Code[3]
    var
        MICATableValue: Record "MICA Table Value";
    begin
        if MICATableValue.Get(MICATableValue."Table Type"::SalesLineCancelReasonCode, ReasonCode) then
            exit(MICATableValue."CT2 Referential Code");
    end;

    local procedure GetActualArrivalDate(SalesLineArchive: Record "Sales Line Archive"): Text
    var
        CalculateActualArrivalDate: Integer;
        ShipmentDate: Date;
        ActualArrivalDate: Date;
    begin
        CalculateActualArrivalDate := 0;
        ShipmentDate := 0D;
        ActualArrivalDate := 0D;

        ShipmentDate := EvaluateDate(GetShipmentDate(SalesLineArchive."Document No.", SalesLineArchive."Line No."));

        if SalesLineArchive."Planned Delivery Date" > ShipmentDate then
            exit(Format(CreateDateTime(SalesLineArchive."Planned Delivery Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z'))
        else begin
            if (SalesLineArchive."Shipment Date" <> 0D) and (SalesLineArchive."Planned Delivery Date" <> 0D) then
                CalculateActualArrivalDate := SalesLineArchive."Planned Delivery Date" - SalesLineArchive."Shipment Date";

            if CalculateActualArrivalDate > 0 then
                ActualArrivalDate := CalcDate('<+' + Format(CalculateActualArrivalDate) + 'D>', ShipmentDate);

            if ActualArrivalDate <> 0D then
                exit(Format(CreateDateTime(ActualArrivalDate, 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z'));
        end;
    end;

    local procedure GetShipmentDate(DocNo: Code[20]; LineNo: Integer): Text
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        SalesShipmentLine.SetRange("Order No.", DocNo);
        SalesShipmentLine.SetRange("Order Line No.", LineNo);
        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);
        If SalesShipmentLine.FindFirst() then begin
            ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
            ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
            ItemLedgerEntry.SetRange("Document No.", SalesShipmentLine."Document No.");
            ItemLedgerEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
            if ItemLedgerEntry.FindFirst() then
                exit(Format(CreateDateTime(ItemLedgerEntry."Posting Date", 0T), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z'))
        end;

    end;

    local procedure GetLineStatus(NewTempOrderSalesLineArchive: Record "Sales Line Archive"): Text
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLineStatus: Text;
    begin
        if FindStatusOnSalesOrderLine(NewTempOrderSalesLineArchive, SalesLineStatus) then
            exit(SalesLineStatus)
        else
            if NewTempOrderSalesLineArchive."MICA Status" = NewTempOrderSalesLineArchive."MICA Status"::Closed then
                exit(Format(NewTempOrderSalesLineArchive."MICA Status"))
            else begin
                SalesInvoiceLine.SetRange("Order No.", NewTempOrderSalesLineArchive."Document No.");
                SalesInvoiceLine.SetRange("Order Line No.", NewTempOrderSalesLineArchive."Line No.");
                SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
                SalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
                if not SalesInvoiceLine.IsEmpty() then
                    exit(Format(NewTempOrderSalesLineArchive."MICA Status"::Closed))
                else
                    exit(Format(NewTempOrderSalesLineArchive."MICA Status"));
            end;
    end;

    local procedure FindStatusOnSalesOrderLine(NewTempOrderSalesLineArchive: Record "Sales Line Archive"; var SalesLineStatus: Text): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLineStatus := '';

        if not SalesLine.Get(NewTempOrderSalesLineArchive."Document Type", NewTempOrderSalesLineArchive."Document No.", NewTempOrderSalesLineArchive."Line No.") then
            exit;
        SalesLineStatus := Format(SalesLine."MICA Status");
        if SalesLineStatus <> '' then
            exit(true);
    end;

    local procedure GetLastApprovalEntryForCreditDates(var NewApprovalEntry: Record "Approval Entry"): Boolean
    begin
        NewApprovalEntry.Reset();
        NewApprovalEntry.SetAscending("Entry No.", true);
        NewApprovalEntry.SetRange("Table ID", 36);
        NewApprovalEntry.SetRange("Document No.", TempSalesLineArchive."Document No.");
        NewApprovalEntry.SetRange("Approval Code", SalesReceivablesSetup."MICA Approval Workflow");
        NewApprovalEntry.SetFilter(Status, '%1|%2', NewApprovalEntry.Status::Approved, NewApprovalEntry.Status::Rejected);
        exit(NewApprovalEntry.FindLast());
    end;

    local procedure EvaluateDate(NewDateInTxt: Text): Date
    var
        DummyDate: Date;
        ExtractDateTxt: Text;
    begin
        ExtractDateTxt := CopyStr(NewDateInTxt, 1, 10);

        if Evaluate(DummyDate, ExtractDateTxt) then
            exit(DummyDate);
    end;

    local procedure SOLineExists(SalesLineArchive: Record "Sales Line Archive"): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        exit(SalesLine.Get(SalesLine."Document Type"::Order, SalesLineArchive."Document No.", SalesLineArchive."Line No."));
    end;
}