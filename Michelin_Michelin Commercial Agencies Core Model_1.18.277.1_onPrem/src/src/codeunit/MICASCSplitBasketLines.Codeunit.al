codeunit 80421 "MICA SC - Split Basket Lines"
{
    var
        MICASplitLineManagement: codeunit "MICA Split Line Management";
        SourceSalesLineNo: integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Order/Basket Functions", 'OnGetSalesLine', '', FALSE, FALSE)]
    local procedure OrderBasketOnGetSalesLine(var XMLNodeBuff: Record "SC - XML Buffer (dotNET)"; var SalesLine: Record "Sales Line"; var Params: Record "SC - Parameters Collection")
    var
        TempSalesLine: Record "Sales Line" temporary;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SCExecutionContext: Codeunit "SC - Execution Context";
        RequestedDeliveryDate: Date;

    begin
        IF not (SCExecutionContext.GetCurrentOperationName() = 'CalculateBasket') then
            exit;
        Clear(MICASplitLineManagement);

        // Add MICA Webshop comment
        XMLNodeBuff.AddFieldElement('Comment', SalesLine."MICA Countermark");

        // Split the line
        SalesReceivablesSetup.Get();
        SourceSalesLineNo := SalesLine."Line No.";
        if SalesLine.Type = SalesLine.Type::Item then
            if not SalesReceivablesSetup."MICA NotUse In Mem. Split Line" then begin
                DateTxtToDate(Params."MICA RequestedDeliveryDate", RequestedDeliveryDate);
                SalesLine."Requested Delivery Date" := RequestedDeliveryDate;
                MICASplitLineManagement.SplitLine(SalesLine, false, true, false);
                MICASplitLineManagement.GetTempSalesLine(TempSalesLine);
                UpdateOutXMLMessage(XMLNodeBuff, TempSalesLine, Params);
                Params."MICA Exceeded Quantity" += TempSalesLine.Quantity;
            end else begin
                MICASplitLineManagement.SplitLine(SalesLine, false, false, false);
                UpdateOutXMLMessage(XMLNodeBuff, SalesLine, Params);
                Params."MICA Exceeded Quantity" += SalesLine.Quantity;
            end;

        // Set filter to include from process MICA splitted line (Commitment)
        SalesLine.SETRANGE("MICA Split Source line No.");
        SalesLine.SETRANGE("MICA Splitted Line", FALSE);
        SalesLine.SETRANGE("Reserved Quantity");
    end;

    local procedure UpdateOutXMLMessage(var SCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var SalesLine: Record "Sales Line"; var SCParametersCollection: Record "SC - Parameters Collection")
    var
        TempSubLinesSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
    begin
        // Update out XML message
        if SCParametersCollection."MICA IsCompleteOrder" = 1 then begin
            SalesLine.SETRANGE("MICA Splitted Line", TRUE);
            SalesLine.SETRANGE("MICA Split Source line No.", SourceSalesLineNo);
            if SalesLine.findfirst() then begin
                SCXMLBufferdotNET.AddElement(TempSubLinesSCXMLBufferdotNET, 'SubLines', '');
                CreateCompleteOrderSubLinesXML(TempSubLinesSCXMLBufferdotNET, SalesLine);
            end;
        end else begin
            SalesLine.SETRANGE("MICA Splitted Line", TRUE);
            SalesLine.SETRANGE("MICA Split Source line No.", SourceSalesLineNo);
            SalesLine.SetRange("Reserved Quantity");
            if SalesLine.findfirst() then begin
                SCXMLBufferdotNET.AddElement(TempSubLinesSCXMLBufferdotNET, 'SubLines', '');
                CreateOrderSubLinesXML(TempSubLinesSCXMLBufferdotNET, SalesLine);
            end;
        end;
    end;

    local procedure CreateOrderSubLinesXML(var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var SalesLine: Record "Sales Line")
    var
        TempSubLineSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
    begin
        IF Salesline.FindSet(false, false) then
            repeat
                OutSCXMLBufferdotNET.AddElement(TempSubLineSCXMLBufferdotNET, 'SubLine', '');
                TempSubLineSCXMLBufferdotNET.AddFieldElement('PromisedDeliveryDate', COPYSTR(FORMAT(SalesLine."Promised Delivery Date"), 1, 1024));
                TempSubLineSCXMLBufferdotNET.AddFieldElement('Quantity', COPYSTR(FORMAT(SalesLine.Quantity), 1, 1024));
                TempSubLineSCXMLBufferdotNET.AddFieldElement('SubLineAmount', COPYSTR(FORMAT(SalesLine."Line Amount"), 1, 1024));
            until salesline.Next() = 0;
    end;

    local procedure CreateCompleteOrderSubLinesXML(var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var SalesLine: Record "Sales Line")
    var
        TempSubLineSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        LPromisedDDate: Date;
        LQuantity: Integer;
        LLineAmount: Decimal;
    begin
        IF Salesline.FindSet(false, false) then begin
            repeat
                if SalesLine."Promised Delivery Date" > LPromisedDDate then LPromisedDDate := SalesLine."Promised Delivery Date";
                LQuantity += SalesLine.Quantity;
                LLineAmount += SalesLine."Line Amount";
            until salesline.Next() = 0;
            OutSCXMLBufferdotNET.AddElement(TempSubLineSCXMLBufferdotNET, 'SubLine', '');
            TempSubLineSCXMLBufferdotNET.AddFieldElement('PromisedDeliveryDate', COPYSTR(FORMAT(LPromisedDDate), 1, 1024));
            TempSubLineSCXMLBufferdotNET.AddFieldElement('Quantity', COPYSTR(FORMAT(LQuantity), 1, 1024));
            TempSubLineSCXMLBufferdotNET.AddFieldElement('SubLineAmount', COPYSTR(FORMAT(LLineAmount), 1, 1024));
        end;
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
                if Year < 2000 then
                    Year := Year + 2000;
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