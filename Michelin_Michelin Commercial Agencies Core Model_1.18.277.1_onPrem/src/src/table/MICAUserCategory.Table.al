table 81180 "MICA User Category"
{
    DataClassification = CustomerContent;
    Caption = 'User Category';
    LookupPageId = "MICA User Categories";
    DrillDownPageId = "MICA User Categories";
    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(2; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description) { }
    }
}