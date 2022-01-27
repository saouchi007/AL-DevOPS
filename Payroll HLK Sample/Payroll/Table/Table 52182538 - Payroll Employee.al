/// <summary>
/// Table Payroll Employee (ID 52182538).
/// </summary>
table 52182538 "Payroll Employee"
//table 39108623 "Payroll Employee"
{

    Caption = 'Salariés de la paie';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'N° salarié';
        }
    }

    keys
    {
        key(Key1; "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }
}

