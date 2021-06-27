codeunit 81982 "MICA Flow Upd. Purch. Ord."
{
    TableNo = "MICA Flow Buffer ASN";

    trigger OnRun()
    begin
        ProcessData(Rec);
    end;

    local procedure ProcessData(MICAFlowBufferASN: Record "MICA Flow Buffer ASN"): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlowEntry: Record "MICA Flow Entry";
    begin
        UpdatePurchaseHeader(MICAFlowBufferASN, PurchaseHeader);
        UpdatePurchaseLines(MICAFlowBufferASN, PurchaseHeader);
        ReleasePurchaseHeader(PurchaseHeader);
        MICAFlowRecord.UpdateReceiveRecord(MICAFlowBufferASN."Flow Entry No.", PurchaseHeader.RecordId(), MICAFlowEntry."Receive Status"::Processed);
    end;

    local procedure UpdatePurchaseHeader(MICAFlowBufferASN: Record "MICA Flow Buffer ASN"; var PurchaseHeader: Record "Purchase Header")
    var
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        PurchaseHeaderLbl: Label '%1%2', Comment = '%1%2', Locked = true;
    Begin
        with PurchaseHeader do begin
            SetRange("Document Type", "Document Type"::Order);
            // SetRange("No.", Buffer."AL No.");
            SetRange("Completely Received", false);
            SetFilter("MICA AL No.", StrSubstNo(PurchaseHeaderLbl, CopyStr(MICAFlowBufferASN."AL No.", 1, 9), '*'));
            FindFirst();
            ReleasePurchaseDocument.PerformManualReopen(PurchaseHeader);
            "MICA ASN No." := CopyStr(MICAFlowBufferASN."Doc. ID", 1, MaxStrLen("MICA ASN No."));
            Validate("Vendor Shipment No.", MICAFlowBufferASN."Doc. ID");
            Validate("Document Date", DT2Date(MICAFlowBufferASN."Tech. Creation DateTime"));
            "MICA Container ID" := MICAFlowBufferASN."Container ID";
            "MICA ETA" := MICAFlowBufferASN.ETA;
            "MICA SRD" := CalcSRDDate(PurchaseHeader, MICAFlowBufferASN.ETA);
            "MICA Seal No." := CopyStr(MICAFlowBufferASN."Seal Number", 1, MaxStrLen("MICA Seal No."));
            "MICA Port of Arrival" := CopyStr(MICAFlowBufferASN."Arrival Port", 1, MaxStrLen("MICA Port of Arrival"));
            "MICA Carrier Doc. No." := CopyStr(MICAFlowBufferASN."Carrier Doc. No.", 1, MaxStrLen("MICA Carrier Doc. No."));
            "MICA Maritime Air Company Name" := CopyStr(MICAFlowBufferASN."Maritime Air Company Name", 1, MaxStrLen("MICA Maritime Air Company Name"));
            "MICA Maritime Air Number" := CopyStr(MICAFlowBufferASN."Maritime Air Number", 1, MaxStrLen("MICA Maritime Air Number"));
            Modify(true);
        end;
    End;

    local procedure UpdatePurchaseLines(MICAFlowBufferASN: Record "MICA Flow Buffer ASN"; PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        QtyToReceive: Decimal;
        PurchaseLineLbl: Label '%1%2', Comment = '%1%2', Locked = true;
    begin
        with PurchaseLine do begin
            SetRange("Document Type", "Document Type"::Order);
            SetRange("Document No.", PurchaseHeader."No.");
            SetFilter("MICA AL No.", StrSubstNo(PurchaseLineLbl, CopyStr(MICAFlowBufferASN."AL No.", 1, 9), '*'));
            SetRange("MICA AL Line No.", MICAFlowBufferASN."AL Line No.");
            SetFilter("Outstanding Qty. (Base)", '<>%1', 0);
            // SetFilter("Qty. Invoiced (Base)", '<>%1', 0);
            if FindFirst() then begin
                if "Qty. to Receive" = 0 then begin //Line not updated (1st update by ASN)
                    if MICAFlowBufferASN.Quantity >= Quantity then
                        Validate(Quantity, MICAFlowBufferASN.Quantity);
                    Validate("Qty. to Receive", MICAFlowBufferASN.Quantity);
                    UpdatePurchaseLineASNFields(PurchaseLine, PurchaseHeader, MICAFlowBufferASN);
                end else begin //Line already updated by ASN 
                    CreateAdditionalPurchaseLine(MICAFlowBufferASN, PurchaseLine, PurchaseHeader);
                    QtyToReceive := "Qty. to Receive";
                    Validate(Quantity, PurchaseLine.Quantity - MICAFlowBufferASN.Quantity);
                    Validate("Qty. to Receive", QtyToReceive);
                end;
                Modify(true);
            end;
        end;
    end;

    local procedure CreateAdditionalPurchaseLine(MICAFlowBufferASN: Record "MICA Flow Buffer ASN"; PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header")
    var
        CopiedPurchaseLine: Record "Purchase Line";
    begin
        CopiedPurchaseLine.Copy(PurchaseLine);
        CopiedPurchaseLine."Line No." := GetNextPurchLineNo(CopiedPurchaseLine);
        CopiedPurchaseLine.Validate(Quantity, MICAFlowBufferASN.Quantity);
        CopiedPurchaseLine.Validate("Qty. to Receive", MICAFlowBufferASN.Quantity);
        UpdatePurchaseLineASNFields(CopiedPurchaseLine, PurchaseHeader, MICAFlowBufferASN);
        CopiedPurchaseLine.Insert(true);
    end;

    local procedure UpdatePurchaseLineASNFields(var PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; MICAFlowBufferASN: Record "MICA Flow Buffer ASN")
    begin
        with PurchaseLine do begin
            "MICA ASN No." := CopyStr(MICAFlowBufferASN."Doc. ID", 1, MaxStrLen("MICA ASN No."));
            "MICA ASN Line No." := MICAFlowBufferASN."ASN Line Number";
            "MICA Country of Origin" := CopyStr(MICAFlowBufferASN."Country Code", 1, MaxStrLen("MICA Country of Origin"));
            "MICA Container ID" := MICAFlowBufferASN."Container ID";
            "MICA ETA" := MICAFlowBufferASN.ETA;
            "MICA SRD" := PurchaseHeader."MICA SRD";
            "MICA Seal No." := CopyStr(MICAFlowBufferASN."Seal Number", 1, MaxStrLen("MICA Seal No."));
            "MICA Port of Arrival" := CopyStr(MICAFlowBufferASN."Arrival Port", 1, MaxStrLen("MICA Port of Arrival"));
            "MICA Carrier Doc. No." := CopyStr(MICAFlowBufferASN."Carrier Doc. No.", 1, MaxStrLen("MICA Carrier Doc. No."));
            "MICA Initial Shipment Date" := DT2Date(MICAFlowBufferASN."Actual Ship DateTime");
            "MICA Ctry. ISO Code/O. Manuf." := CopyStr(MICAFlowBufferASN."Ctry. ISO Code Of Orig. Manuf.", 1, MaxStrLen("MICA Ctry. ISO Code/O. Manuf."));
        end;
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

    local procedure ReleasePurchaseHeader(var PurchaseHeader: Record "Purchase Header")
    var
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
    begin
        ReleasePurchaseDocument.PerformManualRelease(PurchaseHeader);
    End;

    local procedure CalcSRDDate(PurchaseHeader: Record "Purchase Header"; SRD: Date): Date
    var
        TransferRoute: Record "Transfer Route";
        ShippingAgentServices: Record "Shipping Agent Services";
    begin
        if not TransferRoute.Get(PurchaseHeader."Location Code", PurchaseHeader."MICA Location-To Code") then
            exit(0D);
        if (TransferRoute."Shipping Agent Code" <> '') and (TransferRoute."Shipping Agent Service Code" <> '') then
            ShippingAgentServices.Get(TransferRoute."Shipping Agent Code", TransferRoute."Shipping Agent Service Code");
        Exit(CalcDate(ShippingAgentServices."Shipping Time", SRD));
    End;
}