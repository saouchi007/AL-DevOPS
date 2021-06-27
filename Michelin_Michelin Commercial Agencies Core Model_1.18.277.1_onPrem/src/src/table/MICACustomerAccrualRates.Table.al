table 80767 "MICA Customer Accrual Rates"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Rebate Rates';
    LookupPageId = "MICA Customer Accrual Rates";
    DrillDownPageId = "MICA Customer Accrual Rates";
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(3; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(4; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(5; "% Accrual Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '% Rebate Rate';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
        }
        field(6; "Calculation Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculation Date';
        }
    }

    keys
    {
        key(PK; "Code", "Customer No.")
        {
            Clustered = true;
        }
    }
}