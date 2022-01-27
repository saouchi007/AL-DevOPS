/// <summary>
/// Table Leave Right (ID 52182496).
/// </summary>
table 52182496 "Leave Right"
//table 39108469 "Leave Right"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Leave Right',
                FRA = 'Droit au congé';
    //DrillDownPageID = 39108518;
    //LookupPageID = 39108518;

    fields
    {
        field(1; "Leave Period Code"; Code[10])
        {
            CaptionML = ENU = 'Leave Period Code',
                        FRA = 'Code période de congé';
            TableRelation = "Leave Period";
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            TableRelation = Employee;
        }
        field(3; "No. of Days"; Decimal)
        {
            CaptionML = ENU = 'Leave Right',
                        FRA = 'Droit de congé';
        }
        field(4; "Employment Date"; Date)
        {
            CaptionML = ENU = 'Employment Date',
                        FRA = 'Date d''entrée';
        }
        field(5; "Termination Date"; Date)
        {
            CaptionML = ENU = 'Termination Date',
                        FRA = 'Date fin de contrat';
        }
        field(6; "No. of Consumed Days"; Decimal)
        {
            CalcFormula = Sum("Employee Leave"."Quantity (Base)" WHERE("Leave Period" = FIELD("Leave Period Code"),
                                                                        "Employee No." = FIELD("Employee No.")));
            Caption = 'Nbre de jours consommés';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; Difference; Decimal)
        {
            CaptionML = ENU = 'Difference',
                        FRA = 'Différence';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Leave Period Code", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }
}

