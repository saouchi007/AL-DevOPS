codeunit 81211 "MICA Flow Process ReceivedConf"
{
    //INT-3PL-006: Received confirmation (in)
    TableNo = "MICA Flow Entry";

    var
        MICAFlowBuffReceivedConfirm2: Record "MICA FlowBuff ReceivedConfirm2";
        MICAFlowInformation: Record "MICA Flow Information";
        StartMsg: label 'Start processing data';
        UnsupportedTypeErr: label 'Unsupported value type: %1.';
        IncorrectValueErr: label 'Incorrect value: %1';
        WhsShipmentNotFoundErr: label '%1 not found.';
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
        with MICAFlowBuffReceivedConfirm2 do begin
            OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));
            SetRange("Flow Entry No.", Rec."Entry No.");
            if FindSet(true) then begin
                repeat
                    "Error" := false;
                    BufferRecordRef.GetTable(MICAFlowBuffReceivedConfirm2);

                    HandleRawField(BufferRecordRef, fieldNo("RAW Actual Delivery DateTime"), fieldNo("Actual Delivery DateTime"), FieldNo("Error"), Rec, true, Database::"MICA FlowBuff ReceivedConfirm2", "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW Document Line Number"), fieldNo("Document Line Number"), FieldNo("Error"), Rec, true, Database::"MICA FlowBuff ReceivedConfirm2", "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW Expected Quantity"), fieldNo("Expected Quantity"), FieldNo("Error"), Rec, true, Database::"MICA FlowBuff ReceivedConfirm2", "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW Received Quantity"), fieldNo("Received Quantity"), FieldNo("Error"), Rec, true, Database::"MICA FlowBuff ReceivedConfirm2", "Entry No.");

                    BufferRecordRef.Modify();
                until Next() = 0;

                If Not MICAFlow."Allow Partial Processing" then begin
                    CALCFIELDS("Error Count");
                    If "Error Count" > 0 then begin
                        Rec.AddInformation(MICAFlowInformation."Info Type"::Information, "Entry No.", PartialProcessingMsg, '');
                        COMMIT();
                        ERROR('');
                    end;
                end;
                ProcessBuffer(Rec, RecordsProcessed, RecordsRejected);

            end;
            //OverviewMessage(Rec, RecordsRead, RecordsProcessed, RecordsRejected, RunBegin);
            OpeningMICAFlowInformation.Update('', '');
        end;
    end;

    local procedure ProcessBuffer(MICAFlowEntry: Record "MICA Flow Entry"; var RecordsProcessed: Integer; var RecordsRejected: Integer)
    var
        HeaderProcessed: Boolean;
    begin
        with MICAFlowBuffReceivedConfirm2 do begin
            FindFirst();
            HeaderProcessed := ProcessHeader(MICAFlowEntry, MICAFlowBuffReceivedConfirm2);
            repeat
                if HeaderProcessed then begin
                    if "Error" or not ProcessRecord(MICAFlowEntry, MICAFlowBuffReceivedConfirm2, RecordsProcessed) then
                        RecordsRejected += 1;
                end else
                    RecordsRejected += 1;
            until Next() = 0;
        end;
    end;

    local procedure ProcessHeader(MICAFlowEntry: Record "MICA Flow Entry"; var LocMICAFlowBuffReceivedConfirm2: Record "MICA FlowBuff ReceivedConfirm2"): Boolean
    var
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseReceiptLine: record "Warehouse Receipt Line";
        MICAFlowRecord: Record "MICA Flow Record";
        FlowInfo1Lbl: Label '%1=%2', Comment = '%1%2', Locked = true;
    begin
        if not WarehouseReceiptHeader.Get(LocMICAFlowBuffReceivedConfirm2."Document ID") then begin
            MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(WhsShipmentNotFoundErr, WarehouseReceiptHeader.TableCaption()),
                                     CopyStr(StrSubstNo(FlowInfo1Lbl, WarehouseReceiptHeader.FieldCaption("No."), LocMICAFlowBuffReceivedConfirm2."Document ID"), 1, 250)));
            MICAFlowInformation."Flow Buffer Entry No." := LocMICAFlowBuffReceivedConfirm2."Entry No.";
            MICAFlowInformation.Modify(false);
            exit(false);
        end;
        WarehouseReceiptHeader.Validate("Posting Date", DT2Date(LocMICAFlowBuffReceivedConfirm2."Actual Delivery DateTime"));
        WarehouseReceiptHeader."MICA 3PL Update Status" := WarehouseReceiptHeader."MICA 3PL Update Status"::"Receipt Confimation";
        WarehouseReceiptHeader.Validate("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No.");
        WarehouseReceiptHeader.Modify();

        WarehouseReceiptLine.SetRange("No.", LocMICAFlowBuffReceivedConfirm2."Document ID");
        WarehouseReceiptLine.ModifyAll("Qty. to Receive", 0, true);

        LocMICAFlowBuffReceivedConfirm2.VALIDATE("Linked Record ID", WarehouseReceiptHeader.RecordId());
        LocMICAFlowBuffReceivedConfirm2.Modify();
        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", WarehouseReceiptHeader.RecordId(), 4); //" ",Created,Received,Loaded,Processed,PostProcessed;

        exit(true);
    end;

    local procedure ProcessRecord(MICAFlowEntry: Record "MICA Flow Entry"; var LocMICAFlowBuffReceivedConfirm2: Record "MICA FlowBuff ReceivedConfirm2"; var RecordsProcessed: Integer): Boolean
    var
        MICAFlowRecord: Record "MICA Flow Record";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        FlowInfo2Lbl: Label '%1=%2, %3=%4', Comment = '%1%2%3%4', Locked = true;
    begin
        if not WarehouseReceiptLine.Get(LocMICAFlowBuffReceivedConfirm2."Document ID", LocMICAFlowBuffReceivedConfirm2."Document Line Number") then begin
            MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(WhsShipmentNotFoundErr, WarehouseReceiptLine.TableCaption()),
                                     CopyStr(StrSubstNo(FlowInfo2Lbl,
                                     WarehouseReceiptLine.FieldCaption("No."), LocMICAFlowBuffReceivedConfirm2."Document ID", WarehouseReceiptLine.FieldCaption("Line No."), LocMICAFlowBuffReceivedConfirm2."Document Line Number"), 1, 250)));
            MICAFlowInformation."Flow Buffer Entry No." := LocMICAFlowBuffReceivedConfirm2."Entry No.";
            MICAFlowInformation.Modify(false);
            exit(false);
        end;
        WarehouseReceiptLine."MICA 3PL Qty. To Receive" := LocMICAFlowBuffReceivedConfirm2."Received Quantity";
        WarehouseReceiptLine.Validate("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No.");
        WarehouseReceiptLine.Modify(false);

        LocMICAFlowBuffReceivedConfirm2.VALIDATE("Linked Record ID", WarehouseReceiptLine.RecordId());
        LocMICAFlowBuffReceivedConfirm2.Modify();
        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", WarehouseReceiptLine.RecordId(), 4); //" ",Created,Received,Loaded,Processed,PostProcessed;

        RecordsProcessed += 1;
        exit(true);
    end;

    local procedure HandleRawField(var RecordRef: RecordRef; RawFieldNo: Integer; FieldNo: Integer; ErrorFieldNo: Integer; MICAFlowEntry: Record "MICA Flow Entry"; Mandatory: Boolean; TableID: Integer; BufferEntryNo: Integer): Boolean
    var
        RecordField: Record Field;
        RawFieldRef: FieldRef;
        FieldRef: FieldRef;
        ErrorFieldRef: FieldRef;
        DateTimeVal: DateTime;
        CodeVal: Code[20];
        IntegerVal: Integer;
        DecimalVal: Decimal;
        EvalError: Boolean;
    begin
        RecordField.Get(TableID, RawFieldNo);
        RawFieldRef := RecordRef.Field(RecordField."No.");
        RecordField.Get(TableID, FieldNo);
        FieldRef := RecordRef.Field(RecordField."No.");
        RecordField.Get(TableID, ErrorFieldNo);
        ErrorFieldRef := RecordRef.Field(RecordField."No.");

        if format(RawFieldRef) = '' then begin
            if Mandatory then begin
                MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MandatoryErr, CopyStr(RawFieldRef.Caption(), 1, 50)), ''));
                MICAFlowInformation."Flow Buffer Entry No." := BufferEntryNo;
                MICAFlowInformation.Modify(false);

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
                        EvalError := true;
                'Integer':
                    if GetInteger(RawFieldRef.Value(), IntegerVal) then
                        FieldRef.Value(IntegerVal)
                    else
                        EvalError := true;
                'Decimal':
                    if GetDecimal(RawFieldRef.Value(), DecimalVal) then
                        FieldRef.Value(DecimalVal)
                    else
                        EvalError := true

                else
                    Error(UnsupportedTypeErr, format(FieldRef.Type()));
            end;
            if EvalError then begin
                MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, CopyStr(FieldRef.Caption(), 1, 250),
                                    StrSubstNo(IncorrectValueErr, RawFieldRef.Value())));
                MICAFlowInformation."Flow Buffer Entry No." := BufferEntryNo;
                MICAFlowInformation.Modify(false);

                ErrorFieldRef.Value(true);
            end;
        end;
        exit(EvalError);
    end;

    [TryFunction]
    local procedure GetDateTime(txt: Text; var dt: DateTime)
    var
        TypeHelper: Codeunit "Type Helper";
        DTVariant: Variant;
    begin
        DTVariant := dt;
        TypeHelper.Evaluate(DTVariant, txt, '', '');
        dt := DTVariant;
    end;

    [TryFunction]
    local procedure GetCode(txt: Text; var CodeVal: Code[20])
    begin
        CodeVal := CopyStr(txt, 1, 20);
    end;

    [TryFunction]
    local procedure GetInteger(txt: Text; var IntegerVal: Integer)
    begin
        Evaluate(IntegerVal, Format(txt, 0, 9));
    end;

    [TryFunction]
    local procedure GetDecimal(txt: Text; var DecimalVal: Decimal)
    begin
        Evaluate(DecimalVal, Format(txt, 0, 9));
    end;
}