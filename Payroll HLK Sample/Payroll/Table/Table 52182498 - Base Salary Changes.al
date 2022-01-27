/// <summary>
/// Table Base Salary Changes (ID 51471).
/// </summary>
table 52182498 "Base Salary Changes"
//table 39108471 "Base Salary Changes"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Base Salary Changes',
                FRA = 'Changements de salaire de base';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° salarié';
            TableRelation = Employee;
        }
        field(2; "Old Base Salary"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Old Base Salary',
                        FRA = 'Ancien salaire de base';
        }
        field(3; "New Base Salary"; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'New Base Salary',
                        FRA = 'Nouveau salaire de base';
        }
        field(4; "Employee First Name"; Text[30])
        {
            CaptionML = ENU = 'Employee First Name',
                        FRA = 'Prénom salarié';
        }
        field(5; "Employee Last Name"; Text[30])
        {
            CaptionML = ENU = 'Employee Last Name',
                        FRA = 'Nom salarié';
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

