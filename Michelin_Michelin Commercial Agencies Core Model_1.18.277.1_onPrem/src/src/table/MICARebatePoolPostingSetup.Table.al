table 83004 "MICA Rebate Pool Posting Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Rebate Pool Posting Setup';
    LookupPageId = "MICA Rebate Pool Posting Setup";
    DrillDownPageId = "MICA Rebate Pool Posting Setup";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Receivable Rebate Account No."; Code[20])
        {
            Caption = 'Receivable Rebate Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(3; "Rebate Account No."; Code[20])
        {
            Caption = 'Rebate Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(4; "Balancing Rebate Account No."; Code[20])
        {
            Caption = 'Balancing Rebate Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
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