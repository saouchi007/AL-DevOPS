/// <summary>
/// Table Tab Etat de paiement (ID 51620).
/// </summary>
table 52182535 "Tab Etat de paiement"
//table 39108620 "Tab Etat de paiement"
{
    // version HALRHPAIE


    fields
    {
        field(1; matricule; Code[20])
        {
        }
        field(2; Nomprenom; Text[30])
        {
        }
        field(3; Montant; Decimal)
        {
            AutoFormatType = 2;
        }
    }

    keys
    {
        key(Key1; matricule)
        {
        }
    }

    fieldgroups
    {
    }
}

