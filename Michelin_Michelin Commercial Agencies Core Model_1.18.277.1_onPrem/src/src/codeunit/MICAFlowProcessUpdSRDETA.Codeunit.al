codeunit 82442 "MICA Flow Process Upd. SRD/ETA"
{
    TableNo = "MICA Flow Entry";

    var
        MICAFlowBufferETASRD: Record "MICA Flow Buffer ETA SRD";
        MICAFlowInformation: Record "MICA Flow Information";
        StartMsg: label 'Start processing data';
        TransfHdrNotFoundErr: label 'There is no %1 with %2 %3.';
        EmptyDateInBufferLbl: label '%1 is empty in %2.';
        PartialProcessingMsg: Label 'Flow Entry not processed due to Partial Processing not allowed.';

    trigger OnRun()
    var
        MICAFlow: Record "MICA Flow";
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        BufferRecordRef: RecordRef;
        RecordsProcessed: Integer;
        RecordsRejected: Integer;
        IncorrectValueLbl: Label 'Incorrect Value : Field %1 value %2.';
        EmptyAsnNoErr: Label '%1 is empty.';
    begin
        MICAFlow.Get(rec."Flow Code");
        with MICAFlowBufferETASRD do begin
            OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));
            SetRange("Flow Entry No.", Rec."Entry No.");
            if FindSet(true) then begin
                repeat
                    "Error" := false;
                    BufferRecordRef.GetTable(MICAFlowBufferETASRD);

                    "ASN No." := ExtractASNNo();
                    if "ASN No." = '' then
                        AddInformation(MICAFlowInformation."Info Type"::Error, "Entry No.", StrSubstNo(EmptyAsnNoErr, FieldCaption("ASN No.")), '');

                    if not EvaluateRawDateTimeToDateTime(ETA, "ETA Raw") then
                        AddInformation(MICAFlowInformation."Info Type"::Error, "Entry No.", StrSubstNo(IncorrectValueLbl, FieldCaption(ETA), "ETA Raw"), '');

                    if not EvaluateRawDateTimeToDateTime(SRD, "SRD Raw") then
                        AddInformation(MICAFlowInformation."Info Type"::Error, "Entry No.", StrSubstNo(IncorrectValueLbl, FieldCaption(SRD), "SRD Raw"), '');

                    Modify(false);
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
            OpeningMICAFlowInformation.Update('', '');
        end;
    end;

    local procedure ExtractASNNo(): Code[35]
    var
        ASNSeparatorFirstPos: Integer;
        ASNSeparatorSecondPos: Integer;
        ASNNoSeparatorLbl: Label '_', Locked = true;
    begin
        ASNSeparatorFirstPos := StrPos(MICAFlowBufferETASRD."ASN No. Raw", ASNNoSeparatorLbl);
        case true of
            ASNSeparatorFirstPos = 0:
                exit(CopyStr(MICAFlowBufferETASRD."ASN No. Raw", 1, MaxStrLen(MICAFlowBufferETASRD."ASN No.")));
            ASNSeparatorFirstPos > 0:
                begin
                    ASNSeparatorSecondPos := StrPos(CopyStr(MICAFlowBufferETASRD."ASN No. Raw", ASNSeparatorFirstPos + 1), ASNNoSeparatorLbl);
                    if ASNSeparatorSecondPos = 0 then
                        exit(CopyStr(CopyStr(MICAFlowBufferETASRD."ASN No. Raw", ASNSeparatorFirstPos + 1), 1, MaxStrLen(MICAFlowBufferETASRD."ASN No.")))
                    else
                        exit(CopyStr(CopyStr(MICAFlowBufferETASRD."ASN No. Raw", ASNSeparatorFirstPos + 1, ASNSeparatorSecondPos - 1), 1, MaxStrLen(MICAFlowBufferETASRD."ASN No.")))
                end;
        end;
    end;

    local procedure EvaluateRawDateTimeToDateTime(var OutValue: DateTime; RawDateTime: Text): Boolean
    var
        EvaluatedDay: Integer;
        EvaluatedMonth: integer;
        EvaluatedYear: Integer;
        EvaluatedTime: Time;
    begin
        if not Evaluate(EvaluatedDay, CopyStr(RawDateTime, 9, 2)) then
            exit(false);
        if not Evaluate(EvaluatedMonth, CopyStr(RawDateTime, 6, 2)) then
            exit(false);
        if not Evaluate(EvaluatedYear, CopyStr(RawDateTime, 1, 4)) then
            exit(false);
        if not Evaluate(EvaluatedTime, CopyStr(RawDateTime, 12, 8)) then
            exit(false);
        OutValue := CreateDateTime(DMY2Date(EvaluatedDay, EvaluatedMonth, EvaluatedYear), EvaluatedTime);
        Exit(true);
    end;

    local procedure ProcessBuffer(MICAFlowEntry: Record "MICA Flow Entry"; var RecordsProcessed: Integer; var RecordsRejected: Integer)
    begin
        with MICAFlowBufferETASRD do begin
            FindFirst();
            repeat
                if "Error" or not ProcessRecord(MICAFlowEntry, MICAFlowBufferETASRD, RecordsProcessed) then
                    RecordsRejected += 1;
            until Next() = 0;
        end;
    end;

    local procedure ProcessRecord(MICAFlowEntry: Record "MICA Flow Entry"; var LocMICAFlowBufferETASRD: Record "MICA Flow Buffer ETA SRD"; var RecordsProcessed: Integer): Boolean
    var
        TransferHeader: Record "Transfer Header";
        ToLocation: record Location;
        CustomizedCalendarChange: Record "Customized Calendar Change";
        TransferRoute: Record "Transfer Route";
        CalendarManagement: Codeunit "Calendar Management";
        NewSRD: Date;

        UpdateRecord: Boolean;
    begin
        TransferHeader.SetCurrentKey("MICA ASN No.");
        TransferHeader.SetRange("MICA ASN No.", LocMICAFlowBufferETASRD."ASN No.");
        if not TransferHeader.FindFirst() then begin
            MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(TransfHdrNotFoundErr, TransferHeader.TableCaption(), TransferHeader.FieldCaption("MICA ASN No."), LocMICAFlowBufferETASRD."ASN No."), ''));
            MICAFlowInformation."Flow Buffer Entry No." := LocMICAFlowBufferETASRD."Entry No.";
            MICAFlowInformation.Modify();
            exit(false);
        end;

        repeat
            if not ToLocation.get(TransferHeader."Transfer-to Code") then
                ToLocation.Init();
            TransferHeader.CalledFromWarehouse(true);
            CustomizedCalendarChange.SetSource(CustomizedCalendarChange."Source Type"::Location, '', '', ToLocation."Base Calendar Code");
            if LocMICAFlowBufferETASRD.ETA = 0DT then begin
                MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(EmptyDateInBufferLbl, LocMICAFlowBufferETASRD.FieldCaption(ETA), LocMICAFlowBufferETASRD.TableCaption()), ''));
                MICAFlowInformation."Flow Buffer Entry No." := LocMICAFlowBufferETASRD."Entry No.";
                MICAFlowInformation.Modify();
            end else
                if TransferHeader."MICA ETA" <> DT2Date(LocMICAFlowBufferETASRD.ETA) then begin
                    TransferHeader.Validate("MICA ETA", DT2Date(LocMICAFlowBufferETASRD.ETA));
                    If TransferRoute.get(TransferHeader."Transfer-from Code", TransferHeader."Transfer-to Code") then
                        TransferHeader.Validate("MICA SRD", CalcSRDDate(TransferRoute, TransferHeader."MICA ETA"));
                    UpdateRecord := True;
                end;

            if LocMICAFlowBufferETASRD.SRD = 0DT then begin
                MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(EmptyDateInBufferLbl, LocMICAFlowBufferETASRD.FieldCaption(SRD), LocMICAFlowBufferETASRD.TableCaption()), ''));
                MICAFlowInformation."Flow Buffer Entry No." := LocMICAFlowBufferETASRD."Entry No.";
                MICAFlowInformation.Modify();
            end else
                if DT2Date(LocMICAFlowBufferETASRD.SRD) > TransferHeader."MICA SRD" then begin
                    NewSRD := DT2Date(LocMICAFlowBufferETASRD.SRD);
                    while CalendarManagement.IsNonworkingDay(NewSRD, CustomizedCalendarChange) do
                        NewSRD := CalcDate('<+1D>', NewSRD);
                    TransferHeader.validate("MICA SRD", NewSRD);
                    UpdateRecord := True;
                end;

            if UpdateRecord then begin
                TransferHeader.Modify(True);
                UpdateTransferLines(TransferHeader);
                LocMICAFlowBufferETASRD.VALIDATE("Linked Record ID", TransferHeader.RecordId());
                LocMICAFlowBufferETASRD.Modify();
            end;

            RecordsProcessed += 1;
        until TransferHeader.Next() = 0;
        exit(true);
    end;

    local procedure UpdateTransferLines(FromTransferHeader: Record "Transfer Header")
    var
        TransferLine: Record "Transfer Line";
    begin
        with TransferLine do begin
            SetRange("Document No.", FromTransferHeader."No.");
            SetRange("Derived From Line No.", 0);
            if FindSet(true, false) then
                repeat
                    if FromTransferHeader."MICA ETA" <> "MICA ETA" then begin
                        Validate("MICA ETA", FromTransferHeader."MICA ETA");
                        if "MICA Initial ETA" = 0D then
                            Validate("MICA Initial ETA", FromTransferHeader."MICA ETA");
                    end;
                    if FromTransferHeader."MICA SRD" <> "MICA SRD" then begin
                        Validate("MICA SRD", FromTransferHeader."MICA SRD");
                        if "MICA Initial SRD" = 0D then
                            Validate("MICA Initial SRD", FromTransferHeader."MICA SRD");
                    end;
                    Modify(false);
                until Next() = 0;
        end;
    end;

    local procedure CalcSRDDate(TransferRoute: Record "Transfer Route"; SRD: Date): Date
    var
        ShippingAgentServices: Record "Shipping Agent Services";
    begin
        if SRD = 0D then
            exit;
        if (TransferRoute."Shipping Agent Code" <> '') and (TransferRoute."Shipping Agent Service Code" <> '') then
            ShippingAgentServices.Get(TransferRoute."Shipping Agent Code", TransferRoute."Shipping Agent Service Code");
        Exit(CalcDate(ShippingAgentServices."Shipping Time", SRD));
    End;
}