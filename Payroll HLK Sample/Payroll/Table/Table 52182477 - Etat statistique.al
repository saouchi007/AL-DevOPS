/// <summary>
/// Table Etat statistique (ID 51449).
/// </summary>
table 52182477 "Etat statistique"
//table 39108449 "Etat statistique"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Decision Header',
                FRA = 'Etat statistique';
    //DrillDownPageID = 39108469;
    // LookupPageID = 39108469;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            TableRelation = Employee;
        }
        field(2; Basis; Decimal)
        {
            CaptionML = ENU = 'Basis',
                        FRA = 'Base';
        }
        field(3; Number; Decimal)
        {
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre';
        }
        field(4; Rate; Decimal)
        {
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux';
        }
        field(5; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
            DecimalPlaces = 2 : 3;
        }
        field(6; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
        }
        field(7; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
        }
        field(8; structure; Text[100])
        {
            CalcFormula = Lookup(Employee."Structure Description" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Employee No.")
        {
        }
        key(Key2; "Last Name", "First Name")
        {
        }
    }

    fieldgroups
    {
    }
}

