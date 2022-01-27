/// <summary>
/// Codeunit Journal de paie (ID 52182435).
/// </summary>
codeunit 52182435 "Journal de paie"
//codeunit 39108408 "Journal de paie"
{
    // version HALRHPAIE.6.2.01


    trigger OnRun();
    begin
    end;

    var
        TableDonnees2: Record "Journal de paie";
        TableDonnees: Record "Journal de paie";
        Compteur: Integer;
        Rubrique: Record "Payroll Item";
        EcriturePaie: Record "Payroll Entry";
        NumSalarie: Text[30];
        Salarie: Record 5200;
        Matricule: Text[30];
        Nom: Text[30];
        Prenom: Text[30];
        SitFamille: Text[30];
        Affectation: Text[30];
        Fonction: Text[30];
        "Période": Text[30];
        "DuréeTravail": Text[30];
        i: Integer;
        SituationF: Integer;
        SituationFM: Text[30];
        EmployeePayrollItem: Record "Employee Payroll Item";
        EcriturePaie2: Record "Payroll Entry";
        NbreLignes: Integer;
        ParamPaie: Record Payroll_Setup;
        j: Integer;
        k: Integer;
        Date: Code[20];
        NbreJoursAbsence: Decimal;
        Paie: Record Payroll;
        EmployeeRelative: Record 5205;
        nbreEnfant: Integer;
        struct: Record Structure;
        Nbre: Decimal;
        EcriturePaie3: Record "Payroll Entry";
        RubriqueSalarie: Record "Payroll Entry";
        TotalisationJournal: Record "Payroll Book Totalisation";
        TotalisationJournal2: Record "Payroll Book Totalisation";
        Montant: Decimal;
        Total: Decimal;
        ArchivePaieEntete: Record "Payroll Archive Header";
        SalariePaie1: Record "Payroll Employee";
        SalariePaie2: Record "Payroll Employee";
        NbreRubriques: Integer;
        Effectif: Integer;
        NbrePages: Integer;
        Iteration: Integer;

    /// <summary>
    /// RemplirTable.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <param name="P_NbreSections">VAR Integer.</param>
    procedure RemplirTable(P_Paie: Code[20]; P_Salarie: Code[20]; var P_NbreSections: Integer);
    begin
        Paie.GET(P_Paie);
        TableDonnees.DELETEALL;
        Compteur := 1;
        TableDonnees.INIT;
        TableDonnees."Entry No." := Compteur;
        TableDonnees.Description := 'Matricule';
        TableDonnees.INSERT;
        Compteur := Compteur + 1;
        TableDonnees."Entry No." := Compteur;
        TableDonnees.Description := 'Nom';
        TableDonnees.INSERT;
        Compteur := Compteur + 1;
        TableDonnees."Entry No." := Compteur;
        TableDonnees.Description := 'Prénom';
        TableDonnees.INSERT;
        Compteur := Compteur + 1;
        TableDonnees."Entry No." := Compteur;
        TableDonnees.Description := 'Sit. familiale';
        TableDonnees.INSERT;
        Compteur := Compteur + 1;
        TableDonnees."Entry No." := Compteur;
        TableDonnees.Description := 'Fonction';
        TableDonnees.INSERT;
        Compteur := Compteur + 1;
        TableDonnees."Entry No." := Compteur;
        TableDonnees.Description := 'Durée travaillée';
        TableDonnees.INSERT;
        Compteur := Compteur + 1;
        TableDonnees."Entry No." := Compteur;
        TableDonnees.Description := 'RUB.        REPORT         EFF.                               INTITULE';
        TableDonnees."Intitules Report" := '  A REPORTER      EFF.';
        TableDonnees.INSERT;
        NbreLignes := Compteur;
        Rubrique.RESET;
        Rubrique.SETRANGE(Category, Rubrique.Category::Employee);
        Rubrique.FINDFIRST;
        REPEAT
            NbreLignes := NbreLignes + 1;
            Compteur := Compteur + 1;
            TableDonnees."Entry No." := Compteur;
            TableDonnees."Item Code" := Rubrique.Code;
            TableDonnees.Description := Rubrique.Description;
            TableDonnees.INSERT;
        UNTIL Rubrique.NEXT = 0;
        IF P_NbreSections > 1 THEN BEGIN
            i := P_NbreSections;
            REPEAT
                TableDonnees.INIT;
                Compteur := Compteur + 1;
                TableDonnees."Entry No." := Compteur;
                TableDonnees.Description := 'Matricule';
                TableDonnees.INSERT;
                Compteur := Compteur + 1;
                TableDonnees."Entry No." := Compteur;
                TableDonnees.Description := 'Nom';
                TableDonnees.INSERT;
                Compteur := Compteur + 1;
                TableDonnees."Entry No." := Compteur;
                TableDonnees.Description := 'Prénom';
                TableDonnees.INSERT;
                Compteur := Compteur + 1;
                TableDonnees."Entry No." := Compteur;
                TableDonnees.Description := 'Sit. Familiale';
                TableDonnees.INSERT;
                Compteur := Compteur + 1;
                TableDonnees."Entry No." := Compteur;
                TableDonnees.Description := 'Fonction';
                TableDonnees.INSERT;
                Compteur := Compteur + 1;
                TableDonnees."Entry No." := Compteur;
                TableDonnees.Description := 'Durée travaillée';
                TableDonnees.INSERT;
                Compteur := Compteur + 1;
                TableDonnees."Entry No." := Compteur;
                TableDonnees.Description := 'RUB.        REPORT         EFF.                               INTITULE';
                TableDonnees."Intitules Report" := '  A REPORTER      EFF.';
                TableDonnees.INSERT;
                Rubrique.FINDFIRST;
                REPEAT
                    Compteur := Compteur + 1;
                    TableDonnees."Entry No." := Compteur;
                    TableDonnees."Item Code" := Rubrique.Code;
                    TableDonnees.Description := Rubrique.Description;
                    TableDonnees.INSERT;
                UNTIL Rubrique.NEXT = 0;
                i := i - 1;
            UNTIL i = 1;
        END;
        EcriturePaie.RESET;
        EcriturePaie.SETRANGE("Document No.", P_Paie);
        EcriturePaie.FINDFIRST;
        NumSalarie := P_Salarie;
        k := P_NbreSections;
        REPEAT
        BEGIN
            i := 1;
            REPEAT
            BEGIN
                WHILE (NumSalarie <> EcriturePaie."Employee No.") DO EcriturePaie.NEXT;
                IF NumSalarie = EcriturePaie."Employee No." THEN BEGIN
                    nbreEnfant := 0;
                    EmployeeRelative.RESET;
                    EmployeeRelative.SETRANGE("Employee No.", NumSalarie);
                    IF EmployeeRelative.FINDSET THEN BEGIN
                        EmployeeRelative.FINDFIRST;
                        REPEAT
                            nbreEnfant := nbreEnfant + 1;
                        UNTIL EmployeeRelative.NEXT = 0;
                    END;
                    Salarie.GET(NumSalarie);
                    TableDonnees.GET(NbreLignes * (P_NbreSections - k) + 1);
                    insererE(i, NumSalarie);
                    TableDonnees.NEXT;
                    insererE(i, Salarie."Last Name");
                    TableDonnees.NEXT;
                    insererE(i, Salarie."First Name");
                    TableDonnees.NEXT;
                    SituationF := Salarie."Marital Status";
                    IF SituationF = 1 THEN SituationFM := 'C';
                    IF SituationF = 2 THEN SituationFM := 'M';
                    IF SituationF = 3 THEN SituationFM := 'D';
                    IF SituationF = 4 THEN SituationFM := 'V';
                    IF (nbreEnfant < 10) THEN
                        SituationFM := SituationFM + ' 0' + FORMAT(nbreEnfant)
                    ELSE
                        SituationFM := SituationFM + ' ' + FORMAT(nbreEnfant);
                    insererE(i, SituationFM);
                    TableDonnees.NEXT;
                    insererE(i, Salarie."Job Title");
                    TableDonnees.NEXT;
                    insererE(i, DureeTravaillee(P_Paie, NumSalarie));
                    TableDonnees.NEXT;

                    j := NbreLignes - 8 + 2;
                    REPEAT
                        RubriqueSalarié(P_Paie, NumSalarie, TableDonnees."Item Code");
                        j := j - 1;
                        TableDonnees.NEXT;
                    UNTIL j = 0;
                END;

                WHILE (NumSalarie = EcriturePaie."Employee No.") AND (EcriturePaie.NEXT <> 0) DO;
                IF (NumSalarie <> EcriturePaie."Employee No.") THEN
                    NumSalarie := EcriturePaie."Employee No."

                ELSE BEGIN
                    P_Salarie := NumSalarie;
                    P_NbreSections := Compteur;
                    EXIT;
                END;
                i := i + 1;
            END;
            UNTIL (i = 8);

            k := k - 1;
        END;
        UNTIL (k = 0);
    end;

    procedure "RubriqueSalarié"(P_codepaie: Code[20]; P_mat: Code[20]; P_Rubrique: Code[20]);
    begin
        EcriturePaie2.RESET;
        EcriturePaie2.SETRANGE("Document No.", P_codepaie);
        EcriturePaie2.SETRANGE("Employee No.", P_mat);
        EcriturePaie2.SETRANGE("Item Code", P_Rubrique);
        IF (EcriturePaie2.FINDSET) THEN BEGIN
            EcriturePaie2.FINDFIRST;
            IF (EcriturePaie2.Amount MOD 1 = 0) THEN
                insererE(i, FORMAT(ROUND(EcriturePaie2.Amount)) + ',00')//AJout affichage decimales
            ELSE
                IF (EcriturePaie2.Amount MOD 0.1 = 0) THEN
                    insererE(i, FORMAT(ROUND(EcriturePaie2.Amount)) + '0')
                ELSE
                    insererE(i, FORMAT((ROUND((EcriturePaie2.Amount) * 100) DIV 1) / 100));
        END;
    end;

    /// <summary>
    /// insererE.
    /// </summary>
    /// <param name="P_i">Integer.</param>
    /// <param name="Champs">Text[80].</param>
    procedure insererE(P_i: Integer; Champs: Text[80]);
    begin
        CASE P_i OF
            1:
                TableDonnees."Employee 1" := Champs;
            2:
                TableDonnees."Employee 2" := Champs;
            3:
                TableDonnees."Employee 3" := Champs;
            4:
                TableDonnees."Employee 4" := Champs;
            5:
                TableDonnees."Employee 5" := Champs;
            6:
                TableDonnees."Employee 6" := Champs;
            7:
                TableDonnees."Employee 7" := Champs;
            8:
                TableDonnees."Employee 8" := Champs;
            9:
                TableDonnees."Employee 9" := Champs;
        END;
        TableDonnees.MODIFY;
    end;

    /// <summary>
    /// RepererSalaries.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_NbrePages">VAR Integer.</param>
    procedure RepererSalaries(P_Paie: Code[20]; var P_NbrePages: Integer);
    begin
        ParamPaie.GET;
        ArchivePaieEntete.RESET;
        ArchivePaieEntete.SETRANGE("Payroll Code", P_Paie);
        IF ArchivePaieEntete.FINDFIRST THEN
            REPEAT
                IF NOT SalariePaie1.GET(ArchivePaieEntete."No.") THEN BEGIN
                    SalariePaie2.INIT;
                    SalariePaie2."Employee No." := ArchivePaieEntete."No.";
                    SalariePaie2.INSERT;
                END;
            UNTIL ArchivePaieEntete.NEXT = 0;
        SalariePaie1.RESET;
        NbreLignes := SalariePaie1.COUNT;
        P_NbrePages := NbreLignes DIV 7;
        IF NbreLignes MOD 7 > 0 THEN
            P_NbrePages := P_NbrePages + 1;
    end;

    /// <summary>
    /// Nettoyage.
    /// </summary>
    procedure Nettoyage();
    begin
        TableDonnees.FINDFIRST;
        REPEAT
            IF TableDonnees."Employee 1" = '0' THEN BEGIN TableDonnees."Employee 1" := ''; TableDonnees.MODIFY; END;
            IF TableDonnees."Employee 2" = '0' THEN BEGIN TableDonnees."Employee 2" := ''; TableDonnees.MODIFY; END;
            IF TableDonnees."Employee 3" = '0' THEN BEGIN TableDonnees."Employee 3" := ''; TableDonnees.MODIFY; END;
            IF TableDonnees."Employee 4" = '0' THEN BEGIN TableDonnees."Employee 4" := ''; TableDonnees.MODIFY; END;
            IF TableDonnees."Employee 5" = '0' THEN BEGIN TableDonnees."Employee 5" := ''; TableDonnees.MODIFY; END;
            IF TableDonnees."Employee 6" = '0' THEN BEGIN TableDonnees."Employee 6" := ''; TableDonnees.MODIFY; END;
            IF TableDonnees."Employee 7" = '0' THEN BEGIN TableDonnees."Employee 7" := ''; TableDonnees.MODIFY; END;
            IF TableDonnees."Employee 8" = '0' THEN BEGIN TableDonnees."Employee 8" := ''; TableDonnees.MODIFY; END;
            IF TableDonnees."Employee 9" = '0' THEN BEGIN TableDonnees."Employee 9" := ''; TableDonnees.MODIFY; END;
        UNTIL TableDonnees.NEXT = 0;
    end;

    /// <summary>
    /// DureeTravaillee.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <returns>Return variable Heure of type Text[30].</returns>
    procedure DureeTravaillee(P_Paie: Code[20]; P_Salarie: Code[20]) Heure: Text[30];
    begin
        ParamPaie.GET;
        ArchivePaieEntete.GET(P_Paie, P_Salarie);
        NbreJoursAbsence := ArchivePaieEntete."Total Absences Days" + ArchivePaieEntete."Total Absences Hours" / ParamPaie."No. of Hours By Day";
        IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
            EXIT(FORMAT(ROUND(ParamPaie."No. of Worked Days" - NbreJoursAbsence)) + ' J')
        ELSE BEGIN
            ArchivePaieEntete.GET(P_Paie, P_Salarie);
            IF ArchivePaieEntete.Regime = ArchivePaieEntete.Regime::"Vacataire horaire" THEN BEGIN
                EcriturePaie3.RESET;
                EcriturePaie3.SETRANGE("Document No.", P_Paie);
                EcriturePaie3.SETRANGE("Employee No.", P_Salarie);
                EcriturePaie3.SETRANGE("Item Code", ParamPaie."No. of Hours (Hourly Vacatary)");
                Nbre := 0;
                IF EcriturePaie3.FINDFIRST THEN
                    Nbre := EcriturePaie3.Number;
                EXIT(FORMAT(Nbre) + ' H');
            END;
            IF ArchivePaieEntete.Regime = ArchivePaieEntete.Regime::"Vacataire journalier" THEN BEGIN
                EcriturePaie3.RESET;
                EcriturePaie3.SETRANGE("Document No.", P_Paie);
                EcriturePaie3.SETRANGE("Employee No.", P_Salarie);
                EcriturePaie3.SETRANGE("Item Code", ParamPaie."No. of Days (Daily Vacatary)");
                Nbre := 0;
                IF EcriturePaie3.FINDFIRST THEN
                    Nbre := EcriturePaie3.Number;
                EXIT(FORMAT(Nbre) + ' J');
            END
            ELSE
                EXIT(FORMAT(ROUND(ParamPaie."No. of Worked Days" - NbreJoursAbsence)) + ' J');
        END;
    end;

    /// <summary>
    /// TotaliserRubriquesJournal.
    /// </summary>
    procedure TotaliserRubriquesJournal();
    begin
        TotalisationJournal.RESET;
        TotalisationJournal.DELETEALL;
        TableDonnees.RESET;
        TableDonnees.SETFILTER("Item Code", '<>%1', '');
        TableDonnees.FINDFIRST;
        REPEAT
            IF NOT TotalisationJournal.GET(TableDonnees."Item Code") THEN BEGIN
                TotalisationJournal2.INIT;
                TotalisationJournal2."Item Code" := TableDonnees."Item Code";
                TotalisationJournal2.Description := TableDonnees.Description;
                TotalisationJournal2.Amount := 0;
                TotalisationJournal2.INSERT;
            END;
            TotalisationJournal.GET(TableDonnees."Item Code");
            Total := ROUND(TotalisationJournal.Amount);
            IF TableDonnees."Employee 1" <> '' THEN BEGIN
                EVALUATE(Montant, TableDonnees."Employee 1");
                Total := Total + Montant;
            END;
            IF TableDonnees."Employee 2" <> '' THEN BEGIN
                EVALUATE(Montant, TableDonnees."Employee 2");
                Total := Total + Montant;
            END;
            IF TableDonnees."Employee 3" <> '' THEN BEGIN
                EVALUATE(Montant, TableDonnees."Employee 3");
                Total := Total + Montant;
            END;
            IF TableDonnees."Employee 4" <> '' THEN BEGIN
                EVALUATE(Montant, TableDonnees."Employee 4");
                Total := Total + Montant;
            END;
            IF TableDonnees."Employee 5" <> '' THEN BEGIN
                EVALUATE(Montant, TableDonnees."Employee 5");
                Total := Total + Montant;
            END;
            IF TableDonnees."Employee 6" <> '' THEN BEGIN
                EVALUATE(Montant, TableDonnees."Employee 6");
                Total := Total + Montant;
            END;
            IF TableDonnees."Employee 7" <> '' THEN BEGIN
                EVALUATE(Montant, TableDonnees."Employee 7");
                Total := Total + Montant;
            END;
            TotalisationJournal.Amount := ROUND(Total);
            TotalisationJournal.MODIFY;
        UNTIL TableDonnees.NEXT = 0;
    end;

    /// <summary>
    /// CalculerReports.
    /// </summary>
    procedure CalculerReports();
    begin
        Rubrique.RESET;
        Rubrique.SETRANGE(Category, Rubrique.Category::Employee);
        NbreRubriques := Rubrique.COUNT;
        TableDonnees.RESET;
        TableDonnees.SETFILTER("Item Code", '<>%1', '');
        NbrePages := TableDonnees.COUNT / NbreRubriques;
        FOR i := 1 TO NbrePages DO BEGIN
            TableDonnees.GET(8 + (NbreRubriques + 7) * (i - 1));
            FOR j := 1 TO NbreRubriques DO BEGIN
                IF i = 1 THEN BEGIN
                    Total := 0;
                    Effectif := 0;
                END
                ELSE BEGIN
                    TableDonnees2.GET(TableDonnees."Entry No." - NbreRubriques - 7);
                    TableDonnees."Report Mnt Gauche" := TableDonnees2."Report Mnt Droite";
                    TableDonnees."Report Eff Gauche" := TableDonnees2."Report Eff Droite";
                    TableDonnees.MODIFY;
                    Total := TableDonnees2."Report Mnt Droite";
                    Effectif := TableDonnees2."Report Eff Droite";
                END;
                IF TableDonnees."Employee 1" <> '' THEN BEGIN
                    EVALUATE(Montant, TableDonnees."Employee 1");
                    Total := Total + Montant;
                    Effectif := Effectif + 1;
                END;
                IF TableDonnees."Employee 2" <> '' THEN BEGIN
                    EVALUATE(Montant, TableDonnees."Employee 2");
                    Total := Total + Montant;
                    Effectif := Effectif + 1;
                END;
                IF TableDonnees."Employee 3" <> '' THEN BEGIN
                    EVALUATE(Montant, TableDonnees."Employee 3");
                    Total := Total + Montant;
                    Effectif := Effectif + 1;
                END;
                IF TableDonnees."Employee 4" <> '' THEN BEGIN
                    EVALUATE(Montant, TableDonnees."Employee 4");
                    Total := Total + Montant;
                    Effectif := Effectif + 1;
                END;
                IF TableDonnees."Employee 5" <> '' THEN BEGIN
                    EVALUATE(Montant, TableDonnees."Employee 5");
                    Total := Total + Montant;
                    Effectif := Effectif + 1;
                END;
                IF TableDonnees."Employee 6" <> '' THEN BEGIN
                    EVALUATE(Montant, TableDonnees."Employee 6");
                    Total := Total + Montant;
                    Effectif := Effectif + 1;
                END;
                IF TableDonnees."Employee 7" <> '' THEN BEGIN
                    EVALUATE(Montant, TableDonnees."Employee 7");
                    Total := Total + Montant;
                    Effectif := Effectif + 1;
                END;
                TableDonnees."Report Mnt Droite" := Total;
                TableDonnees."Report Eff Droite" := Effectif;
                TableDonnees.MODIFY;
                TableDonnees.NEXT;
            END;
        END;
    end;
}

