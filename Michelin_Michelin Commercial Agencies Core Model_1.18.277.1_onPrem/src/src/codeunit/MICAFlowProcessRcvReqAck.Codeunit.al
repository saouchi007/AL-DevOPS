codeunit 81241 "MICA Flow Process Rcv.Req.Ack"
{
    //INT-3PL-008
    TableNo = "MICA Flow Entry";

    var
        MICAFlowBuffReceiveReqAck2: Record "MICA FlowBuff Receive Req.Ack2";
        MICAFlowInformation: Record "MICA Flow Information";
        StartMsg: label 'Start processing data.';
        UnsupportedTypeErr: label 'Unsupported value type: %1.';
        IncorrectValueErr: label 'Incorrect value: %1.';
        WhsReceiptNotFoundErr: label 'Warehouse Receipt no. %1 not found.';
        MandatoryErr: Label 'You must specify %1.';
        PartialProcessingMsg: Label 'Flow Entry not processed due to Partial Processing not allowed.';

    trigger onRun()
    var
        MICAFlow: Record "MICA Flow";
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        BufferRecordRef: RecordRef;
        RecordsProcessed: Integer;
        RecordsRejected: Integer;
    begin
        MICAFlow.Get(Rec."Flow Code");
        with MICAFlowBuffReceiveReqAck2 do begin
            OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));
            SetRange("Flow Entry No.", Rec."Entry No.");
            if FindSet(true) then begin
                repeat
                    "Error" := false;
                    BufferRecordRef.GetTable(MICAFlowBuffReceiveReqAck2);
                    HandleRawField(BufferRecordRef, fieldNo("RAW REFERENCEID"), fieldNo("Receipt No."), FieldNo("Error"), Rec, true, "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW REFERENCEID"), fieldNo("Time Stamp"), FieldNo("Error"), Rec, true, "Entry No.");
                    BufferRecordRef.Modify();
                until Next() = 0;

                If Not MICAFlow."Allow Partial Processing" then begin
                    CALCFIELDS("Error Count");
                    If "Error Count" > 0 then begin
                        Rec.AddInformation(MICAFlowInformation."Info Type"::Information, PartialProcessingMsg, '');
                        COMMIT();
                        exit;
                    end;
                end;
                ProcessBuffer(Rec, RecordsProcessed, RecordsRejected);
            end;
            OpeningMICAFlowInformation.Update('', '');
        end;
    end;

    local procedure ProcessBuffer(MICAFlowEntry: Record "MICA Flow Entry"; var RecordsProcessed: Integer; var RecordsRejected: Integer)
    begin
        with MICAFlowBuffReceiveReqAck2 do begin
            FindFirst();
            repeat
                if "Error" or not ProcessRecord(MICAFlowEntry, MICAFlowBuffReceiveReqAck2, RecordsProcessed) then
                    RecordsRejected += 1;
            until Next() = 0;
        end;
    end;

    local procedure ProcessRecord(MICAFlowEntry: Record "MICA Flow Entry"; var LocMICAFlowBuffReceiveReqAck2: Record "MICA FlowBuff Receive Req.Ack2"; var RecordsProcessed: Integer): Boolean
    var
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        MICAFlow: Record "MICA Flow";
        MICAFlowRecord: Record "MICA Flow Record";
    begin
        if not WarehouseReceiptHeader.Get(LocMICAFlowBuffReceiveReqAck2."Receipt No.") then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, LocMICAFlowBuffReceiveReqAck2."Entry No.", StrSubstNo(WhsReceiptNotFoundErr, LocMICAFlowBuffReceiveReqAck2."Receipt No."), '');
            exit(false);
        end;

        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", WarehouseReceiptHeader.RecordId(), 3); //" ",Created,Received,Loaded,Processed,PostProcessed;
        LocMICAFlowBuffReceiveReqAck2.VALIDATE("Linked Record ID", WarehouseReceiptHeader.RecordId());
        LocMICAFlowBuffReceiveReqAck2.Modify();

        WarehouseReceiptHeader.Get(LocMICAFlowBuffReceiveReqAck2."Receipt No.");
        WarehouseReceiptHeader.Validate("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No.");
        WarehouseReceiptHeader.Modify();

        MICAFlow.SetAckConfirm(MICAFlowEntry, true);
        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", WarehouseReceiptHeader.RecordId(), 4);
        RecordsProcessed += 1;
        exit(true);
    end;

    local procedure HandleRawField(var RecordRef: RecordRef; RawFieldNo: Integer; FieldNo: Integer; ErrorFieldNo: Integer; MICAFlowEntry: Record "MICA Flow Entry"; Mandatory: Boolean; BufferEntryNo: Integer): Boolean
    var
        RecordField: Record Field;
        RawFieldRef: FieldRef;
        FieldRef: FieldRef;
        ErrorFieldRef: FieldRef;
        DateTimeVal: DateTime;
        CodeVal: Code[20];
        EvalError: Boolean;
    begin
        RecordField.Get(RecordRef.RecordId().TableNo(), RawFieldNo);
        RawFieldRef := RecordRef.Field(RecordField."No.");
        RecordField.Get(RecordRef.RecordId().TableNo(), FieldNo);
        FieldRef := RecordRef.Field(RecordField."No.");
        RecordField.Get(RecordRef.RecordId().TableNo(), ErrorFieldNo);
        ErrorFieldRef := RecordRef.Field(RecordField."No.");

        if format(RawFieldRef) = '' then begin
            if Mandatory then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, BufferEntryNo, StrSubstNo(MandatoryErr, CopyStr(RawFieldRef.Caption(), 1, 50)), '');
                ErrorFieldRef.Value(true);
            end
        end else begin
            case format(FieldRef.Type()) of
                'DateTime':
                    if GetDateTime(RawFieldRef.Value(), DateTimeVal) then
                        FieldRef.Value(DateTimeVal)
                    else
                        EvalError := true;
                'Code':
                    if GetCode(RawFieldRef.Value(), CodeVal) then
                        FieldRef.Value(CodeVal)
                    else
                        EvalError := true
                else
                    Error(UnsupportedTypeErr, format(FieldRef.Type()));
            end;
            if EvalError then begin
                MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, BufferEntryNo, CopyStr(FieldRef.Caption(), 1, 250),
                                    StrSubstNo(IncorrectValueErr, RawFieldRef.Value()));
                ErrorFieldRef.Value(true);
            end;
        end;
        exit(EvalError);
    end;

    [TryFunction]
    local procedure GetDateTime(txt: Text; var dt: DateTime)
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
        d: Date;
        t: Time;
    begin
        txt := CopyStr(txt, StrPos(txt, '_') + 1);
        Evaluate(Year, CopyStr(txt, 1, 4));
        Evaluate(Month, CopyStr(txt, 5, 2));
        Evaluate(Day, CopyStr(txt, 7, 2));
        d := DMY2Date(Day, Month, Year);
        Evaluate(t, CopyStr(txt, 9));
        dt := CreateDateTime(d, t);
    end;

    [TryFunction]
    local procedure GetCode(txt: Text; var CodeVal: Code[20])
    begin
        txt := CopyStr(txt, 1, StrPos(txt, '_') - 1);
        CodeVal := CopyStr(txt, 1, 20);
    end;
}