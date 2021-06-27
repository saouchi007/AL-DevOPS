codeunit 81960 "MICA Flow Send Received Ack."
{
    //INT – DOO-005 RECEIVED

    //Uncomment modify

    TableNo = "MICA Flow";

    var
        WarehouseSetup: Record "Warehouse Setup";
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlow: Record "MICA Flow";
        TempBlob: Codeunit "Temp Blob";
        DataPrepLbl: Label 'Data Prepapration has been Completed. ';
        ExportedFilesCountLbl: Label 'Exported %1 files.';
        ExportFailErr: Label 'Export Failed (%1)';
        UnableCreateFlowEntryErr: Label 'Unable to create Flow Entry';
        StartMsg: Label 'Start preparing data';
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingParamValueMsg: Label 'Missing value for parameter %1';
        Param_FileNameokLbl: Label 'FILENAME';
        PrVal_FileName: Text;

    trigger OnRun()
    var
        MICAReceivedAckGetHeaders: Query "MICA ReceivedAck GetHeaders";
        TotalFilesExported: Integer;
        FlowNotFoundErr: Label '%1.%2 missing';
        FileExported: Boolean;
    begin
        WarehouseSetup.Get();
        WarehouseSetup.TestField(WarehouseSetup."MICA Received Ack. Flow Code");
        if not MICAFlow.Get(WarehouseSetup."MICA Received Ack. Flow Code") then begin
            MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error,
                                StrSubstNo(FlowNotFoundErr, CopyStr(WarehouseSetup.TableCaption(), 1, 30),
                                                            CopyStr(WarehouseSetup.FieldCaption("MICA Received Ack. Flow Code"), 1, 30)), '');
            exit;
        end;

        CheckPrerequisitesAndRetrieveParameters(Param_FileNameokLbl, PrVal_FileName);
        if PrVal_FileName = '' then exit;
        MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, '');
        MICAReceivedAckGetHeaders.Open();
        while MICAReceivedAckGetHeaders.Read() do begin
            Clear(FileExported);
            if not MICAFlowEntry.Get(MICAFlow.CreateFlowEntry()) then
                MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error, UnableCreateFlowEntryErr, GetLastErrorText())
            else begin
                MICAFlowEntry.Description := StrSubstNo(PrVal_FileName, MICAFlowEntry."Entry No.", DelChr(format(CurrentDateTime(), 0, 9), '=', '.:-/\'));
                MICAFlowEntry.Modify(false);
                ExportASNNo(MICAReceivedAckGetHeaders.No_, MICAReceivedAckGetHeaders.MICA_ASN_No_, FileExported);
                if FileExported then
                    TotalFilesExported += 1;
            end;
        end;
        PostedWhseReceiptHeader.MarkedOnly(true);
        if PostedWhseReceiptHeader.FindSet(true) then
            repeat
                PostedWhseReceiptHeader."MICA Send Ack. Received" := true;
                PostedWhseReceiptHeader.Modify(false);
            until PostedWhseReceiptHeader.Next() = 0;

        MICAFlowInformation.Get(MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedFilesCountLbl, TotalFilesExported)));
        MICAFlowInformation.Update('', '');
    end;

    local procedure ExportASNNo(HeaderNo: Code[20]; ASNNo: Code[35]; var Success: Boolean): Integer
    var
        MICAReceivedAcknowledge: XmlPort "MICA Received Acknowledge";
        ExportedRecordCount: Integer;
        OutStream: OutStream;
        RecordsExportedLbl: Label '%1 Records exported for "No." = %2 and "ASN No." = %3. ';
    begin
        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStream);
        Clear(MICAReceivedAcknowledge);
        Clear(Success);
        MICAReceivedAcknowledge.SetParam(MICAFlowEntry, HeaderNo, ASNNo);
        MICAReceivedAcknowledge.SetDestination(OutStream);
        MICAReceivedAcknowledge.CheckAndRetrieveParameters();
        if MICAReceivedAcknowledge.Export() then begin
            ExportedRecordCount := MICAReceivedAcknowledge.GetRecordCount();
            if ExportedRecordCount > 0 then begin
                MICAFlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", PostedWhseReceiptHeader.RecordId(), MICAFlowEntry."Send Status"::Prepared);
                RemovedspaceForEmptyTags(TempBlob);
                MICAFlowEntry.PrepareToSend(TempBlob);

                PostedWhseReceiptHeader.Get(HeaderNo);
                PostedWhseReceiptHeader.Mark(true);
                Success := true;
            end;
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailErr, GetLastErrorText()), GetLastErrorCode());

        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(RecordsExportedLbl, ExportedRecordCount, HeaderNo, ASNNo)));
        MICAFlowInformation.Update('', '');
        exit(ExportedRecordCount);
    end;

    local procedure RemovedspaceForEmptyTags(var TempBlob: Codeunit "Temp Blob")
    var
        Content: Text;
        InStream: InStream;
        OutStream: OutStream;
    begin
        TempBlob.CreateInStream(InStream);
        InStream.Read(Content);
        Content := Content.Replace(' />' + MICAFlow.GetCRLF(), '/>' + MICAFlow.GetCRLF());
        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(Content);
    end;

    local procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20]; var ParamValue: Text)
    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(WarehouseSetup."MICA Received Ack. Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        ParamValue := ParamMICAFlowSetup.GetFlowTextParam(WarehouseSetup."MICA Received Ack. Flow Code", Param);
        if ParamValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamValueMsg, Param), '');
    end;

}