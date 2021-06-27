xmlport 82400 "MICA Export SalesOrder Hst.SPD"
{
    //SPD-002
    Caption = 'Sales Order History File for SPD';
    Direction = Export;
    Format = VariableText;
    FieldDelimiter = '"';
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
                textelement(FileName) { }
                textelement(FileNumber) { }
                textelement(InterfaceName) { }
                textelement(SystemCode) { }
                textelement(LoadOption) { }
                textelement(Language) { }
                textelement(HeaderVersion) { }
                textelement(Userarea1) { }
                textelement(Userarea2) { }
                textelement(Userarea3) { }
                textelement(RequestBy) { }
                textelement(ScheduleDate) { }
                textelement(InvOrg) { }
                textelement(InvOrgGroup) { }


                trigger OnAfterGetRecord()
                begin
                    ConstantRowCount += 1;

                    HeaderFile := PrVal_HEADERFILE;
                    Application := PrVal_APPLICATION;
                    Instance := StrSubstNo(PrVal_HEADERINSTANCE, PrVal_ENV, PrVal_APPLICATION, PrVal_INSTANCE);
                    FlowName := PrVal_FLOWNAME;
                    AppMode := PrVal_APPMODE;
                    FileDate := FORMAT(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Filler Character,0><Minutes,2><Seconds,2>');
                    SourceFileExtractDate := FORMAT(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Filler Character,0><Minutes,2><Seconds,2>');
                    InterfaceName := PrVal_APPLICATION;
                    LoadOption := PrVal_LOADOPTION;
                    Language := PrVal_LANGUAGE;
                    HeaderVersion := PrVal_VERSION;
                    RequestBy := GetRequestBy();
                end;
            }
            tableelement(DataHeaderBlock; Integer)
            {
                XmlName = 'HeaderBlock';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(HeaderBlock) { }
                textelement(HeaderBlockName) { }
                textelement(BegFlds) { }
                textelement(FieldNames) { }
                textelement(EndFlds) { }
                trigger OnAfterGetRecord()
                begin
                    ConstantRowCount += 1;
                    HeaderBlock := PrVal_HEADERBLOCK;
                    HeaderBlockName := PrVal_BLOCKNAME;
                    BegFlds := PrVal_BEGFLDS;
                    EndFlds := PrVal_ENDFLDS;
                end;
            }
            tableelement(DetailBlock; Integer)
            {
                XmlName = 'DetailBlock';
                SourceTableView = sorting(Number);
                textelement(DataBlock) { }
                textelement(RecordIdentifier) { }
                textelement(OrganizationCode) { }
                textelement(ODCountryCode) { }
                textelement(ORCountryCode) { }
                textelement(FinishedGoodOrganizationType) { }
                textelement(DocumentType) { }
                textelement(DocumentNum) { }
                textelement(LinkedPONum) { }
                textelement(DocumentTypeCode) { }
                textelement(DocumentStatusCode) { }
                textelement(LineNumer) { }
                textelement(LineTypeLookUpCode) { }
                textelement(ItemSegment1) { }
                textelement(LineDescription) { }
                textelement(LineStatusCode) { }
                textelement(VendorNumber) { }
                textelement(ShipToLocation) { }
                textelement(VendorSiteCode) { }
                textelement(ShipmentNumber) { }
                textelement(OrderedQuantity) { }
                textelement(UOMCode) { }
                textelement(NeedByDate) { }
                textelement(PromisedDate) { }
                textelement(ShipToOrganization) { }
                textelement(IntransitQuanity) { }
                textelement(ShipmentDate) { }
                textelement(ArrivalDate) { }
                textelement(SubinventoryCode) { }
                textelement(OrderDate) { }
                textelement(LineCategoryCode) { }
                textelement(MarketCode) { }
                textelement(DemandClassCode) { }
                textelement(ShipFromOrganization) { }
                textelement(BillToLocation) { }
                textelement(CST) { }
                textelement(CAI) { }
                textelement(ShippedQuanity) { }
                textelement(QuanityReceived) { }
                textelement(QuantityDue) { }
                textelement(CCM) { }
                textelement(ItemType) { }
                textelement(Filter1) { }
                textelement(Filter2) { }
                textelement(Filter3) { }
                textelement(LegacyItemNumber) { }
                textelement(IntransitPlannedType) { }
                textelement(CountryCode) { }
                textelement(ItemTypeCode) { }
                textelement(AccountNumber) { }
                textelement(AccountDescription) { }
                textelement(ItemCategory) { }
                textelement(OriginalPromiseDate) { }
                textelement(SAS4Status) { }
                textelement(SAS4ALReference) { }
                textelement(SAS4ALLineNumber) { }
                textelement(ALCreationDate) { }
                textelement(InvoiceDate) { }
                textelement(LinkedPOLine) { }
                textelement(ShipToOrganizationCode) { }
                textelement(POLineCreationDate) { }
                textelement(ShipFromFGInvOrgType) { }
                textelement(ShipToFGInvOrgType) { }
                textelement(FinishedGoodsOrganizationTypeSource) { }
                textelement(SourceType) { }
                textelement(OrderType) { }
                textelement(OCCode) { }
                textelement(ForecastProfileCode) { }
                textelement(OfferType) { }
                textelement(ItemCategoryAssgnment) { }
                textelement(SCRefHeader) { }
                textelement(SCRefLine) { }
                textelement(RequisitionNumber) { }
                textelement(Lot) { }
                textelement(ItemProductLine) { }
                textelement(ItemProductNature) { }
                textelement(ShipmentLineNum) { }
                textelement(ContainerNum) { }
                textelement(CategoryConcatSegsFF) { }
                textelement(ShipFromOrganisationCode) { }
                textelement(InstructionDC12) { }
                textelement(InstructionDC13) { }
                textelement(InstructionDC14) { }
                textelement(StockType) { }
                textelement(PrimaryUOM) { }
                textelement(OrderedQuantityPrimUOM) { }
                textelement(InTransitQuantityPrimUOM) { }
                textelement(ShippedQuantityPrimUOM) { }
                textelement(ReceivedQuantityPrimUOM) { }
                textelement(DueQuantityPrimUOM) { }
                textelement(SourceSubinventory) { }
                textelement(DestinationSubinventory) { }
                textelement(ShipWarehouseCode) { }
                textelement(ShipmentDateWithTime) { }
                textelement(ArrivalDateWithTime) { }
                textelement(PortETADate) { }
                textelement(TripNumber) { }
                textelement(WMSSONumber) { }
                textelement(AGP) { }
                textelement(RequestReceptionDate) { }
                textelement(ScheduleReceptionDate) { }
                textelement(NoLaterThanDate) { }
                textelement(PromisingPolicy) { }
                textelement(SubinventorySourceType) { }
                textelement(SubinventoryDestinationType) { }
                textelement(INExecutionFlag) { }
                textelement(TargetDate) { }
                textelement(LastUpdateDateOfLine) { }
                textelement(ShipToCode) { }
                textelement(CommercialOffer) { }
                textelement(DeliveryService) { }
                textelement(PreferedDaySwitch) { }
                textelement(CreditHoldFlag) { }
                textelement(SupplyUsage) { }
                textelement(CustomerAllocationGroup) { }
                textelement(CustomerCommitmentDateTime) { }
                textelement(DeliveryLineNumber) { }
                textelement(DeliveryLineStatus) { }
                textelement(TripName) { }
                textelement(TripStatus) { }
                textelement(SalesAgreementNumber) { }
                textelement(Currency) { }
                textelement(UnitSellingPrice) { }
                textelement(FrozenDate) { }
                textelement(FrozenReceptionDate) { }
                textelement(OriginalCommitmentDate) { }
                textelement(PredefinedWarehouse) { }
                textelement(OrchestrationOrderNum) { }
                textelement(OrchestrationOrderLineNum) { }
                textelement(ShipFromInvOrgName) { }
                textelement(SourceShipmentNumber) { }
                textelement(CustLineNum) { }
                textelement(OriginalCommitmentReceptionDate) { }
                textelement(ElementaryCustomer) { }
                textelement(OPLineID) { }
                textelement(OEComplianceType) { }
                textelement(NeedType) { }
                textelement(Media) { }
                textelement(CreditHoldApplyingDate) { }
                textelement(CreditHoldReleasingDate) { }
                textelement(RequestShipDate) { }

                trigger OnPreXmlItem()
                var
                    CalcDateLbl: Label '%1..%2', Comment = '%1%2', Locked = true;
                begin
                    ExportedRecordCount := 0;
                    MICASalesOrderHistorySPD.SetFilter(Filter_Posting_Date, StrSubstNo(CalcDateLbl, CalcDate('<CM-18M>', WorkDate()), WorkDate()));
                    MICASalesOrderHistorySPD.Open();
                end;

                trigger OnAfterGetRecord()
                var
                    OrganizationCodeLbl: Label '%1_%2', Comment = '%1%2', Locked = true;
                begin
                    if MICASalesOrderHistorySPD.Read() then begin
                        if not SalesLineArchive.Get(SalesLineArchive."Document Type"::Order, MICASalesOrderHistorySPD.Arch_Document_No_,
                                                MICASalesOrderHistorySPD.Arch_Doc__No__Occurrence, MICASalesOrderHistorySPD.Arch_Version_No_,
                                                MICASalesOrderHistorySPD.Line_No_) then
                            Clear(SalesLineArchive);

                        DataBlock := PrVal_DATABLOCK;
                        RecordIdentifier := PrVal_RECORDIDENTIFIER;
                        OrganizationCode := StrSubstNo(OrganizationCodeLbl, MICAFinancialReportingSetup."Company Code", PrVal_ORGANICODE);
                        DocumentType := PrVal_DOCTYPE;
                        DocumentNum := MICASalesOrderHistorySPD.Order_No_;
                        DocumentTypeCode := PrVal_DOCTYPE;
                        DocumentStatusCode := GetDocumentStatus();
                        LineNumer := MICAFlowSendSalesOrderSPD.FormatInteger(MICASalesOrderHistorySPD.Line_No_);
                        LineTypeLookUpCode := PrVal_LINESHIPTYPE;
                        ItemSegment1 := MICASalesOrderHistorySPD.Item_No;
                        if MICASalesOrderHistorySPD.Qty__Shipped_Not_Invoiced > 0 then
                            LineStatusCode := PrVal_SHIPDOCSTATUS
                        else
                            LineStatusCode := PrVal_CLOSEDOCSTATUS;
                        ShipmentNumber := MICASalesOrderHistorySPD.Document_No_;
                        OrderedQuantity := MICAFlowSendSalesOrderSPD.FormatDecimal(MICASalesOrderHistorySPD.Quantity);
                        UOMCode := MICASalesOrderHistorySPD.Unit_of_Measure_Code;
                        NeedByDate := MICAFlowSendSalesOrderSPD.FormatDate(SalesLineArchive."MICA Requested Receipt Date");
                        ShipmentDate := MICAFlowSendSalesOrderSPD.FormatDate(SalesLineArchive."Shipment Date");
                        ArrivalDate := MICAFlowSendSalesOrderSPD.FormatDate(SalesLineArchive."Planned Delivery Date");
                        OrderDate := MICAFlowSendSalesOrderSPD.FormatDateTime(MICASalesOrderHistorySPD.Document_Date);
                        MarketCode := MICAFlowSendSalesOrderSPD.GetItemMarketCode(ItemSegment1);
                        ShippedQuanity := MICAFlowSendSalesOrderSPD.FormatDecimal(MICASalesOrderHistorySPD.Quantity);
                        QuantityDue := MICAFlowSendSalesOrderSPD.FormatDecimal(GetQuantityDue());
                        CountryCode := CountryRegion."ISO Code";
                        ItemProductLine := MICASalesOrderHistorySPD.Item_Category_Code;
                        ShipFromOrganisationCode := MICAFlowSendSalesOrderSPD.GetDRPINLocationCode(MICASalesOrderHistorySPD.Location_Code);
                        RequestReceptionDate := MICAFlowSendSalesOrderSPD.FormatDateTimeTimeZone(MICASalesOrderHistorySPD.MICA_Requested_Receipt_Date, 0T, PrVal_TIMEZONE);
                        ScheduleReceptionDate := MICAFlowSendSalesOrderSPD.FormatDateTimeTimeZone(SalesLineArchive."MICA Requested Receipt Date", 0T, PrVal_TIMEZONE);
                        TargetDate := MICAFlowSendSalesOrderSPD.FormatDateTimeTimeZone(MICASalesOrderHistorySPD.MICA_Requested_Receipt_Date, 0T, PrVal_TIMEZONE);
                        ShipToCode := MICASalesOrderHistorySPD.Ship_to_Code;
                        DeliveryService := Format(MICASalesOrderHistorySPD.MICA_Order_Type);
                        CreditHoldFlag := MICAFlowSendSalesOrderSPD.GetCreditHoldFlag(SalesLineArchive."Document No.", PrVal_CREDITLIMITWORKFLOW);
                        CustomerCommitmentDateTime := MICAFlowSendSalesOrderSPD.FormatDateTimeTimeZone(MICASalesOrderHistorySPD.Promised_Delivery_Date, 0T, PrVal_TIMEZONE);

                        //if SalesOrderHistory.Customer_Location_Code = '' then
                        //   Error(StrSubstNo(MissingCustomerLocationErr, SalesOrderHistory.Sell_to_Customer_No_));
                        PredefinedWarehouse := MICAFlowSendSalesOrderSPD.GetDRPINLocationCode(MICASalesOrderHistorySPD.Customer_Location_Code);
                        if PrVal_ForecastCustCode = '' then
                            ElementaryCustomer := MICAFlowSendSalesOrderSPD.GetForecastCustomerCode(MICASalesOrderHistorySPD.Bill_to_Customer_No_, MICASalesOrderHistorySPD.Item_Category_Code)
                        else
                            ElementaryCustomer := PrVal_ForecastCustCode;
                        RequestShipDate := MICAFlowSendSalesOrderSPD.FormatDateTime(SalesLineArchive."MICA Requested Receipt Date");

                        CheckMandatoryFields();
                        ExportedRecordCount += 1;
                    end else
                        currXMLport.Break();
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
                    FooterBlock := PrVal_FOOTERBLOCK;
                    FooterBlockName := PrVal_BLOCKNAME;
                    NbData := FORMAT(ExportedRecordCount);
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
                    ConstantRowCount += 1;
                    FooterFile := PrVal_FOOTERFILE;
                    FileNbData := Format(ExportedRecordCount + ConstantRowCount);// ConstantRowCount need to increment every time when new constant row is added
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
        CheckIfFieldIsEmpty(
                MICAFinancialReportingSetup."Company Code",
                StrSubstNo(MissingFieldValueTxt, OrganizationCodeTok),
                StrSubstNo(MissingFieldValueKeyTxt, MICAFinancialReportingSetup.FieldCaption("Company Code"), MICAFinancialReportingSetup.TableCaption(), ''));
        CompanyInformation.Get();
        if not CountryRegion.Get(CompanyInformation.GetCompanyCountryRegionCode()) then
            Clear(CountryRegion);
        CheckIfFieldIsEmpty(
                CountryRegion."ISO Code",
                StrSubstNo(MissingFieldValueTxt, CountryCodeTok),
                StrSubstNo(MissingFieldValueKeyTxt, CountryRegion.FieldCaption("ISO Code"), CountryRegion.TableCaption(), StrSubstNo(CountryRegionKeyTxt, CountryRegion.Code)));
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";
        SalesLineArchive: Record "Sales Line Archive";
        MICAFlowEntry: Record "MICA Flow Entry";
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowSendSalesOrderSPD: Codeunit "MICA Flow Send Sales Order SPD";
        MICASalesOrderHistorySPD: Query "MICA Sales Order History SPD";
        ExportedRecordCount: Integer;
        ConstantRowCount: Integer;
        SalesOrderHistoryNo: Code[20];
        CurrentDocumentStatusCode: Text;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingParamValueMsg: Label 'Missing value for parameter %1';
        PrVal_FileNameOpen: Text;
        PrVal_FILENAMEHIST: Text;
        PrVal_REQUESTEDBATCH: Text;
        PrVal_APPLICATION: Text;
        PrVal_HEADERFILE: Text;
        PrVal_HEADERINSTANCE: Text;
        PrVal_ENV: Text;
        PrVal_INSTANCE: Text;
        PrVal_FLOWNAME: Text;
        PrVal_APPMODE: Text;
        PrVal_LOADOPTION: Text;
        PrVal_LANGUAGE: Text;
        PrVal_VERSION: Text;
        PrVal_RequestBy: Text;
        PrVal_REQUESTEDMAN: Text;
        PrVal_HEADERBLOCK: Text;
        PrVal_BLOCKNAME: Text;
        PrVal_BEGFLDS: Text;
        PrVal_ENDFLDS: Text;
        PrVal_FOOTERBLOCK: Text;
        PrVal_FOOTERFILE: Text;
        PrVal_DATABLOCK: Text;
        PrVal_RECORDIDENTIFIER: Text;
        PrVal_DOCTYPE: Text;
        PrVal_OPENDOCSTATUS: Text;
        PrVal_LINEORDERTYPE: Text;
        PrVal_EXPRORDERTYPE: Text;
        PrVal_STDORDERTYPE: Text;
        PrVal_CREDITLIMITWORKFLOW: Text;
        PrVal_SHIPDOCSTATUS: Text;
        PrVal_CLOSEDOCSTATUS: Text;
        PrVal_LINESHIPTYPE: Text;
        PrVal_TIMEZONE: Text;
        PrVal_ORGANICODE: Text;
        PrVal_ForecastCustCode: Text;
        Param_FileNameOpenTok: Label 'FILENAMEOPEN', Locked = true;
        Param_FILENAMEHISTTok: Label 'FILENAMEHIST', Locked = true;
        Param_REQUESTEDBATCHTok: Label 'REQUESTEDBATCH', Locked = true;
        Param_APPLICATIONTok: Label 'APPLICATION', Locked = true;
        Param_HEADERFILETok: Label 'HEADERFILE', Locked = true;
        Param_HEADERINSTANCETok: Label 'HEADERINSTANCE', Locked = true;
        Param_ENVTok: Label 'ENV', Locked = true;
        Param_INSTANCETok: Label 'INSTANCE', Locked = true;
        Param_FLOWNAMETok: Label 'FLOWNAME', Locked = true;
        Param_APPMODETok: Label 'APPMODE', Locked = true;
        Param_LOADOPTIONTok: Label 'LOADOPTION', Locked = true;
        Param_LANGUAGETok: Label 'LANGUAGE', Locked = true;
        Param_VERSIONTok: Label 'VERSION', Locked = true;
        Param_RequestByTok: Label 'RequestBy', Locked = true;
        Param_REQUESTEDMANTok: Label 'REQUESTEDMAN', Locked = true;
        Param_HEADERBLOCKTok: Label 'HEADERBLOCK', Locked = true;
        Param_BLOCKNAMETok: Label 'BLOCKNAME', Locked = true;
        Param_BEGFLDSTok: Label 'BEGFLDS', Locked = true;
        Param_ENDFLDSTok: Label 'ENDFLDS', Locked = true;
        Param_FOOTERBLOCKTok: Label 'FOOTERBLOCK', Locked = true;
        Param_FOOTERFILETok: Label 'FOOTERFILE', Locked = true;
        Param_DATABLOCKTok: Label 'DATABLOCK', Locked = true;
        Param_RECORDIDENTIFIERTok: Label 'RECORDIDENTIFIER', Locked = true;
        Param_DOCTYPETok: Label 'DOCTYPE', Locked = true;
        Param_OPENDOCSTATUSTok: Label 'OPENDOCSTATUS', Locked = true;
        Param_LINEORDERTYPETok: Label 'LINEORDERTYPE', Locked = true;
        Param_EXPRORDERTYPETok: Label 'EXPRORDERTYPE', Locked = true;
        Param_STDORDERTYPETok: Label 'STDORDERTYPE', Locked = true;
        Param_CREDITLIMITWORKFLOWTok: Label 'CREDITLIMITWORKFLOW', Locked = true;
        Param_SHIPDOCSTATUSTok: Label 'SHIPDOCSTATUS', Locked = true;
        Param_CLOSEDOCSTATUSTok: Label 'CLOSEDOCSTATUS', Locked = true;
        Param_LINESHIPTYPETok: Label 'LINESHIPTYPE', Locked = true;
        Param_TIMEZONETok: Label 'TIMEZONE', Locked = true;
        Param_ORGANICODETok: Label 'ORGANICODE', Locked = true;
        Param_ForecastCustCodeTok: Label 'FORECASTCUSTOMERCODE', Locked = true;
        MissingFieldValueTxt: Label 'Missing Value for %1. ';
        MissingFieldValueKeyTxt: Label '%1 is empty in the record %2 where: %3';
        SalesLineKeyLbl: Label 'Document Type: %1, Document No: %2, Line No: %3.';
        SalesShipmentHeaderKeyTxt: Label 'Document No: %1';
        ItemKeyTxt: Label 'No: %1';
        ForecastCustCodeKeyTxt: Label 'Customer No: %1, Product Line: %2';
        CountryRegionKeyTxt: Label 'Code: %1';
        MarketCodeKeyTxt: Label 'Item No: %1, Market Code: %2';
        OrganizationCodeTok: Label 'ORGANIZATION CODE', Locked = true;
        ShipmentDateTok: Label 'SHIPMENT DATE', Locked = true;
        NeedByDateTok: Label 'NEED_BY_DATE', Locked = true;
        ArrivalDateTok: Label 'ARRIVAL DATE', Locked = true;
        OrderDateTok: Label 'ORDER DATE', Locked = true;
        MarketCodeTok: Label 'MARKET CODE', Locked = true;
        CountryCodeTok: Label 'CountryCode', Locked = true;
        ItemProductLineTok: Label 'ITEM_PRODUCT_LINE', Locked = true;
        ShipFromOrganisationCodeTok: Label 'SHIP_FROM_ORGANISATION_CODE', Locked = true;
        PredefinedWarehouseTok: Label 'PREDEFINED_WAREHOUSE', Locked = true;
        ElementaryCustomerTok: Label 'ELEMENTARY_CUSTOMER', Locked = true;



    procedure SetFlowEntry(var NewMICAFlowEntry: Record "MICA Flow Entry")
    begin
        MICAFlowEntry := NewMICAFlowEntry;
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ExportedRecordCount);
    end;

    local procedure GetDocumentStatus(): Text
    var
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        if MICASalesOrderHistorySPD.No_ <> SalesOrderHistoryNo then begin
            SalesOrderHistoryNo := MICASalesOrderHistorySPD.No_;
            SalesShipmentLine.SetRange("Document No.", SalesOrderHistoryNo);
            SalesShipmentLine.SetFilter("Qty. Shipped Not Invoiced", '<>0');
            if SalesShipmentLine.IsEmpty() then
                CurrentDocumentStatusCode := PrVal_CLOSEDOCSTATUS
            else
                CurrentDocumentStatusCode := PrVal_SHIPDOCSTATUS;
        end;
        exit(CurrentDocumentStatusCode);
    end;

    local procedure GetRequestBy(): Text;
    begin
        if CurrentClientType() = ClientType::Background then
            exit(StrSubstNo(PrVal_RequestBy, PrVal_INSTANCE, PrVal_REQUESTEDBATCH))
        else
            exit(StrSubstNo(PrVal_RequestBy, PrVal_INSTANCE, PrVal_REQUESTEDMAN));
    end;

    local procedure GetInstanceId(): Text;
    var
        param: Text;
    begin
        if CurrentClientType() = ClientType::Background then
            param := PrVal_REQUESTEDBATCH
        else begin
            param := UserId();
            param := param.Replace('\', '-');
        end;
        exit(param);
    end;

    procedure GetFileName(): Text
    var
        FileName: Text;
        FileNameLbl: Label '%1_%2', Comment = '%1%2', Locked = true;
    begin
        FileName := StrSubstNo(PrVal_FILENAMEHIST,
                                    StrSubstNo(FileNameLbl, PrVal_APPLICATION, CountryRegion."ISO Code"),
                                    GetInstanceId(),
                                    FORMAT(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Filler Character,0><Minutes,2><Seconds,2>'));
        exit(FileName);
    end;

    procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParameters(Param_FileNameOpenTok, PrVal_FileNameOpen, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FILENAMEHISTTok, PrVal_FILENAMEHIST, true);
        CheckPrerequisitesAndRetrieveParameters(Param_REQUESTEDBATCHTok, PrVal_REQUESTEDBATCH, true);
        CheckPrerequisitesAndRetrieveParameters(Param_APPLICATIONTok, PrVal_APPLICATION, true);
        CheckPrerequisitesAndRetrieveParameters(Param_HEADERFILETok, PrVal_HEADERFILE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_HEADERINSTANCETok, PrVal_HEADERINSTANCE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_ENVTok, PrVal_ENV, true);
        CheckPrerequisitesAndRetrieveParameters(Param_INSTANCETok, PrVal_INSTANCE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FLOWNAMETok, PrVal_FLOWNAME, true);
        CheckPrerequisitesAndRetrieveParameters(Param_APPMODETok, PrVal_APPMODE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_LOADOPTIONTok, PrVal_LOADOPTION, true);
        CheckPrerequisitesAndRetrieveParameters(Param_LANGUAGETok, PrVal_LANGUAGE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_VERSIONTok, PrVal_VERSION, true);
        CheckPrerequisitesAndRetrieveParameters(Param_RequestByTok, PrVal_RequestBy, true);
        CheckPrerequisitesAndRetrieveParameters(Param_REQUESTEDMANTok, PrVal_REQUESTEDMAN, true);
        CheckPrerequisitesAndRetrieveParameters(Param_HEADERBLOCKTok, PrVal_HEADERBLOCK, true);
        CheckPrerequisitesAndRetrieveParameters(Param_BLOCKNAMETok, PrVal_BLOCKNAME, true);
        CheckPrerequisitesAndRetrieveParameters(Param_BEGFLDSTok, PrVal_BEGFLDS, true);
        CheckPrerequisitesAndRetrieveParameters(Param_ENDFLDSTok, PrVal_ENDFLDS, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FOOTERBLOCKTok, PrVal_FOOTERBLOCK, true);
        CheckPrerequisitesAndRetrieveParameters(Param_FOOTERFILETok, PrVal_FOOTERFILE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_DATABLOCKTok, PrVal_DATABLOCK, true);
        CheckPrerequisitesAndRetrieveParameters(Param_RECORDIDENTIFIERTok, PrVal_RECORDIDENTIFIER, true);
        CheckPrerequisitesAndRetrieveParameters(Param_DOCTYPETok, PrVal_DOCTYPE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_OPENDOCSTATUSTok, PrVal_OPENDOCSTATUS, true);
        CheckPrerequisitesAndRetrieveParameters(Param_LINEORDERTYPETok, PrVal_LINEORDERTYPE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_EXPRORDERTYPETok, PrVal_EXPRORDERTYPE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_STDORDERTYPETok, PrVal_STDORDERTYPE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_CREDITLIMITWORKFLOWTok, PrVal_CREDITLIMITWORKFLOW, true);
        CheckPrerequisitesAndRetrieveParameters(Param_SHIPDOCSTATUSTok, PrVal_SHIPDOCSTATUS, true);
        CheckPrerequisitesAndRetrieveParameters(Param_CLOSEDOCSTATUSTok, PrVal_CLOSEDOCSTATUS, true);
        CheckPrerequisitesAndRetrieveParameters(Param_LINESHIPTYPETok, PrVal_LINESHIPTYPE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_TIMEZONETok, PrVal_TIMEZONE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_ORGANICODETok, PrVal_ORGANICODE, true);
        CheckPrerequisitesAndRetrieveParameters(Param_ForecastCustCodeTok, PrVal_ForecastCustCode, false);
    end;

    local procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20]; var ParamValue: Text; Mandatory: Boolean)
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        ParamValue := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if (ParamValue = '') and Mandatory then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamValueMsg, Param), '');
    end;

    local procedure GetQuantityDue(): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", MICASalesOrderHistorySPD.Order_No_);
        SalesLine.SetRange("Line No.", MICASalesOrderHistorySPD.Order_Line_No_);
        if SalesLine.FindFirst() then
            exit(SalesLine."Outstanding Quantity")
        else
            exit(0);
    end;

    local procedure CheckMandatoryFields()
    var
        Item: Record Item;
        SalesShipmentHeader: Record "Sales Shipment Header";
        Customer: Record Customer;
        MICAForecastCustomerCode: Record "MICA Forecast Customer Code";
        MICATableValue: Record "MICA Table Value";
        Location: Record Location;
    begin
        if not Item.Get(ItemSegment1) then
            Item.init();
        CheckIfFieldIsEmpty(
            ShipmentDate,
            StrSubstNo(MissingFieldValueTxt, ShipmentDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesLineArchive.FieldCaption("Planned Shipment Date"),
                SalesLineArchive.TableCaption(),
                StrSubstNo(SalesLineKeyLbl, Format(SalesLineArchive."Document Type"::Order), DocumentNum, LineNumer)));
        CheckIfFieldIsEmpty(
            NeedByDate,
            StrSubstNo(MissingFieldValueTxt, NeedByDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesLineArchive.FieldCaption("MICA Requested Receipt Date"),
                SalesLineArchive.TableCaption(),
                StrSubstNo(SalesLineKeyLbl, Format(SalesLineArchive."Document Type"::Order), DocumentNum, LineNumer)));
        CheckIfFieldIsEmpty(
            ArrivalDate,
            StrSubstNo(MissingFieldValueTxt, ArrivalDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesLineArchive.FieldCaption("Planned Delivery Date"),
                SalesLineArchive.TableCaption(),
                StrSubstNo(SalesLineKeyLbl, Format(SalesLineArchive."Document Type"::Order), DocumentNum, LineNumer)));
        CheckIfFieldIsEmpty(
            OrderDate,
            StrSubstNo(MissingFieldValueTxt, OrderDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                SalesShipmentHeader.FieldCaption("Document Date"),
                SalesShipmentHeader.TableCaption(),
                StrSubstNo(SalesShipmentHeaderKeyTxt, ShipmentNumber)));
        CheckIfFieldIsEmpty(
            MarketCode,
            StrSubstNo(MissingFieldValueTxt, MarketCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                MICATableValue.FieldCaption(Description),
                MICATableValue.TableCaption(),
                StrSubstNo(MarketCodeKeyTxt, Item."No.", Item."MICA Market Code")));
        CheckIfFieldIsEmpty(
                ItemProductLine,
                StrSubstNo(MissingFieldValueTxt, ItemProductLineTok),
                StrSubstNo(
                    MissingFieldValueKeyTxt,
                    SalesLineArchive.FieldCaption("Item Category Code"),
                    SalesLineArchive.TableCaption(),
                    StrSubstNo(SalesLineKeyLbl, Format(SalesLineArchive."Document Type"::Order), DocumentNum, LineNumer)));
        CheckIfFieldIsEmpty(
            ShipFromOrganisationCode,
            StrSubstNo(MissingFieldValueTxt, ShipFromOrganisationCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                Location.FieldCaption("MICA DRP IN Location Code"),
                Location.TableCaption(),
                StrSubstNo(CountryRegionKeyTxt, MICASalesOrderHistorySPD.Location_Code)));
        CheckIfFieldIsEmpty(
            MICASalesOrderHistorySPD.Customer_Location_Code,
            StrSubstNo(MissingFieldValueTxt, PredefinedWarehouseTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                Customer.FieldCaption("Location Code"),
                Customer.TableCaption(),
                StrSubstNo(ItemKeyTxt, MICASalesOrderHistorySPD.Sell_to_Customer_No_)));
        CheckIfFieldIsEmpty(
            PredefinedWarehouse,
            StrSubstNo(MissingFieldValueTxt, PredefinedWarehouseTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                Location.FieldCaption("MICA DRP IN Location Code"),
                Location.TableCaption(),
                StrSubstNo(CountryRegionKeyTxt, Customer."Location Code")));
        CheckIfFieldIsEmpty(
            ElementaryCustomer,
            StrSubstNo(MissingFieldValueTxt, ElementaryCustomerTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                MICAForecastCustomerCode.FieldCaption("Forecast Code"),
                MICAForecastCustomerCode.TableCaption(),
                StrSubstNo(ForecastCustCodeKeyTxt, MICASalesOrderHistorySPD.Sell_to_Customer_No_, MICASalesOrderHistorySPD.Item_Category_Code)));
    end;

    local procedure CheckIfFieldIsEmpty(FieldValue: Text; Description: Text; Description2: Text)
    begin
        if FieldValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, Description, Description2);
    end;
}