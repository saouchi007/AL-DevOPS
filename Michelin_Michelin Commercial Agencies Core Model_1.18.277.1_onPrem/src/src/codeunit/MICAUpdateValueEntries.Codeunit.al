codeunit 80762 "MICA Update Value Entries"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitValueEntry', '', true, true)]
    local procedure UpdateValEntry_OnAfterInitValueEntry(var ValueEntry: Record "Value Entry")
    var
        Item: Record Item;
        Customer: Record Customer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        ReturnReceiptHeader: Record "Return Receipt Header";
    begin
        if Item.Get(ValueEntry."Item No.") then
            ValueEntry."MICA Accr. Item Grp." := Item."MICA Accr. Item Grp.";

        if Customer.Get(ValueEntry."Source No.") then
            ValueEntry."MICA Accr. Customer Grp." := Customer."MICA Accr. Customer Grp.";

        case ValueEntry."Document Type" of
            ValueEntry."Document Type"::"Sales Invoice":
                if SalesInvoiceHeader.Get(ValueEntry."Document No.") then
                    ValueEntry."MICA Sell-to Customer No." := SalesInvoiceHeader."Sell-to Customer No.";
            ValueEntry."Document Type"::"Sales Credit Memo":
                if SalesCrMemoHeader.Get(ValueEntry."Document No.") then
                    ValueEntry."MICA Sell-to Customer No." := SalesCrMemoHeader."Sell-to Customer No.";
            ValueEntry."Document Type"::"Sales Shipment":
                if SalesShipmentHeader.Get(ValueEntry."Document No.") then
                    ValueEntry."MICA Sell-to Customer No." := SalesShipmentHeader."Sell-to Customer No.";
            ValueEntry."Document Type"::"Sales Return Receipt":
                if ReturnReceiptHeader.Get(ValueEntry."Document No.") then
                    ValueEntry."MICA Sell-to Customer No." := ReturnReceiptHeader."Sell-to Customer No.";
        end;
    end;
}