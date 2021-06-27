table 80040 "MICA Brand"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Brand List";
    //DrillDownPageId = "MICA Brand List";
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