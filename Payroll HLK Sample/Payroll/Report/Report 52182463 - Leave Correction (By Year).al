/// <summary>
/// Report Leave Correction (By Year) (ID 52182463).
/// </summary>
report 52182463 "Leave Correction (By Year)"
{
    // version HALRHPAIE.6.2.00

    Caption = 'Actualisation des congés (par exercices)';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
            dataitem(DataItem4144; "Payroll Archive Header")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Payroll Code", "No.");

                trigger OnAfterGetRecord();
                begin
                    IF ("Payroll Code" <> PaieActuelle) OR ("STC Payroll") THEN BEGIN
                        //Calcul des droits par exercice
                        IF NOT Paie.GET("Payroll Code") THEN
                            ERROR(Text05, "Payroll Code");
                        IF Paie."Starting Date" = 0D THEN
                            ERROR(Text04, "Payroll Code", 'Date de début');
                        IF Paie."Ending Date" = 0D THEN
                            ERROR(Text04, "Payroll Code", 'Date de fin');
                        PeriodeConge.RESET;
                        PeriodeConge.SETFILTER("Starting Date", '<=%1', Paie."Ending Date");
                        PeriodeConge.SETFILTER("Ending Date", '>=%1', Paie."Ending Date");
                        IF NOT PeriodeConge.FINDFIRST THEN
                            ERROR(Text06);
                        IF EcritureCongeExercice.GET("Payroll Archive Header"."No.", PeriodeConge.Code) THEN BEGIN
                            EcritureCongeExercice.Amount := EcritureCongeExercice.Amount
                            + "Payroll Archive Header"."Leave Indemnity Amount";
                            EcritureCongeExercice.Days := EcritureCongeExercice.Days
                            + "Payroll Archive Header"."Leave Indemnity No.";
                            EcritureCongeExercice."Remaining Amount" := EcritureCongeExercice."Remaining Amount"
                            + "Payroll Archive Header"."Leave Indemnity Amount";
                            EcritureCongeExercice."Remaining Days" := EcritureCongeExercice."Remaining Days"
                            + "Payroll Archive Header"."Leave Indemnity No.";
                            EcritureCongeExercice.MODIFY;
                        END
                        ELSE BEGIN
                            EcritureCongeExercice2.INIT;
                            EcritureCongeExercice2."Employee No." := "Payroll Archive Header"."No.";
                            EcritureCongeExercice2."Leave Period Code" := PeriodeConge.Code;
                            EcritureCongeExercice2.Amount := "Payroll Archive Header"."Leave Indemnity Amount";
                            EcritureCongeExercice2.Days := "Payroll Archive Header"."Leave Indemnity No.";
                            EcritureCongeExercice2."Remaining Amount" := "Payroll Archive Header"."Leave Indemnity Amount";
                            EcritureCongeExercice2."Remaining Days" := "Payroll Archive Header"."Leave Indemnity No.";
                            EcritureCongeExercice2.INSERT;
                        END;
                    END;
                end;

                trigger OnPostDataItem();
                begin
                    //Génération des écritures de consommation
                    //EXIT;   //08
                    LigneArchivePaie.RESET;
                    LigneArchivePaie.SETRANGE("Employee No.", "Payroll Archive Header"."No.");
                    LigneArchivePaie.SETRANGE("Item Code", '222');
                    IF LigneArchivePaie.FINDFIRST THEN
                        REPEAT
                            Salarie.GET("Payroll Archive Header"."No.");
                            Salarie.CALCFIELDS("Total Leave Indem. No.");
                            NbreJours := LigneArchivePaie.Number;
                            TotalNbreJours := NbreJours;
                            //MESSAGE('%1 : %2 et %3',LigneArchivePaie."Payroll Code",NbreJours,EcritureCongeExercice."Remaining Days");  //08
                            IF NbreJours > ROUND(Salarie."Total Leave Indem. No.") THEN
                                MESSAGE(Text03, Salarie."No.", LigneArchivePaie."Payroll Code")
                            ELSE BEGIN
                                EcritureCongeExercice.RESET;
                                EcritureCongeExercice.SETRANGE("Employee No.", Salarie."No.");
                                EcritureCongeExercice.SETFILTER("Remaining Days", '>0');
                                EcritureCongeExercice.FINDFIRST;
                                REPEAT
                                    IF NbreJours <= ROUND(EcritureCongeExercice."Remaining Days") THEN
                                        MntIndemnite := EcritureCongeExercice."Remaining Amount" / EcritureCongeExercice."Remaining Days" * NbreJours
                                    ELSE BEGIN
                                        MntIndemnite := EcritureCongeExercice."Remaining Amount";
                                        NbreJours := ROUND(EcritureCongeExercice."Remaining Days");
                                    END;
                                    EcritureCongeExercice."Consumed Amount" := EcritureCongeExercice."Consumed Amount" + MntIndemnite;
                                    EcritureCongeExercice."Consumed Days" := EcritureCongeExercice."Consumed Days" + NbreJours;
                                    EcritureCongeExercice."Remaining Amount" := EcritureCongeExercice.Amount - EcritureCongeExercice."Consumed Amount";
                                    EcritureCongeExercice."Remaining Days" := ROUND(EcritureCongeExercice.Days - EcritureCongeExercice."Consumed Days");
                                    EcritureCongeExercice.MODIFY;
                                    TotalNbreJours := TotalNbreJours - NbreJours;
                                    NbreJours := TotalNbreJours;
                                    EcritureCongeExercice.NEXT;
                                UNTIL TotalNbreJours = 0;
                            END;
                        UNTIL LigneArchivePaie.NEXT = 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                IF "Company Business Unit Code" <> CodeUnite THEN
                    CurrReport.SKIP;
                IF NOT InclureInactifs THEN
                    IF Status = Status::Inactive THEN
                        CurrReport.SKIP;
                Progression.UPDATE(1, Employee."No.");
                EcritureCongeExercice.RESET;
                EcritureCongeExercice.SETRANGE("Employee No.", Employee."No.");
                EcritureCongeExercice.DELETEALL;
            end;

            trigger OnPreDataItem();
            begin
                ActionActivee := TRUE;
                IF NOT CONFIRM(Text01) THEN BEGIN
                    ActionActivee := FALSE;
                    CurrReport.SKIP;
                END;
                Progression.OPEN('Traitement des congés du salarié #1#######');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }



    trigger OnPostReport();
    begin
        IF ActionActivee THEN BEGIN
            Progression.CLOSE;
            MESSAGE(Text02);
        END;
    end;

    trigger OnPreReport();
    begin
        GestionnairePaie.RESET;
        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(Text07, USERID);
        IF GestionnairePaie."Company Business Unit Code" = '' THEN
            ERROR(Text08, USERID);
        Unite.GET(GestionnairePaie."Company Business Unit Code");
        CodeUnite := Unite.Code;
        PaieActuelle := Unite."Current Payroll";
        IF PaieActuelle = '' THEN
            ERROR(Text09, CodeUnite);
    end;

    var
        Text01: Label 'Générer les écritures de congé ?';
        Text02: Label 'Génération terminée des écritures de congé.';
        ActionActivee: Boolean;
        Employee: Record 5200;
        "Payroll Archive Header": Record "Payroll Archive Header";
        EcritureCongeExercice: Record "Leave Right By Years";
        EcritureCongeExercice2: Record "Leave Right By Years";
        EnteteArchivePaie: Record "Payroll Archive Header";
        LigneArchivePaie: Record "Payroll Archive Line";
        TotalMontant: Decimal;
        TotalNbreJours: Decimal;
        NbreJours: Decimal;
        MntIndemnite: Decimal;
        PaieConsommation: Code[20];
        Text03: Label 'Incohérence de données : Salarié %1, Consommation %2 !';
        Progression: Dialog;
        Paie: Record Payroll;
        PeriodeConge: Record "Leave Period";
        Text04: Label '"Information manquante : Paie %1 ; Information %2 !"';
        Text05: Label 'Paie non paramétrée : %1 !';
        Text06: Label 'Périodes de congé à réviser !';
        Salarie: Record 5200;
        GestionnairePaie: Record "Payroll Manager";
        Text07: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text08: Label '"Unité non paramétrée pour le gestionnaire %1 ! "';
        CodeUnite: Code[10];
        Unite: Record "Company Business Unit";
        PaieActuelle: Code[20];
        Text09: Label 'Paie actuelle manquante pour l''unité %1 !';
        InclureInactifs: Boolean;

}

