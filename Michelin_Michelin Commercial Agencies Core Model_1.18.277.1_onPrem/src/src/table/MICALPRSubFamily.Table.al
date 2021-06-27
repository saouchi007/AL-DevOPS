table 80046 "MICA LPR Sub Family"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA LPR Sub Family List";
    //DrillDownPageId = "MICA LPR Sub Family List";
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