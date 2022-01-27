/// <summary>
/// Table Effectif récap. de paie (ID 52182555).
/// </summary>
table 52182555 "Effectif récap. de paie"
//table 39108646 "Effectif récap. de paie"
{
    // version HALRHPAIE.6.2.00

    Caption = 'Effectif récap. de paie';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'N° salarié';
        }
        field(2; "Item Code"; Text[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            NotBlank = true;
            TableRelation = "Payroll Item";
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }
}

