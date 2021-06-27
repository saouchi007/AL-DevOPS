page 82865 "MICA S2S Sales Order Status"
{

    PageType = API;
#if not OnPremise
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif  
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 'statusSalesOrder', Locked = true;
    EntityName = 'statusSalesOrder';
    EntitySetName = 'statusSalesOrders';
    ODataKeyFields = SystemId;
    SourceTable = "Sales Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = true;
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
                field(customerNumber; Rec."Sell-to Contact No.")
                {
                    ApplicationArea = All;
                    Caption = 'customerNumber', Locked = true;
                }
                field(customerName; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'customerName', Locked = true;
                }
                field(currencyCode; Currency.Code)
                {
                    ApplicationArea = All;
                    Caption = 'currencyCode', Locked = true;
                }
                field(pricesIncludeTax; Rec."Prices Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'pricesIncludeTax', Locked = true;
                }
                field(paymentTerms; PaymentTerms.Description)
                {
                    ApplicationArea = All;
                    Caption = 'PaymentTerms', Locked = true;
                }
                field(salesperson; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Caption = 'salesperson', Locked = true;
                }
                field(partialShipping; PartialShipping)
                {
                    ApplicationArea = All;
                    Caption = 'partialShipping', Locked = true;
                }
                field(requestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    Caption = 'requestedDeliveryDate', Locked = true;
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
                field(fullyShipped; Rec."Completely Shipped")
                {
                    ApplicationArea = All;
                    Caption = 'fullyShipped', Locked = true;
                }
                field(status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'status', Locked = true;
                }
                field(billToName; Rec."Bill-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'billToName', Locked = true;
                }
                field(billToCustomerNumber; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'billToCustomerNumber', Locked = true;
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'shipToName', Locked = true;
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    Caption = 'shipToContact', Locked = true;
                }
                field(documentDate; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'documentDate', Locked = true;
                }
                field(orderType; Rec."MICA Order Type")
                {
                    ApplicationArea = All;
                    Caption = 'orderType', Locked = true;
                }
                field(billToCode; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'billToCode', Locked = true;
                }
                field(sellToCode; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'sellToSiteId', Locked = true;
                }
                field(shipToCode; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'shipToCode', Locked = true;
                }
                field(customerSearchName; SellCustomer."Search Name")
                {
                    ApplicationArea = All;
                    Caption = 'customerSearchName', Locked = true;
                }
                field(customerEnglishName; SellCustomer."MICA English Name")
                {
                    ApplicationArea = All;
                    Caption = 'customerEnglishName', Locked = true;
                }
                field(combineShipment; Rec."Combine Shipments")
                {
                    ApplicationArea = All;
                    Caption = 'combineShipment', Locked = true;
                }
                field(createdBy; Rec."MICA Created By")
                {
                    ApplicationArea = All;
                    Caption = 'createdBy', Locked = true;
                }
                field(yourReference; Rec."Your Reference")
                {
                    ApplicationArea = All;
                    Caption = 'yourReference', Locked = true;
                }
                field(languageCode; Rec."Language Code")
                {
                    ApplicationArea = All;
                    Caption = 'languageCode', Locked = true;
                }
                field(shipmentPostOption; Rec."MICA Shipment Post Option")
                {
                    ApplicationArea = All;
                    Caption = 'shipmentPostOption', Locked = true;
                }
                field(customerTransport; Rec."MICA Customer Transport")
                {
                    ApplicationArea = All;
                    Caption = 'customerTransport', Locked = true;
                }
                field(truckDriverInfo; Rec."MICA Truck Driver Info")
                {
                    ApplicationArea = All;
                    Caption = 'truckDriverInfo', Locked = true;
                }
                field(truckLicensePlate; Rec."MICA Truck License Plate")
                {
                    ApplicationArea = All;
                    Caption = 'truckLicensePlate', Locked = true;
                }
                field(automaticReleaseDate; Rec."MICA Automatic Release Date")
                {
                    ApplicationArea = All;
                    Caption = 'automaticReleaseDate', Locked = true;
                }
                field(salesAgreement; Rec."MICA Sales Agreement")
                {
                    ApplicationArea = All;
                    Caption = 'salesAgreement', Locked = true;
                }
                field(lastModifiedDateTime; Rec."MICA Last Modified Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'lastModifiedDateTime', Locked = true;
                }
                field(sellToAddress1; Rec."Sell-to Address")
                {
                    ApplicationArea = All;
                    Caption = 'sellToAddress1', Locked = true;
                }
                field(sellToAddress2; Rec."Sell-to Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'sellToAddress2', Locked = true;
                }
                field(sellToPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'sellToPostCode', Locked = true;
                }
                field(sellToCity; Rec."Sell-to City")
                {
                    ApplicationArea = All;
                    Caption = 'sellToCity', Locked = true;
                }
                field(sellToCountry; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'sellToCountry', Locked = true;
                }
                field(sellToState; Rec."Sell-to County")
                {
                    ApplicationArea = All;
                    Caption = 'sellToState', Locked = true;
                }
                field(shipToAddress1; Rec."Ship-To Address")
                {
                    ApplicationArea = All;
                    Caption = 'shipToAddress1', Locked = true;
                }
                field(shipToAddress2; Rec."Ship-To Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'shipToAddress2', Locked = true;
                }
                field(shipToPostCode; Rec."Ship-To Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'shipToPostCode', Locked = true;
                }
                field(shipToCity; Rec."Ship-To City")
                {
                    ApplicationArea = All;
                    Caption = 'shipToCity', Locked = true;
                }
                field(shipToCountry; Rec."Ship-To Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'shipToCountry', Locked = true;
                }
                field(shipToState; Rec."Ship-To County")
                {
                    ApplicationArea = All;
                    Caption = 'shipToState', Locked = true;
                }
                field(billToAddress1; Rec."Bill-To Address")
                {
                    ApplicationArea = All;
                    Caption = 'billToAddress1', Locked = true;
                }
                field(billToAddress2; Rec."Bill-To Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'billToAddress2', Locked = true;
                }
                field(billToPostCode; Rec."Bill-To Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'billToPostCode', Locked = true;
                }
                field(billToCity; Rec."Bill-To City")
                {
                    ApplicationArea = All;
                    Caption = 'billToCity', Locked = true;
                }
                field(billToCountry; Rec."Bill-To Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'billToCountry', Locked = true;
                }
                field(billToState; Rec."Bill-To County")
                {
                    ApplicationArea = All;
                    Caption = 'billToState', Locked = true;
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
    var

        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        PartialShipping := (Rec."Shipping Advice" = Rec."Shipping Advice"::Partial);

        if Rec.get(Rec."Document Type"::Order, Rec."No.") then;
        if SellCustomer.Get(Rec."Sell-to Customer No.") then;
        if BillCustomer.Get(rec."Bill-to Customer No.") then;
        if Contact.Get(Rec."Sell-to Contact No.") then;
        if GeneralLedgerSetup.Get() then;
        if Rec."Currency Code" = '' then begin
            if Currency.Get(GeneralLedgerSetup."LCY Code") then;
        end else
            if Currency.Get(Rec."Currency Code") then;
        if PaymentTerms.Get(Rec."Payment Terms Code") then;
        AssignTotalsFromSalesHeader(Rec);
    end;

    local procedure AssignTotalsFromSalesHeader(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        TotalSalesLine: Record "Sales Line";
        DocumentTotals: Codeunit "Document Totals";
    begin
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");

        if not SalesLine.FindFirst() then begin
            DiscountAppliedBeforeTax := false;
            TotalTaxAmount := 0;
            exit;
        end;

        if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Sales Tax" then
            DiscountAppliedBeforeTax := true
        else
            DiscountAppliedBeforeTax := not SalesHeader."Prices Including VAT";

        DocumentTotals.CalculateSalesTotals(TotalSalesLine, TotalTaxAmount, SalesLine);
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(SellCustomer);
        Clear(BillCustomer);
        Clear(Contact);
        Clear(Currency);
        Clear(PaymentTerms);

        PartialShipping := false;
        DiscountAppliedBeforeTax := false;
        TotalTaxAmount := 0
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        SellCustomer: Record Customer;
        BillCustomer: Record Customer;
        Contact: Record Contact;
        Currency: Record Currency;
        PaymentTerms: Record "Payment Terms";
        PartialShipping: Boolean;
        DiscountAppliedBeforeTax: Boolean;
        TotalTaxAmount: Decimal;

}
