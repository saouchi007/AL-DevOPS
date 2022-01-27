/// <summary>
/// Page Payroll Registers (ID 51496).
/// </summary>
page 52182528 "Payroll Registers"
{
    // version HALRHPAIE.6.1.07

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Avril 2010
    // 01 : Cloisonnement par direction

    CaptionML = ENU = 'Payroll Registers',
                FRA = 'Hist. transactions paies';
    Editable = false;
    PageType = List;
    SourceTable = "Payroll Register";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No."; "No.")
                {
                }
                field("Payroll Code"; "Payroll Code")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("From Entry No."; "From Entry No.")
                {
                }
                field("To Entry No."; "To Entry No.")
                {
                }
                field("No. of employees"; "No. of employees")
                {
                }
                field("No. of Entries"; "No. of Entries")
                {
                }
                field(Recorded; Recorded)
                {
                }
                field("Recording Date"; "Recording Date")
                {
                }
                field("Recorded By"; "Recorded By")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Log")
            {
                CaptionML = ENU = '&Log',
                            FRA = '&Journal';
                Image = Log;
                action("&Payroll Entries")
                {
                    CaptionML = ENU = '&Payroll Entries',
                                FRA = '&Ecritures de paie';
                    Image = PayrollStatistics;
                    RunObject = Codeunit 52182429;
                    ShortCutKey = 'Ctrl+F7';
                }
                action("&GL Entries")
                {
                    CaptionML = ENU = '&GL Entries',
                                FRA = '&Ecritures comptables';
                    Image = GLJournal;
                    RunObject = Page 20;
                    RunPageLink = "Document No." = FIELD("Payroll Code");
                }
            }
        }
        area(processing)
        {
            group("&Functions")
            {
                CaptionML = ENU = '&Functions',
                            FRA = '&Fonctions';
                Image = Job;
                action("&Cancel Last Salary Calculation")
                {
                    CaptionML = ENU = '&Cancel Last Salary Calculation',
                                FRA = '&Annuler la paie';
                    Image = CancelLine;

                    trigger OnAction();
                    begin
                        GestionPaie.SupprimerPaie("Payroll Code");
                    end;
                }

                action("Correction et actualisation des congés")
                {
                    Caption = 'Correction et actualisation des congés';
                    Image = EditAdjustments;

                    trigger OnAction();
                    begin
                        REPORT.RUNMODAL(51494, FALSE);
                    end;
                }

            }
        }
    }

    trigger OnOpenPage();
    begin

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text02);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Company Business Unit Code", ParamUtilisateur."Company Business Unit");
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        GestionPaie: Codeunit 52182430;
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        M: Integer;
        RubriquePaie: Record "Payroll Item";
        RubriqueSalarie: Record "Employee Payroll Item";
        GestionnairePaie: Record "Payroll Manager";
        Paie2: Record Payroll;
        CodePaie: Code[20];
        StructureCode: Code[10];
        NbreSalaries: Integer;
        UniteSociete: Record "Company Business Unit";
        BoiteDialogue: Dialog;
        Text01: Label 'Code de la paie manquant !';
        Text02: Label 'Calculer la paie ?';
        Text03: Label 'Calcul de la paie %1 effectué avec succès.\Génération pour %2 salariés.';
        Text06: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text04: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text07: Label 'Aucun salarié n''est affecté à la direction %1 !';
        Text05: Label 'L''utilisateur %1 n''est pas autorisé à calculer la paie %2 !';
        Text08: Label 'Code de direction manquant pour la paie %1 !';
        Text09: Label '%1 %2 est clôturé(e) !';
        Salarie: Record 5200;

}

