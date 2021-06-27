table 83002 "MICA Rebate Pool Journal Line"
{
    Caption = 'Rebate Pool Journal Line';
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Rebate Pool Item Setup";
    LookupPageId = "MICA Rebate Pool Item Setup";

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField("Posting Date");
            end;
        }
        field(4; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
            OptionMembers = "Initial Entry",Invoice,Closing;
            OptionCaption = 'Initial Entry,Invoice,Closing';
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Cutomer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer where("MICA Rebate Pool" = const(true));
        }
        field(6; "Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Accrual Setup";
            trigger OnValidate()
            begin
                UpdateDescription();
            end;
        }
        field(7; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
        field(8; "Business Line"; Code[10])
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
            end;
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            MinValue = 0;
            AutoFormatType = 1;
        }
        field(10; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Posted Document Line No."; Integer)
        {
            Caption = 'Posted Document Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Customer Description"; Text[250])
        {
            Caption = 'Customer Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key1; "Rebate Code", "Customer No.", "Item Category Code", "Business Line")
        {

        }
    }

    local procedure UpdateDescription()
    var
        MICAAccrualSetup: Record "MICA Accrual Setup";
    begin
        if not MICAAccrualSetup.Get(Rec."Rebate Code") then
            MICAAccrualSetup.Init();

        Rec."Customer Description" := MICAAccrualSetup."Description 2";
    end;
}