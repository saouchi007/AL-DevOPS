codeunit 82441 "MICA Import SRD/ETA XML"
{
    var
        MICAFlowInformation: Record "MICA Flow Information";
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowBufferETASRD: Record "MICA Flow Buffer ETA SRD";
        ImportedRecordCount: Integer;
        InStream: InStream;
        FromXmlDoc: XmlDocument;
        Param_ASNNoLbl: Label 'ASN_NUMBER', Locked = true;
        Param_ETALbl: Label 'ETA_DATE', Locked = true;
        Param_SRDLbl: Label 'SCH_RECEPTION_DATE', Locked = true;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingXPathMsg: Label 'Missing XPath for parameter %1';
        MissingNodeMsg: Label 'Node not found (Flow parameter: %1, XPath: %2)';
        MissingNodeValueMsg: Label 'Node has no value (Flow parameter: %1, XPath: %2)';

    trigger OnRun()
    begin
        XmlDocument.ReadFrom(InStream, FromXmlDoc);
        CheckAndRetrieveParameters();
        PopulateFields();
    end;

    local procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParameters(Param_ASNNoLbl);
        CheckPrerequisitesAndRetrieveParameters(Param_ETALbl);
        CheckPrerequisitesAndRetrieveParameters(Param_SRDLbl);
    end;

    local procedure PopulateFields()
    begin
        with MICAFlowBufferETASRD do begin
            // init record
            Init();
            ImportedRecordCount += 1;
            Validate("Flow Entry No.", MICAFlowEntry."Entry No.");
            "Entry No." := ImportedRecordCount;

            // mandatory
            "ASN No. Raw" := CopyStr(GetNodeValue(Param_ASNNoLbl, true), 1, MaxStrLen("ASN No. Raw"));

            // optional
            "SRD Raw" := CopyStr(GetNodeValue(Param_SRDLbl, true), 1, MaxStrLen("SRD Raw"));
            "ETA Raw" := CopyStr(GetNodeValue(Param_ETALbl, true), 1, MaxStrLen("ETA Raw"));

            // Technical fields
            "Date Time Creation" := MICAFlowEntry."Creation Date Time";
            "Tech. Component ID" := CopyStr(MICAFlowEntry."Component ID", 1, MaxStrLen("Tech. Component ID"));
            "Tech. Logical ID" := CopyStr(MICAFlowEntry."Logical ID", 1, MaxStrLen("Tech. Logical ID"));
            "Tech. Reference ID" := CopyStr(MICAFlowEntry."Reference ID", 1, MaxStrLen("Tech. Reference ID"));
            "Tech. Task ID" := CopyStr(MICAFlowEntry."Task ID", 1, MaxStrLen("Tech. Task ID"));
            Insert(true);
        end;
    end;

    local procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20])
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

    procedure SetInstrSource(FromInStream: InStream)
    begin
        InStream := FromInStream;
    end;

    procedure SetFlowEntry(var FromMICAFlowEntry: Record "MICA Flow Entry")
    begin
        MICAFlowEntry := FromMICAFlowEntry;
    end;

    procedure GetBuffer(var ToMICAFlowBufferETASRD: Record "MICA Flow Buffer ETA SRD")
    begin
        ToMICAFlowBufferETASRD := MICAFlowBufferETASRD;
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ImportedRecordCount);
    end;

    local procedure GetNodeValue(Param: Text[20]; Mandatory: Boolean): Text
    var
        xmlNodeInfo: XmlNode;
        XPath: Text;
        NodeValue: Text;
    begin
        XPath := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if XPath = '' then
            exit('');

        if not FromXmlDoc.SelectSingleNode(XPath, xmlNodeInfo) then begin
            GenerateInformation(Param, XPath, Mandatory, MissingNodeMsg);
            exit('');
        end;

        NodeValue := xmlNodeInfo.AsXmlElement().InnerText();
        if NodeValue = '' then
            GenerateInformation(Param, XPath, Mandatory, MissingNodeValueMsg);

        exit(NodeValue);
    end;

    local procedure GenerateInformation(Param: Text[20]; XPath: Text; Mandatory: Boolean; Info: Text)
    begin
        if Mandatory then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(Info, Param, XPath), '')
        else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(Info, Param, XPath), '');
    End;
}