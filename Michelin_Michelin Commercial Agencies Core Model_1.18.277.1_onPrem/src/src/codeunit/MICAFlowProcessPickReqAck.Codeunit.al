codeunit 81221 "MICA Flow Process Pick Req.Ack"
{
    //INT-3PL-007: Pick request acknowledgement (in)
    TableNo = "MICA Flow Entry";

    var
        MICAFlowBufferPickReqAck2: Record "MICA Flow Buffer Pick Req.Ack2";
        MICAFlowInformation: Record "MICA Flow Information";
        StartMsg: label 'Start processing data';
        UnsupportedTypeErr: label 'Unsupported value type: %1.';
        IncorrectValueErr: label 'Incorrect value: %1';
        WhsShpNotFoundErr: label 'Warehouse Shipment not found.';
        MandatoryErr: Label 'You must specify %1';
        PartialProcessingMsg: Label 'Flow Entry not processed due to Partial Processing not allowed';

    trigger onRun()
    var
        MICAFlow: Record "MICA Flow";
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        BufferRecordRef: RecordRef;
        RecordsProcessed: Integer;
        RecordsRejected: Integer;
    begin
        MICAFlow.Get(Rec."Flow Code");
        with MICAFlowBufferPickReqAck2 do begin
            OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));
            SetRange("Flow Entry No.", Rec."Entry No.");
            if FindSet(true) then begin
                repeat
                    "Error" := false;
                    BufferRecordRef.GetTable(MICAFlowBufferPickReqAck2);
                    HandleRawField(BufferRecordRef, fieldNo("RAW REFERENCEID"), fieldNo("Shipment No."), FieldNo("Error"), Rec, true, "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW REFERENCEID"), fieldNo("Time Stamp"), FieldNo("Error"), Rec, true, "Entry No.");
                    BufferRecordRef.Modify();
                until Next() = 0;

                If Not MICAFlow."Allow Partial Processing" then begin
                    CALCFIELDS("Error Count");
                    If "Error Count" > 0 then begin
                        Rec.AddInformation(MICAFlowInformation."Info Type"::Information, PartialProcessingMsg, '');
                        COMMIT();
                        ERROR('');
                    end;
                end;
                ProcessBuffer(Rec, RecordsProcessed, RecordsRejected);
            end;
            OpeningMICAFlowInformation.Update('', '');
        end;
    end;

    local procedure ProcessBuffer(MICAFlowEntry: Record "MICA Flow Entry"; var RecordsProcessed: Integer; var RecordsRejected: Integer)
    begin
        with MICAFlowBufferPickReqAck2 do begin
            FindFirst();
            repeat
                if "Error" or not ProcessRecord(MICAFlowEntry, MICAFlowBufferPickReqAck2, RecordsProcessed) then
                    RecordsRejected += 1;
            until Next() = 0;
        end;
    end;

    local procedure ProcessRecord(MICAFlowEntry: Record "MICA Flow Entry"; var LocMICAFlowBufferPickReqAck2: Record "MICA Flow Buffer Pick Req.Ack2"; var RecordsProcessed: Integer): Boolean
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        MICAFlow: Record "MICA Flow";
        MICAFlowRecord: Record "MICA Flow Record";
    begin
        if not WarehouseShipmentHeader.Get(LocMICAFlowBufferPickReqAck2."Shipment No.") then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, LocMICAFlowBufferPickReqAck2."Entry No.", WhsShpNotFoundErr, LocMICAFlowBufferPickReqAck2."Shipment No.");
            exit(false);
        end;

        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", WarehouseShipmentHeader.RecordId(), 3); //" ",Created,Received,Loaded,Processed,PostProcessed;        
        LocMICAFlowBufferPickReqAck2.VALIDATE("Linked Record ID", WarehouseShipmentHeader.RecordId());
        LocMICAFlowBufferPickReqAck2.Modify();

        WarehouseShipmentHeader.Get(LocMICAFlowBufferPickReqAck2."Shipment No.");
        WarehouseShipmentHeader.Validate("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No.");
        WarehouseShipmentHeader.Modify();
        MICAFlow.SetAckConfirm(MICAFlowEntry, true);

        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", WarehouseShipmentHeader.RecordId(), 4); //" ",Created,Received,Loaded,Processed,PostProcessed;

        // WhsShptLine.SetRange("No.", Buffer."Shipment No.");
        // if not WhsShptLine.FindSet(true) then begin
        //     Buffer.AddInformation(FlowInfo."Info Type"::Error, WhsShpNotFoundErr, CopyStr(WhsShptLine.GetFilters(), 1, 250));
        //     exit(false);
        // end;
        // repeat
        //     WhsShptLine."MICA Receive Buffer Entry No." := Buffer."Entry No.";
        //     WhsShptLine."MICA Receive Flow Entry No." := FlowEntry."Entry No.";
        //     WhsShptLine.Modify(false);
        // until WhsShptLine.Next() = 0;

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
        //ShipmentNo_YYYY-MM-DD HH:MM:SS
        txt := CopyStr(txt, StrLen(txt) - 19 + 1);
        Evaluate(Year, CopyStr(txt, 1, 4));
        Evaluate(Month, CopyStr(txt, 6, 2));
        Evaluate(Day, CopyStr(txt, 9, 2));
        d := DMY2Date(Day, Month, Year);
        Evaluate(t, CopyStr(txt, 12));
        dt := CreateDateTime(d, t);
    end;

    [TryFunction]
    local procedure GetCode(txt: Text; var CodeVal: Code[20])
    begin
        //ShipmentNo_YYYY-MM-DD HH:MM:SS
        txt := CopyStr(txt, 1, StrLen(txt) - 19 - 1);
        CodeVal := CopyStr(txt, 1, 20);
    end;
}