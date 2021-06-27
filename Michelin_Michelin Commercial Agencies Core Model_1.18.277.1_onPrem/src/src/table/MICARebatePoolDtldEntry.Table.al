table 83001 "MICA Rebate Pool Dtld. Entry"
{
    Caption = 'Rebate Pool Dtld. Entry';
    DataClassification = CustomerContent;
    LookupPageId = "MICA Rebate Pool Dtld. Entries";
    DrillDownPageId = "MICA Rebate Pool Dtld. Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(3; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
            OptionMembers = "Initial Entry",Invoice,Closing;
            OptionCaption = 'Initial Entry,Invoice,Closing';
        }
        field(4; "Rebate Pool Entry No."; Integer)
        {
            Caption = 'Rebate Pool Entry No.';
            DataClassification = CustomerContent;
        }
        field(5; "Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Accrual Setup";
        }
        field(6; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
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
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(11; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }
        field(12; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = CustomerContent;
        }
        field(13; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
            DataClassification = CustomerContent;
        }
    }

    Keys
    {
        Key(PK; "Entry No.")
        {
            Clustered = true;
        }
        Key(Key1; "Rebate Pool Entry No.")
        {
            SumIndexFields = Amount;
        }
    }
}