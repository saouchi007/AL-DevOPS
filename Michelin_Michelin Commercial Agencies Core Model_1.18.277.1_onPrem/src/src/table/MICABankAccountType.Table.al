table 81550 "MICA Bank Account Type"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Bank Account Types";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
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