table 80047 "MICA Product Nature"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Product Nature List";
    //DrillDownPageId = "MICA Product Nature List";
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