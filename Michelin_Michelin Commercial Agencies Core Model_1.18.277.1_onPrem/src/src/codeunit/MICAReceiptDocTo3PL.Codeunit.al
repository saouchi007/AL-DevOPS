codeunit 81380 "MICA Receipt Doc. To 3PL"
{
    trigger OnRun()
    begin
        Code();
    end;

    local procedure Code()
    var
        Location: Record Location;
    begin
        Location.SetRange(Location."Require Receive", true);

        if Location.FindSet() then
            repeat
                ProccesLocation(Location);
            until Location.Next() = 0;
    end;

    local procedure ProccesLocation(Location: Record Location)
    begin
        if FORMAT(Location."MICA Whse. Receipt Creat. Per.") = '' then
            exit;
        ProcessTransferOrder(Location);
        ProcessPurchaseOrder(Location);
        ProcessSalesReturnOrder(Location);
    end;

    procedure ProcessTransferOrder(Location: Record Location)
    var
        WarehouseRequest: Record "Warehouse Request";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TempMICAWhseContainerBuffer: Record "MICA Whse Container Buffer" temporary;
        WhseCreateSourceDocument: Codeunit "Whse.-Create Source Document";
        MICAWhseReceiptRelease: Codeunit "MICA Whse.-Receipt Release";
        HeaderCreated: Boolean;
    begin
        Clear(TempMICAWhseContainerBuffer);

        WarehouseRequest.SetRange("Source Type", Database::"Transfer Line");
        WarehouseRequest.SetRange("Source Subtype", 1);
        WarehouseRequest.SetRange("Location Code", Location.Code);
        WarehouseRequest.SetRange("Document Status", WarehouseRequest."Document Status"::Released);
        WarehouseRequest.SetRange(Type, WarehouseRequest.Type::Inbound);
        WarehouseRequest.SetRange("Source Document", WarehouseRequest."Source Document"::"Inbound Transfer");

        Clear(WarehouseReceiptHeader);

        if not WarehouseRequest.FindSet() then
            exit;

        if not TransferHeader.Get(WarehouseRequest."Source No.") then
            exit;
        if TransferHeader."MICA ETA" = 0D then
            if TransferHeader."Receipt Date" > CalcDate(Location."MICA Whse. Receipt Creat. Per.", Today()) then
                exit;
        if TransferHeader."MICA ETA" > CalcDate(Location."MICA Whse. Receipt Creat. Per.", Today()) then
            exit;

        repeat
            TransferLine.SetRange("Document No.", WarehouseRequest."Source No.");
            TransferLine.Setrange("Derived From Line No.", 0);
            TransferLine.SetFilter("Qty. in Transit", '<>0');
            TransferLine.SetRange("Transfer-to Code", Location.Code);
            if TransferLine.FindSet() then begin
                repeat
                    if WhseCreateSourceDocument.CheckIfTransLine2ReceiptLine(TransferLine) then begin
                        if TempMICAWhseContainerBuffer.Get(TransferLine."MICA Container ID") then
                            WarehouseReceiptHeader.Get(TempMICAWhseContainerBuffer."Whse Receipt Header No.")
                        else begin
                            CreateReceiptHeader(WarehouseReceiptHeader, WarehouseRequest, Location, HeaderCreated);
                            WarehouseReceiptHeader."MICA Container ID" := TransferLine."MICA Container ID";
                            WarehouseReceiptHeader.Modify();
                            TempMICAWhseContainerBuffer.Init();
                            TempMICAWhseContainerBuffer."MICA Container ID" := TransferLine."MICA Container ID";
                            TempMICAWhseContainerBuffer."Whse Receipt Header No." := WarehouseReceiptHeader."No.";
                            TempMICAWhseContainerBuffer.Insert();
                        end;

                        if WhseCreateSourceDocument.TransLine2ReceiptLine(WarehouseReceiptHeader, TransferLine) then;
                        //error msg?
                        UpdateReceiptHeaderStatus(WarehouseReceiptHeader);
                    end;
                until TransferLine.Next() = 0;
                if HeaderCreated then begin
                    Clear(WarehouseReceiptHeader);
                    HeaderCreated := false;
                end;
            end;
        until WarehouseRequest.Next() = 0;

        if TempMICAWhseContainerBuffer.FindSet() then
            repeat
                WarehouseReceiptHeader.Get(TempMICAWhseContainerBuffer."Whse Receipt Header No.");
                MICAWhseReceiptRelease.Release(WarehouseReceiptHeader);
            until TempMICAWhseContainerBuffer.Next() = 0;

    end;

    local procedure ProcessPurchaseOrder(Location: Record Location)
    var
        WarehouseRequest: Record "Warehouse Request";
    begin
        WarehouseRequest.SetRange("Source Type", Database::"Purchase Line");
        WarehouseRequest.SetRange("Source Subtype", 1);
        WarehouseRequest.SetRange("Location Code", Location.Code);
        WarehouseRequest.SetFilter("Expected Receipt Date", '<=%1',
                                    CalcDate(Location."MICA Whse. Receipt Creat. Per.", Today()));
        WarehouseRequest.SetRange("Document Status", WarehouseRequest."Document Status"::Released);
        WarehouseRequest.SetRange(Type, WarehouseRequest.Type::Inbound);
        WarehouseRequest.SetRange("Source Document", WarehouseRequest."Source Document"::"Purchase Order");

        //Clear(WarehouseReceiptHeader);
        //HeaderCreated := false;

        if WarehouseRequest.FindSet() then
            repeat
                ProcessPurchaseWarehouseRequest(WarehouseRequest);
            until WarehouseRequest.Next() = 0;
    end;

    local procedure CreateReceiptHeader(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseRequest: Record "Warehouse Request"; Location: Record Location; var WhseHeaderCreated: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        WarehouseReceiptHeader.Init();
        WarehouseReceiptHeader."No." := '';
        WarehouseReceiptHeader."Location Code" := WarehouseRequest."Location Code";
        if Location.Code = WarehouseReceiptHeader."Location Code" then
            WarehouseReceiptHeader."Bin Code" := Location."Receipt Bin Code";
        WarehouseReceiptHeader."Vendor Shipment No." := WarehouseRequest."External Document No.";

        if ((WarehouseRequest.Type = WarehouseRequest.Type::Inbound) and (WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Sales Return Order")) then begin
            SalesHeader.Get(SalesHeader."Document Type"::"Return Order", WarehouseRequest."Source No.");
            WarehouseReceiptHeader."MICA Return Order With Collect" := SalesHeader."MICA Return Order With Collect";
            WarehouseReceiptHeader."MICA Retrieve-From Addr. Code" := SalesHeader."MICA Retrieve-From Addr. Code";
            WarehouseReceiptHeader."MICA Retrieve-From Address" := SalesHeader."MICA Retrieve-From Address";
        end;

        //WhseReceiptLine.LOCKTABLE;
        WarehouseReceiptHeader.INSERT(TRUE);
        WhseHeaderCreated := TRUE;
        Commit();
    end;

    local procedure UpdateReceiptHeaderStatus(WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        with WarehouseReceiptHeader do begin
            if "No." = '' then
                exit;
            Validate("Document Status", GetHeaderStatus(0));
            Modify(true);
        end;
    end;

    procedure ProcessPurchaseWarehouseRequest(WarehouseRequest: Record "Warehouse Request")
    var
        //PurchaseHeader: Record "Purchase Header";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        PurchaseLine: Record "Purchase Line";
        Location: Record Location;
        WhseCreateSourceDocument: codeunit "Whse.-Create Source Document";
        MICAWhseReceiptRelease: Codeunit "MICA Whse.-Receipt Release";
        HeaderCreated: Boolean;
    begin
        HeaderCreated := false;
        Location.Get(WarehouseRequest."Location Code");
        if Location."Require Receive" = false then
            exit;
        if FORMAT(Location."MICA Whse. Receipt Creat. Per.") = '' then
            exit;
        PurchaseLine.SetRange("Document No.", WarehouseRequest."Source No.");
        PurchaseLine.SetRange("Location Code", Location.Code);
        PurchaseLine.SetFilter("Planned Receipt Date", '<=%1',
                                    CalcDate(Location."MICA Whse. Receipt Creat. Per.", Today()));
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SETRANGE("Drop Shipment", FALSE);
        PurchaseLine.SETRANGE("Job No.", '');
        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);

        if ((WarehouseRequest.Type = WarehouseRequest.Type::Inbound) AND
            (WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Purchase Order")) OR
           ((WarehouseRequest.Type = WarehouseRequest.Type::Outbound) AND
            (WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Purchase Return Order"))
        then
            PurchaseLine.SETFILTER("Outstanding Quantity", '>0')
        else
            PurchaseLine.SETFILTER("Outstanding Quantity", '<0');

        if PurchaseLine.FindSet() then begin
            repeat
                if WhseCreateSourceDocument.CheckIfPurchLine2ReceiptLine(PurchaseLine) then begin
                    if not HeaderCreated then
                        CreateReceiptHeader(WarehouseReceiptHeader, WarehouseRequest, Location, HeaderCreated);
                    if WhseCreateSourceDocument.PurchLine2ReceiptLine(WarehouseReceiptHeader, PurchaseLine) then;
                    //error msg?
                    if HeaderCreated then
                        UpdateReceiptHeaderStatus(WarehouseReceiptHeader);
                end;
            until PurchaseLine.Next() = 0;
            if HeaderCreated then begin
                MICAWhseReceiptRelease.Release(WarehouseReceiptHeader);
                Clear(WarehouseReceiptHeader);
                HeaderCreated := false;
            end;
        end;
    end;


    local procedure ProcessSalesReturnOrder(Location: Record Location)
    var
        WarehouseRequest: Record "Warehouse Request";
    begin
        WarehouseRequest.SetRange("Source Type", Database::"Sales Line");
        WarehouseRequest.SetRange("Source Subtype", 5);
        WarehouseRequest.SetRange("Location Code", Location.Code);
        WarehouseRequest.SetRange("Document Status", WarehouseRequest."Document Status"::Released);
        WarehouseRequest.SetRange(Type, WarehouseRequest.Type::Inbound);
        WarehouseRequest.SetRange("Source Document", WarehouseRequest."Source Document"::"Sales Return Order");
        if WarehouseRequest.FindSet() then
            repeat
                ProcessSalesReturnWarehouseRequest(WarehouseRequest);
            until WarehouseRequest.Next() = 0;
    end;

    procedure ProcessSalesReturnWarehouseRequest(WarehouseRequest: Record "Warehouse Request")
    var
        //SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        Location: Record Location;
        WhseCreateSourceDocument: codeunit "Whse.-Create Source Document";
        MICAWhseReceiptRelease: Codeunit "MICA Whse.-Receipt Release";
        HeaderCreated: Boolean;
    begin
        HeaderCreated := false;
        Location.Get(WarehouseRequest."Location Code");
        if Location."Require Receive" = false then
            exit;
        if FORMAT(Location."MICA Whse. Receipt Creat. Per.") = '' then
            exit;

        SalesLine.SetRange("Document No.", WarehouseRequest."Source No.");
        SalesLine.SetRange("Location Code", Location.Code);
        SalesLine.SetFilter("Shipment Date", '<=%1',
                                   CalcDate(Location."MICA Whse. Receipt Creat. Per.", Today()));
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SETRANGE("Drop Shipment", FALSE);
        SalesLine.SETRANGE("Job No.", '');
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Return Order");

        if ((WarehouseRequest.Type = WarehouseRequest.Type::Outbound) AND
            (WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Sales Order")) OR
           ((WarehouseRequest.Type = WarehouseRequest.Type::Inbound) AND
            (WarehouseRequest."Source Document" = WarehouseRequest."Source Document"::"Sales Return Order"))
        then
            SalesLine.SETFILTER("Outstanding Quantity", '>0')
        else
            SalesLine.SETFILTER("Outstanding Quantity", '<0');

        if SalesLine.FindSet() then begin
            repeat
                if WhseCreateSourceDocument.CheckIfSalesLine2ReceiptLine(SalesLine) then begin
                    if not HeaderCreated then
                        CreateReceiptHeader(WarehouseReceiptHeader, WarehouseRequest, Location, HeaderCreated);
                    if WhseCreateSourceDocument.SalesLine2ReceiptLine(WarehouseReceiptHeader, SalesLine) then;
                    //error msg?
                    if HeaderCreated then
                        UpdateReceiptHeaderStatus(WarehouseReceiptHeader);
                end;
            until SalesLine.Next() = 0;
            if HeaderCreated then begin
                MICAWhseReceiptRelease.Release(WarehouseReceiptHeader);
                Clear(WarehouseReceiptHeader);

                HeaderCreated := false;
            end;
        end;
    end;
}