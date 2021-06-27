codeunit 80060 "MICA CustomerAssortment"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure onAfterValidateSalesLineNoEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrfieldNo: Integer)
    var
        TempSCCustAssortment: Record "SC - Cust. Assortment" temporary;
        Item: Record Item;
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
        SCWebshop: Record "SC - Webshop";
        SCCatalogHelper: Codeunit "SC - Catalog Helper";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckCustomerAssortment(Rec, IsHandled);
        if IsHandled then
            exit;

        if rec."Document Type" in [rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"] then
            exit;
        if rec.Type <> rec.type::Item then
            exit;
        if not Item.Get(Rec."No.") then
            exit;
        SCCatalogHelper.FindItemCustomerAssortment(Item, TempSCCustAssortment, TempSCParametersCollection);
        If not SCWebshop.FindFirst() then
            EXIT;
        IF not Item.Get(Rec."No.") then
            Exit;
        TempSCParametersCollection.InitializeEmptyParams();
        TempSCParametersCollection.WebsiteId := SCWebshop.ID;
        TempSCParametersCollection.MODIFY();
        SCCatalogHelper.FindItemCustomerAssortment(Item, TempSCCustAssortment, TempSCParametersCollection);
        FindCustCustomerAssortment(Rec, TempSCCustAssortment);
        FinditemCustomerAssortment(Rec, TempSCCustAssortment, Item);
        Rec."MICA Catalog Item No." := Rec."No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'MICA Catalog Item No.', false, false)]
    local procedure onAfterValidateSalesLineMICACatalogItemNoEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrfieldNo: Integer)
    var
        TxtCatalog_Err: label 'Type must be Item.';
    begin
        if rec."Document Type" in [rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"] then
            exit;
        if Rec.Type <> Rec.Type::Item then
            Error(TxtCatalog_Err);

        Rec.VALIDATE("No.", Rec."MICA Catalog Item No.");
    end;

    local procedure ShowCustomerAssortmentError()
    var
        SCExecutionContext: Codeunit "SC - Execution Context";
        CustAssortmentErr: Label 'This item doesn''t exist on the customer assortment';
    begin
        if not ((SCExecutionContext.GetCurrentOperationName() = 'CalculateBasket') and not GuiAllowed()) then
            error(CustAssortmentErr);
    end;

    procedure ShowCustomerAssortmentDenyError()
    var
        CustAssortmentErr: Label 'This item is not allowed';
    begin
        error(CustAssortmentErr);
    end;

    procedure FindCustCustomerAssortment(SalesLine: record "Sales Line"; var TempSCCustAssortment: Record "SC - Cust. Assortment")
    var
        Customer: Record Customer;
    begin
        If not Customer.get(SalesLine."Sell-to Customer No.") then
            exit;
        TempSCCustAssortment.SetRange("Sales Type", TempSCCustAssortment."Sales Type"::Customer);
        TempSCCustAssortment.SetRange("Sales Code", SalesLine."Sell-to Customer No.");
        if not TempSCCustAssortment.FINDSET() THEN
            if (Customer."Customer Price Group" <> '') then begin
                TempSCCustAssortment.SetRange("Sales Type", TempSCCustAssortment."Sales Type"::"Customer Price Group");
                TempSCCustAssortment.SetRange("Sales Code", Customer."Customer Price Group");
                if not TempSCCustAssortment.FINDSET() THEN
                    ShowCustomerAssortmentError();
            end else
                ShowCustomerAssortmentError();
    end;

    procedure FindItemCustomerAssortment(SalesLine: record "Sales Line"; var TempSCCustAssortment: Record "SC - Cust. Assortment"; Item: Record Item)
    begin
        TempSCCustAssortment.SetRange(Type, TempSCCustAssortment.Type::Item);
        TempSCCustAssortment.SetRange(Code, SalesLine."No.");
        if not TempSCCustAssortment.FindSet() then begin
            if Item."Item Category Code" <> '' THEN begin
                TempSCCustAssortment.SetRange(Type, TempSCCustAssortment.Type::"Item Category");
                TempSCCustAssortment.SetRange(code, item."Item Category Code");
                if not TempSCCustAssortment.FindSet() then
                    ShowCustomerAssortmentError()
                else
                    if TempSCCustAssortment.Mode = TempSCCustAssortment.Mode::Deny then
                        ShowCustomerAssortmentDenyError();
            END else
                ShowCustomerAssortmentError();
        end else
            if TempSCCustAssortment.Mode = TempSCCustAssortment.Mode::Deny then
                ShowCustomerAssortmentDenyError();
    end;

    Procedure OnAssistEditMICACatalogItemNo(VAR SalesLine: Record "Sales Line")
    var
        TmpSCCustAssortment: record "SC - Cust. Assortment";
        Customer: record customer;
        SalesHeader: Record "Sales Header";
        SCWebshop: Record "SC - Webshop";
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
        //SCCatalogHelper: Codeunit "SC - Catalog Helper";
        MICACustomerAssortment: codeunit "MICA CustomerAssortment";
        PageMICACustomerAssortment: page "MICA Customer Assortment";
        TxtCatalog_Err: label 'Type must be Item.';
    begin
        IF SalesLine.type <> SalesLine.type::Item then
            Error(TxtCatalog_Err);
        IF NOT SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.") then
            EXIT;
        IF NOT Customer.GET(SalesHeader."Sell-to Customer No.") THEN
            EXIT;
        If not SCWebshop.FindFirst() then
            EXIT;
        TempSCParametersCollection.InitializeEmptyParams();
        TempSCParametersCollection.WebsiteId := SCWebshop.ID;
        TempSCParametersCollection.MODIFY();
        /* SCCatalogHelper.FindItemCustomerAssortment(Item, TempCustAssort, Params);
        if customer."Customer Price Group" = '' then
            TempCustAssort.SetRange("Sales Code", Customer."No.")
        else
            TempCustAssort.Setfilter("Sales Code", '%1|%2', Customer."No.", customer."Customer Price Group");
        if TempCustAssort.FindSet() then begin
            repeat
                TempCustAssort2.COPY(TempCustAssort, true);
            until TempCustAssort.NEXT() = 0;
            TempCustAssort2.SETRANGE(Mode, TempCustAssort2.Mode::Deny);
            IF TempCustAssort2.FINDSET() then
                repeat
                    TempCustAssort.RESET();
                    TempCustAssort.setrange(code, TempCustAssort2.Code);
                    if TempCustAssort.FindSet() then
                        TempCustAssort.DELETEALL();
                until TempCustAssort2.next() = 0;
        end; */
        TmpSCCustAssortment.Reset();
        if customer."Customer Price Group" = '' then
            TmpSCCustAssortment.SetRange("Sales Code", Customer."No.")
        else
            TmpSCCustAssortment.Setfilter("Sales Code", '%1|%2', Customer."No.", customer."Customer Price Group");
        TmpSCCustAssortment.SetRange(Mode, TmpSCCustAssortment.Mode::Allow);
        TmpSCCustAssortment.SetRange(Type, TmpSCCustAssortment.type::Item);
        if TmpSCCustAssortment.FindSet() then
            CLEAR(PageMICACustomerAssortment);
        PageMICACustomerAssortment.LookupMode(true);
        PageMICACustomerAssortment.SetTableView(TmpSCCustAssortment);
        PageMICACustomerAssortment.SetRecord(TmpSCCustAssortment);
        if Page.RunModal(Page::"MICA Customer Assortment", TmpSCCustAssortment) = Action::LookupOK THEN BEGIN
            if TmpSCCustAssortment.Mode = TmpSCCustAssortment.Mode::Deny then
                MICACustomerAssortment.ShowCustomerAssortmentDenyError();
            SalesLine.Validate("No.", TmpSCCustAssortment.code);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckCustomerAssortment(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;
}