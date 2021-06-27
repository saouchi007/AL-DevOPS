table 83003 "MICA Rebate Pool Item Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Rebate Pool Item Setup';
    LookupPageId = "MICA Rebate Pool Item Setup";
    DrillDownPageId = "MICA Rebate Pool Item Setup";

    fields
    {
        field(1; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
        field(2; "Business Line"; Code[10])
        {
            Caption = 'Business Line';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                DimensionValue: Record "Dimension Value";
                MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
                DimValDimensionValueList: Page "Dimension Value List";
            begin
                MICAFinancialReportingSetup.Get();
                MICAFinancialReportingSetup.TestField("Structure Dimension");
                DimensionValue.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                DimValDimensionValueList.SetTableView(DimensionValue);
                DimValDimensionValueList.LookupMode(true);
                if DimValDimensionValueList.RunModal() = Action::LookupOK then begin
                    DimValDimensionValueList.GetRecord(DimensionValue);
                    Validate("Business Line", DimensionValue."MICA Michelin Code");
                end;
            end;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
                MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
                NotACorrectValueLbl: Label '%1 is not a correct value.';
            begin
                MICAFinancialReportingSetup.Get();
                MICAFinancialReportingSetup.TestField("Structure Dimension");
                DimensionValue.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
                DimensionValue.SetRange("MICA Michelin Code", "Business Line");
                if DimensionValue.IsEmpty() then
                    Error(NotACorrectValueLbl, "Business Line");

                if DimensionValue.FindFirst() then
                    Validate("Shortcut Dimension 2 Code", DimensionValue.Code);
            end;
        }
        field(3; "Rebate Pool Item No."; Code[20])
        {
            Caption = 'Rebate Pool Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(4; "Rebate Dim. Value Code"; Code[20])
        {
            Caption = 'REBATE Dim. Value Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('Rebate'));
        }
        field(5; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }
    }

    keys
    {
        key(PK; "Item Category Code", "Business Line")
        {
            Clustered = true;
        }
        key(Key1; "Rebate Pool Item No.")
        {

        }
    }
}