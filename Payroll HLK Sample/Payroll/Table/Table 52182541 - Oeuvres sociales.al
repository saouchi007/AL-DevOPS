/// <summary>
/// Table Oeuvres sociales (ID 52182541).
/// </summary>
table 52182541 "Oeuvres sociales"
//table 39108626 "Oeuvres sociales"
{
    // version HALRHPAIE


    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'N° ligne';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Désignation';
        }
        field(3; "Basis Amount"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Montant base';
        }
        field(4; Rate; Decimal)
        {
            Caption = 'Taux';
        }
        field(5; Amount; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Montant';
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

