codeunit 80520 "MICA SANA GetOrders"
{
    [EventSubscriber(ObjectType::Table, Database::"SC - Parameters Collection", 'OnInitParams', '', FALSE, FALSE)]
    local procedure OnBeforeInitParamCollection(var InXMLBuff: Record "SC - XML Buffer (dotNET)"; var Params: Record "SC - Parameters Collection")
    var
        Customer: Record Customer;
        ShiptoAddress: Record "Ship-to Address";
        TempAddressInfoSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        SalesHeader: Record "Sales Header";
        ShippingAddressValue: Text;
    begin
        with Params do begin
            if Params.DocumentId <> '' then
                if SalesHeader.Get(SalesHeader."Document Type"::Order, Params.DocumentId) then
                    if Params.CustomerId = '' then
                        Params.CustomerId := SalesHeader."Sell-to Customer No."
                    else
                        if Params.CustomerId <> SalesHeader."Sell-to Customer No." then
                            exit;
            if Customer.get(Params.CustomerId) then
                if InXmlBuff.SelectSingleNode('//CustomerAddressId', TempAddressInfoSCXMLBufferdotNET) then begin
                    ShippingAddressValue := InXmlBuff.SelectSingleNodeText('//CustomerAddressId');
                    "MICA Ship-to Address Code" := CopyStr(ShippingAddressValue, 1, 20);
                    if (UpperCase(ShippingAddressValue) <> 'DEFAULT') and (ShippingAddressValue <> '') then
                        ShiptoAddress.get(Customer."No.", ShippingAddressValue);
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Orders Functions", 'OnBeforeGetSalesDocuments', '', false, false)]
    local procedure OnBeforeGetSalesDocuments(var Params: Record "SC - Parameters Collection"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
    begin
        //RecRef.FindSet();
        if Params."MICA Ship-to Address Code" <> '' then
            if RecRef.RecordId().TableNo() = Database::"Sales Header" then begin
                FieldRef := RecRef.Field(12);
                FieldRef.SetRange(Params."MICA Ship-to Address Code");
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Orders Functions", 'OnAfterCreateDocResponse', '', false, false)]
    local procedure OnAfterCreateDocResponse(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var SalesHeader: Record "Sales Header"; var Params: Record "SC - Parameters Collection")
    var
        TempOrderNumberSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        completeOrderDefaultValue: Integer;
        OrderType: Text[30];
        OrderNo: Code[20];
    begin
        if SalesHeader."Shipping Advice" = SalesHeader."Shipping Advice"::Complete then
            completeOrderDefaultValue := 1;

        XMLNodeBuff.SelectNodes('//Order', TempOrderNumberSCXMLBufferdotNET);
        while TempOrderNumberSCXMLBufferdotNET.NextNode() do begin
            OrderNo := CopyStr(TempOrderNumberSCXMLBufferdotNET.ReadFieldValueByName('DocumentId'), 1, 20);
            if OrderNo = SalesHeader."No." then begin
                if SalesHeader."MICA Order Type" = SalesHeader."MICA Order Type"::"Express Order" then
                    OrderType := 'Express';
                if SalesHeader."MICA Order Type" = SalesHeader."MICA Order Type"::"Standard Order" then
                    OrderType := 'Standard';
                TempOrderNumberSCXMLBufferdotNET.AddFieldElement('OrderType', OrderType);
                TempOrderNumberSCXMLBufferdotNET.AddFieldElement('IsCompleteOrder', copystr(Format(completeOrderDefaultValue), 1, 1024));
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Orders Functions", 'OnGetSalesLine', '', false, false)]
    local procedure OnGetSalesLine(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var SalesLine: Record "Sales Line"; var Params: Record "SC - Parameters Collection")
    var
        ParentSalesLine: Record "Sales Line";
    begin
        ParentSalesLine.Reset();
        ParentSalesLine.SetRange("Document Type", SalesLine."Document Type");
        ParentSalesLine.SetRange("Document No.", SalesLine."Document No.");
        ParentSalesLine.SetRange(Type, SalesLine.Type);
        ParentSalesLine.SetRange("No.", Salesline."No.");
        if ParentSalesLine.FindFirst() then
            XMLNodeBuff.AddFieldElement('ParentLineNo', Copystr(Format(ParentSalesLine."Line No."), 1, 1024));

        if SalesLine."MICA Countermark" <> '' then
            XMLNodeBuff.AddFieldElement('Comment', SalesLine."MICA Countermark");
        XMLNodeBuff.CutFieldValueByName('ShipmentDate');
        XMLNodeBuff.AddFieldElement('ShipmentDate', Copystr(Format(SalesLine."Planned Delivery Date"), 1, 1024));
        XMLNodeBuff.AddFieldElement('ListPrice', XMLNodeBuff.CutFieldValueByName('Price'));
        if SalesLine.Quantity <> 0 then
            XMLNodeBuff.AddFieldElement('Price', format(SalesLine."Line Amount" / SalesLine.Quantity))
        else
            XMLNodeBuff.AddFieldElement('Price', '0');

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Orders Functions", 'OnGetSalesInvoiceLine', '', false, false)]
    local procedure OnGetSalesInvoiceLine(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var SalesInvLine: Record "Sales Invoice Line"; var Params: Record "SC - Parameters Collection")
    var
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        SalesShipmentLine.SetRange("Order No.", SalesInvLine."Order No.");
        SalesShipmentLine.SetRange("Order Line No.", SalesInvLine."Order Line No.");
        if SalesShipmentLine.FindFirst() then
            XMLNodeBuff.AddFieldElement('ShipmentNumber', SalesShipmentLine."Document No.");

        if SalesInvLine."Order No." <> '' then
            XMLNodeBuff.AddFieldElement('OrderNo', SalesInvLine."Order No.");

        if SalesInvLine."MICA Countermark" <> '' then
            XMLNodeBuff.AddFieldElement('Comment', SalesInvLine."MICA Countermark");

        XMLNodeBuff.AddFieldElement('ListPrice', XMLNodeBuff.CutFieldValueByName('Price'));
        if SalesInvLine.Quantity <> 0 then
            XMLNodeBuff.AddFieldElement('Price', format(SalesInvLine."Line Amount" / SalesInvLine.Quantity))
        else
            XMLNodeBuff.AddFieldElement('Price', '0');

        GetRebatesOffFromOrder(XMLNodeBuff, SalesInvLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Orders Functions", 'OnGetSalesShipmentLine', '', false, false)]
    local procedure OnGetSalesShipmentLine(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var SalesShipLine: Record "Sales Shipment Line"; var Params: Record "SC - Parameters Collection")
    var
        SalesLine: Record "Sales Line";
    begin
        if SalesShipLine."MICA Countermark" <> '' then
            XMLNodeBuff.AddFieldElement('Comment', SalesShipLine."MICA Countermark");
        XMLNodeBuff.AddFieldElement('ListPrice', XMLNodeBuff.CutFieldValueByName('Price'));
        if SalesLine.Get(Salesline."Document Type"::Order, SalesShipLine."Order No.", SalesShipLine."Order Line No.") then begin
            if SalesLine.Quantity <> 0 then
                XMLNodeBuff.AddFieldElement('Price', format(SalesLine."Line Amount" / SalesLine.Quantity))
            else
                XMLNodeBuff.AddFieldElement('Price', '0');
        end else
            XMLNodeBuff.AddFieldElement('Price', '0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Orders Functions", 'OnGetRtrnRcptLine', '', false, false)]
    local procedure OnGetRtrnRcptLine(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var ReturnRcptLine: Record "Return Receipt Line"; var Params: Record "SC - Parameters Collection")
    var
        SalesLine: Record "Sales Line";
    begin
        XMLNodeBuff.AddFieldElement('ListPrice', XMLNodeBuff.CutFieldValueByName('Price'));
        if SalesLine.Get(Salesline."Document Type"::Order, ReturnRcptLine."Return Order No.", ReturnRcptLine."Return Order Line No.") then begin
            if SalesLine.Quantity <> 0 then
                XMLNodeBuff.AddFieldElement('Price', format(SalesLine."Line Amount" / SalesLine.Quantity))
            else
                XMLNodeBuff.AddFieldElement('Price', '0');
        end else
            XMLNodeBuff.AddFieldElement('Price', '0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Orders Functions", 'OnGetSalesCrMemoLine', '', false, false)]
    local procedure OnGetSalesCrMemoLine(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var SalesCrMemoLine: Record "Sales Cr.Memo Line"; var Params: Record "SC - Parameters Collection")
    begin
        XMLNodeBuff.AddFieldElement('ListPrice', XMLNodeBuff.CutFieldValueByName('Price'));
        if SalesCrMemoLine.Quantity <> 0 then
            XMLNodeBuff.AddFieldElement('Price', format(SalesCrMemoLine."Line Amount" / SalesCrMemoLine.Quantity))
        else
            XMLNodeBuff.AddFieldElement('Price', '0');
    end;

    local procedure GetRebatesOffFromOrder(var SCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var SalesInvoiceLine: Record "Sales Invoice Line")
    var
        MICAPostedAppliedSLDisc: Record "MICA Posted Applied SL Disc.";
        TempRebatesOffSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        TempRebateOffSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        ItemDiscountGroup: Record "Item Discount Group";
        NbRebatesOff: Integer;
    begin
        SCXMLBufferdotNET.AddElement(TempRebatesOffSCXMLBufferdotNET, 'OffRebates', '');
        MICAPostedAppliedSLDisc.SetRange("Document Type", MICAPostedAppliedSLDisc."Document Type"::Order);
        MICAPostedAppliedSLDisc.SetRange("Document No.", SalesInvoiceLine."Order No.");
        MICAPostedAppliedSLDisc.SetRange("Document Line No.", SalesInvoiceLine."Order Line No.");
        if MICAPostedAppliedSLDisc.FindSet() then
            repeat
                NbRebatesOff += 1;
                TempRebatesOffSCXMLBufferdotNET.AddElement(TempRebateOffSCXMLBufferdotNET, 'OffRebate', '');
                if ItemDiscountGroup.Get(MICAPostedAppliedSLDisc.code) then
                    TempRebateOffSCXMLBufferdotNET.AddFieldElement('OffRebateName', ItemDiscountGroup.Description)
                else
                    if MICAPostedAppliedSLDisc.Code = '' then
                        case MICAPostedAppliedSLDisc.Type of
                            MICAPostedAppliedSLDisc.Type::"Exceptional Disc.":
                                TempRebateOffSCXMLBufferdotNET.AddFieldElement('OffRebateName', Format(MICAPostedAppliedSLDisc."Rebates Type"::Exceptional));
                            MICAPostedAppliedSLDisc.Type::"Payment Term Disc.":
                                TempRebateOffSCXMLBufferdotNET.AddFieldElement('OffRebateName', 'TOP');
                        end
                    else
                        TempRebateOffSCXMLBufferdotNET.AddFieldElement('OffRebateName', MICAPostedAppliedSLDisc.code);

                TempRebateOffSCXMLBufferdotNET.AddFieldElement('DiscountPercentage', Copystr(Format(MICAPostedAppliedSLDisc."Sales Discount %"), 1, 1024));
            until (MICAPostedAppliedSLDisc.Next() = 0) or (NbRebatesOff = 5);
    end;
}