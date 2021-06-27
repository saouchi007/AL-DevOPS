codeunit 82900 "MICA Off-Invoice Auto Setup"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Discount Group", 'OnAfterDeleteEvent', '', false, false)]
    local procedure T341OnAfterDeleteEvent(var Rec: Record "Item Discount Group"; RunTrigger: Boolean)
    var
        MICAOffInvItemSelSetup: Record "MICA Off-Inv. Item Sel. Setup";
    begin
        if not RunTrigger then
            exit;

        if MICAOffInvItemSelSetup.Get(Rec.Code) then
            MICAOffInvItemSelSetup.Delete();
    end;

    procedure CheckIfEnteredValueExistStandardTables(FilterText: Text; FieldToSelect: Integer)
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        DimensionValue: Record "Dimension Value";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
    begin
        case FieldToSelect of
            0:
                begin
                    if FilterText = '' then
                        exit;

                    Item.SetCurrentKey("No.");
                    Item.SetFilter("No.", FilterText);
                    if Item.IsEmpty() then
                        ReturnErrorTxt(FilterText, Item.TableCaption());
                end;
            1:
                begin
                    if FilterText = '' then
                        exit;

                    ItemCategory.SetCurrentKey(Code);
                    ItemCategory.SetFilter(Code, FilterText);
                    if ItemCategory.IsEmpty() then
                        ReturnErrorTxt(FilterText, ItemCategory.TableCaption());
                end;
            2:
                begin
                    if FilterText = '' then
                        exit;

                    MICAFinancialReportingSetup.Get();
                    MICAFinancialReportingSetup.TestField("Structure Dimension");

                    DimensionValue.SetCurrentKey("Dimension Code", Code);
                    DimensionValue.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                    if DimensionValue.IsEmpty() then
                        ReturnErrorTxt(FilterText, DimensionValue.TableCaption());
                end;
        end;
    end;

    procedure CheckIfEnteredValueExistMICAables(FilterText: Text; FieldToSelect: Integer)
    var
        MICATableValue: Record "MICA Table Value";
    begin
        if FilterText = '' then
            exit;

        MICATableValue.SetCurrentKey("Table Type", Code);
        CaseTableValueFilter(MICATableValue, FieldToSelect);
        MICATableValue.SetFilter(Code, FilterText);
        if MICATableValue.IsEmpty() then
            ReturnErrorTxt(FilterText, MICATableValue.TableCaption());
    end;

    local procedure ReturnErrorTxt(FilterSelectedValues: Text; TableCaption: Text): Text;
    var
        ErrorTxt: Text;
        DataDontExistErr: Label 'Entered value(s): %1 do not exist in table: %2.';
    begin
        ErrorTxt := StrSubstNo(DataDontExistErr, FilterSelectedValues, TableCaption);
        Error(ErrorTxt);
    end;

    procedure SelectionFilter(var FilterText: Text; FieldToSelect: Integer)
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        DimensionValue: Record "Dimension Value";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        ItemList: Page "Item List";
        ItemCategories: Page "Item Categories";
        DimensionValueList: Page "Dimension Value List";
        OldFilter: Text;
    begin
        OldFilter := '';

        case FieldToSelect of
            0:
                begin
                    Item.Reset();
                    Item.SetRange("MICA Auto Off-Invoice Setup", false);
                    ItemList.SetTableView(Item);
                    ItemList.LookupMode(true);

                    if ItemList.RunModal() <> Action::LookupOK then
                        exit;

                    OldFilter := ItemList.GetSelectionFilter();
                    CreateFilterForStandardTables(FilterText, OldFilter, 0, '');
                end;
            1:
                begin
                    ItemCategory.Reset();
                    ItemCategories.SetTableView(ItemCategory);
                    ItemCategories.LookupMode(true);

                    if ItemCategories.RunModal() <> Action::LookupOK then
                        exit;

                    OldFilter := ItemCategories.GetSelectionFilter();
                    CreateFilterForStandardTables(FilterText, OldFilter, 1, '');
                end;
            2:
                begin
                    MICAFinancialReportingSetup.Get();
                    MICAFinancialReportingSetup.TestField("Structure Dimension");

                    DimensionValue.SetCurrentKey("Dimension Code", Code);
                    DimensionValue.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                    DimensionValueList.SetTableView(DimensionValue);
                    DimensionValueList.LookupMode(true);

                    if DimensionValueList.RunModal() <> Action::LookupOK then
                        exit;

                    OldFilter := DimensionValueList.GetSelectionFilter();
                    CreateFilterForStandardTables(FilterText, OldFilter, 2, MICAFinancialReportingSetup."Structure Dimension");
                end;
        end;
    end;

    procedure CreateFilterForStandardTables(var NewFilterText: Text; OldFilterText: Text; TypeOfStandardTable: Integer; DimensionCode: Code[20])
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        DimensionValue: Record "Dimension Value";
    begin
        case TypeOfStandardTable of
            0:
                begin
                    Item.SetCurrentKey("No.");
                    Item.SetFilter("No.", OldFilterText);
                    if Item.FindSet() then
                        repeat
                            CreateFilterWithPipe(Item."No.", NewFilterText);
                        until Item.Next() = 0;
                end;
            1:
                begin
                    ItemCategory.SetCurrentKey(Code);
                    ItemCategory.SetFilter(Code, OldFilterText);
                    if ItemCategory.FindSet() then
                        repeat
                            CreateFilterWithPipe(ItemCategory.Code, NewFilterText);
                        until ItemCategory.Next() = 0;
                end;
            2:
                begin
                    DimensionValue.SetCurrentKey("Dimension Code", Code);
                    DimensionValue.SetRange("Dimension Code", DimensionCode);
                    DimensionValue.SetFilter(Code, OldFilterText);
                    if DimensionValue.FindSet() then
                        repeat
                            CreateFilterWithPipe(DimensionValue.Code, NewFilterText);
                        until DimensionValue.Next() = 0;
                end;
        end;
    end;

    procedure CreateFilterForTableValues(var OutputParameter: Text; TypeOfValue: Integer)
    var
        OldFilter: Text;
    begin
        OldFilter := '';

        SelectionFilterTableValue(OldFilter, TypeOfValue);
        if OldFilter <> '' then
            SelectionFilterTableValuePipe(OutputParameter, OldFilter, TypeOfValue);
    end;

    local procedure SelectionFilterTableValue(var FilterText: Text; TypeOfValue: Integer)
    var
        MICATableValue: Record "MICA Table Value";
        MICATableValues: Page "MICA Table Values";
    begin
        MICATableValue.SetCurrentKey("Table Type", Code);

        CaseTableValueFilter(MICATableValue, TypeOfValue);

        MICATableValues.SetTableView(MICATableValue);
        MICATableValues.LookupMode(true);

        if MICATableValues.RunModal() <> Action::LookupOK then
            exit;

        FilterText := MICATableValues.GetSelectionFilter(MICATableValue);
    end;

    local procedure SelectionFilterTableValuePipe(var NewFilterText: Text; OldFilterText: Text; TypeOfValue: Integer)
    var
        MICATableValue: Record "MICA Table Value";
    begin
        MICATableValue.SetCurrentKey("Table Type", Code);
        CaseTableValueFilter(MICATableValue, TypeOfValue);
        MICATableValue.SetFilter(Code, OldFilterText);
        if MICATableValue.FindSet() then
            repeat
                CreateFilterWithPipe(Format(MICATableValue.Code), NewFilterText);
            until MICATableValue.Next() = 0;
    end;

    local procedure CreateFilterWithPipe(InputParameter: Text; var OutputParameter: Text)
    begin
        if OutputParameter = '' then
            OutputParameter := InputParameter
        else
            OutputParameter += '|' + InputParameter;
    end;

    procedure FillAdditionalItemDiscountGroup(NewItemNo: Code[20]; NewItemDiscGrpCode: Code[20]; ItemDiscGrpDesc: Text[50])
    var
        MICAAddItemDiscountGroup: record "MICA Add. Item Discount Group";
    begin
        if not MICAAddItemDiscountGroup.Get(NewItemNo, NewItemDiscGrpCode) then begin
            MICAAddItemDiscountGroup.Init();
            MICAAddItemDiscountGroup."Item No." := NewItemNo;
            MICAAddItemDiscountGroup."Item Discount Group Code" := NewItemDiscGrpCode;
            MICAAddItemDiscountGroup."Item Discount Group Desc." := ItemDiscGrpDesc;
            MICAAddItemDiscountGroup.Insert();
        end;
    end;

    procedure ModifyAutoOffInvSetupOnItem(var Item: Record Item)
    begin
        Item.Validate("MICA Auto Off-Invoice Setup", true);
        Item.Modify();
    end;

    procedure FilterOffInvoiceItemSelectionSetup(MICAOffInvItemSelSetup: Record "MICA Off-Inv. Item Sel. Setup"; Item: Record Item)
    var
        ExistsValidSelectSetup: Boolean;
    begin
        if MICAOffInvItemSelSetup."Item Code" <> '' then
            ExistsValidSelectSetup := ValueExistsItem(MICAOffInvItemSelSetup."Item Code", Format(Item."No."))
        else
            ExistsValidSelectSetup := CheckValuesSelectionSetup(MICAOffInvItemSelSetup, Item);

        if ExistsValidSelectSetup then
            FillAdditionalItemDiscountGroup(
                Item."No.", MICAOffInvItemSelSetup."Item Discount Group Code",
                MICAOffInvItemSelSetup."Item Discount Group Desc.");
    end;

    procedure CheckValuesSelectionSetup(MICAOffInvItemSelSetup: Record "MICA Off-Inv. Item Sel. Setup"; Item: Record Item): Boolean
    begin
        if CheckFieldsWithTableRelation(MICAOffInvItemSelSetup, Item) and CheckFieldsWithoutTableRelation(MICAOffInvItemSelSetup, Item) then
            exit(true);
    end;

    local procedure CheckFieldsWithTableRelation(MICAOffInvItemSelSetup: Record "MICA Off-Inv. Item Sel. Setup"; Item: Record Item): Boolean
    begin
        if ValueExists(MICAOffInvItemSelSetup."Item Category Code", Format(Item."Item Category Code"), true) and
          ValueExists(MICAOffInvItemSelSetup.Brand, Format(Item."MICA Brand"), true) and
          ValueExists(MICAOffInvItemSelSetup.Pattern, Format(Item."MICA Pattern Code"), true) and
          ValueExists(MICAOffInvItemSelSetup."Market Code", Format(Item."MICA Market Code"), true) and
          ValueExists(MICAOffInvItemSelSetup."Product Nature", Format(Item."MICA Product Nature"), true) and
          ValueExists(MICAOffInvItemSelSetup."LPR Category", Format(Item."MICA LPR Category"), true) and
          ValueExists(MICAOffInvItemSelSetup."Business Line", Format(Item."MICA Business Line"), true)
        then
            exit(true);
    end;

    local procedure CheckFieldsWithoutTableRelation(MICAOffInvItemSelSetup: Record "MICA Off-Inv. Item Sel. Setup"; Item: Record Item): Boolean
    begin
        if ((MICAOffInvItemSelSetup."Rim Diametar" = '') or ((MICAOffInvItemSelSetup."Rim Diametar" <> '') and (ValueExistWithSpecialChars(MICAOffInvItemSelSetup."Rim Diametar", Item, 0)))) and
        ((MICAOffInvItemSelSetup."Commercial Label" = '') or ((MICAOffInvItemSelSetup."Commercial Label" <> '') and (ValueExists(MICAOffInvItemSelSetup."Commercial Label", Format(Item."MICA Commercial Label"), false)))) and
         ((MICAOffInvItemSelSetup."Item Class" = '') or ((MICAOffInvItemSelSetup."Item Class" <> '') and (ValueExists(MICAOffInvItemSelSetup."Item Class", Format(Item."MICA Item Class"), false)))) and
         ((MICAOffInvItemSelSetup."Section Width" = '') or ((MICAOffInvItemSelSetup."Section Width" <> '') and (ValueExistWithSpecialChars(MICAOffInvItemSelSetup."Section Width", Item, 1)))) and
         ((MICAOffInvItemSelSetup."Aspect Ratio" = '') or ((MICAOffInvItemSelSetup."Aspect Ratio" <> '') and (ValueExists(MICAOffInvItemSelSetup."Aspect Ratio", Format(Item."MICA Aspect Ratio"), false)))) and
         ((MICAOffInvItemSelSetup."CCID Code" = '') or ((MICAOffInvItemSelSetup."CCID Code" <> '') and (ValueExists(MICAOffInvItemSelSetup."CCID Code", Format(Item."MICA CCID Code"), false))))
       then
            exit(true);
    end;

    local procedure ValueExistWithSpecialChars(OffSelectionSetupValue: Text[250]; Item: Record Item; CurrentField: Option "Rim Diameter","Section Width"): Boolean
    var
        SpecialChar: Text;
        OutputDecimalNumber: Decimal;
        RimDiameterItemCardDecimal: Decimal;
    begin
        if CurrentField = CurrentField::"Rim Diameter" then
            IfEvaluateFailed(Item."MICA Rim Diameter", RimDiameterItemCardDecimal);

        if not ReadSpecialCharacters(OffSelectionSetupValue, SpecialChar, OutputDecimalNumber) then
            exit(false);

        case SpecialChar of
            '<':
                if CurrentField = CurrentField::"Rim Diameter" then
                    exit(RimDiameterItemCardDecimal < OutputDecimalNumber)
                else
                    exit(Item."MICA Section Width" < OutputDecimalNumber);
            '>':
                if CurrentField = CurrentField::"Rim Diameter" then
                    exit(RimDiameterItemCardDecimal > OutputDecimalNumber)
                else
                    exit(Item."MICA Section Width" > OutputDecimalNumber);
            '<>':
                if CurrentField = CurrentField::"Rim Diameter" then
                    exit(RimDiameterItemCardDecimal <> OutputDecimalNumber)
                else
                    exit(Item."MICA Section Width" <> OutputDecimalNumber);
            '=':
                if CurrentField = CurrentField::"Rim Diameter" then
                    exit(RimDiameterItemCardDecimal = OutputDecimalNumber)
                else
                    exit(Item."MICA Section Width" = OutputDecimalNumber);

            '<=':
                if CurrentField = CurrentField::"Rim Diameter" then
                    exit(RimDiameterItemCardDecimal <= OutputDecimalNumber)
                else
                    exit(Item."MICA Section Width" <= OutputDecimalNumber);
            '>=':
                if CurrentField = CurrentField::"Rim Diameter" then
                    exit(RimDiameterItemCardDecimal >= OutputDecimalNumber)
                else
                    exit(Item."MICA Section Width" >= OutputDecimalNumber);
        end;
    end;

    local procedure ReadSpecialCharacters(InputString: Text[250]; var SpecialChars: Text; var DummyDecimal: Decimal): Boolean
    var
        FoundFirstNumberOccurrence: Integer;
        i: Integer;
        OutputStringNumber: Text;
        NumbersLbl: Label '0123456789';
    begin
        for i := 1 to StrLen(InputString) do begin
            FoundFirstNumberOccurrence := StrPos(NumbersLbl, InputString[i]);
            if FoundFirstNumberOccurrence > 0 then begin
                SpecialChars := CopyStr(InputString, 1, i - 1);
                OutputStringNumber := CopyStr(InputString, i, MaxStrLen(InputString));
                IfEvaluateFailed(OutputStringNumber, DummyDecimal);
                exit(SpecialChars <> '');
            end;
        end;
    end;

    local procedure IfEvaluateFailed(InputText: Text; var OutputDecimal: Decimal)
    var
        ItemRimDiameterCommaInsteadDotValue: Text;
    begin
        if not Evaluate(OutputDecimal, InputText) then begin
            ItemRimDiameterCommaInsteadDotValue := ConvertStr(InputText, '.', ',');
            Evaluate(OutputDecimal, ItemRimDiameterCommaInsteadDotValue);
        end;
    end;

    procedure ValueExists(MultipleInputValues: Text; SingleInputValue: Text; LookupFields: Boolean): Boolean
    begin
        if LookupFields then
            if MultipleInputValues = '' then
                exit(true);

        if StrPos(MultipleInputValues, SingleInputValue) > 0 then
            exit(true);
    end;

    procedure ValueExistsItem(MultipleInputValues: Text; SingleInputValue: Text): Boolean
    begin
        if StrPos(MultipleInputValues, SingleInputValue) > 0 then
            exit(true);
    end;

    local procedure CaseTableValueFilter(var MICATableValue: Record "MICA Table Value"; FieldToSelect: Integer)
    begin
        case FieldToSelect of
            0:
                MICATableValue.SetRange("Table Type", MICATableValue."Table Type"::ItemBrand);
            1:
                MICATableValue.SetRange("Table Type", MICATableValue."Table Type"::ItemPatternCode);
            2:
                MICATableValue.SetRange("Table Type", MICATableValue."Table Type"::MarketCode);
            3:
                MICATableValue.SetRange("Table Type", MICATableValue."Table Type"::ItemProductNature);
            4:
                MICATableValue.SetRange("Table Type", MICATableValue."Table Type"::ItemLPRCategory);
        end;
    end;
}