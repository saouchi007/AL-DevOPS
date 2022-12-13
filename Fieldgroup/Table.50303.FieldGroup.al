/// <summary>
/// Table ISA_FieldGroup (ID 50303).
/// </summary>
table 50303 ISA_FieldGroup
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; No; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; No, Description) { }
        fieldgroup(Brick; No, Description) { }
    }

}