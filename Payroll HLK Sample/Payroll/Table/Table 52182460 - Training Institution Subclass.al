/// <summary>
/// Table Training Institution Subclass (ID 52182460).
/// </summary>
table 52182460 "Training Institution Subclass"
//table 39108431 "Training Institution Subclass"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Institution Subclass',
                FRA = 'Sous-classe établissement de formation';
    // DrillDownPageID = 39108431;
    //LookupPageID = 39108431;

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

    var
        InstitutionClass: Record 52182459;
}

