/// <summary>
/// Table Training Institution Class (ID 51430).
/// </summary>
table 52182459 "Training Institution Class"
//table 39108430 "Training Institution Class"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Institution Class',
                FRA = 'Classe établissement de formation';
    //LookupPageID = 39108430;

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

