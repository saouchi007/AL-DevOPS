/// <summary>
/// Page Reminder Registers (ID 52182532).
/// </summary>
page 52182532 "Reminder Registers"
{
    // version HALRHPAIE.6.2.00

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Avril 2010
    // 01 : Cloisonnement par direction

    CaptionML = ENU = 'Payroll Registers',
                FRA = 'Hist. transactions paies';
    Editable = false;
    PageType = Card;
    SourceTable = "Reminder Register";

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
                field("Employee No."; "Employee No.")
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
                field("Creation Date"; "Creation Date")
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
                                FRA = '&Ecritures de rappel';
                    Image = PayrollStatistics;
                    RunObject = Codeunit 52182429;
                    ShortCutKey = 'Ctrl+F7';
                }
                action("&GL Entries")
                {
                    CaptionML = ENU = '&GL Entries',
                                FRA = '&Ecritures comptables';
                    Image = GLAccountBalance;
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
                    Image = Cancel;

                    trigger OnAction();
                    begin
                        GestionRappel.SupprimerRappel("Payroll Code", "Employee No.");
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
        GestionRappel: Codeunit 52182433;
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        Text02: Label 'Utilisateur %1 non configuré !';

}

