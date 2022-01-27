/// <summary>
/// Table Payroll Reminder Header (ID 52182505).
/// </summary>
table 52182505 "Payroll Reminder Header"
//table 39108478 "Payroll Reminder Header"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Reminder Header',
                FRA = 'Entête rappel de paie';
    //LookupPageID = 39108561;

    fields
    {
        field(1; "Reminder Lot No."; Code[20])
        {
            Caption = 'N° Lot de rappel';
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
        }
        field(3; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
        }
        field(4; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
        }
        field(5; Observation; Text[250])
        {
            Caption = 'Observation';
        }
        field(6; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Editable = true;
        }
    }

    keys
    {
        key(Key1; "Reminder Lot No.", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        LigneRappelPaie.RESET;
        LigneRappelPaie.SETRANGE("Reminder Lot No.", "Reminder Lot No.");
        LigneRappelPaie.SETRANGE("Employee No.", "Employee No.");
        LigneRappelPaie.DELETEALL;
        RappelSituation.RESET;
        RappelSituation.SETRANGE("Reminder Lot No.", "Reminder Lot No.");
        RappelSituation.SETRANGE("Employee No.", "Employee No.");
        RappelSituation.DELETEALL;
    end;

    var
        EnteteArchivePaie: Record 52182530;
        LigneArchivePaie: Record 52182531;
        LigneRappelPaie: Record 52182506;
        Salarie: Record 5200;
        ParamUtilisateur: Record 91;
        Direction: Record 52182429;
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        RappelSituation: Record 52182553;
}

