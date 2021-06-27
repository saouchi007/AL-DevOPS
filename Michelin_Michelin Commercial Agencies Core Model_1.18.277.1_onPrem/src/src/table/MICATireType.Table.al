table 80053 "MICA Tire Type"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Tire Type List";
    //DrillDownPageId = "MICA Tire Type List";
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