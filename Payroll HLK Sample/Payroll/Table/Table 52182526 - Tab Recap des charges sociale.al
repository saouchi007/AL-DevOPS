/// <summary>
/// Table Tab Recap des charges sociale (ID 52182526).
/// </summary>
table 52182526 "Tab Recap des charges sociale"
///table 39108610 "Tab Recap des charges sociale"
{
    // version HALRHPAIE.6.1.05


    fields
    {
        field(1; Rubrique; Code[20])
        {
        }
        field(2; "Désignation"; Text[50])
        {
        }
        field(3; Base; Decimal)
        {
            AutoFormatType = 2;
        }
        field(4; Taux; Decimal)
        {
        }
        field(5; Nombre; Integer)
        {
        }
        field(6; "Part ouvrière"; Decimal)
        {
        }
        field(7; "Charge patronale"; Decimal)
        {
        }
        field(8; "Numéro"; Integer)
        {
        }
        field(9; "Nbre salariés"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Numéro")
        {
        }
        key(Key2; Taux)
        {
        }
    }

    fieldgroups
    {
    }
}

