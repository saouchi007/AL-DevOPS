/// <summary>
/// Table Lending Type (ID 52182518).
/// </summary>
table 52182518 "Lending Type"
//table 39108601 "Lending Type"
{
    // version HALRHPAIE.6.1.01

    Caption = 'Type de prêt';
    //LookupPageID = 39108551;

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
        field(3; "Lending Deduction (Capital)"; Code[10])
        {
            Caption = 'Code retenue prêt (capital)';
            TableRelation = "Payroll Item";
        }
        field(4; "Lending Deduction (Interest)"; Code[10])
        {
            Caption = 'Code retenue prêt (intérêt)';
            TableRelation = "Payroll Item";
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

    var
        Rubrique: Record 52182481;
}

