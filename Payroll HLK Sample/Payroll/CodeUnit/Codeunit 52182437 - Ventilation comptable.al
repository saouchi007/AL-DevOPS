/// <summary>
/// Codeunit Ventilation comptable (ID 52182437).
/// </summary>
codeunit 52182437 "Ventilation comptable"
//codeunit 39108410 "Ventilation comptable"
{
    // version HALRHPAIE.6.2.00


    trigger OnRun();
    begin
    end;

    var
        Rubrique: Record "Payroll Item";
        Compteur: Integer;
        TabVentilationComptable: Record "Tab Ventilation Comptable";
        LigneArchivePaie: Record "Payroll Archive Line";
        ParamPaie: Record Payroll_Setup;
        Gain: Decimal;
        Retenue: Decimal;
        Salarie: Record 5200;
        HistTransactPaie: Record "Payroll Register";
        Annee: Integer;
        Mois: Integer;
        g1: Decimal;
        r1: Decimal;
        Gain1: Decimal;
        Retenue1: Decimal;
        Base1: Decimal;
        Nombre1: Decimal;
        GestionnairePaie: Record "Payroll Manager";
        Paie: Record Payroll;
        ActionActivee: Boolean;
        Text01: Label 'Paie %1 non calculée !';
        EffectifRecap: Record "Effectif récap. de paie";

    /// <summary>
    /// InitialiserRubriques.
    /// </summary>
    procedure InitialiserRubriques();
    begin
        EffectifRecap.DELETEALL;
        TabVentilationComptable.DELETEALL;
        Compteur := 0;
        TabVentilationComptable.INIT;
        Rubrique.FINDFIRST;
        REPEAT
            Compteur := Compteur + 1;
            TabVentilationComptable.No := Compteur;
            TabVentilationComptable.description := Rubrique.Description;
            TabVentilationComptable."No Rub" := Rubrique.Code;
            TabVentilationComptable.compte := Rubrique."Account No.";
            TabVentilationComptable.INSERT;
        UNTIL Rubrique.NEXT = 0;
    end;

    /// <summary>
    /// RemplirTable.
    /// </summary>
    /// <param name="P_Rubrique">Text[20].</param>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Gain">VAR Decimal.</param>
    /// <param name="P_Retenue">VAR Decimal.</param>
    /// <param name="P_Structure">Code[200].</param>
    /// <param name="P_Categorie">Code[200].</param>
    procedure RemplirTable(P_Rubrique: Text[20]; P_Paie: Code[20]; var P_Gain: Decimal; var P_Retenue: Decimal; P_Structure: Code[200]; P_Categorie: Code[200]);
    begin
        ParamPaie.GET;
        LigneArchivePaie.RESET;
        LigneArchivePaie.SETRANGE("Payroll Code", P_Paie);
        LigneArchivePaie.SETRANGE("Item Code", P_Rubrique);
        IF LigneArchivePaie.FINDSET THEN BEGIN
            LigneArchivePaie.FINDFIRST;
            Nombre1 := 0;
            Base1 := 0;
            P_Gain := 0;
            P_Retenue := 0;
            REPEAT
                IF (LigneArchivePaie."Item Code" <> ParamPaie."Employer Cotisation")
                AND (LigneArchivePaie."Item Code" <> ParamPaie."Base Salary Without Indemnity")
                AND (LigneArchivePaie."Item Code" <> ParamPaie."Employer Cotisation") THEN BEGIN
                    IF NOT EffectifRecap.GET(LigneArchivePaie."Employee No.", P_Rubrique) THEN BEGIN
                        EffectifRecap.INIT;
                        EffectifRecap."Employee No." := LigneArchivePaie."Employee No.";
                        EffectifRecap."Item Code" := P_Rubrique;
                        EffectifRecap.INSERT;
                    END;
                    Salarie.GET(LigneArchivePaie."Employee No.");
                    ActionActivee := FALSE;
                    IF P_Structure = '' THEN BEGIN
                        IF P_Categorie = '' THEN
                            ActionActivee := TRUE
                        ELSE
                            IF STRPOS(P_Categorie, Salarie."Socio-Professional Category") > 0 THEN
                                ActionActivee := TRUE;
                    END
                    ELSE BEGIN
                        IF STRPOS(P_Structure, Salarie."Structure Code") > 0 THEN
                            IF P_Categorie = '' THEN
                                ActionActivee := TRUE
                            ELSE
                                IF STRPOS(P_Categorie, Salarie."Socio-Professional Category") > 0 THEN
                                    ActionActivee := TRUE;
                    END;
                    IF ActionActivee THEN BEGIN
                        Nombre1 := Nombre1 + 1;
                        IF (LigneArchivePaie."Item Code" <> ParamPaie."Post Salary")
                        AND (LigneArchivePaie."Item Code" <> ParamPaie."Taxable Salary")
                        AND (LigneArchivePaie."Item Code" <> ParamPaie."DAIP Taxable Salary")
                        AND (LigneArchivePaie."Item Code" <> ParamPaie."Brut Salary") //THEN
                        AND (LigneArchivePaie."Item Code" <> ParamPaie."Net Salary") THEN
                            IF (LigneArchivePaie.Amount < 0) OR (LigneArchivePaie."Item Code" = ParamPaie."Net Salary") THEN BEGIN
                                IF LigneArchivePaie.Amount < 0 THEN
                                    P_Retenue := P_Retenue - LigneArchivePaie.Amount
                                ELSE
                                    P_Retenue := P_Retenue + LigneArchivePaie.Amount
                            END
                            ELSE
                                P_Gain := P_Gain + LigneArchivePaie.Amount;
                        IF (LigneArchivePaie."Item Code" = ParamPaie."Post Salary")
                        OR (LigneArchivePaie."Item Code" = ParamPaie."Taxable Salary")
                        OR (LigneArchivePaie."Item Code" = ParamPaie."DAIP Taxable Salary")
                        OR (LigneArchivePaie."Item Code" = ParamPaie."Brut Salary") THEN
                            Base1 := Base1 + LigneArchivePaie.Basis;
                        IF (ParamPaie."Employee SS Deduction" = LigneArchivePaie."Item Code")
                        OR (ParamPaie."TIT Deduction" = LigneArchivePaie."Item Code")
                        OR (ParamPaie."TIT Out of Grid" = LigneArchivePaie."Item Code") THEN
                            IF LigneArchivePaie.Basis < 0 THEN
                                Base1 := Base1 - LigneArchivePaie.Basis
                            ELSE
                                Base1 := Base1 + LigneArchivePaie.Basis;
                        IF (LigneArchivePaie."Item Code" = ParamPaie."Net Salary") THEN
                            IF LigneArchivePaie.Amount < 0 THEN
                                P_Gain := P_Gain - LigneArchivePaie.Amount
                            ELSE
                                P_Retenue := P_Retenue + LigneArchivePaie.Amount;
                    END;
                END;
            UNTIL LigneArchivePaie.NEXT = 0;
            TabVentilationComptable.Nombre := TabVentilationComptable.Nombre + Nombre1;
            TabVentilationComptable.base := TabVentilationComptable.base + Base1;
            TabVentilationComptable.versement := TabVentilationComptable.versement + P_Gain;
            TabVentilationComptable.retenue := TabVentilationComptable.retenue + P_Retenue;
            TabVentilationComptable.MODIFY;
        END;
    end;

    /// <summary>
    /// TraitementRubrique.
    /// </summary>
    /// <param name="P_AnneeDebut">Integer.</param>
    /// <param name="P_AnneeFin">Integer.</param>
    /// <param name="P_MoisDebut">Integer.</param>
    /// <param name="P_MoisFin">Integer.</param>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Gain">VAR Decimal.</param>
    /// <param name="P_Retenue">VAR Decimal.</param>
    /// <param name="P_Structure">Code[200].</param>
    /// <param name="P_Categorie">Code[200].</param>
    procedure TraitementRubrique(P_AnneeDebut: Integer; P_AnneeFin: Integer; P_MoisDebut: Integer; P_MoisFin: Integer; P_Paie: Code[20]; var P_Gain: Decimal; var P_Retenue: Decimal; P_Structure: Code[200]; P_Categorie: Code[200]);
    begin
        GestionnairePaie.GET(USERID);
        InitialiserRubriques;
        P_Gain := 0;
        P_Retenue := 0;
        HistTransactPaie.RESET;
        HistTransactPaie.FINDFIRST;
        IF P_Paie <> '' THEN BEGIN
            HistTransactPaie.SETRANGE("Payroll Code", P_Paie);
            IF NOT HistTransactPaie.FINDFIRST THEN
                ERROR(Text01, P_Paie);
        END;
        REPEAT
            ActionActivee := FALSE;
            /* Paie.GET(HistTransactPaie."Payroll Code");
             Mois:=DATE2DMY(Paie."Ending Date",2);
             Annee:=DATE2DMY(Paie."Ending Date",3);*/

            //nouveau code  amel
            IF Paie.GET(HistTransactPaie."Payroll Code") THEN BEGIN
                Mois := DATE2DMY(Paie."Ending Date", 2);
                Annee := DATE2DMY(Paie."Ending Date", 3);
            END;
            IF GestionnairePaie."Company Business Unit Code" = '' THEN
                ActionActivee := TRUE
            ELSE BEGIN
                IF (Paie."Company Business Unit Code" = GestionnairePaie."Company Business Unit Code") THEN
                    ActionActivee := TRUE;
            END;
            IF ActionActivee THEN BEGIN
                IF (Annee >= P_AnneeDebut) AND (Annee <= P_AnneeFin) AND (Mois >= P_MoisDebut) AND (Mois <= P_MoisFin) THEN BEGIN
                    TabVentilationComptable.FINDFIRST;
                    REPEAT
                        RemplirTable(TabVentilationComptable."No Rub", HistTransactPaie."Payroll Code", Gain, Retenue,
                        P_Structure, P_Categorie);
                        P_Gain := P_Gain + Gain;
                        P_Retenue := P_Retenue + Retenue;
                    UNTIL TabVentilationComptable.NEXT = 0;
                END;
            END;
        UNTIL HistTransactPaie.NEXT = 0;

    end;
}

