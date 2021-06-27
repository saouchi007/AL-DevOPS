codeunit 81460 "MICA ASN Integration"
{
    //EDD-ITG-001: GIT – ASN Integration 
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        RcptHeader: Record "Purch. Rcpt. Header";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";

    trigger OnRun()
    var
        FlowEntry: Record "MICA Flow Entry";
    begin
        PurchSetup.Get();
        PurchSetup.TestField("MICA ASN Flow Code");
        FlowEntry.SetRange("Flow Code", PurchSetup."MICA ASN Flow Code");
        FlowEntry.SetRange("Receive Status", FlowEntry."Receive Status"::Processed);
        if FlowEntry.FindSet(false) then begin
            repeat
                ProcessBuffer(FlowEntry."Entry No.");
                FlowEntry.Mark(true);
            until FlowEntry.Next() = 0;
            FlowEntry.SetRange("Receive Status");
            FlowEntry.MarkedOnly(true);
            FlowEntry.ModifyAll("Receive Status", FlowEntry."Receive Status"::PostProcessed, true);
        end;
    end;

    local procedure ProcessBuffer(FlowEntryNo: Integer)
    var
        Buffer: Record "MICA FlowBuff Receive ASN Msg";
        Release: Codeunit "Release Purchase Document";
    begin
        Buffer.SetRange("Flow Entry No.", FlowEntryNo);
        if Buffer.FindSet(false) then begin
            repeat
                if PurchHeader."MICA ASN No." <> Buffer.No then begin
                    PurchHeader.SetRange("MICA ASN No.", Buffer.No);
                    if PurchHeader.FindFirst() then begin
                        if Buffer.SRD = 0D then
                            CalcSRD(Buffer.SRD, Buffer.ETA);

                        Release.Reopen(PurchHeader);
                        PurchHeader.SetHideValidationDialog(true);
                        PurchHeader.Validate("Posting Date", Buffer.ASN_Date);
                        PurchHeader.Validate("Document Date", Buffer.ASN_Date);
                        PurchHeader.Validate("Vendor Shipment No.", Buffer.No);
                        PurchHeader.Modify();
                        PurchHeader.Mark(true);
                        PurchLine.SetRange("MICA ASN No.", Buffer.No);
                        PurchLine.ModifyAll("Qty. to Receive", 0, true);
                    end;
                end;

                PurchLine.SetRange("MICA ASN Line No.", Buffer.Line_No);
                if PurchLine.FindFirst() then begin
                    PurchLine.Validate("Qty. to Receive", Buffer.Quantity);
                    PurchLine.Modify();
                    PurchLine.Mark(true);
                end;
            until Buffer.Next() = 0;

            PostPurchHeaders();

            TransferOrders();

            PurchHeader.Reset();
            PurchLine.Reset();
            RcptHeader.Reset();
            TransferHeader.Reset();
        end;
    end;

    local procedure CreateTransferHeader(RcptHdr: Record "Purch. Rcpt. Header"; RcptLine: Record "Purch. Rcpt. Line")
    var
        Buffer: Record "MICA FlowBuff Receive ASN Msg";
    begin
        PurchSetup.Get();
        Buffer.SetRange("Flow Code", PurchSetup."MICA ASN Flow Code");
        Buffer.SetRange(No, RcptLine."MICA ASN No.");
        Buffer.SetRange(Line_No, RcptLine."MICA ASN Line No.");
        if not Buffer.FindFirst() then
            Buffer.Init();
        with TransferHeader do begin
            Init();
            SetHideValidationDialog(true);
            Insert(true);
            Validate("Transfer-from Code", RcptLine."Location Code");
            Validate("Transfer-to Code", RcptLine."MICA Location-To Code");
            TestField("In-Transit Code");
            "MICA ASN No." := RcptLine."MICA ASN No.";
            "MICA ASN Date" := Buffer.ASN_Date;
            Validate("Posting Date", RcptHdr."Posting Date");
            "MICA Initial ETA" := Buffer.ETA;
            "MICA Initial SRD" := Buffer.SRD;
            "MICA ETA" := "MICA Initial ETA";
            "MICA SRD" := "MICA Initial SRD";
            if RcptHdr."MICA SRD" <> 0D then
                Validate("Receipt Date", RcptHdr."MICA SRD");
            "MICA Container ID" := RcptHdr."MICA Container ID";
            "MICA Seal No." := RcptHdr."MICA Seal No.";
            "MICA Port of Arrival" := RcptHdr."MICA Port of Arrival";
            "MICA Carrier Doc. No." := RcptHdr."MICA Carrier Doc. No.";
            Modify();
            Mark(true);
        end;
    end;

    local procedure CreateTransferLine(RcptLine: Record "Purch. Rcpt. Line"; RcptHdr: Record "Purch. Rcpt. Header")
    begin
        with TransferLine do begin
            Init();
            "Document No." := TransferHeader."No.";
            Validate("Item No.", RcptLine."No.");
            Validate(Quantity, RcptLine.Quantity);
            "MICA ASN No." := RcptLine."MICA ASN No.";
            "MICA ASN Line No." := RcptLine."MICA ASN Line No.";
            "MICA AL No." := RcptHeader."MICA AL No.";
            "MICA AL Line No." := RcptLine."MICA AL Line No.";
            "MICA Purchase Order No." := RcptLine."Order No.";
            "MICA Purchase Order Line No." := RcptLine."Order Line No.";
            if RcptLine."MICA Container ID" <> '' then
                "MICA Container ID" := RcptLine."MICA Container ID"
            else
                "MICA Container ID" := RcptHdr."MICA Container ID";
            "MICA ASN Date" := TransferHeader."MICA ASN Date";
            "MICA Initial ETA" := TransferHeader."MICA Initial ETA";
            "MICA Initial SRD" := TransferHeader."MICA Initial SRD";
            "MICA Seal No." := TransferHeader."MICA Seal No.";
            "MICA Port of Arrival" := TransferHeader."MICA Port of Arrival";
            "MICA Carrier Doc. No." := TransferHeader."MICA Carrier Doc. No.";
            "MICA Country of Origin" := RcptLine."MICA Country of Origin";
            "Shortcut Dimension 1 Code" := RcptLine."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := RcptLine."Shortcut Dimension 2 Code";
            "Dimension Set ID" := RcptLine."Dimension Set ID";
            "MICA DC14" := RcptLine."MICA DC14";
            "MICA Initial Shipment Date" := RcptLine."MICA Initial Shipment Date";
            "MICA Ctry. ISO Code/O. Manuf." := RcptLine."MICA Ctry. ISO Code/O. Manuf.";
            Insert(true);
        end;
    end;

    procedure CreateTransferOrder(RcptHdr: Record "Purch. Rcpt. Header"; ToDo: Option Create,Ship)  //call from Receipt Card and for internal use
                                                                                                    //Usage:
                                                                                                    //CreateTransferOrder(RcptHeader, 0); //Create Orders
                                                                                                    //CreateTransferOrder(RcptHeader, 1); //Ship Orders
    var
        RcptLine: Record "Purch. Rcpt. Line";
        Release: Codeunit "Release Transfer Document";
        Post: Codeunit "TransferOrder-Post Shipment";
        ReallocBackOrdMgt: Codeunit "MICA Realloc. BackOrder Mgt";
        TransHeaderCreated: Boolean;
    begin
        TransHeaderCreated := false;
        case ToDo of
            ToDo::Create:
                begin
                    RcptLine.Reset();
                    RcptLine.SetRange("MICA ASN No.", RcptHdr."MICA ASN No.");
                    RcptLine.SetFilter(Quantity, '>0');
                    if RcptLine.FindSet(false) then begin //Create one transfer header will *all* receipt line with same ASN No. (Issue 1140)
                        TransferHeader.Reset();
                        TransferHeader.SetRange("MICA ASN No.", RcptHdr."MICA ASN No.");
                        if not TransferHeader.FindFirst() then
                            CreateTransferHeader(RcptHdr, RcptLine);
                        repeat
                            RcptHdr.get(RcptLine."Document No.");
                            TransferLine.Reset();
                            TransferLine.SetRange("MICA ASN No.", RcptHdr."MICA ASN No.");
                            TransferLine.SetRange("MICA ASN Line No.", RcptLine."MICA ASN Line No.");
                            if not TransferLine.FindFirst() then
                                CreateTransferLine(RcptLine, RcptHdr);
                        until RcptLine.Next() = 0;

                    end else  //Create one transfer header for the Receipt Header
                        if RcptHdr."MICA Location-To Code" <> '' then begin
                            RcptLine.Reset();
                            RcptLine.SetRange("Document No.", RcptHdr."No.");
                            RcptLine.SetFilter(Quantity, '>0');
                            repeat
                                if not TransHeaderCreated then
                                    CreateTransferHeader(RcptHdr, RcptLine);
                                TransHeaderCreated := true;

                                TransferLine.Reset();
                                TransferLine.SetRange("MICA Purchase Order No.", RcptLine."Order No.");
                                TransferLine.SetRange("MICA Purchase Order Line No.", RcptLine."Order Line No.");
                                if not TransferLine.FindFirst() then
                                    CreateTransferLine(RcptLine, RcptHdr);
                            until RcptLine.Next() = 0;
                        end;
                end;
            ToDo::Ship:
                begin
                    TransferHeader.SetRange("MICA ASN No.");
                    TransferHeader.MarkedOnly(true);
                    if TransferHeader.FindSet() then
                        repeat
                            ReallocBackOrdMgt.CommitmentOnTransferOrderHeader(TransferHeader);

                            if TransferHeader.Status = TransferHeader.Status::Open then
                                Release.Run(TransferHeader);
                            Post.SetHideValidationDialog(true);
                            Post.Run(TransferHeader);
                        until TransferHeader.Next() = 0;
                end;
        end;
    end;

    local procedure TransferOrders()
    begin
        RcptHeader.MarkedOnly(true);
        if RcptHeader.FindSet(false) then
            repeat
                CreateTransferOrder(RcptHeader, 0); //Create Orders
            until RcptHeader.Next() = 0;
        CreateTransferOrder(RcptHeader, 1); //Ship Orders
    end;

    local procedure SplitPurchLines()
    var
        TempPurchLine: Record "Purchase Line" temporary;
        LastLineNo: Integer;
    begin
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindLast() then begin
            LastLineNo := PurchLine."Line No.";
            PurchLine.FindSet();
            repeat
                if (PurchLine."Outstanding Quantity" <> 0) and (PurchLine."Quantity Received" <> 0) then begin
                    LastLineNo += 10000;
                    TempPurchLine.init();
                    TempPurchLine.Validate("Document Type", PurchHeader."Document Type");
                    TempPurchLine.Validate("Document No.", PurchHeader."No.");
                    TempPurchLine.Validate("Line No.", LastLineNo);
                    TempPurchLine.insert(true);
                    TempPurchLine.Validate(Type, TempPurchLine.Type::Item);
                    TempPurchLine.Validate("No.", PurchLine."No.");
                    TempPurchLine.Validate(Quantity, PurchLine."Outstanding Quantity");
                    TempPurchLine.Validate("MICA AL No.", PurchLine."MICA AL No.");
                    TempPurchLine.Validate("MICA AL Line No.", PurchLine."MICA AL Line No.");
                    TempPurchLine.Validate("MICA Location-To Code", PurchLine."MICA Location-To Code");
                    TempPurchLine.Validate("MICA Record ID", PurchHeader.RecordId());
                    TempPurchLine.Validate("Location Code", PurchLine."Location Code");
                    TempPurchLine."MICA ASN No." := '';
                    TempPurchLine."MICA ASN Line No." := 0;
                    TempPurchLine."MICA Country of Origin" := '';
                    TempPurchLine."MICA Container ID" := '';
                    TempPurchLine."MICA ETA" := PurchLine."MICA ETA";
                    TempPurchLine."MICA Seal No." := '';
                    TempPurchLine."MICA Port of Arrival" := '';
                    TempPurchLine."MICA Carrier Doc. No." := '';
                    TempPurchLine."MICA DC14" := PurchLine."MICA DC14";
                    TempPurchLine."MICA Ctry. ISO Code/O. Manuf." := '';
                    TempPurchLine."MICA Initial Shipment Date" := PurchLine."MICA Initial Shipment Date";
                    TempPurchLine.Modify(true);
                    PurchLine.Validate(Quantity, PurchLine."Quantity Received");
                    PurchLine.Modify();
                end;
            until PurchLine.Next() = 0;

            if TempPurchLine.FindSet() then
                repeat
                    PurchLine := TempPurchLine;
                    PurchLine.Insert();
                until TempPurchLine.Next() = 0
        end;
    end;

    local procedure PostPurchHeaders()
    var
        Post: Codeunit "Purch.-Post";
        Release: Codeunit "Release Purchase Document";
    begin
        PurchLine.SetRange("MICA ASN No.");
        PurchLine.SetRange("MICA ASN Line No.");
        PurchLine.MarkedOnly(true);

        PurchHeader.SetRange("MICA ASN No.");
        PurchHeader.MarkedOnly(true);
        if PurchHeader.FindSet() then
            repeat
                PurchHeader.Invoice := false;
                PurchHeader.Receive := true;

                Post.Run(PurchHeader);

                if RcptHeader.Get(PurchHeader."Last Receiving No.") then
                    RcptHeader.Mark(true);

                Release.Reopen(PurchHeader);
                SplitPurchLines();

                Release.SetSkipCheckReleaseRestrictions();
                Release.ReleasePurchaseHeader(PurchHeader, false);
            until PurchHeader.Next() = 0;
    end;

    local procedure CalcSRD(var SRD: Date; ASN_ETA: Date)
    var
        CalChange: Record "Customized Calendar Change";
        CustomCalendarChange: Array[2] of Record "Customized Calendar Change";
        CalendarMgmt: Codeunit "Calendar Management";
    begin
        if ASN_ETA <> 0D then begin
            CustomCalendarChange[1].SetSource(CalChange."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", '', '');
            CustomCalendarChange[2].SetSource(CalChange."Source Type"::Location, PurchHeader."Location Code", '', '');
            SRD :=
              CalendarMgmt.CalcDateBOC('', ASN_ETA, CustomCalendarChange, TRUE);
        end;
        if SRD <> 0D then begin
            CustomCalendarChange[1].SetSource(CalChange."Source Type"::Location, PurchHeader."Location Code", '', '');
            CustomCalendarChange[2].SetSource(CalChange."Source Type"::Location, PurchHeader."Location Code", '', '');
            SRD :=
              CalendarMgmt.CalcDateBOC('', SRD, CustomCalendarChange, FALSE);
        end;
    end;
}