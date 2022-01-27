/// <summary>
/// Table Reminder Payroll Item (ID 52182546).
/// </summary>
table 52182546 "Reminder Payroll Item"
//table 39108635 "Reminder Payroll Item"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Reminder Payroll Item',
                FRA = 'Rubrique rappel';
    // DrillDownPageID = 39108493;
    // LookupPageID = 39108493;

    fields
    {
        field(1; "Reminder Code"; Code[20])
        {
            Caption = 'Code rappel';
            Editable = false;
            TableRelation = Payroll;
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            Editable = false;
            NotBlank = true;
            TableRelation = Employee;
        }
        field(3; "Item Code"; Text[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            Editable = false;
            NotBlank = true;
            TableRelation = "Payroll Item";
        }
        field(4; "Item Description"; Text[50])
        {
            CaptionML = ENU = 'Item Description',
                        FRA = 'Désignation rubrique';
            Editable = false;
        }
        field(5; Basis; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base';
            Editable = false;
        }
        field(6; Rate; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux';
            Editable = false;
        }
        field(7; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
            Editable = false;
        }
        field(8; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            Editable = false;
            OptionCaption = 'Libre saisie,Formule,Pourcentage,Au prorata';
            OptionMembers = "Libre saisie",Formule,Pourcentage,"Au prorata";
        }
        field(9; Number; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre';
            Editable = false;
        }
        field(10; "Submitted To Leave"; Boolean)
        {
            Caption = 'Soumis à congé';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Reminder Code", "Employee No.", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        ERROR(Text06);
    end;

    var
        PayrollItem: Record 52182481;
        EmployeePayrollItem: Record 52182482;
        EmployeePayrollItem2: Record 52182482;
        ParametresPaie: Record 52182483;
        Text01: Label 'Nature de la rubrique ne doit pas être "Calculée" !';
        Text02: Label '%1 ne doit pas dépasser %2 !';
        Text03: Label '%1 doit être positif !';
        Salarie: Record 5200;
        NbreJoursTravailles: Decimal;
        Text04: Label 'Suppression impossible de la rubrique %1';
        PayrollMgt: Codeunit 52182430;
        Text05: Label '%1 doit être négatif !';
        Text06: Label 'Suppression impossible des rubriques de rappel !';

    /// <summary>
    /// CalcItemAmount.
    /// </summary>
    procedure CalcItemAmount();
    begin
    end;
}

