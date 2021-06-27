table 83000 "MICA Rebate Pool Entry"
{
    Caption = 'Rebate Pool Entry';
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Rebate Pool Entries";
    LookupPageId = "MICA Rebate Pool Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(4; "Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Accrual Setup";
        }
        field(5; "Customer Description"; Text[250])
        {
            Caption = 'Customer Description';
            DataClassification = CustomerContent;
        }
        field(6; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
        field(7; "Business Line"; Code[10])
        {
            Caption = 'Business Line';
            DataClassification = CustomerContent;
        }
        field(8; "Original Amount"; Decimal)
        {
            Caption = 'Original Amount';
            DataClassification = CustomerContent;
        }
        field(9; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("MICA Rebate Pool Dtld. Entry".Amount where("Rebate Pool Entry No." = field("Entry No.")));
        }
        field(10; Open; Boolean)
        {
            Caption = 'Open';
            DataClassification = CustomerContent;
        }
        field(11; "Closed By"; Code[50])
        {
            Caption = 'Closed By';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; Open, "Customer No.", "Item Category Code", "Business Line")
        {

        }
    }
}