/// <summary>
/// Table Payroll Type (ID 52182540).
/// </summary>
table 52182540 "Payroll Type"
//table 39108625 "Payroll Type"
{
    // version HALRHPAIE.6.1.01

    Caption = 'Type de paie';
    // DrillDownPageID = 39108547;
    // LookupPageID = 39108547;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Désignation';
        }
        field(3; "SS Deduction"; Boolean)
        {
            Caption = 'Retenue SS';
        }
        field(4; "IRG %"; Decimal)
        {
            Caption = '% IRG';
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

