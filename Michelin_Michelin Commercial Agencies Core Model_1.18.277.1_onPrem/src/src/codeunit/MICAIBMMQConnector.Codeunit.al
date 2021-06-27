codeunit 81000 "MICA IBM MQ Connector"
{
    trigger OnRun()
    var
        TempBlob: Codeunit "Temp Blob";
        ResponseCode: Integer;
        ErrorMsgID: Text;
        ErrorMsg: Text;
        ErrorExplanation: Text;
        ErrorAction: Text;
        OutStream: outStream;
    begin
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText('Hello Word 21. ' + format(CurrentDateTime()));

        SendMessageToQueue(TempBlob, 'https://web-qm1-5953.qm.eu-gb.mq.appdomain.cloud/ibmmq/rest/v1/', 'DEV.QUEUE.1', 'QM1', 'dalius', 'ROVK11Z5b61PMtpb0C35-8As90OfUvPTQKOsFnxJhMrN',
                           ResponseCode, ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);

        GetMessageFromQueue(TempBlob, 'https://web-qm1-5953.qm.eu-gb.mq.appdomain.cloud/ibmmq/rest/v1/', 'DEV.QUEUE.1', 'QM1', 'dalius', 'ROVK11Z5b61PMtpb0C35-8As90OfUvPTQKOsFnxJhMrN',
                            ResponseCode, ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);
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

    procedure GetMessageFromQueue(var TempBlob: Codeunit "Temp Blob"; apiBase: Text; queue: Text; Manager: Text; User: Text; Password: Text; var ResponseCode: Integer;
                                  var ErrorMsgID: Text; var ErrorMsg: Text; var ErrorExplanation: Text; var ErrorAction: Text): Boolean
    var
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        OutStream: OutStream;
        txt: Text;
        DeleteErr: label 'Internal error. HHTPClient Delete method error.';

    begin
        MICAIntMonitoringSetup.get();
        MICAIntMonitoringSetup.SetupHttpClient(HttpClient);

        ClearErrorVariables(ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);
        PrepareRestAPICall(HttpClient.DefaultRequestHeaders(), User, Password);
        if not HttpClient.Delete(apiBase + 'messaging/qmgr/' + Manager + '/queue/' + queue + '/message', HttpResponseMessage) then begin
            ErrorMsgID := 'Codeunit: MICA IBM MQ Connector';
            ErrorMsg := DeleteErr;
            exit(false);
        end;

        //Headers.Clear();
        //Headers := ResponseMessage.Headers;
        //Headers.GetValues('ibm-mq-md-persistence', txtArr);

        ResponseCode := HttpResponseMessage.HttpStatusCode();
        if (ResponseCode < 200) or (ResponseCode > 299) then begin
            HttpContent := HttpResponseMessage.Content();
            HttpContent.ReadAs(txt);
            GetErrorInfo(txt, ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);
        end else begin
            HttpContent := HttpResponseMessage.Content();
            HttpContent.ReadAs(txt);
            Clear(TempBlob);
            TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
            OutStream.Write(txt);
        end;
        exit(HttpResponseMessage.IsSuccessStatusCode());
    end;

    procedure SendMessageToQueue(TempBlob: Codeunit "Temp Blob"; apiBase: Text; queue: Text; Manager: Text; User: Text; Password: Text; var ResponseCode: Integer;
                                var ErrorMsgID: Text; var ErrorMsg: Text; var ErrorExplanation: Text; var ErrorAction: Text): Boolean
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        InStream: InStream;
        txt: Text;
        PostErr: label 'Internal error: HHTPClient Post method error.';
    begin
        ClearErrorVariables(ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);
        PrepareRestAPICall(HttpClient.DefaultRequestHeaders(), User, Password);

        TempBlob.CreateInStream(InStream);
        InStream.Read(txt);
        HttpContent.WriteFrom(txt);

        if not HttpClient.Post(apiBase + 'messaging/qmgr/' + Manager + '/queue/' + queue + '/message', HttpContent, HttpResponseMessage) then begin
            ErrorMsgID := 'Codeunit: MICA IBM MQ Connector';
            ErrorMsg := PostErr;
            exit(false);
        end;

        ResponseCode := HttpResponseMessage.HttpStatusCode();
        if (ResponseCode < 200) or (ResponseCode > 299) then begin
            HttpContent.Clear();
            HttpContent := HttpResponseMessage.Content();
            HttpContent.ReadAs(txt);
            GetErrorInfo(txt, ErrorMsgID, ErrorMsg, ErrorExplanation, ErrorAction);
        end;

        exit(HttpResponseMessage.IsSuccessStatusCode());
    end;

    local procedure GetErrorInfo(errorText: text; var ErrorMsgID: Text; var ErrorMsg: Text; var ErrorExplanation: Text; var ErrorAction: Text)
    var
        JObject: JsonObject;
        JToken: JsonToken;
        JToken2: JsonToken;
        jArray: JsonArray;
    begin
        JObject.ReadFrom(errorText);
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
    end;

    local procedure ClearErrorVariables(var ErrorMsgID: Text; var ErrorMsg: Text; var ErrorExplanation: Text; var ErrorAction: Text)
    begin
        ErrorMsgID := '';
        ErrorMsg := '';
        ErrorExplanation := '';
        ErrorAction := '';
    end;
}