codeunit 81420 "MICA Transport Event Integrat"
{
    //EDD-ITG-003: GIT – Transport Event Integration
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        WarehouseSetup: Record "Warehouse Setup";

    trigger OnRun()
    var
        MICAFlowEntry: Record "MICA Flow Entry";
    begin
        WarehouseSetup.Get();
        WarehouseSetup.TestField("MICA 3PL Transp.Event FlowCode");

        //>>Testing
        // FlowEntry.Init();
        // FlowEntry."Flow Code" := WhsSetup."MICA 3PL Transp.Event FlowCode";
        // FlowEntry."Receive Status" := FlowEntry."Receive Status"::Processed;
        // FlowEntry.Insert(true);
        //<<Testing

        MICAFlowEntry.SetRange("Flow Code", WarehouseSetup."MICA 3PL Transp.Event FlowCode");
        MICAFlowEntry.SetRange("Receive Status", MICAFlowEntry."Receive Status"::Processed);
        if MICAFlowEntry.FindSet(false) then begin
            repeat
                ProcessBuffer(MICAFlowEntry."Entry No.");
                MICAFlowEntry.Mark(true);
            until MICAFlowEntry.Next() = 0;
            MICAFlowEntry.SetRange("Receive Status");
            MICAFlowEntry.MarkedOnly(true);
            MICAFlowEntry.ModifyAll("Receive Status", MICAFlowEntry."Receive Status"::PostProcessed, true);
        end;
    end;

    local procedure ProcessBuffer(FlowEntryNo: Integer)
    var
        MICAFlowBuffReceiveTranspEv: Record "MICA FlowBuff Receive TranspEv";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
    begin
        //>>Testing
        // Buffer.Init();
        // Buffer.Document_No := '1002';
        // Buffer.SRD := Today() - 34;
        // Buffer.ETA := Today() - 4;
        // Buffer.Validate("Flow Entry No.", FlowEntryNo);
        // Buffer.Insert(true);
        //<<Testing

        MICAFlowBuffReceiveTranspEv.SetRange("Flow Entry No.", FlowEntryNo); //one Buffer line = one Transfer Header
        if MICAFlowBuffReceiveTranspEv.FindSet(false) then
            repeat
                if TransferHeader.Get(MICAFlowBuffReceiveTranspEv.Document_No) then begin
                    if MICAFlowBuffReceiveTranspEv.SRD = 0D then
                        CalcSRD(MICAFlowBuffReceiveTranspEv.SRD, MICAFlowBuffReceiveTranspEv.ETA);

                    ReleaseTransferDocument.Reopen(TransferHeader);
                    TransferHeader."MICA ETA" := MICAFlowBuffReceiveTranspEv.ETA;
                    TransferHeader."MICA SRD" := MICAFlowBuffReceiveTranspEv.SRD;
                    TransferHeader.Modify();

                    UpdateTransferLines();
                    UpdateTransferReceipt();
                end;
            until MICAFlowBuffReceiveTranspEv.Next() = 0;
    end;

    local procedure UpdateTransferReceipt()
    var
        TransferReceiptHeader: Record "Transfer Receipt Header";
        TransferReceiptLine: Record "Transfer Receipt Line";
    begin
        TransferReceiptHeader.SetRange("Transfer Order No.", TransferHeader."No.");
        if TransferReceiptHeader.FindSet(true) then
            repeat
                TransferReceiptHeader."MICA SRD" := TransferHeader."MICA SRD";
                TransferReceiptHeader."MICA ETA" := TransferHeader."MICA ETA";
                TransferReceiptHeader.Modify();
                TransferReceiptLine.SetRange("Document No.", TransferReceiptHeader."No.");
                if TransferReceiptLine.FindSet(true) then
                    repeat
                        TransferReceiptLine."MICA ETA" := TransferReceiptHeader."MICA ETA";
                        TransferReceiptLine."MICA SRD" := TransferReceiptHeader."MICA SRD";
                        TransferReceiptLine.Modify();
                    until TransferReceiptLine.Next() = 0;
            until TransferReceiptHeader.Next() = 0;
    end;


    local procedure UpdateTransferLines()
    var
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
    begin
        TransferLine.SetRange("Document No.", TransferHeader."No.");

        if TransferLine.FindSet(true) then begin
            repeat
                TransferLine."MICA ETA" := TransferHeader."MICA ETA";
                TransferLine."MICA SRD" := TransferHeader."MICA SRD";
                TransferLine.Modify();

                WarehouseReceiptLine.SetRange("Source Type", Database::"Transfer Line");
                WarehouseReceiptLine.SetRange("Source Subtype", 1);
                WarehouseReceiptLine.SetRange("Source No.", TransferLine."Document No.");
                if WarehouseReceiptLine.FindFirst() then
                    WarehouseReceiptLine.Mark(true);
            until TransferLine.Next() = 0;

            WarehouseReceiptLine.MarkedOnly(true);
            if WarehouseReceiptLine.FindSet(true) then
                repeat
                    WarehouseReceiptLine."MICA ETA" := TransferHeader."MICA ETA";
                    WarehouseReceiptLine."MICA SRD" := TransferHeader."MICA SRD";
                    WarehouseReceiptLine.Modify();
                    WarehouseReceiptHeader.Get(WarehouseReceiptLine."No.");
                    if (WarehouseReceiptHeader."MICA ETA" <> TransferHeader."MICA ETA") or (WarehouseReceiptHeader."MICA SRD" <> TransferHeader."MICA SRD") then begin
                        WarehouseReceiptHeader."MICA ETA" := TransferHeader."MICA ETA";
                        WarehouseReceiptHeader."MICA SRD" := TransferHeader."MICA SRD";
                        WarehouseReceiptHeader.Modify();
                    end;
                until WarehouseReceiptLine.Next() = 0;
        end;
    end;

    local procedure CalcSRD(var SRD: Date; ASN_ETA: Date)
    var
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CustomCalendarChange: Array[2] of Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
    begin
        if ASN_ETA <> 0D then begin
            CustomCalendarChange[1].SetSource(CustomizedCalendarChange."Source Type"::Location, TransferHeader."Transfer-from Code", '', '');
            CustomCalendarChange[2].SetSource(CustomizedCalendarChange."Source Type"::Location, TransferHeader."Transfer-from Code", '', '');
            SRD := CalendarManagement.CalcDateBOC('', ASN_ETA, CustomCalendarChange, true);
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateWhseDocuments', '', false, false)]
    local procedure PageTransferOrderOnAfterCreateWhseReceipt(var WhseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        if WhseReceiptHeader."No." <> '' then begin
            WhseReceiptHeader."MICA Status" := WhseReceiptHeader."MICA Status"::Released;
            WhseReceiptHeader.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateRcptHeader', '', false, false)]
    local procedure GetSsrcDocOnAfterCreateRcptHeader(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseRequest: Record "Warehouse Request")
    var
        LocTransferHeader: record "Transfer Header";
    begin
        if WarehouseRequest."Source Type" <> Database::"Transfer Line" then
            exit;
        if LocTransferHeader.get(WarehouseRequest."Source No.") then
            with WarehouseReceiptHeader do begin
                "MICA SRD" := LocTransferHeader."MICA SRD";
                "MICA ETA" := LocTransferHeader."MICA ETA";
                "MICA Container ID" := LocTransferHeader."MICA Container ID";
                "MICA Seal No." := LocTransferHeader."MICA Seal No.";
                "MICA Port of Arrival" := LocTransferHeader."MICA Port of Arrival";
                "MICA Carrier Doc. No." := LocTransferHeader."MICA Carrier Doc. No.";
                "MICA Maritime Air Company Name" := LocTransferHeader."MICA Maritime Air Company Name";
                "MICA Maritime Air Number" := LocTransferHeader."MICA Maritime Air Number";
                Modify(false);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnBeforeUpdateRcptLineFromTransLine', '', false, false)]
    local procedure WhseCreateSrcDocOnBeforeUpdateRcptLineFromTransLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; TransferLine: Record "Transfer Line")
    begin
        with WarehouseReceiptLine do begin
            "MICA Country of Origin" := TransferLine."MICA Country of Origin";
            "MICA ETA" := TransferLine."MICA ETA";
            "MICA Port of Arrival" := TransferLine."MICA Port of Arrival";
            "MICA Purchase Order Line No." := TransferLine."MICA Purchase Order Line No.";
            "MICA Purchase Order No." := TransferLine."MICA Purchase Order No.";
            "MICA Seal No." := TransferLine."MICA Seal No.";
            "MICA SRD" := TransferLine."MICA SRD";
            "MICA AL Line No." := TransferLine."MICA AL Line No.";
            "MICA AL No." := TransferLine."MICA AL No.";
            "MICA ASN Line No." := TransferLine."MICA ASN Line No.";
            "MICA ASN No." := TransferLine."MICA ASN No.";
            "MICA Carrier Doc. No." := TransferLine."MICA Carrier Doc. No.";
            "MICA Container ID" := TransferLine."MICA Container ID";
            "MICA Ctry. ISO Code/O. Manuf." := TransferLine."MICA Ctry. ISO Code/O. Manuf.";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure SalesLineOnAfterInsertEvent(var SalesLine: Record "Sales Line")
    begin
        SalesLine.Validate("MICA Delivery Date Modified", Today());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure t5746OnAfterCopyFromTransferHeader(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."MICA AL No." := TransferHeader."MICA AL No.";
        TransferReceiptHeader."MICA SRD" := TransferHeader."MICA SRD";
        TransferReceiptHeader."MICA ASN No." := TransferHeader."MICA ASN No.";
        TransferReceiptHeader."MICA ETA" := TransferHeader."MICA ETA";
        TransferReceiptHeader."MICA Container ID" := TransferHeader."MICA Container ID";
        TransferReceiptHeader."MICA Seal No." := TransferHeader."MICA Seal No.";
        TransferReceiptHeader."MICA Port of Arrival" := TransferHeader."MICA Port of Arrival";
        TransferReceiptHeader."MICA Carrier Doc. No." := TransferHeader."MICA Carrier Doc. No.";
        TransferReceiptHeader."MICA ASN Date" := TransferHeader."MICA ASN Date";
        TransferReceiptHeader."MICA Initial ETA" := TransferHeader."MICA Initial ETA";
        TransferReceiptHeader."MICA Initial SRD" := TransferHeader."MICA Initial SRD";
        TransferReceiptHeader."MICA Maritime Air Company Name" := TransferHeader."MICA Maritime Air Company Name";
        TransferReceiptHeader."MICA Maritime Air Number" := TransferHeader."MICA Maritime Air Number";
        TransferReceiptHeader."MICA Action From Page" := TransferHeader."MICA Action From Page";
        TransferReceiptHeader."MICA Vendor Order No." := TransferHeader."MICA Vendor Order No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure t5747OnAfterCopyFromTransferLine(var TransferReceiptLine: Record "Transfer Receipt Line"; TransferLine: Record "Transfer Line")
    begin
        TransferReceiptLine."MICA AL No." := TransferLine."MICA AL No.";
        TransferReceiptLine."MICA AL Line No." := TransferLine."MICA AL Line No.";
        TransferReceiptLine."MICA SRD" := TransferLine."MICA SRD";
        TransferReceiptLine."MICA ASN No." := TransferLine."MICA ASN No.";
        TransferReceiptLine."MICA ASN Line No." := TransferLine."MICA ASN Line No.";
        TransferReceiptLine."MICA ETA" := TransferLine."MICA ETA";
        TransferReceiptLine."MICA Container ID" := TransferLine."MICA Container ID";
        TransferReceiptLine."MICA Seal No." := TransferLine."MICA Seal No.";
        TransferReceiptLine."MICA Port of Arrival" := TransferLine."MICA Port of Arrival";
        TransferReceiptLine."MICA Carrier Doc. No." := TransferLine."MICA Carrier Doc. No.";
        TransferReceiptLine."MICA ASN Date" := TransferLine."MICA ASN Date";
        TransferReceiptLine."MICA Initial ETA" := TransferLine."MICA Initial ETA";
        TransferReceiptLine."MICA Initial SRD" := TransferLine."MICA Initial SRD";
        TransferReceiptLine."MICA Country of Origin" := TransferLine."MICA Country of Origin";
        TransferReceiptLine."MICA DC14" := TransferLine."MICA DC14";
        TransferReceiptLine."MICA Purchase Order No." := TransferLine."MICA Purchase Order No.";
        TransferReceiptLine."MICA Purchase Order Line No." := TransferLine."MICA Purchase Order Line No.";
        TransferReceiptLine."MICA Ship From Vendor" := TransferLine."MICA Ship From Vendor";
        TransferReceiptLine."MICA Shipment Line Num" := TransferLine."MICA Shipment Line Num";
        TransferReceiptLine."MICA Initial Shipment Date" := TransferLine."MICA Initial Shipment Date";

    end;

}