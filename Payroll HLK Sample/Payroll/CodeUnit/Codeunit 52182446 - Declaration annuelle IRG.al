/// <summary>
/// Codeunit Declaration annuelle IRG (ID 52182446).
/// </summary>
codeunit 52182446 "Declaration annuelle IRG"
//codeunit 39108419 "Declaration annuelle IRG"
{
    // version HALRHPAIE.6.2.00


    trigger OnRun();
    begin
    end;

    var
        ParamPaie: Record Payroll_Setup;
        ArchivePaieLigne: Record "Payroll Archive Line";
        base: Decimal;
        NP: Text[50];
        imaSS: Code[20];
        ret: Decimal;
        PayrollArchiveHeader: Record "Payroll Archive Header";
        nbjr: Decimal;
        NumSS1: Code[20];
        NomPremon11: Text[50];
        dateN1: Date;
        dateE1: Date;
        dateS1: Date;
        ArchivePaieEntete2: Record "Payroll Archive Header";
        RubriqueSalarie: Record "Payroll Entry";
        NbreJoursAbsence: Decimal;
        PayrollArchiveHeader3: Record "Payroll Archive Header";
        Annee: Integer;
        Mois: Integer;
        Paie: Record Payroll;
        MoisDebut: Integer;
        MoisFin: Integer;
        Salarie: Record 5200;
        dat: Date;
        NbreEnf11: Integer;
        Statut11: Code[20];
        Function11: Text[50];
        Address11: Text[50];
        SalaireImposable: Decimal;
        MntIRG: Decimal;
        BaseHorsBareme: Decimal;
        MntRetenueHorsBareme: Decimal;
        v: Boolean;
        EmployeeRelative: Record 5205;
        cpt: Integer;
        DeclarationIRG: Record "Declaration IRG";
        Text01: Label 'Date fin non configurée pour la paie %1 !';
        Progression: Dialog;
        CID: Decimal;

    /// <summary>
    /// InsererMontants.
    /// </summary>
    /// <param name="P_SalaireImposable">Decimal.</param>
    /// <param name="P_RetenueIRG">Decimal.</param>
    /// <param name="P_BaseHorsBareme">Decimal.</param>
    /// <param name="P_RetenueHorsBareme">Decimal.</param>
    /// <param name="P_Mois">Integer.</param>
    /// <param name="P_CID">Decimal.</param>
    procedure InsererMontants(P_SalaireImposable: Decimal; P_RetenueIRG: Decimal; P_BaseHorsBareme: Decimal; P_RetenueHorsBareme: Decimal; P_Mois: Integer; P_CID: Decimal);
    begin
        IF P_SalaireImposable < 0 THEN
            P_SalaireImposable := -P_SalaireImposable;
        IF P_BaseHorsBareme < 0 THEN
            P_BaseHorsBareme := -P_BaseHorsBareme;
        //IF P_RetenueHorsBareme<0 THEN
        //P_RetenueHorsBareme:=-P_RetenueHorsBareme;
        CASE P_Mois OF
            1:
                BEGIN
                    DeclarationIRG.SalaireImp1 := DeclarationIRG.SalaireImp1 + P_SalaireImposable;

                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp1 := 0;
                    DeclarationIRG.RetenueIrg1 := DeclarationIRG.RetenueIrg1 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg1 := 0;

                    DeclarationIRG.BasePrime1 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG1 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            2:
                BEGIN
                    DeclarationIRG.SalaireImp2 := DeclarationIRG.SalaireImp2 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp2 := 0;
                    DeclarationIRG.RetenueIrg2 := DeclarationIRG.RetenueIrg2 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg2 := 0;

                    DeclarationIRG.BasePrime2 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG2 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            3:
                BEGIN
                    DeclarationIRG.SalaireImp3 := DeclarationIRG.SalaireImp3 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp3 := 0;
                    DeclarationIRG.RetenueIrg3 := DeclarationIRG.RetenueIrg3 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg3 := 0;

                    DeclarationIRG.BasePrime3 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG3 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            4:
                BEGIN
                    DeclarationIRG.SalaireImp4 := DeclarationIRG.SalaireImp4 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp4 := 0;
                    DeclarationIRG.RetenueIrg4 := DeclarationIRG.RetenueIrg4 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg4 := 0;

                    DeclarationIRG.BasePrime4 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG4 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            5:
                BEGIN
                    DeclarationIRG.SalaireImp5 := DeclarationIRG.SalaireImp5 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp5 := 0;
                    DeclarationIRG.RetenueIrg5 := DeclarationIRG.RetenueIrg5 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg5 := 0;

                    DeclarationIRG.BasePrime5 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG5 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            6:
                BEGIN
                    DeclarationIRG.SalaireImp6 := DeclarationIRG.SalaireImp6 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp6 := 0;
                    DeclarationIRG.RetenueIrg6 := DeclarationIRG.RetenueIrg6 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg6 := 0;

                    DeclarationIRG.BasePrime6 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG6 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            7:
                BEGIN
                    DeclarationIRG.SalaireImp7 := DeclarationIRG.SalaireImp7 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp7 := 0;
                    DeclarationIRG.RetenueIrg7 := DeclarationIRG.RetenueIrg7 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg7 := 0;

                    DeclarationIRG.BasePrime7 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG7 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            8:
                BEGIN
                    DeclarationIRG.SalaireImp8 := DeclarationIRG.SalaireImp8 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp8 := 0;
                    DeclarationIRG.RetenueIrg8 := DeclarationIRG.RetenueIrg8 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg8 := 0;

                    DeclarationIRG.BasePrime8 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG8 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            9:
                BEGIN
                    DeclarationIRG.SalaireImp9 := DeclarationIRG.SalaireImp9 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp9 := 0;
                    DeclarationIRG.RetenueIrg9 := DeclarationIRG.RetenueIrg9 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg9 := 0;

                    DeclarationIRG.BasePrime9 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG9 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            10:
                BEGIN
                    DeclarationIRG.SalaireImp10 := DeclarationIRG.SalaireImp10 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp10 := 0;
                    DeclarationIRG.RetenueIrg10 := DeclarationIRG.RetenueIrg10 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg10 := 0;

                    DeclarationIRG.BasePrime10 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG10 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            11:
                BEGIN
                    DeclarationIRG.SalaireImp11 := DeclarationIRG.SalaireImp11 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp11 := 0;
                    DeclarationIRG.RetenueIrg11 := DeclarationIRG.RetenueIrg11 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg11 := 0;

                    DeclarationIRG.BasePrime11 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG11 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
            12:
                BEGIN
                    DeclarationIRG.SalaireImp12 := DeclarationIRG.SalaireImp12 + P_SalaireImposable;
                    IF P_CID <> 0 THEN DeclarationIRG.SalaireImp12 := 0;
                    DeclarationIRG.RetenueIrg12 := DeclarationIRG.RetenueIrg12 + P_RetenueIRG;
                    IF P_CID <> 0 THEN DeclarationIRG.RetenueIrg12 := 0;

                    DeclarationIRG.BasePrime12 := P_BaseHorsBareme;
                    DeclarationIRG.PrimeRetenueIRG12 := P_RetenueHorsBareme;

                    DeclarationIRG.BsHBareme := DeclarationIRG.BsHBareme + P_BaseHorsBareme;
                    DeclarationIRG.MtRHBareme := DeclarationIRG.MtRHBareme + P_RetenueHorsBareme;
                END;
        END;
        DeclarationIRG.MODIFY;
    end;

    /// <summary>
    /// InsererLigne.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Mois">Integer.</param>
    procedure InsererLigne(P_Paie: Code[20]; P_Mois: Integer);
    begin
        ArchivePaieEntete2.RESET;
        ArchivePaieEntete2.SETRANGE("Payroll Code", P_Paie);
        IF ArchivePaieEntete2.FINDFIRST THEN
            REPEAT
                Progression.UPDATE(2, ArchivePaieEntete2."No.");
                SalaireImposable := 0;
                CID := 0;
                MntIRG := 0;
                BaseHorsBareme := 0;
                MntRetenueHorsBareme := 0;
                //GRATIFICATION CID
                IF ArchivePaieLigne.GET(ArchivePaieEntete2."No.", P_Paie, '573') THEN
                    CID := ArchivePaieLigne.Amount;
                IF ArchivePaieLigne.GET(ArchivePaieEntete2."No.", P_Paie, ParamPaie."Taxable Salary") THEN
                    SalaireImposable := ArchivePaieLigne.Amount;
                IF ArchivePaieLigne.GET(ArchivePaieEntete2."No.", P_Paie, ParamPaie."DAIP Taxable Salary") THEN
                    SalaireImposable := SalaireImposable + ArchivePaieLigne.Basis;
                IF ArchivePaieLigne.GET(ArchivePaieEntete2."No.", P_Paie, ParamPaie."TIT Out of Grid") THEN BEGIN
                    BaseHorsBareme := ArchivePaieLigne.Basis;
                    MntRetenueHorsBareme := ROUND(ArchivePaieLigne.Amount);
                END;
                ArchivePaieLigne.RESET;
                ArchivePaieLigne.SETRANGE("Employee No.", ArchivePaieEntete2."No.");
                ArchivePaieLigne.SETRANGE("Payroll Code", P_Paie);
                ArchivePaieLigne.SETFILTER("Item Code", ParamPaie."TIT Filter");
                IF ArchivePaieLigne.FINDFIRST THEN
                    REPEAT
                        MntIRG := MntIRG + ArchivePaieLigne.Amount;
                    UNTIL ArchivePaieLigne.NEXT = 0;
                IF (SalaireImposable <> 0) OR (MntIRG <> 0) OR (BaseHorsBareme <> 0) OR (MntRetenueHorsBareme <> 0) THEN BEGIN
                    IF NOT DeclarationIRG.GET(ArchivePaieEntete2."No.") THEN BEGIN
                        Salarie.GET(ArchivePaieEntete2."No.");
                        DeclarationIRG.INIT;
                        DeclarationIRG.Matricule := ArchivePaieEntete2."No.";
                        DeclarationIRG.NomPrenom := Salarie."Last Name";
                        DeclarationIRG.Prenom := Salarie."First Name";
                        //Salarie.CALCFIELDS("No. of Children");
                        DeclarationIRG.NbreEnf := Salarie."No. of Children";
                        DeclarationIRG.Statut := COPYSTR(FORMAT(Salarie."Marital Status"), 1, 1);
                        DeclarationIRG."function" := COPYSTR(Salarie."Job Title", 1, 50);
                        DeclarationIRG.address := Salarie.Address + ' ' + Salarie."Address 2" + ' ' + Salarie.City;
                        DeclarationIRG.INSERT;
                    END;
                    DeclarationIRG.GET(ArchivePaieEntete2."No.");
                    InsererMontants(SalaireImposable, MntIRG, BaseHorsBareme, MntRetenueHorsBareme, Mois, CID);
                END;
            UNTIL ArchivePaieEntete2.NEXT = 0;
    end;

    /// <summary>
    /// Traitement.
    /// </summary>
    /// <param name="P_Annee">Integer.</param>
    /// <param name="P_Unite">Code[10].</param>
    /// <param name="P_CalculEffectue">VAR Boolean.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure Traitement(P_Annee: Integer; P_Unite: Code[10]; var P_CalculEffectue: Boolean): Integer;
    begin
        ParamPaie.GET;
        DeclarationIRG.RESET;
        DeclarationIRG.DELETEALL;
        P_CalculEffectue := FALSE;
        Paie.RESET;
        IF P_Unite <> '' THEN
            Paie.SETRANGE("Company Business Unit Code", P_Unite);
        Progression.OPEN('Traitement de la paie #1#########\Salarié               #2#########');
        Paie.FINDFIRST;
        REPEAT
            IF Paie."Ending Date" = 0D THEN
                ERROR(Text01, Paie.Code);
            Annee := DATE2DMY(Paie."Ending Date", 3);
            IF Annee = P_Annee THEN BEGIN
                Mois := DATE2DMY(Paie."Ending Date", 2);
                Progression.UPDATE(1, Paie.Code);
                InsererLigne(Paie.Code, Mois);
                P_CalculEffectue := TRUE;
            END;
        UNTIL Paie.NEXT = 0;
        DeclarationIRG.RESET;
        Progression.CLOSE;
        EXIT(DeclarationIRG.COUNT);
    end;
}

