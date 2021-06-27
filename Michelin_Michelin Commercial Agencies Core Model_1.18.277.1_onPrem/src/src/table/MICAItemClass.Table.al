table 80057 "MICA Item Class"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Item Class List";
    //DrillDownPageId = "MICA Item Class List";
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