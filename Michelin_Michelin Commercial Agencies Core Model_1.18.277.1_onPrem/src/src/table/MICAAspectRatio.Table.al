table 80051 "MICA Aspect Ratio"
{
    DataClassification = CustomerContent;
    //DrillDownPageId = "MICA Aspect Ratio List";
    //LookupPageId = "MICA Aspect Ratio List";
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