table 80021 "MICA Distribution"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Distribution List";
    //DrillDownPageId = "MICA Distribution List";
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