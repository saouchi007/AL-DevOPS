table 80027 "MICA Forecast Code2"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Forecast Code List";
    DrillDownPageId = "MICA Forecast Code List";
    fields
    {
        field(1; "Code"; Code[5])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(3; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }

        field(4; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }

        field(5; "Holding Customer"; Code[20])
        {
            Caption = 'Holding Customer';
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