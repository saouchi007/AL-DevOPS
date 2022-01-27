/// <summary>
/// Table DAS Entete (ID 52182514).
/// </summary>
table 52182514 "DAS Entete"
//table 39108500 "DAS Entete"
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            CaptionML = ENU = 'Primary Key',
                        FRA = 'Clé primaire';
        }
        field(2; "Trimestre 1"; Decimal)
        {
            CalcFormula = Sum(DAS."Montant 1");
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Trimestre 2"; Decimal)
        {
            CalcFormula = Sum(DAS."Montant 2");
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Trimestre 3"; Decimal)
        {
            CalcFormula = Sum(DAS."Montant 3");
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Trimestre 4"; Decimal)
        {
            CalcFormula = Sum(DAS."Montant 4");
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Total annuel"; Decimal)
        {
            CalcFormula = Sum(DAS."Montant annuel");
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Nbre Salariés"; Integer)
        {
            CalcFormula = Count(DAS);
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Année"; Integer)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

