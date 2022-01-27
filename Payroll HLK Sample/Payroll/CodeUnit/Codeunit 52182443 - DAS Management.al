/// <summary>
/// Codeunit DAS Management (ID 51416).
/// </summary>
codeunit 52182443 "DAS Management"
//codeunit 39108416 "DAS Management"
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
        TabDas: Record DAS;
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
        LigneDetail: Text[1000];
        Fichier: File;
        ParamPaie: Record Payroll_Setup;
        EcriturePaie: Record "Payroll Entry";
        Text01: Label 'Pas de paies calculées pour %1/%2 !';
        EcriturePaieBis: Record "Payroll Entry";
        DAS: Record DAS;
        DASBis: Record DAS;
        Salarie: Record 5200;
        Paie: Record Payroll;
        Mois: Integer;
        Text02: Label 'DAS générée avec succès.';
        Progression: Dialog;
        ArchivePaieEntete: Record "Payroll Archive Header";
        Duree: Decimal;
        Nbre: Decimal;
        NomFichierEntete: Text[23];
        NomFichierDetail: Text[23];
        UniteSociete: Record "Company Business Unit";
        TypeDAS: Text[1];
        EnteteDAS: Record "DAS Entete";
        Numero: Integer;
        DateNais: Text[30];
        Nationality: Record Nationality;
        "DateDébutExerciceCacobatph": Date;
        DateFinExerciceCacobatph: Date;
        "DateDébutExCacobatphTxt": Text[10];
        DateFinExCacobatphTxt: Text[10];
        LengthAdresse: Integer;
        Text001: Label 'L''adresse de l''employé N° %1 doit être supérieur au 15 caractaires';
        Text002: Label 'le code nationalité de l''employé N° %1 doit être spécifié';
        Text003: Label 'le code nationalité Cacobapth de l''employé N° %1 doit être spécifié';
        Text004: Label 'Clé RIB obligatoire pour l''employé N° %1';
        LengthJobTitle: Integer;
        Text005: Label 'Fonction de l''employé N° %1 doit être supérieur au 5 caractaires';
        Text006: Label 'Sexe de l''employé N° %1 doit être spécifié';
        Text007: Label 'Situation familiale de l''employé N° %1 doit être spécifié';
        Text008: Label 'Prénom du père de l''employé N° %1 doit être spécifié';
        Text009: Label 'Nom de la mère de l''employé N° %1 doit être spécifié';
        Text010: Label 'Prénom du mère de l''employé N° %1 doit être spécifié';
        Text011: Label 'Numéro Identification National de l''employé N° %1 doit être spécifié';
        Text012: Label 'Numéro acte de naissance de l''employé N° %1 doit être spécifié';
        AnneeApres: Integer;
        AnneeEndingPayrol: Integer;
        MoisAnneeEndingPayrol: Text[8];
        AnneeEntree: Integer;
        MoisAnneeEntree: Text;
        MoisEntree: Integer;
        DebutDeMois: Date;
        MoisAnneeSortie: Text;
        MoisSortie: Integer;
        AnneeSortie: Integer;
        Duree1: Decimal;
        MoisAnneeEntreeDate: Date;
        MoisAnneeSortieDate: Date;
        MoisAnneeEndingPayrolDate: Date;
        PremerDeMois: Integer;
        Text013: Label 'La date d''entrée de l''employé N° %1 doit être inférieur au date fin de contrat';
        PeriodePaie: Text[50];
        MoisVirmCPA: Text[2];
        AnneeVirmCPA: Text[2];
        BankAccount: Record 270;
        JourEndingPayrol: Integer;
        MoisEndingPayrolText: Text[2];

    /// <summary>
    /// GenererFichiersDAS.
    /// </summary>
    /// <param name="P_Unite">Code[10].</param>
    /// <param name="P_Annee">Integer.</param>
    /// <param name="P_Chemin">Text[1000].</param>
    /// <param name="P_Type">Option N,C,R.</param>
    procedure GenererFichiersDAS(P_Unite: Code[10]; P_Annee: Integer; P_Chemin: Text[1000]; P_Type: Option N,C,R);
    begin
        UniteSociete.GET(P_Unite);
        NomFichierEntete := 'D' + COPYSTR(FORMAT(P_Annee), 3, 2) + 'E' + PADSTR(UniteSociete."Employer SS No.", 10) + '.txt';
        NomFichierDetail := 'D' + COPYSTR(FORMAT(P_Annee), 3, 2) + 'S' + PADSTR(UniteSociete."Employer SS No.", 10) + '.txt';
        //***Fichier entête***
        NomFichier := P_Chemin + NomFichierEntete;
        IF EXISTS(NomFichier) THEN
            ERASE(NomFichier);
        Fichier.WRITEMODE(TRUE);
        Fichier.TEXTMODE(TRUE);
        IF Fichier.CREATE(NomFichier) THEN BEGIN
            CASE P_Type OF
                P_Type::N:
                    TypeDAS := 'N';
                P_Type::C:
                    TypeDAS := 'C';
                P_Type::R:
                    TypeDAS := 'R';
            END;
            EnteteDAS.CALCFIELDS("Trimestre 1", "Trimestre 2", "Trimestre 3", "Trimestre 4", "Total annuel");
            LigneEntete := PADSTR(UniteSociete."Employer SS No.", 10) + PADSTR(TypeDAS, 1) + PADSTR(FORMAT(P_Annee), 4)
            + PADSTR(UniteSociete."CNAS Center", 5) + PADSTR(UniteSociete.Name, 30) + PADSTR(UniteSociete.Name, 30)
            + PADSTR(UniteSociete.Address, 50)
            + PADSTR(FORMAT(EnteteDAS."Trimestre 1" * 100, 0, 2), 16)
            + PADSTR(FORMAT(EnteteDAS."Trimestre 2" * 100, 0, 2), 16)
            + PADSTR(FORMAT(EnteteDAS."Trimestre 3" * 100, 0, 2), 16)
            + PADSTR(FORMAT(EnteteDAS."Trimestre 4" * 100, 0, 2), 16)
            + PADSTR(FORMAT(EnteteDAS."Total annuel" * 100, 0, 2), 16)
            + PADSTR(FORMAT(DAS.COUNT), 6);
            Fichier.WRITE(LigneEntete);
            Fichier.CLOSE;
        END;
        //***Fichier détail***
        NomFichier := P_Chemin + NomFichierDetail;
        IF EXISTS(NomFichier) THEN
            ERASE(NomFichier);
        Fichier.WRITEMODE(TRUE);
        Fichier.TEXTMODE(TRUE);
        IF Fichier.CREATE(NomFichier) THEN BEGIN
            Numero := 0;
            DAS.RESET;
            DAS.FINDFIRST;
            REPEAT
                Numero := Numero + 1;
                Salarie.GET(DAS.Matricule);
                LigneDetail := PADSTR(UniteSociete."Employer SS No.", 10) + PADSTR(FORMAT(P_Annee), 4)
                + PADSTR(FORMAT(Numero), 6) + PADSTR(DELCHR(Salarie."Social Security No."), 12)
                + PADSTR(DAS.Nom, 25) + PADSTR(DAS.Prénom, 25) + DAS."Date de naissance"
                + PADSTR(FORMAT(DAS."Durée 1"), 3) + 'J' + PADSTR(FORMAT(DAS."Montant 1" * 100, 0, 2), 10)
                + PADSTR(FORMAT(DAS."Durée 2"), 3) + 'J' + PADSTR(FORMAT(DAS."Montant 2" * 100, 0, 2), 10)
                + PADSTR(FORMAT(DAS."Durée 3"), 3) + 'J' + PADSTR(FORMAT(DAS."Montant 3" * 100, 0, 2), 10)
                + PADSTR(FORMAT(DAS."Durée 4"), 3) + 'J' + PADSTR(FORMAT(DAS."Montant 4" * 100, 0, 2), 10)
                + PADSTR(FORMAT(DAS."Montant annuel" * 100, 0, 2), 12)
                + FormaterDate(DAS."Date d'entrée")
                + DELCHR(FormaterDate(DAS."Date de sortie"), '>', '  ');
                Fichier.WRITE(LigneDetail);
            UNTIL DAS.NEXT = 0;
            Fichier.CLOSE;
        END;
        MESSAGE('Génération des deux fichiers de la DAS effectuée avec succès.');
    end;

    /// <summary>
    /// GenererDAS.
    /// </summary>
    /// <param name="P_Unite">Code[10].</param>
    /// <param name="P_Annee">Integer.</param>
    procedure GenererDAS(P_Unite: Code[10]; P_Annee: Integer);
    begin
        ParamPaie.GET;
        //***Montants***
        EcriturePaie.RESET;
        EcriturePaie.SETRANGE("Item Code", ParamPaie."Post Salary");
        EcriturePaie.SETRANGE("Company Business Unit Code", P_Unite);
        EcriturePaie.SETFILTER("Document No.", '%1', '*' + FORMAT(P_Annee) + '*');
        EcriturePaie.SETCURRENTKEY("Employee No.", "Document No.");
        IF NOT EcriturePaie.FINDFIRST THEN
            ERROR(Text01, P_Annee);
        IF NOT EnteteDAS.GET THEN BEGIN
            EnteteDAS.INIT;
            EnteteDAS."Primary Key" := ' ';
            EnteteDAS.INSERT;
        END;
        EnteteDAS.GET;
        EnteteDAS.Année := P_Annee;
        EnteteDAS.MODIFY;
        DAS.RESET;
        DAS.DELETEALL;
        Progression.OPEN('Traitement du salarié #1#######');
        REPEAT
            Progression.UPDATE(1, EcriturePaie."Employee No.");
            Salarie.GET(EcriturePaie."Employee No.");
            IF NOT DASBis.GET(EcriturePaie."Employee No.") THEN BEGIN
                DAS.INIT;
                DAS.Matricule := EcriturePaie."Employee No.";
                DAS."Num SS" := Salarie."Social Security No.";
                DAS.Nom := Salarie."Last Name";
                DAS.Prénom := Salarie."First Name";

                //DAS."Date de naissance":=Salarie."Birth Date";
                IF Salarie.Présumé THEN
                    DateNais := '    19' + COPYSTR(FORMAT(Salarie."Birth Date"), 7, 2)
                ELSE
                    DateNais := FormaterDate(Salarie."Birth Date");
                DAS."Date de naissance" := DateNais;
                DAS."Date d'entrée" := Salarie."Employment Date";
                DAS."Date de sortie" := Salarie.Dateexit;
                DAS.INSERT;
            END;
            DAS.GET(EcriturePaie."Employee No.");
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
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF Paie."Regular Payroll" THEN
                            CASE Salarie.Regime OF
                                Salarie.Regime::Mensuel:
                                    DAS."Durée 1" := ROUND(DAS."Durée 1" + Duree - ArchivePaieEntete."Total Absences Days"
                                    - ArchivePaieEntete."Total Absences Hours" / ParamPaie."No. of Hours By Day", 1, '>');
                                Salarie.Regime::"Vacataire journalier":
                                    DAS."Durée 1" := ROUND(DAS."Durée 1" + Duree - ArchivePaieEntete."Total Absences Days", 1, '>');
                                Salarie.Regime::"Vacataire horaire":
                                    DAS."Durée 1" := ROUND(DAS."Durée 1" + Duree - ArchivePaieEntete."Total Absences Hours"
                                    - ArchivePaieEntete."Total Absences Days" * ParamPaie."No. of Hours By Day", 1, '>');
                            END;
                    END;
                4, 5, 6:
                    BEGIN
                        DAS."Montant 2" := DAS."Montant 2" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF Paie."Regular Payroll" THEN
                            CASE Salarie.Regime OF
                                Salarie.Regime::Mensuel:
                                    DAS."Durée 2" := ROUND(DAS."Durée 2" + Duree - ArchivePaieEntete."Total Absences Days"
                                    - ArchivePaieEntete."Total Absences Hours" / ParamPaie."No. of Hours By Day", 1, '>');
                                Salarie.Regime::"Vacataire journalier":
                                    DAS."Durée 2" := ROUND(DAS."Durée 2" + Duree - ArchivePaieEntete."Total Absences Days", 1, '>');
                                Salarie.Regime::"Vacataire horaire":
                                    DAS."Durée 2" := ROUND(DAS."Durée 2" + Duree - ArchivePaieEntete."Total Absences Hours"
                                    - ArchivePaieEntete."Total Absences Days" * ParamPaie."No. of Hours By Day", 1, '>');
                            END;
                    END;
                7, 8, 9:
                    BEGIN
                        DAS."Montant 3" := DAS."Montant 3" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF Paie."Regular Payroll" THEN
                            CASE Salarie.Regime OF
                                Salarie.Regime::Mensuel:
                                    DAS."Durée 3" := ROUND(DAS."Durée 3" + Duree - ArchivePaieEntete."Total Absences Days"
                                    - ArchivePaieEntete."Total Absences Hours" / ParamPaie."No. of Hours By Day", 1, '>');
                                Salarie.Regime::"Vacataire journalier":
                                    DAS."Durée 3" := ROUND(DAS."Durée 3" + Duree - ArchivePaieEntete."Total Absences Days", 1, '>');
                                Salarie.Regime::"Vacataire horaire":
                                    DAS."Durée 3" := ROUND(DAS."Durée 3" + Duree - ArchivePaieEntete."Total Absences Hours"
                                    - ArchivePaieEntete."Total Absences Days" * ParamPaie."No. of Hours By Day", 1, '>');
                            END;
                    END;
                10, 11, 12:
                    BEGIN
                        DAS."Montant 4" := DAS."Montant 4" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF Paie."Regular Payroll" THEN
                            CASE Salarie.Regime OF
                                Salarie.Regime::Mensuel:
                                    DAS."Durée 4" := ROUND(DAS."Durée 4" + Duree - ArchivePaieEntete."Total Absences Days"
                                    - ArchivePaieEntete."Total Absences Hours" / ParamPaie."No. of Hours By Day", 1, '>');
                                Salarie.Regime::"Vacataire journalier":
                                    DAS."Durée 4" := ROUND(DAS."Durée 4" + Duree - ArchivePaieEntete."Total Absences Days", 1, '>');
                                Salarie.Regime::"Vacataire horaire":
                                    DAS."Durée 4" := ROUND(DAS."Durée 4" + Duree - ArchivePaieEntete."Total Absences Hours"
                                    - ArchivePaieEntete."Total Absences Days" * ParamPaie."No. of Hours By Day", 1, '>');
                            END;
                    END;
            END;
            DAS.MODIFY;
        UNTIL EcriturePaie.NEXT = 0;
        //***Régularisation des cas particuliers***
        DAS.RESET;
        DAS.FINDFIRST;
        REPEAT
            IF (DAS."Montant 1" > 0) AND (DAS."Durée 1" = 0) THEN
                DAS."Durée 1" := 1;
            IF (DAS."Montant 2" > 0) AND (DAS."Durée 2" = 0) THEN
                DAS."Durée 2" := 1;
            IF (DAS."Montant 3" > 0) AND (DAS."Durée 3" = 0) THEN
                DAS."Durée 3" := 1;
            IF (DAS."Montant 4" > 0) AND (DAS."Durée 4" = 0) THEN
                DAS."Durée 4" := 1;
            DAS.MODIFY;
        UNTIL DAS.NEXT = 0;
        Progression.CLOSE;
    end;

    /// <summary>
    /// FormaterDate.
    /// </summary>
    /// <param name="P_Date">Date.</param>
    /// <returns>Return value of type Text[10].</returns>
    procedure FormaterDate(P_Date: Date): Text[10];
    var
        Chn: Text[10];
        Annee: Integer;
    begin
        IF P_Date = 0D THEN
            Chn := '        '
        ELSE BEGIN
            Annee := DATE2DMY(P_Date, 3);
            Chn := COPYSTR(FORMAT(P_Date), 1, 2) + '/' + COPYSTR(FORMAT(P_Date), 4, 2) + '/' + FORMAT(Annee);
        END;
        EXIT(Chn);
    end;

    /// <summary>
    /// GenererFichiersDasCacobatph.
    /// </summary>
    /// <param name="P_Unite">Code[10].</param>
    /// <param name="P_Annee">Integer.</param>
    /// <param name="P_Chemin">Text[1000].</param>
    /// <param name="P_Type">Option N,C,R.</param>
    procedure GenererFichiersDasCacobatph(P_Unite: Code[10]; P_Annee: Integer; P_Chemin: Text[1000]; P_Type: Option N,C,R);
    begin
        UniteSociete.GET(P_Unite);
        NomFichierDetail := 'CACOBATPH' + '.txt';
        //NomFichierDetail:=PADSTR(UniteSociete."Employer SS No.",10)+'_DAS_'+FORMAT(P_Annee)+'.txt';
        //***Fichier détail***
        NomFichier := P_Chemin + NomFichierDetail;
        IF EXISTS(NomFichier) THEN
            ERASE(NomFichier);
        Fichier.WRITEMODE(TRUE);
        Fichier.TEXTMODE(TRUE);
        IF Fichier.CREATE(NomFichier) THEN BEGIN
            Numero := 0;
            DAS.RESET;
            DAS.FINDFIRST;
            DAS.CALCFIELDS("Total annuel");

            LigneDetail := 'DAS CACOBATPH VER 3.0';
            Fichier.WRITE(LigneDetail);
            LigneDetail := PADSTR(UniteSociete."Employer SS No.", 8) + ';' + FORMAT(P_Annee) + ';1;' + FORMAT(DAS."Total annuel", 0, 2) + ';' + FORMAT(DAS.COUNT);
            Fichier.WRITE(UPPERCASE(LigneDetail));
            REPEAT
                Numero := Numero + 1;
                Salarie.GET(DAS.Matricule);
                LigneDetail :=
                 DELCHR(DAS."Num SS", '>', '  ') + ';'
                + DELCHR(DAS.Nom, '>', '  ') + ';'
                + DELCHR(DAS.Prénom, '>', '  ') + ';'
                + PADSTR(DELCHR(FORMAT(DAS."Marital Status"), '>', '  '), 1) + ';'
                + DELCHR(DAS."Date de naissance", '>', '  ') + ';'
                + DELCHR(DAS."Birthplace City", '>', '  ') + ';'
                + DELCHR(DAS.Address, '>', '  ') + ';'
                + DELCHR(DAS.City, '>', '  ') + ';'
                + DELCHR(DAS."Post Code", '>', '  ') + ';'
                + PADSTR(DELCHR(FORMAT(DAS.Présumé), '>', '  '), 1) + ';'
                + PADSTR(DELCHR(FORMAT(DAS.Etranger), '>', '  '), 1) + ';'
                + DELCHR(DAS."CCP N", '>', '  ') + ';'
                + DELCHR(DAS."Bank Account No.", '>', '  ') + ';'
                + DELCHR(DAS.Banque, '>', '  ') + ';'
                + DELCHR(DAS."Agence bancaire", '>', '  ') + ';'
                + DELCHR(DAS."Job Title", '>', '  ') + ';'
                + DELCHR(FORMAT(DAS."Montant annuel", 0, 2), '>', '  ') + ';'
                + DELCHR(FORMAT(DAS."Durée de travail", 0, 2), '>', '  ') + ';'
                + 'J;'
                + DELCHR(FormaterDate(DAS."Date d'entrée"), '>', '  ') + ';'
                + DELCHR(FormaterDate(DAS."Date de sortie"), '>', '  ') + ';'
                + DELCHR(DAS."Type E/S", '>', '  ') + ';'
                + PADSTR(DELCHR(FORMAT(DAS.Gender), '>', '  '), 1) + ';'
                + DELCHR(DAS."Mobile Phone No.", '>', '  ') + ';'
                + DELCHR(DAS."E-Mail", '>', '  ') + ';'
                + DELCHR(DAS."N° Carte identité nationale", '>', '  ') + ';'
                + DELCHR(DAS."Code nationalité cacobatph", '>', '  ') + ';'
                + DELCHR(DAS."Prénom du père", '>', '  ') + ';'
                + DELCHR(DAS."Nom de la mère", '>', '  ') + ';'
                + DELCHR(DAS."Prénom de la mère", '>', '  ') + ';'
                + DELCHR(DAS."N° Identification National", '>', '  ') + ';'
                + DELCHR(DAS."N° acte de naissance", '>', '  ') + ';';
                Fichier.WRITE(UPPERCASE(LigneDetail));
            UNTIL DAS.NEXT = 0;
            Fichier.CLOSE;
        END;
        MESSAGE('Génération du fichier de CACOBATPH effectué avec succès.');
    end;

    /// <summary>
    /// GenererDasCacobatph.
    /// </summary>
    /// <param name="P_Unite">Code[10].</param>
    /// <param name="P_Annee">Integer.</param>
    procedure GenererDasCacobatph(P_Unite: Code[10]; P_Annee: Integer);
    begin
        ParamPaie.GET;
        //***Montants Et Durée***
        EcriturePaie.RESET;
        AnneeApres := P_Annee + 1;
        DateDébutExCacobatphTxt := '0107' + FORMAT(P_Annee);
        DateFinExCacobatphTxt := '3006' + FORMAT(P_Annee + 1);
        EVALUATE(DateDébutExerciceCacobatph, DateDébutExCacobatphTxt);
        EVALUATE(DateFinExerciceCacobatph, DateFinExCacobatphTxt);
        EcriturePaie.SETRANGE("Item Code", ParamPaie."Post Salary");
        EcriturePaie.SETRANGE("Company Business Unit Code", P_Unite);
        EcriturePaie.SETFILTER("Document Date", '%1..%2', DateDébutExerciceCacobatph, DateFinExerciceCacobatph);
        EcriturePaie.FINDSET;
        EcriturePaie.SETCURRENTKEY("Employee No.", "Document No.");
        IF NOT EcriturePaie.FINDFIRST THEN
            ERROR(Text01, P_Annee);

        DAS.DELETEALL;
        DAS.RESET;
        Progression.OPEN('Traitement du salarié #1#######');
        REPEAT
            Progression.UPDATE(1, EcriturePaie."Employee No.");
            Salarie.GET(EcriturePaie."Employee No.");
            IF NOT DASBis.GET(EcriturePaie."Employee No.") THEN BEGIN
                DAS.INIT;
                DAS.Matricule := EcriturePaie."Employee No.";

                IF Salarie."Social Security No." = '' THEN BEGIN
                    DAS."Num SS" := '000000000000'
                END
                ELSE
                    DAS."Num SS" := Salarie."Social Security No.";


                DAS.Nom := Salarie."Last Name";
                DAS.Prénom := Salarie."First Name";

                IF Salarie."Marital Status" = Salarie."Marital Status"::" " THEN BEGIN
                    ERROR(Text007, Salarie."No.")
                END ELSE
                    IF Salarie."Marital Status" = Salarie."Marital Status"::Married THEN BEGIN
                        DAS."Marital Status" := 'M'
                    END ELSE
                        DAS."Marital Status" := 'C';

                IF Salarie.Présumé THEN BEGIN
                    DateNais := '01/01/' + COPYSTR(FormaterDate(Salarie."Birth Date"), 7, 4)
                END
                ELSE
                    DateNais := FormaterDate(Salarie."Birth Date");
                DAS."Date de naissance" := DateNais;

                DAS."Birthplace City" := Salarie."Birthplace City";

                DAS.Address := Salarie.Address;
                /* LengthAdresse:= STRLEN(Salarie.Address);
                 IF LengthAdresse < 15 THEN BEGIN ERROR(Text001,Salarie."No.");END
                   ELSE DAS.Address:=Salarie.Address;*/

                DAS.City := Salarie.City;
                DAS."Post Code" := Salarie."Post Code CACOBATPH";
                DAS.Présumé := Salarie.Présumé;
                DAS.Etranger := Salarie.Etranger;
                DAS."CCP N" := Salarie."CCP N";

                IF Salarie."Payroll Bank Account No." <> '' THEN BEGIN
                    IF Salarie."RIB Key" = '' THEN BEGIN
                        ERROR(Text004, Salarie."No.");
                    END ELSE
                        DAS."Bank Account No." := Salarie."Payroll Bank Account No." + Salarie."RIB Key";
                END;

                DAS.Banque := COPYSTR(Salarie."Payroll Bank Account No.", 1, 3);
                DAS."Agence bancaire" := COPYSTR(Salarie."Payroll Bank Account No.", 4, 5);

                LengthJobTitle := STRLEN(Salarie."Job Title");
                IF LengthJobTitle < 5 THEN BEGIN
                    ERROR(Text005, Salarie."No.");
                END
                ELSE
                    DAS."Job Title" := Salarie."Job Title";

                DAS."Date d'entrée" := Salarie."Employment Date";
                DAS."Date de sortie" := Salarie.Dateexit;

                // DateDébutExCacobatphTxt:='0107'+FORMAT(P_Annee);
                //DateFinExCacobatphTxt:='3006'+FORMAT(P_Annee+1);
                //EVALUATE(DateDébutExerciceCacobatph,DateDébutExCacobatphTxt);
                //EVALUATE(DateFinExerciceCacobatph,DateFinExCacobatphTxt);
                IF (Salarie.Dateexit <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) THEN BEGIN
                    DAS."Type E/S" := 'S'
                END ELSE
                    DAS."Type E/S" := 'E';
                /* IF (Salarie."Employment Date"<=DateFinExerciceCacobatph) AND (Salarie."Employment Date">=DateDébutExerciceCacobatph) THEN BEGIN
                    DAS."Type E/S":='E';
                   END;*/


                IF Salarie.Gender = Salarie.Gender::" " THEN BEGIN
                    ERROR(Text006, Salarie."No.")
                END ELSE
                    IF Salarie.Gender = Salarie.Gender::Female THEN BEGIN
                        DAS.Gender := 'F';
                    END ELSE
                        DAS.Gender := 'M';


                DAS."Mobile Phone No." := Salarie."Mobile Phone No.";
                DAS."E-Mail" := Salarie."E-Mail";
                DAS."N° Carte identité nationale" := Salarie."N° Carte identité nationale";

                IF Salarie."Nationality Code" <> '' THEN BEGIN
                    Nationality.GET(Salarie."Nationality Code");
                    //  IF Nationality."Code nationalité cacobatph" <> '' THEN BEGIN
                    DAS."Code nationalité cacobatph" := Nationality."Code nationalité cacobatph"
                    //  END ELSE ERROR(Text003,Salarie."No.");
                END;
                // ELSE ERROR(Text002,Salarie."No.");

                /* IF Salarie."Prénom du père"='' THEN
                 BEGIN
                   ERROR(Text008,Salarie."No.")
                   END ELSE */
                DAS."Prénom du père" := Salarie."Prénom du père";

                /* IF Salarie."Nom de la mère"='' THEN
                 BEGIN
                   ERROR(Text009,Salarie."No.")
                   END ELSE*/
                DAS."Nom de la mère" := Salarie."Nom de la mère";

                /* IF Salarie."Prénom de la mère"='' THEN
                 BEGIN
                   ERROR(Text010,Salarie."No.")
                   END ELSE*/
                DAS."Prénom de la mère" := Salarie."Prénom de la mère";

                /* IF Salarie."N° Identification National"='' THEN
                 BEGIN
                   ERROR(Text011,Salarie."No.")
                   END ELSE */
                DAS."N° Identification National" := Salarie."N° Identification National";

                /* IF Salarie."N° acte de naissance"='' THEN
                 BEGIN
                     ERROR(Text012,Salarie."No.")
                     END ELSE*/
                DAS."N° acte de naissance" := Salarie."N° acte de naissance";

                DAS.INSERT;
            END;
            //**************************************************************************************************************************************************
            //la durée de travail et Montant pendant l'excercice CACOBATPH (01/07/N(P_Anne)-30/06/N+1(AnneeApres))(le calcule de la durée se fait par rapport a la paie cloturé)
            DAS.GET(EcriturePaie."Employee No.");
            Paie.GET(EcriturePaie."Document No.");
            Mois := DATE2DMY(Paie."Ending Date", 2);
            PremerDeMois := 1;

            AnneeEndingPayrol := DATE2DMY(Paie."Ending Date", 3);
            MoisAnneeEndingPayrol := FORMAT(Mois) + FORMAT(AnneeEndingPayrol);
            MoisAnneeEndingPayrolDate := DMY2DATE(PremerDeMois, Mois, AnneeEndingPayrol);

            /*IF Salarie.Dateexit<Salarie."Employment Date" THEN BEGIN
               ERROR(Text013);
            END; */
            IF Salarie."Employment Date" <> 0D THEN BEGIN
                MoisEntree := DATE2DMY(Salarie."Employment Date", 2);
                AnneeEntree := DATE2DMY(Salarie."Employment Date", 3);
                //MoisAnneeEntree:=FORMAT(MoisEntree)+FORMAT(AnneeEntree);
                MoisAnneeEntreeDate := DMY2DATE(PremerDeMois, MoisEntree, AnneeEntree);
            END;

            IF Salarie.Dateexit <> 0D THEN BEGIN
                MoisSortie := DATE2DMY(Salarie.Dateexit, 2);
                AnneeSortie := DATE2DMY(Salarie.Dateexit, 3);
                // MoisAnneeSortie:=FORMAT(MoisSortie)+FORMAT(AnneeSortie);
                MoisAnneeSortieDate := DMY2DATE(PremerDeMois, MoisSortie, AnneeSortie);
            END;

            EcriturePaieBis.RESET;
            EcriturePaieBis.SETRANGE("Document No.", EcriturePaie."Document No.");
            EcriturePaieBis.SETRANGE("Employee No.", EcriturePaie."Employee No.");
            EcriturePaieBis.SETRANGE("Item Code", ParamPaie."Base Salary");
            Duree := 0;
            IF EcriturePaieBis.FINDFIRST THEN BEGIN
                Duree := ROUND(EcriturePaieBis.Number, 1, '>')
            END
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
            CASE MoisAnneeEndingPayrol OF
                ('7' + FORMAT(P_Annee)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0107' + FORMAT(P_Annee));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        //** Pas E/S dans l'excercice CACOBAPTH(01/07/N(P_Anne)-30/06/N+1(AnneeApres))**
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;
                        //** le cas d'une E dans l'excercice CACOBAPTH(01/07/N(P_Anne)-30/06/N+1(AnneeApres))**
                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;
                        //** le cas d'une S dans l'excercice CACOBAPTH(01/07/N(P_Anne)-30/06/N+1(AnneeApres))**
                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;
                        //** le cas d'une E et S dans l'excercice CACOBAPTH(01/07/N(P_Anne)-30/06/N+1(AnneeApres))**
                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('8' + FORMAT(P_Annee)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0108' + FORMAT(P_Annee));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('9' + FORMAT(P_Annee)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0109' + FORMAT(P_Annee));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30)); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('10' + FORMAT(P_Annee)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0110' + FORMAT(P_Annee));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('11' + FORMAT(P_Annee)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0111' + FORMAT(P_Annee));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('12' + FORMAT(P_Annee)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0112' + FORMAT(P_Annee));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('1' + FORMAT(AnneeApres)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0101' + FORMAT(AnneeApres));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('2' + FORMAT(AnneeApres)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0102' + FORMAT(AnneeApres));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('3' + FORMAT(AnneeApres)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0103' + FORMAT(AnneeApres));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('4' + FORMAT(AnneeApres)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0104' + FORMAT(AnneeApres));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('5' + FORMAT(AnneeApres)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0105' + FORMAT(AnneeApres));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;
                    END;

                ('6' + FORMAT(AnneeApres)):
                    BEGIN
                        EVALUATE(DebutDeMois, '0106' + FORMAT(AnneeApres));
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        IF (Salarie."Employment Date" < DateDébutExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            DAS."DuréeCaco 1" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 1");
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND ((Salarie.Dateexit > DateFinExerciceCacobatph) OR (Salarie.Dateexit = 0D)) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2" - ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) THEN BEGIN DAS."DuréeCaco 2" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 2", 1); END;
                        END;

                        IF (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) AND ((Salarie."Employment Date" < DateDébutExerciceCacobatph) OR (Salarie."Employment Date" = 0D)) THEN BEGIN
                            Duree := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(DAS."DuréeCaco 3" + ((Duree * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (Duree > 0) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 3" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 3", 1); END;
                        END;

                        IF (Salarie."Employment Date" >= DateDébutExerciceCacobatph) AND (Salarie."Employment Date" <= DateFinExerciceCacobatph) AND (Salarie.Dateexit >= DateDébutExerciceCacobatph) AND (Salarie.Dateexit <= DateFinExerciceCacobatph) THEN BEGIN
                            Duree := (Salarie."Employment Date" - DebutDeMois + 1);
                            Duree1 := (Salarie.Dateexit - DebutDeMois + 1);
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4" - (ParamPaie."No. of Worked Days" * Duree / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 * ParamPaie."No. of Worked Days") / 30), 1); END;
                            IF (MoisAnneeEndingPayrolDate > MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate < MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(ParamPaie."No. of Worked Days" + DAS."DuréeCaco 4", 1); END;
                            IF (MoisAnneeEndingPayrolDate = MoisAnneeEntreeDate) AND (MoisAnneeEndingPayrolDate = MoisAnneeSortieDate) THEN BEGIN DAS."DuréeCaco 4" := ROUND(DAS."DuréeCaco 4" + ((Duree1 - Duree) * ParamPaie."No. of Worked Days" / 30), 1); END;
                        END;

                    END;
            END;
            DAS."Durée de travail" := DAS."DuréeCaco 1" + DAS."DuréeCaco 2" + DAS."DuréeCaco 3" + DAS."DuréeCaco 4";
            DAS.MODIFY;
        UNTIL EcriturePaie.NEXT = 0;
        //***Régularisation des cas particuliers***
        DAS.RESET;
        DAS.FINDFIRST;
        REPEAT
            IF (DAS."Montant 1" > 0) AND (DAS."Durée 1" = 0) THEN
                DAS."Durée 1" := 1;
            IF (DAS."Montant 2" > 0) AND (DAS."Durée 2" = 0) THEN
                DAS."Durée 2" := 1;
            IF (DAS."Montant 3" > 0) AND (DAS."Durée 3" = 0) THEN
                DAS."Durée 3" := 1;
            IF (DAS."Montant 4" > 0) AND (DAS."Durée 4" = 0) THEN
                DAS."Durée 4" := 1;
            DAS.MODIFY;
        UNTIL DAS.NEXT = 0;
        DAS.CALCFIELDS("Total annuel");
        Progression.CLOSE;

    end;

    /// <summary>
    /// GenererFichiersVirmCPA.
    /// </summary>
    /// <param name="P_Unite">Code[10].</param>
    /// <param name="P_Annee">Integer.</param>
    /// <param name="P_Chemin">Text[1000].</param>
    /// <param name="P_Type">Option N,C,R.</param>
    /// <param name="P_Mois">Integer.</param>
    /// <param name="P_CodeVirementCPA">Text[3].</param>
    procedure GenererFichiersVirmCPA(P_Unite: Code[10]; P_Annee: Integer; P_Chemin: Text[1000]; P_Type: Option N,C,R; P_Mois: Integer; P_CodeVirementCPA: Text[3]);
    begin
        UniteSociete.GET(P_Unite);
        BankAccount.SETRANGE("No.", UniteSociete."Payroll Bank Account");
        BankAccount.FINDFIRST;
        CASE P_Mois OF
            1:
                BEGIN
                    PeriodePaie := 'Paie Mois Janvier'
                END;
            2:
                BEGIN
                    PeriodePaie := 'Paie Mois Fevrier'
                END;
            3:
                BEGIN
                    PeriodePaie := 'Paie Mois Mars'
                END;
            4:
                BEGIN
                    PeriodePaie := 'Paie Mois Avril'
                END;
            5:
                BEGIN
                    PeriodePaie := 'Paie Mois Mai'
                END;
            6:
                BEGIN
                    PeriodePaie := 'Paie Mois Juin'
                END;
            7:
                BEGIN
                    PeriodePaie := 'Paie Mois Juillet'
                END;
            8:
                BEGIN
                    PeriodePaie := 'Paie Mois Aout'
                END;
            9:
                BEGIN
                    PeriodePaie := 'Paie Mois Septembre'
                END;
            10:
                BEGIN
                    PeriodePaie := 'Paie Mois Octobre'
                END;
            11:
                BEGIN
                    PeriodePaie := 'Paie Mois Novembre'
                END;
            12:
                BEGIN
                    PeriodePaie := 'Paie Mois Decembre'
                END;
        END;

        EcriturePaie.RESET;
        EcriturePaie.SETRANGE("Company Business Unit Code", P_Unite);
        EcriturePaie.SETFILTER("Document No.", '%1', '*' + FORMAT(P_Mois) + FORMAT(P_Annee) + '*');
        EcriturePaie.SETCURRENTKEY("Employee No.", "Document No.");
        Paie.GET(EcriturePaie."Document No.");

        //JourEndingPayrol:=DATE2DMY(Paie."Ending Date",1);
        JourEndingPayrol := DATE2DMY(WORKDATE(), 1);
        //Mois:=DATE2DMY(Paie."Ending Date",2);
        Mois := DATE2DMY(WORKDATE(), 2);
        //AnneeEndingPayrol:=DATE2DMY(Paie."Ending Date",3);
        AnneeEndingPayrol := DATE2DMY(WORKDATE(), 3);
        IF STRLEN(FORMAT(Mois)) = 1 THEN BEGIN
            MoisAnneeEndingPayrol := FORMAT(AnneeEndingPayrol) + '0' + FORMAT(Mois) + FORMAT(JourEndingPayrol);
        END ELSE
            MoisAnneeEndingPayrol := FORMAT(AnneeEndingPayrol) + FORMAT(Mois);

        NomFichierDetail := 'VIRM' + '.txt';
        //NomFichierDetail:=COPYSTR(FORMAT(P_Annee),3,2)+'S'+PADSTR(UniteSociete."Employer SS No.",10)+'.txt';
        //***Fichier détail***
        NomFichier := P_Chemin + NomFichierDetail;
        IF EXISTS(NomFichier) THEN
            ERASE(NomFichier);
        Fichier.WRITEMODE(TRUE);
        Fichier.TEXTMODE(TRUE);
        IF Fichier.CREATE(NomFichier) THEN BEGIN
            Numero := 0;
            DAS.RESET;
            DAS.FINDFIRST;
            DAS.CALCFIELDS("Total annuel CPA");
            LigneDetail := 'VIRM00401001' + PADSTR(BankAccount."Bank Account No.", 24) + PADSTR(UniteSociete.Name, 50) + PADSTR(UniteSociete.Address, 70) + PADSTR(MoisAnneeEndingPayrol, 8) + PADSTR(P_CodeVirementCPA, 3) + PADSTR('', 6 - STRLEN(FORMAT(DAS.COUNT)), '0')
            + FORMAT(DAS.COUNT)
            + PADSTR('', 16 - STRLEN(FORMAT(DAS."Total annuel CPA" * 100, 0, 2)), '0')
            + FORMAT(DAS."Total annuel CPA" * 100, 0, 2) + PADSTR('', 30);
            Fichier.WRITE(UPPERCASE(LigneDetail));
            REPEAT
                Numero := Numero + 1;
                Salarie.GET(DAS.Matricule);
                LigneDetail :=
                PADSTR((PADSTR('', 6 - STRLEN(FORMAT(Numero)), '0') + FORMAT(Numero)) + DAS."Matricule VIRM CPA", 35)
                + UPPERCASE(PADSTR(DAS.Nom + ' ' + DAS.Prénom, 50))
                + UPPERCASE(PADSTR(DAS.Address, 70))
                + PADSTR('', 15 - STRLEN(FORMAT(DAS."Montant 1" * 100, 0, 2)), '0')
                + FORMAT(DAS."Montant 1" * 100, 0, 2)
                + PADSTR(PeriodePaie, 70)
                + PADSTR('', 80);
                Fichier.WRITE(LigneDetail);
            UNTIL DAS.NEXT = 0;
            LigneDetail := PADSTR('FVIR', 99);
            Fichier.WRITE(LigneDetail);
            Fichier.CLOSE;
        END;
        MESSAGE('Génération du fichier de Virement CPA effectué avec succès.');
    end;

    /// <summary>
    /// GenererVirmCPA.
    /// </summary>
    /// <param name="P_Unite">Code[10].</param>
    /// <param name="P_Annee">Integer.</param>
    /// <param name="P_Mois">Integer.</param>
    procedure GenererVirmCPA(P_Unite: Code[10]; P_Annee: Integer; P_Mois: Integer);
    begin
        ParamPaie.GET;
        //***Montants***
        //JourEndingPayrol:=DATE2DMY(Paie."Ending Date",1);
        //JourEndingPayrol:=DATE2DMY(WORKDATE(),1);
        //Mois:=DATE2DMY(Paie."Ending Date",2);
        Mois := DATE2DMY(WORKDATE(), 2);
        //AnneeEndingPayrol:=DATE2DMY(Paie."Ending Date",3);
        AnneeEndingPayrol := DATE2DMY(WORKDATE(), 3);
        IF STRLEN(FORMAT(Mois)) = 1 THEN BEGIN
            MoisAnneeEndingPayrol := '0' + FORMAT(Mois) + COPYSTR(FORMAT(AnneeEndingPayrol), 3, 2);
        END ELSE
            MoisAnneeEndingPayrol := FORMAT(Mois) + COPYSTR(FORMAT(AnneeEndingPayrol), 3, 2);

        CASE P_Mois OF
            1:
                BEGIN
                    MoisVirmCPA := '01'
                END;
            2:
                BEGIN
                    MoisVirmCPA := '02'
                END;
            3:
                BEGIN
                    MoisVirmCPA := '03'
                END;
            4:
                BEGIN
                    MoisVirmCPA := '04'
                END;
            5:
                BEGIN
                    MoisVirmCPA := '05'
                END;
            6:
                BEGIN
                    MoisVirmCPA := '06'
                END;
            7:
                BEGIN
                    MoisVirmCPA := '07'
                END;
            8:
                BEGIN
                    MoisVirmCPA := '08'
                END;
            9:
                BEGIN
                    MoisVirmCPA := '09'
                END;
            10:
                BEGIN
                    MoisVirmCPA := '10'
                END;
            11:
                BEGIN
                    MoisVirmCPA := '11'
                END;
            12:
                BEGIN
                    MoisVirmCPA := '12'
                END;
        END;
        EcriturePaie.RESET;
        EcriturePaie.SETRANGE("Item Code", ParamPaie."Net Salary");
        EcriturePaie.SETRANGE("Company Business Unit Code", P_Unite);
        EcriturePaie.SETFILTER("Document No.", '%1', '*' + FORMAT(P_Mois) + FORMAT(P_Annee) + '*');
        EcriturePaie.SETCURRENTKEY("Employee No.", "Document No.");

        IF NOT EcriturePaie.FINDFIRST THEN
            ERROR(Text01, P_Mois, P_Annee);
        DAS.RESET;
        DAS.DELETEALL;
        Progression.OPEN('Traitement du salarié #1#######');
        REPEAT
            Progression.UPDATE(1, EcriturePaie."Employee No.");
            Salarie.GET(EcriturePaie."Employee No.");
            IF NOT DASBis.GET(EcriturePaie."Employee No.") THEN BEGIN
                DAS.INIT;
                DAS.Matricule := EcriturePaie."Employee No.";
                IF Salarie."CCP N" <> '' THEN BEGIN
                    DAS."Matricule VIRM CPA" := MoisAnneeEndingPayrol + '1' + Salarie."CCP N" + Salarie."RIB Key" //MoisVirmCPA+COPYSTR(FORMAT(P_Annee),3,2)
                END
                ELSE
                    IF (Salarie."Payroll Bank Account No." <> '') AND (Salarie."RIB Key" <> '') THEN BEGIN
                        DAS."Matricule VIRM CPA" := MoisAnneeEndingPayrol + '1' + Salarie."Payroll Bank Account No." + Salarie."RIB Key"//MoisVirmCPA+COPYSTR(FORMAT(P_Annee),3,2)
                    END ELSE
                        DAS."Matricule VIRM CPA" := MoisAnneeEndingPayrol + '1' + '00799999000000000000';//MoisVirmCPA+COPYSTR(FORMAT(P_Annee),3,2)

                DAS.Nom := Salarie."Last Name";
                DAS.Prénom := Salarie."First Name";
                DAS.Address := Salarie.Address;
                DAS.INSERT;
            END;
            DAS.GET(EcriturePaie."Employee No.");
            Paie.GET(EcriturePaie."Document No.");
            Mois := DATE2DMY(Paie."Ending Date", 2);

            EcriturePaieBis.RESET;
            EcriturePaieBis.SETRANGE("Document No.", EcriturePaie."Document No.");
            EcriturePaieBis.SETRANGE("Employee No.", EcriturePaie."Employee No.");
            EcriturePaieBis.SETRANGE("Item Code", ParamPaie."Net Salary");
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
                1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12:
                    BEGIN
                        DAS."Montant 1" := DAS."Montant 1" + EcriturePaie.Amount;
                        DAS."Montant annuel" := DAS."Montant annuel" + EcriturePaie.Amount;
                        /*  IF Paie."Regular Payroll" THEN
                            CASE Salarie.Regime OF
                              Salarie.Regime::Mensuel :
                                DAS."Durée 1":=ROUND(DAS."Durée 1"+Duree-ArchivePaieEntete."Total Absences Days"
                                -ArchivePaieEntete."Total Absences Hours"/ParamPaie."No. of Hours By Day",1,'>');
                              Salarie.Regime::"Vacataire journalier" :
                                DAS."Durée 1":=ROUND(DAS."Durée 1"+Duree-ArchivePaieEntete."Total Absences Days",1,'>');
                              Salarie.Regime::"Vacataire horaire":
                                DAS."Durée 1":=ROUND(DAS."Durée 1"+Duree-ArchivePaieEntete."Total Absences Hours"
                                -ArchivePaieEntete."Total Absences Days"*ParamPaie."No. of Hours By Day",1,'>');
                            END;*/
                    END;
            END;
            DAS.MODIFY;
        UNTIL EcriturePaie.NEXT = 0;
        //***Régularisation des cas particuliers***
        DAS.RESET;
        DAS.FINDFIRST;
        REPEAT
            IF (DAS."Montant 1" > 0) AND (DAS."Durée 1" = 0) THEN
                DAS."Durée 1" := 1;
            IF (DAS."Montant 2" > 0) AND (DAS."Durée 2" = 0) THEN
                DAS."Durée 2" := 1;
            IF (DAS."Montant 3" > 0) AND (DAS."Durée 3" = 0) THEN
                DAS."Durée 3" := 1;
            IF (DAS."Montant 4" > 0) AND (DAS."Durée 4" = 0) THEN
                DAS."Durée 4" := 1;
            DAS.MODIFY;
        UNTIL DAS.NEXT = 0;
        Progression.CLOSE;

    end;
}

