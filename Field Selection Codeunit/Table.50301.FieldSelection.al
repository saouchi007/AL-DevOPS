/// <summary>
/// Table ISA_FieldSelection (ID 50301).
/// </summary>
table 50301 ISA_FieldSelection
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; TableNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Table No';

        }
        field(2; TableName; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Table Name';
        }
        field(3; FieldNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Field No';
        }
        field(4; FieldName; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Field Name';
        }
    }

    keys
    {
        key(PK; TableNo, FieldNo)
        {
            Clustered = true;
        }
    }

}