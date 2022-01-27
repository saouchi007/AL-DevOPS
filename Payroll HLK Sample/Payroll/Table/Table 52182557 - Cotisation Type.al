/// <summary>
/// Table Cotisation Type (ID 52182557).
/// </summary>
table 52182557 "Cotisation Type"
//table 39108648 "Cotisation Type"
{
    // version HALRHPAIE.6.2.00

    Caption = 'Type de cotisation';
    //LookupPageID = 39108581;

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
            CaptionML = ENU = 'Name',
                        FRA = 'Désignation';
        }
        field(3; Rate; Decimal)
        {
            Caption = 'Taux';
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

