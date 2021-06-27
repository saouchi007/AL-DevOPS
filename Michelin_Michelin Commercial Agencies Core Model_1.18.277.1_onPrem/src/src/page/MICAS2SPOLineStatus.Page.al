#pragma implicitwith disable
page 82875 "MICA S2S PO. Line Status"
{
    PageType = API;
#if not OnPremise
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif 
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 'statusPurchaseOrderLines', Locked = true;
    EntityName = 'statusPurchaseOrderLine';
    EntitySetName = 'statusPurchaseOrderLines';
    ODataKeyFields = SystemId;
    SourceTable = "Purchase Line";
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
                field(number; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'number', Locked = true;
                }
                field(sequence; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'sequence', Locked = true;
                }
                field(itemNumber; Item."No.")
                {
                    ApplicationArea = All;
                    Caption = 'itemNumber', Locked = true;
                }
                field(productLine; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'productLine';
                }
                field(accountCode; GLAccNo)
                {
                    ApplicationArea = All;
                    Caption = 'accountCode', Locked = true;
                }
                field(locationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'locationCode', Locked = true;
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
                field(unitCost; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'unitCost';
                }
                field(quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'quantity', Locked = true;
                }
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'directUnitCost', Locked = true;
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
                field(amountExcludingTax; Rec.MicaGetLineAmountExclVAT())
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
                field(totalTaxAmount; Rec.MicaGetLineAmountInclVAT() - Rec.MicaGetLineAmountExclVAT())
                {
                    ApplicationArea = All;
                    Caption = 'totalTaxAmount', Locked = true;
                }
                field(amountIncludingTax; Rec.MicaGetLineAmountInclVAT())
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
                field(expectedReceiptDate; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'expectedReceiptDate', Locked = true;
                }
                field(quantityToReceive; Rec."Qty. to Receive")
                {
                    ApplicationArea = All;
                    Caption = 'quantityToReceive', Locked = true;
                }
                field(quantityReceived; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    Caption = 'quantityReceived', Locked = true;
                }
                field(quantityToInvoice; Rec."Qty. to Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'quantityToInvoice', Locked = true;
                }
                field(quantityInvoiced; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                    Caption = 'quantityInvoiced', Locked = true;
                }
                field(requestedReceiptDate; Rec."Requested Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'requestedReceiptDate', Locked = true;
                }
                field(promisedReceiptDate; Rec."Promised Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'promisedReceiptDate';
                }
                field(plannedReceiptDate; Rec."Planned Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'plannedReceiptDate', Locked = true;
                }
                field(purchasingFamily; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    Caption = 'purchasingFamily', Locked = true;
                }
                field(site; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    Caption = 'site', Locked = true;
                }
                field(section; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'section', Locked = true;
                }
                field(structure; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'structure', Locked = true;
                }
                field(intercompanyCode; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    Caption = 'intercompanyCode', Locked = true;
                }
                field(countryOfOrigin; Rec."MICA Country of Origin")
                {
                    ApplicationArea = All;
                    Caption = 'countryOfOrigin', Locked = true;
                }
                field(containerId; Rec."MICA Container ID")
                {
                    ApplicationArea = All;
                    Caption = 'containerId', Locked = true;
                }
                field(alNumberPoLine; Rec."MICA AL No.")
                {
                    ApplicationArea = All;
                    Caption = 'alNumberPoLine', Locked = true;
                }
                field(alLineNumberPoLine; Rec."MICA AL Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'alLineNumberPoLine', Locked = true;
                }
                field(locationToCodePoLine; Rec."MICA Location-To Code")
                {
                    ApplicationArea = All;
                    Caption = 'locationToCodePoLine', Locked = true;
                }
                field(asnNumber; Rec."MICA ASN No.")
                {
                    ApplicationArea = All;
                    Caption = 'asnNumber', Locked = true;
                }
                field(asnLineNumber; Rec."MICA ASN Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'asnLineNumber', Locked = true;
                }
                field(sealNumber; Rec."MICA Seal No.")
                {
                    ApplicationArea = All;
                    Caption = 'sealNumber', Locked = true;
                }
                field(portOfArrival; Rec."MICA Port of Arrival")
                {
                    ApplicationArea = All;
                    Caption = 'portOfArrival', Locked = true;
                }
                field(countryIsoOrigin; Rec."MICA Ctry. ISO Code/O. Manuf.")
                {
                    ApplicationArea = All;
                    Caption = 'countryIsoOrigin', Locked = true;
                }
                field(dc14; Rec."MICA DC14")
                {
                    ApplicationArea = All;
                    Caption = 'DC14', Locked = true;
                }
                field(etaDate; Rec."MICA ETA")
                {
                    ApplicationArea = All;
                    Caption = 'etaDate', Locked = true;
                }
                field(srdDate; Rec."MICA SRD")
                {
                    ApplicationArea = All;
                    Caption = 'srdDate', Locked = true;
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
        DimMgt: Codeunit DimensionManagement;
    begin
        GeneralLedgerSetup.Get();
        if GeneralLedgerSetup.UseVat() then
            TaxCode := Rec."VAT Identifier"
        else
            TaxCode := Rec."Tax Group Code";
        if Rec.Type = Rec.Type::"G/L Account" then
            GLAccNo := Rec."No.";
        if Rec.Type = Rec.Type::Item then
            if item.get(Rec."No.") then;

        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            if PurchaseHeader."Prices Including VAT" then
                InvDiscountAmountExclVAT := Rec."Line Discount Amount"
            else
                InvDiscountAmountExclVAT := Rec."Inv. Discount Amount";
            if Rec."VAT Calculation Type" = Rec."VAT Calculation Type"::"Sales Tax" then
                DiscountAppliedBeforeTax := true
            else
                DiscountAppliedBeforeTax := not PurchaseHeader."Prices Including VAT";
        end;
        DimMgt.GetShortcutDimensions(Rec."Dimension Set ID", ShortcutDimCode);

    end;


    trigger OnInit()
    begin
        MICAFinancialReportingSetup.Get();
    end;

    local procedure ClearCalculatedFields()
    begin

        clear(Location);
        Clear(Item);
        Clear(MICAPriority);
        clear(SalesShipmentLine);
        clear(GLAccNo);
        TaxCode := '';
        InvDiscountAmountExclVAT := 0;
        DiscountAppliedBeforeTax := false;
        Clear(ShortcutDimCode);


    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        TaxCode: Code[50];
        Location: Record Location;
        Item: Record Item;
        MICAPriority: Record "MICA Priority";
        SalesShipmentLine: Record "Sales Shipment Line";
        PurchaseHeader: Record "Purchase Header";
        GLAccNo: Code[20];
        InvDiscountAmountExclVAT: Decimal;
        DiscountAppliedBeforeTax: Boolean;
        ShortcutDimCode: array[8] of Code[20];

}
#pragma implicitwith restore
