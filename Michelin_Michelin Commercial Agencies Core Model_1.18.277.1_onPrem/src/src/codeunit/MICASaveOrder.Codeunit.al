codeunit 80600 "MICA Save Order"
{
    var
        MICASplitLineManagement: codeunit "MICA Split Line Management";

    [EventSubscriber(ObjectType::Table, Database::"SC - Parameters Collection", 'OnInitParams', '', FALSE, FALSE)]
    local procedure OnBeforeInitParamCollection(var InXMLBuff: Record "SC - XML Buffer (dotNET)"; var Params: Record "SC - Parameters Collection")
    var
        TempOrderSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        SCExecutionContext: Codeunit "SC - Execution Context";
    begin
        with Params do begin
            IF NOT (SCExecutionContext.GetCurrentOperationName() = 'SaveOrder') then
                exit;

            if InXmlBuff.SelectSingleNode('//Order', TempOrderSCXMLBufferdotNET) then begin
                "MICA OrderType" := CopyStr(TempOrderSCXMLBufferdotNET.ReadFieldValueByName('OrderType'), 1, 20);
                if TempOrderSCXMLBufferdotNET.ReadFieldValueByName('IsCompleteOrder') = '1' then
                    "MICA IsCompleteOrder" := 1;
                "MICA RequestedDeliveryDate" := CopyStr(TempOrderSCXMLBufferdotNET.ReadFieldValueByName('RequestedDeliveryDate'), 1, MaxStrLen("MICA RequestedDeliveryDate"));
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Order/Basket Functions", 'OnAfterCreateDocResponse', '', false, false)]
    local procedure OnAfterCreateDocResponse(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var SalesHeader: Record "Sales Header"; var Params: Record "SC - Parameters Collection")
    var
        TempOrderNumberSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        SCExecutionContext: Codeunit "SC - Execution Context";
        completeOrderDefaultValue: Integer;
        OrderType: Text[30];
        OrderNo: Code[20];
    begin
        IF NOT (SCExecutionContext.GetCurrentOperationName() = 'SaveOrder') then
            exit;

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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Order/Basket Functions", 'OnAfterAddDocumentLine', '', FALSE, FALSE)]
    local procedure OrderBasketOnGetSalesLine(var SalesLine: Record "Sales Line"; var Params: Record "SC - Parameters Collection")
    var
        SCExecutionContext: Codeunit "SC - Execution Context";
        RequestedDeliveryDate: Date;

    begin
        IF NOT (SCExecutionContext.GetCurrentOperationName() = 'SaveOrder') then
            exit;
        clear(MICASplitLineManagement);

        // Split the line
        DateTxtToDate(Params."MICA RequestedDeliveryDate", RequestedDeliveryDate);
        SalesLine."Requested Delivery Date" := RequestedDeliveryDate;
        IF SalesLine.type = SalesLine.Type::Item THEN
            MICASplitLineManagement.SplitLine(SalesLine, false, false, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Order/Basket Functions", 'OnInitDocument', '', FALSE, FALSE)]
    local procedure OnInitDocument(var SalesHeader: Record "Sales Header"; var Params: Record "SC - Parameters Collection")
    begin
        if Params.RequestedDeliveryDate <> 0D then
            SalesHeader."Requested Delivery Date" := Params.RequestedDeliveryDate;
        with SalesHeader do
            case params."MICA OrderType" of
                'Express':
                    "MICA Order Type" := "MICA Order Type"::"Express Order";
                'Standard':
                    "MICA Order Type" := "MICA Order Type"::"Standard Order";
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Orders Functions", 'OnGetSalesLine', '', false, false)]
    local procedure MyProcedure(var Params: Record "SC - Parameters Collection"; var SalesLine: Record "Sales Line"; var XMLNodeBuff: Record "SC - XML Buffer (dotNET)")
    var
        SalesHeader: Record "Sales Header";
        SCSettingsFunctions: Codeunit "SC - Settings Functions";
        ListPrice: Decimal;
    begin
        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            ListPrice := SCSettingsFunctions.RoundPrice(SalesLine."Unit Price", SalesHeader."Currency Code");
            if ListPrice <> 0.0 then
                XMLNodeBuff.AddFieldElement('ListPrice', Format(ListPrice))
            else
                XMLNodeBuff.AddFieldElement('ListPrice', '0')
        end else
            XMLNodeBuff.AddFieldElement('ListPrice', '0')
    end;

    local procedure DateTxtToDate(DateText: Text; var GlobalDate: Date)
    var
        Day: Integer;
        Mounth: Integer;
        Year: Integer;
    begin
        if DateText <> '' then
            if not Evaluate(GlobalDate, DateText) then begin
                Evaluate(Mounth, Split(DateText, '/'));
                Evaluate(Day, Split(DateText, '/'));
                Evaluate(Year, Split(DateText, '/'));
                GlobalDate := DMY2Date(Day, Mounth, Year);
            end;
    end;

    local procedure Split(VAR Text: Text; Separator: Text[1]) Token: Text
    var
        Pos: Integer;
    begin
        Pos := StrPos(Text, Separator);
        if Pos > 0 then begin
            Token := CopyStr(Text, 1, Pos - 1);
            if Pos + 1 <= StrLen(Text) then
                Text := CopyStr(Text, Pos + 1)
            else
                Text := '';
        end else begin
            Token := Text;
            Text := '';
        end;
    end;

}