report 80180 "MICA Sales Line Disc. Assist."
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rdl80180.MICASalesLineDiscAssistant.rdl';
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Sales Line Discount Assistant';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") order(ascending);
            column(ItemNo; "No.")
            {
                IncludeCaption = true;
            }
            column(ItemNo2; "No. 2")
            {
                IncludeCaption = true;
            }
            column(ItemDesc; Description)
            {
                IncludeCaption = true;
            }


            trigger OnPreDataItem()
            var
                ItemDiscGroup: record "Item Discount Group";
                SalesLineDisc: record "Sales Line Discount";
                ExistItemDiscGroup_Err: label 'Item discount group  code already exist.';
            begin
                FilterItem(Item);

                UOMCode := '';
                CheckIsEmptyParams();

                if NOT ItemDiscGroup.get(ItemDiscGrpCode) THEN begin
                    itemDiscGroup.Init();
                    ItemDiscGroup.Code := ItemDiscGrpCode;
                    ItemDiscGroup.Description := ItemDiscGrpDesc;
                    ItemDiscGroup.INSERT();
                end else
                    error(ExistItemDiscGroup_Err);

                SalesLineDisc.INIT();
                SalesLineDisc.Type := SalesLineDisc.Type::"Item Disc. Group";
                SalesLineDisc.Code := ItemDiscGrpCode;
                SalesLineDisc."Sales Code" := SalesCode;
                SalesLineDisc."Currency Code" := CurrCode;
                SalesLineDisc."Starting Date" := StartDate;
                SalesLineDisc."Line Discount %" := LineDisc;
                SalesLineDisc."Sales Type" := SalesType;
                SalesLineDisc."Minimum Quantity" := MinimumQty;
                SalesLineDisc."Ending Date" := EndingDate;
                SalesLineDisc."Unit of Measure Code" := UOMCode;
                SalesLineDisc."Variant Code" := VariantCode;
                SalesLineDisc.INSERT();

                FillOffInvoiceSelectionSetup();

                AmountToProcess := Item.Count();
                ProgressWindowDialog.Open(ProgressEntriesLbl);
            end;

            trigger OnAfterGetRecord()
            var
                AddItemDiscGroup: record "MICA Add. Item Discount Group";
            begin
                if NOT AddItemDiscGroup.get("No.", ItemDiscGrpCode) THEN begin
                    AddItemDiscGroup.Init();
                    AddItemDiscGroup."Item No." := "No.";
                    AddItemDiscGroup."Item Discount Group Code" := ItemDiscGrpCode;
                    AddItemDiscGroup."Item Discount Group Desc." := ItemDiscGrpDesc;
                    AddItemDiscGroup.INSERT();
                end;
                AmountProcessed += 1;
                PercentProcessed := Round(AmountProcessed / AmountToProcess * 100, 1);
                ProgressWindowDialog.Update(1, PercentProcessed);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Sales Line Discount")
                {
                    field("Code"; "ItemDiscGrpCode")
                    {
                        ApplicationArea = All;
                        Caption = 'Code';
                    }
                    field("Sales Type"; "SalesType")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Type';
                        OptionCaption = 'Customer,Customer Disc. Group,All Customer';
                    }
                    field("Sales Code"; "SalesCode")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Code';
                        trigger OnDrillDown()
                        var
                            Customer: Record Customer;
                            CustDiscGrp: Record "Customer Discount Group";
                        begin
                            case SalesType of
                                SalesType::Customer:
                                    if page.RunModal(0, customer) = Action::LookupOK then
                                        SalesCode := customer."No.";
                                SalesType::"Customer Disc. Group":
                                    if page.RunModal(0, CustDiscGrp) = Action::LookupOK then
                                        SalesCode := CustDiscGrp.Code;
                            end;
                        end;

                    }
                    field(Description; "ItemDiscGrpDesc")
                    {
                        ApplicationArea = All;
                        Caption = 'Description';
                    }
                    field("Minimum Quantity"; "MinimumQty")
                    {
                        ApplicationArea = All;
                        DecimalPlaces = 0 : 2;
                        Caption = 'Minimum Quantity';
                    }
                    field("Line Discount %"; LineDisc)
                    {
                        ApplicationArea = All;
                        MinValue = 0;
                        MaxValue = 100;
                        DecimalPlaces = 0 : 2;
                        Caption = 'Line Discount %';
                    }
                    field("Starting Date"; "StartDate")
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                    }
                    field("Ending Date"; "EndingDate")
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                    }
                    field("Currency Code"; "CurrCode")
                    {
                        ApplicationArea = All;
                        Caption = 'Currency Code';
                    }
                    field("Variant Code"; "VariantCode")
                    {
                        ApplicationArea = All;
                        Caption = 'Variant Code';
                    }
                }
                group(Item)
                {
                    field("Item Code"; ItemCode)
                    {
                        ApplicationArea = All;
                        Caption = 'No.';
                        Enabled = EmptyAllItemFields;
                        TableRelation = Item;

                        trigger OnValidate()
                        begin
                            EmptyItemCode := CheckSingleValue(ItemCode);
                            MICAOffInvoiceAutoSetup.CheckIfEnteredValueExistStandardTables(ItemCode, 0);
                        end;

                    }
                    field("Item Category Code"; ItemCategoryCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Item Category Code';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            ItemCategoryCode := UpperCase(ItemCategoryCode);
                            EmptyAllItemFields := CheckSingleValue(ItemCategoryCode);
                            MICAOffInvoiceAutoSetup.CheckIfEnteredValueExistStandardTables(ItemCategoryCode, 1);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            MICAOffInvoiceAutoSetup.SelectionFilter(ItemCategoryCode, 1);
                            EmptyAllItemFields := CheckSingleValue(ItemCategoryCode);
                        end;
                    }

                    field(Brand; BrandCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Brand';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            BrandCode := UpperCase(BrandCode);
                            EmptyAllItemFields := CheckSingleValue(BrandCode);
                            MICAOffInvoiceAutoSetup.CheckIfEnteredValueExistMICAables(BrandCode, 0);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            MICAOffInvoiceAutoSetup.CreateFilterForTableValues(BrandCode, 0);
                            EmptyAllItemFields := CheckSingleValue(BrandCode);
                        end;
                    }
                    field("Rim Diametar"; RimDiameter)
                    {
                        ApplicationArea = All;
                        Caption = 'Rim Diameter';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            EmptyAllItemFields := CheckSingleValue(RimDiameter);
                        end;
                    }
                    field("Pattern Code"; PatternCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Pattern Code';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            PatternCode := UpperCase(PatternCode);
                            EmptyAllItemFields := CheckSingleValue(PatternCode);
                            MICAOffInvoiceAutoSetup.CheckIfEnteredValueExistMICAables(PatternCode, 1);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            MICAOffInvoiceAutoSetup.CreateFilterForTableValues(PatternCode, 1);
                            EmptyAllItemFields := CheckSingleValue(PatternCode);
                        end;
                    }
                    field("Commercial Label"; CommercialLabel)
                    {
                        ApplicationArea = All;
                        Caption = 'Commercial Label';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            EmptyAllItemFields := CheckSingleValue(CommercialLabel);
                        end;
                    }
                    field("Market Code"; MarketCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Market Code';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            EmptyAllItemFields := CheckSingleValue(MarketCode);
                            MICAOffInvoiceAutoSetup.CheckIfEnteredValueExistMICAables(MarketCode, 2);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            MICAOffInvoiceAutoSetup.CreateFilterForTableValues(MarketCode, 2);
                            EmptyAllItemFields := CheckSingleValue(MarketCode);
                        end;
                    }
                    field("Item Class"; ItemClass)
                    {
                        ApplicationArea = All;
                        Caption = 'Item Class';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            EmptyAllItemFields := CheckSingleValue(ItemClass);
                        end;
                    }
                    field("Product Nature"; ProductNature)
                    {
                        ApplicationArea = All;
                        Caption = 'Product Nature';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            ProductNature := UpperCase(ProductNature);
                            EmptyAllItemFields := CheckSingleValue(ProductNature);
                            MICAOffInvoiceAutoSetup.CheckIfEnteredValueExistMICAables(ProductNature, 3);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            MICAOffInvoiceAutoSetup.CreateFilterForTableValues(ProductNature, 3);
                            EmptyAllItemFields := CheckSingleValue(ProductNature);
                        end;
                    }
                    field("LPR Category"; LPRCategory)
                    {
                        ApplicationArea = All;
                        Caption = 'LPR Category';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            LPRCategory := UpperCase(LPRCategory);
                            EmptyAllItemFields := CheckSingleValue(LPRCategory);
                            MICAOffInvoiceAutoSetup.CheckIfEnteredValueExistMICAables(LPRCategory, 4);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            MICAOffInvoiceAutoSetup.CreateFilterForTableValues(LPRCategory, 4);
                            EmptyAllItemFields := CheckSingleValue(LPRCategory);
                        end;
                    }
                    field("Section Width"; SectionWidth)
                    {
                        ApplicationArea = All;
                        Caption = 'Section Width';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            EmptyAllItemFields := CheckSingleValue(SectionWidth);
                        end;
                    }
                    field("Aspect Ratio"; AspectRatio)
                    {
                        ApplicationArea = All;
                        Caption = 'Aspect Ratio';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            EmptyAllItemFields := CheckSingleValue(AspectRatio);
                        end;
                    }
                    field("CCID Code"; CCIDCode)
                    {
                        ApplicationArea = All;
                        Caption = 'CCID Code';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            EmptyAllItemFields := CheckSingleValue(CCIDCode);
                        end;
                    }
                    field("Business Line"; BusinessLine)
                    {
                        ApplicationArea = All;
                        Caption = 'Business Line';
                        Enabled = EmptyItemCode;

                        trigger OnValidate()
                        begin
                            BusinessLine := UpperCase(BusinessLine);
                            EmptyAllItemFields := CheckSingleValue(BusinessLine);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
                            DimensionValue: Record "Dimension Value";
                            DimensionValueList: Page "Dimension Value List";
                        begin
                            MICAFinancialReportingSetup.Get();
                            MICAFinancialReportingSetup.TestField("Structure Dimension");
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                            DimensionValue.SetFilter("MICA Michelin Code", '<>%1', '');

                            Clear(DimensionValueList);
                            DimensionValueList.SetTableView(DimensionValue);
                            DimensionValueList.LookupMode(true);

                            if DimensionValueList.RunModal() = Action::LookupOK then begin
                                DimensionValueList.GetRecord(DimensionValue);
                                BusinessLine := DimensionValue."MICA Michelin Code"
                            end else
                                exit;
                            EmptyAllItemFields := CheckSingleValue(BusinessLine);
                        end;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {

            }
        }

        trigger OnInit()
        begin
            EmptyItemCode := CheckSingleValue(ItemCode);
            EmptyAllItemFields := CheckAllItemFields();
        end;

        trigger OnOpenPage()
        begin
            EmptyItemCode := CheckSingleValue(ItemCode);
            EmptyAllItemFields := CheckAllItemFields();
        end;
    }
    var
        MICAOffInvoiceAutoSetup: Codeunit "MICA Off-Invoice Auto Setup";
        SalesType: Option "Customer","Customer Disc. Group","All Customer";
        SalesCode: code[20];
        ItemDiscGrpCode: Code[20];
        UOMCode: Code[10];
        MinimumQty: Decimal;
        LineDisc: Decimal;
        StartDate: Date;
        EndingDate: Date;
        CurrCode: Code[10];
        VariantCode: Code[10];
        ItemDiscGrpDesc: Text[30];
        ItemCode: Text;
        ItemCategoryCode: Text;
        BrandCode: Text;
        RimDiameter: Text;
        PatternCode: Text;
        CommercialLabel: Text;
        MarketCode: Text;
        ItemClass: Text;
        ProductNature: Text;
        LPRCategory: Text;
        SectionWidth: Text;
        AspectRatio: Text;
        CCIDCode: Text;
        BusinessLine: Text;
        ProgressWindowDialog: Dialog;
        AmountProcessed: Integer;
        AmountToProcess: Integer;
        PercentProcessed: Integer;
        [InDataSet]
        EmptyItemCode: Boolean;
        [InDataSet]
        EmptyAllItemFields: Boolean;
        ProgressEntriesLbl: Label 'Processing entries       #1################';

    local procedure CheckIsEmptyParams()
    var
        SalesLineDiscount: Record "Sales Line Discount";
        IsEmpty_Err: label '%1 must not be empty.';
    begin
        IF ItemDiscGrpCode = '' THEN
            Error(IsEmpty_Err, SalesLineDiscount.FieldCaption(Code));
        if LineDisc = 0 then
            Error(IsEmpty_Err, SalesLineDiscount.FieldCaption("Line Discount %"));
    end;

    local procedure FilterItem(var Item: Record Item)
    begin
        if ItemCode <> '' then
            Item.SetFilter("No.", ItemCode);
        if ItemCategoryCode <> '' then
            Item.SetFilter("Item Category Code", ItemCategoryCode);
        if BrandCode <> '' then
            Item.SetFilter("MICA Brand", BrandCode);
        if RimDiameter <> '' then
            Item.SetFilter("MICA Rim Diameter", RimDiameter);
        if PatternCode <> '' then
            Item.SetFilter("MICA Pattern Code", PatternCode);
        if CommercialLabel <> '' then
            Item.SetFilter("MICA Commercial Label", CommercialLabel);
        if MarketCode <> '' then
            Item.SetFilter("MICA Market Code", MarketCode);
        if ItemClass <> '' then
            Item.SetFilter("MICA Item Class", ItemClass);
        if ProductNature <> '' then
            Item.SetFilter("MICA Product Nature", ProductNature);
        if LPRCategory <> '' then
            Item.SetFilter("MICA LPR Category", LPRCategory);
        if SectionWidth <> '' then
            Item.SetFilter("MICA Section Width", SectionWidth);
        if AspectRatio <> '' then
            Item.SetFilter("MICA Aspect Ratio", AspectRatio);
        if CCIDCode <> '' then
            Item.SetFilter("MICA CCID Code", CCIDCode);
        if BusinessLine <> '' then
            Item.SetFilter("MICA Business Line", BusinessLine);
    end;

    procedure FillOffInvoiceSelectionSetup()
    var
        MICAOffInvItemSelSetup: Record "MICA Off-Inv. Item Sel. Setup";
        ErrorTxt: Text;
        ExistItemDiscGroupOffInvSetup_Err: Label 'Item discount group code already exist in %1.';
    begin
        if not MICAOffInvItemSelSetup.Get(ItemDiscGrpCode) then begin
            MICAOffInvItemSelSetup.Init();

            MICAOffInvItemSelSetup.Validate("Item Discount Group Code", ItemDiscGrpCode);
            RearrangeValues(MICAOffInvItemSelSetup);

            MICAOffInvItemSelSetup.Insert();
        end else begin
            ErrorTxt := StrSubstNo(ExistItemDiscGroupOffInvSetup_Err, MICAOffInvItemSelSetup.TableCaption());
            Error(ErrorTxt);
        end;
    end;

    local procedure RearrangeValues(var MICAOffInvItemSelSetup: Record "MICA Off-Inv. Item Sel. Setup")
    begin
        MICAOffInvItemSelSetup."Item Code" := CopyStr(CopyStr(ItemCode, 1, MaxStrLen(ItemCode)), 1, MaxStrLen(MICAOffInvItemSelSetup."Item Code"));
        MICAOffInvItemSelSetup."Item Category Code" := CopyStr(CopyStr(ItemCategoryCode, 1, MaxStrLen(ItemCategoryCode)), 1, MaxStrLen(MICAOffInvItemSelSetup."Item Category Code"));
        MICAOffInvItemSelSetup.Brand := CopyStr(CopyStr(BrandCode, 1, MaxStrLen(BrandCode)), 1, MaxStrLen(MICAOffInvItemSelSetup.Brand));
        MICAOffInvItemSelSetup."Rim Diametar" := CopyStr(CopyStr(RimDiameter, 1, MaxStrLen(RimDiameter)), 1, MaxStrLen(MICAOffInvItemSelSetup."Rim Diametar"));
        MICAOffInvItemSelSetup.Pattern := CopyStr(CopyStr(PatternCode, 1, MaxStrLen(PatternCode)), 1, MaxStrLen(MICAOffInvItemSelSetup.Pattern));
        MICAOffInvItemSelSetup."Commercial Label" := CopyStr(CopyStr(CommercialLabel, 1, MaxStrLen(CommercialLabel)), 1, MaxStrLen(MICAOffInvItemSelSetup."Commercial Label"));
        MICAOffInvItemSelSetup."Market Code" := CopyStr(CopyStr(MarketCode, 1, MaxStrLen(MarketCode)), 1, MaxStrLen(MICAOffInvItemSelSetup."Market Code"));
        MICAOffInvItemSelSetup."Item Class" := CopyStr(CopyStr(ItemClass, 1, MaxStrLen(ItemClass)), 1, MaxStrLen(MICAOffInvItemSelSetup."Item Class"));
        MICAOffInvItemSelSetup."Product Nature" := CopyStr(CopyStr(ProductNature, 1, MaxStrLen(ProductNature)), 1, MaxStrLen(MICAOffInvItemSelSetup."Product Nature"));
        MICAOffInvItemSelSetup."LPR Category" := CopyStr(CopyStr(LPRCategory, 1, MaxStrLen(LPRCategory)), 1, MaxStrLen(MICAOffInvItemSelSetup."LPR Category"));
        MICAOffInvItemSelSetup."Section Width" := CopyStr(CopyStr(SectionWidth, 1, MaxStrLen(SectionWidth)), 1, MaxStrLen(MICAOffInvItemSelSetup."Section Width"));
        MICAOffInvItemSelSetup."Aspect Ratio" := CopyStr(CopyStr(AspectRatio, 1, MaxStrLen(AspectRatio)), 1, MaxStrLen(MICAOffInvItemSelSetup."Aspect Ratio"));
        MICAOffInvItemSelSetup."CCID Code" := CopyStr(CopyStr(CCIDCode, 1, MaxStrLen(CCIDCode)), 1, MaxStrLen(MICAOffInvItemSelSetup."CCID Code"));
        MICAOffInvItemSelSetup."Business Line" := CopyStr(CopyStr(BusinessLine, 1, MaxStrLen(BusinessLine)), 1, MaxStrLen(MICAOffInvItemSelSetup."Business Line"));
        MICAOffInvItemSelSetup."Item Discount Group Desc." := ItemDiscGrpDesc;
    end;

    local procedure CheckAllItemFields(): Boolean
    begin
        exit(CheckSingleValue(ItemCategoryCode) or CheckSingleValue(BrandCode) or CheckSingleValue(RimDiameter) or CheckSingleValue(PatternCode) or
            CheckSingleValue(CommercialLabel) or CheckSingleValue(MarketCode) or CheckSingleValue(ItemClass) or CheckSingleValue(ProductNature) or
            CheckSingleValue(LPRCategory) or CheckSingleValue(SectionWidth) or CheckSingleValue(AspectRatio) or CheckSingleValue(CCIDCode) or CheckSingleValue(BusinessLine));
    end;

    local procedure CheckSingleValue(InputParam: Text): Boolean
    begin
        exit(InputParam = '');
    end;
}