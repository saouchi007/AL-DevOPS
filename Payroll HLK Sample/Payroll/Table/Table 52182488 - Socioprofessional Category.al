/// <summary>
/// Table Socio-professional Category (ID 52182488).
/// </summary>
table 52182488 "Socio-professional Category"
//table 39108461 "Socio-professional Category"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Socio-professional Category',
                FRA = 'Catégorie socio-professionnelle';
    //DrillDownPageID = 39108523;
    //LookupPageID = 39108523;

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
}

