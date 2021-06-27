codeunit 80866 "MICA Saas Encryption Mgt"
{
    var
        MICAFlow: Record "MICA Flow";
        MICAFlowEndPoint: Record "MICA Flow EndPoint";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        TempBlob: Codeunit "Temp Blob";
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        OutStream: OutStream;
        InStream: InStream;

    procedure SaasEncryptBlob(var FromMICAFlowEntry: Record "MICA Flow Entry"): Integer
    var
        NewMICAFlowEntry: Record "MICA Flow Entry";
        MICAInterfaceMonitoring: Codeunit "MICA Interface Monitoring";
        NewEntryNo: Integer;
        ProcessedEntriesCount: Integer;
        PublicKeyInstream: InStream;
        EntryCreatedLbl: Label 'Entry %1 created, encrypted from Entry %2.', Comment = '%1 = New Entry No., %2 = Entry to encrypt No';
        PutEncryptionKeyErr: label 'Process cannot put file public key file %1 in the container %2', comment = '%1 = Public key filename ; %2 = BLOB Container name';
        MissingInterfaceParameterLbl: Label 'Interface monitoring parameter %1 missing in %2', comment = '%1 = parameter caption, %2 = interface monitoring setup table caption';
    begin
        // First check
        FromMICAFlowEntry.TestField("Use Encryption", false);

        // Init
        MICAFlow.Get(FromMICAFlowEntry."Flow Code");
        MICAFlow.TestField("Use SaaS Encryption", true);
        MICAFlowEndPoint.Get(MICAFlow."EndPoint Code");
        MICAIntMonitoringSetup.Get();

        if MICAIntMonitoringSetup."PGP Azure Function Key" = '' then begin
            FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingInterfaceParameterLbl, MICAIntMonitoringSetup.FieldCaption("PGP Azure Function Key"), MICAIntMonitoringSetup.TableCaption()), '');
            exit;
        end;
        if MICAIntMonitoringSetup."PGP Azure Function URI" = '' then begin
            FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingInterfaceParameterLbl, MICAIntMonitoringSetup.FieldCaption("PGP Azure Function URI"), MICAIntMonitoringSetup.TableCaption()), '');
            exit;
        end;
        if MICAIntMonitoringSetup."PGP File Extension" = '' then begin
            FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingInterfaceParameterLbl, MICAIntMonitoringSetup.FieldCaption("PGP File Extension"), MICAIntMonitoringSetup.TableCaption()), '');
            exit;
        end;

        if FromMICAFlowEntry.FindSet() then
            repeat
                if FromMICAFlowEntry."Use Encryption" <> false then
                    break;

                Clear(PublicKeyInstream);
                MICAFlow.CalcFields("Public Key Blob");
                MICAFlow."Public Key Blob".CreateInStream(PublicKeyInstream);
                if not MICAInterfaceMonitoring.PutBlob(
                    CopyStr(MICAFlowEndPoint.SubstituteParameters(MICAFlowEndPoint."Blob Storage"), 1, 100),
                    MICAFlowEndPoint."Blob SSAS Signature",
                    MICAFlowEndPoint.SubstituteParameters(MICAFlow."Blob Container"),
                    MICAFlow."Public Key File Name",
                    PublicKeyInstream
                ) then begin
                    FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(PutEncryptionKeyErr, MICAFlow."Public Key File Name", MICAFlow."Blob Container"), '');
                    exit;
                end;

                // Clean
                Clear(HttpClient);
                Clear(HttpRequestMessage);
                Clear(HttpContent);
                Clear(HttpResponseMessage);

                BuildRequestHeaders();
                BuildRequestBody(FromMICAFlowEntry);
                HttpRequestMessage.Method('POST');
                HttpRequestMessage.SetRequestUri(MICAIntMonitoringSetup."PGP Azure Function URI");
                HttpRequestMessage.Content(HttpContent);
                HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

                if HttpResponseMessage.IsSuccessStatusCode then begin
                    Clear(OutStream);
                    Clear(InStream);

                    NewEntryNo := MICAFlow.CreateFlowEntry();
                    NewMICAFlowEntry.Get(NewEntryNo);
                    NewMICAFlowEntry.Validate(Description, FromMICAFlowEntry.Description + MICAIntMonitoringSetup."PGP File Extension");
                    NewMICAFlowEntry.Validate("Use Encryption", true);
                    NewMICAFlowEntry.Validate("Source Entry No.", FromMICAFlowEntry."Entry No.");
                    NewMICAFlowEntry."Copied from Entry No." := FromMICAFlowEntry."Entry No.";
                    NewMICAFlowEntry.CalcFields(Blob);
                    NewMICAFlowEntry.Blob.CreateOutStream(OutStream);

                    HttpResponseMessage.Content.ReadAs(InStream);
                    CopyStream(OutStream, InStream);
                    NewMICAFlowEntry.Validate(Blob);

                    NewMICAFlowEntry.Validate("Send Status", NewMICAFlowEntry."Send Status"::Prepared);
                    NewMICAFlowEntry.Modify(true);
                    NewMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(EntryCreatedLbl, NewEntryNo, FromMICAFlowEntry."Entry No."), '');
                    ProcessedEntriesCount += 1;
                end else
                    FromMICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, HttpResponseMessage.ReasonPhrase(), '');

                MICAInterfaceMonitoring.DeleteBlob(
                    CopyStr(MICAFlowEndPoint.SubstituteParameters(MICAFlowEndPoint."Blob Storage"), 1, 100),
                    MICAFlowEndPoint."Blob SSAS Signature",
                    MICAFlowEndPoint.SubstituteParameters(MICAFlow."Blob Container"),
                    MICAFlow."Public Key File Name"
                );
            until FromMICAFlowEntry.Next() = 0;
        exit(ProcessedEntriesCount);
    end;

    //#region RequestBuild
    local procedure BuildRequestHeaders()
    var
        PublicKeyBlobURI: Text;
        PublicKeyBlobURISubLbl: Label '%1/%2/%3?%4', Comment = '%1%2%3%4';
    begin
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Clear();
        PublicKeyBlobURI := StrSubstNo(PublicKeyBlobURISubLbl, MICAFlowEndPoint."Blob Storage", MICAFlow."Blob Container", MICAFlow."Public Key File Name", MICAFlowEndPoint."Blob SSAS Signature");
        HttpHeaders.Add('x-functions-key', MICAIntMonitoringSetup."PGP Azure Function Key");
        HttpHeaders.Add('publickeyblobURI', PublicKeyBlobURI);
    end;

    local procedure BuildRequestBody(FromMICAFlowEntry: Record "MICA Flow Entry")
    begin
        Clear(InStream);
        TempBlob.FromRecord(FromMICAFlowEntry, FromMICAFlowEntry.FieldNo(Blob));
        TempBlob.CreateInStream(InStream);
        HttpContent.WriteFrom(InStream);
    end;

    //#endregion RequestBuild 
}