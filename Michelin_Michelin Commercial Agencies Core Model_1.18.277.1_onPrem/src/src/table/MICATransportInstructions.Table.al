table 80141 "MICA Transport Instructions"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Transport Instr. List";
    DrillDownPageId = "MICA Transport Instr. List";
    fields
    {
        field(10; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(20; Description; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
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