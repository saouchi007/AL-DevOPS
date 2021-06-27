codeunit 81780 "MICA SO Status Mgmt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MICA Split Line Management", 'OnReservedOnHand', '', false, false)]
    local procedure OnReservedOnHandSplitLineManagement(var SalesLine: Record "Sales Line")
    begin
        SalesLine.Validate("MICA Status", SalesLine."MICA Status"::"Reserve OnHand");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MICA Split Line Management", 'OnReservedInTransit', '', false, false)]
    local procedure OnReservedOnTransitSplitLineManagement(var SalesLine: Record "Sales Line")
    begin
        SalesLine.Validate("MICA Status", SalesLine."MICA Status"::"Reserve InTransit");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MICA Split Line Management", 'OnWaitingAllocation', '', false, false)]
    local procedure OnWaitingAllocationSplitLineManagement(var SalesLine: Record "Sales Line")
    begin
        SalesLine.Validate("MICA Status", SalesLine."MICA Status"::"Waiting Allocation");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterDeleteEvent', '', false, false)]
    local procedure T337OnAfterDeleteReservationEntry(var Rec: Record "Reservation Entry"; RunTrigger: Boolean)
    var
        SalesLine: Record "Sales Line";
        ReservationEntry: Record "Reservation Entry";
    begin
        if Rec."Source Type" = 37 then
            if SalesLine.Get(Rec."Source Subtype", Rec."Source ID", Rec."Source Ref. No.") then begin
                ReservationEntry.SetCurrentKey("Source Type", "Source Subtype", "Source ID", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
                ReservationEntry.SetRange("Source Type", 37);
                ReservationEntry.SetRange("Source Subtype", Rec."Source Subtype");
                ReservationEntry.SetRange("Source ID", Rec."Source ID");
                ReservationEntry.SetRange("Source Ref. No.", Rec."Source Ref. No.");
                if ReservationEntry.IsEmpty() then begin
                    SalesLine.Validate("MICA Status", SalesLine."MICA Status"::Open);
                    SalesLine.Modify();
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnBeforeModifyEvent', '', false, false)]
    local procedure T337OnBeforeModifyEvent(var Rec: Record "Reservation Entry"; VAR xRec: Record "Reservation Entry"; RunTrigger: Boolean)
    var
        ReservationEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
    begin
        if Rec."Source Type" = 37 then
            if ReservationEntry.Get(Rec."Entry No.") then
                if (ReservationEntry."Expected Receipt Date" > 0D) and (Rec."Expected Receipt Date" = 0D) then
                    if SalesLine.Get(Rec."Source Subtype", Rec."Source ID", Rec."Source Ref. No.") then begin
                        SalesLine.Validate("MICA Status", SalesLine."MICA Status"::"Reserve OnHand");
                        SalesLine.Modify();
                    end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostUpdateOrderLineOnBeforeInitTempSalesLineQuantities', '', false, false)]
    LOCAL procedure C80OnPostUpdateOrderLineOnBeforeInitTempSalesLineQuantities(VAR SalesHeader: Record "Sales Header"; VAR TempSalesLine: Record "Sales Line")
    begin
        if TempSalesLine."Quantity (Base)" = (TempSalesLine."Qty. Shipped (Base)" + TempSalesLine."Qty. to Ship (Base)") then
            TempSalesLine.Validate("MICA Status", TempSalesLine."MICA Status"::Closed);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertWarehouseShipmentLine(var Rec: Record "Warehouse Shipment Line"; RunTrigger: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        if (Rec."Source Type" = 37) and (Rec."Source Subtype" = 1) then
            if Rec."Qty. (Base)" = Rec."Qty. Shipped (Base)" then begin
                if SalesLine.Get(Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.") then begin
                    SalesLine.Validate("MICA Status", SalesLine."MICA Status"::Closed);
                    SalesLine.Modify();
                end;
            end else
                if SalesLine.Get(Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.") and (SalesLine."MICA Status" <> SalesLine."MICA Status"::"Send to Execution") then begin
                    SalesLine.Validate("MICA Status", SalesLine."MICA Status"::"Send to Execution");
                    SalesLine.Modify();
                end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        SalesReceivablesSetup.Get();
        if not SalesReceivablesSetup."MICA Optimize Archive Mgmt" or (Rec."MICA Status" <> Rec."MICA Status"::Closed) then begin
            Rec.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
            if (Rec."Quantity Shipped" = 0) and (Rec."MICA Status" > Rec."MICA Status"::"Waiting Allocation") then begin
                Rec.Validate("MICA Status", Rec."MICA Status"::"Reserve OnHand");
                Rec.Modify();
            end;

            if not (Rec."MICA Delete From Split Line") and (Rec."Document Type" = Rec."Document Type"::Order) then
                if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
                    ArchiveManagement.StoreSalesDocument(SalesHeader, false);

        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteWarehouseShipmentLine(var Rec: Record "Warehouse Shipment Line"; RunTrigger: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        if (Rec."Source Type" = 37) and (Rec."Source Subtype" = 1) then
            /*if SalesLn.Get(Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.") then begin
                SalesLn.Validate("MICA Status", SalesLn."MICA Status"::"Reserve OnHand");
                SalesLn.Modify();
            end;*/
            //if SalesLn."Qty. Shipped (Base)" <> 0 then
            if SalesLine.Get(Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.") then
                if SalesLine."MICA Status" <> SalesLine."MICA Status"::Closed then
                    if (Rec."Qty. (Base)" <> Rec."Qty. Shipped (Base)") then
                        if (Rec."Qty. Shipped (Base)" > 0) then begin
                            if Rec."MICA 3PL Qty. To Ship" <> Rec.Quantity then
                                if SalesLine.Quantity = SalesLine."Quantity Shipped" then
                                    SalesLine.Validate("MICA Status", SalesLine."MICA Status"::Closed)
                                else
                                    SalesLine.Validate("MICA Status", SalesLine."MICA Status"::"Waiting Allocation")
                            else
                                SalesLine.Validate("MICA Status", SalesLine."MICA Status"::"Reserve OnHand");
                            SalesLine.Modify();
                        end else begin
                            SalesLine.Validate("MICA Status", SalesLine."MICA Status"::"Reserve OnHand");
                            SalesLine.Modify();
                        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyWarehouseShipmentLine(var Rec: Record "Warehouse Shipment Line"; VAR xRec: Record "Warehouse Shipment Line"; RunTrigger: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        if Rec."Qty. (Base)" = Rec."Qty. Shipped (Base)" then
            if SalesLine.Get(Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.") then begin
                SalesLine.Validate("MICA Status", SalesLine."MICA Status"::Closed);
                SalesLine.Modify();
            end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteRecordSalesOrderSubform(var Rec: Record "Sales Line"; VAR AllowDelete: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if not AllowDelete then
            exit;
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec.TestField("MICA Cancel. Reason");
            if SalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.") then begin
                SalesLine.Validate("MICA Cancelled", true);
                SalesLine.Modify(false);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnBeforeSalesHeaderArchiveInsert', '', false, false)]
    local procedure OnBeforeSalesHeaderArchiveInsert(var SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header")
    begin
        SalesHeaderArchive."MICA Unique Webshop Doc. Id" := SalesHeader."SC Unique Webshop Document Id";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDocCUReleaseSalesDocument(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean; VAR LinesWereModified: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            if SalesLine.FindSet(true) then
                repeat
                    SalesLine.Validate("MICA Release Status Count", SalesLine."MICA Release Status Count" + 1);
                    SalesLine.Modify(true);
                until SalesLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeFinalizePosting', '', false, false)]
    local procedure OnBeforeFinalizePosting(var SalesHeader: Record "Sales Header"; var TempSalesLineGlobal: Record "Sales Line"; var EverythingInvoiced: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        SalesReceivablesSetup.Get();
        if not SalesReceivablesSetup."MICA Optimize Archive Mgmt" then
            exit;

        EverythingInvoiced := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure OnAfterFinalizePosting(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        SalesReceivablesSetup.Get();
        if not SalesReceivablesSetup."MICA Optimize Archive Mgmt" then
            exit;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet(true, false) then
            repeat
                if SalesLine."Quantity Shipped" = SalesLine.Quantity then begin
                    SalesLine."MICA Status" := SalesLine."MICA Status"::Closed;
                    SalesLine.Modify(false);
                end
            until SalesLine.Next() = 0;
    end;
}