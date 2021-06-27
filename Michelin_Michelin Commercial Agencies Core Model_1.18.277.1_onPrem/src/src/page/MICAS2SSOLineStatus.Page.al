page 82866 "MICA S2S SO. Line Status"
{
    PageType = API;
#if not OnPremise
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif  
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 'statusSalesOrderLine', Locked = true;
    EntityName = 'statusSalesOrderLine';
    EntitySetName = 'statusSalesOrderLines';
    ODataKeyFields = SystemId;
    SourceTable = "Sales Line";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'id', Locked = true;
                }
                field(companyCode; MICAFinancialReportingSetup."Company Code")
                {
                    ApplicationArea = All;
                    Caption = 'companyCode', Locked = true;
                }
                field(sequence; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'sequence', Locked = true;
                }
                field(number; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'number', Locked = true;
                }
                field(lineType; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'lineType';
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'description', Locked = true;
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Caption = 'unitOfMeasureCode', Locked = true;
                }
                field(quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'quantity', Locked = true;
                }
                field(unitPrice; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'unitPrice', Locked = true;
                }
                field(discountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    Caption = 'discountAmount', Locked = true;
                }
                field(discountPercent; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Caption = 'discountPercent', Locked = true;
                }
                field(discountAppliedBeforeTax; DiscountAppliedBeforeTax)
                {
                    ApplicationArea = All;
                    Caption = 'discountAppliedBeforeTax', Locked = true;
                }
                field(amountExcludingTax; Rec.GetLineAmountExclVAT())
                {
                    ApplicationArea = All;
                    Caption = 'amountExcludingTax', Locked = true;
                }
                field(taxCode; TaxCode)
                {
                    ApplicationArea = All;
                    Caption = 'taxCode', Locked = true;
                }
                field(taxPercent; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'taxPercent', Locked = true;
                }
                field(totalTaxAmount; Rec.GetLineAmountInclVAT() - Rec.GetLineAmountExclVAT())
                {
                    ApplicationArea = All;
                    Caption = 'totalTaxAmount', Locked = true;
                }
                field(amountIncludingTax; Rec.GetLineAmountInclVAT())
                {
                    ApplicationArea = All;
                    Caption = 'amountIncludingTax', Locked = true;
                }
                field(invoiceDiscountAllocation; InvDiscountAmountExclVAT)
                {
                    ApplicationArea = All;
                    Caption = 'invoiceDiscountAllocation', Locked = true;
                }
                field(netAmount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'netAmount', Locked = true;
                }
                field(netTaxAmount; Rec."Amount Including VAT" - Rec."VAT Base Amount")
                {
                    ApplicationArea = All;
                    Caption = 'netTaxAmount', Locked = true;
                }
                field(netAmountIncludingTax; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'netAmountIncludingTax', Locked = true;
                }
                field(shipmentDate; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    Caption = 'shipmentDate', Locked = true;
                }
                field(shippedQuantity; Rec."Quantity Shipped")
                {
                    ApplicationArea = All;
                    Caption = 'shippedQuantity', Locked = true;
                }
                field(invoicedQuantity; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                    Caption = 'invoicedQuantity', Locked = true;
                }
                field(invoiceQuantity; Rec."Qty. to Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'invoiceQuantity', Locked = true;
                }
                field(shipQuantity; Rec."Qty. to Ship")
                {
                    ApplicationArea = All;
                    Caption = 'shipQuantity', Locked = true;
                }
                field(shippedNotInvoicedQty; Rec."Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = All;
                    Caption = 'shippedNotInvoicedQty', Locked = true;
                }
                field(marketCode; item."MICA Market Code")
                {
                    ApplicationArea = All;
                    Caption = 'marketCode', Locked = true;
                }
                field(forecastCustomerCode; MICAForecastCustomerCode."Forecast Code")
                {
                    ApplicationArea = All;
                    Caption = 'forecastCustomerCode', Locked = true;
                }
                field(splitSourceLineNo; Rec."MICA Split Source line No.")
                {
                    ApplicationArea = All;
                    Caption = 'splitSourceLineNo', Locked = true;
                }
                field(locationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'locationCode', Locked = true;
                }
                field(locationCountryCode; Location."Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'locationCountryCode', Locked = true;
                }
                field(locationInventoryOrg; Location."MICA Inventory Organization")
                {
                    ApplicationArea = All;
                    Caption = 'locationInventoryOrg', Locked = true;
                }
                field(itemCode; Item."No.")
                {
                    ApplicationArea = All;
                    Caption = 'itemCode';
                }
                field(itemCategoryCode; Item."Item Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'itemCategoryCode';
                }
                field(catalogItemNumber; Rec."MICA Catalog Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'catalogItemNumber';
                }
                field(crossReferenceNo; Rec."Cross-Reference No.")
                {
                    ApplicationArea = All;
                    Caption = 'crossReferenceNo';
                }
                field(accountNumber; GLAccNo)
                {
                    ApplicationArea = All;
                }
                field(unitCost; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'unitCost';
                }
                field(exceptRebatePercent; Rec."MICA Exceptional Disc. %")
                {
                    ApplicationArea = All;
                    Caption = 'exceptRebatePercent';
                }
                field(exceptRebateReason; Rec."MICA Except. Rebate Reason")
                {
                    ApplicationArea = All;
                    Caption = 'exceptRebateReason';
                }
                field(salesAgreementNumber; Rec."MICA Sales Agreement No.")
                {
                    ApplicationArea = All;
                    Caption = 'salesAgreementNumber';
                }
                field(paymentTermsCode; Rec."MICA Payment Terms Code")
                {
                    ApplicationArea = All;
                    Caption = 'paymentTermsCode';
                }
                field(paymentMethodCode; Rec."MICA Payment Method Code")
                {
                    ApplicationArea = All;
                    Caption = 'paymentMethodCode';
                }
                field(status; Rec."MICA Status")
                {
                    ApplicationArea = All;
                    Caption = 'status';
                }
                field(requestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'requestedDeliveryDate';
                }
                field(promisedDeliveryDate; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'promisedDeliveryDate';
                }
                field(plannedDeliveryDate; Rec."Planned Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'plannedDeliveryDate';
                }
                field(plannedShipmentDate; Rec."Planned Shipment Date")
                {
                    ApplicationArea = All;
                    Caption = 'plannedShipmentDate';
                }
                field(shipmentPostingDate; SalesShipmentLine."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'shipmentPostingDate';
                }
                field(modifiedDeliveryDate; Rec."MICA Delivery Date Modified")
                {
                    ApplicationArea = All;
                    Caption = 'modifiedDeliveryDate';
                }
                field(requestedReceiptDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'requestedReceiptDate';
                }
                field(promisedReceiptDate; Rec."MICA Promised Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'promisedReceiptDate';
                }
                field(cancelled; Rec."MICA Cancelled")
                {
                    ApplicationArea = All;
                    Caption = 'cancelled';
                }
                field(cancelReason; Rec."MICA Cancel. Reason")
                {
                    ApplicationArea = All;
                    Caption = 'cancelReason';
                }
                field(cancelReasonRef; MICACancelReason."CT2 Referential Code")
                {
                    ApplicationArea = All;
                    Caption = 'cancelReasonRef';
                }
                field(cancelQuantity; CancelQuantity)
                {
                    ApplicationArea = All;
                    Caption = 'cancelQuantity';
                }
                field(lastDateUpdateStatus; Rec."MICA Last Date Update Status")
                {
                    ApplicationArea = All;
                    Caption = 'lastDateUpdateStatus';
                }
                field(originalCommitmentDate; Rec."MICA Source Line Commit Date")
                {
                    ApplicationArea = All;
                    Caption = 'originalCommitmentDate';
                }
                field(dotValue; Rec."MICA 3PL DOT Value")
                {
                    ApplicationArea = All;
                    Caption = 'dotValue';
                }
                field(countryOfOrigin; Rec."MICA 3PL Country Of Origin")
                {
                    ApplicationArea = All;
                    Caption = 'countryOfOrigin';
                }
                field(warehouseShipComment; Rec."MICA 3PL Whse Shpt. Comment")
                {
                    ApplicationArea = All;
                    Caption = 'warehouseShipComment';
                }
                field(shippingTime; calcdate(Rec."Shipping Time", Today()) - Today())
                {
                    ApplicationArea = All;
                    Caption = 'shippingTime';
                }
                field(shippingAgentCode; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    Caption = 'shippingAgentCode';
                }
                field(shippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                    Caption = 'shippingAgentServiceCode';
                }
                field(priorityCode; Rec."MICA Priority Code")
                {
                    ApplicationArea = All;
                    Caption = 'priorityCode';
                }
                field(priorityDescription; MICAPriority.Description)
                {
                    ApplicationArea = All;
                    Caption = 'priorityDescription';
                }
                field(postedShipmentNumber; SalesShipmentLine."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'postedShipmentNumber';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ClearCalculatedFields();
        SetCalculatedFields();
    end;


    local procedure SetCalculatedFields()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if Location.get(Rec."Location Code") then;
        if MICAPriority.get(Rec."MICA Priority Code") then;

        SalesShipmentLine.Reset();
        SalesShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
        SalesShipmentLine.setrange("Order No.", Rec."Document No.");
        SalesShipmentLine.setrange("Order Line No.", Rec."Line No.");
        if SalesShipmentLine.findlast() then;

        if Rec.Type = Rec.Type::"G/L Account" then
            GLAccNo := Rec."No.";

        if Rec.Type = Rec.Type::Item then
            if item.get(Rec."No.") then;

        if Rec."MICA Cancel. Reason" <> '' then begin
            if MICACancelReason.get(MICACancelReason."Table Type"::SalesLineCancelReasonCode, Rec."MICA Cancel. Reason") then;
            CancelQuantity := Rec."Outstanding Quantity";
        end;

        if MICAForecastCustomerCode.get(Rec."Bill-to Customer No.", item."Item Category Code") then;

        if GeneralLedgerSetup.UseVat() then
            TaxCode := Rec."VAT Identifier"
        else
            TaxCode := Rec."Tax Group Code";

        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            if SalesHeader."Prices Including VAT" then
                InvDiscountAmountExclVAT := Rec."Line Discount Amount"
            else
                InvDiscountAmountExclVAT := Rec."Inv. Discount Amount";
            if Rec."VAT Calculation Type" = Rec."VAT Calculation Type"::"Sales Tax" then
                DiscountAppliedBeforeTax := true
            else
                DiscountAppliedBeforeTax := not SalesHeader."Prices Including VAT";
        end;

    end;


    trigger OnInit()
    begin
        MICAFinancialReportingSetup.Get();
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(Location);
        Clear(Item);
        Clear(MICAPriority);
        Clear(SalesShipmentLine);
        Clear(MICACancelReason);
        Clear(MICAForecastCustomerCode);
        Clear(GLAccNo);
        Clear(CancelQuantity);
        Clear(TaxCode);
        Clear(InvDiscountAmountExclVAT);
        Clear(DiscountAppliedBeforeTax);
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        Location: Record Location;
        Item: Record Item;
        MICAPriority: Record "MICA Priority";
        SalesShipmentLine: Record "Sales Shipment Line";
        MICACancelReason: Record "MICA Table Value";
        MICAForecastCustomerCode: Record "MICA Forecast Customer Code";
        SalesHeader: Record "Sales Header";
        GLAccNo: Code[20];
        TaxCode: Code[50];
        CancelQuantity: decimal;
        InvDiscountAmountExclVAT: Decimal;
        DiscountAppliedBeforeTax: Boolean;
}