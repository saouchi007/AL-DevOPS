/// <summary>
/// Table Cause of Accident (ID 52182475).
/// </summary>
table 52182475 "Cause of Accident"
//table 39108447 "Cause of Accident"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Cause of Accident',
                FRA = 'Motif d''accident';
    //DrillDownPageID = 39108466;
    //LookupPageID = 39108466;

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



