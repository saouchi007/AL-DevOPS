report 82900 "MICA Apply Off-Invoice"
{
    ApplicationArea = All;
    Caption = 'Apply Off-Invoice New Item';
    ProcessingOnly = true;
    UseRequestPage = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(MICAOffInvItemSelSetup; "MICA Off-Inv. Item Sel. Setup")
        {
            DataItemTableView = sorting("Item Discount Group Code") order(ascending);

            trigger OnPreDataItem()
            var
                SalesLineDiscount: Record "Sales Line Discount";
                ValidItemDiscGrpLbl: Label '%1|%2', Comment = '%1,%2';
            begin
                if FilterItemNo <> '' then begin
                    Item.Get(FilterItemNo);
                    if Item."MICA Auto Off-Invoice Setup" then
                        CurrReport.Quit();
                end else begin
                    TempItem.Reset();
                    TempItem.DeleteAll();
                end;

                SalesLineDiscount.SetCurrentKey(Type, "Code", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                SalesLineDiscount.SetRange(Type, SalesLineDiscount.Type::"Item Disc. Group");
                SalesLineDiscount.SetFilter("Starting Date", '..%1', WorkDate());
                SalesLineDiscount.SetFilter("Ending Date", '%1|%2..', 0D, WorkDate());
                if SalesLineDiscount.Findset() then
                    repeat
                        if ValidItemDiscountGroups = '' then
                            ValidItemDiscountGroups := SalesLineDiscount.Code
                        else
                            ValidItemDiscountGroups := StrSubstNo(ValidItemDiscGrpLbl, ValidItemDiscountGroups, SalesLineDiscount.Code);
                    until SalesLineDiscount.Next() = 0;

                SetFilter("Item Discount Group Code", ValidItemDiscountGroups);
            end;

            trigger OnAfterGetRecord()
            begin
                if FilterItemNo <> '' then
                    MICAOffInvoiceAutoSetup.FilterOffInvoiceItemSelectionSetup(MICAOffInvItemSelSetup, Item)
                else
                    if MICAOffInvItemSelSetup."Item Code" <> '' then begin
                        Item.Get(MICAOffInvItemSelSetup."Item Code");
                        CreateItemDiscGroupAndPopulateTemp(MICAOffInvItemSelSetup, Item);
                    end else begin
                        FilterItem(MICAOffInvItemSelSetup, Item);
                        if Item.FindSet() then
                            repeat
                                CreateItemDiscGroupAndPopulateTemp(MICAOffInvItemSelSetup, Item);
                            until Item.Next() = 0;
                    end;
            end;

            trigger OnPostDataItem()
            begin
                if FilterItemNo <> '' then
                    MICAOffInvoiceAutoSetup.ModifyAutoOffInvSetupOnItem(Item)
                else
                    UpdateTempItem();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field("Filter Item No"; FilterItemNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Item No';
                        ToolTip = 'Specifies filter of selected Item(s) from Item List or Item Card';
                        TableRelation = Item;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            MICAOffInvoiceAutoSetup.SelectionFilter(FilterItemNo, 0);
                        end;
                    }
                }
            }
        }
    }

    local procedure FilterItem(MICAOffInvItemSelSetup: Record "MICA Off-Inv. Item Sel. Setup"; var Item: Record Item)
    begin
        Item.SetCurrentKey("MICA Auto Off-Invoice Setup");
        Item.SetRange(Blocked, false);
        Item.SetRange("MICA Auto Off-Invoice Setup", false);
        if MICAOffInvItemSelSetup."Item Category Code" <> '' then
            Item.SetFilter("Item Category Code", MICAOffInvItemSelSetup."Item Category Code")
        else
            Item.SetFilter("Item Category Code", '%1', '');

        if MICAOffInvItemSelSetup.Brand <> '' then
            Item.SetFilter("MICA Brand", MICAOffInvItemSelSetup.Brand)
        else
            Item.SetFilter("MICA Brand", '%1', '');

        if MICAOffInvItemSelSetup."Rim Diametar" <> '' then
            Item.SetFilter("MICA Rim Diameter", MICAOffInvItemSelSetup."Rim Diametar")
        else
            Item.SetFilter("MICA Rim Diameter", '%1', '');

        if MICAOffInvItemSelSetup.Pattern <> '' then
            Item.SetFilter("MICA Pattern Code", MICAOffInvItemSelSetup.Pattern)
        else
            Item.SetFilter("MICA Pattern Code", '%1', '');

        if MICAOffInvItemSelSetup."Commercial Label" <> '' then
            Item.SetFilter("MICA Commercial Label", MICAOffInvItemSelSetup."Commercial Label")
        else
            Item.SetFilter("MICA Commercial Label", '%1', '');

        if MICAOffInvItemSelSetup."Market Code" <> '' then
            Item.SetFilter("MICA Market Code", MICAOffInvItemSelSetup."Market Code")
        else
            Item.SetFilter("MICA Market Code", '%1', '');

        if MICAOffInvItemSelSetup."Item Class" <> '' then
            Item.SetFilter("MICA Item Class", MICAOffInvItemSelSetup."Item Class")
        else
            Item.SetFilter("MICA Item Class", '%1', '');

        if MICAOffInvItemSelSetup."Product Nature" <> '' then
            Item.SetFilter("MICA Product Nature", MICAOffInvItemSelSetup."Product Nature")
        else
            Item.SetFilter("MICA Product Nature", '%1', '');

        if MICAOffInvItemSelSetup."LPR Category" <> '' then
            Item.SetFilter("MICA LPR Category", MICAOffInvItemSelSetup."LPR Category")
        else
            Item.SetFilter("MICA LPR Category", '%1', '');

        if MICAOffInvItemSelSetup."Section Width" <> '' then
            Item.SetFilter("MICA Section Width", MICAOffInvItemSelSetup."Section Width");

        if MICAOffInvItemSelSetup."Aspect Ratio" <> '' then
            Item.SetFilter("MICA Aspect Ratio", MICAOffInvItemSelSetup."Aspect Ratio")
        else
            Item.SetFilter("MICA Aspect Ratio", '%1', '');

        if MICAOffInvItemSelSetup."CCID Code" <> '' then
            Item.SetFilter("MICA CCID Code", MICAOffInvItemSelSetup."CCID Code")
        else
            Item.SetFilter("MICA CCID Code", '%1', '');

        if MICAOffInvItemSelSetup."Business Line" <> '' then
            Item.SetFilter("MICA Business Line", MICAOffInvItemSelSetup."Business Line")
        else
            Item.SetFilter("MICA Business Line", '%1', '');
    end;

    local procedure CreateItemDiscGroupAndPopulateTemp(MICAOffInvItemSelSetup: Record "MICA Off-Inv. Item Sel. Setup"; Item: Record Item)
    begin
        MICAOffInvoiceAutoSetup.FillAdditionalItemDiscountGroup(Item."No.", MICAOffInvItemSelSetup."Item Discount Group Code",
        MICAOffInvItemSelSetup."Item Discount Group Desc.");

        if not TempItem.Get(Item."No.") then begin
            TempItem.Init();
            TempItem."No." := Item."No.";
            TempItem."MICA Auto Off-Invoice Setup" := true;
            TempItem.Insert();
        end;
    end;

    local procedure UpdateTempItem()
    var
        UpdateItem: Record Item;
    begin
        TempItem.SetCurrentKey("MICA Auto Off-Invoice Setup");
        TempItem.SetRange("MICA Auto Off-Invoice Setup", true);
        if TempItem.FindSet() then
            repeat
                UpdateItem.Get(TempItem."No.");
                UpdateItem.Validate("MICA Auto Off-Invoice Setup", true);
                UpdateItem.Modify();
            until TempItem.Next() = 0;
    end;

    procedure SetFilterItemNo(NewFilterItemNo: Text)
    begin
        FilterItemNo := NewFilterItemNo;
    end;

    var
        Item: Record Item;
        TempItem: Record Item temporary;
        MICAOffInvoiceAutoSetup: Codeunit "MICA Off-Invoice Auto Setup";
        FilterItemNo: Text;
        ValidItemDiscountGroups: Text;
}