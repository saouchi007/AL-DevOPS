codeunit 81760 "MICA Sales Order Events"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure t37OnAfterValidateNoEvent(var Rec: Record "Sales Line")
    begin
        if Rec.IsTemporary() then
            exit;
        if Rec.Type <> Rec.Type::Item then
            exit;
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        CheckMarketCode(Rec);
    end;

    local procedure CheckMarketCode(var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        MICATableValue: Record "MICA Table Value";
        Customer: Record Customer;
    begin
        Customer.Get(SalesLine."Sell-to Customer No.");
        if Customer."MICA Market Code" = '' then
            exit;

        MICATableValue.Get(MICATableValue."Table Type"::MarketCode, Customer."MICA Market Code");
        case MICATableValue."Market Code Business Line" of
            MICATableValue."Market Code Business Line"::"LB-OE":
                begin
                    Item.Get(SalesLine."No.");
                    if Item."MICA LB-OE" <> '' then
                        AddDiminesionOnSalesLine(SalesLine, Item."MICA LB-OE");
                end;
            MICATableValue."Market Code Business Line"::"LB-RT":
                begin
                    Item.Get(SalesLine."No.");
                    if Item."MICA LB-RT" <> '' then
                        AddDiminesionOnSalesLine(SalesLine, Item."MICA LB-RT");
                end;
        end;
    end;


    local procedure AddDiminesionOnSalesLine(var SalesLine: Record "Sales Line"; ItemLBCode: Code[10])
    var
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionManagement: Codeunit DimensionManagement;
    begin
        GeneralLedgerSetup.Get();
        if GeneralLedgerSetup."MICA LB Dimension code" = '' then
            exit;
        DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."MICA LB Dimension code");
        DimensionValue.SetRange("MICA Michelin Code", ItemLBCode);
        if DimensionValue.FindFirst() then begin
            DimensionManagement.GetDimensionSet(TempDimensionSetEntry, SalesLine."Dimension Set ID");
            CreateDimSetEntryFromDimValue(TempDimensionSetEntry, DimensionValue);
            SalesLine."Dimension Set ID" := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);
            DimensionManagement.UpdateGlobalDimFromDimSetID(SalesLine."Dimension Set ID", SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code");
        end;
    end;

    local procedure CreateDimSetEntryFromDimValue(var TempDimensionSetEntry: Record "Dimension Set Entry"; DimensionValue: Record "Dimension Value")
    begin
        TempDimensionSetEntry.Init();
        TempDimensionSetEntry."Dimension Code" := DimensionValue."Dimension Code";
        TempDimensionSetEntry."Dimension Value Code" := DimensionValue.Code;
        TempDimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
        if not TempDimensionSetEntry.Insert() then
            TempDimensionSetEntry.Modify();
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Header", 'OnAfterValidateEvent', 'Combine Shipments', false, false)]
    local procedure t36OnAfterValidateCombineShipmentsEvent(var Rec: Record "Sales Header")
    begin
        if Rec."Combine Shipments" and (Rec."MICA Shipment Post Option" <> Rec."MICA Shipment Post Option"::Ship) then
            Rec."MICA Shipment Post Option" := Rec."MICA Shipment Post Option"::Ship;
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Header", 'OnAfterValidateEvent', 'MICA Shipment Post Option', false, false)]
    local procedure t36OnAfterValidateShipmentPostOptionEvent(var Rec: Record "Sales Header")
    begin
        if Rec."MICA Shipment Post Option" <> Rec."MICA Shipment Post Option"::Ship then
            Rec.TestField(Rec."Combine Shipments", false);
    end;
}