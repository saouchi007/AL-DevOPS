table 80055 "MICA Grading Type"
{
    DataClassification = CustomerContent;
    //LookupPageId = "MICA Grading Type List";
    //DrillDownPageId = "MICA Grading Type List";
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