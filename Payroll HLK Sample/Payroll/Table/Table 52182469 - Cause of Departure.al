/// <summary>
/// Table Cause of Departure (ID 52182469).
/// </summary>
table 52182469 "Cause of Departure"
//table 39108440 "Cause of Departure"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Cause of Departure',
                FRA = 'Motif de départ';
    DrillDownPageID = 5215;
    LookupPageID = 5215;

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

