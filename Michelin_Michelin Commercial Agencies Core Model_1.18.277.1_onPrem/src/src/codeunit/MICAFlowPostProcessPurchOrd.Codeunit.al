codeunit 81983 "MICA Flow PostProcessPurchOrd"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure c90OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
                       PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        FromPurchRcptHeader: Record "Purch. Rcpt. Header";
        TempPurchaseLine: Record "Purchase Line" temporary;
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        NextPurchLineNo: Integer;
    begin
        if PurchaseHeader."MICA ASN No." = '' then
            if not PurchaseHeader."MICA Auto. Trans. Order" then
                exit;

        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.findset() then begin
            ReleasePurchaseDocument.PerformManualReopen(PurchaseHeader);
            NextPurchLineNo := GetNextPurchLineNo(PurchaseLine);
            repeat
                if PurchaseLine.Quantity - PurchaseLine."Outstanding Quantity" <> 0 then begin
                    CreateTempNewPurchLine(PurchaseHeader, PurchaseLine, TempPurchaseLine, NextPurchLineNo);
                    PurchaseLine.validate(Quantity, PurchaseLine."Quantity Received");
                    PurchaseLine.Modify();
                end;
            until PurchaseLine.Next() = 0;
            InsertTempNewPurchLines(TempPurchaseLine);
            ReleasePurchaseDocument.PerformManualRelease(PurchaseHeader);
        end;

        Commit();
        FromPurchRcptHeader.SetRange("No.", PurchRcpHdrNo);
        if FromPurchRcptHeader.FindFirst() then
            CreateAndPostTransferOrder(FromPurchRcptHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure t5744OnAfterCopyFromTransferHeader(VAR TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferShipmentHeader."MICA AL No." := TransferHeader."MICA AL No.";
        TransferShipmentHeader."MICA SRD" := TransferHeader."MICA SRD";
        TransferShipmentHeader."MICA ASN No." := TransferHeader."MICA ASN No.";
        TransferShipmentHeader."MICA ETA" := TransferHeader."MICA ETA";
        TransferShipmentHeader."MICA Container ID" := TransferHeader."MICA Container ID";
        TransferShipmentHeader."MICA Seal No." := TransferHeader."MICA Seal No.";
        TransferShipmentHeader."MICA Port of Arrival" := TransferHeader."MICA Port of Arrival";
        TransferShipmentHeader."MICA Carrier Doc. No." := TransferHeader."MICA Carrier Doc. No.";
        TransferShipmentHeader."MICA ASN Date" := TransferHeader."MICA ASN Date";
        TransferShipmentHeader."MICA Initial ETA" := TransferHeader."MICA Initial ETA";
        TransferShipmentHeader."MICA Initial SRD" := TransferHeader."MICA Initial SRD";
        TransferShipmentHeader."MICA Maritime Air Company Name" := TransferHeader."MICA Maritime Air Company Name";
        TransferShipmentHeader."MICA Maritime Air Number" := TransferHeader."MICA Maritime Air Number";
        TransferShipmentHeader."MICA Action From Page" := TransferHeader."MICA Action From Page";
        TransferShipmentHeader."MICA Vendor Order No." := TransferHeader."MICA Vendor Order No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure t5745OnAfterCopyFromTransferLine(VAR TransferShipmentLine: Record "Transfer Shipment Line"; TransferLine: Record "Transfer Line")
    begin
        TransferShipmentLine."MICA AL No." := TransferLine."MICA AL No.";
        TransferShipmentLine."MICA AL Line No." := TransferLine."MICA AL Line No.";
        TransferShipmentLine."MICA SRD" := TransferLine."MICA SRD";
        TransferShipmentLine."MICA ASN No." := TransferLine."MICA ASN No.";
        TransferShipmentLine."MICA ASN Line No." := TransferLine."MICA ASN Line No.";
        TransferShipmentLine."MICA ETA" := TransferLine."MICA ETA";
        TransferShipmentLine."MICA Container ID" := TransferLine."MICA Container ID";
        TransferShipmentLine."MICA Seal No." := TransferLine."MICA Seal No.";
        TransferShipmentLine."MICA Port of Arrival" := TransferLine."MICA Port of Arrival";
        TransferShipmentLine."MICA Carrier Doc. No." := TransferLine."MICA Carrier Doc. No.";
        TransferShipmentLine."MICA ASN Date" := TransferLine."MICA ASN Date";
        TransferShipmentLine."MICA Initial ETA" := TransferLine."MICA Initial ETA";
        TransferShipmentLine."MICA Initial SRD" := TransferLine."MICA Initial SRD";
        TransferShipmentLine."MICA Country of Origin" := TransferLine."MICA Country of Origin";
        TransferShipmentLine."MICA DC14" := TransferLine."MICA DC14";
        TransferShipmentLine."MICA Purchase Order No." := TransferLine."MICA Purchase Order No.";
        TransferShipmentLine."MICA Purchase Order Line No." := TransferLine."MICA Purchase Order Line No.";
        TransferShipmentLine."MICA Ship From Vendor" := TransferLine."MICA Ship From Vendor";
        TransferShipmentLine."MICA Shipment Line Num" := TransferLine."MICA Shipment Line Num";
        TransferShipmentLine."MICA Initial Shipment Date" := TransferLine."MICA Initial Shipment Date";
        TransferShipmentLine."MICA Ctry. ISO Code/O. Manuf." := TransferLine."MICA Ctry. ISO Code/O. Manuf.";
    end;

    local procedure CreateTempNewPurchLine(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary; var NextPurchLineNo: Integer);
    begin
        if not (PurchaseLine."Qty. Received (Base)" <> PurchaseLine."Quantity (Base)") then
            exit;
        TempPurchaseLine.Init();
        TempPurchaseLine.Validate("Document Type", PurchaseHeader."Document Type");
        TempPurchaseLine.Validate("Document No.", PurchaseHeader."No.");
        TempPurchaseLine.Validate("Line No.", NextPurchLineNo);
        TempPurchaseLine.insert(true);
        NextPurchLineNo += 10000;
        TempPurchaseLine.Validate(Type, TempPurchaseLine.Type::Item);
        TempPurchaseLine.Validate("No.", PurchaseLine."No.");
        TempPurchaseLine.Validate(Quantity, PurchaseLine."Outstanding Quantity");
        TempPurchaseLine.Validate("MICA AL No.", PurchaseLine."MICA AL No.");
        TempPurchaseLine.Validate("MICA AL Line No.", PurchaseLine."MICA AL Line No.");
        TempPurchaseLine.Validate("MICA Location-To Code", PurchaseLine."MICA Location-To Code");
        TempPurchaseLine.Validate("MICA Record ID", PurchaseHeader.RecordId());
        TempPurchaseLine.Validate("Location Code", PurchaseLine."Location Code");
        TempPurchaseLine."MICA ASN No." := '';
        TempPurchaseLine."MICA ASN Line No." := 0;
        TempPurchaseLine."MICA Country of Origin" := '';
        TempPurchaseLine."MICA Container ID" := '';
        TempPurchaseLine."MICA ETA" := PurchaseLine."MICA ETA";
        TempPurchaseLine."MICA Seal No." := '';
        TempPurchaseLine."MICA Port of Arrival" := '';
        TempPurchaseLine."MICA Carrier Doc. No." := '';
        TempPurchaseLine."MICA DC14" := PurchaseLine."MICA DC14";
        TempPurchaseLine."MICA Ctry. ISO Code/O. Manuf." := '';
        TempPurchaseLine."MICA Initial Shipment Date" := PurchaseLine."MICA Initial Shipment Date";
        TempPurchaseLine."MICA Ship From Vendor" := PurchaseLine."MICA Ship From Vendor";
        TempPurchaseLine.Modify(true);
    end;

    local procedure InsertTempNewPurchLines(var TempPurchaseLine: Record "Purchase Line" temporary);
    var
        PurchaseLine: Record "Purchase Line";
    begin
        TempPurchaseLine.Reset();
        if TempPurchaseLine.FindSet() then
            repeat
                PurchaseLine.TransferFields(TempPurchaseLine);
                PurchaseLine.Insert(true);
            until TempPurchaseLine.Next() = 0;
    end;

    local procedure GetNextPurchLineNo(PurchaseLine: Record "Purchase Line"): Integer
    var
        FoundPurchaseLine: Record "Purchase Line";
    begin
        FoundPurchaseLine.SetRange("Document Type", PurchaseLine."Document Type");
        FoundPurchaseLine.SetRange("Document No.", PurchaseLine."Document No.");
        if FoundPurchaseLine.FindLast() then
            exit(FoundPurchaseLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetNextTransfLineNo(TransferHeader: Record "Transfer Header"): Integer
    var
        NewTransferLine: Record "Transfer Line";
    begin
        NewTransferLine.SetRange("Document No.", TransferHeader."No.");
        if NewTransferLine.FindLast() then
            exit(NewTransferLine."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure CreateAndPostTransferOrder(FromPurchRcptHeader: record "Purch. Rcpt. Header")
    var
        TransferHeader: Record "Transfer Header";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PurchRcptLine: record "Purch. Rcpt. line";
        TempToPostTransferHeader: Record "Transfer Header" temporary;
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        MICAReallocBackOrderMgt: Codeunit "MICA Realloc. BackOrder Mgt";
    begin
        if FromPurchRcptHeader."MICA ASN No." = '' then
            if not FromPurchRcptHeader."MICA Auto. Trans. Order" then
                exit;

        SalesReceivablesSetup.Get();
        if not SalesReceivablesSetup."MICA ASN Use Line No. Grouping" then begin
            TransferHeader.Reset();
            TransferHeader.SetCurrentKey("MICA ASN No.");
            TransferHeader.setrange("MICA ASN No.", FromPurchRcptHeader."MICA ASN No.");
            if (FromPurchRcptHeader."MICA ASN No." <> '') and TransferHeader.FindFirst() then begin
                if TransferHeader.Status <> TransferHeader.Status::Open then
                    ReleaseTransferDocument.Reopen(TransferHeader);
            end else
                InsertNewTransferHeader(TransferHeader, FromPurchRcptHeader);
            InsertTransferOrderLines(TransferHeader, FromPurchRcptHeader);
            if FromPurchRcptHeader."MICA Auto. Trans. Order" then
                MICAReallocBackOrderMgt.CommitmentOnTransferOrderHeader(TransferHeader);
            ReleaseTransferDocument.Run(TransferHeader);
            TransferOrderPostShipment.Run(TransferHeader);

        end else begin

            //Find ASN No. on Purch. Receipt Line instead of Purch. Receipt Header
            PurchRcptLine.Reset();
            PurchRcptLine.SetRange("Document No.", FromPurchRcptHeader."No.");
            PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
            PurchRcptLine.SetFilter(Quantity, '>%1', 0);
            if PurchRcptLine.Findset() then
                Repeat
                    TransferHeader.Reset();
                    TransferHeader.SetCurrentKey("MICA ASN No.");
                    TransferHeader.setrange("MICA ASN No.", PurchRcptLine."MICA ASN No.");
                    if TransferHeader.FindFirst() then begin
                        if TransferHeader.Status <> TransferHeader.Status::Open then
                            ReleaseTransferDocument.Reopen(TransferHeader);
                    end else
                        InsertNewTransferHeader(TransferHeader, FromPurchRcptHeader, PurchRcptLine); //Create TO from Purch. Receipt Line infos

                    TempToPostTransferHeader."No." := TransferHeader."No.";
                    if not TempToPostTransferHeader.Insert() then; //Backup Transfer order tobe released/posted

                    InsertTransferLine(TransferHeader, PurchRcptLine);
                Until PurchRcptLine.Next() = 0;

            //Release and post all Transfer order previously created
            if TempToPostTransferHeader.FindSet() then
                repeat
                    TransferHeader.Get(TempToPostTransferHeader."No.");
                    if FromPurchRcptHeader."MICA Auto. Trans. Order" then
                        MICAReallocBackOrderMgt.CommitmentOnTransferOrderHeader(TransferHeader);
                    ReleaseTransferDocument.Run(TransferHeader);
                    TransferOrderPostShipment.Run(TransferHeader);
                until TempToPostTransferHeader.Next() = 0;

        end;
    end;

    local procedure InsertNewTransferHeader(var TransferHeader: Record "Transfer Header"; FromPurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        MICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        TransferRoute: Record "Transfer Route";
        MissingRouteErr: Label 'Transfer Route setup is required for combination From %1 To %2.';
        BufferAsn1Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        Clear(TransferHeader);

        MICAFlowBufferASN.SetFilter("AL No.", StrSubstNo(BufferAsn1Lbl, CopyStr(FromPurchRcptHeader."MICA AL No.", 1, 9), '*'));
        If FromPurchRcptHeader."MICA ASN No." <> '' then
            MICAFlowBufferASN.SetRange("Doc. ID", FromPurchRcptHeader."MICA ASN No.");

        if not MICAFlowBufferASN.FindFirst() then
            MICAFlowBufferASN.Init();

        TransferHeader.Insert(true);

        TransferHeader.Validate("Transfer-from Code", FromPurchRcptHeader."Location Code");
        TransferHeader.Validate("Transfer-to Code", FromPurchRcptHeader."MICA Location-To Code");
        if not TransferRoute.Get(FromPurchRcptHeader."Location Code", FromPurchRcptHeader."MICA Location-To Code") then
            Error(MissingRouteErr, FromPurchRcptHeader."Location Code", FromPurchRcptHeader."MICA Location-To Code");
        TransferHeader.Validate("In-Transit Code", TransferRoute."In-Transit Code");
        TransferHeader.Validate("Posting Date", DT2Date(MICAFlowBufferASN."Date Time Creation"));
        if TransferHeader."Posting Date" = 0D then
            TransferHeader.Validate("Posting Date", Today());

        if MICAFlowBufferASN.SRD <> 0D then
            TransferHeader.Validate("Receipt Date", CalcReceiptDate(TransferHeader."Transfer-to Code", MICAFlowBufferASN.SRD))
        else
            if MICAFlowBufferASN.ETA <> 0D then
                TransferHeader.Validate("Receipt Date", CalcReceiptDate(TransferHeader."Transfer-to Code", MICAFlowBufferASN.ETA));
        TransferHeader."MICA ASN No." := FromPurchRcptHeader."MICA ASN No.";
        TransferHeader."MICA AL No." := FromPurchRcptHeader."MICA AL No.";
        TransferHeader."External Document No." := CopyStr(FromPurchRcptHeader."MICA ASN No.", 1, MaxStrLen(TransferHeader."External Document No."));
        TransferHeader."MICA ASN Date" := DT2Date(MICAFlowBufferASN."Date Time Creation");
        TransferHeader.SetHideValidationMsg(true);
        TransferHeader.Validate("MICA ETA", MICAFlowBufferASN.ETA);
        TransferHeader."MICA Container ID" := FromPurchRcptHeader."MICA Container ID";
        TransferHeader."MICA Seal No." := FromPurchRcptHeader."MICA Seal No.";
        TransferHeader."MICA Port of Arrival" := FromPurchRcptHeader."MICA Port of Arrival";
        TransferHeader."MICA Carrier Doc. No." := FromPurchRcptHeader."MICA Carrier Doc. No.";
        TransferHeader."Shortcut Dimension 1 Code" := FromPurchRcptHeader."Shortcut Dimension 1 Code";
        TransferHeader."Shortcut Dimension 2 Code" := FromPurchRcptHeader."Shortcut Dimension 2 Code";
        TransferHeader."Dimension Set ID" := FromPurchRcptHeader."Dimension Set ID";
        TransferHeader."MICA Maritime Air Company Name" := FromPurchRcptHeader."MICA Maritime Air Company Name";
        TransferHeader."MICA Maritime Air Number" := FromPurchRcptHeader."MICA Maritime Air Number";

        if FromPurchRcptHeader."MICA Auto. Trans. Order" then begin
            TransferHeader."MICA Vendor Order No." := FromPurchRcptHeader."Vendor Order No.";
            TransferHeader."MICA ETA" := FromPurchRcptHeader."MICA ETA";
            TransferHeader."MICA SRD" := FromPurchRcptHeader."MICA SRD";
            TransferHeader."MICA Initial ETA" := TransferHeader."MICA ETA";
            TransferHeader."MICA Initial SRD" := TransferHeader."MICA SRD";
            TransferHeader."MICA Container ID" := FromPurchRcptHeader."MICA Container ID";
        end;

        TransferHeader.Modify(true);
    end;

    local procedure InsertNewTransferHeader(var TransferHeader: Record "Transfer Header"; FromPurchRcptHeader: Record "Purch. Rcpt. Header"; FromPurchRcptLine: Record "Purch. Rcpt. Line")
    var
        MICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        TransferRoute: Record "Transfer Route";
        MissingRouteErr2Lbl: Label 'Transfer Route setup is required for combination From %1 To %2.';
        BufferAsn2Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        Clear(TransferHeader);

        MICAFlowBufferASN.SetFilter("AL No.", StrSubstNo(BufferAsn2Lbl, CopyStr(FromPurchRcptLine."MICA AL No.", 1, 9), '*'));
        If FromPurchRcptLine."MICA ASN No." <> '' then
            MICAFlowBufferASN.SetRange("Doc. ID", FromPurchRcptLine."MICA ASN No.");

        if not MICAFlowBufferASN.FindFirst() then
            MICAFlowBufferASN.Init();

        TransferHeader.Insert(true);

        TransferHeader.Validate("Transfer-from Code", FromPurchRcptLine."Location Code");
        TransferHeader.Validate("Transfer-to Code", FromPurchRcptLine."MICA Location-To Code");
        if not TransferRoute.Get(FromPurchRcptLine."Location Code", FromPurchRcptLine."MICA Location-To Code") then
            Error(MissingRouteErr2Lbl, FromPurchRcptLine."Location Code", FromPurchRcptLine."MICA Location-To Code");
        TransferHeader.Validate("In-Transit Code", TransferRoute."In-Transit Code");
        TransferHeader.Validate("Posting Date", DT2Date(MICAFlowBufferASN."Date Time Creation"));
        if TransferHeader."Posting Date" = 0D then
            TransferHeader.Validate("Posting Date", Today());

        if MICAFlowBufferASN.SRD <> 0D then
            TransferHeader.Validate("Receipt Date", CalcReceiptDate(TransferHeader."Transfer-to Code", MICAFlowBufferASN.SRD))
        else
            if MICAFlowBufferASN.ETA <> 0D then
                TransferHeader.Validate("Receipt Date", CalcReceiptDate(TransferHeader."Transfer-to Code", MICAFlowBufferASN.ETA));
        TransferHeader."MICA ASN No." := FromPurchRcptLine."MICA ASN No.";
        TransferHeader."MICA AL No." := FromPurchRcptLine."MICA AL No.";
        TransferHeader."External Document No." := CopyStr(FromPurchRcptLine."MICA ASN No.", 1, MaxStrLen(TransferHeader."External Document No."));
        TransferHeader."MICA ASN Date" := DT2Date(MICAFlowBufferASN."Date Time Creation");
        TransferHeader.SetHideValidationMsg(true);
        TransferHeader.Validate("MICA ETA", MICAFlowBufferASN.ETA);
        TransferHeader."MICA Container ID" := FromPurchRcptLine."MICA Container ID";
        TransferHeader."MICA Seal No." := FromPurchRcptLine."MICA Seal No.";
        TransferHeader."MICA Port of Arrival" := FromPurchRcptLine."MICA Port of Arrival";
        TransferHeader."MICA Carrier Doc. No." := FromPurchRcptLine."MICA Carrier Doc. No.";
        TransferHeader."Shortcut Dimension 1 Code" := FromPurchRcptHeader."Shortcut Dimension 1 Code";
        TransferHeader."Shortcut Dimension 2 Code" := FromPurchRcptHeader."Shortcut Dimension 2 Code";
        TransferHeader."Dimension Set ID" := FromPurchRcptHeader."Dimension Set ID";
        TransferHeader."MICA Maritime Air Company Name" := FromPurchRcptHeader."MICA Maritime Air Company Name";
        TransferHeader."MICA Maritime Air Number" := FromPurchRcptHeader."MICA Maritime Air Number";

        if FromPurchRcptHeader."MICA Auto. Trans. Order" then begin
            TransferHeader."MICA Vendor Order No." := FromPurchRcptHeader."Vendor Order No.";
            TransferHeader."MICA ETA" := FromPurchRcptHeader."MICA ETA";
            TransferHeader."MICA SRD" := FromPurchRcptHeader."MICA SRD";
        end;

        TransferHeader.Modify(true);
    end;

    local procedure InsertTransferOrderLines(var TransferHeader: Record "Transfer Header"; FromPurchRcptHeader: record "Purch. Rcpt. Header")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.SetRange("Document No.", FromPurchRcptHeader."No.");
        PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SetFilter(Quantity, '<>%1', 0);
        if PurchRcptLine.FindSet() then
            repeat
                InsertTransferLine(TransferHeader, PurchRcptLine);
            until PurchRcptLine.Next() = 0;
    end;

    local procedure InsertTransferLine(TransferHeader: Record "Transfer Header"; FromPurchRcptLine: Record "Purch. Rcpt. Line")
    var
        TransferLine: Record "Transfer Line";
        MICAFlowBufferASN: Record "MICA Flow Buffer ASN";
        BufferAsn3Lbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        MICAFlowBufferASN.SetFilter("AL No.", StrSubstNo(BufferAsn3Lbl, CopyStr(FromPurchRcptLine."MICA AL No.", 1, 9), '*'));
        MICAFlowBufferASN.SetFilter("AL Line No.", '=%1', Format(FromPurchRcptLine."MICA AL Line No."));
        if not MICAFlowBufferASN.FindFirst() then
            MICAFlowBufferASN.Init();

        TransferLine."Document No." := TransferHeader."No.";
        TransferLine."Line No." := GetNextTransfLineNo(TransferHeader);
        TransferLine.Insert(true);
        TransferLine.Validate("Item No.", FromPurchRcptLine."No.");
        TransferLine.validate(Quantity, FromPurchRcptLine.Quantity);
        TransferLine.Validate("Qty. to Ship", FromPurchRcptLine.Quantity);
        TransferLine."MICA ASN No." := FromPurchRcptLine."MICA ASN No.";
        TransferLine."MICA ASN Line No." := FromPurchRcptLine."MICA ASN Line No.";
        TransferLine."MICA AL No." := FromPurchRcptLine."MICA AL No.";
        TransferLine."MICA AL Line No." := FromPurchRcptLine."MICA AL Line No.";
        TransferLine."MICA Purchase Order No." := FromPurchRcptLine."Order No.";
        TransferLine."MICA Purchase Order Line No." := FromPurchRcptLine."Order Line No.";
        TransferLine."MICA Container ID" := TransferHeader."MICA Container ID";
        TransferLine."MICA ASN Date" := DT2Date(MICAFlowBufferASN."Date Time Creation");
        TransferLine."MICA Initial ETA" := TransferHeader."MICA Initial ETA";
        TransferLine."MICA Initial SRD" := TransferHeader."MICA Initial SRD";
        TransferLine.Validate("MICA ETA", TransferHeader."MICA ETA");
        TransferLine.Validate("MICA SRD", TransferHeader."MICA SRD");
        TransferLine.Validate("Receipt Date", TransferHeader."Receipt Date");
        TransferLine."MICA Seal No." := TransferHeader."MICA Seal No.";
        TransferLine."MICA Port of Arrival" := TransferHeader."MICA Port of Arrival";
        TransferLine."MICA Carrier Doc. No." := TransferHeader."MICA Carrier Doc. No.";
        TransferLine."MICA Country of Origin" := FromPurchRcptLine."MICA Country of Origin";
        TransferLine."Shortcut Dimension 1 Code" := FromPurchRcptLine."Shortcut Dimension 1 Code";
        TransferLine."Shortcut Dimension 2 Code" := FromPurchRcptLine."Shortcut Dimension 2 Code";
        TransferLine."Dimension Set ID" := FromPurchRcptLine."Dimension Set ID";
        TransferLine."MICA DC14" := FromPurchRcptLine."MICA DC14";
        TransferLine."MICA Initial Shipment Date" := FromPurchRcptLine."MICA Initial Shipment Date";
        TransferLine."MICA Ctry. ISO Code/O. Manuf." := FromPurchRcptLine."MICA Ctry. ISO Code/O. Manuf.";
        TransferLine."MICA Country of Origin" := FromPurchRcptLine."MICA Country of Origin";
        TransferLine.Modify(true);
    End;

    local procedure FollowPlannedDeliveryDateUserUpdate(var OldSalesLine: record "Sales Line"; var NewSalesLine: record "Sales Line"; FromCurrFieldNo: Integer)
    begin
        if not (FromCurrFieldNo IN [OldSalesLine.FieldNo("Shipment Date"), OldSalesLine.FieldNo("Planned Delivery Date"), OldSalesLine.FieldNo("Planned Shipment Date")]) then
            exit;
        if (OldSalesLine."Planned Delivery Date" = NewSalesLine."Planned Delivery Date") or (OldSalesLine."Planned Delivery Date" = 0D) then
            exit;
        NewSalesLine."MICA Prev. Planned Del. Date" := OldSalesLine."Planned Delivery Date";
        if NewSalesLine."MICA Prev. Planned Del. Date" <> 0D then
            NewSalesLine."MICA Delivery Date Modified" := Today();
    end;

    procedure CalcReceiptDate(LocationCode: Code[10]; SRD: Date): Date
    var
        Location: Record Location;
    begin
        if not Location.Get(LocationCode) then
            exit(SRD);
        if SRD = 0D then
            exit;
        Location.testfield("Inbound Whse. Handling Time");
        Exit(CalcDate(Location."Inbound Whse. Handling Time", SRD));
    End;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Shipment Date', false, false)]
    local procedure SalesLineOnAfterValidateShipmentDate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        FollowPlannedDeliveryDateUserUpdate(xRec, Rec, CurrFieldNo);
    End;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Planned Delivery Date', false, false)]
    local procedure SalesLineOnAfterValidatePlannedDeliveryDate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        FollowPlannedDeliveryDateUserUpdate(xRec, Rec, CurrFieldNo);
    End;

    [EventSubscriber(ObjectType::Page, Page::"Transfer Order", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure UpdateTransferHdrActionFromPage(var Rec: Record "Transfer Header")
    begin
        Rec."MICA Action From Page" := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransferOrderPostReceipt', '', true, true)]
    local procedure OnBeforeTransferOrderPostReceipt(var TransferHeader: Record "Transfer Header")
    var
        Location: record Location;
        ContinuePostingQst: Label 'Transfer Order %1 is GIT and Receipt should be managed using Whse. Receipt document. Do you really want to continue?';
        AbortPostinrErr: Label 'Posting Transfer Order %1 canceled.';
    begin
        if not TransferHeader."MICA Action From Page" then
            exit;

        if not GuiAllowed() then
            exit;

        if not Location.get(TransferHeader."Transfer-to Code") then
            exit;

        if not Location."MICA 3PL Integration" then
            exit;

        if not Confirm(ContinuePostingQst, false, TransferHeader."No.") then
            Error(AbortPostinrErr, TransferHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeTransferOrderPostShipment', '', true, true)]
    local procedure OnBeforeTransferOrderPostShipment(var TransferHeader: Record "Transfer Header")
    var
        Location: record Location;
        ContinuePostingQst: Label 'Transfer Order %1 is GIT and Shipment should be managed using Whse. Shipment document. Do you really want to continue?';
        AbortPostinrErr: Label 'Posting Transfer Order %1 canceled.';
    begin
        if not TransferHeader."MICA Action From Page" then
            exit;

        if not GuiAllowed() then
            exit;

        if not Location.get(TransferHeader."Transfer-from Code") then
            exit;

        if not Location."MICA 3PL Integration" then
            exit;

        if not Confirm(ContinuePostingQst, false, TransferHeader."No.") then
            Error(AbortPostinrErr, TransferHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure CheckDocOnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean)
    begin
        if PurchaseHeader."MICA Auto. Trans. Order" and (PurchaseHeader."MICA ETA" = 0D) then
            Error(ETAErr);
    end;

    var
        ETAErr: label 'ETA Date cannot be empty, Automatic Transfer Order Creation is enabled';

}