/// <summary>
/// Table Employee Movement (ID 51422).
/// </summary>
table 52182451 "Employee Movement"
//table 39108422 "Employee Movement"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Movement',
                FRA = 'Mouvement salarié';
    //LookupPageID = 39108439;

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

