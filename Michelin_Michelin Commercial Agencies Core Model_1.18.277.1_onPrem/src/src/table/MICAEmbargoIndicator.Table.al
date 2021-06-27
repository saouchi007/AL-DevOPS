table 80050 "MICA Embargo Indicator"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Embargo Indicator List";
    //DrillDownPageId = "MICA Embargo Indicator List";
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