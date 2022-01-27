/// <summary>
/// Table Tab Releve des emoluments (ID 52182527).
/// </summary>
table 52182527 "Tab Releve des emoluments"
{
    // version HALRHPAIE


    fields
    {
        field(1; No; Integer)
        {
        }
        field(2; Mois; Text[30])
        {
        }
        field(3; base; Decimal)
        {
            AutoFormatType = 2;
        }
        field(4; retenue; Decimal)
        {
            AutoFormatType = 2;
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }
}

