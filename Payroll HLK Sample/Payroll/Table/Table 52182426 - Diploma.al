/// <summary>
/// Table Diploma (ID 52182426).
/// </summary>
table 52182426 Diploma
//table 39108397 Diploma
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Diploma',
                FRA = 'Diplôme';
    //DrillDownPageID = 39108397;
    //LookupPageID = 39108397;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; Level; Option)
        {
            CaptionML = ENU = 'Level',
                        FRA = 'Niveau';
            OptionCaptionML = ENU = 'Primary,Secondary,University,Post-University',
                              FRA = 'Primaire,Secondaire,Universitaire,Post-Universitaire';
            OptionMembers = Primary,Secondary,University,"Post-University";
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

