codeunit 81981 "MICA Flow PostProcess ASN"
{
    TableNo = "MICA Flow Entry";

    var
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowInformation: Record "MICA Flow Information";

    trigger OnRun()
    var
        PurchaseHeader: Record "Purchase Header";
        OpeningMICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        UserSetupManagement: Codeunit "User Setup Management";
        MICAFlowMgt: Codeunit "MICA Flow Mgt";
        MICAFlowProcessALtoPO: codeunit "MICA Flow Process AL to PO";
        SetupRecordID: RecordId;
        RecordRef: RecordRef;
        StartMsg: Label 'Start post-processing data';
        PostProcessingErr: Label 'Post Receipt failed : %1';
        DatapostProcessedMsg: Label 'Data Post-Processed';
        NumberOfPostRecRefsMsg: Label ' %1 records post-processed';
        PurchHeaderNotFoundErr: label 'Record not found.';
        PurchHeaderInvalidStatusErr: label '%1 should be %2.';
        PostingDateErr: Label 'Posting date %1 is not allowed for user %2.';
        ProcessAbortedLbl: Label 'Process aborted : %1 error(s) found.';
        RecordsPostProcessed: Integer;
        CurrencyError: Text;
    begin
        OpeningMICAFlowInformation.Get(Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, ''));

        if not UserSetupManagement.IsPostingDateValidWithSetup(WorkDate(), SetupRecordID) then begin
            Rec.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(PostingDateErr, WorkDate(), UserId()), '');
            Rec.CalcFields("Error Count");
            Rec.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ProcessAbortedLbl, Rec."Error Count"), '');
            OpeningMICAFlowInformation.Update('', '');
            exit;
        end;

        //Check record before post-process
        MICAFlowRecord.Reset();
        MICAFlowRecord.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowRecord.modifyall("Disable Post-Processed", false);

        MICAFlowRecord.Reset();
        MICAFlowRecord.SetRange("Flow Entry No.", Rec."Entry No.");
        if MICAFlowRecord.FindSet(true) then
            repeat
                if not RecordRef.Get(MICAFlowRecord."Linked RecordID") then begin
                    MICAFlowRecord."Disable Post-Processed" := true;
                    Rec.AddInformation(OpeningMICAFlowInformation."Info Type"::Error, PurchHeaderNotFoundErr, MICAFlowRecord."Linked Record");

                end else begin

                    RecordRef.SetTable(PurchaseHeader);
                    MICAFlowMgt.GetFlowEntry(PurchaseHeader."MICA Rcv. Last Flow Entry No.", MICAFlowEntry);
                    if MICAFlowEntry."Receive Status" <> MICAFlowEntry."Receive Status"::Processed then begin
                        MICAFlowRecord."Disable Post-Processed" := true;
                        Rec.AddInformation(OpeningMICAFlowInformation."Info Type"::Error,
                            StrSubstNo(PurchHeaderInvalidStatusErr, MICAFlowEntry.fieldcaption("Receive Status"), format(MICAFlowEntry."Receive Status"::Processed)),
                            MICAFlowRecord."Linked Record");
                    end;

                    if ASNAlreadyProcessed(rec, PurchaseHeader) then
                        MICAFlowRecord."Disable Post-Processed" := true;

                    CurrencyError := MICAFlowProcessALtoPO.CheckPurchaseOrderCurrencyRate(PurchaseHeader."Currency Code", PurchaseHeader."Document Date");
                    if CurrencyError <> '' then begin
                        Rec.AddInformation(OpeningMICAFlowInformation."Info Type"::Error, CurrencyError, MICAFlowRecord."Linked Record");
                        MICAFlowRecord."Disable Post-Processed" := true;
                    end;

                end;
                MICAFlowRecord.modify(true);
            until MICAFlowRecord.next() = 0;

        //Post-process records
        MICAFlowRecord.Reset();
        MICAFlowRecord.SetRange("Flow Entry No.", Rec."Entry No.");
        MICAFlowRecord.setrange("Disable Post-Processed", false); //only valid records
        if MICAFlowRecord.FindSet() then
            repeat
                RecordRef.Get(MICAFlowRecord."Linked RecordID");
                RecordRef.SetTable(PurchaseHeader);
                PurchaseHeader.Invoice := false;
                PurchaseHeader.Receive := true;
                Commit();
                if not Codeunit.Run(Codeunit::"Purch.-Post", PurchaseHeader) then
                    Rec.AddInformation(OpeningMICAFlowInformation."Info Type"::Error, strsubstno(PostProcessingErr, GetLastErrorText()), MICAFlowRecord."Linked Record")
                else begin
                    MICAFlowRecord.UpdateReceiveRecord(Rec."Entry No.", PurchaseHeader.RecordId(), Rec."Receive Status"::PostProcessed);
                    RecordsPostProcessed += 1;
                end;
            until MICAFlowRecord.Next() = 0;

        Rec.CalcFields("Error Count");
        Rec.AddInformation(MICAFlowInformation."Info Type"::Information, Rec."Entry No.", DatapostProcessedMsg, StrSubstNo(NumberOfPostRecRefsMsg, RecordsPostProcessed));
        OpeningMICAFlowInformation.Update('', '');
    end;

    local procedure ASNAlreadyProcessed(MICAFlowEntry: record "MICA Flow Entry"; PurchaseHeader: record "Purchase Header"): Boolean
    var
        TransferHeader: record "Transfer Header";
        TransferShipmentHeader: record "Transfer Shipment Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        TransferReceiptHeader: record "Transfer Receipt Header";
        TransferReceiptLine: record "Transfer Receipt Line";
        AsnAlreadyExistLbl: label 'ASN integration already processed on %1 %2.';
    begin
        TransferHeader.SetCurrentKey("MICA ASN No.");
        TransferHeader.SetRange("MICA ASN No.", PurchaseHeader."MICA ASN No.");
        if not TransferHeader.IsEmpty() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, PurchaseHeader.RecordId(), StrSubstNo(AsnAlreadyExistLbl, TransferHeader.TableCaption(), TransferHeader."No."), '');
            exit(true);
        end;

        TransferShipmentLine.SetCurrentKey("MICA ASN No.");
        TransferShipmentLine.SetRange("MICA ASN No.", PurchaseHeader."MICA ASN No.");
        if not TransferShipmentLine.IsEmpty() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, PurchaseHeader.RecordId(), StrSubstNo(AsnAlreadyExistLbl, TransferShipmentHeader.TableCaption(), TransferShipmentLine."Document No."), '');
            exit(true);
        end;

        TransferReceiptLine.SetCurrentKey("MICA ASN No.");
        TransferReceiptLine.SetRange("MICA ASN No.", PurchaseHeader."MICA ASN No.");
        if not TransferReceiptLine.IsEmpty() then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, PurchaseHeader.RecordId(), StrSubstNo(AsnAlreadyExistLbl, TransferReceiptHeader.TableCaption(), TransferReceiptLine."Document No."), '');
            exit(true);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptLine', '', false, false)]
    local procedure TransfOrderPostShptOnBeforeInsertTransShptLine(var TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line")
    begin
        with TransShptLine do begin
            "MICA AL No." := TransLine."MICA AL No.";
            "MICA SRD" := TransLine."MICA SRD";
            "MICA ASN No." := TransLine."MICA ASN No.";
            "MICA ETA" := TransLine."MICA ETA";
            "MICA Container ID" := TransLine."MICA Container ID";
            "MICA Seal No." := TransLine."MICA Seal No.";
            "MICA Port of Arrival" := TransLine."MICA Port of Arrival";
            "MICA Carrier Doc. No." := TransLine."MICA Carrier Doc. No.";
            "MICA ASN Date" := TransLine."MICA ASN Date";
            "MICA Initial ETA" := transline."MICA Initial ETA";
            "MICA Initial SRD" := TransLine."MICA Initial SRD";
            "MICA AL Line No." := TransLine."MICA AL Line No.";
            "MICA ASN Line No." := TransLine."MICA ASN Line No.";
            "MICA Country of Origin" := TransLine."MICA Country of Origin";
            "MICA Purchase Order No." := TransLine."MICA Purchase Order No.";
            "MICA Purchase Order Line No." := TransLine."MICA Purchase Order Line No.";
            "MICA DC14" := TransLine."MICA DC14";
            "MICA Ctry. ISO Code/O. Manuf." := TransLine."MICA Ctry. ISO Code/O. Manuf.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptLine', '', false, false)]
    local procedure TransfOrderPostRcvOnBeforeInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line")
    begin
        with TransRcptLine do begin
            "MICA AL No." := TransLine."MICA AL No.";
            "MICA SRD" := TransLine."MICA SRD";
            "MICA ASN No." := TransLine."MICA ASN No.";
            "MICA ETA" := TransLine."MICA ETA";
            "MICA Container ID" := TransLine."MICA Container ID";
            "MICA Seal No." := TransLine."MICA Seal No.";
            "MICA Port of Arrival" := TransLine."MICA Port of Arrival";
            "MICA Carrier Doc. No." := TransLine."MICA Carrier Doc. No.";
            "MICA ASN Date" := TransLine."MICA ASN Date";
            "MICA Initial ETA" := transline."MICA Initial ETA";
            "MICA Initial SRD" := TransLine."MICA Initial SRD";
            "MICA AL Line No." := TransLine."MICA AL Line No.";
            "MICA ASN Line No." := TransLine."MICA ASN Line No.";
            "MICA Country of Origin" := TransLine."MICA Country of Origin";
            "MICA Purchase Order No." := TransLine."MICA Purchase Order No.";
            "MICA Purchase Order Line No." := TransLine."MICA Purchase Order Line No.";
            "MICA DC14" := TransLine."MICA DC14";
            "MICA Ctry. ISO Code/O. Manuf." := TransLine."MICA Ctry. ISO Code/O. Manuf.";
        end;
    end;
}
