/// <summary>
/// Table ISA_Book (ID 50191).
/// </summary>
table 50191 ISA_BookTemporary
{
    DataClassification = CustomerContent;
    Caption = 'Books';
    TableType = Temporary;

    fields
    {
        field(1; "No. "; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'No .';

        }
        field(2; Title; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Title';
        }
        field(3; PageCount; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Page Count';
        }
    }

    keys
    {
        key(PK; "No. ")
        {
            Clustered = true;
        }
    }

}