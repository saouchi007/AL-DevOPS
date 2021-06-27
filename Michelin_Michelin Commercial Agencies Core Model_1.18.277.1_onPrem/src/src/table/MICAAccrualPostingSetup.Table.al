table 80761 "MICA Accrual Posting Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Rebate Posting Setup';
    LookupPageId = "MICA Accrual Posting Setup";
    DrillDownPageId = "MICA Accrual Posting Setup";
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(2; "Receivable Accr. Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Receivable Rebate Account No.';
            TableRelation = "G/L Account";
        }
        field(3; "Accrual Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate Account No.';
            TableRelation = "G/L Account";
        }
        field(4; "Balancing Rebate Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Balancing Rebate Account No.';
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}