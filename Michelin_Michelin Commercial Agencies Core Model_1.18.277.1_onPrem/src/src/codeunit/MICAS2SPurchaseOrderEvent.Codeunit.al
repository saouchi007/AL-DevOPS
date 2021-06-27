codeunit 82783 "MICA S2SPurchaseOrderEvent"
{

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventPurchaseHeader(var Rec: Record "Purchase Header")
    var
        MICAS2SSOHeaderIntEvent: Record "MICA S2S P.Header Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;
        MICAS2SSOHeaderIntEvent.Init();
        MICAS2SSOHeaderIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SSOHeaderIntEvent.Validate("Source Event Type", MICAS2SSOHeaderIntEvent."Source Event Type"::Created);
        MICAS2SSOHeaderIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SSOHeaderIntEvent.Validate("Document No.", Rec."No.");
        MICAS2SSOHeaderIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventPurchaseHeader(var Rec: Record "Purchase Header")
    var
        MICAS2SSOHeaderIntEvent: Record "MICA S2S P.Header Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;

        MICAS2SSOHeaderIntEvent.Init();
        MICAS2SSOHeaderIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SSOHeaderIntEvent.Validate("Source Event Type", MICAS2SSOHeaderIntEvent."Source Event Type"::Updated);
        MICAS2SSOHeaderIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SSOHeaderIntEvent.Validate("Document No.", Rec."No.");
        MICAS2SSOHeaderIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventPurchaseHeader(var Rec: Record "Purchase Header")
    var
        MICAS2SSOHeaderIntEvent: Record "MICA S2S P.Header Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;

        MICAS2SSOHeaderIntEvent.Init();
        MICAS2SSOHeaderIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SSOHeaderIntEvent.Validate("Source Event Type", MICAS2SSOHeaderIntEvent."Source Event Type"::Deleted);
        MICAS2SSOHeaderIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SSOHeaderIntEvent.Validate("Document No.", Rec."No.");
        MICAS2SSOHeaderIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventPurchaseLine(var Rec: Record "Purchase Line")
    var
        MICAS2SPOLineIntEvent: Record "MICA S2S P.Line Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;

        MICAS2SPOLineIntEvent.Init();
        MICAS2SPOLineIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SPOLineIntEvent.Validate("Source Event Type", MICAS2SPOLineIntEvent."Source Event Type"::Created);
        MICAS2SPOLineIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SPOLineIntEvent.Validate("Document No.", Rec."Document No.");
        MICAS2SPOLineIntEvent.Validate("Line No.", Rec."Line No.");
        MICAS2SPOLineIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventPurchaseLine(var Rec: Record "Purchase Line")
    var
        MICAS2SPOLineIntEvent: Record "MICA S2S P.Line Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;

        MICAS2SPOLineIntEvent.Init();
        MICAS2SPOLineIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SPOLineIntEvent.Validate("Source Event Type", MICAS2SPOLineIntEvent."Source Event Type"::Updated);
        MICAS2SPOLineIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SPOLineIntEvent.Validate("Document No.", Rec."Document No.");
        MICAS2SPOLineIntEvent.Validate("Line No.", Rec."Line No.");
        MICAS2SPOLineIntEvent.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventPurchaseLine(var Rec: Record "Purchase Line")
    var
        MICAS2SPOLineIntEvent: Record "MICA S2S P.Line Int. Event";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if Rec.IsTemporary then
            exit;
        if IsNullGuid(Rec.SystemId) then
            exit;

        MICAS2SPOLineIntEvent.Init();
        MICAS2SPOLineIntEvent.Validate("Event Date Time", CurrentDateTime());
        MICAS2SPOLineIntEvent.Validate("Source Event Type", MICAS2SPOLineIntEvent."Source Event Type"::Deleted);
        MICAS2SPOLineIntEvent.Validate("Source Record ID", Rec.SystemId);
        MICAS2SPOLineIntEvent.Validate("Document No.", Rec."Document No.");
        MICAS2SPOLineIntEvent.Validate("Line No.", Rec."Line No.");
        MICAS2SPOLineIntEvent.Insert(true);
    end;
}