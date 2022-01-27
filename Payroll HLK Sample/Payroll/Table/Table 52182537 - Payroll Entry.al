/// <summary>
/// Table Payroll Entry (ID 52182537).
/// </summary>
table 52182537 "Payroll Entry"
//table 39108622 "Payroll Entry"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Entry',
                FRA = 'Ecriture paie';
    // DrillDownPageID = 39108495;
    // LookupPageID = 39108495;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
        }
        field(2; "Document No."; Code[158])
        {
            CaptionML = ENU = 'Document No.',
                        FRA = 'N° document';
            TableRelation = Payroll;
        }
        field(3; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date',
                        FRA = 'Date document';
        }
        field(4; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            TableRelation = Employee;
        }
        field(5; "Item Code"; Code[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
        }
        field(6; "Item Description"; Text[50])
        {
            CaptionML = ENU = 'Item Description',
                        FRA = 'Désignation rubrique';
            Editable = true;
        }
        field(7; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
            DecimalPlaces = 2 : 3;
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,3,1';
            CaptionML = ENU = 'Global Dimension 1 Code',
                        FRA = 'Code axe principal 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,3,2';
            CaptionML = ENU = 'Global Dimension 2 Code',
                        FRA = 'Code axe principal 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(10; "User ID"; Code[40])
        {
            CaptionML = ENU = 'User ID',
                        FRA = 'Code utilisateur';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            var
                LoginMgt: Record 52182503;///*** 
                //LoginMgt : Codeunit 418;
            begin
                LoginMgt.LookupUserID("User ID");
            end;

        }
        field(11; Basis; Decimal)
        {
            CaptionML = ENU = 'Basis',
                        FRA = 'Base';
            DecimalPlaces = 2 : 2;
        }
        field(12; Rate; Decimal)
        {
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux';
        }
        field(13; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            OptionCaption = 'Libre saisie,Formule,Pourcentage,Au prorata,Au prorata autorisé';
            OptionMembers = "Libre saisie",Formule,Pourcentage,"Au prorata","Au prorata autorisé";
        }
        field(14; Number; Decimal)
        {
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre';
        }
        field(15; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            TableRelation = "Company Business Unit";
        }
        field(16; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.',
                        FRA = 'N° compte';
            TableRelation = "G/L Account";
        }
        field(17; "Bal. Account No."; Code[20])
        {
            CaptionML = ENU = 'Bal. Account No.',
                        FRA = 'N° compte contrepartie';
            TableRelation = "G/L Account";
        }
        field(18; "Union/Insurance Code"; Code[10])
        {
            CaptionML = ENU = 'Union/Insurance Code',
                        FRA = 'Code mutuelle/assurance';
            TableRelation = Union;
        }
        field(19; Category; Option)
        {
            CaptionML = ENU = 'Category',
                        FRA = 'Catégorie';
            OptionCaptionML = ENU = 'Employee,Employer',
                              FRA = 'Salarié,Employeur';
            OptionMembers = Employee,Employer;
        }
        field(50000; "Dimension Set ID"; Integer)
        {
        }
        field(50001; "Lending Code"; Code[30])
        {
            Caption = 'Code Prêt';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Document No.", "Employee No.", "Item Code")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Document No.", "Item Code", "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
            SumIndexFields = Amount;
        }
        key(Key4; "Document No.", "Item Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Document Date")
        {
            SumIndexFields = Amount;
        }
        key(Key5; "Employee No.", "Document No.")
        {
        }
        key(Key6; "Employee No.", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }
}

