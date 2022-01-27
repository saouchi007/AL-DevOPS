/// <summary>
/// Codeunit Bilan de formation prep (ID 52182449).
/// </summary>
codeunit 52182449 "Bilan de formation prep"
//codeunit 39108422 "Bilan de formation prep"
{
    // version HALRHPAIE.6.2.00


    trigger OnRun();
    begin
    end;

    var
        PayrollArchiveLine: Record "Payroll Archive Line";
        base: Decimal;
        NP: Text[50];
        imaSS: Code[20];
        ret: Decimal;
        PayrollArchiveHeader: Record "Payroll Archive Header";
        TabBil: Record "Bilan de formation data";
        nbjr: Decimal;
        NumSS1: Code[20];
        NomPremon1: Text[50];
        dateN1: Date;
        dateE1: Date;
        dateS1: Date;
        PayrollArchiveHeader2: Record "Payroll Archive Header";
        RubriqueSalarie: Record "Payroll Entry";
        NbreJoursAbsence: Decimal;
        conv: Codeunit "Fiche fiscale";
        PayrollArchiveHeader3: Record "Payroll Archive Header";
        payroll: Record Payroll;
        MoisDebut: Integer;
        MoisFin: Integer;
        employee: Record 5200;
        dat: Date;
        NomFichier: Text[200];
        LigneEntete: Text[216];
        LigneDetail: Text[194];
        Fichier: File;
        ParamPaie: Record Payroll_Setup;
        EcriturePaie: Record "Payroll Entry";
        Text01: Label 'Pas de paies calculées pour %1 !';
        EcriturePaieBis: Record "Payroll Entry";
        BIL: Record "Bilan de formation data";
        BILBis: Record "Bilan de formation data";
        Salarie: Record 5200;
        Paie: Record Payroll;
        Mois: Integer;
        Text02: Label 'DAS générée avec succès.';
        Progression: Dialog;
        ArchivePaieEntete: Record "Payroll Archive Header";
        Duree: Decimal;
        Nbre: Decimal;
        NomFichierEntete: Text[18];
        NomFichierDetail: Text[18];
        UniteSociete: Record "Company Business Unit";
        Numero: Integer;
        DateNais: Text[30];

    /// <summary>
    /// GenererBilan.
    /// </summary>
    /// <param name="P_Unite">Code[10].</param>
    /// <param name="P_Annee">Integer.</param>
    procedure GenererBilan(P_Unite: Code[10]; P_Annee: Integer);
    begin
        ParamPaie.GET;
        //***Montants***
        EcriturePaie.RESET;
        EcriturePaie.SETRANGE("Item Code", ParamPaie."TIT Basis");
        EcriturePaie.SETRANGE("Company Business Unit Code", P_Unite);
        EcriturePaie.SETFILTER("Document No.", '%1', '*' + FORMAT(P_Annee) + '*');
        EcriturePaie.SETCURRENTKEY("Employee No.", "Document No.");
        IF NOT EcriturePaie.FINDFIRST THEN
            ERROR(Text01, P_Annee);
        BIL.RESET;
        BIL.DELETEALL;
        Progression.OPEN('Traitement du salarié #1#######');
        REPEAT
            Progression.UPDATE(1, EcriturePaie."Employee No.");
            Salarie.GET(EcriturePaie."Employee No.");
            IF NOT BILBis.GET(EcriturePaie."Employee No.") THEN BEGIN
                BIL.INIT;
                BIL.Matricule := EcriturePaie."Employee No.";
                BIL.Categorie := Salarie."Socio-Professional Category";
                BIL.Nom := Salarie."Last Name";
                BIL.Prénom := Salarie."First Name";
                BIL.INSERT;
            END;
            BIL.GET(EcriturePaie."Employee No.");
            Paie.GET(EcriturePaie."Document No.");
            Mois := DATE2DMY(Paie."Ending Date", 2);

            EcriturePaieBis.RESET;
            EcriturePaieBis.SETRANGE("Document No.", EcriturePaie."Document No.");
            EcriturePaieBis.SETRANGE("Employee No.", EcriturePaie."Employee No.");
            EcriturePaieBis.SETRANGE("Item Code", ParamPaie."Base Salary");
            Duree := 0;
            IF EcriturePaieBis.FINDFIRST THEN
                Duree := ROUND(EcriturePaieBis.Number, 1, '>')
            ELSE BEGIN
                EcriturePaieBis.RESET;
                EcriturePaieBis.SETRANGE("Document No.", EcriturePaie."Document No.");
                EcriturePaieBis.SETRANGE("Employee No.", EcriturePaie."Employee No.");
                EcriturePaieBis.SETRANGE("Item Code", ParamPaie."No. of Days (Daily Vacatary)");
                IF EcriturePaieBis.FINDFIRST THEN
                    Duree := ROUND(EcriturePaieBis.Number, 1, '>')
                ELSE BEGIN
                    EcriturePaieBis.RESET;
                    EcriturePaieBis.SETRANGE("Document No.", EcriturePaie."Document No.");
                    EcriturePaieBis.SETRANGE("Employee No.", EcriturePaie."Employee No.");
                    EcriturePaieBis.SETRANGE("Item Code", ParamPaie."No. of Hours (Hourly Vacatary)");
                    IF EcriturePaieBis.FINDFIRST THEN
                        Duree := ROUND(EcriturePaieBis.Number, 1, '>');
                END;
            END;

            ArchivePaieEntete.GET(EcriturePaie."Document No.", EcriturePaie."Employee No.");
            CASE Mois OF
                1, 2, 3:
                    BEGIN
                        BIL."Montant 1" := BIL."Montant 1" + EcriturePaie.Amount;
                        BIL."Montant annuel" := BIL."Montant annuel" + EcriturePaie.Amount;
                        IF Paie."Regular Payroll" THEN
                            CASE Salarie.Regime OF
                                Salarie.Regime::Mensuel:
                                    BIL."Durée 1" := ROUND(BIL."Durée 1" + Duree - ArchivePaieEntete."Total Absences Days"
                                    - ArchivePaieEntete."Total Absences Hours" / ParamPaie."No. of Hours By Day", 1, '>');
                                Salarie.Regime::"Vacataire journalier":
                                    BIL."Durée 1" := ROUND(BIL."Durée 1" + Duree - ArchivePaieEntete."Total Absences Days", 1, '>');
                                Salarie.Regime::"Vacataire horaire":
                                    BIL."Durée 1" := ROUND(BIL."Durée 1" + Duree - ArchivePaieEntete."Total Absences Hours"
                                    - ArchivePaieEntete."Total Absences Days" * ParamPaie."No. of Hours By Day", 1, '>');
                            END;
                    END;
                4, 5, 6:
                    BEGIN
                        BIL."Montant 2" := BIL."Montant 2" + EcriturePaie.Amount;
                        BIL."Montant annuel" := BIL."Montant annuel" + EcriturePaie.Amount;
                        IF Paie."Regular Payroll" THEN
                            CASE Salarie.Regime OF
                                Salarie.Regime::Mensuel:
                                    BIL."Durée 2" := ROUND(BIL."Durée 2" + Duree - ArchivePaieEntete."Total Absences Days"
                                    - ArchivePaieEntete."Total Absences Hours" / ParamPaie."No. of Hours By Day", 1, '>');
                                Salarie.Regime::"Vacataire journalier":
                                    BIL."Durée 2" := ROUND(BIL."Durée 2" + Duree - ArchivePaieEntete."Total Absences Days", 1, '>');
                                Salarie.Regime::"Vacataire horaire":
                                    BIL."Durée 2" := ROUND(BIL."Durée 2" + Duree - ArchivePaieEntete."Total Absences Hours"
                                    - ArchivePaieEntete."Total Absences Days" * ParamPaie."No. of Hours By Day", 1, '>');
                            END;
                    END;
                7, 8, 9:
                    BEGIN
                        BIL."Montant 3" := BIL."Montant 3" + EcriturePaie.Amount;
                        BIL."Montant annuel" := BIL."Montant annuel" + EcriturePaie.Amount;
                        IF Paie."Regular Payroll" THEN
                            CASE Salarie.Regime OF
                                Salarie.Regime::Mensuel:
                                    BIL."Durée 3" := ROUND(BIL."Durée 3" + Duree - ArchivePaieEntete."Total Absences Days"
                                    - ArchivePaieEntete."Total Absences Hours" / ParamPaie."No. of Hours By Day", 1, '>');
                                Salarie.Regime::"Vacataire journalier":
                                    BIL."Durée 3" := ROUND(BIL."Durée 3" + Duree - ArchivePaieEntete."Total Absences Days", 1, '>');
                                Salarie.Regime::"Vacataire horaire":
                                    BIL."Durée 3" := ROUND(BIL."Durée 3" + Duree - ArchivePaieEntete."Total Absences Hours"
                                    - ArchivePaieEntete."Total Absences Days" * ParamPaie."No. of Hours By Day", 1, '>');
                            END;
                    END;
                10, 11, 12:
                    BEGIN
                        BIL."Montant 4" := BIL."Montant 4" + EcriturePaie.Amount;
                        BIL."Montant annuel" := BIL."Montant annuel" + EcriturePaie.Amount;
                        IF Paie."Regular Payroll" THEN
                            CASE Salarie.Regime OF
                                Salarie.Regime::Mensuel:
                                    BIL."Durée 4" := ROUND(BIL."Durée 4" + Duree - ArchivePaieEntete."Total Absences Days"
                                    - ArchivePaieEntete."Total Absences Hours" / ParamPaie."No. of Hours By Day", 1, '>');
                                Salarie.Regime::"Vacataire journalier":
                                    BIL."Durée 4" := ROUND(BIL."Durée 4" + Duree - ArchivePaieEntete."Total Absences Days", 1, '>');
                                Salarie.Regime::"Vacataire horaire":
                                    BIL."Durée 4" := ROUND(BIL."Durée 4" + Duree - ArchivePaieEntete."Total Absences Hours"
                                    - ArchivePaieEntete."Total Absences Days" * ParamPaie."No. of Hours By Day", 1, '>');
                            END;
                    END;
            END;
            BIL.MODIFY;
        UNTIL EcriturePaie.NEXT = 0;
        //***Régularisation des cas particuliers***
        BIL.RESET;
        BIL.FINDFIRST;
        REPEAT
            IF (BIL."Montant 1" > 0) AND (BIL."Durée 1" = 0) THEN
                BIL."Durée 1" := 1;
            IF (BIL."Montant 2" > 0) AND (BIL."Durée 2" = 0) THEN
                BIL."Durée 2" := 1;
            IF (BIL."Montant 3" > 0) AND (BIL."Durée 3" = 0) THEN
                BIL."Durée 3" := 1;
            IF (BIL."Montant 4" > 0) AND (BIL."Durée 4" = 0) THEN
                BIL."Durée 4" := 1;
            BIL.MODIFY;
        UNTIL BIL.NEXT = 0;
        Progression.CLOSE;
    end;

    /// <summary>
    /// FormaterDate.
    /// </summary>
    /// <param name="P_Date">Date.</param>
    /// <returns>Return value of type Text[8].</returns>
    procedure FormaterDate(P_Date: Date): Text[8];
    var
        Chn: Text[8];
        Annee: Integer;
    begin
        IF P_Date = 0D THEN
            Chn := '        '
        ELSE BEGIN
            Annee := DATE2DMY(P_Date, 3);
            Chn := COPYSTR(FORMAT(P_Date), 1, 2) + COPYSTR(FORMAT(P_Date), 4, 2) + FORMAT(Annee);
        END;
        EXIT(Chn);
    end;
}

