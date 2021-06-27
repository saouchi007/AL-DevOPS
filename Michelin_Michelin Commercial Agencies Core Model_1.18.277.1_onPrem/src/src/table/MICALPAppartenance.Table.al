table 80041 "MICA LP Appartenance"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA LP Appartenance List";
    //DrillDownPageId = "MICA LP Appartenance List";
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