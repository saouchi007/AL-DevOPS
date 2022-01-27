/// <summary>
/// Table Employee Cotisation (ID 52182558).
/// </summary>
table 52182558 "Employee Cotisation"
//table 39108649 "Employee Cotisation"
{

    Caption = 'Cotisation salarié';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "Cotisation Type"; Code[10])
        {
            Caption = 'Type de cotisation';
            TableRelation = "Cotisation Type";
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Cotisation Type")
        {
        }
    }

    fieldgroups
    {
    }
}

