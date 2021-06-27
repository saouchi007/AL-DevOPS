codeunit 80360 "MICA ItemCommercialPeriod"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Requested Delivery Date', false, false)]
    local procedure OnAfterValidateReqDeliDateSalesLine(var rec: Record "Sales Line")
    var
        Item: Record Item;
        ItemCommercPeriodBeforeErr: Label 'Not possible to order this product before the commercialization period.';
    begin
        if rec.GetSkipCheckCommercPeriod() then exit;

        if rec.Type <> rec.Type::Item then exit;
        if rec."No." = '' then exit;
        if rec."Requested Delivery Date" = 0D then exit;

        if not Item.get(rec."No.") then exit;
        if not item.IsInRangeOfCommercializationDate(rec."Requested Delivery Date") and
           not item.IsOverRangeOfCommercializationDate(rec."Requested Delivery Date") then
            Error(ItemCommercPeriodBeforeErr);
    end;
}