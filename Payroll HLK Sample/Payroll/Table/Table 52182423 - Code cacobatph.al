/// <summary>
/// Table Code cacobatph (ID 52182423).
/// </summary>
table 52182423 "Code cacobatph"
{
    // version RHPAIECacobatph

    //DrillDownPageID = 50001;
    //LookupPageID = 50001;

    fields
    {
        field(1; "Code cacobatph"; Code[4])
        {
            Caption = 'Code cacobatph';
        }
        field(2; City; Text[100])
        {
            Caption = 'Ville';
        }
    }

    keys
    {
        key(Key1; "Code cacobatph")
        {
        }
        key(Key2; City, "Code cacobatph")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code cacobatph", City)
        {
            Caption = 'Code cacobatph,ville';
        }
    }
}

