codeunit 81823 "MICA Split SO Line Post&Print"
{

    var
        SalesReceivablesSetup: record "Sales & Receivables Setup";
        MICAGetSourceDocOutbound: Codeunit "MICA Get Source Doc. Outbound";
        ReleaseSalesDocument: Codeunit "Release Sales Document";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterPostWhseShipment', '', false, false)]
    local procedure OnAfterPostWhseShipment(var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        SalesHeader: Record "Sales Header";
        FoundWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: record "Warehouse Shipment Line";
        TempSalesHeader: Record "Sales Header" temporary;
    begin
        if not FoundWarehouseShipmentHeader.get(FoundWarehouseShipmentHeader."No.") then
            exit;
        FoundWarehouseShipmentHeader.DeleteRelatedLines();
        WarehouseShipmentLine.SetRange("No.", FoundWarehouseShipmentHeader."No.");
        if WarehouseShipmentLine.FindFirst() then
            repeat
                WarehouseShipmentLine.SuspendStatusCheck(true);
                if (WarehouseShipmentLine."Source Document" = WarehouseShipmentLine."Source Document"::"Sales Order") and SalesHeader.Get(SalesHeader."Document Type"::Order, WarehouseShipmentLine."Source No.") then
                    if not TempSalesHeader.get(TempSalesHeader."Document Type"::Order, SalesHeader."No.") then begin
                        TempSalesHeader.Init();
                        TempSalesHeader."Document Type" := TempSalesHeader."Document Type"::Order;
                        TempSalesHeader."No." := SalesHeader."No.";
                        TempSalesHeader.Insert(false);
                    end;
                WarehouseShipmentLine.Delete(true);
                DeleteRelatedActivityLines(WarehouseShipmentLine);
            until WarehouseShipmentLine.Next() = 0;
        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."MICA Auto Whse.Ship Part Post" then begin
            Clear(MICAGetSourceDocOutbound);
            if TempSalesHeader.FindSet() then
                repeat
                    SalesHeader.Get(TempSalesHeader."Document Type", TempSalesHeader."No.");
                    MICAGetSourceDocOutbound.CreateFromSalesOrderHideDialog(SalesHeader);
                until TempSalesHeader.Next() = 0;
        end;
    end;

    local procedure DeleteRelatedActivityLines(var WhseShipmentLine: Record "Warehouse Shipment Line")
    var
        WhseActivityHeader: Record "Warehouse Activity Header";
        WhseActivityLine: Record "Warehouse Activity Line";
        HeaderNo: Code[20];
    begin
        WhseActivityLine.SetCurrentKey("Activity Type", "No.", "Whse. Document Type", "Whse. Document No.", "Whse. Document Line No.");
        WhseActivityLine.SetRange("Whse. Document Type", WhseActivityLine."Whse. Document Type"::Shipment);
        WhseActivityLine.SetRange("Whse. Document No.", WhseShipmentLine."No.");
        WhseActivityLine.SetRange("Whse. Document Line No.", WhseShipmentLine."Line No.");
        if WhseActivityLine.FindFirst() then begin
            HeaderNo := WhseActivityLine."No.";
            WhseActivityLine.DeleteAll(true);
        end;
        if WhseActivityHeader.Get(WhseActivityHeader.Type::Pick, HeaderNo) then
            if not WhseActivityHeader.LineExist() then
                WhseActivityHeader.Delete(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20])
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        ToOpenSalesHeader: record "Sales Header";
        SalesLine: Record "Sales Line";
        MgtMICASplitSalesLine: Codeunit "MICA SplitSalesLine";
        MICAWhseEmailAfterPost: Codeunit "MICA Whse. Email After Post";
    begin
        if SalesShptHdrNo = '' then
            exit;
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;
        Clear(ReleaseSalesDocument);
        SalesShipmentLine.SetRange("Document No.", SalesShptHdrNo);
        SalesShipmentLine.SetFilter("Quantity (Base)", '<>%1', 0);
        if SalesShipmentLine.FindSet() then begin
            if ToOpenSalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
                repeat
                    if SalesLine.get(SalesLine."Document Type"::Order, SalesHeader."No.", SalesShipmentLine."Order Line No.") and
                    (SalesShipmentLine."Quantity (Base)" <> SalesLine."Quantity (Base)") then begin
                        if ToOpenSalesHeader.Status = ToOpenSalesHeader.Status::Released then
                            ReleaseSalesDocument.Reopen(ToOpenSalesHeader);
                        if SalesLine."MICA Inv. Discrepancy" then
                            MgtMICASplitSalesLine.AddSalesLine(SalesLine, false, false, SalesLine."Outstanding Qty. (Base)")
                        else
                            MgtMICASplitSalesLine.AddSalesLineAndSplit(SalesLine, true, SalesLine."Outstanding Qty. (Base)");
                    end;
                until SalesShipmentLine.Next() = 0;

                ReleaseSalesDocOpen(ToOpenSalesHeader);

                SalesReceivablesSetup.Get();
                if SalesReceivablesSetup."MICA Auto Whse.Ship Part Post" and not SalesLinePostedFromWhseShpt(SalesShptHdrNo) then begin
                    Clear(MICAGetSourceDocOutbound);
                    MICAGetSourceDocOutbound.CreateFromSalesOrderHideDialog(ToOpenSalesHeader);
                end;
            end;
            MICAWhseEmailAfterPost.SetSendSalesDocToWhseByEmail(SalesHeader, SalesShptHdrNo);
        end;
    end;

    local procedure ReleaseSalesDocOpen(var FromSalesHeader: Record "Sales Header")
    var
        Workflow: Record Workflow;
        WorkflowEnableSave: Boolean;
    begin
        if not (FromSalesHeader.Status = FromSalesHeader.Status::Open) then
            exit;

        Clear(ReleaseSalesDocument);
        SalesReceivablesSetup.Get();
        WorkflowEnableSave := false;
        if Workflow.Get(SalesReceivablesSetup."MICA Approval Workflow") then begin
            WorkflowEnableSave := Workflow.Enabled;
            if Workflow.Enabled = true then begin
                Workflow.Validate(Enabled, false);
                Workflow.Modify(true);
            end;
        end;
        ReleaseSalesDocument.ReleaseSalesHeader(FromSalesHeader, false);
        if WorkflowEnableSave = true then begin
            Workflow.Validate(Enabled, true);
            Workflow.Modify(true);
        end;
    end;

    local procedure SalesLinePostedFromWhseShpt(FromSalesShptHdrNo: Code[20]): Boolean
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
    begin
        With PostedWhseShipmentLine do begin
            SetCurrentKey("Posted Source No.", "Posting Date");
            SetRange("Posted Source No.", FromSalesShptHdrNo);
            SetRange("Posted Source Document", "Posted Source Document"::"Posted Shipment");
            exit(FindFirst());
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Warehouse Shipment", 'OnClosePageEvent', '', false, false)]
    local procedure WhseShipmentOnClosePageEvent(var Rec: Record "Warehouse Shipment Header")
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        if not WarehouseShipmentHeader.Get(Rec."No.") then
            exit;
        WarehouseShipmentLine.SetRange("No.", Rec."No.");
        if WarehouseShipmentLine.IsEmpty() then
            WarehouseShipmentHeader.delete(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostedWhseShptHeaderInsert', '', false, false)]
    local procedure WhsePostShipmentOnBeforePostedWhseShptHeaderInsert(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        with PostedWhseShipmentHeader do begin
            "MICA Ship to code" := WarehouseShipmentHeader."MICA Ship to code";
            "MICA Ship to City" := WarehouseShipmentHeader."MICA Ship to City";
            "MICA Ship to Name" := WarehouseShipmentHeader."MICA Ship to Name";
            "MICA Ship-to Address" := WarehouseShipmentHeader."MICA Ship-to Address";
            "MICA Customer Transport" := WarehouseShipmentHeader."MICA Customer Transport";
            "MICA 3PL Update Status" := WarehouseShipmentHeader."MICA 3PL Update Status";
            "MICA Rcv. Last Flow Entry No." := WarehouseShipmentHeader."MICA Rcv. Last Flow Entry No.";
            "MICA Send Last Flow Entry No." := WarehouseShipmentHeader."MICA Send Last Flow Entry No.";
            //"MICA Send Ack. Received" := WarehouseShipmentHeader."MICA Send Ack. Received";
        end;
    end;
}