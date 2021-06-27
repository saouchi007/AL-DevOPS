xmlport 82360 "MICA Export InTransit SPD"
{

    Caption = 'Stock File for SPD';
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
                textelement(FileVersion) { }
                textelement(Userarea1) { }
                textelement(Userarea2) { }
                textelement(Userarea3) { }
                textelement(FileRequestedBy) { }
                textelement(ScheduleDate) { }
                textelement(InvOrg) { }
                textelement(InvOrgGroup) { }

                trigger OnAfterGetRecord()
                begin
                    ConstantRowCount += 1;
                    HeaderFile := ParamValue_HeaderFile;
                    Application := ParamValue_Application;
                    Instance := StrSubstNo(ParamValue_HeaderInstance, ParamValue_Env, ParamValue_Application, ParamValue_Instance);
                    FlowName := ParamValue_FlowName;
                    AppMode := ParamValue_AppMode;
                    FileDate := FORMAT(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');
                    SourceFileExtractDate := FileDate;
                    InterfaceName := ParamValue_Application;
                    LoadOption := ParamValue_LoadOption;
                    Language := ParamValue_Language;
                    FileVersion := ParamValue_Version;
                    if CurrentClientType() = ClientType::Background then begin
                        FileRequestedBy := StrSubstNo(ParamValue_RequestBy, ParamValue_Instance, ParamValue_RequestedBatch);
                        BatchEnv := ParamValue_RequestedBatch;
                    end else begin
                        FileRequestedBy := StrSubstNo(ParamValue_RequestBy, ParamValue_Instance, ParamValue_RequestedMan);
                        BatchEnv := CONVERTSTR(UserId(), '\', '-');
                    end;
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
                    HeaderBlock := ParamValue_HeaderBlock;
                    HeaderBlockName := ParamValue_BlockName;
                    BegFlds := ParamValue_BegFlds;
                    EndFlds := ParamValue_EndFlds;
                end;
            }
            tableelement(DataBlock; Integer)
            {
                XmlName = 'DataBlock';
                SourceTableView = sorting(Number);
                textelement(DataBlock2) { }
                textelement(RecordIdentifier) { }
                textelement(OrganizationCode) { }
                textelement(ODCountryCode) { }
                textelement(ORCountryCode) { }
                textelement(FinishedGoodsOrganizationType) { }
                textelement(DocumentType) { }
                textelement(DocumentNum) { }
                textelement(LinkedPoNum) { }
                textelement(DocumentTypeCode) { }
                textelement(DocumentStatusCode) { }
                textelement(LineNumber) { }
                textelement(LineTypeLookupCode) { }
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
                textelement(InTransitQuantity) { }

                textelement(ShipmentDate) { }

                textelement(ArrivalDate) { }
                textelement(SubInventoryCode) { }
                textelement(OrderDate) { }
                textelement(LineCategoryCode) { }
                textelement(MarketCode) { }
                textelement(DemandClassCode) { }
                textelement(ShipFromOrganization) { }
                textelement(BillToLocation) { }
                textelement(CST) { }
                textelement(CAI) { }
                textelement(ShippedQuantity) { }
                textelement(QuantityReceived) { }
                textelement(QuantityDue) { }
                textelement(CCM) { }
                textelement(ItemType) { }
                textelement(Filler1) { }
                textelement(Filler2) { }
                textelement(Filler3) { }
                textelement(LegacyItemNumber) { }
                textelement(InTransitPlannedType) { }
                textelement(CountryCode) { }
                textelement(ItemTypeCode) { }
                textelement(AccountNumber) { }
                textelement(AccountDescription) { }
                textelement(ItemCategory) { }
                textelement(OriginalPromiseDate) { }
                textelement(SAS4Status) { }
                textelement(SAS4AlReference) { }
                textelement(SAS4AlLineNumber) { }
                textelement(AlCreationDate) { }
                textelement(InvoiceDate) { }
                textelement(LinkedPoLine) { }
                textelement(ShipToOrganizationCode) { }
                textelement(PoLineCreationDate) { }
                textelement(ShipFromFgInvOrgType) { }
                textelement(ShipToFgInvOrgType) { }
                textelement(FinishedGoodsOrganizationTypeSource) { }
                textelement(SourceType) { }
                textelement(OrderType) { }
                textelement(OCCode) { }
                textelement(ForecastProfileCode) { }
                textelement(OfferType) { }
                textelement(ItemCategoryAssignment) { }
                textelement(SCRefHeader) { }
                textelement(SCRefLine) { }
                textelement(RequisitionNumber) { }
                textelement(Lot) { }
                textelement(ItemProductLine) { }
                textelement(ItemProductNature) { }
                textelement(ShipmentLineNum) { }
                textelement(ContainerNum) { }
                textelement(CategoryConcatSegsFF) { }
                textelement(ShipFromOrganizationCode) { }
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
                textelement(SourceSubInventory) { }
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
                textelement(PromissingPolicy) { }
                textelement(SubInventorySourceType) { }
                textelement(SubInventoryDestionationType) { }
                textelement(InExecutionFlag) { }
                textelement(TargetDate) { }
                textelement(LastUpdateDateOfLine) { }
                textelement(ShipToCode) { }
                textelement(CommercialOffer) { }
                textelement(DeliveryService) { }
                textelement(PreferredDaySwitch) { }
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
                textelement(OrcherstrationOrdernum) { }
                textelement(OrcerstrationOrderlinenum) { }
                textelement(ShipFromInvOrgName) { }
                textelement(SourceShipmentNumber) { }
                textelement(CustLineNum) { }
                textelement(OriginalCommitmentReceptionDate) { }
                textelement(ElementaryCustomer) { }
                textelement(OpLineID) { }
                textelement(OEComplianceType) { }
                textelement(NeedType) { }
                textelement(Media) { }
                textelement(CreditHoldApplyingDate) { }
                textelement(CreditHoldReleasingDate) { }
                textelement(RequestShipDate) { }

                trigger OnPreXmlItem()
                begin

                    TempItemLedgerEntry.Reset();
                    ExportedRecordCount := TempItemLedgerEntry.Count();

                    DataBlock.SetFilter(Number, '%1..%2', 1, ExportedRecordCount);
                end;

                trigger OnAfterGetRecord()
                var
                    OrganizationCodeLbl: Label '%1_%2', Comment = '%1%2', Locked = true;
                begin
                    if DataBlock.Number = 1 then
                        TempItemLedgerEntry.FindFirst()
                    else
                        TempItemLedgerEntry.Next();

                    DataBlock2 := ParamValue_DataBlock;
                    RecordIdentifier := ParamValue_RecordIdentifier;
                    OrganizationCode := StrSubstNo(OrganizationCodeLbl, MICAFinancialReportingSetup."Company Code", ParamValue_OrganiCode);
                    ODCountryCode := TempItemLedgerEntry."Shpt. Method Code";
                    ORCountryCode := CountryRegion."ISO Code";
                    DocumentNum := TempItemLedgerEntry."Source No.";
                    LineNumber := FORMAT(TempItemLedgerEntry."Document Line No.");
                    ItemSegment1 := TempItemLedgerEntry."Item No.";
                    ShipToLocation := GetLocationDRPINCode(TempItemLedgerEntry."Location Code");
                    ShipmentNumber := TempItemLedgerEntry."No. Series";
                    OrderedQuantity := FORMAT(TempItemLedgerEntry.Quantity, 0, 9);
                    InTransitQuantity := Format(TempItemLedgerEntry."Invoiced Quantity", 0, 9);
                    ShipmentDate := Format(TempItemLedgerEntry."Document Date", 0, '<Day,2>-<Month,2>-<Year4>');
                    ArrivalDate := Format(TempItemLedgerEntry."Expiration Date", 0, '<Day,2>-<Month,2>-<Year4>');
                    OrderDate := Format(CreateDateTime(TempItemLedgerEntry."Last Invoice Date", 0T), 0, '<Day,2>-<Month,2>-<Year4><Hours24,2>:<Minutes,2>:<Seconds,2>');
                    MarketCode := GetItemMarketCode(ItemSegment1);
                    ShippedQuantity := Format(TempItemLedgerEntry."Remaining Quantity", 0, 9);
                    ItemProductLine := TempItemLedgerEntry."Item Category Code";
                    ShipmentLineNum := Format(TempItemLedgerEntry."Order Line No.");
                    //ShipFromOrganizationCode := TempItemLedgerEntry."Global Dimension 1 Code";
                    InstructionDC14 := TempItemLedgerEntry."Global Dimension 2 Code";

                    DocumentType := TempItemLedgerEntry."External Document No.";
                    ShipToOrganizationCode := GetLocationDRPINCode(TempItemLedgerEntry."Area");
                    ShipFromOrganizationCode := TempItemLedgerEntry."Global Dimension 1 Code";
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
                    FooterFile := ParamValue_FooterFile;
                    FileNbData := Format(ExportedRecordCount + ConstantRowCount);// ConstantRowCount need to increment every time when new constant row is added
                end;
            }
            tableelement(EmptyFooterLine; Integer)
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
        if not CountryRegion.Get(CompanyInformation."Country/Region Code") then
            CountryRegion.Init();
        SetData();
    end;

    var
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";
        MICAFlowEntry: Record "MICA Flow Entry";
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
        ParamValue_UserItemType: text;
        ParamValue_RequestBy: text;
        ParamValue_RequestedBatch: text;
        ParamValue_RequestedMan: text;
        ParamValue_FileName: text;
        ParamValue_CountryOfOrigin: text;
        ParamValue_HeaderInstance: text;
        ParamValue_Env: text;
        ParamValue_Instance: text;
        ParamValue_PurchLocFilter: text;
        ParamValue_HeaderFile: text;
        ParamValue_Application: text;
        ParamValue_FlowName: text;
        ParamValue_AppMode: text;
        ParamValue_LoadOption: text;
        ParamValue_HeaderBlock: text;
        ParamValue_Intransit: text;
        ParamValue_BegFlds: text;
        ParamValue_EndFlds: text;
        ParamValue_FooterBlock: Text;
        ParamValue_BlockName: Text;
        ParamValue_FooterFile: Text;
        ParamValue_Language: Text;
        ParamValue_Version: Text;
        ParamValue_DataBlock: Text;
        ParamValue_RecordIdentifier: Text;
        ParamValue_UOMCode: Text;
        ParamValue_DocTypePIT: Text;
        ParamValue_DocTypeGIT: Text;
        ParamValue_OrganiCode: Text;
        ParamValue_DimInterco: Text;
        BatchEnv: Text;
        ConstantRowCount: Integer;
        ExportedRecordCount: Integer;
        EntryNo: Integer;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingParamValueMsg: Label 'Missing value for parameter %1';
        Param_UserItemTypeLbl: Label 'USERITEMTYPE', Locked = true;
        Param_RequestByLbl: Label 'REQUESTBY', Locked = true;
        Param_RequestedBatchLbl: Label 'REQUESTEDBATCH', locked = true;
        Param_RequestedManLbl: Label 'REQUESTEDMAN', Locked = true;
        Param_FileNameLbl: Label 'FILENAME', Locked = true;
        Param_CountryOfOriginLbl: Label 'COUNTRYOFORIGIN', Locked = true;
        Param_HeaderInstanceLbl: Label 'HEADERINSTANCE', locked = true;
        Param_EnvLbl: Label 'ENV', Locked = true;
        Param_InstanceLbl: Label 'INSTANCE', Locked = true;
        Param_PurchLocFilterLbl: Label 'PURCHLOCFILTER', locked = true;
        Param_HeaderFileLbl: Label 'HEADERFILE', Locked = true;
        Param_ApplicationLbl: Label 'APPLICATION', Locked = true;
        Param_FlowNameLbl: Label 'FLOWNAME', Locked = true;
        Param_AppModeLbl: Label 'APPMODE', Locked = true;
        Param_LoadOptionLbl: Label 'LOADOPTION', Locked = true;
        Param_HeaderBlockLbl: label 'HEADERBLOCK', locked = true;
        Param_IntransitLbl: Label 'INTRANSIT', locked = true;
        Param_BegFldsLbl: Label 'BEGFLDS', locked = true;
        Param_EndFldsLbl: Label 'ENDFLDS', locked = true;
        ParamFooterBlockLbl: Label 'FOOTERBLOCK', locked = true;
        Param_BlockNameLbl: Label 'BLOCKNAME', locked = true;
        Param_FooterFileLbl: Label 'FOOTERFILE', locked = true;
        Param_LanguageLbl: Label 'LANGUAGE', locked = true;
        Param_VersionLbl: Label 'VERSION', locked = true;
        Param_DataBlockLbl: Label 'DATABLOCK', locked = true;
        Param_RecordIdentifierLbl: Label 'RECORDIDENTIFIER', locked = true;
        Param_UOMCodeLbl: Label 'UOMCODE', locked = true;
        Param_DoctypePITLbl: Label 'DOCTYPEPIT', locked = true;
        Param_DoctypeGITLbl: Label 'DOCTYPEGIT', locked = true;
        Param_OrganiCodeTxt: Label 'ORGANICODE', Locked = true;
        Param_DimIntercoTxt: Label 'DIMINTERCO', Locked = true;
        BSCLbl: Label 'BSC', Locked = true;
        MissingFieldValueTxt: Label 'Missing Value for %1. ';
        MissingFieldValueKeyTxt: Label '%1 is empty in the record %2 where: %3';
        TransferLineKeyTxt: Label 'Document No: %1, Line No: %2';
        PurchHeaderKeyTxt: Label 'Document No: %1';
        PurchLineKeyTxt: Label 'Document Type: %1, Document No: %2, Line No: %3';
        OrganizationCodeTok: Label 'ORGANIZATION CODE', Locked = true;
        OrderDateTok: Label 'ORDER DATE', Locked = true;
        ShipmentDateTok: Label 'SHIPMENT DATE', Locked = true;
        ItemProductLineTok: Label 'ITEM_PRODUCT_LINE', Locked = true;
        ArrivalDateTok: Label 'ARRIVAL DATE', Locked = true;
        ShipFromOrganizationCodeTok: Label 'SHIP_FROM_ORGANISATION_CODE', Locked = true;

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
        LocalCompanyInformation: Record "Company Information";
        FileName: Text;
        InstanceID: Text;
    begin
        LocalCompanyInformation.get();
        InstanceID := BSCLbl + '_' + LocalCompanyInformation."Country/Region Code";

        FileName := StrSubstNo(ParamValue_FileName,
                                    InstanceID,
                                    BatchEnv,
                                    FORMAT(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
        exit(FileName);
    end;

    procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParameters(Param_UserItemTypeLbl, ParamValue_UserItemType);
        CheckPrerequisitesAndRetrieveParameters(Param_RequestByLbl, ParamValue_RequestBy);
        CheckPrerequisitesAndRetrieveParameters(Param_RequestedBatchLbl, ParamValue_RequestedBatch);
        CheckPrerequisitesAndRetrieveParameters(Param_RequestedManLbl, ParamValue_RequestedMan);
        CheckPrerequisitesAndRetrieveParameters(Param_FileNameLbl, ParamValue_FileName);
        CheckPrerequisitesAndRetrieveParameters(Param_CountryOfOriginLbl, ParamValue_CountryOfOrigin);
        CheckPrerequisitesAndRetrieveParameters(Param_HeaderInstanceLbl, ParamValue_HeaderInstance);
        CheckPrerequisitesAndRetrieveParameters(Param_EnvLbl, ParamValue_Env);
        CheckPrerequisitesAndRetrieveParameters(Param_InstanceLbl, ParamValue_Instance);
        CheckPrerequisitesAndRetrieveParameters(Param_PurchLocFilterLbl, ParamValue_PurchLocFilter);
        CheckPrerequisitesAndRetrieveParameters(Param_HeaderFileLbl, ParamValue_HeaderFile);
        CheckPrerequisitesAndRetrieveParameters(Param_ApplicationLbl, ParamValue_Application);
        CheckPrerequisitesAndRetrieveParameters(Param_FlowNameLbl, ParamValue_FlowName);
        CheckPrerequisitesAndRetrieveParameters(Param_AppModeLbl, ParamValue_AppMode);
        CheckPrerequisitesAndRetrieveParameters(Param_LoadOptionLbl, ParamValue_LoadOption);
        CheckPrerequisitesAndRetrieveParameters(Param_HeaderBlockLbl, ParamValue_HeaderBlock);
        CheckPrerequisitesAndRetrieveParameters(Param_IntransitLbl, ParamValue_Intransit);
        CheckPrerequisitesAndRetrieveParameters(Param_BegFldsLbl, ParamValue_BegFlds);
        CheckPrerequisitesAndRetrieveParameters(Param_EndFldsLbl, ParamValue_EndFlds);
        CheckPrerequisitesAndRetrieveParameters(ParamFooterBlocklbl, ParamValue_FooterBlock);
        CheckPrerequisitesAndRetrieveParameters(Param_BlockNamelbl, ParamValue_BlockName);
        CheckPrerequisitesAndRetrieveParameters(Param_FooterFilelbl, ParamValue_FooterFile);
        CheckPrerequisitesAndRetrieveParameters(Param_LanguageLbl, ParamValue_Language);
        CheckPrerequisitesAndRetrieveParameters(Param_VersionLbl, ParamValue_Version);
        CheckPrerequisitesAndRetrieveParameters(Param_DataBlockLbl, ParamValue_DataBlock);
        CheckPrerequisitesAndRetrieveParameters(Param_RecordIdentifierLbl, ParamValue_RecordIdentifier);
        CheckPrerequisitesAndRetrieveParameters(Param_UOMCodeLbl, ParamValue_UOMCode);

        CheckPrerequisitesAndRetrieveParameters(Param_DoctypePITLbl, ParamValue_DocTypePIT);
        CheckPrerequisitesAndRetrieveParameters(Param_DoctypeGITLbl, ParamValue_DocTypeGIT);
        CheckPrerequisitesAndRetrieveParameters(Param_OrganiCodeTxt, ParamValue_OrganiCode);
        CheckPrerequisitesAndRetrieveParameters(Param_DimIntercoTxt, ParamValue_DimInterco);
    end;

    procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20]; var ParamValue: Text)
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        ParamValue := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if ParamValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamValueMsg, Param), '');
    end;

    local procedure SetData()
    begin
        EntryNo := 1;
        GetPIT();
        GetGIT();
    end;

    local procedure GetPIT()
    var
        MICAPITStock: Query "MICA PIT Stock";
    begin
        MICAPITStock.SetFilter(MICAPITStock.MICA_User_Item_Type, ParamValue_UserItemType);
        MICAPITStock.SetFilter(MICAPITStock.Location_Code, ParamValue_PurchLocFilter);
        MICAPITStock.Open();
        while MICAPITStock.Read() do begin
            TempItemLedgerEntry.Init();
            TempItemLedgerEntry."Entry No." := EntryNo;
            TempItemLedgerEntry."Shpt. Method Code" := CopyStr(MICAPITStock.MICA_AL_No_, 1, 2); // ODCountryCode
            TempItemLedgerEntry."Source No." := MICAPITStock.Document_No_; // DocumentNum
            TempItemLedgerEntry."Document Line No." := MICAPITStock.Line_No_; // LineNUM
            TempItemLedgerEntry."Item No." := MICAPITStock.No_; //ItemSegment1
            TempItemLedgerEntry."Location Code" := MICAPITStock.MICA_Location_To_Code; // ShipToLocation
            // TempItemLedgerEntry."No. Series" := PITStock.MICA_Ship_From_Vendor; //SHIP_FROM_ORGANIZATION_CODE
            TempItemLedgerEntry.Quantity := MICAPITStock.Quantity; // OrderedQty
            TempItemLedgerEntry."Invoiced Quantity" := MICAPITStock.Quantity; // InTransitQty
            TempItemLedgerEntry."Last Invoice Date" := MICAPITStock.Order_Date; //OrderDate
            TempItemLedgerEntry."Remaining Quantity" := 0; //ShippedQty
            TempItemLedgerEntry."Item Category Code" := MICAPITStock.Item_Category_Code; //ItemProductLine
            TempItemLedgerEntry."Global Dimension 1 Code" := MICAPITStock.MICA_Ship_From_Vendor; //SHIP_FROM_ORGANIZATION_CODE
            TempItemLedgerEntry."Global Dimension 2 Code" := MICAPITStock.MICA_DC14;

            TempItemLedgerEntry."External Document No." := CopyStr(ParamValue_DocTypePIT, 1, MaxStrLen(TempItemLedgerEntry."External Document No.")); //DOCUMENT_TYPE
            TempItemLedgerEntry."Expiration Date" := MICAPITStock.MICA_SRD; // ArrivalDate
            TempItemLedgerEntry."Area" := MICAPITStock.PurchHeader_MICA_Location_To_Code; //SHIP_TO_ORGANIZATION_CODE
            TempItemLedgerEntry.Insert();

            CheckMandatoryPITFields(TempItemLedgerEntry);
            EntryNo += 1;
        end;
        MICAPITStock.Close();
    end;

    local procedure GetGIT()
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        MICAGITStock: Query "MICA GIT Stock";
    begin
        MICAGITStock.SetFilter(MICAGITStock.MICA_User_Item_Type, ParamValue_UserItemType);
        MICAGITStock.Open();
        while MICAGITStock.Read() do begin
            Clear(PurchaseHeader);
            Clear(PurchaseLine);
            TempItemLedgerEntry.Init();
            TempItemLedgerEntry."Entry No." := EntryNo;
            TempItemLedgerEntry."Source No." := MICAGITStock.No_;
            TempItemLedgerEntry."Item No." := MICAGITStock.Item_No_;
            TempItemLedgerEntry."Location Code" := MICAGITStock.Transfer_to_Code;
            if MICAGITStock.MICA_ASN_No_ <> '' then
                GetPurchHeaderAndLine(MICAGITStock.MICA_ASN_No_, MICAGITStock.MICA_ASN_Line_No_, PurchaseHeader, PurchaseLine);
            TempItemLedgerEntry."Shpt. Method Code" := CopyStr(MICAGITStock.MICA_Country_of_Origin, 1, 2); //OD_CountryCode
            TempItemLedgerEntry."Document Line No." := MICAGITStock.Line_No_;
            TempItemLedgerEntry."No. Series" := ''; // ShipmentNumber
            TempItemLedgerEntry.Quantity := PurchaseLine.Quantity;
            TempItemLedgerEntry."Invoiced Quantity" := MICAGITStock.TransLineQuantity; // InTransitQty
            TempItemLedgerEntry."Document Date" := MICAGITStock.Shipment_Date; // ShipmentDate
            TempItemLedgerEntry."Expiration Date" := MICAGITStock.MICA_SRD; // ArrivalDate
            if PurchaseHeader."Order Date" <> 0D then
                TempItemLedgerEntry."Last Invoice Date" := PurchaseHeader."Order Date" //OrderDate
            else
                TempItemLedgerEntry."Last Invoice Date" := MICAGITStock.MICA_ASN_Date;
            TempItemLedgerEntry."Remaining Quantity" := MICAGITStock.TransLineQuantity; //ShippedQty
            TempItemLedgerEntry."Item Category Code" := MICAGITStock.Item_Category_Code; //ItemProductLine
            TempItemLedgerEntry."Global Dimension 1 Code" := PurchaseLine."MICA Ship From Vendor"; //SHIP_FROM_ORGANIZATION_CODE
            TempItemLedgerEntry."Global Dimension 2 Code" := MICAGITStock.MICA_DC14;
            TempItemLedgerEntry."External Document No." := CopyStr(ParamValue_DocTypeGIT, 1, MaxStrLen(TempItemLedgerEntry."External Document No."));
            TempItemLedgerEntry."Order Line No." := MICAGITStock.MICA_Shipment_Line_Num; //ShipmentLineNum
            TempItemLedgerEntry."Area" := MICAGITStock.Transfer_to_Code; //SHIP_TO_ORGANIZATION_CODE
            TempItemLedgerEntry.Insert();

            CheckMandatoryGITFields(TempItemLedgerEntry, PurchaseHeader."No.");
            EntryNo += 1;
        end;
        MICAGITStock.Close();
    end;

    local procedure GetPurchHeaderAndLine(ASNNo: Code[20]; ASNLineNo: Integer; var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine.SetCurrentKey("MICA ASN No.", "MICA ASN Line No.");
        PurchaseLine.SetRange("MICA ASN No.", ASNNo);
        PurchaseLine.SetRange("MICA ASN Line No.", ASNLineNo);
        if PurchaseLine.FindFirst() then
            PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
    end;

    local procedure CheckMandatoryGITFields(ItemLedgerEntry: Record "Item Ledger Entry"; PurchHeaderNo: Code[20])
    var
        TransferLine: Record "Transfer Line";
        PurchaseHeader: Record "Purchase Header";
    begin
        CheckIfFieldIsEmpty(
            Format(ItemLedgerEntry."Document Date"),
            StrSubstNo(MissingFieldValueTxt, ShipmentDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                TransferLine.FieldCaption("MICA ASN Date"),
                TransferLine.TableCaption(),
                StrSubstNo(TransferLineKeyTxt, ItemLedgerEntry."Source No.", ItemLedgerEntry."Document Line No.")));
        CheckIfFieldIsEmpty(
            Format(ItemLedgerEntry."Expiration Date"),
            StrSubstNo(MissingFieldValueTxt, ArrivalDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                TransferLine.FieldCaption("MICA SRD"),
                TransferLine.TableCaption(),
                StrSubstNo(TransferLineKeyTxt, ItemLedgerEntry."Source No.", ItemLedgerEntry."Document Line No.")));
        CheckIfFieldIsEmpty(
            Format(ItemLedgerEntry."Last Invoice Date"),
            StrSubstNo(MissingFieldValueTxt, OrderDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                PurchaseHeader.FieldCaption("Order Date"),
                PurchaseHeader.TableCaption(),
                StrSubstNo(PurchHeaderKeyTxt, PurchHeaderNo)));
        CheckIfFieldIsEmpty(
            ItemLedgerEntry."Item Category Code",
            StrSubstNo(MissingFieldValueTxt, ItemProductLineTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                TransferLine.FieldCaption("Item Category Code"),
                TransferLine.TableCaption(),
                StrSubstNo(TransferLineKeyTxt, ItemLedgerEntry."Source No.", ItemLedgerEntry."Document Line No.")));
        CheckIfFieldIsEmpty(
            ItemLedgerEntry."No. Series",
            StrSubstNo(MissingFieldValueTxt, ShipFromOrganizationCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                TransferLine.FieldCaption("MICA Ship From Vendor"),
                TransferLine.TableCaption(),
                StrSubstNo(TransferLineKeyTxt, ItemLedgerEntry."Source No.", ItemLedgerEntry."Document Line No.")));
    end;

    local procedure CheckMandatoryPITFields(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        CheckIfFieldIsEmpty(
            Format(ItemLedgerEntry."Last Invoice Date"),
            StrSubstNo(MissingFieldValueTxt, OrderDateTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                PurchaseHeader.FieldCaption("Document Date"),
                PurchaseHeader.TableCaption(),
                StrSubstNo(PurchHeaderKeyTxt, ItemLedgerEntry."Source No.")));
        CheckIfFieldIsEmpty(
            ItemLedgerEntry."Item Category Code",
            StrSubstNo(MissingFieldValueTxt, ItemProductLineTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                PurchaseLine.FieldCaption("Item Category Code"),
                PurchaseLine.TableCaption(),
                StrSubstNo(PurchLineKeyTxt, Format(PurchaseLine."Document Type"::Order), ItemLedgerEntry."Source No.", ItemLedgerEntry."Document Line No.")));
        CheckIfFieldIsEmpty(
            ItemLedgerEntry."No. Series",
            StrSubstNo(MissingFieldValueTxt, ShipFromOrganizationCodeTok),
            StrSubstNo(
                MissingFieldValueKeyTxt,
                PurchaseLine.FieldCaption("MICA Ship From Vendor"),
                PurchaseLine.TableCaption(),
                StrSubstNo(PurchLineKeyTxt, Format(PurchaseLine."Document Type"::Order), ItemLedgerEntry."Source No.", ItemLedgerEntry."Document Line No.")));
    end;

    local procedure CheckIfFieldIsEmpty(FieldValue: Text; Description: Text; Description2: Text)
    begin
        if FieldValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, Description, Description2);
    end;

    procedure GetItemMarketCode(ItemNo: Code[20]): Text
    var
        MICATableValue: Record "MICA Table Value";
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit;
        if MICATableValue.Get(MICATableValue."Table Type"::MarketCode, Item."MICA Market Code") then
            exit(MICATableValue.Description);
    end;

    local procedure GetLocationDRPINCode(LocationCode: Code[10]): Code[50]
    var
        Location: Record Location;
    begin
        if Location.Get(LocationCode) then
            exit(Location."MICA DRP IN Location Code");
    end;
}