/// <summary>
/// Table Consumers (ID 50144).
/// </summary>
table 50144 Consumers
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[50])
        {
            DataClassification = CustomerContent;
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