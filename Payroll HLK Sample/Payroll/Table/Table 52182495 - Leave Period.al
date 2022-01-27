/// <summary>
/// Table Leave Period (ID 52182495).
/// </summary>
table 52182495 "Leave Period"
//table 39108468 "Leave Period"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Leave Period',
                FRA = 'Période de congé';
    //DrillDownPageID = 39108516;
    //LookupPageID = 39108517;

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
        field(3; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date de début';
        }
        field(4; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date de fin';
        }
        field(5; Closed; Boolean)
        {
            CaptionML = ENU = 'Closed',
                        FRA = 'Clôturée';
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

