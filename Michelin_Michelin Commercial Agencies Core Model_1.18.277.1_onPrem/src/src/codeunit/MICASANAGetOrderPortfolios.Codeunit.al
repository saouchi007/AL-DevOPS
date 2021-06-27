codeunit 82620 "MICA SANA Get Order Portfolios"
{
    var
        TempMICAGetOrderPortfoliosTab: Record "MICA Get Order Portfolios Tab" temporary;
        CurrentPageIndex: Integer;
        CurrentInteractIndex: Integer;
        OrderPortfoliosTabEntryNo: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Customer Functions", 'OnRunCustomerFunctions', '', false, false)]
    local procedure OnRunCustomerFunctionsSCCustomerFunctions(var Rec: Record "SC - Operation"; var RequestBuff: Record "SC - XML Buffer (dotNET)"; var ResponseBuff: Record "SC - XML Buffer (dotNET)")
    begin
        if Rec.Code = UPPERCASE('GetOrderPortfolios') then
            GetOrderPortfolios(RequestBuff, ResponseBuff);
    end;

    local procedure GetOrderPortfolios(var InSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)")
    var
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesHeaderFilterTxt: Text;
        AccountId: Text[20];
        ItemNumber: Text[20];
        OrderNumber: Text[20];
        CustomerAddressId: Text[10];
        IsIncludeDetails: Text[1];
        FromDateTxt: Text[10];
        ToDateTxt: Text[10];
        BusinessLine: Text[20];
        BusinessLineResult: Text;
        FromDate: Date;
        ToDate: Date;
        NoLine: Boolean;
    begin
        OrderPortfoliosTabEntryNo := 1;
        TempSCParametersCollection.InitParams(InSCXMLBufferdotNET, 0);
        AccountId := CopyStr(InSCXMLBufferdotNET.SelectSingleNodeText('//AccountId'), 1, MaxStrLen(AccountId));
        ItemNumber := CopyStr(InSCXMLBufferdotNET.SelectSingleNodeText('//ItemNumber'), 1, MaxStrLen(ItemNumber));
        OrderNumber := CopyStr(InSCXMLBufferdotNET.SelectSingleNodeText('//OrderNumber'), 1, MaxStrLen(OrderNumber));
        CustomerAddressId := CopyStr(InSCXMLBufferdotNET.SelectSingleNodeText('//CustomerAddressId'), 1, MaxStrLen(CustomerAddressId));
        IsIncludeDetails := CopyStr(InSCXMLBufferdotNET.SelectSingleNodeText('//IsIncludeDetails'), 1, MaxStrLen(IsIncludeDetails));
        FromDateTxt := CopyStr(InSCXMLBufferdotNET.SelectSingleNodeText('//FromDate'), 1, MaxStrLen(FromDateTxt));
        ToDateTxt := CopyStr(InSCXMLBufferdotNET.SelectSingleNodeText('//ToDate'), 1, MaxStrLen(ToDateTxt));
        BusinessLine := CopyStr(InSCXMLBufferdotNET.SelectSingleNodeText('//BusinessLine'), 1, MaxStrLen(BusinessLine));

        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Sell-to Customer No.", AccountId);

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);

        if CustomerAddressId <> '' then
            SalesHeader.SetRange("Ship-to Code", CustomerAddressId);

        if OrderNumber <> '' then begin
            if SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNumber) then
                SalesLine.SetRange("Document No.", OrderNumber);
        end else begin
            if SalesHeader.FindSet() then
                repeat
                    if SalesHeaderFilterTxt <> '' then
                        SalesHeaderFilterTxt += '|' + SalesHeader."No."
                    else
                        SalesHeaderFilterTxt := SalesHeader."No.";
                until SalesHeader.Next() = 0
            else
                NoLine := true; //No header => no line
            SalesLine.SetFilter("Document No.", SalesHeaderFilterTxt);
        end;

        SalesLine.SetRange(Type, SalesLine.Type::Item);

        if ItemNumber <> '' then begin
            if BusinessLine <> '' then begin
                if StrPos(GetItemWithBusinessLine(BusinessLine), ItemNumber) <> 0 then
                    SalesLine.SetRange("No.", ItemNumber)
                else
                    NoLine := true;
            end else
                SalesLine.SetRange("No.", ItemNumber);
        end else
            if BusinessLine <> '' then begin
                BusinessLineResult := GetItemWithBusinessLine(BusinessLine);
                if BusinessLineResult <> '' then
                    SalesLine.SetFilter("No.", BusinessLineResult)
                else
                    NoLine := true
            end;
        DateTxtToDate(FromDateTxt, FromDate);
        DateTxtToDate(ToDateTxt, ToDate);

        if FromDateTxt <> '' then
            if ToDateTxt <> '' then
                SalesLine.SetFilter("Planned Delivery Date", '%1..%2', FromDate, ToDate)
            else
                SalesLine.SetFilter("Planned Delivery Date", '%1..', FromDate)
        else
            if ToDateTxt <> '' then
                SalesLine.SetFilter("Planned Delivery Date", '..%1', ToDate);

        SalesLine.SetFilter("Outstanding Quantity", '<>0');

        if not NoLine then
            if SalesLine.FindSet() then
                repeat
                    if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                        if IsIncludeDetails = '0' then begin
                            TempMICAGetOrderPortfoliosTab.SetRange("Item No.", SalesLine."No.");
                            TempMICAGetOrderPortfoliosTab.SetRange("Planned Delivery Date", SalesLine."Planned Delivery Date");
                            if SalesHeader."Ship-to Code" <> '' then
                                TempMICAGetOrderPortfoliosTab.SetRange("Ship To Address", SalesHeader."Ship-to Code")
                            else
                                TempMICAGetOrderPortfoliosTab.SetRange("Ship To Address", 'DEFAULT');
                            if not TempMICAGetOrderPortfoliosTab.FindFirst() then
                                InitGetOrderPortfoliosTab(SalesHeader, SalesLine)
                            else begin
                                TempMICAGetOrderPortfoliosTab.Quantity += SalesLine.Quantity;
                                TempMICAGetOrderPortfoliosTab.Modify();
                            end;
                        end
                        else
                            InitGetOrderPortfoliosTab(SalesHeader, SalesLine)
                until SalesLine.Next() = 0;
        FillXmlResponse(OutSCXMLBufferdotNET, TempSCParametersCollection, IsIncludeDetails);
        OnAfterGetOrderPortfolios(TempMICAGetOrderPortfoliosTab);
    end;

    local procedure GetItemWithBusinessLine(BusinessLine: Text[20]): Text
    var
        Item: Record Item;
        Result: Text;
    begin
        Item.SetCurrentKey("Item Category Code");
        Item.SetRange("Item Category Code", BusinessLine);
        if Item.FindSet() then
            repeat
                if Result <> '' then
                    Result += '|' + Item."No."
                else
                    Result := Item."No.";
            until Item.Next() = 0;
        exit(Result);
    end;

    local procedure InitGetOrderPortfoliosTab(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        if Item.Get(SalesLine."No.") then begin
            TempMICAGetOrderPortfoliosTab.Init();
            TempMICAGetOrderPortfoliosTab."Entry No." := OrderPortfoliosTabEntryNo;
            TempMICAGetOrderPortfoliosTab."Item No." := SalesLine."No.";
            TempMICAGetOrderPortfoliosTab.Description := SalesLine.Description;
            TempMICAGetOrderPortfoliosTab.Quantity := SalesLine.Quantity;
            TempMICAGetOrderPortfoliosTab."Planned Delivery Date" := SalesLine."Planned Delivery Date";
            TempMICAGetOrderPortfoliosTab."Prev. Planned Del. Date" := SalesLine."MICA Prev. Planned Del. Date";
            TempMICAGetOrderPortfoliosTab."Promised Delivery Date" := SalesLine."Promised Delivery Date";
            TempMICAGetOrderPortfoliosTab."Business Line" := Item."Item Category Code";
            if SalesHeader."Ship-to Code" <> '' then
                TempMICAGetOrderPortfoliosTab."Ship To Address" := SalesHeader."Ship-to Code"
            else
                TempMICAGetOrderPortfoliosTab."Ship To Address" := 'DEFAULT';
            TempMICAGetOrderPortfoliosTab.Insert();
            OrderPortfoliosTabEntryNo += 1;
        end;
    end;

    local procedure DateTxtToDate(DateText: Text; var MyDate: Date)
    var
        Day: Integer;
        Mounth: Integer;
        Year: Integer;
    begin
        if DateText <> '' then
            if not Evaluate(MyDate, DateText) then begin
                Evaluate(Day, Split(DateText, '/'));
                Evaluate(Mounth, Split(DateText, '/'));
                Evaluate(Year, Split(DateText, '/'));
                MyDate := DMY2Date(Day, Mounth, Year);
            end;
    end;

    local procedure FillXmlResponse(var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var SCParametersCollection: Record "SC - Parameters Collection"; IsIncludeDetails: Text[1])
    var
        TotalDeliveries: Integer;
    begin
        Clear(TempMICAGetOrderPortfoliosTab);
        OutSCXMLBufferdotNET.AddElementEx('TotalCount', Format(TempMICAGetOrderPortfoliosTab.Count()));
        TempMICAGetOrderPortfoliosTab.SetCurrentKey("Planned Delivery Date", "Item No.");
        TempMICAGetOrderPortfoliosTab.SetAscending("Planned Delivery Date", true);
        TempMICAGetOrderPortfoliosTab.SetFilter("Planned Delivery Date", '<>%1', 0D);
        CreateXmlLineResponse(OutSCXMLBufferdotNET, SCParametersCollection, IsIncludeDetails, TotalDeliveries);
        TempMICAGetOrderPortfoliosTab.SetRange("Planned Delivery Date", 0D);
        CreateXmlLineResponse(OutSCXMLBufferdotNET, SCParametersCollection, IsIncludeDetails, TotalDeliveries);
        OutSCXMLBufferdotNET.AddElementEx('TotalDeliveries', Format(TotalDeliveries));
    end;

    local procedure CreateXmlLineResponse(var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var SCParametersCollection: Record "SC - Parameters Collection"; IsIncludeDetails: Text[1]; var TotalDeliveries: Integer)
    var
        TempLineSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
    begin
        if TempMICAGetOrderPortfoliosTab.FindSet() then
            repeat
                NewIntercationInPage(SCParametersCollection);
                TotalDeliveries += TempMICAGetOrderPortfoliosTab.Quantity;
                if CheckInteractToShowInPage(SCParametersCollection) then begin
                    OutSCXMLBufferdotNET.AddElement(TempLineSCXMLBufferdotNET, 'OrderLine', '');
                    TempLineSCXMLBufferdotNET.AddFieldElement('ItemNumber', TempMICAGetOrderPortfoliosTab."Item No.");
                    TempLineSCXMLBufferdotNET.AddFieldElement('Description', TempMICAGetOrderPortfoliosTab.Description);
                    TempLineSCXMLBufferdotNET.AddFieldElement('Quantity', Format(TempMICAGetOrderPortfoliosTab.Quantity));
                    TempLineSCXMLBufferdotNET.AddFieldElement('PlannedDeliveryDate', Format(TempMICAGetOrderPortfoliosTab."Planned Delivery Date"));
                    if IsIncludeDetails = '1' then begin
                        TempLineSCXMLBufferdotNET.AddFieldElement('PrevCommitmentDate', Format(TempMICAGetOrderPortfoliosTab."Prev. Planned Del. Date"));
                        TempLineSCXMLBufferdotNET.AddFieldElement('InitCommitmentDate', Format(TempMICAGetOrderPortfoliosTab."Promised Delivery Date"));
                    end;
                    TempLineSCXMLBufferdotNET.AddFieldElement('BusinessLine', Format(TempMICAGetOrderPortfoliosTab."Business Line"));
                    TempLineSCXMLBufferdotNET.AddFieldElement('ShipToAddress', Format(TempMICAGetOrderPortfoliosTab."Ship To Address"));
                end
            until (TempMICAGetOrderPortfoliosTab.Next() = 0)
    end;

    local procedure NewIntercationInPage(var SCParametersCollection: Record "SC - Parameters Collection")
    begin
        if CurrentInteractIndex = SCParametersCollection.PageSize then begin
            CurrentInteractIndex := 1;
            CurrentPageIndex += 1;
        end else
            CurrentInteractIndex += 1
    end;

    local procedure CheckInteractToShowInPage(var SCParametersCollection: Record "SC - Parameters Collection"): Boolean
    begin
        if SCParametersCollection.PageSize <> 0 then
            exit(CurrentPageIndex = SCParametersCollection.PageIndex)
        else
            exit(true);
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

    [IntegrationEvent(false, false)]
    procedure OnAfterGetOrderPortfolios(var MICAGetOrderPortfoliosTab: Record "MICA Get Order Portfolios Tab");
    begin
    end;
}