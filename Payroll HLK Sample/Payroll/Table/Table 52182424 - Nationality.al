//table 39108395 Nationality
/// <summary>
/// Table Nationality (ID 52182424).
/// </summary>
table 52182424 Nationality
{

    CaptionML = ENU = 'Nationality',
                FRA = 'Nationalité';
    //DrillDownPageID = 51395;
    //LookupPageID = 51395;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; "Code nationalité cacobatph"; Text[3])
        {
            Caption = 'Code nationalité cacobatph';
            Description = 'Code numérique des nationalitées CACOBATPH';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var

        PostCode: Record 225;
}

