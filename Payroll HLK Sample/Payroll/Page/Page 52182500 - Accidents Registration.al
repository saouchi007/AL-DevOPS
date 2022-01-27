/// <summary>
/// Page Accidents Registration (ID 52182500).
/// </summary>
page 52182500 "Accidents Registration" // Saisie des accidents de travail
{
    // version HALRHPAIE

    CaptionML = ENU = 'Accidents Registration',
                FRA = 'Saisie des accidents';
    PageType = List;
    SourceTable = "Employee Accident";

    layout
    {
        area(content)
        {
            repeater(new1)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("Accident Date"; "Accident Date")
                {
                }
                field("Cause of Accident Code"; "Cause of Accident Code")
                {
                }
                field(Description; Description)
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
            group("&Accident")
            {
                CaptionML = ENU = '&Accident',
                            FRA = '&Accident';
                Image = DeleteAllBreakpoints;
                action("Co&ments")
                {
                    CaptionML = ENU = 'Co&ments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(0), //CONST(18)
                                  "Table Line No." = FIELD("Entry No.");
                }
            }
        }
        area(processing)
        {
            group("&Functions")
            {
                CaptionML = ENU = '&Functions',
                            FRA = '&Fonctions';
                Image = JobJournal;
                action("&Leave")
                {
                    CaptionML = ENU = '&Leave',
                                FRA = '&Générer les absences pour accident de travail';
                    Image = ImportChartOfAccounts;

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
                        IF ParamPaie."Accident cause of absence" = '' THEN
                            ERROR(Text07);
                        AccidentSalarie.RESET;
                        AccidentSalarie.SETFILTER(AccidentSalarie."Accident Date", '%1..%2', Paie."Starting Date", Paie."Ending Date");
                        IF NOT AccidentSalarie.FINDFIRST THEN BEGIN
                            MESSAGE(Text05, Unite."Current Payroll");
                            EXIT;
                        END;
                        AbsenceSalarie.RESET;
                        AbsenceSalarie.SETRANGE("Cause of Absence Code", ParamPaie."Accident cause of absence");
                        AbsenceSalarie."Company Business Unit Code" := Unite.Code;
                        AbsenceSalarie.SETFILTER("From Date", '%1..%2', Paie."Starting Date", Paie."Ending Date");
                        IF AbsenceSalarie.FINDSET THEN
                            IF CONFIRM(STRSUBSTNO(Text08, FORMAT(AbsenceSalarie.COUNT), Unite."Current Payroll")) THEN
                                AbsenceSalarie.DELETEALL;
                        MotifAbsence.GET(ParamPaie."Accident cause of absence");
                        AbsenceSalarie.RESET;
                        REPEAT
                            AbsenceSalarie.INIT;
                            AbsenceSalarie.VALIDATE("Employee No.", AccidentSalarie."Employee No.");
                            AbsenceSalarie."From Date" := AccidentSalarie."Accident Date";
                            AbsenceSalarie."To Date" := AccidentSalarie."To Date";
                            AbsenceSalarie.VALIDATE("Cause of Absence Code", MotifAbsence.Code);
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                                Nbre := AccidentSalarie.Quantity;
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                                Nbre := ROUND(AccidentSalarie.Quantity * ParamPaie."No. of Worked Hours" / ParamPaie."No. of Worked Days");
                            AbsenceSalarie.VALIDATE(Quantity, Nbre);
                            AbsenceSalarie.Authorised := TRUE;
                            AbsenceSalarie."Company Business Unit Code" := Unite.Code;
                            AbsenceSalarie.INSERT(TRUE);
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                                AbsenceSalarie.VALIDATE("Unit of Measure", AbsenceSalarie."Unit of Measure"::Day);
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                                AbsenceSalarie.VALIDATE("Unit of Measure", AbsenceSalarie."Unit of Measure"::Hour);
                            AbsenceSalarie.MODIFY;
                        UNTIL AccidentSalarie.NEXT = 0;
                        MESSAGE(Text06, AccidentSalarie.COUNT, Unite."Current Payroll");
                        //Element 03 Fin
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Texte01);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            Direction.GET(ParamUtilisateur."Company Business Unit");
            IF ParamUtilisateur."Company Business Unit" = '' THEN
                ERROR(Texte02);
            FILTERGROUP(2);
            SETRANGE("Company Business Unit Code", ParamUtilisateur."Company Business Unit");
            SETRANGE(Status, Status::Active);
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        AbsenceSalarie: Record "Employee Absence";
        AccidentSalarie: Record "Employee Accident";
        Paie: Record Payroll;
        GestionnairePaie: Record "Payroll Manager";
        Unite: Record "Company Business Unit";
        ParamPaie: Record Payroll_Setup;
        Nbre: Decimal;
        MotifAbsence: Record 5206;
        Text01: Label 'Unité non configurée pour le gestionnaire de paie %1 !';
        Text02: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text03: Label 'Paie courante non configurée pour l''unité %1 !';
        Text04: Label '%1 non configurée pour la paie %2 !';
        Text05: Label 'Aucune absence n''est générée pour la paie %1.';
        Text06: Label 'Génération de %1 absences pour la paie %2.';
        Text07: Label 'Motif d''absence pour accident de travail non configuré dans les paramètres de paie !';
        Text08: Label 'Supprimer les %1 absences pour AT actuellement saisies pour la paie %2 ?';
        Employee: Record 5200;
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        Texte01: Label 'Utilisateur %1 non configuré !';
        Texte02: Label 'Direction non paramétrée pour l''utilisateur %1 !';

}

