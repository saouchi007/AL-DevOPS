/// <summary>
/// Table Bilan de formation data (ID 52182512).
/// </summary>
table 52182512 "Bilan de formation data"
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; Matricule; Code[20])
        {
            Caption = 'Matricule';
        }
        field(2; Categorie; Code[20])
        {
            Caption = 'Categorie';
        }
        field(3; Nom; Text[30])
        {
            Caption = 'Nom';
        }
        field(4; "Durée 1"; Decimal)
        {
        }
        field(5; "Montant 1"; Decimal)
        {
        }
        field(6; "Prénom"; Text[30])
        {
        }
        field(7; "Durée 2"; Decimal)
        {
        }
        field(8; "Montant 2"; Decimal)
        {
        }
        field(10; "Durée 3"; Decimal)
        {
        }
        field(11; "Montant 3"; Decimal)
        {
        }
        field(13; "Durée 4"; Decimal)
        {
        }
        field(14; "Montant 4"; Decimal)
        {
        }
        field(39; "Date de naissance"; Text[30])
        {
        }
        field(40; "Montant annuel"; Decimal)
        {
        }
        field(41; "Date d'entrée"; Date)
        {
        }
        field(42; "Date de sortie"; Date)
        {
        }
    }

    keys
    {
        key(Key1; Matricule)
        {
            SumIndexFields = "Montant 1", "Montant 2", "Montant 3", "Montant 4", "Montant annuel";
        }
    }

    fieldgroups
    {
    }
}

