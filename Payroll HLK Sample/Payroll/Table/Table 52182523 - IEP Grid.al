/// <summary>
/// Table IEP Grid (ID 51606).
/// </summary>
table 52182523 "IEP Grid"
//table 39108606 "IEP Grid"
{
    // version HALRHPAIE.6.1.01

    Caption = 'Barème IEP';

    fields
    {
        field(1; "Starting period"; Integer)
        {
            Caption = 'Début période';
        }
        field(2; "Ending Period"; Integer)
        {
            Caption = 'Fin période';
        }
        field(3; Rate; Decimal)
        {
            Caption = 'Taux';
        }
    }

    keys
    {
        key(Key1; "Starting period", "Ending Period")
        {
        }
    }

    fieldgroups
    {
    }
}

