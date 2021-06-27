table 80764 "MICA Accrual Customer Group"
{
    DataClassification = CustomerContent;
    Caption = 'Rebate Customer Group';
    LookupPageId = "MICA Accrual Customer Groups";
    DrillDownPageId = "MICA Accrual Customer Groups";
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