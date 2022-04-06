/// <summary>
/// Table ISA_Boat (ID 50192).
/// </summary>
table 50192 ISA_Boat
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No. "; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'No. ';

        }
        field(2; "Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(3; Speed; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Speed Km/H';
        }
    }

    keys
    {
        key(PK; "No. ", Name)
        {
            Clustered = true;
        }
    }



}