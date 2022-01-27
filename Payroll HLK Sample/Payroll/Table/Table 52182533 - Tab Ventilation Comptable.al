/// <summary>
/// Table Tab Ventilation Comptable (ID 52182533).
/// </summary>
table 52182533 "Tab Ventilation Comptable"
//table 39108618 "Tab Ventilation Comptable"
{
    // version HALRHPAIE.6.1.01


    fields
    {
        field(1; "No Rub"; Text[20])
        {
        }
        field(2; Nombre; Integer)
        {
        }
        field(3; versement; Decimal)
        {
        }
        field(4; retenue; Decimal)
        {
        }
        field(5; description; Text[50])
        {
        }
        field(6; compte; Code[20])
        {
        }
        field(7; base; Decimal)
        {
        }
        field(8; No; Integer)
        {
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
        key(Key2; "No Rub")
        {
        }
    }

    fieldgroups
    {
    }
}

