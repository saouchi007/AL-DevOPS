codeunit 80540 "MICA SANA GetProducts"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Product Functions", 'OnAfterGetProduct', '', false, false)]
    local procedure OnAfterGetProduct(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var Item: Record Item; var Params: Record "SC - Parameters Collection")
    var
        IsPossibleExpressOrder: Integer;
        CAI: Code[20];
        CAIText: Text;
        SplitValue: List of [Text];
    begin
        if Item."MICA Express Order" then
            IsPossibleExpressOrder := 1;

        CAIText := Item."No.";
        SplitValue := CAIText.Split('_');

        SplitValue.Get(1, CAIText);
        CAI := CopyStr(CAIText, 1, MaxStrLen(CAI));

        XMLNodeBuff.AddFieldElement('IsPossibleByExpress', CopyStr(format(IsPossibleExpressOrder), 1, 1024));
        XMLNodeBuff.AddFieldElement('CAI', CAI);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Product Functions", 'OnRunProductFunctions', '', false, false)]
    local procedure OnRunProductFunctions(var Rec: Record "SC - Operation"; var RequestBuff: Record "SC - XML Buffer (dotNET)"; var ResponseBuff: Record "SC - XML Buffer (dotNET)")
    var
        TempSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
        Item: Record Item;
        Customer: Record Customer;
        TempSalesLineDiscount: Record "Sales Line Discount" temporary;
        TempSalesPrice: Record "Sales Price" temporary;
        SCExecutionContext: Codeunit "SC - Execution Context";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        MICANewRebatesLineMgt: Codeunit "MICA New Rebates Line Mgt";
        ProductId: Code[20];
        Price: Text[1024];
        PriceList: Text[1024];
    begin
        if SCExecutionContext.GetCurrentOperationName() = 'GetPriceInfo' then begin
            TempSCParametersCollection.InitParams(RequestBuff, DATABASE::Item);
            ResponseBuff.SelectNodes('//Price', TempSCXMLBufferdotNET);
            while TempSCXMLBufferdotNET.NextNode() do begin
                ProductId := CopyStr(TempSCXMLBufferdotNET.ReadFieldValueByName('ProductId'), 1, MaxStrLen(ProductId));
                Price := CopyStr(TempSCXMLBufferdotNET.CutFieldValueByName('Price'), 1, MaxStrLen(Price));
                PriceList := CopyStr(TempSCXMLBufferdotNET.CutFieldValueByName('ListPrice'), 1, MaxStrLen(PriceList));
                Clear(TempSalesLineDiscount);
                TempSalesLineDiscount.DeleteAll();
                if Item.Get(ProductId) and Customer.Get(TempSCParametersCollection.AccountId) then begin
                    SalesPriceCalcMgt.FindSalesPrice(TempSalesPrice, Customer."No.", '', Customer."Customer Price Group", '', Item."No.", '', Item."Sales Unit of Measure", Customer."Currency Code", WorkDate(), false);
                    SalesPriceCalcMgt.CalcBestUnitPrice(TempSalesPrice);
                    TempSCXMLBufferdotNET.AddFieldElement('ListPrice', Format(TempSalesPrice."Unit Price"));
                    TempSCXMLBufferdotNET.AddFieldElement('Price', Format(TempSalesPrice."Unit Price" * (100 - MICANewRebatesLineMgt.FindItemRebatesPerCustomer(Item, Customer, WorkDate(), TempSalesLineDiscount)) / 100))
                end else begin
                    TempSCXMLBufferdotNET.AddFieldElement('Price', Price);
                    TempSCXMLBufferdotNET.AddFieldElement('ListPrice', PriceList);
                end;
            end;
        end;
    end;
}