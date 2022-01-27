/// <summary>
/// Table Payroll Book Totalisation (ID 52182547).
/// </summary>
table 52182547 "Payroll Book Totalisation"
//table 39108636 "Payroll Book Totalisation"
{
    // version HALRHPAIE.6.1.06

    Caption = 'Totalisation du journal de paie';

    fields
    {
        field(1; "Item Code"; Code[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Désignation';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Montant';
        }
    }

    keys
    {
        key(Key1; "Item Code")
        {
        }
    }

    fieldgroups
    {
    }
}

