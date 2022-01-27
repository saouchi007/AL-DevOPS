/// <summary>
/// Table tab recap des virements (ID 52182528).
/// </summary>
table 52182528 "tab recap des virements"
//table 39108612 "tab recap des virements"
{
    // version HALRHPAIE


    fields
    {
        field(1; modepaie; Code[10])
        {
        }
        field(2; "No agence"; Code[10])
        {
        }
        field(3; "Nom agence"; Text[50])
        {
        }
        field(4; montant; Decimal)
        {
            AutoFormatType = 2;
            DecimalPlaces = 1 : 2;
        }
        field(5; NomMode; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; modepaie, "No agence")
        {
        }
    }

    fieldgroups
    {
    }
}

