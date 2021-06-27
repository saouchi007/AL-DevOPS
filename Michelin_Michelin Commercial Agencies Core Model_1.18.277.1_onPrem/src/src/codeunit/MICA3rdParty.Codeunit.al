codeunit 82920 "MICA 3rd Party"
{

    procedure GetOnHandQuantity(Location: Record Location; var SalesLine: Record "Sales Line") AvailableQuantity: Decimal
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::"Blanket Order");
        PurchaseHeader.SetRange("Buy-from Vendor No.", Location."MICA 3rd Party Vendor No.");
        PurchaseHeader.SetRange(Status, PurchaseHeader.Status::Released);
        if PurchaseHeader.FindFirst() then begin
            PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
            PurchaseLine.SetRange(Type, SalesLine.Type);
            PurchaseLine.SetRange("No.", SalesLine."No.");
            if PurchaseLine.FindSet() then
                repeat
                    AvailableQuantity += PurchaseLine.GetAvailableQuantity()
                until PurchaseLine.Next() = 0;
        end;
        if AvailableQuantity >= SalesLine."Quantity (Base)" then
            AvailableQuantity := SalesLine."Quantity (Base)";
    end;

    procedure Reservation3rdParty(Location: Record Location; var SalesLine: Record "Sales Line")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        MICA3rdPartyCommQtyDet: Record "MICA 3rd Party Comm. Qty. Det.";
        QuantityToCommit: Decimal;
        AvailableQuantity: Decimal;
    begin
        QuantityToCommit := SalesLine."Quantity (Base)";
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::"Blanket Order");
        PurchaseHeader.SetRange("Buy-from Vendor No.", Location."MICA 3rd Party Vendor No.");
        PurchaseHeader.SetRange(Status, PurchaseHeader.Status::Released);
        if not PurchaseHeader.FindFirst() then
            exit;
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", SalesLine."No.");
        if not PurchaseLine.FindSet() then
            exit;
        repeat
            AvailableQuantity := PurchaseLine.GetAvailableQuantity();
            Clear(MICA3rdPartyCommQtyDet);
            MICA3rdPartyCommQtyDet.Init();
            MICA3rdPartyCommQtyDet.Validate("Blanket Purch. Order Doc. No.", PurchaseLine."Document No.");
            MICA3rdPartyCommQtyDet.Validate("Blanket Purch. Order Line No.", PurchaseLine."Line No.");
            MICA3rdPartyCommQtyDet.Validate("Item No.", PurchaseLine."No.");
            MICA3rdPartyCommQtyDet.Validate("Original Line", PurchaseLine."MICA Original Line No.");
            MICA3rdPartyCommQtyDet.Validate("Sales Order No.", SalesLine."Document No.");
            MICA3rdPartyCommQtyDet.Validate("Sales Order Line No.", SalesLine."Line No.");
            if AvailableQuantity < QuantityToCommit then
                MICA3rdPartyCommQtyDet.Validate("Commited Qty.", AvailableQuantity)
            else
                MICA3rdPartyCommQtyDet.Validate("Commited Qty.", QuantityToCommit);
            if MICA3rdPartyCommQtyDet."Commited Qty." > 0 then
                MICA3rdPartyCommQtyDet.Insert(true);
            QuantityToCommit -= AvailableQuantity;
        until (PurchaseLine.Next() = 0) or (QuantityToCommit <= 0);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventPurchaseLine(var Rec: Record "Purchase Line")
    var
        MICA3rdPartyCommQtyDet: Record "MICA 3rd Party Comm. Qty. Det.";
    begin
        if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then begin
            MICA3rdPartyCommQtyDet.SetCurrentKey("Blanket Purch. Order Doc. No.", "Blanket Purch. Order Line No.");
            MICA3rdPartyCommQtyDet.SetRange("Blanket Purch. Order Doc. No.", Rec."Document No.");
            MICA3rdPartyCommQtyDet.SetRange("Blanket Purch. Order Line No.", Rec."Line No.");
            MICA3rdPartyCommQtyDet.DeleteAll(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventSalesLine(var Rec: Record "Sales Line")
    var
        MICA3rdPartyCommQtyDet: Record "MICA 3rd Party Comm. Qty. Det.";
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            MICA3rdPartyCommQtyDet.SetCurrentKey("Sales Order No.", "Sales Order Line No.");
            MICA3rdPartyCommQtyDet.SetRange("Sales Order No.", Rec."Document No.");
            MICA3rdPartyCommQtyDet.SetRange("Sales Order Line No.", Rec."Line No.");
            MICA3rdPartyCommQtyDet.DeleteAll(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNoSalesLine(var Rec: Record "Sales Line")
    var
        Item: Record Item;
    begin
        if Rec.Type = Rec.Type::Item then begin
            if Item.Get(Rec."No.") then
                Rec.Validate("MICA CAI", Item."No. 2")
            else
                Rec.Validate("MICA CAI", '');
        end else
            Rec.Validate("MICA CAI", '');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnAfterValidateLocationCodeSalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        Location: Record Location;
        Purchasing: Record Purchasing;
    begin
        if not Location.Get(Rec."Location Code") then
            exit;
        if Location."MICA Commitment Type" = Location."MICA Commitment Type"::"Third Party" then begin
            Purchasing.SetRange("Drop Shipment", true);
            if Purchasing.FindFirst() then begin
                Rec.Validate("Purchasing Code", Purchasing.Code);
                if (Rec."MICA Splitted Line" = false) then
                    Rec.Validate("Drop Shipment", false);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesLine(var Rec: Record "Sales Line")
    var
        Location: Record Location;
        Purchasing: Record Purchasing;
    begin
        if (Rec."Document Type" = Rec."Document Type"::Order) and (Rec."MICA Splitted Line" = false) then
            if Location.Get(Rec."Location Code") then
                if Location."MICA Commitment Type" = Location."MICA Commitment Type"::"Third Party" then begin
                    Purchasing.SetRange("Drop Shipment", true);
                    if Purchasing.FindFirst() then begin
                        Rec.Validate("Purchasing Code", Purchasing.Code);
                        Rec.Validate("Drop Shipment", false);
                    end;
                end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnReleaseSalesOrder(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        Location: Record Location;
        ReqWkshTemplate: Record "Req. Wksh. Template";
        ReqWkshTemplateName: Text;
        RequisitionWkshNameLbl: Label 'THIRDPARTY', Locked = true;
    begin
        ReqWkshTemplateName := 'REQ.';
        if not Location.Get(SalesHeader."Location Code") then
            exit;
        if Location."MICA Commitment Type" = Location."MICA Commitment Type"::"Third Party" then begin
            if not ReqWkshTemplate.Get(ReqWkshTemplateName) then begin
                ReqWkshTemplateName := 'REQ';
                if not ReqWkshTemplate.Get(ReqWkshTemplateName) then begin
                    ReqWkshTemplate.Init();
                    ReqWkshTemplate.Validate(Name, ReqWkshTemplateName);
                    ReqWkshTemplate.Validate("Page ID", 291);
                    ReqWkshTemplate.Validate(Type, ReqWkshTemplate.Type::"Req.");
                    ReqWkshTemplate.Insert(true);
                end;
            end;
            CreateRequisitionWksh(ReqWkshTemplateName, RequisitionWkshNameLbl);

            ClearRequisitionLine(ReqWkshTemplateName, RequisitionWkshNameLbl);

            InitRequisitionLine(ReqWkshTemplateName, RequisitionWkshNameLbl, SalesHeader);

            CarryOutRequisitionLine(ReqWkshTemplateName, RequisitionWkshNameLbl);

            UpdateSalesLine(SalesHeader)
        end;
    end;

    local procedure CarryOutActionMsg(RequisitionLine: Record "Requisition Line")
    var
        CarryOutActionMsgReq: Report "Carry Out Action Msg. - Req.";
    begin
        CarryOutActionMsgReq.SetReqWkshLine(RequisitionLine);
        CarryOutActionMsgReq.UseRequestPage(false);
        CarryOutActionMsgReq.RunModal();
        CarryOutActionMsgReq.GetReqWkshLine(RequisitionLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchaseLine(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        Rec.CalcFields("MICA 3rd Party");
        if Rec."MICA 3rd Party" and (Rec."MICA Original Line No." <> Rec."Line No.") then
            Rec.TransfertCAI(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyPurchaseLine(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    begin
        if RunTrigger then begin
            Rec.CalcFields("MICA 3rd Party");
            if Rec."MICA 3rd Party" then
                Rec.TransfertCAI(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnAfterValidateLocationCode(var Rec: Record "Sales Header")
    var
        Location: Record Location;
    begin
        if Location.Get(Rec."Location Code") then
            Rec.Validate("MICA 3rd Party Vendor No.", Location."MICA 3rd Party Vendor No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', false, false)]
    local procedure OnAfterPostSalesLines(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        MICA3rdPartyCommQtyDet: Record "MICA 3rd Party Comm. Qty. Det.";
        ModifyMICA3rdPartyCommQtyDet: Record "MICA 3rd Party Comm. Qty. Det.";
        MICAArch3rdPartyComQty: Record "MICA Arch. 3rd Party Com. Qty.";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesLine: Record "Sales Line";
        ShipmentQuantity: Decimal;
    begin
        SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
        if SalesShipmentLine.FindSet() then
            repeat
                if SalesLine.Get(SalesLine."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.") then
                    if SalesLine.OrderIs3rdParty() then begin
                        MICA3rdPartyCommQtyDet.SetCurrentKey("Sales Order No.", "Sales Order Line No.");
                        MICA3rdPartyCommQtyDet.SetRange("Sales Order No.", SalesLine."Document No.");
                        MICA3rdPartyCommQtyDet.SetRange("Sales Order Line No.", SalesLine."Line No.");
                        ShipmentQuantity := SalesShipmentLine."Quantity (Base)";
                        if MICA3rdPartyCommQtyDet.FindSet() then
                            repeat
                                ModifyMICA3rdPartyCommQtyDet.Get(MICA3rdPartyCommQtyDet."Entry No.");
                                if ModifyMICA3rdPartyCommQtyDet."Commited Qty." > ShipmentQuantity then begin
                                    ModifyMICA3rdPartyCommQtyDet.Validate("Commited Qty.", ModifyMICA3rdPartyCommQtyDet."Commited Qty." - ShipmentQuantity);
                                    ModifyMICA3rdPartyCommQtyDet.Modify(true);
                                end else
                                    ModifyMICA3rdPartyCommQtyDet.Delete(true);
                                Clear(MICAArch3rdPartyComQty);
                                MICAArch3rdPartyComQty.TransferFields(ModifyMICA3rdPartyCommQtyDet);
                                MICAArch3rdPartyComQty."Entry No." := 0;
                                MICAArch3rdPartyComQty.Insert(true);
                                ShipmentQuantity -= MICAArch3rdPartyComQty."Commited Qty.";
                            until (MICA3rdPartyCommQtyDet.Next() = 0) or (ShipmentQuantity <= 0);
                    end;
            until SalesShipmentLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        FindPurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        MICA3rdPartyCommQtyDet: Record "MICA 3rd Party Comm. Qty. Det.";
        MICAArch3rdPartyComQty: Record "MICA Arch. 3rd Party Com. Qty.";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
        ArchiveManagement: Codeunit ArchiveManagement;
        QuantityToDispatch: Decimal;
        FirstWasUse: Boolean;
        QuantityMissingErr: label 'A quantity of %1 is missing for item %2';
        MissingItemErr: label 'The item %1 is missing';
    begin
        if PurchaseHeader."MICA 3rd Party" and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Blanket Order") then begin
            FindPurchaseHeader.SetRange("Document Type", FindPurchaseHeader."Document Type"::"Blanket Order");
            FindPurchaseHeader.SetRange("MICA 3rd Party", true);
            FindPurchaseHeader.SetFilter("No.", '<>%1', PurchaseHeader."No.");
            FindPurchaseHeader.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
            FindPurchaseHeader.SetRange(Status, FindPurchaseHeader.Status::Released);
            if FindPurchaseHeader.FindSet() then
                repeat
                    MICA3rdPartyCommQtyDet.SetRange("Blanket Purch. Order Doc. No.", FindPurchaseHeader."No.");
                    if MICA3rdPartyCommQtyDet.FindSet() then
                        repeat
                            QuantityToDispatch := MICA3rdPartyCommQtyDet."Commited Qty.";
                            FirstWasUse := false;
                            PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                            PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                            PurchaseLine.SetRange("No.", MICA3rdPartyCommQtyDet."Item No.");
                            if PurchaseLine.FindSet() then
                                repeat
                                    if PurchaseLine."Quantity (Base)" >= QuantityToDispatch then begin
                                        MICA3rdPartyCommQtyDetOnRelease(MICA3rdPartyCommQtyDet, PurchaseLine, FirstWasUse, QuantityToDispatch);
                                        QuantityToDispatch := 0;
                                    end else begin
                                        MICA3rdPartyCommQtyDetOnRelease(MICA3rdPartyCommQtyDet, PurchaseLine, FirstWasUse, PurchaseLine."Quantity (Base)");
                                        QuantityToDispatch -= PurchaseLine."Quantity (Base)";
                                    end;
                                until (PurchaseLine.Next() = 0) or (QuantityToDispatch = 0);
                            if QuantityToDispatch > 0 then
                                Error(QuantityMissingErr, QuantityToDispatch, MICA3rdPartyCommQtyDet."Item No.");
                            MICAArch3rdPartyComQty.TransferFields(MICA3rdPartyCommQtyDet);
                            MICAArch3rdPartyComQty."Entry No." := 0;
                            MICAArch3rdPartyComQty.Insert(true);
                        until MICA3rdPartyCommQtyDet.Next() = 0;
                    if not MICA3rdPartyCommQtyDet.IsEmpty() then
                        Error(MissingItemErr, MICA3rdPartyCommQtyDet."Item No.");
                    ArchiveManagement.ArchivePurchDocument(FindPurchaseHeader);
                    PurchaseHeaderArchive.SetRange("Document Type", FindPurchaseHeader."Document Type");
                    PurchaseHeaderArchive.SetRange("No.", FindPurchaseHeader."No.");
                    if not PurchaseHeaderArchive.IsEmpty() then
                        FindPurchaseHeader.Delete(true);
                until FindPurchaseHeader.Next() = 0;
        end;

    end;

    local procedure MICA3rdPartyCommQtyDetOnRelease(MICA3rdPartyCommQtyDet: Record "MICA 3rd Party Comm. Qty. Det."; PurchaseLine: Record "Purchase Line"; var FirstWasUse: Boolean; Quantity: Decimal)
    var
        ModifyMICA3rdPartyCommQtyDet: Record "MICA 3rd Party Comm. Qty. Det.";
    begin
        if not FirstWasUse then
            ModifyMICA3rdPartyCommQtyDet.Get(MICA3rdPartyCommQtyDet."Entry No.")
        else
            ModifyMICA3rdPartyCommQtyDet.Init();
        ModifyMICA3rdPartyCommQtyDet.Validate("Commited Qty.", Quantity);
        ModifyMICA3rdPartyCommQtyDet.Validate("Blanket Purch. Order Doc. No.", PurchaseLine."Document No.");
        ModifyMICA3rdPartyCommQtyDet.Validate("Blanket Purch. Order Line No.", PurchaseLine."Line No.");
        ModifyMICA3rdPartyCommQtyDet.Validate("Original Line", PurchaseLine."Line No.");
        if not FirstWasUse then begin
            ModifyMICA3rdPartyCommQtyDet.Modify(true);
            FirstWasUse := true;
        end else
            ModifyMICA3rdPartyCommQtyDet.Insert(true);
    end;

    local procedure CreateRequisitionWksh(ReqWkshTemplateName: Text; Name: Text)
    var
        RequisitionWkshName: Record "Requisition Wksh. Name";
    begin
        if not RequisitionWkshName.Get(ReqWkshTemplateName, Name) then begin
            RequisitionWkshName.Init();
            RequisitionWkshName.Validate("Worksheet Template Name", ReqWkshTemplateName);
            RequisitionWkshName.Validate(Name, Name);
            RequisitionWkshName.Insert(true);
        end;
    end;

    local procedure InitRequisitionLine(ReqWkshTemplateName: Text; Name: Text; SalesHeader: Record "Sales Header")
    var
        RequisitionLine: Record "Requisition Line";
        SalesLine: Record "Sales Line";
        GetSalesOrder: Report "Get Sales Orders";
    begin
        RequisitionLine.Validate("Worksheet Template Name", ReqWkshTemplateName);
        RequisitionLine.Validate("Journal Batch Name", Name);
        GetSalesOrder.SetReqWkshLine(RequisitionLine, 0);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("Purch. Order Line No.", 0);
        SalesLine.SetFilter("Outstanding Quantity", '<> 0');
        GetSalesOrder.InitializeRequest(1);
        GetSalesOrder.SetTableView(SalesLine);
        GetSalesOrder.UseRequestPage(false);
        RequisitionLine.LockTable(true);
        GetSalesOrder.RunModal();
    end;

    local procedure ClearRequisitionLine(ReqWkshTemplateName: Text; Name: Text)
    var
        RequisitionLine: Record "Requisition Line";
    begin
        RequisitionLine.SetRange("Worksheet Template Name", ReqWkshTemplateName);
        RequisitionLine.SetRange("Journal Batch Name", Name);
        RequisitionLine.DeleteAll(true);
        RequisitionLine.Reset();
    end;

    local procedure CarryOutRequisitionLine(ReqWkshTemplateName: Text; Name: Text)
    var
        RequisitionLine: Record "Requisition Line";
    begin
        RequisitionLine.SetRange("Worksheet Template Name", ReqWkshTemplateName);
        RequisitionLine.SetRange("Journal Batch Name", Name);
        if RequisitionLine.FindFirst() then
            CarryOutActionMsg(RequisitionLine);
    end;

    local procedure UpdateSalesLine(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        PurchaseHeader: Record "Purchase Header";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
    begin
        SalesLine.Reset();
        Clear(SalesLine);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                SalesLine.Validate("MICA Status", SalesLine."MICA Status"::"Send to Execution");
                SalesLine.Modify(true);
            until SalesLine.Next() = 0;
        if SalesLine.FindSet() then
            repeat
                if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, SalesLine."Purchase Order No.") then
                    if PurchaseHeader.Status = PurchaseHeader.Status::Open then
                        ReleasePurchaseDocument.ReleasePurchaseHeader(PurchaseHeader, false);
            until SalesLine.Next() = 0;
    end;
}