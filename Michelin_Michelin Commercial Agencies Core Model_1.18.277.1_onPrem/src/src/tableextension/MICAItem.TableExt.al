tableextension 80040 "MICA Item" extends Item
{
    fields
    {
        field(80000; "MICA Exclude from Report. Grp."; Boolean)
        {
            Caption = 'Exclude from Reporting Group';
            DataClassification = CustomerContent;
        }

        field(80010; "MICA Item Location Code"; Code[20])
        {
            Caption = 'Item Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }

        field(80020; "MICA Express Order"; Boolean)
        {
            Caption = 'Express Order';
            DataClassification = CustomerContent;
        }

        field(80030; "MICA Market Code"; Code[2])
        {
            Caption = 'Market Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(MarketCode), Blocked = const(false));
        }

        field(80040; "MICA Brand"; Code[10])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Brand";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemBrand), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemBrand, "MICA Brand");
            end;

            /*trigger OnLookup()
            var
                MICATableType: Record "MICA Table Type";
            begin
                if MICATableType.Get(MICATableType.Type::ItemBrand) then
                    MICATableType.DrillDownValues();
            end;*/
        }
        field(80041; "MICA Brand Grouping"; Code[20])
        {
            Caption = 'Brand Grouping';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Table Value"."Item Brand Grouping Code" where("Table Type" = const(ItemBrand), Code = field("MICA Brand")));
        }

        field(80050; "MICA Item Segment"; Code[10])
        {
            Caption = 'Item Segment';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Item Segment";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemSegment), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemSegment, "MICA Item Segment");
            end;
        }

        field(80060; "MICA Long Description"; Text[100])
        {
            Caption = 'Long Description';
            DataClassification = CustomerContent;
        }

        field(80061; "MICA Short Description"; Text[100])
        {
            Caption = 'Short Description';
            DataClassification = CustomerContent;
        }

        field(80070; "MICA Primary Unit Of Measure"; Code[10])
        {
            Caption = 'Primary Unit Of Measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }

        field(80080; "MICA LP Family Code"; Code[10])
        {
            Caption = 'LP Family Code';
            DataClassification = CustomerContent;
            //TableRelation = "MICA LP Family";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemLPFamily), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemLPFamily, "MICA LP Family Code");
            end;
        }

        field(80090; "MICA LP Appartenance"; Code[10])
        {
            Caption = 'LP Appartenance';
            DataClassification = CustomerContent;
            //TableRelation = "MICA LP Appartenance";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80100; "MICA LPR Category"; Code[10])
        {
            Caption = 'LPR Category ';
            DataClassification = CustomerContent;
            //TableRelation = "MICA LPR Category";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemLPRCategory), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemLPRCategory, "MICA LPR Category");
            end;
        }

        field(80110; "MICA LPR Sub Family"; Code[10])
        {
            Caption = 'LPR Sub Family ';
            DataClassification = CustomerContent;
            //TableRelation = "MICA LPR Sub Family";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemLPRSubFamily), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemLPRSubFamily, "MICA LPR Sub Family");
            end;
        }

        field(80120; "MICA Product Nature"; Code[10])
        {
            Caption = 'Product Nature';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Product Nature";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemProductNature), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemProductNature, "MICA Product Nature");
            end;
        }

        field(80130; "MICA Usage Category"; Code[10])
        {
            Caption = 'Usage Category';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Usage Category";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemUsageCategory), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemUsageCategory, "MICA Usage Category");
            end;
        }

        field(80140; "MICA Prevision Indicator"; Code[10])
        {
            Caption = 'Prevision Indicator';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Prevision Indicator";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemPrevisionIndicator), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemPrevisionIndicator, "MICA Prevision Indicator");
            end;
        }

        field(80150; "MICA Manufacturer Part Number"; Text[250])
        {
            Caption = 'Manufacturer Part Number';
            DataClassification = CustomerContent;
        }

        field(80160; "MICA Embargo Indicator"; Code[10])
        {
            Caption = 'Embargo Indicator';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Embargo Indicator";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80170; "MICA Commercial Label"; Text[250])
        {
            Caption = 'Commercial Label';
            DataClassification = CustomerContent;
        }

        field(80180; "MICA Product Weight"; Decimal)
        {
            Caption = 'Product Weight';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                InventorySetup: Record "Inventory Setup";
            begin
                if Rec."MICA Product Weight" = xRec."MICA Product Weight" then
                    exit;
                if not InventorySetup.Get() then
                    exit;
                if InventorySetup."MICA Item Weight Default UoM" = '' then
                    exit;
                if "MICA Net Weight UoM" = '' then
                    Validate("MICA Net Weight UoM", InventorySetup."MICA Item Weight Default UoM");
                if "MICA Gross Weight UoM" = '' then
                    Validate("MICA Gross Weight UoM", InventorySetup."MICA Item Weight Default UoM");
                Validate("Net Weight", round("MICA Product Weight" / InventorySetup."MICA Item to PS9 Weight Factor", InventorySetup."MICA Item Wght Decimal Places", '='));
                Validate("Gross Weight", round("MICA Product Weight" / InventorySetup."MICA Item to PS9 Weight Factor", InventorySetup."MICA Item Wght Decimal Places", '='));
                Modify();
            end;
        }

        field(80190; "MICA Product Weight UOM"; Code[10])
        {
            Caption = 'Product Weight UOM ';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }

        field(80200; "MICA Section Width"; Decimal)
        {
            Caption = 'Section Width';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
            //ObsoleteState = Removed;
        }

        field(80210; "MICA Section Width UOM"; Code[10])
        {
            Caption = 'Section Width UOM';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80220; "MICA Aspect Ratio"; Code[10])
        {
            Caption = 'Aspect Ratio';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Aspect Ratio";
            //ObsoleteState = Removed;
        }

        field(80230; "MICA Bead Seat Diameter"; Text[250])
        {
            Caption = 'Bead Seat Diameter';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80231; "MICA Rim Diameter"; Text[10])
        {
            Caption = 'Rim Diameter';
            DataClassification = CustomerContent;
        }

        field(80240; "MICA Bead Seat Diameter UOM"; Code[10])
        {
            Caption = 'Bead Seat Diameter UOM';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80241; "MICA Rim Diameter UOM"; Code[10])
        {
            Caption = 'Rim diameter UOM';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }

        field(80250; "MICA Load Index 1"; Decimal)
        {
            Caption = 'Load Index 1';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }

        field(80260; "MICA Speed Index 1"; Code[10])
        {
            Caption = 'Speed Index 1';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Speed Index";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemSpeedIndex1), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemSpeedIndex1, "MICA Speed Index 1");
            end;
        }

        field(80270; "MICA Tire Type"; Code[10])
        {
            Caption = 'Tire Type';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Tire Type";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemTireType), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemTireType, "MICA Tire Type");
            end;
        }

        field(80280; "MICA Star Sating"; Code[10])
        {
            Caption = 'Star Rating';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Star Rating";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
            //TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemStarSating), Blocked = const(false));
            //trigger OnValidate()
            //begin
            //    MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableVal."Table Type"::ItemStarSating, "MICA Star Sating");
            //end;
        }
        field(80281; "MICA Star Rating"; Code[10])
        {
            Caption = 'Star Rating';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemStarRating), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemStarRating, "MICA Star Rating");
            end;
        }

        field(80290; "MICA Active Country"; Code[10])
        {
            Caption = 'Active Country';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80300; "MICA Start Year"; Date)
        {
            Caption = 'Start Year';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80310; "MICA End Year"; Date)
        {
            Caption = 'End Year';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80320; "MICA Grading Type"; Code[10])
        {
            Caption = 'Grading Type';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Grading Type";
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemGradingType), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemGradingType, "MICA Grading Type");
            end;
        }

        field(80330; "MICA Rolling Resistance"; Text[250])
        {
            Caption = 'Rolling Resistance';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80331; "MICA Rolling Resistance2"; Text[10])
        {
            Caption = 'Rolling Resistance';
            DataClassification = CustomerContent;
        }

        field(80340; "MICA Wet Grip"; Text[250])
        {
            Caption = 'Wet Grip';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80341; "MICA Wet Grip2"; Text[10])
        {
            Caption = 'Wet Grip';
            DataClassification = CustomerContent;
        }

        field(80350; "MICA Noise Performance"; Text[250])
        {
            Caption = 'Noise Performance';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80351; "MICA Noise Performance2"; Text[10])
        {
            Caption = 'Noise Performance';
            DataClassification = CustomerContent;
        }

        field(80360; "MICA Noise Wave"; Text[250])
        {
            Caption = 'Noise Wave';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80361; "MICA Noise Wave2"; Text[10])
        {
            Caption = 'Noise Wave';
            DataClassification = CustomerContent;
        }

        field(80370; "MICA Noise Class"; Text[250])
        {
            Caption = 'Noise Class';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80371; "MICA Noise Class2"; Text[10])
        {
            Caption = 'Noise Class';
            DataClassification = CustomerContent;
        }

        field(80380; "MICA Aspect Quality"; Text[250])
        {
            Caption = 'Aspect Quality';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80381; "MICA Aspect Quality2"; Code[20])
        {
            Caption = 'Aspect Quality';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemAspectQuality), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemAspectQuality, "MICA Aspect Quality2");
            end;
        }

        field(80390; "MICA Marketing Manager Name"; Text[250])
        {
            Caption = 'Marketing Manager Name';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80391; "MICA Marketing Manager Name2"; Text[250])
        {
            Caption = 'Marketing Manager Name';
            DataClassification = CustomerContent;
        }

        field(80400; "MICA Homologation Class"; Text[250])
        {
            Caption = 'Homologation Class';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80410; "MICA CAD Business Line"; Text[250])
        {
            Caption = 'CAD Business Line';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80420; "MICA Commercial. Start Date"; Date)
        {
            Caption = 'Commercialization Start Date';
            DataClassification = CustomerContent;
        }

        field(80430; "MICA Commercial. End Date"; Date)
        {
            Caption = 'Commercialization End Date';
            DataClassification = CustomerContent;
        }

        field(80440; "MICA Vehicle Code"; Text[250])
        {
            Caption = 'Vehicle Code';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80450; "MICA Homologation Type"; code[10])
        {
            Caption = 'Homologation Type';
            DataClassification = CustomerContent;
            //TableRelation = "MICA Homologation Type";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80460; "MICA Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80470; "MICA End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80480; "MICA Country"; Text[250])
        {
            Caption = 'Country';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80490; "MICA Derogation Number"; Code[10])
        {
            Caption = 'Derogation number';
            DataClassification = CustomerContent;
        }

        field(80500; "MICA Derogation Quantity"; Decimal)
        {
            Caption = 'Derogation quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }

        field(80510; "MICA Primary UOM"; Code[10])
        {
            Caption = 'Primary UOM';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80520; "MICA Effective Start Date"; Date)
        {
            Caption = 'Effective Start Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80530; "MICA Effective End Date"; Date)
        {
            Caption = 'Effective End Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80540; "MICA Attribute Code"; Code[10])
        {
            Caption = 'Attribute Code';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80550; "MICA Attribute Description"; Text[50])
        {
            Caption = 'Attribute Description';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80560; "MICA Embargo"; Boolean)
        {
            Caption = 'Embargo';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80570; "MICA Item Class"; Code[30])
        {
            Caption = 'Item Class';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemClass), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemClass, "MICA Item Class");
            end;

        }
        field(80580; "MICA Sensitive Product"; Boolean)
        {
            Caption = 'Sensitive Product';
            DataClassification = CustomerContent;
        }
        field(80590; "MICA Item Status"; Boolean)
        {
            Caption = 'Item status';
            DataClassification = CustomerContent;
        }
        field(80600; "MICA Item Master Type Code"; Code[20])
        {
            Caption = 'Item Master Type Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemItemMasterTypeCode), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemItemMasterTypeCode, "MICA Item Master Type Code");
            end;
        }
        field(80610; "MICA Product Segment"; Code[20])
        {
            Caption = 'Product Segment';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemProductSegment), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemProductSegment, "MICA Product Segment");
            end;
        }
        field(80620; "MICA None Update from PS9"; Boolean)
        {
            Caption = 'Item to Update';
            DataClassification = CustomerContent;
        }
        field(80630; "MICA CCID Code"; Code[3])
        {
            Caption = 'CCID Code';
            DataClassification = CustomerContent;
        }
        field(80640; "MICA User Item Type"; Code[10])
        {
            Caption = 'User Item Type';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemUserItemType), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemUserItemType, "MICA User Item Type");
            end;
        }
        field(80650; "MICA Vignette"; Boolean)
        {
            Caption = 'Vignette';
            DataClassification = CustomerContent;
        }
        field(80660; "MICA Business Line"; Code[10])
        {
            Caption = 'Business Line';
            DataClassification = CustomerContent;
            //TableRelation = "Dimension Value"."MICA Michelin Code";

            trigger OnLookup()
            var
                DimVal: Record "Dimension Value";
                MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
                DimValLt: Page "Dimension Value List";
            begin
                MICAFinancialReportingSetup.Get();
                MICAFinancialReportingSetup.TestField("Structure Dimension");
                DimVal.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                DimValLt.SetTableView(DimVal);
                DimValLt.LookupMode(true);
                if DimValLt.RunModal() = Action::LookupOK THEN BEGIN
                    DimValLt.GetRecord(DimVal);
                    Validate("MICA Business Line", DimVal."MICA Michelin Code");
                end;
            end;

            trigger OnValidate()
            var
                DimVal: Record "Dimension Value";
                MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
            begin
                MICAFinancialReportingSetup.Get();
                MICAFinancialReportingSetup.TestField("Structure Dimension");
                DimVal.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                DimVal.SetRange("MICA Michelin Code", "MICA Business Line");
                if DimVal.FindFirst() then
                    Validate("Global Dimension 2 Code", DimVal."Code")
                else
                    if "MICA Business Line" <> '' then
                        Error(NotACorrectValueLbl, "MICA Business Line");
            end;
        }
        field(80670; "MICA Business Line OE"; Code[10])
        {
            Caption = 'Business Line OE';
            DataClassification = CustomerContent;
            //TableRelation = "Dimension Value"."MICA Michelin Code";
            trigger OnLookup()
            var
                DimVal: Record "Dimension Value";
                MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
                DimValLt: Page "Dimension Value List";
            begin
                MICAFinancialReportingSetup.Get();
                MICAFinancialReportingSetup.TestField("Structure Dimension");
                DimVal.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                DimValLt.SetTableView(DimVal);
                DimValLt.LookupMode(true);
                if DimValLt.RunModal() = Action::LookupOK THEN BEGIN
                    DimValLt.GetRecord(DimVal);
                    Validate("MICA Business Line OE", DimVal."MICA Michelin Code");
                end;
            end;

            trigger OnValidate()
            var
                DimVal: Record "Dimension Value";
                MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
            begin
                MICAFinancialReportingSetup.Get();
                MICAFinancialReportingSetup.TestField("Structure Dimension");
                DimVal.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                DimVal.SetRange("MICA Michelin Code", "MICA Business Line OE");
                if DimVal.IsEmpty() then
                    if "MICA Business Line OE" <> '' then
                        Error(NotACorrectValueLbl, "MICA Business Line OE");
            end;
        }
        field(80680; "MICA Business Line RT"; Code[10])
        {
            Caption = 'Business Line RT';
            DataClassification = CustomerContent;
            //TableRelation = "Dimension Value"."MICA Michelin Code";
            trigger OnLookup()
            var
                DimVal: Record "Dimension Value";
                MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
                DimValLt: Page "Dimension Value List";
            begin
                MICAFinancialReportingSetup.Get();
                MICAFinancialReportingSetup.TestField("Structure Dimension");
                DimVal.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                DimValLt.SetTableView(DimVal);
                DimValLt.LookupMode(true);
                if DimValLt.RunModal() = Action::LookupOK THEN BEGIN
                    DimValLt.GetRecord(DimVal);
                    Validate("MICA Business Line RT", DimVal."MICA Michelin Code");
                end;
            end;

            trigger OnValidate()
            var
                DimVal: Record "Dimension Value";
                MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
            begin
                MICAFinancialReportingSetup.Get();
                MICAFinancialReportingSetup.TestField("Structure Dimension");
                DimVal.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                DimVal.SetRange("MICA Michelin Code", "MICA Business Line RT");
                if DimVal.IsEmpty() then
                    if "MICA Business Line RT" <> '' then
                        Error(NotACorrectValueLbl, "MICA Business Line RT");
            end;
        }
        field(80690; "MICA Administrative Status"; Code[20])
        {
            Caption = 'Administrative Status';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemAdministrativeStatus), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemAdministrativeStatus, "MICA Administrative Status");
            end;
        }
        field(80700; "MICA Load Range"; Code[20])
        {
            Caption = 'Load Range';
            DataClassification = CustomerContent;
        }
        field(80710; "MICA Airtightness"; Code[2])
        {
            Caption = 'Airtightness';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemAirtightness), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemAirtightness, "MICA Airtightness");
            end;
        }
        field(80720; "MICA Tire Size"; Text[30])
        {
            Caption = 'Tire size';
            DataClassification = CustomerContent;
        }
        field(80730; "MICA Pattern Code"; Code[20])
        {
            Caption = 'Pattern Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(ItemPatternCode), Blocked = const(false));
            trigger OnValidate()
            begin
                MICASyncValuesToItemAttr.SynchronizeToItem("No.", MICATableValue."Table Type"::ItemPatternCode, "MICA Pattern Code");
            end;
        }

        field(80760; "MICA Accr. Item Grp."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Rebates Item Group';
            TableRelation = "MICA Accrual Item Group";
        }
        //Flow Export
        field(80860; "MICA Send Last Flow Entry No."; Integer)
        {
            Caption = 'Send Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
        }
        field(80862; "MICA Send Last Flow Status"; Option)
        {
            Caption = 'Send Last Flow Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "",Prepared,Sent;
            OptionCaption = ',Prepared,Sent';
        }
        field(80864; "MICA Send Last DateTime"; DateTime)
        {
            Caption = 'Send Last DateTime';
            Editable = false;
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80865; "MICA Send Last DateTime2"; DateTime)
        {
            Caption = 'Send Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Sent Date Time" where("Entry No." = field("MICA Send Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80866; "MICA Send Last Info Count"; Integer)
        {
            Caption = 'Send Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80867; "MICA Send Last Warning Count"; Integer)
        {
            Caption = 'Send Last Warning Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80868; "MICA Send Last Error Count"; Integer)
        {
            Caption = 'Send Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Send Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';

        }
        field(80869; "MICA Send Ack. Received"; Boolean)
        {
            Caption = 'Send Ack. Received';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80870; "MICA Rcv. Last Flow Entry No."; Integer)
        {
            Caption = 'Receive Last Flow Entry No.';
            Editable = false;
            TableRelation = "MICA Flow Entry";
            DataClassification = CustomerContent;
        }

        field(80872; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ',Created,Received,Loaded,Processed,PostProcessed';
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80873; "MICA Receive Last Flow Status2"; Option)
        {
            Caption = 'Receive Last Flow Status';
            Editable = false;
            OptionMembers = "",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ',Created,Received,Loaded,Processed,PostProcessed';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Receive Status" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }

        field(80874; "MICA Receive Last DateTime"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80875; "MICA Receive Last DateTime2"; DateTime)
        {
            Caption = 'Receive Last DateTime';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Flow Entry"."Received Date Time" where("Entry No." = field("MICA Rcv. Last Flow Entry No.")));
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80876; "MICA Receive Last Info Count"; Integer)
        {
            Caption = 'Receive Last Info Count';
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80877; "MICA Rcv. Last Warning Count"; Integer)
        {
            Caption = 'Receive Last Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80878; "MICA Receive Last Error Count"; Integer)
        {
            Caption = 'Receive Last Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Error), "Flow Entry No." = field("MICA Rcv. Last Flow Entry No."), "Linked Record ID" = field("MICA Record ID")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(80879; "MICA Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
        }
        //Flow end
        field(80880; "MICA Homologator Code"; Code[4])
        {
            Caption = 'Homologator Code';
            DataClassification = CustomerContent;
        }
        field(80890; "MICA Homologator Label"; Text[50])
        {
            Caption = 'Homologator Label';
            DataClassification = CustomerContent;
        }
        field(80900; "MICA Homologation Market Code"; Code[2])
        {
            Caption = 'Homologation Market Code';
            DataClassification = CustomerContent;
        }
        field(80910; "MICA Homologation Vehicle Code"; Code[3])
        {
            Caption = 'Homologation Vehicle Code';
            DataClassification = CustomerContent;
        }
        field(80920; "MICA Homologation Type2"; Code[1])
        {
            Caption = 'Homologation Type';
            DataClassification = CustomerContent;
        }
        field(80930; "MICA Homologation Start Date"; Date)
        {
            Caption = 'Homologation Start Date';
            DataClassification = CustomerContent;
        }
        field(80940; "MICA Homologation End Date"; Date)
        {
            Caption = 'Homologation End Date';
            DataClassification = CustomerContent;
        }
        field(80950; "MICA Homologa. Deliver Profil"; Text[1])
        {
            Caption = 'Homologation Deliver Profil';
            DataClassification = CustomerContent;
        }
        field(80960; "MICA Homologation Country"; Code[10])
        {
            Caption = 'Homologation Country';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code;
        }
        field(80970; "MICA Certificate Country"; Code[10])
        {
            Caption = 'Certificate Country';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code;
        }
        field(80980; "MICA Certif. Effective Date"; Date)
        {
            Caption = 'Certificate Effective Date';
            DataClassification = CustomerContent;
        }
        field(80990; "MICA Certif. Expiration Date"; Date)
        {
            Caption = 'Certificate Expiration Date';
            DataClassification = CustomerContent;
        }
        field(81000; "MICA Certificate Number"; Text[50])
        {
            Caption = 'Certificate Number';
            DataClassification = CustomerContent;
        }
        field(81010; "MICA Regional. Active Country"; Code[10])
        {
            Caption = 'Regionalisation Active Country';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code;
        }
        field(81020; "MICA Regional. Act. Str. Date"; Date)
        {
            Caption = 'Regionalisation Active Start Date';
            DataClassification = CustomerContent;
        }
        field(81030; "MICA Regional. Act. End Date"; Date)
        {
            Caption = 'Regionalisation Active End Date';
            DataClassification = CustomerContent;
        }
        field(81040; "MICA Custom Export Country"; Code[10])
        {
            Caption = 'Custom Export Country';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code;
        }
        field(81050; "MICA Custom Start Date"; Code[10])
        {
            Caption = 'Custom Start Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(81051; "MICA Custom Start Date2"; Date)
        {
            Caption = 'Custom Start Date';
            DataClassification = CustomerContent;
        }
        field(81060; "MICA Custom End Date"; Code[10])
        {
            Caption = 'Custom End Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(81061; "MICA Custom End Date2"; Date)
        {
            Caption = 'Custom End Date';
            DataClassification = CustomerContent;
        }
        field(81070; "MICA Military ECCN Code"; Code[50])
        {
            Caption = 'Military/ECCN code';
            DataClassification = CustomerContent;
            //TableRelation = "Country/Region";
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(81071; "MICA Military ECCN Code2"; Text[50])
        {
            Caption = 'Military/ECCN code';
            DataClassification = CustomerContent;
        }
        field(81080; "MICA Military ECCN Label"; Text[50])
        {
            Caption = 'Military/ECCN label';
            DataClassification = CustomerContent;
        }
        field(81090; "MICA Military Export Country"; Code[10])
        {
            Caption = 'Military Export Country';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(81100; "MICA Military Start Date"; Date)
        {
            Caption = 'Military Start Date';
            DataClassification = CustomerContent;
        }
        field(81110; "MICA Military End Date"; Date)
        {
            Caption = 'Military End Date';
            DataClassification = CustomerContent;
        }
        field(81760; "MICA LB-OE"; Code[10])
        {
            Caption = 'LB-OE';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                LookupLBOE();
            end;


        }
        field(81761; "MICA LB-RT"; Code[10])
        {
            Caption = 'LB-RT';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                LookupLBRT();
            end;
        }
        field(82460; "MICA Product Volume UoM"; Code[10])
        {
            Caption = 'Product Volume UoM';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(82461; "MICA Product Volume"; Decimal)
        {
            Caption = 'Product Volume';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(82462; "MICA EAN Item ID"; Text[20])
        {
            Caption = 'EAN Article ID';
            DataClassification = CustomerContent;
        }
        field(82900; "MICA Auto Off-Invoice Setup"; Boolean)
        {
            Caption = 'Auto Off-Invoice Setup';
            DataClassification = CustomerContent;
        }
        field(82080; "MICA Net Weight UoM"; Code[10])
        {
            Caption = 'Net Weight Unit of Measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
        field(82085; "MICA Gross Weight UoM"; Code[10])
        {
            Caption = 'Gross Weight Unit of Measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "MICA Auto Off-Invoice Setup")
        {

        }
    }

    procedure IsInRangeOfCommercializationDate(DateToCheck: Date): Boolean
    begin
        if ("MICA Commercial. Start Date" = 0D) then begin
            if ("MICA Commercial. End Date" = 0D) then
                exit(true)
            else
                if ("MICA Commercial. End Date" < DateToCheck) then
                    exit(false)
                else
                    exit(true);
        end else
            if ("MICA Commercial. End Date" = 0D) then
                if ("MICA Commercial. Start Date" > DateToCheck) then
                    exit(false)
                else
                    exit(true)
            else
                if (DateToCheck >= "MICA Commercial. Start Date") and (DateToCheck <= "MICA Commercial. End Date") then
                    exit(true)
                else
                    exit(false);
    end;

    procedure IsOverRangeOfCommercializationDate(DateToCheck: Date): Boolean
    begin
        if ("MICA Commercial. End Date" = 0D) then
            exit(false)
        else
            if (DateToCheck > "MICA Commercial. End Date") then
                exit(true)
            else
                exit(false);
    end;

    local procedure LookupLBOE()
    var
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionValueList: Page "Dimension Value List";
    begin
        Clear(DimensionValueList);
        GeneralLedgerSetup.Get();
        IF GeneralLedgerSetup."MICA LB Dimension code" = '' then
            exit;
        DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."MICA LB Dimension code");
        DimensionValueList.SetTableView(DimensionValue);
        DimensionValueList.LookupMode(true);
        IF DimensionValueList.RunModal() = Action::LookupOK then begin
            DimensionValueList.GetRecord(DimensionValue);
            IF DimensionValue."MICA Michelin Code" <> '' then
                Validate("MICA LB-OE", DimensionValue."MICA Michelin Code");
        end;
    end;

    local procedure LookupLBRT()
    var
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionValueList: Page "Dimension Value List";
    begin
        Clear(DimensionValueList);
        GeneralLedgerSetup.Get();
        if GeneralLedgerSetup."MICA LB Dimension code" = '' then
            exit;
        DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."MICA LB Dimension code");
        DimensionValueList.SetTableView(DimensionValue);
        DimensionValueList.LookupMode(true);
        IF DimensionValueList.RunModal() = Action::LookupOK then begin
            DimensionValueList.GetRecord(DimensionValue);
            IF DimensionValue."MICA Michelin Code" <> '' then
                Validate("MICA LB-RT", DimensionValue."MICA Michelin Code");
        end;
    end;


    var
        MICATableValue: Record "MICA Table Value";
        MICASyncValuesToItemAttr: Codeunit "MICA Sync Values To Item Attr";
        NotACorrectValueLbl: Label '%1 is not a correct value';
}