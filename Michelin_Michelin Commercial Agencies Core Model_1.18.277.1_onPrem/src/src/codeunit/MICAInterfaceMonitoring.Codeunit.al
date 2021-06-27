codeunit 80860 "MICA Interface Monitoring"
{
    [TryFunction]
    procedure ListContainers(var TempMICAMMEBlobStorageContainer: Record "MICA MME BlobStorage Container" temporary; "Account Url": Text[100]; "SaS Token": Text[250])
    var
        //blobStorageAccount: Record "MICA MME BlobStorage Account";
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        xmlContent: Text;
        xmlDoc: XmlDocument;
        root: XmlElement;
        nodes: XmlNodeList;
        node: XmlNode;
        i: Integer;
        Url: text;
        HttpClientResponseDetailErr: Label 'HttpClient failed.\\HttpStatusCode = %1\ReasonPhrase = %2\IsBlockByEnvronnement = %3\\Get URL = %4';
        XmlContainerEmptyErr: label 'No container found on Blob Storage (%1).';
        XmlContainerXpathTxt: label '/*/Containers/Container/Name', locked = true;
        HttpClientGetLblUrlTxt: label '%1?comp=list&%2', locked = true;
        LastModifLbl: Label '/*/Containers/Container[%1]/Properties/Last-Modified', Comment = '%1', Locked = true;
        LeaseStatusLbl: Label '/*/Containers/Container[%1]/Properties/LeaseStatus', Comment = '%1', Locked = true;
        LeaseStateLbl: Label '/*/Containers/Container[%1]/Properties/LeaseState', Comment = '%1', Locked = true;
    begin
        MICAIntMonitoringSetup.get();
        MICAIntMonitoringSetup.SetupHttpClient(HttpClient);

        //GET https://<accountname>.blob.core.windows.net/?comp=list&<sastoken>
        Url := StrSubstNo(HttpClientGetLblUrlTxt, "Account Url", "SaS Token");
        HttpClient.Get(Url, HttpResponseMessage);
        if not HttpResponseMessage.IsSuccessStatusCode() then
            Error(HttpClientResponseDetailErr,
                HttpResponseMessage.HttpStatusCode(),
                HttpResponseMessage.ReasonPhrase(),
                HttpResponseMessage.IsBlockedByEnvironment(),
                Url);

        HttpResponseMessage.Content().ReadAs(xmlContent);
        XmlDocument.ReadFrom(xmlContent, xmlDoc);
        xmlDoc.GetRoot(root);
        root.WriteTo(xmlContent);

        if not root.SelectNodes(XmlContainerXpathTxt, nodes) then
            error(XmlContainerEmptyErr, XmlContainerXpathTxt);

        for i := 1 to nodes.Count() do begin
            nodes.Get(i, node);
            TempMICAMMEBlobStorageContainer.Init();
            TempMICAMMEBlobStorageContainer.Name := CopyStr(node.AsXmlElement().InnerText(), 1, 250);

            if root.SelectSingleNode(StrSubstNo(LastModifLbl, i), node) then
                TempMICAMMEBlobStorageContainer."Last Modified" := CopyStr(node.AsXmlElement().InnerText(), 1, 50);
            if root.SelectSingleNode(StrSubstNo(LeaseStatusLbl, i), node) then
                TempMICAMMEBlobStorageContainer."Lease Status" := CopyStr(node.AsXmlElement().InnerText(), 1, 50);
            if root.SelectSingleNode(StrSubstNo(LeaseStateLbl, i), node) then
                TempMICAMMEBlobStorageContainer."Lease State" := CopyStr(node.AsXmlElement().InnerText(), 1, 50);
            TempMICAMMEBlobStorageContainer.Insert();
        end;
    end;

    [TryFunction]
    procedure GetListOfBlob(MICAFlow: Record "MICA Flow"; MICAFlowEndPoint: Record "MICA Flow EndPoint"; var MICAMMEBlobStorageBlob: Record "MICA MME BlobStorage Blob" temporary)
    var
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        xmlContent: Text;
        xmlDoc: XmlDocument;
        root: XmlElement;
        nodes: XmlNodeList;
        node: XmlNode;
        i: Integer;
        len: Integer;
        Url: text;
        NoBlobFoundInfoErr: label 'No Blob found on URL %1.';
        BlobPrefUrl1Lbl: Label '%1/%2?restype=container&comp=list&%3', Comment = '%1%2%3', Locked = true;
        BlobPrefUrl2Lbl: Label '%1/%2?restype=container&comp=list&prefix=%3&%4', Comment = '%1%2%3%4', Locked = true;
        LastModifLbl: Label '/*/Blobs/Blob[%1]/Properties/Last-Modified', Comment = '%1', Locked = true;
        LeaseStatusLbl: Label '/*/Blobs/Blob[%1]/Properties/LeaseStatus', Comment = '%1', Locked = true;
        LeaseStateLbl: Label '/*/Blobs/Blob[%1]/Properties/LeaseState', Comment = '%1', Locked = true;
        CreationTimeLbl: Label '/*/Blobs/Blob[%1]/Properties/Creation-Time', Comment = '%1', Locked = true;
        BlobTypeLbl: Label '/*/Blobs/Blob[%1]/Properties/BlobType', Comment = '%1', Locked = true;
        ContentTypeLbl: Label '/*/Blobs/Blob[%1]/Properties/Content-Type', Comment = '%1', Locked = true;
        ContentLengthLbl: Label '/*/Blobs/Blob[%1]/Properties/Content-Length', Comment = '%1', Locked = true;

    begin
        //if not blobStorageAccount.FindFirst() then exit;
        //GET https://<accountname>.blob.core.windows.net/<container>?restype=container&comp=list&<sastoken>
        MICAIntMonitoringSetup.get();
        MICAIntMonitoringSetup.SetupHttpClient(HttpClient);

        if MICAFlow."Blob Prefix" = '' then
            url := StrSubstNo(BlobPrefUrl1Lbl,
                MICAFlowEndPoint.SubstituteParameters(MICAFlowEndPoint."Blob Storage"),
                MICAFlowEndPoint.SubstituteParameters(MICAFlow."Blob Container"),
                MICAFlowEndPoint."Blob SSAS Signature")
        else
            url := StrSubstNo(BlobPrefUrl2Lbl,
                MICAFlowEndPoint.SubstituteParameters(MICAFlowEndPoint."Blob Storage"),
                MICAFlowEndPoint.SubstituteParameters(MICAFlow."Blob Container"),
                MICAFlowEndPoint.SubstituteParameters(MICAFlow."Blob Prefix"),
                MICAFlowEndPoint."Blob SSAS Signature");

        HttpClient.Get(url, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(xmlContent);
        XmlDocument.ReadFrom(xmlContent, xmlDoc);
        xmlDoc.GetRoot(root);
        root.WriteTo(xmlContent);
        if root.SelectNodes('/Error', nodes) then
            if nodes.Count() > 0 then begin
                nodes.Get(1, node);
                if root.SelectSingleNode('/Error/Message', node) then
                    Error(node.AsXmlElement().InnerText());
            end;

        if not root.SelectNodes('/*/Blobs/Blob/Name', nodes) then
            error(NoBlobFoundInfoErr, url);

        for i := 1 to nodes.Count() do begin
            nodes.Get(i, node);
            MICAMMEBlobStorageBlob.Init();
            MICAMMEBlobStorageBlob.Container := CopyStr(MICAFlow."Blob Container", 1, 250);
            MICAMMEBlobStorageBlob.Name := CopyStr(node.AsXmlElement().InnerText(), 1, 250);

            if root.SelectSingleNode(StrSubstNo(LastModifLbl, i), node) then
                MICAMMEBlobStorageBlob."Last Modified" := CopyStr(node.AsXmlElement().InnerText(), 1, 50);
            if root.SelectSingleNode(StrSubstNo(LeaseStatusLbl, i), node) then
                MICAMMEBlobStorageBlob."Lease Status" := CopyStr(node.AsXmlElement().InnerText(), 1, 50);
            if root.SelectSingleNode(StrSubstNo(LeaseStateLbl, i), node) then
                MICAMMEBlobStorageBlob."Lease State" := CopyStr(node.AsXmlElement().InnerText(), 1, 50);
            if root.SelectSingleNode(StrSubstNo(CreationTimeLbl, i), node) then
                MICAMMEBlobStorageBlob."Creation Time" := CopyStr(node.AsXmlElement().InnerText(), 1, 50);
            if root.SelectSingleNode(StrSubstNo(BlobTypeLbl, i), node) then
                MICAMMEBlobStorageBlob."Blob Type" := CopyStr(node.AsXmlElement().InnerText(), 1, 50);
            if root.SelectSingleNode(StrSubstNo(ContentTypeLbl, i), node) then
                MICAMMEBlobStorageBlob."Content Type" := CopyStr(node.AsXmlElement().InnerText(), 1, 50);
            if root.SelectSingleNode(StrSubstNo(ContentLengthLbl, i), node) then
                if Evaluate(len, node.AsXmlElement().InnerText()) then
                    MICAMMEBlobStorageBlob."Content Length" := len;

            if strpos(MICAMMEBlobStorageBlob.name, MICAIntMonitoringSetup."Discard Blob Name Containing") = 0 then
                MICAMMEBlobStorageBlob.Insert();
        end;

    end;

    procedure GetBlob("Account Url": Text; "SaS Token": Text; containerName: Text; blobName: Text; var InStream: InStream): Boolean
    var
        //blobStorageAccount: Record "MICA MME BlobStorage Account";
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        Url: text;
        UrlLbl: Label '%1/%2/%3?%4', Comment = '%1%2%3%4', Locked = true;
    begin
        //if not blobStorageAccount.FindFirst() then exit(false);
        //GET https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        MICAIntMonitoringSetup.get();
        MICAIntMonitoringSetup.SetupHttpClient(HttpClient);
        Url := StrSubstNo(UrlLbl, "Account Url", containerName, blobName, "SaS Token");
        HttpClient.Get(Url, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(InStream);
        exit(true);
    end;

    procedure PutBlob("Account Url": Text[100]; "SaS Token": Text[250]; containerName: Text; blobName: Text; text: Text): Boolean
    var
        //memoryStream: Codeunit "MemoryStream Wrapper";
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        Url: text;
        MemoryStreamHeaderLbl: Label '%1', Comment = '%1', Locked = true;
        UrlLbl: Label '%1/%2/%3?%4', Comment = '%1%2%3%4', Locked = true;
    //len: Integer;
    begin
        //if not blobStorageAccount.FindFirst() then exit;

        // Write the test into HTTP Content and change the needed Header Information 
        MICAIntMonitoringSetup.get();
        MICAIntMonitoringSetup.SetupHttpClient(HttpClient);

        HttpContent.WriteFrom(text);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/octet-stream');
        HttpHeaders.Add('Content-Length', StrSubstNo(MemoryStreamHeaderLbl, StrLen(text)));
        HttpHeaders.Add('x-ms-blob-type', 'BlockBlob');

        //PUT https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        Url := StrSubstNo(UrlLbl, "Account Url", containerName, blobName, "SaS Token");
        HttpClient.Put(Url, HttpContent, HttpResponseMessage);
        exit(true);
    end;

    procedure PutBlob("Account Url": Text[100]; "SaS Token": Text[250]; containerName: Text; blobName: Text; var InStream: InStream): Boolean
    var
        //blobStorageAccount: Record "MICA MME BlobStorage Account";
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        MemoryStreamWrapper: Codeunit "MemoryStream Wrapper";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        len: Integer;
        StorageAccountHeaderLbl: Label '%1', Comment = '%1', Locked = true;
        ClientLbl: Label '%1/%2/%3?%4', Comment = '%1%2%3%4', Locked = true;
    begin
        MICAIntMonitoringSetup.get();
        MICAIntMonitoringSetup.SetupHttpClient(HttpClient);

        //if not blobStorageAccount.FindFirst() then exit;
        HttpClient.SetBaseAddress("Account Url");

        // Load the memory stream and get the size
        MemoryStreamWrapper.Create(0);
        MemoryStreamWrapper.ReadFrom(InStream);
        len := MemoryStreamWrapper.Length();
        MemoryStreamWrapper.SetPosition(0);
        MemoryStreamWrapper.GetInStream(InStream);

        // Write the Stream into HTTP Content and change the needed Header Information 
        HttpContent.WriteFrom(InStream);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/octet-stream');
        HttpHeaders.Add('Content-Length', StrSubstNo(StorageAccountHeaderLbl, len));
        HttpHeaders.Add('x-ms-blob-type', 'BlockBlob');

        //PUT https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        HttpClient.Put(StrSubstNo(ClientLbl, "Account Url", containerName, blobName, "SaS Token"), HttpContent, HttpResponseMessage);
        exit(true);
    end;

    procedure GetBlobUrl("Account Url": Text[100]; "SaS Token": Text[250]; containerName: Text; blobName: Text): Text
    var
        GetBlobUrlLbl: Label '%1/%2/%3?%4', Comment = '%1%2%3%4', Locked = true;
    begin
        exit(StrSubstNo(GetBlobUrlLbl, "Account Url", containerName, blobName, "SaS Token"));
    end;

    procedure DeleteBlob("Account Url": Text[100]; "SaS Token": Text[250]; containerName: Text; blobName: Text): Boolean
    var
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        ClientLbl: Label '%1/%2/%3?%4', Comment = '%1%2%3%4', Locked = true;
    begin
        MICAIntMonitoringSetup.get();
        MICAIntMonitoringSetup.SetupHttpClient(HttpClient);
        HttpClient.Delete(StrSubstNo(ClientLbl, "Account Url", containerName, blobName, "SaS Token"), HttpResponseMessage);
        //response.Content().ReadAs(stream);
        exit(true);
    end;

    [TryFunction]
    procedure SendFileUsingSmtp(var FromInstream: InStream; FromFlow: Record "MICA Flow"; FromFlowEntry: Record "MICA Flow Entry")
    var
        CompanyInformation: Record "Company Information";
        SMTPMailSetup: Record "SMTP Mail Setup";
        FlowSetup: Record "MICA Flow Setup";
        SMTPMail: Codeunit "SMTP Mail";
        ToRecipientList: List of [Text];
        FlowParamErr: label '%1 is missing !';
        EmailSubject: Text;
        EmailBody: Text;
        EmailSubjectParamCodeLbl: label 'EMAILSUBJECT', Locked = true;
        EmailBodyParamCodeLbl: label 'EMAILBODY*', Locked = true;
    begin
        CompanyInformation.get();
        ToRecipientList := FromFlow."EndPoint Recipients".Split(';');

        FlowSetup.SetRange(Flow, FromFlow.Code);
        // Initialize subject from flow parameters
        FlowSetup.SetRange("Parameter Code", EmailSubjectParamCodeLbl);
        if not FlowSetup.FindFirst() then
            error(FlowParamErr, EmailSubjectParamCodeLbl)
        else
            EmailSubject := StrSubstNo(FlowSetup."Text Value", FromFlow.Description, FromFlowEntry."Created Date Time");

        // Initialize body from flow parameters
        FlowSetup.SetRange("Parameter Code");
        FlowSetup.SetFilter("Parameter Code", EmailBodyParamCodeLbl);
        if FlowSetup.IsEmpty() then
            error(FlowParamErr, EmailSubjectParamCodeLbl)
        else
            if FlowSetup.FindSet() then
                repeat
                    EmailBody += StrSubstNo(FlowSetup."Text Value", FromFlowEntry.Description) + '<br>';
                until FlowSetup.Next() = 0;

        SMTPMailSetup.get();
        if SMTPMailSetup."MICA Default From Email Addr." = '' then
            SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", ToRecipientList, EmailSubject, EmailBody)
        else
            SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."MICA Default From Email Addr.", ToRecipientList, EmailSubject, EmailBody);
        SMTPMail.AddAttachmentStream(FromInstream, FromFlowEntry.Description);
        SMTPMail.Send();
    end;

    procedure SendMessageToQueue(
            var InStream: InStream;
            MICAFlow: Record "MICA Flow";
            MICAFlowEndPoint: Record "MICA Flow EndPoint";
            var ErrorMsgID: Text;
            var ErrorMsg: Text;
            var ErrorExplanation: Text;
            var ErrorAction: Text): Boolean
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        txt: Text;
        PostErr: label 'Internal error: HHTPClient Post method error.';
        ResponseCode: Integer;
    begin
        MICAFlowEndPoint.SetupHttpClient(HttpClient);
        ClearErrorMQVariables(ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);
        PrepareRestAPICall(HttpClient.DefaultRequestHeaders(), MICAFlowEndPoint."MQ Login", MICAFlowEndPoint."MQ Password");

        HttpContent.WriteFrom(InStream);

        if not HttpClient.Post(
            MICAFlowEndPoint.SubstituteParameters(MICAFlowEndPoint."MQ URL") + MICAFlowEndPoint.SubstituteParameters(MICAFlow."MQ Sub URL"),
            HttpContent,
            HttpResponseMessage)
        then begin
            ErrorMsgID := 'Codeunit: MICA IBM MQ Connector';
            ErrorMsg := PostErr;
            exit(false);
        end;

        ResponseCode := HttpResponseMessage.HttpStatusCode();
        if (ResponseCode < 200) or (ResponseCode > 299) then begin
            HttpContent.Clear();
            HttpContent := HttpResponseMessage.Content();
            HttpContent.ReadAs(txt);
            GetErrorMQInfo(txt, ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);
        end;

        exit(HttpResponseMessage.IsSuccessStatusCode());
    end;

    procedure GetMessageFromQueue(
        var TempBlob: Codeunit "Temp Blob";
        MICAFlow: Record "MICA Flow";
        MICAFlowEndPoint: Record "MICA Flow EndPoint";
        var ErrorMsgID: Text;
        var ErrorMsg: Text;
        var ErrorExplanation: Text;
        var ErrorAction: Text): Boolean
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        InStream: InStream;
        OutStream: OutStream;
        txt: Text;
        DeleteErr: label 'Internal error on HttpClient : %1';

    begin
        MICAFlowEndPoint.SetupHttpClient(HttpClient);
        ClearErrorMQVariables(ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);
        PrepareRestAPICall(HttpClient.DefaultRequestHeaders(), MICAFlowEndPoint."MQ Login", MICAFlowEndPoint."MQ Password");
        if MICAFlow."Delete After Receive" then begin
            if not HttpClient.Delete(
                MICAFlowEndPoint.SubstituteParameters(MICAFlowEndPoint."MQ URL") + MICAFlowEndPoint.SubstituteParameters(MICAFlow."MQ Sub URL"),
                HttpResponseMessage)
            then begin
                ErrorMsgID := 'Codeunit: MICA IBM MQ Connector';
                ErrorMsg := StrSubstNo(DeleteErr, GetLastErrorText());
                exit(false);
            end;
        end else
            if not HttpClient.Get(
                MICAFlowEndPoint.SubstituteParameters(MICAFlowEndPoint."MQ URL") + MICAFlowEndPoint.SubstituteParameters(MICAFlow."MQ Sub URL"),
                HttpResponseMessage)
            then begin
                ErrorMsgID := 'Codeunit: MICA IBM MQ Connector';
                ErrorMsg := StrSubstNo(DeleteErr, GetLastErrorText());
                exit(false);
            end;

        //Headers.Clear();
        //Headers := ResponseMessage.Headers;
        //Headers.GetValues('ibm-mq-md-persistence', txtArr);

        if not HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpContent := HttpResponseMessage.Content();
            HttpContent.ReadAs(txt);
            GetErrorMQInfo(txt, ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);
        end else begin
            HttpContent := HttpResponseMessage.Content();
            HttpResponseMessage.Content().ReadAs(InStream);
            Clear(TempBlob);
            TempBlob.CreateOutStream(OutStream);
            CopyStream(OutStream, InStream);
            if TempBlob.Length() = 0 then begin
                ErrorMsgID := 'EMPTYQUEUE';
                exit;
            end;
            exit(true);
        end;

    end;

    local procedure PrepareRestAPICall(Headers: HttpHeaders; User: Text; Password: Text)
    var
        Cd64TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        AuthText: text;
        Text64: Text;
        AuthLbl: Label '%1:%2', Comment = '%1%2', Locked = true;
        RestApiHeaderLbl: Label 'Basic %1', Comment = '%1', Locked = true;
        OutStream: OutStream;
        InStream: InStream;
    begin
        AuthText := StrSubstNo(AuthLbl, User, Password);
        Cd64TempBlob.CreateOutStream(OutStream, TextEncoding::Windows);
        OutStream.Write(AuthText);
        Cd64TempBlob.CreateInStream(InStream);
        InStream.Read(Text64);
        Headers.Add('Authorization', StrSubstNo(RestApiHeaderLbl, Base64Convert.ToBase64(Text64)));
        Headers.Add('ibm-mq-rest-csrf-token', '');
    end;

    local procedure GetErrorMQInfo(errorText: text; var ErrorMsgID: Text; var ErrorMsg: Text; var ErrorExplanation: Text; var ErrorAction: Text)
    var
        JObject: JsonObject;
        JToken: JsonToken;
        JToken2: JsonToken;
        jArray: JsonArray;
    begin
        if JObject.ReadFrom(errorText) then begin
            JObject.Get('error', JToken);
            jArray := JToken.AsArray();
            jArray.Get(0, JToken);
            if JToken.SelectToken('msgId', JToken2) then
                JToken2.WriteTo(ErrorMsgID);
            if JToken.SelectToken('message', JToken2) then
                JToken2.WriteTo(ErrorMsg);
            if JToken.SelectToken('explanation', JToken2) then
                JToken2.WriteTo(ErrorExplanation);
            if JToken.SelectToken('action', JToken2) then
                JToken2.WriteTo(ErrorAction);
        end else
            ErrorMsg := errorText;

    end;

    local procedure ClearErrorMQVariables(var ErrorMsgID: Text; var ErrorMsg: Text; var ErrorExplanation: Text; var ErrorAction: Text)
    begin
        ErrorMsgID := '';
        ErrorMsg := '';
        ErrorExplanation := '';
        ErrorAction := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"API Webhook Notification Mgt.", 'OnGetDetailedLoggingEnabled', '', false, false)]
    local procedure OnGetDetailedLoggingEnabledAPIWebhookNotificationMgtCodeunit(var Handled: Boolean; var Enabled: Boolean)
    var
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
    begin
        if MICAIntMonitoringSetup.Get() then begin
            Enabled := MICAIntMonitoringSetup."Enable API Detailed Log";
            Handled := true;
        end;
    end;
}