table 81880 "MICA Accrual Setup Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Rebate Setup Line';
    fields
    {
        field(1; "Accrual Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Code';
            
        }
        field(2; Minimum; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum';
        }
        field(3; "% Accrual"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '% of Rebate';
            DecimalPlaces = 0:2;
            MinValue = 0;
            MaxValue = 100;
        }

    }
    
    keys
    {
        key(PK; "Accrual Code",Minimum)
        {
            Clustered = true;
        }
    }
    
}