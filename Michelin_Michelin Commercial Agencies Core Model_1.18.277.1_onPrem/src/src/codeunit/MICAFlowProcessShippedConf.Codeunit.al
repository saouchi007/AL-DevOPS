codeunit 81191 "MICA Flow Process Shipped Conf"
{
    //INT-3PL-005: Shipped confirmation (in)

    TableNo = "MICA Flow Entry";

    var
        MICAFlowBuffShippedConfirm2: Record "MICA FlowBuff Shipped Confirm2";
        MICAFlowInformation: Record "MICA Flow Information";
        UserSetupManagement: Codeunit "User Setup Management";
        SetupRecordID: RecordId;
        StartMsg: label 'Start processing data';
        UnsupportedTypeErr: label 'Unsupported value type: %1.';
        IncorrectValueErr: label 'Incorrect value: %1';
        WhsShipmentNotFoundErr: label '%1 not found.';
        MandatoryErr: Label 'You must specify %1.';
        PartialProcessingMsg: Label 'Flow Entry not processed due to Partial Processing not allowed.';
        PostingDateErr: Label 'Posting date %1 is not allowed for user %2.';

    trigger onRun()
    var
        MICAFlow: Record "MICA Flow";
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        BufferRecordRef: RecordRef;
        PostingDateFieldRef: FieldRef;
        RecordsProcessed: Integer;
        RecordsRejected: Integer;
        PostingDate: Date;
    begin
        MICAFlow.Get(rec."Flow Code");
        with MICAFlowBuffShippedConfirm2 do begin
            OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));
            SetRange("Flow Entry No.", Rec."Entry No.");
            if FindSet(true) then begin
                repeat
                    "Error" := false;
                    BufferRecordRef.GetTable(MICAFlowBuffShippedConfirm2);
                    PostingDateFieldRef := BufferRecordRef.Field(fieldNo("Actual Ship DateTime"));

                    HandleRawField(BufferRecordRef, fieldNo("RAW Actual Ship DateTime"), fieldNo("Actual Ship DateTime"), FieldNo("Error"), Rec, true, Database::"MICA FlowBuff Shipped Confirm2", "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW Document Line Number"), fieldNo("Document Line Number"), FieldNo("Error"), Rec, true, Database::"MICA FlowBuff Shipped Confirm2", "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW Planned Ship Quantity"), fieldNo("Planned Ship Quantity"), FieldNo("Error"), Rec, true, Database::"MICA FlowBuff Shipped Confirm2", "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW Shipped Quantity"), fieldNo("Shipped Quantity"), FieldNo("Error"), Rec, true, Database::"MICA FlowBuff Shipped Confirm2", "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW DOT Value"), fieldNo("DOT Value"), FieldNo("Error"), Rec, false, Database::"MICA FlowBuff Shipped Confirm2", "Entry No.");
                    HandleRawField(BufferRecordRef, fieldNo("RAW Country Of Origin"), fieldNo("Country Of Origin"), FieldNo("Error"), Rec, false, Database::"MICA FlowBuff Shipped Confirm2", "Entry No.");
                    BufferRecordRef.Modify();
                    PostingDate := DT2Date(PostingDateFieldRef.Value());
                    if not UserSetupManagement.IsPostingDateValidWithSetup(PostingDate, SetupRecordID) then begin
                        MICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Error, "Entry No.", StrSubstNo(PostingDateErr, PostingDate, UserId()), ''));
                        MICAFlowInformation."Flow Buffer Entry No." := "Entry No.";
                        MICAFlowInformation.Modify(false);
                    end;
                until Next() = 0;

                If Not MICAFlow."Allow Partial Processing" then begin
                    CALCFIELDS("Error Count");
                    If "Error Count" > 0 then begin
                        Rec.AddInformation(MICAFlowInformation."Info Type"::Error, MICAFlowBuffShippedConfirm2."Entry No.", PartialProcessingMsg, '');
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
    var
        HeaderProcessed: Boolean;
    begin
        with MICAFlowBuffShippedConfirm2 do begin
            FindFirst();
            HeaderProcessed := ProcessHeader(MICAFlowEntry, MICAFlowBuffShippedConfirm2);
            repeat
                if HeaderProcessed then begin
                    if "Error" or not ProcessRecord(MICAFlowEntry, MICAFlowBuffShippedConfirm2, RecordsProcessed) then
                        RecordsRejected += 1;
                end else
                    RecordsRejected += 1;
            until Next() = 0;
        end;
    end;

    local procedure ProcessHeader(MICAFlowEntry: Record "MICA Flow Entry"; var LocMICAFlowBuffShippedConfirm2: Record "MICA FlowBuff Shipped Confirm2"): Boolean
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        MICAFlowRecord: Record "MICA Flow Record";
        FlowInfo1Lbl: Label '%1=%2', Comment = '%1%2', Locked = true;
    begin
        if not WarehouseShipmentHeader.Get(LocMICAFlowBuffShippedConfirm2."Document ID") then begin
            MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(WhsShipmentNotFoundErr, WarehouseShipmentHeader.TableCaption()),
                                     CopyStr(StrSubstNo(FlowInfo1Lbl, WarehouseShipmentHeader.FieldCaption("No."), LocMICAFlowBuffShippedConfirm2."Document ID"), 1, 250)));
            MICAFlowInformation."Flow Buffer Entry No." := LocMICAFlowBuffShippedConfirm2."Entry No.";
            MICAFlowInformation.Modify(false);
            exit(false);
        end;

        WarehouseShipmentHeader.Validate("Posting Date", DT2Date(LocMICAFlowBuffShippedConfirm2."Actual Ship DateTime"));
        WarehouseShipmentHeader."MICA 3PL Update Status" := WarehouseShipmentHeader."MICA 3PL Update Status"::"Shipped Confimation";
        WarehouseShipmentHeader.Validate("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No.");
        WarehouseShipmentHeader."MICA Truck Driver Info" := LocMICAFlowBuffShippedConfirm2."Driver Info";
        WarehouseShipmentHeader."MICA Truck License Plate" := LocMICAFlowBuffShippedConfirm2."License Plate";
        WarehouseShipmentHeader.Modify();

        WarehouseShipmentLine.SetRange("No.", LocMICAFlowBuffShippedConfirm2."Document ID");
        WarehouseShipmentLine.ModifyAll("Qty. to Ship", 0, true);

        LocMICAFlowBuffShippedConfirm2.VALIDATE("Linked Record ID", WarehouseShipmentHeader.RecordId());
        LocMICAFlowBuffShippedConfirm2.Modify();
        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", WarehouseShipmentHeader.RecordId(), 4); //" ",Created,Received,Loaded,Processed,PostProcessed;
        exit(true);
    end;

    local procedure ProcessRecord(MICAFlowEntry: Record "MICA Flow Entry"; var LocMICAFlowBuffShippedConfirm2: Record "MICA FlowBuff Shipped Confirm2"; var RecordsProcessed: Integer): Boolean
    var
        MICAFlowRecord: Record "MICA Flow Record";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        FlowInfo2Lbl: Label '%1=%2, %3=%4', Comment = '%1%2%3%4', Locked = true;
    begin
        if not WarehouseShipmentLine.Get(LocMICAFlowBuffShippedConfirm2."Document ID", LocMICAFlowBuffShippedConfirm2."Document Line Number") then begin
            MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(WhsShipmentNotFoundErr, WarehouseShipmentLine.TableCaption()),
                                     CopyStr(StrSubstNo(FlowInfo2Lbl,
                                     WarehouseShipmentLine.FieldCaption("No."), LocMICAFlowBuffShippedConfirm2."Document ID", WarehouseShipmentLine.FieldCaption("Line No."), LocMICAFlowBuffShippedConfirm2."Document Line Number"), 1, 250)));
            MICAFlowInformation."Flow Buffer Entry No." := LocMICAFlowBuffShippedConfirm2."Entry No.";
            MICAFlowInformation.Modify(false);
            exit(false);
        end;
        WarehouseShipmentLine."MICA 3PL Qty. To Ship" := LocMICAFlowBuffShippedConfirm2."Shipped Quantity";
        WarehouseShipmentLine.Validate("MICA Rcv. Last Flow Entry No.", MICAFlowEntry."Entry No.");
        WarehouseShipmentLine."MICA 3PL Country Of Origin" := LocMICAFlowBuffShippedConfirm2."Country Of Origin";
        WarehouseShipmentLine."MICA 3PL DOT Value" := LocMICAFlowBuffShippedConfirm2."DOT Value";
        WarehouseShipmentLine.Validate("MICA 3PL DOT Value");
        WarehouseShipmentLine.Modify(false);

        LocMICAFlowBuffShippedConfirm2.VALIDATE("Linked Record ID", WarehouseShipmentLine.RecordId());
        LocMICAFlowBuffShippedConfirm2.Modify();
        MICAFlowRecord.UpdateReceiveRecord(MICAFlowEntry."Entry No.", WarehouseShipmentLine.RecordId(), 4); //" ",Created,Received,Loaded,Processed,PostProcessed;

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

    [EventSubscriber(ObjectType::Table, database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromShptLine(var SalesShptLine: record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line")
    begin
        with SalesLine do begin
            "MICA 3PL Country Of Origin" := SalesShptLine."MICA 3PL Country Of Origin";
            "MICA 3PL DOT Value" := SalesShptLine."MICA 3PL DOT Value";
        end;
    end;
}