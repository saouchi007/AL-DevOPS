/// <summary>
/// Table G/L Payroll Buffer (ID 52182486).
/// </summary>
table 52182486 "G/L Payroll Buffer"
//table 39108459 "G/L Payroll Buffer"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'G/L Payroll Buffer',
                FRA = 'Tampon comptabilité paie';

    fields
    {
        field(1; "Item Code"; Text[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            NotBlank = true;
            TableRelation = "Payroll Item";
        }
        field(2; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.',
                        FRA = 'N° compte';
            TableRelation = "G/L Account";
        }
        field(3; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Unité société';
            TableRelation = "Company Business Unit";
        }
        field(4; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Global Dimension 2 Filter',
                        FRA = 'N° salarié';
            TableRelation = Employee;
        }
        field(5; Nature; Option)
        {
            CaptionML = ENU = 'Nature',
                        FRA = 'Nature';
            OptionCaptionML = ENU = 'Debit,Credit',
                              FRA = 'Débit,Crédit';
            OptionMembers = Debit,Credit;
        }
        field(6; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,3,1';
            CaptionML = ENU = 'Global Dimension 1 Code',
                        FRA = 'Code axe principal 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,3,2';
            CaptionML = ENU = 'Global Dimension 2 Code',
                        FRA = 'Code axe principal 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
    }

    keys
    {
        key(Key1; "Item Code", "Employee No.", Nature)
        {
        }
        key(Key2; "Account No.", "Employee No.", Nature)
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
    }
}

