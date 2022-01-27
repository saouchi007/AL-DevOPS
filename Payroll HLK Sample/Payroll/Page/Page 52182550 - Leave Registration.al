/// <summary>
/// Page Leave Registration (ID 51520).
/// </summary>
page 52182550 "Leave Registration"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Leave Registration',
                FRA = 'Saisie des congés';
    Editable = true;
    PageType = List;
    SourceTable = "Employee Leave";

    layout
    {
        area(content)
        {
            repeater(new)
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
                field("Leave Right"; "Leave Right")
                {
                }
                field("No. of Consumed Days"; "No. of Consumed Days")
                {
                }
                field("Leave Period"; "Leave Period")
                {
                    TableRelation = "Leave Period";
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Recovery Date"; "Recovery Date")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Leave")
            {
                CaptionML = ENU = '&Leave',
                            FRA = '&Congé';
                Image = Holiday;
                action("&Leave1")
                {
                    CaptionML = ENU = '&Leave',
                                FRA = '&Droits au congé';
                    Image = Holiday;

                    trigger OnAction();
                    begin
                        DroitConge.RESET;
                        DroitConge.SETRANGE("Employee No.", Rec."Employee No.");
                        IF DroitConge.FINDFIRST THEN BEGIN
                            REPEAT
                                DroitConge.CALCFIELDS("No. of Consumed Days");
                                DroitConge.Difference := DroitConge."No. of Days" - DroitConge."No. of Consumed Days";
                                DroitConge.MODIFY;
                            UNTIL DroitConge.NEXT = 0;
                            COMMIT;
                            PAGE.RUNMODAL(51518, DroitConge);
                        END;
                    end;
                }
                action("Imprimer titre de congé")
                {
                    Caption = 'Imprimer titre de congé';
                    Image = Print;

                    trigger OnAction();
                    begin
                        //Salarie.RESET;
                        //Salarie.SETRANGE("No.", "Employee No.");
                        //REPORT.RUN(REPORT::"Titre de congé", TRUE, FALSE, CongeSalarie);

                        CongeSalarie.RESET;
                        CongeSalarie.SETRANGE("Entry No.", "Entry No.");
                        CongeSalarie.FINDFIRST;
                        REPORT.RUNMODAL(51443, TRUE, FALSE, CongeSalarie);

                    end;
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
                action("&Leave2")
                {
                    CaptionML = ENU = '&Leave',
                                FRA = '&Générer les absences pour congé';
                    Image = AbsenceCategories;

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
                        CongeSalarie.RESET;
                        CongeSalarie.SETFILTER("Starting Date", '%1..%2', Paie."Starting Date", Paie."Ending Date");
                        IF NOT CongeSalarie.FINDFIRST THEN BEGIN
                            MESSAGE(Text05, Unite."Current Payroll");
                            EXIT;
                        END;
                        AbsenceSalarie.RESET;
                        AbsenceSalarie.SETRANGE("Cause of Absence Code", ParamPaie."Leave Cause of Absence");
                        AbsenceSalarie."Company Business Unit Code" := Unite.Code;
                        AbsenceSalarie.SETFILTER("From Date", '%1..%2', Paie."Starting Date", Paie."Ending Date");
                        IF AbsenceSalarie.FINDSET THEN
                            IF CONFIRM(STRSUBSTNO(Text08, FORMAT(AbsenceSalarie.COUNT), Unite."Current Payroll")) THEN
                                AbsenceSalarie.DELETEALL;
                        MotifAbsence.GET(ParamPaie."Leave Cause of Absence");
                        AbsenceSalarie.RESET;
                        REPEAT
                            AbsenceSalarie.INIT;
                            AbsenceSalarie.VALIDATE("Employee No.", CongeSalarie."Employee No.");
                            AbsenceSalarie."From Date" := CongeSalarie."Starting Date";
                            AbsenceSalarie."To Date" := CongeSalarie."Ending Date";
                            AbsenceSalarie.VALIDATE("Cause of Absence Code", MotifAbsence.Code);
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                                Nbre := CongeSalarie.Quantity;
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                                Nbre := ROUND(CongeSalarie.Quantity * ParamPaie."No. of Worked Hours" / ParamPaie."No. of Worked Days");
                            AbsenceSalarie.VALIDATE(Quantity, Nbre);
                            AbsenceSalarie.Authorised := TRUE;
                            AbsenceSalarie."Company Business Unit Code" := Unite.Code;
                            AbsenceSalarie.INSERT(TRUE);
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                                AbsenceSalarie.VALIDATE("Unit of Measure", AbsenceSalarie."Unit of Measure"::Day);
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                                AbsenceSalarie.VALIDATE("Unit of Measure", AbsenceSalarie."Unit of Measure"::Hour);
                            AbsenceSalarie.MODIFY;
                        UNTIL CongeSalarie.NEXT = 0;
                        MESSAGE(Text06, CongeSalarie.COUNT, Unite."Current Payroll");
                        //Element 03 Fin
                    end;
                }
            }
        }
    }



    var
        DroitConge: Record "Leave Right";
        AbsenceSalarie: Record 5207;
        CongeSalarie: Record "Employee Leave";
        Paie: Record Payroll;
        GestionnairePaie: Record "Payroll Manager";
        Unite: Record "Company Business Unit";
        Text01: Label 'Unité non configurée pour le gestionnaire de paie %1 !';
        Text02: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text03: Label 'Paie courante non configurée pour l''unité %1 !';
        Text04: Label '%1 non configurée pour la paie %2 !';
        Text05: Label 'Aucune absence n''est générée pour la paie %1.';
        Text06: Label 'Génération de %1 absences pour la paie %2.';
        ParamPaie: Record Payroll_Setup;
        Text07: Label 'Motif d''absence pour congé non configuré dans les paramètres de paie !';
        Nbre: Decimal;
        Text08: Label 'Supprimer les %1 absences pour congé actuellement saisies pour la paie %2 ?';
        MotifAbsence: Record 5206;
        Salarie: Record 5200;

}

