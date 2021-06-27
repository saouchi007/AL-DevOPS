table 80763 "MICA Accrual Item Group"
{
    DataClassification = CustomerContent;
    Caption = 'Rebate Item Group';
    LookupPageId = "MICA Accrual Item Groups";
    DrillDownPageId = "MICA Accrual Item Groups";
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(2; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}