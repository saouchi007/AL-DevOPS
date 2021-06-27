table 80762 "MICA Accr. Cust. Posting Group"
{
    DataClassification = CustomerContent;
    Caption = 'Def. Reb. Customer Posting Group';
    //LookupPageId = "MICA Accr. Cust. Post. Groups";
    //DrillDownPageId = "MICA Accr. Cust. Post. Groups";
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';
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
        field(3; "Accrual Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deferred Rebates Account No.';
            TableRelation = "G/L Account";
        }
        field(4; "Over Take Accr. Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Over Take Def. Reb. Account No.';
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