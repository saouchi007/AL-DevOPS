/// <summary>
/// Table Sanction (ID 52182444).
/// </summary>
table 52182444 Sanction
//table 39108415 Sanction
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Sanction',
                FRA = 'Sanction';
    //DrillDownPageID = 39108432;
    //LookupPageID = 39108432;

    fields
    {
        field(1; "Code"; Code[20])
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

