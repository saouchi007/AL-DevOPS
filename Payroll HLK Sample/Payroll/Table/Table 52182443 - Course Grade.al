/// <summary>
/// Table Course Grade (ID 52182443).
/// </summary>
table 52182443 "Course Grade"
//table 39108414 "Course Grade"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Course Grade',
                FRA = 'Niveau d''étude';
    //LookupPageID = 39108421;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
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

