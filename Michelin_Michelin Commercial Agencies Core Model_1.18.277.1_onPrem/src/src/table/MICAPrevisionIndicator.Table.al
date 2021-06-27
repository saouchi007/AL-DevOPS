table 80049 "MICA Prevision Indicator"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Prevision Indicator List";
    //DrillDownPageId = "MICA Prevision Indicator List";
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