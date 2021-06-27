codeunit 80300 "MICA Prepayment Management"
{
    [EventSubscriber(ObjectType::table, database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateSellToCustNoSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
    begin
        IF NOT Customer.Get(Rec."Sell-to Customer No.") then
            EXIT;
        Rec.TestField("MICA Prepaid Amount", 0);
        Rec."MICA % Of Prepayment" := Customer."MICA % Of Prepayment";

        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.setrange("Document No.", rec."No.");
        if SalesLine.FindFirst() then
            UpdateSalesHeaderPrepaymentAmt(Rec, SalesLine)
        else
            rec."MICA Prepayment Amount" := 0;
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    local procedure OnafterUpdateAmountsDonePrepaymtMgt(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    var
        SalesHeader: record "Sales Header";
    begin
        GetSalesHeader(SalesHeader, SalesLine);
        UpdateSalesHeaderPrepaymentAmt(salesheader, SalesLine);
        SalesHeader.Modify();
    end;

    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEvent(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: record "Sales Header";
        MICASalesSingleInstance: Codeunit "MICA Sales Single Instance";
    begin
        if MICASalesSingleInstance.HeaderIsBeingDeleted(Rec) then
            exit;
        IF SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec."Amount Including VAT" := 0;
            UpdateSalesHeaderPrepaymentAmt(SalesHeader, Rec);
            SalesHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesDocument', '', false, false)]
    local procedure OnAfterCopySalesDocumentPrepaymentMgt(FromDocumentType: Option; FromDocumentNo: Code[20]; VAR ToSalesHeader: Record "Sales Header"; FromDocOccurenceNo: Integer; FromDocVersionNo: Integer; IncludeHeader: Boolean)
    begin
        //Retrieve ToSalesHeader record back again from database because it has been modified since the last retrieve
        if not ToSalesHeader.get(ToSalesHeader."Document Type", ToSalesHeader."No.") then
            exit;
        If ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::Order then begin
            ToSalesHeader."MICA Prepaid Amount" := 0;
            ToSalesHeader.Modify();
        end;

    end;

    local procedure GetSalesHeader(var SalesHeader: record "Sales Header"; SalesLine: Record "Sales Line")
    var
        SalesHeader_Err: label 'Sales Header does not exist.';
    begin
        IF Not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            error(SalesHeader_Err)
    end;

    local procedure UpdateSalesHeaderPrepaymentAmt(var SalesHeader: Record "Sales Header"; SalesLine: record "Sales Line")
    var
        CalcSalesLine: Record "Sales Line";
        Currency: record Currency;
    begin
        if SalesHeader."MICA % Of Prepayment" > 0 then begin
            CalcSalesLine.setrange("Document Type", SalesLine."Document Type");
            CalcSalesLine.SetRange("Document No.", SalesLine."Document No.");
            CalcSalesLine.SETFILTER("Line No.", '<>%1', SalesLine."Line No.");
            CalcSalesLine.CalcSums("Amount Including VAT");

            SalesHeader."MICA Prepayment Amount" := ROUND((CalcSalesLine."Amount Including VAT" + SalesLine."Amount Including VAT") * SalesHeader."MICA % Of Prepayment" / 100, Currency."Amount Rounding Precision");
        end else
            if SalesHeader."MICA Prepayment Amount" <> 0 then
                salesheader."MICA Prepayment Amount" := 0;
    end;
}
