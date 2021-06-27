codeunit 80200 "MICA Express Order Management"
{
    trigger OnRun()
    begin

    end;


    ////////////////////////////////////////////////////////////Sell To/////////////////////////////////////////////////////////////////////
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnBeforeValidateSellToCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin

        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Address 2', false, false)]
    local procedure OnBeforeValidateSellToAddress2(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Address', false, false)]
    local procedure OnBeforeValidateSellToAddress(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to City', false, false)]
    local procedure OnBeforeValidateSellToCity(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Contact No.', false, false)]
    local procedure OnBeforeValidateSellToContactNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Contact', false, false)]
    local procedure OnBeforeValidateSellToContact(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Country/Region Code', false, false)]
    local procedure OnBeforeValidateSellToCountryRegionCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to County', false, false)]
    local procedure OnBeforeValidateSellToCounty(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Customer Name 2', false, false)]
    local procedure OnBeforeValidateSellToCustomerName2(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Customer Name', false, false)]
    local procedure OnBeforeValidateSellToCustomerName(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Customer Template Code', false, false)]
    local procedure OnBeforeValidateSellToCustomerTemplateCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to IC Partner Code', false, false)]
    local procedure OnBeforeValidateSellToICPartnerCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Post Code', false, false)]
    local procedure OnBeforeValidateSellToPostCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            Error(CanNotChangeSellToErr);
    end;


    ////////////////////////////////////////////////////////////Ship To/////////////////////////////////////////////////////////////////////
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to Name', false, false)]
    local procedure OnBeforeValidateShipToName(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to Name" <> '') then
                Error(CanNotChangeShipToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to Address 2', false, false)]
    local procedure OnBeforeValidateAddress2(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to Address 2" <> '') then
                Error(CanNotChangeShipToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to Address', false, false)]
    local procedure OnBeforeValidateAddress(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to Address" <> '') then
                Error(CanNotChangeShipToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to City', false, false)]
    local procedure OnBeforeValidateCity(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to City" <> '') then
                Error(CanNotChangeShipToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to Code', false, false)]
    local procedure OnBeforeValidateShipToCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to Code" <> '') then
                Error(CanNotChangeShipToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to Contact', false, false)]
    local procedure OnBeforeValidateShipToContact(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to Contact" <> '') then
                Error(CanNotChangeShipToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to Country/Region Code', false, false)]
    local procedure OnBeforeValidateShipToCountryRegionCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to Country/Region Code" <> '') then
                Error(CanNotChangeShipToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to County', false, false)]
    local procedure OnBeforeValidateShipToCounty(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to County" <> '') then
                Error(CanNotChangeShipToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to Name 2', false, false)]
    local procedure OnBeforeValidateShipToName2(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to Name 2" <> '') then
                Error(CanNotChangeShipToErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Ship-to Post Code', false, false)]
    local procedure OnBeforeValidateShipToPostCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        if not Rec.CheckThereIsNoLine() and (Rec."Document Type" = Rec."Document Type"::Order) then
            if (Rec."MICA Order Type" = Rec."MICA Order Type"::"Express Order") and (xRec."Ship-to Post Code" <> '') then
                Error(CanNotChangeShipToErr);
    end;
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesLine(var Rec: Record "Sales Line")
    begin
        CheckPossibleExpressOrderLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifySalesLine(var Rec: Record "Sales Line")
    begin
        CheckPossibleExpressOrderLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Quantity', false, false)]
    local procedure OnBeforeValidateQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
        SCExecutionContext: Codeunit "SC - Execution Context";
    begin
        SalesReceivablesSetup.Get();
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            if not ((SCExecutionContext.GetCurrentOperationName() = 'CalculateBasket') and (not IsNullGuid(SalesHeader."SC Unique Webshop Document Id"))) then
                if Rec.OrderIsExpressOrder() and ((SalesHeader.GetTotalItemQuantity() - xRec.Quantity + Rec.Quantity) > SalesReceivablesSetup."MICA Express Order Qty Max") then
                    Error(QtyOverExpressOrderQtyMaxErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure OnBeforeValidateNo(var Rec: Record "Sales Line")
    begin
        CheckPossibleExpressOrderLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnAfterValidateLocationCodeSalesLine(var Rec: Record "Sales Line")
    var
        Location: Record Location;
    begin
        if (Rec."Document Type" = Rec."Document Type"::Order) and (Rec.Type = Rec.Type::Item) then
            if Rec.OrderIsExpressOrder() then
                if Location.Get(Rec."Location Code") then begin
                    Rec.Validate("Outbound Whse. Handling Time", Location."MICA Outb Whse Hand T Exp Ord");
                    if Rec.Modify() then;
                end;

    end;

    local procedure CheckPossibleExpressOrderLine(SalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        if (SalesLine."Document Type" = SalesLine."Document Type"::Order) and (SalesLine.Type = SalesLine.Type::Item) then
            if SalesLine.OrderIsExpressOrder() then
                if Item.Get(SalesLine."No.") then
                    if not Item."MICA Express Order" then
                        Error(ItemNotOrderableExpressOrdersErr, Item."No.");
    end;

    var
        QtyOverExpressOrderQtyMaxErr: Label 'Total Quantity is greater than Max Qty allowed for Express Orders';
        CanNotChangeSellToErr: Label 'You cannot change the Sell To because there is at least one line';
        CanNotChangeShipToErr: Label 'You cannot change the Ship To because there is at least one line';
        ItemNotOrderableExpressOrdersErr: Label 'Item %1 is not orderable in Express orders.';
}