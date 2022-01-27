/// <summary>
/// Table Cause of Training Cancellation (ID 52182473).
/// </summary>
table 52182473 "Cause of Training Cancellation"
//table 39108445 "Cause of Training Cancellation"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Cause of Training Cancellation',
                FRA = 'Motif d''annulation de formation';
    //DrillDownPageID = 39108462;
    //LookupPageID = 39108462;

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[80])
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
        Text01: Label 'Le nombre de jours de validité doit être positif !';
}

