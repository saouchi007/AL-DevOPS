/// <summary>
/// Table Diploma Domain (ID 52182425).
/// </summary>
table 52182425 "Diploma Domain"
//table 39108396 "Diploma Domain"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Diploma Domain',
                FRA = 'Domaine du diplôme';
    //LookupPageID = 39108396;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
        }
        field(2; Description; Text[50])
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

