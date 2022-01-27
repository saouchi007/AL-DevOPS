/// <summary>
/// Table Payroll Reminder Line (ID 52182506).
/// </summary>
table 52182506 "Payroll Reminder Line"
//table 39108479 "Payroll Reminder Line"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Line Archive',
                FRA = 'Ligne rappel de paie';

    fields
    {
        field(1; "Reminder Lot No."; Code[20])
        {
            Caption = 'N° Lot de rappel';
            TableRelation = "Payroll Reminder Lot";
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(3; "Item Code"; Text[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            NotBlank = true;
        }
        field(4; "Item Description"; Text[50])
        {
            CaptionML = ENU = 'Item Description',
                        FRA = 'Désignation rubrique';
        }
        field(5; Number; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Nbre';
        }
        field(6; Basis; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Base';
        }
        field(7; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
        }
    }

    keys
    {
        key(Key1; "Reminder Lot No.", "Employee No.", "Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Rubrique: Record 52182481;
        ParamPaie: Record 52182483;
        Text01: Label 'Nature de la rubrique doit être "Calculée" !';
        Text02: Label '%1 ne doit pas dépasser %2 !';
        Text03: Label '%1 doit être positif !';
        Employee: Record 5200;
        NbreJoursTravailles: Decimal;
        Text04: Label 'Suppression impossible de la rubrique %1';
        GestionRappel: Codeunit 52182433;
        LigneRappel: Record 52182506;
        LigneRappel2: Record 52182506;
        Montant: Decimal;
        LigneArchive: Record 52182531;
        Text05: Label 'Rubrique [%1] manquante !';
}

