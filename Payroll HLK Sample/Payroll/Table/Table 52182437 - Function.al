/// <summary>
/// Table Function (ID 52182437).
/// </summary>
table 52182437 "Function"
//table 39108408 "Function"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Function',
                FRA = 'Fonction';
    //DrillDownPageID = 39108411;
    //LookupPageID = 39108411;

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
}

