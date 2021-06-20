table 50200 Book
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
        }
        field(2; "Title"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Title';

        }
        field(3; "Author"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Author';

        }
        field(4; "Hardcover"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Hardcover';
        }
        field(5; "Page Count"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Page count';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}