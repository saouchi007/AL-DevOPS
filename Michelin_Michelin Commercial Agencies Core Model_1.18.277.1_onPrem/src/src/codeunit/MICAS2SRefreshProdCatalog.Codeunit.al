codeunit 82860 "MICA S2S Refresh Prod. Catalog"
{
    trigger OnRun()
    var
        Item: Record Item;
    begin
        if Item.FindSet() then
            repeat
                RefreshForItem(Item);
            until Item.Next() = 0;
    end;

    local procedure RefreshForItem(Item: Record Item)
    var
        Customer: Record Customer;
        DeleteMICAS2SProductCatalog: Record "MICA S2S Product Catalog";
        MICAS2SProductCatalog: Record "MICA S2S Product Catalog";
        TempSCCustAssortment: Record "SC - Cust. Assortment" temporary;
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
        SCWebshop: Record "SC - Webshop";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        SCCatalogHelper: Codeunit "SC - Catalog Helper";
    begin
        DeleteMICAS2SProductCatalog.SetRange(itemNumber, Item."No.");
        DeleteMICAS2SProductCatalog.DeleteAll(true);
        SCCatalogHelper.FindItemCustomerAssortment(Item, TempSCCustAssortment, TempSCParametersCollection);
        if SCWebshop.FindFirst() then begin
            TempSCParametersCollection.InitializeEmptyParams();
            TempSCParametersCollection.WebsiteId := SCWebshop.ID;
            TempSCParametersCollection.MODIFY();
            SCCatalogHelper.FindItemCustomerAssortment(Item, TempSCCustAssortment, TempSCParametersCollection);
        end;
        TempSCCustAssortment.Reset();
        TempSCCustAssortment.SetRange("Sales Type", TempSCCustAssortment."Sales Type"::Customer);
        if TempSCCustAssortment.FindSet() then
            repeat
                MICAS2SProductCatalog.Init();
                MICAS2SProductCatalog.Validate(itemNumber, Item."No.");
                MICAS2SProductCatalog.Validate(itemId, Item.SystemId);
                MICAS2SProductCatalog.Validate(itemName, Item.Description);
                MICAS2SProductCatalog.Validate(itemLocation, Item."MICA Item Location Code");
                MICAS2SProductCatalog.Validate(Blocked, Item.Blocked);
                if Customer.Get(TempSCCustAssortment."Sales Code") then begin
                    MICAS2SProductCatalog.Validate(customerNumber, Customer."No.");
                    MICAS2SProductCatalog.Validate(customerId, Customer.SystemId);
                    MICAS2SProductCatalog.Validate(customerName, Customer.Name);
                    MICAS2SProductCatalog.Validate("MDM Bill-to Site Use ID", Customer."MICA MDM Bill-to Site Use ID");
                    if MICAFinancialReportingSetup.Get() then
                        MICAS2SProductCatalog.Validate("Company Code", MICAFinancialReportingSetup."Company Code");
                    FindBestPrice(MICAS2SProductCatalog);
                end;
            until TempSCCustAssortment.Next() = 0;
        TempSCCustAssortment.Reset();
        TempSCCustAssortment.SetRange("Sales Type", TempSCCustAssortment."Sales Type"::"Customer Price Group");
        if TempSCCustAssortment.FindSet() then
            repeat
                MICAS2SProductCatalog.Init();
                MICAS2SProductCatalog.Validate(itemNumber, Item."No.");
                MICAS2SProductCatalog.Validate(itemId, Item.SystemId);
                MICAS2SProductCatalog.Validate(itemName, Item.Description);
                Customer.SetCurrentKey("Customer Posting Group");
                Customer.SetRange("Customer Price Group", TempSCCustAssortment."Sales Code");
                if Customer.FindSet() then
                    repeat
                        MICAS2SProductCatalog.Validate(customerNumber, Customer."No.");
                        MICAS2SProductCatalog.Validate(customerId, Customer.SystemId);
                        MICAS2SProductCatalog.Validate(customerName, Customer.Name);
                        MICAS2SProductCatalog.Validate("MDM Bill-to Site Use ID", Customer."MICA MDM Bill-to Site Use ID");
                        if MICAFinancialReportingSetup.Get() then
                            MICAS2SProductCatalog.Validate("Company Code", MICAFinancialReportingSetup."Company Code");
                        FindBestPrice(MICAS2SProductCatalog);
                    until Customer.Next() = 0;
            until TempSCCustAssortment.Next() = 0;
    end;

    local procedure FindBestPrice(var MICAS2SProductCatalog: Record "MICA S2S Product Catalog")
    var
        TempSavedSalesPrice: Record "Sales Price" temporary;
        TempSalesPrice: Record "Sales Price" temporary;
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrentCurrency: Code[10];
        FirstLineCurrentCurrency: Boolean;
    begin
        if GeneralLedgerSetup.Get() then;
        FindPrice(MICAS2SProductCatalog.itemNumber, MICAS2SProductCatalog.customerNumber, TempSalesPrice);
        TempSalesPrice.Reset();
        TempSalesPrice.SetCurrentKey("Currency Code");
        TempSalesPrice.SetAscending("Currency Code", true);
        if TempSalesPrice.FindSet() then begin
            CurrentCurrency := TempSalesPrice."Currency Code";
            FirstLineCurrentCurrency := true;
            repeat
                if CurrentCurrency <> TempSalesPrice."Currency Code" then begin
                    UpdateS2SProductCatalogInfo(MICAS2SProductCatalog, TempSavedSalesPrice, GeneralLedgerSetup."LCY Code");
                    CurrentCurrency := TempSalesPrice."Currency Code";
                    clear(TempSavedSalesPrice);
                    FirstLineCurrentCurrency := true
                end;
                if FirstLineCurrentCurrency or (TempSavedSalesPrice."Unit Price" > TempSalesPrice."Unit Price") then begin
                    FirstLineCurrentCurrency := false;
                    TempSavedSalesPrice.TransferFields(TempSalesPrice);
                end;
            until TempSalesPrice.Next() = 0;
            UpdateS2SProductCatalogInfo(MICAS2SProductCatalog, TempSavedSalesPrice, GeneralLedgerSetup."LCY Code");
        end;
        TempSalesPrice.SetRange("Currency Code");
    end;

    local procedure UpdateS2SProductCatalogInfo(ReferenceMICAS2SProductCatalog: Record "MICA S2S Product Catalog"; SalesPrice: Record "Sales Price"; GLSetupLCY: Code[10])
    var
        MICAS2SProductCatalog: Record "MICA S2S Product Catalog";
        FindMICAS2SProductCatalog: Record "MICA S2S Product Catalog";

    begin
        MICAS2SProductCatalog.TransferFields(ReferenceMICAS2SProductCatalog);
        MICAS2SProductCatalog.Validate("Unit Price", SalesPrice."Unit Price");
        MICAS2SProductCatalog.Validate("Starting Date", SalesPrice."Starting Date");
        MICAS2SProductCatalog.Validate("Ending Date", SalesPrice."Ending Date");
        if (SalesPrice."Currency Code" = '') or (SalesPrice."Currency Code" = GLSetupLCY) then begin
            MICAS2SProductCatalog.Validate("Currency Code", GLSetupLCY);
            FindMICAS2SProductCatalog.SetRange(customerId, ReferenceMICAS2SProductCatalog.customerId);
            FindMICAS2SProductCatalog.SetRange(itemId, ReferenceMICAS2SProductCatalog.itemId);
            FindMICAS2SProductCatalog.SetRange("Currency Code", MICAS2SProductCatalog."Currency Code");
            if FindMICAS2SProductCatalog.FindFirst() then
                if FindMICAS2SProductCatalog."Unit Price" > MICAS2SProductCatalog."Unit Price" then begin
                    MICAS2SProductCatalog."Entry No." := FindMICAS2SProductCatalog."Entry No.";
                    MICAS2SProductCatalog.Modify(true);
                    exit
                end;
        end else
            MICAS2SProductCatalog.Validate("Currency Code", SalesPrice."Currency Code");
        MICAS2SProductCatalog.Insert(true);
    end;

    local procedure FindPrice(ItemNo: Code[20]; CustNo: Code[20]; var SalesPrice: Record "Sales Price" temporary);
    var
        TempPriceListLine: Record "Price List Line" temporary;
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        PriceSourceList: Codeunit "Price Source List";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        CopyFromToPriceListLine: Codeunit CopyFromToPriceListLine;
        SalesLinePrice: Codeunit "Sales Line - Price";
        PriceCalculation: Interface "Price Calculation";
        PriceType: Enum "Price Type";
        PriceSourceType: Enum "Price Source Type";
    begin

        if not Customer.get(CustNo) then
            exit;

        PriceSourceList.Init();
        PriceSourceList.Add(PriceSourceType::"All Customers");
        PriceSourceList.Add(PriceSourceType::"Customer Price Group", Customer."Customer Price Group");
        PriceSourceList.Add(PriceSourceType::Customer, Customer."No.");

        SalesLine.Init();
        SalesLine.Type := SalesLine.Type::Item;
        SalesLine."No." := ItemNo;
        SalesLine."Posting Date" := WorkDate();
        SalesLine.Quantity := 1;
        SalesLine."Currency Code" := 'EUR';

        SalesLinePrice.SetLine(PriceType::Sale, SalesLine);
        SalesLinePrice.SetSources(PriceSourceList);

        PriceCalculationMgt.GetHandler(SalesLinePrice, PriceCalculation);
        TempPriceListLine.SetRange("Currency Code", 'EUR');
        if PriceCalculation.FindPrice(TempPriceListLine, true) then
            CopyFromToPriceListLine.CopyTo(SalesPrice, TempPriceListLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteTableCustomer(var Rec: Record Customer)
    var
        MICAS2SProductCatalog: Record "MICA S2S Product Catalog";
    begin
        MICAS2SProductCatalog.SetRange(customerNumber, Rec."No.");
        MICAS2SProductCatalog.DeleteAll(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteTableItem(var Rec: Record Item)
    var
        MICAS2SProductCatalog: Record "MICA S2S Product Catalog";
    begin
        MICAS2SProductCatalog.SetRange(itemNumber, Rec."No.");
        MICAS2SProductCatalog.DeleteAll(true);
    end;
}