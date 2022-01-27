/// <summary>
/// Table Salarie masse salariale (ID 52182511).
/// </summary>
table 52182511 "Salarie masse salariale"
{
    // version HALRHPAIE.6.1.05


    fields
    {
        field(1; Salarie; Code[20])
        {
        }
        field(2; Structure; Code[20])
        {
        }
        field(3; Categorie; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; Salarie, Structure, Categorie)
        {
        }
    }

    fieldgroups
    {
    }
}

