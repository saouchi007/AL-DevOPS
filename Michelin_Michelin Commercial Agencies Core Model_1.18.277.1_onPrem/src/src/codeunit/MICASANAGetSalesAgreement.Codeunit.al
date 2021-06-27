codeunit 83020 "MICA SANA Get Sales Agreement"
{
    var
        CurrentPageIndex: Integer;
        CurrentInteractIndex: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Customer Functions", 'OnRunCustomerFunctions', '', false, false)]
    local procedure OnRunCustomerFunctionsSCCustomerFunctions(var Rec: Record "SC - Operation"; var RequestBuff: Record "SC - XML Buffer (dotNET)"; var ResponseBuff: Record "SC - XML Buffer (dotNET)")
    begin
        if Rec.Code = UPPERCASE('GetSalesAgreement') then
            GetSalesAgreement(RequestBuff, ResponseBuff);
    end;

    local procedure GetSalesAgreement(var InXMLBuff: Record "SC - XML Buffer (dotNET)"; var OutXMLBuff: Record "SC - XML Buffer (dotNET)")
    var
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
        MICASalesAgreement: Record "MICA Sales Agreement";
        TempMICASalesAgreement: Record "MICA Sales Agreement" temporary;
        TempProductsSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        TempProductSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        Item: Record Item;
        SalesAgreementCode: Code[20];
        CustomerNo: Text[20];
        ItemNumber: Text[20];
        ReferenceDateTxt: Text[10];
        ReferenceDate: Date;
        NoCustomerIdErr: Label 'Customer Id not found';
        ReferenceDateErr: Label 'Reference Date not found';
        Only1SalesAgreementErr: Label 'You can only have 1 sales agreement';
        SalesAgrmtErr: Label 'You must set up at least one Sales Agreement for the customer no. %1.';
        SalesAgrmtItemErr: Label 'You must set up at least one Sales Agreement for the customer no. %1 and item no. %2.';
    begin
        TempSCParametersCollection.InitParams(InXMLBuff, 0);
        CustomerNo := CopyStr(InXMLBuff.SelectSingleNodeText('//CustomerId'), 1, MaxStrLen(CustomerNo));
        ReferenceDateTxt := CopyStr(InXMLBuff.SelectSingleNodeText('//ReferenceDate'), 1, MaxStrLen(ReferenceDateTxt));

        if CustomerNo = '' then
            Error(NoCustomerIdErr);
        if ReferenceDateTxt = '' then
            Error(ReferenceDateErr);

        DateTxtToDate(ReferenceDateTxt, ReferenceDate);

        InXMLBuff.SelectNodes('//Products', TempProductsSCXMLBufferdotNET);
        while TempProductsSCXMLBufferdotNET.NextNode() do begin
            InXMLBuff.SelectNodes('//Product', TempProductSCXMLBufferdotNET);
            while TempProductSCXMLBufferdotNET.NextNode() do begin
                SalesAgreementCode := '';
                ItemNumber := CopyStr(TempProductSCXMLBufferdotNET.ReadFieldValueByName('Id'), 1, 20);
                if ItemNumber <> '' then
                    if Item.Get(ItemNumber) then begin
                        SalesAgreementCode := GetSalesAgreementNo(CustomerNo, Item, ReferenceDate);
                        if SalesAgreementCode = '' then
                            Error(SalesAgrmtItemErr, CustomerNo, ItemNumber);
                        if MICASalesAgreement.Get(SalesAgreementCode) and not TempMICASalesAgreement.Get(SalesAgreementCode) then begin
                            TempMICASalesAgreement.TransferFields(MICASalesAgreement);
                            TempMICASalesAgreement.Insert(false);
                        end;
                    end;
            end;
        end;

        Clear(TempMICASalesAgreement);
        if TempMICASalesAgreement.Count = 0 then
            Error(SalesAgrmtErr, CustomerNo);
        if TempMICASalesAgreement.Count() > 1 then
            Error(Only1SalesAgreementErr);

        FillXmlResponse(OutXMLBuff, TempSCParametersCollection, TempMICASalesAgreement);
    end;

    local procedure DateTxtToDate(DateText: Text; var MyDate: Date)
    var
        DateList: List of [Text];
        Day: Integer;
        Mounth: Integer;
        Year: Integer;
    begin
        if DateText <> '' then
            if not Evaluate(MyDate, DateText) then begin
                DateList := DateText.Split('/');
                if DateList.Count() >= 3 then begin
                    Evaluate(Day, DateList.Get(1));
                    Evaluate(Mounth, DateList.Get(2));
                    Evaluate(Year, DateList.Get(3));
                    MyDate := DMY2Date(Day, Mounth, Year);
                end;
            end;
    end;

    local procedure FillXmlResponse(var OutXMLBuff: Record "SC - XML Buffer (dotNET)"; var Params: Record "SC - Parameters Collection"; var MICASalesAgreement: Record "MICA Sales Agreement")
    var
        TempSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
    begin
        Clear(MICASalesAgreement);
        if MICASalesAgreement.FindSet() then
            repeat
                NewIntercationInPage(Params);
                if CheckInteractToShowInPage(Params) then
                    OutXMLBuff.AddElement(TempSCXMLBufferdotNET, 'SalesAgreement', MICASalesAgreement."No.");
            until (MICASalesAgreement.Next() = 0)
    end;

    local procedure NewIntercationInPage(var Params: Record "SC - Parameters Collection")
    begin
        if CurrentInteractIndex = Params.PageSize then begin
            CurrentInteractIndex := 1;
            CurrentPageIndex += 1;
        end else
            CurrentInteractIndex += 1
    end;

    local procedure CheckInteractToShowInPage(var Params: Record "SC - Parameters Collection"): Boolean
    begin
        if Params.PageSize <> 0 then
            exit(CurrentPageIndex = Params.PageIndex)
        else
            exit(true);
    end;

    local procedure GetSalesAgreementNo(CustomerNo: Code[20]; Item: Record Item; ReferenceDate: Date): Code[20]
    var
        SalesAgreement: Record "MICA Sales Agreement";
        SalesAgreement2: Record "MICA Sales Agreement";
    begin
        SalesAgreement.SetCurrentKey("Customer No.", "Item Category Code", Default, DefaultLP);
        if Item."Item Category Code" <> '' THEN begin
            SalesAgreement.SetRange("Customer No.", CustomerNo);
            SalesAgreement.SetRange("Item Category Code", Item."Item Category Code");
            SalesAgreement.SetRange(DefaultLP, true);
            if SalesAgreement.FindFirst() then begin
                Clear(SalesAgreement2);
                SalesAgreement2.CopyFilters(SalesAgreement);
                SalesAgreement2.FindSet();
                repeat
                    if (ReferenceDate >= SalesAgreement2."Start Date") AND (ReferenceDate <= SalesAgreement2."End Date") then
                        exit(SalesAgreement2."No.");
                until SalesAgreement2.Next() = 0;
            end;
            SalesAgreement.SetRange("Item Category Code");
            SalesAgreement.SetRange(DefaultLP);
            SalesAgreement.SetRange(Default, true);
            if SalesAgreement.FindFirst() then begin
                Clear(SalesAgreement2);
                SalesAgreement2.CopyFilters(SalesAgreement);
                SalesAgreement2.FindSet();
                repeat
                    if (ReferenceDate >= SalesAgreement2."Start Date") AND (ReferenceDate <= SalesAgreement2."End Date") then
                        exit(SalesAgreement2."No.");
                until SalesAgreement2.Next() = 0;
            end;

        end else begin
            SalesAgreement.SetRange("Customer No.", CustomerNo);
            SalesAgreement.SetRange(Default, true);
            if SalesAgreement.FindFirst() then begin
                Clear(SalesAgreement2);
                SalesAgreement2.CopyFilters(SalesAgreement);
                SalesAgreement2.FindSet();
                repeat
                    if (ReferenceDate >= SalesAgreement2."Start Date") AND (ReferenceDate <= SalesAgreement2."End Date") then
                        exit(SalesAgreement2."No.");
                until SalesAgreement2.Next() = 0;
            end;
        end;
    end;
}