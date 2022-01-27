/// <summary>
/// Table Terms of pay (ID 52182532).
/// </summary>
table 52182532 "Terms of pay"
//table 39108617 "Terms of pay"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Duty',
                FRA = 'Clause de rémunération';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(3; Description; Text[80])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(4; "Item Code"; Code[10])
        {
        }
        field(5; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine();
    var
        DutyLine: Record 52182435;
    begin
    end;
}

