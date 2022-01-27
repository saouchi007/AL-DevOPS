/// <summary>
/// Table Totalisation comptable de paie (ID 52182560).
/// </summary>
table 52182560 "Totalisation comptable de paie"
//table 39108651 "Totalisation comptable de paie"
{
    // version HALRHPAIE.6.2.00


    fields
    {
        field(1; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.',
                        FRA = 'N° compte';
            TableRelation = "G/L Account";
        }
        field(2; "Debit Total"; Decimal)
        {
            CalcFormula = Sum("G/L Payroll Buffer".Amount WHERE("Account No." = FIELD("Account No."),
                                                                 "Employee No." = FIELD("Employee Filter"),
                                                                 Nature = CONST(Debit),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code")));
            CaptionML = ENU = 'Amount',
                        FRA = 'Total débit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Credit Total"; Decimal)
        {
            CalcFormula = Sum("G/L Payroll Buffer".Amount WHERE("Account No." = FIELD("Account No."),
                                                                 "Employee No." = FIELD("Employee Filter"),
                                                                 Nature = CONST(Credit),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Code"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code")));
            Caption = 'Total crédit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Employee Filter"; Code[20])
        {
            Caption = 'Filtre salariés';
            FieldClass = FlowFilter;
        }
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,3,1';
            CaptionML = ENU = 'Global Dimension 1 Code',
                        FRA = 'Code axe principal 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(6; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,3,2';
            CaptionML = ENU = 'Global Dimension 2 Code',
                        FRA = 'Code axe principal 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
    }

    keys
    {
        key(Key1; "Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
    }
}

