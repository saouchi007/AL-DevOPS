/// <summary>
/// Codeunit Masse salariale (ID 52182444).
/// </summary>
codeunit 52182444 "Masse salariale"
//codeunit 39108417 "Masse salariale"
{
    // version HALRHPAIE.6.2.01

    // 01    25/01/2012   Amélioration de l'état Masse salariale
    // //Cacobatph & pretbath
    // //Non Imposable et Non cotisable
    // //Imposable et Non cotisable


    trigger OnRun();
    begin
        //MESSAGE('%1',NonImposableNonCotisable('PAIE012020','000151'));
    end;

    var
        ArchivePaieLigne: Record "Payroll Archive Line";
        ParamPaie: Record Payroll_Setup;
        MasseSalariale: Record "Masse salariale";
        i: Integer;
        Annee1: Date;
        Annee2: Date;
        Paie: Record Payroll;
        ArchivePaieEntete: Record "Payroll Archive Header";
        Structure2: Record Structure;
        n: Integer;
        SalarieMasseSalariale: Record "Salarie masse salariale";
        ch: Code[50];
        Text01: Label 'Aucune paie calculée durant la période choisie !';
        Montant: Decimal;
        Structure: Record Structure;
        CategorieSocioProfess: Record "Socio-professional Category";
        Fonction: Record Function;
        Position: Integer;
        MontantNonImposable: Decimal;

    /// <summary>
    /// RemplirLigne.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <param name="P_Structure">Code[20].</param>
    /// <param name="P_Categorie">Code[20].</param>
    procedure RemplirLigne(P_Paie: Code[20]; P_Salarie: Code[20]; P_Structure: Code[20]; P_Categorie: Code[20]);
    begin
        IF NOT MasseSalariale.GET(P_Structure, P_Categorie) THEN BEGIN
            MasseSalariale.INIT;
            IF P_Structure = '' THEN BEGIN
                MasseSalariale.CodeStructure := '';
                MasseSalariale.DesignationStructure := '';
            END
            ELSE BEGIN
                Structure2.GET(P_Structure);
                MasseSalariale.CodeStructure := P_Structure;
                MasseSalariale.DesignationStructure := Structure2.Description;
            END;
            MasseSalariale.Categorie := P_Categorie;
            MasseSalariale.INSERT;
        END;
        IF NOT SalarieMasseSalariale.GET(P_Salarie, P_Structure, P_Categorie) THEN BEGIN
            SalarieMasseSalariale.INIT;
            SalarieMasseSalariale.Salarie := P_Salarie;
            SalarieMasseSalariale.Structure := P_Structure;
            SalarieMasseSalariale.Categorie := P_Categorie;
            SalarieMasseSalariale.INSERT;
            MasseSalariale.NbreSalaries := MasseSalariale.NbreSalaries + 1;
        END;
        Montant := 0;
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."Base Salary")
        OR ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."No. of Days (Daily Vacatary)")//SOU
        THEN
            Montant := ABS(ArchivePaieLigne.Amount);
        MasseSalariale.SalaireBase := MasseSalariale.SalaireBase + Montant;
        Montant := 0;
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."Post Salary") THEN
            Montant := ABS(ArchivePaieLigne.Amount);
        MasseSalariale.Cotisable := MasseSalariale.Cotisable + Montant;
        Montant := 0;
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."Taxable Salary") THEN
            Montant := ABS(ArchivePaieLigne.Basis);
        MasseSalariale.Imposable := MasseSalariale.Imposable + Montant;
        MasseSalariale.NonImposable := MasseSalariale.NonImposable + NonImposable(P_Paie, P_Salarie);
        //Imposable et Non cotisable
        MasseSalariale."Imposable Non Cotisable" := MasseSalariale."Imposable Non Cotisable" + ImposableNonCotisable(P_Paie, P_Salarie);
        //Imposable et Non cotisable
        //Non Imposable et Non cotisable
        MasseSalariale."Non Imposable Non cotisable" := MasseSalariale."Non Imposable Non cotisable" + NonImposableNonCotisable(P_Paie, P_Salarie);
        //Non Imposable et Non cotisable
        Montant := 0;
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."Net Salary") THEN
            Montant := ABS(ArchivePaieLigne.Amount);
        MasseSalariale.FraisPersonnel := MasseSalariale.FraisPersonnel + Montant;
        Montant := 0;
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."Employee SS Deduction") THEN
            Montant := ABS(ArchivePaieLigne.Amount);
        MasseSalariale.AutresCharges := MasseSalariale.AutresCharges + Montant;
        Montant := 0;
        //Cacobatph & pretbath
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."Employer Cotisation Cacobaptph") THEN
            Montant := ABS(ArchivePaieLigne.Amount);
        MasseSalariale.Cacobatph := MasseSalariale.Cacobatph + Montant;
        Montant := 0;
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."Employer Cotisation pretbath") THEN
            Montant := ABS(ArchivePaieLigne.Amount);
        MasseSalariale.Pretbath := MasseSalariale.Pretbath + Montant;
        //Cacobatph & pretbath
        Montant := 0;
        //MODIFIE SOUHILA INCLURE TOUS LES IRG
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."TIT Deduction")
        THEN
            Montant := ABS(ArchivePaieLigne.Amount);
        MasseSalariale.ChargesFiscales := MasseSalariale.ChargesFiscales + Montant;
        Montant := 0;
        //tous irg
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."TIT Out of Grid")
        OR ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."Leave TIT")
        THEN
            Montant := ABS(ArchivePaieLigne.Amount);
        MasseSalariale.ChargesFiscales := MasseSalariale.ChargesFiscales + Montant;
        Montant := 0;
        IF ArchivePaieLigne.GET(P_Salarie, P_Paie, ParamPaie."Employer Cotisation") THEN
            Montant := ABS(ArchivePaieLigne.Amount);
        MasseSalariale.ChargesSociales := MasseSalariale.ChargesSociales + Montant;


        MasseSalariale.MODIFY;
    end;

    /// <summary>
    /// NonImposable.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure NonImposable(P_Paie: Code[20]; P_Salarie: Code[20]): Decimal;
    begin
        MontantNonImposable := 0;
        ArchivePaieLigne.RESET;
        ArchivePaieLigne.SETRANGE("Payroll Code", P_Paie);
        ArchivePaieLigne.SETRANGE("Employee No.", P_Salarie);
        REPEAT
            FOR i := 601 TO 998 DO
                IF (FORMAT(i) = ArchivePaieLigne."Item Code") AND (ArchivePaieLigne."Item Code" <> ParamPaie."TIT Deduction")
                AND (ArchivePaieLigne."Item Code" <> ParamPaie."TIT Out of Grid") THEN
                    MontantNonImposable := MontantNonImposable + ABS(ArchivePaieLigne.Amount);
        UNTIL ArchivePaieLigne.NEXT = 0;
        EXIT(MontantNonImposable);
    end;

    /// <summary>
    /// Traitement.
    /// </summary>
    /// <param name="P_MoisDebut">Integer.</param>
    /// <param name="P_MoisFin">Integer.</param>
    /// <param name="P_Annee">Integer.</param>
    /// <param name="P_Unite">Code[20].</param>
    /// <param name="P_FiltreStructure">Text[200].</param>
    /// <param name="P_FiltreCategorie">Text[200].</param>
    /// <param name="P_FiltreFonction">Text[200].</param>
    procedure Traitement(P_MoisDebut: Integer; P_MoisFin: Integer; P_Annee: Integer; P_Unite: Code[20]; P_FiltreStructure: Text[200]; P_FiltreCategorie: Text[200]; P_FiltreFonction: Text[200]);
    begin
        ParamPaie.GET;
        SalarieMasseSalariale.DELETEALL;
        MasseSalariale.DELETEALL;
        n := 0;
        Annee1 := DMY2DATE(1, P_MoisDebut, P_Annee);
        CASE P_MoisFin OF
            1, 3, 5, 7, 8, 10, 12:
                Annee2 := DMY2DATE(31, P_MoisFin, P_Annee);
            4, 6, 9, 11:
                Annee2 := DMY2DATE(30, P_MoisFin, P_Annee);
            2:
                IF P_Annee MOD 4 = 0 THEN
                    Annee2 := DMY2DATE(29, P_MoisFin, P_Annee)
                ELSE
                    Annee2 := DMY2DATE(28, P_MoisFin, P_Annee)
        END;
        Paie.RESET;
        Paie.SETRANGE("Company Business Unit Code", P_Unite);
        IF Paie.FINDFIRST THEN
            REPEAT
                IF (Paie."Ending Date" >= Annee1) AND (Paie."Ending Date" <= Annee2) THEN BEGIN
                    ArchivePaieEntete.RESET;
                    ArchivePaieEntete.SETRANGE("Payroll Code", Paie.Code);
                    ArchivePaieEntete.SETFILTER("Structure Code", COPYSTR(P_FiltreStructure, 7, 50));
                    ArchivePaieEntete.SETFILTER("Socio-Professional Category", COPYSTR(P_FiltreCategorie, 7, 50));
                    ArchivePaieEntete.SETFILTER("Function Code", COPYSTR(P_FiltreFonction, 7, 50));
                    IF ArchivePaieEntete.FINDFIRST THEN
                        REPEAT
                            n := n + 1;
                            RemplirLigne(Paie.Code, ArchivePaieEntete."No.",
                            ArchivePaieEntete."Structure Code", ArchivePaieEntete."Socio-Professional Category");
                        UNTIL ArchivePaieEntete.NEXT = 0;
                END;
            UNTIL Paie.NEXT = 0;
        MasseSalariale.RESET;
        IF MasseSalariale.FINDFIRST THEN
            REPEAT
                //old code
                //MasseSalariale.TotalMasseSalariale:=MasseSalariale.FraisPersonnel+MasseSalariale.ChargesSociales+MasseSalariale.ChargesFiscales
                // +MasseSalariale.AutresCharges;
                //old code
                //new code 01
                //Cacobatph & pretbath
                MasseSalariale.TotalMasseSalariale := MasseSalariale.Cotisable + MasseSalariale.Cacobatph + MasseSalariale.Pretbath + MasseSalariale.ChargesSociales + MasseSalariale."Non Imposable Non cotisable" + MasseSalariale."Imposable Non Cotisable";
                //Cacobatph & pretbath
                //Non Imposable et Non cotisable
                //new code      01
                MasseSalariale.MODIFY;
            UNTIL MasseSalariale.NEXT = 0;
        IF MasseSalariale.ISEMPTY THEN
            ERROR(Text01);
    end;

    /// <summary>
    /// ValeurDansFiltre.
    /// </summary>
    /// <param name="Filtre">Text[200].</param>
    /// <param name="Valeur">Text[20].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ValeurDansFiltre(Filtre: Text[200]; Valeur: Text[20]): Boolean;
    begin
        IF Filtre = '' THEN
            EXIT(TRUE)
        ELSE BEGIN
            IF Valeur = '' THEN
                EXIT(FALSE)
            ELSE BEGIN
                Position := STRPOS(Filtre, Valeur);
                IF ((Position + STRLEN(Valeur) > STRLEN(Filtre)) OR (Filtre[Position + STRLEN(Valeur)] = '|')) THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE);
            END;
        END;
    end;

    /// <summary>
    /// NonImposableNonCotisable.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure NonImposableNonCotisable(P_Paie: Code[20]; P_Salarie: Code[20]): Decimal;
    var
        PayrollItem: Record "Payroll Item";
    begin
        MontantNonImposable := 0;
        PayrollItem.RESET;
        PayrollItem.SETRANGE("Non Cotisable Non Imposable", TRUE);
        IF PayrollItem.FINDFIRST THEN BEGIN
            REPEAT
                ArchivePaieLigne.RESET;
                ArchivePaieLigne.SETRANGE("Payroll Code", P_Paie);
                ArchivePaieLigne.SETRANGE("Employee No.", P_Salarie);
                IF ArchivePaieLigne.FINDFIRST THEN
                    REPEAT
                        IF (PayrollItem.Code = ArchivePaieLigne."Item Code") THEN
                            MontantNonImposable := MontantNonImposable + ABS(ArchivePaieLigne.Amount);
                    UNTIL ArchivePaieLigne.NEXT = 0;
            UNTIL PayrollItem.NEXT = 0;
            EXIT(MontantNonImposable);
        END;
    end;

    /// <summary>
    /// ImposableNonCotisable.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure ImposableNonCotisable(P_Paie: Code[20]; P_Salarie: Code[20]): Decimal;
    var
        PayrollItem: Record "Payroll Item";
    begin
        MontantNonImposable := 0;
        PayrollItem.RESET;
        PayrollItem.SETRANGE("Non Cotisable et Imposable", TRUE);
        IF PayrollItem.FINDFIRST THEN BEGIN
            REPEAT
                ArchivePaieLigne.RESET;
                ArchivePaieLigne.SETRANGE("Payroll Code", P_Paie);
                ArchivePaieLigne.SETRANGE("Employee No.", P_Salarie);
                IF ArchivePaieLigne.FINDFIRST THEN
                    REPEAT
                        IF (PayrollItem.Code = ArchivePaieLigne."Item Code") THEN
                            MontantNonImposable := MontantNonImposable + ABS(ArchivePaieLigne.Amount);
                    UNTIL ArchivePaieLigne.NEXT = 0;
            UNTIL PayrollItem.NEXT = 0;
            EXIT(MontantNonImposable);
        END;
    end;
}

