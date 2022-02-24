/// <summary>
/// Table PowerAutomateSetup (ID 50154).
/// </summary>
table 50154 PowerAutomateSetup
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key';
        }
        field(2; SetupField; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Setup Field';
        }
    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

    var

}