/// <summary>
/// Table Leave Right By Years (ID 51637).
/// </summary>
table 52182548 "Leave Right By Years"
///table 39108637 "Leave Right By Years"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Leave Entry',
                FRA = 'Indemnité de congé (par exercices)';
    // DrillDownPageID = 39108569;
    // LookupPageID = 39108569;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "Leave Period Code"; Code[10])
        {
            Caption = 'Code période de congé';
            TableRelation = "Leave Period";
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Indemnité de congé';
        }
        field(4; Days; Decimal)
        {
            Caption = 'Droit à congé';
        }
        field(5; "Consumed Amount"; Decimal)
        {
            Caption = 'Indemnité consommée';
            Editable = true;
        }
        field(6; "Consumed Days"; Decimal)
        {
            Caption = 'Droit consommé';
            Editable = false;
        }
        field(7; "Remaining Amount"; Decimal)
        {
            Caption = 'Indemnité restante';
        }
        field(8; "Remaining Days"; Decimal)
        {
            Caption = 'Droit restant';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Leave Period Code")
        {
            SumIndexFields = "Remaining Amount", "Remaining Days", "Consumed Amount", "Consumed Days";
        }
    }

    fieldgroups
    {
    }
}

