codeunit 80480 "MICA SANA GetCustomer"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Customer Helper", 'OnGetCustomer', '', false, false)]
    local procedure OnGetCustomer(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var Customer: Record Customer; var Params: Record "SC - Parameters Collection")
    var
        IsPossibleExpressOrder: Integer;
        completeOrderDefauktValue: Integer;
    begin
        if Customer."MICA Express Order" then
            IsPossibleExpressOrder := 1;
        XMLNodeBuff.AddFieldElement('IsPossibleExpressOrder', CopyStr(format(IsPossibleExpressOrder), 1, 1024));

        if Customer."Shipping Advice" = Customer."Shipping Advice"::Complete then
            completeOrderDefauktValue := 1;

        XMLNodeBuff.AddFieldElement('CompleteOrderDefaultValue', CopyStr(Format(completeOrderDefauktValue), 1, 1024));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Customer Helper", 'OnGetShippingAddress', '', false, false)]
    local procedure OnGetShippingAddress(var ResultNodeBuff: Record "SC - XML Buffer (dotNET)"; var ShippingAddress: Record "Ship-to Address")
    var
        IsPossibleExpressOrder: Integer;
    begin
        if ShippingAddress."MICA Express Order" then
            IsPossibleExpressOrder := 1;
        ResultNodeBuff.AddFieldElement('IsPossibleExpressOrder', CopyStr(format(IsPossibleExpressOrder), 1, 1024));
    end;
}