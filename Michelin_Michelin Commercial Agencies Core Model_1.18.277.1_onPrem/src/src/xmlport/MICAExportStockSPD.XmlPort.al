xmlport 82340 "MICA Export Stock SPD"
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
                textelement(EnvirInstance) { }
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

                trigger OnAfterGetRecord()
                begin
                    ConstantRowCount += 1;
                    if not GuiAllowed() then
                        FileRequestedBy := StrSubstNo(Request_By, Instance, RequestedBatch)
                    else
                        FileRequestedBy := StrSubstNo(Request_By, Instance, RequestedMan);
                    HeaderFile := HeaderFileLbl;
                    Application := ApplicationLbl;
                    FlowName := FlowNameLbl;
                    AppMode := AppModeLbl;
                    FileDate := FORMAT(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');
                    SourceFileExtractDate := FileDate;
                    FileVersion := VersionLbl;
                    Language := LanguageLbl;
                    EnvirInstance := StrSubstNo(HeaderInstance, Env, Instance);
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
                    HeaderBlock := HeaderBlockLbl;
                    HeaderBlockName := HeaderBlockNameLbl;
                end;
            }
            tableelement(DataBlock; Integer)
            {
                XmlName = 'DataBlock';
                SourceTableView = sorting(Number);
                textelement(RecordIdentifier) { }
                textelement(CompanyCode) { }
                textelement(OrganizationCode) { }
                textelement(OrganizationType) { }
                textelement(FinishedGoodOrganizationType) { }
                textelement(OCCompanyCode) { }
                textelement(ODCountryCode) { }
                textelement(ORCountryCode) { }
                textelement(Site) { }
                textelement(ItemSegment1) { }
                textelement(ParentItem) { }
                textelement(ItemSegment2) { }
                textelement(CCI) { }
                textelement(CAD) { }
                textelement(ItemCategory) { }
                textelement(FGCategory) { }
                textelement(PurchasingCategory) { }
                textelement(MFGCategory) { }
                textelement(ProductFamily) { }
                textelement(OMCategory) { }
                textelement(Warehouse) { }
                textelement(ItemDescription) { }
                textelement(Revision) { }
                textelement(Subinventory) { }
                textelement(Locator) { }
                textelement(Lot) { }
                textelement(Lpn) { }
                textelement(ParentLpn) { }
                textelement(Serial) { }
                textelement(ContainerizedFlag) { }
                textelement(ReceivingLocation) { }
                textelement(PrimaryQuantity) { }
                textelement(PrimaryUOM) { }
                textelement(PrimaryQuantityValue) { }
                textelement(UnitCost) { }
                textelement(SnapshotDate) { }
                textelement(OnHandStatus) { }
                textelement(MaterialLocation) { }
                textelement(OwningParty) { }
                textelement(CostType) { }
                textelement(CustomerCountryCode) { }
                textelement(MarketCode) { }
                textelement(ClientCode) { }
                textelement(NipImp) { }
                textelement(Matanom) { }
                textelement(Matref) { }
                textelement(SnapshotTimeDateTimeZone) { }
                textelement(DunsCode) { }
                textelement(MichDuns) { }
                textelement(IntendedMarket) { }
                textelement(ItemProductNature) { }
                textelement(StockType) { }
                textelement(ReceivingLocationType) { }
                textelement(StockStatus) { }
                textelement(BusinessLine) { }
                trigger OnPreXmlItem()
                begin
                    TempInventoryBuffer.Reset();
                    TempInventoryBuffer.SetCurrentKey("Serial No.");
                    ExportedRecordCount := TempInventoryBuffer.Count();

                    DataBlock.SetFilter(Number, '%1..%2', 1, ExportedRecordCount);
                end;

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                begin
                    if DataBlock.Number = 1 then
                        TempInventoryBuffer.FindFirst()
                    else
                        TempInventoryBuffer.Next();
                    RecordIdentifier := RecordIdentifierLbl;
                    CompanyCode := MICAFinancialReportingSetup."Company Code" + CompCodeSufixLbl;
                    OrganizationCode := TempInventoryBuffer."Serial No.";
                    ItemSegment1 := TempInventoryBuffer."Item No.";
                    PrimaryQuantity := FORMAT(TempInventoryBuffer.Quantity, 0, 9);
                    StockType := StockTypeLbl;
                    StockStatus := TempInventoryBuffer."Bin Code";
                    BusinessLine := TempInventoryBuffer."Variant Code";
                    OMCategory := TempInventoryBuffer."Lot No.";
                    CheckIfFieldIsEmpty(
                        OMCategory,
                        StrSubstNo(MissingFieldValueMsg, OMCategoryTok),
                        StrSubstNo(MissingFieldValueKeyMsg, Item.FieldCaption("Item Category Code"), Item.TableCaption(), StrSubstNo(NoKeyTxt, ItemSegment1)));
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
                    FooterBlock := FooterDataBlockLbl;
                    FooterBlockName := ApplicationLbl;
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
                    FooterFile := FooterFileLbl;
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
            StrSubstNo(MissingFieldValueMsg, CompanyCodeTok),
            StrSubstNo(MissingFieldValueKeyMsg, MICAFinancialReportingSetup.FieldCaption("Company Code"), MICAFinancialReportingSetup.TableCaption(), ''));

        CheckLocationForGrouping();
        SetData();
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        MICAFlowEntry: Record "MICA Flow Entry";
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
        TempInventoryBuffer: Record "Inventory Buffer" Temporary;
        ExportedRecordCount: Integer;
        UserItemType: Text;
        FileNaming: Text;
        CountryOfOrigin: Text;
        Instance: Text;
        Env: Text;
        Environement: Text;
        Request_By: Text;
        RequestedBatch: Text;
        RequestedMan: Text;
        HeaderInstance: Text;
        LanguageLbl: Label 'EN', Locked = true;
        VersionLbl: Label '1.0', Locked = true;
        ApplicationLbl: Label 'STOCKLEVEL', Locked = true;
        HeaderFileLbl: Label 'HEADER_FILE', Locked = true;
        AppModeLbl: Label 'INCREMENTAL', Locked = true;
        FlowNameLbl: Label 'INVSTOCKLEVEL', Locked = true;
        HeaderBlockLbl: Label 'HEADER_BLOCK', Locked = true;
        HeaderBlockNameLbl: Label 'MATERIAL TRANSACTIONS', Locked = true;
        RecordIdentifierLbl: Label 'MTL_STOCKLEVEL', Locked = true;
        CompCodeSufixLbl: Label '_OU', Locked = true;
        StockTypeLbl: Label 'COMMERCIAL', Locked = true;
        FooterDataBlockLbl: Label 'FOOTER_BLOCK', Locked = true;
        FooterFileLbl: Label 'FOOTER_FILE', Locked = true;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingParamValueMsg: Label 'Missing value for parameter %1';
        Param_UserItemTypeLbl: Label 'USERITEMTYPE', Locked = true;
        Param_FileNamingTxt: Label 'FILENAMING', Locked = true;
        Param_CountryOfOriginTxt: Label 'COUNTRYOFORIGIN', Locked = true;
        Param_InstanceTxt: Label 'INSTANCE', Locked = true;
        Param_EnvTxt: Label 'ENV', Locked = true;
        Param_EnvironementTxt: Label 'ENVIRONEMENT', Locked = true;
        Param_RequestByTxt: Label 'REQUEST_BY', Locked = true;
        Param_RequestedBatchTxt: Label 'REQUESTEDBATCH', locked = true;
        Param_RequestedManTxt: Label 'REQUESTEDMAN', Locked = true;
        Param_HeaderInstanceTxt: Label 'HEADERINSTANCE', locked = true;
        BSCLbl: Label 'BSC', Locked = true;
        StockStatusBlockedLbl: label 'BLOCKED', locked = true;
        StockStatusOnHandLbl: Label 'ON_HAND', Locked = true;
        ConstantRowCount: Integer;
        MissingFieldValueMsg: Label 'Missing Value for %1. ';
        MissingFieldValueKeyMsg: Label '%1 is empty in the record %2 where: %3';
        NoKeyTxt: Label 'No: %1';
        EmptyFieldsTxt: Label 'Fields %1, %2, are empty. ';
        GroupingFieldsNotSetUpMsg: Label 'One or more Location must be set up for stock grouping. ';
        CompanyCodeTok: Label 'COMPANY CODE', Locked = true;
        OMCategoryTok: Label 'OM_CATEGORY', Locked = true;

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
        CompanyInformation: Record "Company Information";
        FileName: Text;
        InstanceID: Text;
    begin
        CompanyInformation.get();
        InstanceID := BSCLbl + '_' + CompanyInformation."Country/Region Code";

        FileName := StrSubstNo(FileNaming,
                                    InstanceID,
                                    GetRequestedBy(),
                                    FORMAT(CurrentDateTime(), 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>'));
        exit(FileName);
    end;

    procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParameters(Param_UserItemTypeLbl, UserItemType);
        CheckPrerequisitesAndRetrieveParameters(Param_FileNamingTxt, FileNaming);
        CheckPrerequisitesAndRetrieveParameters(Param_CountryOfOriginTxt, CountryOfOrigin);
        CheckPrerequisitesAndRetrieveParameters(Param_InstanceTxt, Instance);
        CheckPrerequisitesAndRetrieveParameters(Param_EnvTxt, Env);
        CheckPrerequisitesAndRetrieveParameters(Param_EnvironementTxt, Environement);
        CheckPrerequisitesAndRetrieveParameters(Param_RequestByTxt, Request_By);
        CheckPrerequisitesAndRetrieveParameters(Param_RequestedManTxt, RequestedMan);
        CheckPrerequisitesAndRetrieveParameters(Param_RequestedBatchTxt, RequestedBatch);
        CheckPrerequisitesAndRetrieveParameters(Param_HeaderInstanceTxt, HeaderInstance);
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
    var
        MICAItemOnHandStockSPD: Query "MICA Item OnHand Stock SPD";
        MICAItemBlockedStockSPD: Query "MICA Item Blocked Stock SPD";
    begin
        // Get on hand inventory 
        MICAItemOnHandStockSPD.SetRange(MICAItemOnHandStockSPD.MICA_User_Item_Type, UserItemType);
        MICAItemOnHandStockSPD.Open();
        while MICAItemOnHandStockSPD.Read() do begin
            Clear(TempInventoryBuffer);
            TempInventoryBuffer."Item No." := MICAItemOnHandStockSPD.No_;
            TempInventoryBuffer."Serial No." := MICAItemOnHandStockSPD.MICA_SPD_OnHand_Qty__Code;
            TempInventoryBuffer.Quantity := MICAItemOnHandStockSPD.Quantity;
            TempInventoryBuffer."Bin Code" := StockStatusOnHandLbl;
            TempInventoryBuffer."Variant Code" := MICAItemOnHandStockSPD.MICA_Business_Line;
            TempInventoryBuffer."Lot No." := MICAItemOnHandStockSPD.Item_Category_Code;
            TempInventoryBuffer.Insert();
        end;
        MICAItemOnHandStockSPD.Close();
        // Get blocked inventory
        MICAItemBlockedStockSPD.SetRange(MICAItemBlockedStockSPD.MICA_User_Item_Type, UserItemType);
        MICAItemBlockedStockSPD.Open();
        while MICAItemBlockedStockSPD.Read() do begin
            Clear(TempInventoryBuffer);
            TempInventoryBuffer."Item No." := MICAItemBlockedStockSPD.No_;
            TempInventoryBuffer."Serial No." := MICAItemBlockedStockSPD.MICA_SPD_Blocked_Qty__Code;
            TempInventoryBuffer.Quantity := MICAItemBlockedStockSPD.Quantity;
            TempInventoryBuffer."Bin Code" := StockStatusBlockedLbl;
            TempInventoryBuffer."Variant Code" := MICAItemBlockedStockSPD.MICA_Business_Line;
            TempInventoryBuffer."Lot No." := MICAItemBlockedStockSPD.Item_Category_Code;
            TempInventoryBuffer.Insert();
        end;
        MICAItemBlockedStockSPD.Close();
    end;

    local procedure CheckIfFieldIsEmpty(FieldValue: Text; Description: Text; Description2: Text)
    begin
        if FieldValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, Description, Description2);
    end;

    local procedure CheckLocationForGrouping()
    var
        Location: record Location;
    begin
        Location.SetFilter("MICA SPD OnHand Qty. Code", '<>%1', '');
        if not Location.IsEmpty() then
            exit;
        Location.Reset();
        Location.SetFilter("MICA SPD Blocked Qty. Code", '<>%1', '');
        if not Location.IsEmpty() then
            exit;

        MICAFlowEntry.AddInformation(
            MICAFlowInformation."Info Type"::Warning,
            StrSubstNo(EmptyFieldsTxt, Location.FieldCaption("MICA SPD Blocked Qty. Code"), Location.FieldCaption("MICA SPD OnHand Qty. Code")),
            GroupingFieldsNotSetUpMsg);
    end;

    local procedure GetRequestedBy(): Text;
    var
        param: Text;
    begin
        if CurrentClientType() = ClientType::Background then
            param := RequestedBatch
        else begin
            param := UserId();
            param := param.Replace('\', '-');
        end;
        exit(param);
    end;
}