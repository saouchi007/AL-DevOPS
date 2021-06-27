codeunit 81040 "MICA Batch Job Exec"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        Code(Rec."Parameter String");
    end;

    procedure Code(ParameterString: text[250])
    var
        MICABatchJobExecutionSetup: Record "MICA Batch Job Execution Setup";
        SalesHeader: Record "Sales Header";
        NoSetupErrorLbl: Label 'Batch Job Setup does not Exists';
    begin
        if NOT MICABatchJobExecutionSetup.GET(ParameterString) then
            Error(NoSetupErrorLbl);

        SalesHeader.SetRange(SalesHeader.Status, SalesHeader.Status::Released);
        SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);

        SalesHeader.SetRange(SalesHeader."Completely Shipped", false);
        SalesHeader.SetFilter(SalesHeader."MICA Shipment", '<>%1', SalesHeader."MICA Shipment"::"3");

        if MICABatchJobExecutionSetup."Shipping agent" <> '' then
            SalesHeader.Setrange(SalesHeader."Shipping Agent Code", MICABatchJobExecutionSetup."Shipping agent");

        if MICABatchJobExecutionSetup.Location <> '' then
            SalesHeader.SetRange(SalesHeader."Location Code", MICABatchJobExecutionSetup.Location);

        if SalesHeader.FindSet() then
            repeat
                ProcessSalesHeader(SalesHeader, MICABatchJobExecutionSetup);
            until SalesHeader.Next() = 0;
    End;

    local procedure ProcessSalesHeader(SalesHeader: Record "Sales Header"; MICABatchJobExecutionSetup: record "MICA Batch Job Execution Setup")
    var
        SalesLine: Record "Sales Line";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseRequest: Record "Warehouse Request";
        WhseCreateSourceDocument: Codeunit "Whse.-Create Source Document";
    begin
        if NOT HasUnpostedLines(SalesHeader, MICABatchJobExecutionSetup, true) then
            exit;

        if NOT FindWarehouseRequestForSalesOrder(WarehouseRequest, SalesHeader) then
            exit;

        SalesLine.SETRANGE(SalesLine.Type, SalesLine.Type::Item);
        SalesLine.SetFilter(SalesLine."Shipment Date", '<=%1', CalcDate(MICABatchJobExecutionSetup.Period, MICABatchJobExecutionSetup."Ending date"));

        //General Sales Line filters for creating Wrhse shipment for order
        SalesLine.SETFILTER(SalesLine."Outstanding Quantity", '>0');
        SalesLine.SETRANGE(SalesLine."Drop Shipment", FALSE);
        SalesLine.SETRANGE(SalesLine."Job No.", '');
        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
        if MICABatchJobExecutionSetup.Location <> '' then
            SalesLine.SetRange(SalesLine."Location Code", MICABatchJobExecutionSetup.Location);
        SalesLine.SetRange(SalesLine."Document No.", SalesHeader."No.");

        if SalesLine.FindSet() then begin
            CreateWhseHeader(WarehouseRequest, WarehouseShipmentHeader);
            repeat
                WhseCreateSourceDocument.FromSalesLine2ShptLine(WarehouseShipmentHeader, SalesLine)
            until SalesLine.Next() = 0;

            if HasUnpostedLines(SalesHeader, MICABatchJobExecutionSetup, false) then begin
                SalesHeader."MICA Shipment" := SalesHeader."MICA Shipment"::"2";
                SalesHeader.Modify();
            end;
        end;
    end;

    local procedure FindWarehouseRequestForSalesOrder(VAR WarehouseRequest: Record "Warehouse Request"; SalesHeader: Record "Sales Header"): Boolean
    var
        GetSourceDocOutbound: Codeunit 5752;
    //Text003: label 'The warehouse shipment was not created because an open warehouse shipment exists for the Sales Header and Shipping Advice is %1.\\You must add the item(s) as new line(s) to the existing warehouse shipment or change Shipping Advice to Partial.';
    begin
        with SalesHeader do begin
            TESTFIELD(Status, Status::Released);
            if WhseShpmntConflict("Document Type".AsInteger(), "No.", "Shipping Advice".AsInteger()) then
                //ERROR(Text003, FORMAT("Shipping Advice"));
                exit(false);

            GetSourceDocOutbound.CheckSalesHeader(SalesHeader, TRUE);
            WarehouseRequest.SETRANGE(WarehouseRequest.Type, WarehouseRequest.Type::Outbound);
            WarehouseRequest.SetRange(WarehouseRequest."Source Type", DATABASE::"Sales Line");
            WarehouseRequest.SetRange(WarehouseRequest."Source Subtype", "Document Type");
            WarehouseRequest.SetRange(WarehouseRequest."Source No.", "No.");
            WarehouseRequest.SetRange(WarehouseRequest."Document Status", WarehouseRequest."Document Status"::Released);
            if WarehouseRequest.FindFirst() then
                exit(true);
            exit(false);
        end;
    end;

    local procedure CreateWhseHeader(var WarehouseRequest: Record "Warehouse Request"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        Location: Record Location;
    begin
        Location.Get(WarehouseRequest."Location Code");
        WarehouseShipmentHeader.INIT();
        WarehouseShipmentHeader."No." := '';
        WarehouseShipmentHeader."Location Code" := WarehouseRequest."Location Code";
        WarehouseShipmentHeader."Bin Code" := Location."Shipment Bin Code";
        WarehouseShipmentHeader."External Document No." := WarehouseRequest."External Document No.";
        WarehouseShipmentHeader.INSERT(TRUE);
    End;

    local procedure HasUnpostedLines(var SalesHeader: Record "Sales Header"; MICABatchJobExecutionSetup: record "MICA Batch Job Execution Setup"; CheckBatch: Boolean): Boolean
    var
        SalesLine: Record "Sales Line";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin

        if CheckBatch then begin
            SalesLine.SetFilter(SalesLine."Shipment Date", '<=%1', CalcDate(MICABatchJobExecutionSetup.Period, MICABatchJobExecutionSetup."Ending date"));
            if MICABatchJobExecutionSetup.Location <> '' then
                SalesLine.SetRange(SalesLine."Location Code", MICABatchJobExecutionSetup.Location);
        end;

        SalesLine.SetRange(SalesLine."Document Type", SalesHeader."Document Type");
        SalesLine.SetRange(SalesLine."Document No.", SalesHeader."No.");

        WarehouseShipmentLine.SetRange(WarehouseShipmentLine."Source Type", Database::"Sales Line");
        WarehouseShipmentLine.SetRange(WarehouseShipmentLine."Source Document", WarehouseShipmentLine."Source Document"::"Sales Order");

        if SalesLine.FindSet() then
            repeat
                WarehouseShipmentLine.SetRange(WarehouseShipmentLine."Source No.", SalesLine."Document No.");
                WarehouseShipmentLine.SetRange(WarehouseShipmentLine."Source Line No.", SalesLine."Line No.");
                if WarehouseShipmentLine.IsEmpty() then begin
                    SalesLine.CalcFields("Reserved Quantity");
                    if SalesLine.Quantity = SalesLine."Reserved Quantity" then
                        exit(true);
                end;
            until SalesLine.Next() = 0;

        if NOT CheckBatch then begin
            SalesHeader."MICA Shipment" := SalesHeader."MICA Shipment"::"3";
            SalesHeader.Modify();
        end;

        exit(false);
    end;
}