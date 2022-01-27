/// <summary>
/// Table Payroll Constatation Warning (ID 52182501).
/// </summary>
table 52182501 "Payroll Constatation Warning"
//table 39108474 "Payroll Constatation Warning"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Constatation Warning',
                FRA = 'Avertissement constatation paie';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° salarié';
            Editable = false;
            TableRelation = Employee;
        }
        field(2; "Field"; Text[100])
        {
            CaptionML = ENU = 'Warning',
                        FRA = 'Champ manquant';
            Editable = false;
        }
        field(3; Name; Text[30])
        {
            Caption = 'Nom';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Field")
        {
        }
    }

    fieldgroups
    {
    }
}

