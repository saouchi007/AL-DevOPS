/// <summary>
/// Page Sanction Registration (ID 52182458).
/// </summary>
Page 52182458 "Sanction Registration" //page saisie des sanction 
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Sanction Registration',
                FRA = 'Saisie des sanctions';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Employee Sanction";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Entry No."; "Entry No.")
                {
                    Editable = false;
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("Sanction Code"; "Sanction Code")
                {
                }
                field(Observation; Observation)
                {
                }
                field("Sanction Date"; "Sanction Date")
                {
                }
                field("Sanction Description"; "Sanction Description")
                {
                }
                field("Misconduct Code"; "Misconduct Code")
                {
                }
                field(Degree; Degree)
                {
                }
                field("Misconduct Description"; "Misconduct Description")
                {
                }
                field("Minutes No."; "Minutes No.")
                {
                }
                field("Minutes Date"; "Minutes Date")
                {
                }
                field("Decision No."; "Decision No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Decision Date"; "Decision Date")
                {
                }
                field("Structure code"; "Structure code")
                {
                }
                field("Structure description"; "Structure description")
                {
                }
                field("Function code"; "Function code")
                {
                }
                field("Function description"; "Function description")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field(Number; Number)
                {
                }
                field(Degré; Degré)
                {
                }
                field(Comment; Comment)
                 {
                 }
            }

        }
    }

    actions
    {
        area(navigation)
        {
            group("&Sanction")
            {
                Image = Error;
                CaptionML = ENU = '&Sanction',
                            FRA = '&Sanction';
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    //RunPageLink = "Table Name"=CONST("Employee Advance"),
                    //            "Table Line No."=FIELD("Entry No.");
                }
            }
        }
        area(processing)
        {
            group("&Functions")
            {
                Image = Job;
                CaptionML = ENU = '&Functions',
                            FRA = '&Fonctions';
                action("&Leave")
                {
                    Image = GoTo;
                    CaptionML = ENU = '&Leave',
                                FRA = '&Générer les absences pour Mise à Pied';

                    trigger OnAction();
                    begin
                        //Element 03 Début
                        ParamPaie.GET;
                        GestionnairePaie.RESET;
                        GestionnairePaie.SETRANGE("User ID", USERID);
                        IF NOT GestionnairePaie.FINDSET THEN
                            ERROR(Text02, USERID);
                        GestionnairePaie.FINDFIRST;
                        IF GestionnairePaie."Company Business Unit Code" = '' THEN
                            ERROR(Text01, USERID);
                        Unite.GET(GestionnairePaie."Company Business Unit Code");
                        IF Unite."Current Payroll" = '' THEN
                            ERROR(Text03, GestionnairePaie."Company Business Unit Code");
                        Paie.GET(Unite."Current Payroll");
                        IF Paie."Starting Date" = 0D THEN
                            ERROR(Text04, Paie.FIELDCAPTION("Starting Date"), Unite."Current Payroll");
                        IF Paie."Ending Date" = 0D THEN
                            ERROR(Text04, Paie.FIELDCAPTION("Ending Date"), Unite."Current Payroll");
                        IF ParamPaie."Leave Cause of Absence" = '' THEN
                            ERROR(Text07);
                        SanctionSalarie.RESET;
                        SanctionSalarie.SETFILTER("From Date", '%1..%2', Paie."Starting Date", Paie."Ending Date");
                        IF NOT SanctionSalarie.FINDFIRST THEN BEGIN
                            MESSAGE(Text05, Unite."Current Payroll");
                            EXIT;
                        END;
                        AbsenceSalarie.RESET;
                        AbsenceSalarie.SETRANGE("Cause of Absence Code", 'MISEAP');
                        AbsenceSalarie."Company Business Unit Code" := Unite.Code;
                        AbsenceSalarie.SETFILTER("From Date", '%1..%2', Paie."Starting Date", Paie."Ending Date");
                        IF AbsenceSalarie.FINDSET THEN
                            IF CONFIRM(STRSUBSTNO(Text08, FORMAT(AbsenceSalarie.COUNT), Unite."Current Payroll")) THEN
                                AbsenceSalarie.DELETEALL;
                        MotifAbsence.GET('MISEAP');
                        AbsenceSalarie.RESET;
                        REPEAT
                            AbsenceSalarie.INIT;
                            AbsenceSalarie.VALIDATE("Employee No.", SanctionSalarie."Employee No.");
                            AbsenceSalarie."From Date" := SanctionSalarie."From Date";
                            AbsenceSalarie."To Date" := SanctionSalarie."To Date";
                            AbsenceSalarie.VALIDATE("Cause of Absence Code", MotifAbsence.Code);
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                                Nbre := SanctionSalarie.Number;
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                                Nbre := ROUND(SanctionSalarie.Number * ParamPaie."No. of Worked Hours" / ParamPaie."No. of Worked Days");
                            AbsenceSalarie.VALIDATE(Quantity, Nbre);
                            AbsenceSalarie.Authorised := TRUE;
                            AbsenceSalarie."Company Business Unit Code" := Unite.Code;
                            AbsenceSalarie.INSERT(TRUE);
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                                AbsenceSalarie.VALIDATE("Unit of Measure", AbsenceSalarie."Unit of Measure"::Day);
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                                AbsenceSalarie.VALIDATE("Unit of Measure", AbsenceSalarie."Unit of Measure"::Hour);
                            AbsenceSalarie.MODIFY;
                        UNTIL SanctionSalarie.NEXT = 0;
                        MESSAGE(Text06, SanctionSalarie.COUNT, Unite."Current Payroll");
                        //Element 03 Fin
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        EXIT(Employee.GET("Employee No."));
    end;

    trigger OnOpenPage();
    begin

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text01);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            IF ParamUtilisateur."Company Business Unit" = '' THEN
                ERROR(Text02);
            FILTERGROUP(2);
            SETRANGE("Company Business Unit Code", ParamUtilisateur."Company Business Unit");
            SETRANGE(Status, Status::Active);
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        Employee: Record 5200;
        ParamUtilisateur: Record 91;
        Text01: Label 'Unité non configurée pour le gestionnaire de paie %1 !';
        Text02: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text03: Label 'Paie courante non configurée pour l''unité %1 !';
        Text04: Label '%1 non configurée pour la paie %2 !';
        Text05: Label 'Aucune absence n''est générée pour la paie %1.';
        Text06: Label 'Génération de %1 absences pour la paie %2.';
        Text07: Label 'Motif d''absence pour congé non configuré dans les paramètres de paie !';
        Text08: Label 'Supprimer les %1 absences pour congé actuellement saisies pour la paie %2 ?';
        AbsenceSalarie: Record "Employee Absence";
        SanctionSalarie: Record "Employee Sanction";
        Paie: Record Payroll;
        GestionnairePaie: Record "Payroll Manager";
        Unite: Record "Company Business Unit";
        ParamPaie: Record Payroll_Setup;
        Nbre: Decimal;
        MotifAbsence: Record 5206;
        Salarie: Record 5200;

}

