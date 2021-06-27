
codeunit 80420 "MICA SC - CalculateBaskets"
{
    [EventSubscriber(ObjectType::Table, Database::"SC - Parameters Collection", 'OnInitParams', '', FALSE, FALSE)]
    local procedure OnBeforeInitParamCollection(var InXMLBuff: Record "SC - XML Buffer (dotNET)"; var Params: Record "SC - Parameters Collection")
    var
        SCExecutionContext: Codeunit "SC - Execution Context";
    begin
        with Params do begin
            IF NOT (SCExecutionContext.GetCurrentOperationName() = 'CalculateBasket') then
                exit;
            "MICA OrderType" := COPYSTR(ReadStringValueFromXML(InXMLBuff, '//OrderType'), 1, MaxStrLen("MICA OrderType"));
            "MICA IsCompleteOrder" := ReadIntegerValueFromXML(InXMLBuff, '//IsCompleteOrder');
            "MICA RequestedDeliveryDate" := CopyStr(ReadStringValueFromXML(InXMLBuff, '//RequestedDeliveryDate'), 1, MaxStrLen("MICA RequestedDeliveryDate"));
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"SC - Parameters Collection", 'OnInitLineFieldValues', '', FALSE, FALSE)]
    local procedure OnBeforeEventInitFieldValues(var LineNodeBuff: Record "SC - XML Buffer (dotNET)"; var Params: Record "SC - Parameters Collection")
    var
        TextValue: Text[1024];
    begin
        with Params do begin
            "MICA Comment" := '';
            TextValue := GetFieldValueByNameFromXML(LineNodeBuff, 'Comment');
            if TextValue <> '' then
                "MICA Comment" := COPYSTR(TextValue, 1, MaxStrLen("MICA Comment"));
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Order/Basket Functions", 'OnBeforeSaveDocument', '', FALSE, FALSE)]
    local procedure OnBeforeSaveSalesHeader(var SalesHeader: Record "Sales Header"; var Params: Record "SC - Parameters Collection")
    var
        SCWebshop: Record "SC - Webshop";
        SanaContext: Codeunit "SC - Execution Context";
    begin
        with SalesHeader do begin
            case params."MICA OrderType" of
                'Express':
                    VALIDATE("MICA Order Type", "MICA Order Type"::"Express Order");
                'Standard':
                    VALIDATE("MICA Order Type", "MICA Order Type"::"Standard Order");
            end;
            VALIDATE("Requested Delivery Date", Params.RequestedDeliveryDate);

            if (SanaContext.GetCurrentOperationName() = 'SaveOrder') then
                CalculateShippingDateSalesHeaderSaveOrder(SalesHeader);

            case params."MICA IsCompleteOrder" of
                0:
                    VALIDATE("Shipping Advice", "Shipping Advice"::Partial);
                1:
                    VALIDATE("Shipping Advice", "Shipping Advice"::Complete);
            end;

            if ("Document Type" = "Document Type"::Order) and ("External Document No." <> '') then begin
                "Your Reference" := "External Document No.";
                "External Document No." := '';
            end;

            if SCWebshop.Get(Params.WebsiteId) and SCWebshop."MICA Keep No. in Ext. Doc No." then
                "External Document No." := "No."
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Order/Basket Functions", 'OnAddDocumentLine', '', FALSE, FALSE)]
    local procedure OnAddSalesLine(var SalesLine: Record "Sales Line"; var Params: Record "SC - Parameters Collection")
    begin
        if params."MICA Comment" <> '' then begin
            SalesLine."MICA Countermark" := Params."MICA Comment";
            SalesLine.modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Order/Basket Functions", 'OnAfterCreateDocResponse', '', FALSE, FALSE)]
    local procedure OnAfterCreateDocResponse(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var SalesHeader: Record "Sales Header"; var Params: Record "SC - Parameters Collection")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        exceededQty: Decimal;
    begin
        SalesReceivablesSetup.get();
        with SalesHeader do begin
            IF "MICA Order Type" = "MICA Order Type"::"Express Order" then begin
                exceededQty := Params."MICA Exceeded Quantity" - SalesReceivablesSetup."MICA Express Order Qty Max";
                if exceededQty > 0 then
                    XMLNodeBuff.AddFieldElement('ExceededQuantity', COPYSTR(FORMAT(exceededQty), 1, 1024))
                else
                    XMLNodeBuff.AddFieldElement('ExceededQuantity', '0');
            end else
                XMLNodeBuff.AddFieldElement('ExceededQuantity', '0');
            case "MICA Order Type" of
                "MICA Order Type"::"Express Order":
                    XMLNodeBuff.AddFieldElement('OrderType', 'Express');
                "MICA Order Type"::"Standard Order":
                    XMLNodeBuff.AddFieldElement('OrderType', 'Standard');
            end;
            XMLNodeBuff.AddFieldElement('RequestedDeliveryDate', COPYSTR(FORMAT("Requested Delivery Date"), 1, 1024));
            CASE "Shipping Advice" of
                "Shipping Advice"::Complete:
                    XMLNodeBuff.AddFieldElement('IsCompleteOrder', '1');
                "Shipping Advice"::Partial:
                    XMLNodeBuff.AddFieldElement('IsCompleteOrder', '0');
            end;
        end;
    end;

    local procedure ReadStringValueFromXML(var InSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; QueryString: Text[1024]): Text[1024];
    var
        TextValue: Text[1024];
    begin
        TextValue := COPYSTR(InSCXMLBufferdotNET.SelectSingleNodeText(QueryString), 1, 1024);
        exit(TextValue);
    end;

    local procedure ReadIntegerValueFromXML(var InSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; QueryString: Text[1024]): Integer;
    var
        TextValue: Text[1024];
        IntValue: Integer;
    begin
        TextValue := COPYSTR(InSCXMLBufferdotNET.SelectSingleNodeText(QueryString), 1, 1024);
        if EVALUATE(IntValue, TextValue) then
            exit(IntValue);
    end;

    local procedure GetFieldValueByNameFromXML(var InSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; FieldName: Text[1024]) TextValue: Text[1024];
    begin
        TextValue := CopyStr(InSCXMLBufferdotNET.CutFieldValueByName(FieldName), 1, MaxStrLen(TextValue));
        exit(TextValue);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Order/Basket Functions", 'OnGetSalesLine', '', false, false)]
    local procedure OnGetSalesLineCodeUnitSCOrderBasketFunctions(var Params: Record "SC - Parameters Collection"; var SalesLine: Record "Sales Line"; var XMLNodeBuff: Record "SC - XML Buffer (dotNET)")
    var
        SalesHeader: Record "Sales Header";
        SCSettingsFunctions: Codeunit "SC - Settings Functions";
        ListPrice: Decimal;
    begin
        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            ListPrice := SCSettingsFunctions.RoundPrice(SalesLine."Unit Price", SalesHeader."Currency Code");
            XMLNodeBuff.AddFieldElement('NetUnitPrice', Format(SalesLine."Line Amount" / SalesLine.Quantity));
            if ListPrice <> 0.0 then
                XMLNodeBuff.AddFieldElement('ListPrice', Format(ListPrice))
            else
                XMLNodeBuff.AddFieldElement('ListPrice', '0');
        end else begin
            XMLNodeBuff.AddFieldElement('ListPrice', '0');
            XMLNodeBuff.AddFieldElement('NetUnitPrice', '0');
        end;
    end;

    local procedure CalculateShippingDateSalesHeaderSaveOrder(SalesHeader: Record "Sales Header")
    var
        CustomizedCalChg: Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
        NextTruckManagement: Codeunit "MICA Next Truck Management";
        ShipmentDate: Date;
        PlannedShipmentDate: Date;
        PlannedDeliveryDate: Date;
        LocationBaseCalendar: Code[10];
        ShippingAgentBaseCalendar: Code[10];
        ShipToBaseCalendar: Code[10];
        CutOff: Boolean;
        DoesNotMatchErr: Label 'Date does not match Customer / Ship-to Address calendar” / “Customer / Ship-to address cannot be delivered because of lead time';
        RequestedDeliveryDateImpossibleErr: Label 'The Requested Delivery Date %1 is not a working day in the base calendar %2.';
    begin
        NextTruckManagement.GetBasCalendars(SalesHeader, LocationBaseCalendar, ShippingAgentBaseCalendar, ShipToBaseCalendar, CutOff, SalesHeader."Location Code");
        CustomizedCalChg.SetSource(CustomizedCalChg."Source Type"::"Shipping Agent", '', '', ShipToBaseCalendar);
        if CalendarManagement.IsNonworkingDay(SalesHeader."Requested Delivery Date", CustomizedCalChg) and (IsNullGuid(SalesHeader."SC Unique Webshop Document Id")) then
            Error(RequestedDeliveryDateImpossibleErr, SalesHeader."Requested Delivery Date", ShipToBaseCalendar);
        NextTruckManagement.CalculateDateLineOnHand(SalesHeader."Requested Delivery Date", SalesHeader."Outbound Whse. Handling Time", LocationBaseCalendar, SalesHeader."Shipping Time", ShippingAgentBaseCalendar, ShipToBaseCalendar, ShipmentDate, PlannedShipmentDate, PlannedDeliveryDate);
        if (ShipmentDate < WorkDate()) then
            Error(DoesNotMatchErr);
    end;
}