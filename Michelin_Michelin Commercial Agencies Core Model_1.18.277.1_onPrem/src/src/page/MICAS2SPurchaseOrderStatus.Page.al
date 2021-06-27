page 82874 "MICA S2S Purchase Order Status"
{
    PageType = API;
#if not OnPremise
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif 
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 'statusPurchaseOrder', Locked = true;
    EntityName = 'statusPurchaseOrder';
    EntitySetName = 'statusPurchaseOrders';
    ODataKeyFields = SystemId;
    SourceTable = "Purchase Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
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
                field(number; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'number', Locked = true;
                }
                field(orderDate; Rec."Order Date")
                {
                    ApplicationArea = All;
                    Caption = 'orderDate', Locked = true;
                }
                field(postingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'postingDate', Locked = true;
                }
                field(vendorNumber; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'vendorNumber', Locked = true;
                }
                field(buyFromVendorName; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    caption = 'buyFromVendorName', Locked = true;
                }

                field(buyFromAddressLine1; Rec."Buy-From Address")
                {
                    ApplicationArea = All;
                    Caption = 'buyFromAddressLine1', Locked = true;
                }
                field(buyFromAddressLine2; Rec."Buy-From Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'buyFromAddressLine2', Locked = true;
                }

                field(buyFromCity; Rec."Buy-From City")
                {
                    ApplicationArea = All;
                    Caption = 'buyFromCity', Locked = true;
                }
                field(buyFromState; Rec."Buy-From County")
                {
                    ApplicationArea = All;
                    Caption = 'buyFromState', Locked = true;
                }
                field(buyFromCountry; Rec."Buy-From Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'buyFromCountry', Locked = true;
                }
                field(buyFromPostCode; Rec."Buy-From Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'buyFromPostCode', Locked = true;
                }
                field(buyFromContact; Rec."Buy-from Contact No.")
                {
                    ApplicationArea = All;
                    Caption = 'buyFromContact', Locked = true;
                }
                field(payToVendorNumber; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'payToVendorNumber', Locked = true;
                }
                field(payToVendorName; Vendor.Name)
                {
                    ApplicationArea = All;
                    Caption = 'payToVendorName', Locked = true;
                }
                field(paytoAddressLine1; Rec."Pay-to Address")
                {
                    ApplicationArea = All;
                    Caption = 'paytoAddressLine1', Locked = true;
                }
                field(paytoAddressLine2; Rec."Pay-to Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'paytoAddressLine2', Locked = true;
                }

                field(paytoCity; Rec."Pay-to City")
                {
                    ApplicationArea = All;
                    Caption = 'paytoCity', Locked = true;
                }
                field(paytoState; Rec."Pay-to County")
                {
                    ApplicationArea = All;
                    Caption = 'paytoState', Locked = true;
                }
                field(paytoCountry; Rec."Pay-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'paytoCountry', Locked = true;
                }
                field(paytoPostCode; Rec."Pay-to Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'paytoPostCode', Locked = true;
                }
                field(payToContact; Rec."Pay-to Contact")
                {
                    ApplicationArea = All;
                    Caption = 'payToContact', Locked = true;
                }
                field(shipToCode; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'shipToCode', Locked = true;
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'shipToName', Locked = true;
                }
                field(shipToLineAddress1; Rec."Ship-To Address")
                {
                    ApplicationArea = All;
                    Caption = 'shipToLineAddress1', Locked = true;
                }
                field(shipToLineAddress2; Rec."Ship-To Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'shipToLineAddress2', Locked = true;
                }

                field(shipToCity; Rec."Ship-To City")
                {
                    ApplicationArea = All;
                    Caption = 'shipToCity', Locked = true;
                }
                field(shipToState; Rec."Ship-To County")
                {
                    ApplicationArea = All;
                    Caption = 'shipToState', Locked = true;
                }
                field(shipToCountry; Rec."Ship-To Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'shipToCountry', Locked = true;
                }
                field(shipToPostCode; Rec."Ship-To Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'shipToPostCode', Locked = true;
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    Caption = 'shipToContact', Locked = true;
                }
                field(currencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Caption = 'currencyCode', Locked = true;
                }
                field(currencyFactor; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                    Caption = 'currencyFactor', Locked = true;
                }
                field(pricesIncludeTax; Rec."Prices Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'pricesIncludeTax', Locked = true;
                }
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    Caption = 'PaymentTermsCode', Locked = true;
                }
                field(paymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                    Caption = 'paymentMethodCode', Locked = true;
                }
                field(shipmentMethodCode; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                    Caption = 'shipmentMethodCode', Locked = true;
                }
                field(purchaser; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    Caption = 'purchaser', Locked = true;
                }
                field(requestedReceiptDate; Rec."Requested Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'requestedReceiptDate', Locked = true;
                }
                field(discountAmount; Rec."Invoice Discount Amount")
                {
                    ApplicationArea = All;
                    Caption = 'discountAmount', Locked = true;
                }
                field(discountAppliedBeforeTax; DiscountAppliedBeforeTax)
                {
                    ApplicationArea = All;
                    Caption = 'discountAppliedBeforeTax', Locked = true;
                }
                field(totalAmountExcludingTax; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'totalAmountExcludingTax', Locked = true;
                }
                field(totalTaxAmount; TotalTaxAmount)
                {
                    ApplicationArea = All;
                    Caption = 'totalTaxAmount', Locked = true;
                }
                field(totalAmountIncludingTax; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'totalAmountIncludingTax', Locked = true;
                }
                field(fullyReceived; Rec."Completely Received")
                {
                    ApplicationArea = All;
                    Caption = 'fullyReceived', Locked = true;
                }
                field(status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'status', Locked = true;
                }

                field(dueDate; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'dueDate', Locked = true;
                }
                field(locationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'locationCode', Locked = true;
                }

                field(vendorOrderNumber; Rec."Vendor Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'vendorOrderNumber', Locked = true;
                }
                field(vendorShipmentNumber; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = All;
                    Caption = 'vendorShipmentNumber', Locked = true;
                }

                field(vendorInvoiceNumber; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = All;
                    Caption = 'vendorInvoiceNumber', Locked = true;
                }

                field(documentDate; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'documentDate', Locked = true;
                }
                field(expectedReceiptDate; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'expectedReceiptDate', Locked = true;
                }
                field(languageCode; Rec."Language Code")
                {
                    ApplicationArea = All;
                    Caption = 'languageCode', Locked = true;
                }
                field(alNumber; Rec."MICA AL No.")
                {
                    ApplicationArea = All;
                    Caption = 'alNumber', Locked = true;
                }
                field(shipmentInstructions; Rec."MICA Shipment Instructions")
                {
                    ApplicationArea = All;
                    Caption = 'shipmentInstructions', Locked = true;
                }
                field(srdDate; Rec."MICA SRD")
                {
                    ApplicationArea = All;
                    Caption = 'srdDate', Locked = true;
                }
                field(etaDate; Rec."MICA ETA")
                {
                    ApplicationArea = All;
                    Caption = 'etaDate', Locked = true;
                }
                field(locationToCode; Rec."MICA Location-To Code")
                {
                    ApplicationArea = All;
                    Caption = 'locationToCode', Locked = true;
                }


                field(gisRelfactCode; Rec."MICA RELFAC Code")
                {
                    ApplicationArea = All;
                    Caption = 'gisRelfactCode', Locked = true;
                }
                field(gisTotalInvoiceAmount; Rec."MICA Total Inv. Amt.(excl.VAT)")
                {
                    ApplicationArea = All;
                    Caption = 'gisTotalInvoiceAmount', Locked = true;
                }
                field(gisOriginalInvoiceNum; Rec."MICA GIS Invoice Doc. No.")
                {
                    ApplicationArea = All;
                    Caption = 'gisOriginalInvoiceNum', Locked = true;
                }
                field(gisTotalInvoiceDate; Rec."MICA GIS Invoice Doc. Date")
                {
                    ApplicationArea = All;
                    Caption = 'gisTotalInvoiceDate';
                }
                field(gisRebillReasonCode; Rec."MICA GIS Rebill Reason Code")
                {
                    ApplicationArea = All;
                    Caption = 'gisRebillReasonCode';
                }
            }
        }
    }
    trigger OnInit()
    begin
        MICAFinancialReportingSetup.Get();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ClearCalculatedFields();
        SetCalculatedFields();
    end;

    local procedure SetCalculatedFields()
    begin
        if Vendor.Get(Rec."Pay-to Vendor No.") then;
        AssignTotalsFromPurchaseHeader(Rec);
    end;

    local procedure AssignTotalsFromPurchaseHeader(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        TotalPurchaseLine: Record "Purchase Line";
        DocumentTotals: Codeunit "Document Totals";
    begin
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");

        if not PurchaseLine.FindFirst() then begin
            DiscountAppliedBeforeTax := false;
            TotalTaxAmount := 0;
            exit;
        end;

        if PurchaseLine."VAT Calculation Type" = PurchaseLine."VAT Calculation Type"::"Sales Tax" then
            DiscountAppliedBeforeTax := true
        else
            DiscountAppliedBeforeTax := not PurchaseHeader."Prices Including VAT";

        DocumentTotals.CalculatePurchaseTotals(TotalPurchaseLine, TotalTaxAmount, PurchaseLine);
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(Vendor);
        DiscountAppliedBeforeTax := false;
        TotalTaxAmount := 0
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        Vendor: Record Vendor;
        DiscountAppliedBeforeTax: Boolean;
        TotalTaxAmount: Decimal;
}