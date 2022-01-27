/// <summary>
/// Table Cause of Contract Termination (ID 52182507).
/// </summary>
table 52182507 "Cause of Contract Termination"
//table 39108480 "Cause of Contract Termination"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Cause of Contract Termination',
                FRA = 'Motif fin de contrat';
    //DrillDownPageID = 39108544;
    //LookupPageID = 39108544;

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

