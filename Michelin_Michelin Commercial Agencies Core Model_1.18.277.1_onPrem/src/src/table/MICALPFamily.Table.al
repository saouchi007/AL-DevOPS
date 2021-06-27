table 80044 "MICA LP Family"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA LP Family List";
    //DrillDownPageId = "MICA LP Family List";
    ObsoleteState = Removed;
    ObsoleteReason = 'Deleted';
    fields
    {
        field(1; No; Code[10])
        {
            Caption = 'No';
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
        key(PK; No)
        {
            Clustered = true;
        }
    }

}