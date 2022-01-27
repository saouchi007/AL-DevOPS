/// <summary>
/// Table Payroll Archive Line (ID 52182531).
/// </summary>
table 52182531 "Payroll Archive Line"
//table 39108616 "Payroll Archive Line"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Archive Line',
                FRA = 'Ligne archive de paie';
    // DrillDownPageID = 39108498;
    // LookupPageID = 39108522;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
        }
        field(2; "Item Code"; Text[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            NotBlank = true;
        }
        field(3; "Item Description"; Text[50])
        {
            CaptionML = ENU = 'Item Description',
                        FRA = 'Désignation rubrique';
        }
        field(4; Basis; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base';
        }
        field(5; Rate; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux';
        }
        field(6; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
            DecimalPlaces = 3 : 3;
            Editable = true;
        }
        field(7; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            Editable = false;
            OptionCaption = 'Libre saisie,Formule,Pourcentage,Au prorata,Au prorata autorisé';
            OptionMembers = "Libre saisie",Formule,Pourcentage,"Au prorata","Au prorata autorisé";
        }
        field(8; Number; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre';
        }
        field(9; "Payroll Code"; Code[20])
        {
            Caption = 'Code paie';
            TableRelation = Payroll;
        }
        field(10; Category; Option)
        {
            CaptionML = ENU = 'Category',
                        FRA = 'Catégorie';
            OptionCaptionML = ENU = 'Employee,Employer',
                              FRA = 'Salarié,Employeur';
            OptionMembers = Employee,Employer;
        }
        field(11; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
        }
        field(12; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Payroll Code", "Item Code")
        {
            SumIndexFields = Amount, Number;
        }
        key(Key2; "Last Name", "First Name")
        {
        }
        key(Key3; "Payroll Code", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PayrollItem: Record 52182481;
        EmployeePayrollItem: Record 52182482;
        EmployeePayrollItem2: Record 52182482;
        ParametresPaie: Record 52182483;
        Text01: Label 'Nature de la rubrique doit être "Calculée" !';
        Text02: Label 'Nombre ne doit pas dépasser %1 !';
        Text03: Label 'Nombre doit être positif !';
        Employee: Record 5200;
        NbreJoursTravailles: Decimal;
        Text04: Label 'Suppression impossible de la rubrique %1';
        PayrollMgt: Codeunit 52182430;
        Text05: Label 'Suppression impossible de %1';

    procedure CalcItemAmount();
    begin
    end;

    procedure CalcAmountFromTreatmentGrid(EmployeeNumber: Code[20]; ItemCode: Option);
    var
        MinimalIndex: Integer;
        Index: Integer;
        TotalIndex: Integer;
        Employee: Record 5200;
        TreatmentIndexGrid: Record 52182489;
    begin
    end;
}

