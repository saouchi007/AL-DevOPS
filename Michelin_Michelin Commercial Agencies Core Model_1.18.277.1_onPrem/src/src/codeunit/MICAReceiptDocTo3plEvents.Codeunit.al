codeunit 81381 "MICA ReceiptDocTo3pl Events"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReleasePurchaseDoc', '', false, false)]
    local procedure c415OnAfterReleasePurchaseDoc(VAR PurchaseHeader: Record "Purchase Header")
    var
        WarehouseRequest: Record "Warehouse Request";
        MICAReceiptDocTo3PL: Codeunit "MICA Receipt Doc. To 3PL";
    begin
        WarehouseRequest.SETRANGE(Type, WarehouseRequest.Type::Inbound);
        WarehouseRequest.SETRANGE("Source Type", DATABASE::"Purchase Line");
        WarehouseRequest.SETRANGE("Source Subtype", PurchaseHeader."Document Type");
        WarehouseRequest.SETRANGE("Source No.", PurchaseHeader."No.");
        WarehouseRequest.SETRANGE("Document Status", WarehouseRequest."Document Status"::Released);

        if WarehouseRequest.FindSet() then
            MICAReceiptDocTo3PL.ProcessPurchaseWarehouseRequest(WarehouseRequest);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure c414OnAfterReleaseSalesDoc(VAR SalesHeader: Record "Sales Header")
    var
        WarehouseRequest: Record "Warehouse Request";
        MICAReceiptDocTo3PL: Codeunit "MICA Receipt Doc. To 3PL";
    begin
        WarehouseRequest.SETRANGE(Type, WarehouseRequest.Type::Inbound);
        WarehouseRequest.SETRANGE("Source Type", DATABASE::"Sales Line");
        WarehouseRequest.SETRANGE("Source Subtype", SalesHeader."Document Type");
        WarehouseRequest.SETRANGE("Source No.", SalesHeader."No.");
        WarehouseRequest.SETRANGE("Document Status", WarehouseRequest."Document Status"::Released);
        WarehouseRequest.SetRange("Location Code", SalesHeader."Location Code");

        if WarehouseRequest.FindSet() then
            MICAReceiptDocTo3PL.ProcessSalesReturnWarehouseRequest(WarehouseRequest);
    end;

}