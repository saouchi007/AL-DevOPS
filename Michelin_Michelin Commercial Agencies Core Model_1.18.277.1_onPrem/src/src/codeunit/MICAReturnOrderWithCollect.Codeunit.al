codeunit 81120 "MICA ReturnOrderWithCollect"
{
    Permissions = tabledata "Return Receipt Header" = RIMD;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterCreateWhseDocuments', '', false, false)]
    local procedure r5753OnOnAfterCreateWhseDocument(VAR WhseReceiptHeader: Record "Warehouse Receipt Header"; VAR WhseShipmentHeader: Record "Warehouse Shipment Header"; WhseHeaderCreated: Boolean)
    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        SalesHeader: Record "Sales Header";
    begin
        IF NOT WarehouseReceiptLine.Get(WhseReceiptHeader."No.", 10000) then
            exit;

        IF NOT SalesHeader.Get(SalesHeader."Document Type"::"Return Order", WarehouseReceiptLine."Source No.") then
            exit;

        WhseReceiptHeader."MICA Return Order With Collect" := SalesHeader."MICA Return Order With Collect";
        WhseReceiptHeader.Modify(false);
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeFinalizePosting', '', false, false)]
    local procedure c80OnRunOnBeforeFinalizePosting(VAR SalesHeader: Record "Sales Header"; var ReturnReceiptHeader: Record "Return Receipt Header")
    begin
        IF SalesHeader."No." = '' then
            Exit;

        If ReturnReceiptHeader."No." = '' then
            Exit;

        ReturnReceiptHeader."MICA Return Order With Collect" := SalesHeader."MICA Return Order With Collect";
        ReturnReceiptHeader.Modify();

    end;


}