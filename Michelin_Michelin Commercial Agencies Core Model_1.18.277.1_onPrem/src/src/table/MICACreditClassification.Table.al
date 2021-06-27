table 80024 "MICA Credit Classification"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Credit Classif List";
    //DrillDownPageId = "MICA Credit Classif List";
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';
    fields
    {
        field(1; "Code"; Code[5])
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