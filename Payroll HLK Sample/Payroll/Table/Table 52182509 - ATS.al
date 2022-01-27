/// <summary>
/// Table ATS (ID 51483).
/// </summary>
table 52182509 ATS
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; Annee; Integer)
        {
        }
        field(2; Mois; Integer)
        {
        }
        field(3; Description; Text[50])
        {
        }
        field(4; Base; Decimal)
        {
        }
        field(5; Retenue; Decimal)
        {
        }
        field(6; Duree; Decimal)
        {
        }
        field(7; PaieCompl; Text[30])
        {
        }
        field(8; Motif; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; Annee, Mois, PaieCompl)
        {
        }
    }

    fieldgroups
    {
    }
}

