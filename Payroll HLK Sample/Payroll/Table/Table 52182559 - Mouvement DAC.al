/// <summary>
/// Table Mouvement DAC (ID 52182559).
/// </summary>
table 52182559 "Mouvement DAC"
//table 39108650 "Mouvement DAC"
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; Entree; Boolean)
        {
        }
        field(3; Sortie; Boolean)
        {
        }
        field(4; "Cotisation Type"; Code[10])
        {
            Caption = 'Type de cotisation';
            //TableRelation = Table39108638;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Cotisation Type")
        {
        }
    }

    fieldgroups
    {
    }
}

