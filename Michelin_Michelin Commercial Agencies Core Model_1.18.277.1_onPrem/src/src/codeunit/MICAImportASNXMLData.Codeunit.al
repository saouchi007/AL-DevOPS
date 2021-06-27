codeunit 81984 "MICA Import ASN XML Data"
{
    trigger OnRun()
    begin
        LoadData();
    end;

    procedure LoadData()
    begin
        XmlDocument.ReadFrom(InStream, xmlDoc);

        CheckAndRetrieveParameters();
        PopulateTechniqueFields();
        PopulateHeaderFields();
        PopulateLineFieldsAndInsertASNBuffer();
    End;

    procedure PopulateTechniqueFields()
    var
        TypeHelper: Codeunit "Type Helper";
        DTVariant: Variant;
        CreationDT: DateTime;
        DocDateTime: Text;
    begin
        CreationDT := 0DT;
        DocDateTime := GetNodeValue(Param_CreationDatetimeLbl, false);
        DTVariant := CreationDT;
        TypeHelper.Evaluate(DTVariant, DocDateTime, '', '');
        Evaluate(CreationDT, format(DTVariant));

        MICAFlowEntry.UpdateTechnicalData(
          GetNodeValue(Param_LogicalIDLbl, false),
          GetNodeValue(Param_ComponentIDLbl, false),
          GetNodeValue(Param_TaskIDLbl, false),
          GetNodeValue(Param_ReferenceIDLbl, false),
          CreationDT,
          '', '', '', '', '', '');
    end;

    procedure PopulateHeaderFields()
    begin
        // mandatory
        MICAFlowBufferASN.Init();
        MICAFlowBufferASN."Doc. ID" :=
          CopyStr(GetNodeValue(Param_DocumentIDLbl, true), 1, MaxStrLen(MICAFlowBufferASN."Doc. ID"));
        MICAFlowBufferASN."Alt. Doc. ID" :=
          CopyStr(GetNodeValue(Param_AlternateDocumentIDLbl, true), 1, MaxStrLen(MICAFlowBufferASN."Alt. Doc. ID"));
        MICAFlowBufferASN."Actual Ship DateTime Raw" :=
          CopyStr(GetNodeValue(Param_ActualShipDatetimeLbl, true), 1, MaxStrLen(MICAFlowBufferASN."Actual Ship DateTime Raw"));
        //Buffer."SRD Raw" :=
        //CopyStr(GetNodeValue(Param_SRDLbl, true), 1, MaxStrLen(Buffer."SRD Raw"));
        MICAFlowBufferASN."Ship. From" :=
          CopyStr(GetNodeValue(Param_ShipFromLbl, true), 1, MaxStrLen(MICAFlowBufferASN."Ship. From"));
        MICAFlowBufferASN."Arrival Port" :=
          CopyStr(GetNodeValue(Param_ArrivalPortLbl, true), 1, MaxStrLen(MICAFlowBufferASN."Arrival Port"));
        MICAFlowBufferASN."Container ID Raw" :=
          CopyStr(GetNodeValue(Param_ContainerIDLbl, true), 1, MaxStrLen(MICAFlowBufferASN."Container ID"));
        MICAFlowBufferASN."Doc. Type" :=
          CopyStr(GetNodeValue(Param_DocumentTypeLbl, true), 1, MaxStrLen(MICAFlowBufferASN."Doc. Type"));
        MICAFlowBufferASN."ETA Raw" :=
          CopyStr(GetNodeValue(Param_ETALbl, true), 1, MaxStrLen(MICAFlowBufferASN."ETA Raw"));
        // optional
        MICAFlowBufferASN."Seal Number" := CopyStr(GetNodeValue(Param_SealIDLbl, false), 1, MaxStrLen(MICAFlowBufferASN."Seal Number"));
        MICAFlowBufferASN."Maritime Air Company Name" := CopyStr(GetNodeValue(Param_MaritimeAirCompanyNameLbl, false), 1, MaxStrLen(MICAFlowBufferASN."Maritime Air Company Name"));
        MICAFlowBufferASN."Maritime Air Number" := CopyStr(GetNodeValue(Param_MaritimeAirNumberLbl, false), 1, MaxStrLen(MICAFlowBufferASN."Maritime Air Number"));
        // Technical fields
        MICAFlowBufferASN."Date Time Creation" := MICAFlowEntry."Creation Date Time";
        MICAFlowBufferASN."Tech. Component ID" := CopyStr(MICAFlowEntry."Component ID", 1, MaxStrLen(MICAFlowBufferASN."Tech. Component ID"));
        MICAFlowBufferASN."Tech. Creation DateTime Raw" := copystr(GetNodeValue(Param_CreationDatetimeLbl, false), 1, 50);
        MICAFlowBufferASN."Tech. Logical ID" := MICAFlowEntry."Logical ID";
        MICAFlowBufferASN."Tech. Reference ID" := CopyStr(MICAFlowEntry."Reference ID", 1, MaxStrLen(MICAFlowBufferASN."Tech. Reference ID"));
        MICAFlowBufferASN."Tech. Task ID" := CopyStr(MICAFlowEntry."Task ID", 1, MaxStrLen(MICAFlowBufferASN."Tech. Task ID"));
    end;

    procedure PopulateLineFieldsAndInsertASNBuffer()
    var
        xmlNodeItemList: XmlNodeList;
        xmlNodeItem: XmlNode;
        XPath_Items: Text;
    begin
        XPath_Items := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param_ItemsLbl);
        if xmlDoc.SelectNodes(XPath_Items, xmlNodeItemList) then
            foreach xmlNodeItem in xmlNodeItemList do begin
                // mandatory
                MICAFlowBufferASN.CAI :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_CAILbl, true), 1, MaxStrLen(MICAFlowBufferASN.CAI));
                MICAFlowBufferASN.CCI :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_CCILbl, true), 1, MaxStrLen(MICAFlowBufferASN.CCI));
                MICAFlowBufferASN."Market Code" :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_MarketCodeLbl, true), 1, MaxStrLen(MICAFlowBufferASN."Market Code"));
                MICAFlowBufferASN."AL No. Raw" :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_ALNumberLbl, true), 1, MaxStrLen(MICAFlowBufferASN."AL No. Raw"));// PURCHASE_ORDER_NUMBER
                MICAFlowBufferASN."AL Line No." :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_ALLineNumberLbl, true), 1, MaxStrLen(MICAFlowBufferASN."AL Line No."));// PURCHASE_ORDER_NUMBER_LINE
                MICAFlowBufferASN."Quantity Raw" :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_QuantityLbl, true), 1, MaxStrLen(MICAFlowBufferASN."Quantity Raw"));
                MICAFlowBufferASN."ASN Line Number Raw" :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_LineNumberLbl, true), 1, MaxStrLen(MICAFlowBufferASN."ASN Line Number Raw"));

                // optional                        	
                MICAFlowBufferASN."Country Code" :=
                   CopyStr(GetNodeValue(Param_CountryCodeLbl, false), 1, MaxStrLen(MICAFlowBufferASN."Country Code"));
                MICAFlowBufferASN."Carrier Doc. No." :=
                   CopyStr(GetNodeValue(Param_BordereauTransportLbl, false), 1, MaxStrLen(MICAFlowBufferASN."Carrier Doc. No."));
                MICAFlowBufferASN."Ctry. ISO Code Of Orig. Manuf." :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_IsoCtryOfOriginLbl, false), 1, MaxStrLen(MICAFlowBufferASN."Ctry. ISO Code Of Orig. Manuf."));
                MICAFlowBufferASN.CCID :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_CCIDLbl, false), 1, MaxStrLen(MICAFlowBufferASN.CCID));
                MICAFlowBufferASN.CST :=
                  CopyStr(GetNodeValue(xmlNodeItem, Param_CSTLbl, false), 1, MaxStrLen(MICAFlowBufferASN.CST));
                InsertBuffer();
            end;
    end;

    procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParameters(Param_ActualShipDatetimeLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ALLineNumberLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ALNumberLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_AlternateDocumentIDLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ArrivalPortLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_BordereauTransportLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_CAILbl);
        CheckPrerequisitesAndRetrieveParameters(Param_CCILbl);
        CheckPrerequisitesAndRetrieveParameters(Param_CCIDLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ComponentIDLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ContainerIDLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_CountryCodeLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_CreationDatetimeLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_CSTLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentTypeLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentIDLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ETALbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ItemsLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_LineNumberLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_LogicalIDLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_MarketCodeLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_QuantityLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ReferenceIDLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_SealIDLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ShipFromLbl);
        //CheckPrerequisitesAndRetrieveParameters(Param_SRDLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_TaskIDLbl);
    end;

    procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20])
    var
        XPath: Text;
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        XPath := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if XPath = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingXPathMsg, Param), '');
    end;

    procedure GetNodeValue(Param: Text[20]; Mandatory: Boolean): Text
    var
        xmlNodeInfo: XmlNode;
        XPath: Text;
        NodeValue: Text;
    begin
        XPath := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if XPath = '' then
            exit('');

        if not xmlDoc.SelectSingleNode(XPath, xmlNodeInfo) then begin
            GenerateInformation(Param, XPath, Mandatory, MissingNodeMsg);
            exit('');
        end;

        NodeValue := xmlNodeInfo.AsXmlElement().InnerText();
        if NodeValue = '' then
            GenerateInformation(Param, XPath, Mandatory, MissingNodeValueMsg);

        exit(NodeValue);
    end;

    procedure GetNodeValue(xmlNodeItem: XmlNode; Param: Text[20]; Mandatory: Boolean): Text
    var
        XPath: Text;
        NodeValue: Text;
    begin
        XPath := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if XPath = '' then
            exit('');

        if not xmlNodeItem.SelectSingleNode(XPath, xmlNodeItem) then begin
            GenerateInformation(Param, XPath, Mandatory, MissingNodeMsg);
            exit('');
        end;

        NodeValue := xmlNodeItem.AsXmlElement().InnerText();
        if NodeValue = '' then
            GenerateInformation(Param, XPath, Mandatory, MissingNodeValueMsg);

        exit(NodeValue);
    end;

    procedure GenerateInformation(Param: Text[20]; XPath: Text; Mandatory: Boolean; Info: Text)
    begin
        if Mandatory then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(Info, Param, XPath), '')
        else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(Info, Param, XPath), '');
    End;

    procedure InsertBuffer()
    begin
        ImportedRecordCount += 1;
        MICAFlowBufferASN."Tech. Native ID" := CopyStr(MICAFlowBufferASN."Doc. ID" + 'ODOR' +
          format(MICAFlowBufferASN."Date Time Creation"), 1, MaxStrLen(MICAFlowBufferASN."Tech. Native ID"));
        MICAFlowBufferASN.Validate("Flow Entry No.", MICAFlowEntry."Entry No.");
        MICAFlowBufferASN."Entry No." := 0;
        MICAFlowBufferASN.Insert();
    End;

    procedure SetFlowEntry(var PMICAFlowEntry: Record "MICA Flow Entry")
    begin
        MICAFlowEntry := PMICAFlowEntry;
    end;

    procedure SetSource(PInStream: InStream)
    begin
        InStream := PInStream;
    end;

    procedure GetBuffer(var OutMICAFlowBufferASN: Record "MICA Flow Buffer ASN")
    begin
        OutMICAFlowBufferASN := MICAFlowBufferASN;
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ImportedRecordCount);
    end;

    var
        MICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        ParamMICAFlowSetup: Record "MICA Flow Setup";

        xmlDoc: XmlDocument;
        InStream: InStream;
        ImportedRecordCount: Integer;
        Param_ActualShipDatetimeLbl: Label 'ACTUALSHIPDATETIME', Locked = true;
        Param_ALLineNumberLbl: Label 'AL_LINE_NUMBER', Locked = true;
        Param_ALNumberLbl: Label 'AL_NUMBER', Locked = true;
        Param_AlternateDocumentIDLbl: Label 'ALTERNATEDOCUMENTID', Locked = true;
        Param_ArrivalPortLbl: Label 'ARRIVAL_PORT', Locked = true;
        Param_BordereauTransportLbl: Label 'BORDEREAUTRANSPORT', Locked = true;
        Param_CAILbl: Label 'CAI', Locked = true;
        Param_CCILbl: Label 'CCI', Locked = true;
        Param_CCIDLbl: Label 'CCID', Locked = true;
        Param_ComponentIDLbl: Label 'COMPONENTID', Locked = true;
        Param_ContainerIDLbl: Label 'CONTAINER_ID', Locked = true;
        Param_CountryCodeLbl: Label 'COUNTRYCODE', Locked = true;
        Param_CreationDatetimeLbl: Label 'CREATIONDATETIME', Locked = true;
        Param_CSTLbl: Label 'CST', Locked = true;
        Param_DocumentTypeLbl: Label 'DOCUMENT_TYPE', Locked = true;
        Param_DocumentIDLbl: Label 'DOCUMENTID', Locked = true;
        Param_ETALbl: Label 'ETA', Locked = true;
        Param_ItemsLbl: Label 'ITEMS', Locked = true;
        Param_LineNumberLbl: Label 'LINENUMBER', Locked = true;
        Param_LogicalIDLbl: Label 'LOGICALID', Locked = true;
        Param_MarketCodeLbl: Label 'MARKET_CODE', Locked = true;
        Param_QuantityLbl: Label 'QUANTITY', Locked = true;
        Param_ReferenceIDLbl: Label 'REFERENCEID', Locked = true;
        Param_SealIDLbl: Label 'SEALID', Locked = true;
        Param_ShipFromLbl: Label 'SHIP_FROM', Locked = true;
        Param_MaritimeAirCompanyNameLbl: Label 'MARITIME_AIR_COMPANY', locked = true;
        Param_MaritimeAirnumberLbl: Label 'MARITIME_AIR_NUMBER', locked = true;
        Param_IsoCtryOfOriginLbl: label 'ISOCOUNTRYOFORIGIN', locked = true;
        Param_TaskIDLbl: Label 'TASKID', Locked = true;

        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingXPathMsg: Label 'Missing XPath for parameter %1';

        MissingNodeMsg: Label 'Node not found (Flow parameter: %1, XPath: %2)';
        MissingNodeValueMsg: Label 'Node has no value (Flow parameter: %1, XPath: %2)';
}