codeunit 82782 "MICA S2SSalesOrderEvent"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Order Entity Buffer", 'OnAfterValidateEvent', 'Ship-to Code', false, false)]
    local procedure OnAfterValidateShiptoCodeSalesOrderEntityBufferTable(var Rec: Record "Sales Order Entity Buffer")
    begin
        Rec.UpdateShipToAddressId();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Order Entity Buffer", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateSelltoCustomerNoSalesOrderEntityBufferTable(var Rec: Record "Sales Order Entity Buffer")
    begin
        Rec.UpdateShipToAddressId();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Order Entity Buffer", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesOrderEntityBuffer(var Rec: Record "Sales Order Entity Buffer"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        Rec.UpdateShipToAddressId();
        Rec.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Order Entity Buffer", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesOrderEntityBuffer(var Rec: Record "Sales Order Entity Buffer"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        Rec.UpdateShipToAddressId();
        Rec.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Order Entity Buffer", 'OnAfterRenameEvent', '', false, false)]
    local procedure OnAfterRenameSalesOrderEntityBuffer(var Rec: Record "Sales Order Entity Buffer"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        Rec.UpdateShipToAddressId();
        Rec.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCodeSalesHeaderTable(var SalesHeader: Record "Sales Header"; var NoSeriesCode: Code[20])
    begin
        if (SalesHeader."No. Series" <> '') and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then
            NoSeriesCode := SalesHeader."No. Series";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order Line Entity", 'OnAfterGetRecordEvent', '', false, false)]
    local procedure OnAfterGetRecordEventSalesOrderLineEntityPage(var Rec: Record "Sales Invoice Line Aggregate")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if SalesHeader.GetBySystemId(Rec."Document Id") then
            if SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", Rec."Line No.") then begin
                Rec.Validate("MICA Planned Delivery Date", SalesLine."Planned Delivery Date");
                Rec.Validate("MICA Planned Shipment Date", SalesLine."Planned Shipment Date");
                Rec.Validate("MICA Split Source line No.", SalesLine."MICA Split Source line No.");
                Rec.Validate("MICA Split Src Exp Ord Qty (b)", SalesLine."MICA Split Src Exp Ord Qty (b)");
                Rec.Validate("MICA Status", SalesLine."MICA Status");
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventSalesHeader(var Rec: Record "Sales Header")
    var
        MICAS2SSHeaderIntEvent: Record "MICA S2S S.Header Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;
        MICAS2SSHeaderIntEvent.Init();
        MICAS2SSHeaderIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SSHeaderIntEvent.Validate("Source Event Type", MICAS2SSHeaderIntEvent."Source Event Type"::Created);
        MICAS2SSHeaderIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SSHeaderIntEvent.Validate("Document No.", Rec."No.");
        MICAS2SSHeaderIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventSalesHeader(var Rec: Record "Sales Header")
    var
        MICAS2SSHeaderIntEvent: Record "MICA S2S S.Header Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;
        MICAS2SSHeaderIntEvent.Init();
        MICAS2SSHeaderIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SSHeaderIntEvent.Validate("Source Event Type", MICAS2SSHeaderIntEvent."Source Event Type"::Updated);
        MICAS2SSHeaderIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SSHeaderIntEvent.Validate("Document No.", Rec."No.");
        MICAS2SSHeaderIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventSalesHeader(var Rec: Record "Sales Header")
    var
        MICAS2SSHeaderIntEvent: Record "MICA S2S S.Header Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;
        MICAS2SSHeaderIntEvent.Init();
        MICAS2SSHeaderIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SSHeaderIntEvent.Validate("Source Event Type", MICAS2SSHeaderIntEvent."Source Event Type"::Deleted);
        MICAS2SSHeaderIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SSHeaderIntEvent.Validate("Document No.", Rec."No.");
        MICAS2SSHeaderIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventSalesLine(var Rec: Record "Sales Line")
    var
        MICAS2SSLineIntEvent: Record "MICA S2S S.Line Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;
        MICAS2SSLineIntEvent.Init();
        MICAS2SSLineIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SSLineIntEvent.Validate("Source Event Type", MICAS2SSLineIntEvent."Source Event Type"::Created);
        MICAS2SSLineIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SSLineIntEvent.Validate("Document No.", Rec."Document No.");
        MICAS2SSLineIntEvent.Validate("Line No.", Rec."Line No.");
        MICAS2SSLineIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventSalesLine(var Rec: Record "Sales Line")
    var
        MICAS2SSLineIntEvent: Record "MICA S2S S.Line Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;
        MICAS2SSLineIntEvent.Init();
        MICAS2SSLineIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SSLineIntEvent.Validate("Source Event Type", MICAS2SSLineIntEvent."Source Event Type"::Updated);
        MICAS2SSLineIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SSLineIntEvent.Validate("Document No.", Rec."Document No.");
        MICAS2SSLineIntEvent.Validate("Line No.", Rec."Line No.");
        MICAS2SSLineIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventSalesLine(var Rec: Record "Sales Line")
    var
        MICAS2SSLineIntEvent: Record "MICA S2S S.Line Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;
        MICAS2SSLineIntEvent.Init();
        MICAS2SSLineIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SSLineIntEvent.Validate("Source Event Type", MICAS2SSLineIntEvent."Source Event Type"::Deleted);
        MICAS2SSLineIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SSLineIntEvent.Validate("Document No.", Rec."Document No.");
        MICAS2SSLineIntEvent.Validate("Line No.", Rec."Line No.");
        MICAS2SSLineIntEvent.Insert(true);
    end;
}