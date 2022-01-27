/// <summary>
/// Table Déclaration de cotisations (ID 52182556).
/// </summary>
table 52182556 "Déclaration de cotisations"
//table 39108647 "Déclaration de cotisations"
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; Assiette; Decimal)
        {
        }
        field(4; Taux; Decimal)
        {
        }
        field(5; Montant; Decimal)
        {
        }
        field(6; "Entrée"; Integer)
        {
        }
        field(7; Sortie; Integer)
        {
        }
        field(8; Effectif; Integer)
        {
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

