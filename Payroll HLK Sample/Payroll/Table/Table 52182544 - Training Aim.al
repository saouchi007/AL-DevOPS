/// <summary>
/// Table Training Aim (ID 52182544).
/// </summary>
table 52182544 "Training Aim"
//table 39108633 "Training Aim"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Aim',
                FRA = 'Objectif de formation';
    //LookupPageID = 39108560;

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            CaptionML = ENU = 'Name',
                        FRA = 'Nom';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; Name)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        VATRegNoFormat: Record 381;
    begin
    end;
}

