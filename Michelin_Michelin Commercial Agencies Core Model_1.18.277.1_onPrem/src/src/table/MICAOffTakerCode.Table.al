table 80880 "MICA OffTaker Code"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA OffTaker List";
    DrillDownPageId = "MICA OffTaker List";
    fields
    {
        field(1; "Code"; Code[3])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; text[50])
        {
            caption = 'Description';
            dataClassification = CustomerContent;
        }
        field(3; "Starting Date"; date)
        {
            caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(4; "Ending Date"; date)
        {
            caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}