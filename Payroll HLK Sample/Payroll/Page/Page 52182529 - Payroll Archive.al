/// <summary>
/// Page Payroll Archive (ID 52182529).
/// </summary>
page 52182529 "Payroll Archive"
{
    // version HALRHPAIE.6.1.07

    CaptionML = ENU = 'Payroll Archive',
                FRA = 'Archive paie';
    Editable = false;
    PageType = Card;
    SourceTable = "Payroll Archive Header";

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                Editable = true;
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("First Name"; "First Name")
                {
                    Editable = false;
                }
                field("Last Name"; "Last Name")
                {
                    Editable = false;
                }
                field("Middle Name"; "Middle Name")
                {
                    Editable = false;
                }
                field("Section Grid Class"; "Section Grid Class")
                {
                    Editable = false;
                }
                field("Section Grid Section"; "Section Grid Section")
                {
                    Caption = 'Section / Echelon';
                    Editable = false;
                }
                field("Section Grid Level"; "Section Grid Level")
                {
                    Editable = false;
                }
                field("Payroll Template No."; "Payroll Template No.")
                {

                    trigger OnValidate();
                    begin
                        PayrollTemplateNoOnAfterValida;
                    end;
                }
                field(Observation; Observation)
                {
                }
                field("Payroll Code"; "Payroll Code")
                {
                }
                field("Total Absences Days"; "Total Absences Days")
                {
                }
                field("Total Absences Hours"; "Total Absences Hours")
                {
                }
                field("Total Advance"; "Total Advance")
                {
                }
                field("Total Overtime (Base)"; "Total Overtime (Base)")
                {
                }
                field("Total Medical Refund"; "Total Medical Refund")
                {
                }
                field("Total Family Allowance Contr."; "Total Family Allowance Contr.")
                {
                }
                field("Total Union Contr."; "Total Union Contr.")
                {
                }
            }
            part("Sous-formulaire archive paie"; 52182530)
            {
                SubPageLink = "Employee No." = FIELD("No."),
                              "Payroll Code" = FIELD("Payroll Code");
            }
            group(Administration)
            {
                Caption = 'Administration';
                Editable = true;
                field("Function Description"; "Function Description")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Leave Indemnity Amount"; "Leave Indemnity Amount")
                {
                }
                field("Leave Indemnity No."; "Leave Indemnity No.")
                {
                }
                group("Section grid : ")
                {
                    CaptionML = ENU = 'Section grid : ',
                                FRA = 'Grille par sections : ';
                    field(ClassSections; "Section Grid Class")
                    {
                        Editable = false;
                    }
                    field(SectionSections; "Section Grid Section")
                    {
                        Editable = false;
                    }
                    field(LevelSections; "Section Grid Level")
                    {
                        Editable = false;
                    }
                }
                group("Hourly Index Grid")
                {
                    CaptionML = ENU = 'Hourly Index Grid',
                                FRA = 'Grille par indices horaires : ';
                    field("Hourly Index Grid Function No."; "Hourly Index Grid Function No.")
                    {
                        Editable = false;
                    }
                    field("Hourly Index Grid Function"; "Hourly Index Grid Function")
                    {
                        Editable = false;
                    }
                    field("Hourly Index Grid CH"; "Hourly Index Grid CH")
                    {
                        Editable = false;
                    }
                    field("Hourly Index Grid Index"; "Hourly Index Grid Index")
                    {
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                CaptionML = ENU = 'Print',
                            FRA = 'Imprimer';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    ArchivePaieEntete: Record "Payroll Archive Header";
                begin
                    ArchivePaieEntete.SETRANGE("Payroll Code", "Payroll Code");
                    ArchivePaieEntete.SETRANGE("No.", "No.");
                    REPORT.RUNMODAL(51412, TRUE, FALSE, ArchivePaieEntete);
                end;
            }
        }
    }



    var
        EmployeePayrollItem: Record "Employee Payroll Item";
        PayrollSetup: Record Payroll_Setup;
        Text01: Label 'Rubrique "retenue jours d''absences" déjà existante !';
        PayrollItem: Record "Payroll Item";
        Text02: Label 'Rubrique "salaire de base" manquante !';
        BaseSalary: Decimal;
        Text03: Label 'Rubrique "retenue avance sur salaire" déjà existante !';
        Text04: Label 'Aucune absence n''est enregistrée pour la période %1 !';
        Text05: Label 'Aucune avance sur salaire n''est enregistrée pour la période %1 !';
        Mois: Integer;
        Annee: Integer;
        DebutMois: Date;
        FinMois: Date;
        Text06: Label 'Souhaitez-vous appliquer le modèle de paie %1 ?';
        Text07: Label 'Les rubriques actuelles seront supprimées.';
        Payroll: Record Payroll;
        CompanyBusinessUnit: Record "Company Business Unit";
        User: Record 2000000120;
        Text08: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text09: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        PayrollManager: Record "Payroll Manager";
        PayrollMgt: Codeunit 52182430;
        CodePaie: Code[20];


    local procedure PayrollTemplateNoOnAfterValida();
    begin
        CurrPage.SAVERECORD;
        CurrPage.UPDATE(FALSE);
    end;
}

