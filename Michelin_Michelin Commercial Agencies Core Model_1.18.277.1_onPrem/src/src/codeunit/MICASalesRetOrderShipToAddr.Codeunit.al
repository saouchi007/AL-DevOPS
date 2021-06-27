codeunit 81570 "MICA SalesRetOrderShipToAddr"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesLinesToDoc', '', false, false)]
    local procedure c6620OnAfterCopySalesLinesToDocLOCAL(FromDocType: Option; VAR ToSalesHeader: Record "Sales Header"; VAR FromSalesShipmentLine: Record "Sales Shipment Line"; VAR FromSalesInvoiceLine: Record "Sales Invoice Line"; VAR FromReturnReceiptLine: Record "Return Receipt Line"; VAR FromSalesCrMemoLine: Record "Sales Cr.Memo Line"; VAR LinesNotCopied: Integer; VAR MissingExCostRevLink: Boolean)
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ReturnReceiptHeader: Record "Return Receipt Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(ToSalesHeader."Document Type", ToSalesHeader."No.");
        case FromDocType of
            SalesDocType::"Posted Shipment":
                begin
                    if not SalesShipmentHeader.Get(FromSalesShipmentLine."Document No.") then
                        exit;
                    SalesHeader.Validate("MICA Retrieve-From Addr. Code", SalesShipmentHeader."Ship-to Code");
                    SalesHeader.Validate("MICA Retrieve-From Address", CopyStr(SalesShipmentHeader."Ship-to Address" + ' ' + SalesShipmentHeader."Ship-to Address 2" + ' ' + SalesShipmentHeader."Ship-to City", 1, MaxStrLen(ToSalesHeader."MICA Retrieve-From Address")));
                    SalesHeader.Modify(true);
                end;
            SalesDocType::"Posted Invoice":
                begin
                    if not SalesInvoiceHeader.Get(FromSalesInvoiceLine."Document No.") then
                        exit;
                    SalesHeader.Validate("MICA Retrieve-From Addr. Code", SalesInvoiceHeader."Ship-to Code");
                    SalesHeader.Validate("MICA Retrieve-From Address", CopyStr(SalesInvoiceHeader."Ship-to Address" + ' ' + SalesInvoiceHeader."Ship-to Address 2" + ' ' + SalesInvoiceHeader."Ship-to City", 1, MaxStrLen(ToSalesHeader."MICA Retrieve-From Address")));
                    SalesHeader.Modify(true);
                end;
            SalesDocType::"Posted Return Receipt":
                begin
                    if not ReturnReceiptHeader.Get(FromReturnReceiptLine."Document No.") then
                        exit;
                    SalesHeader.Validate("MICA Retrieve-From Addr. Code", ReturnReceiptHeader."Ship-to Code");
                    SalesHeader.Validate("MICA Retrieve-From Address", CopyStr(ReturnReceiptHeader."Ship-to Address" + ' ' + ReturnReceiptHeader."Ship-to Address 2" + ' ' + ReturnReceiptHeader."Ship-to City", 1, MaxStrLen(ToSalesHeader."MICA Retrieve-From Address")));
                    SalesHeader.Modify(true);
                end;
            SalesDocType::"Posted Credit Memo":
                begin
                    if not SalesCrMemoHeader.Get(FromSalesCrMemoLine."Document No.") then
                        exit;
                    SalesHeader.Validate("MICA Retrieve-From Addr. Code", SalesCrMemoHeader."Ship-to Code");
                    SalesHeader.Validate("MICA Retrieve-From Address", CopyStr(SalesCrMemoHeader."Ship-to Address" + ' ' + SalesCrMemoHeader."Ship-to Address 2" + ' ' + SalesCrMemoHeader."Ship-to City", 1, MaxStrLen(ToSalesHeader."MICA Retrieve-From Address")));
                    SalesHeader.Modify(true);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeReturnRcptHeaderInsert', '', false, false)]
    local procedure c80OnBeforeReturnRcptHeaderInsert(VAR ReturnRcptHeader: Record "Return Receipt Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    begin
        ReturnRcptHeader."MICA Retrieve-From Addr. Code" := SalesHeader."MICA Retrieve-From Addr. Code";
        ReturnRcptHeader."MICA Retrieve-From Address" := SalesHeader."MICA Retrieve-From Address";
    end;

    var
        SalesDocType: Option Quote,"Blanket Order",Order,Invoice,"Return Order","Credit Memo","Posted Shipment","Posted Invoice","Posted Return Receipt","Posted Credit Memo","Arch. Quote","Arch. Order","Arch. Blanket Order","Arch. Return Order";
}