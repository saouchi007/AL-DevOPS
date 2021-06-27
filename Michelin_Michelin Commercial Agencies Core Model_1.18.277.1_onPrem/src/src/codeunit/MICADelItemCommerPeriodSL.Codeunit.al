codeunit 80343 "MICA Del.ItemCommer.PeriodSL"
{
    trigger OnRun()
    begin
        CheckComPeriodForAllItems();
    end;

    local procedure CheckComPeriodForAllItems()
    var
        Item: Record Item;
        SalesLine: Record "Sales Line";
        DeleteSalesLine: Record "Sales Line";
    begin
        SalesLine.SetCurrentKey("Document Type", "Type", "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Outstanding Quantity", '<>0');
        SalesLine.SetRange("Reserved Quantity", 0);
        SalesLine.SetRange("MICA Splitted Line", true);

        if SalesLine.FindSet() then
            repeat
                Item.Get(SalesLine."No.");
                if Item.IsOverRangeOfCommercializationDate(SalesLine."Requested Delivery Date") then begin
                    DeleteSalesLine.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.");
                    DeleteSalesLine.Validate("MICA Delete Without Realloc.", true);
                    DeleteSalesLine.Modify(true);
                    DeleteSalesLine.Delete(true);
                end;
            until SalesLine.Next() = 0;
    end;
}