table 80043 "MICA Item Segment"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Item Segment List";
    //DrillDownPageId = "MICA Item Segment List";
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