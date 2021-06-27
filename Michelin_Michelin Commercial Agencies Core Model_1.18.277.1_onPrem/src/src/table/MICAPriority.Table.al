table 81640 "MICA Priority"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Priority List";
    DrillDownPageId = "MICA Priority List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
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