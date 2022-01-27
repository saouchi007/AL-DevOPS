/// <summary>
/// Codeunit Fiche fiscale (ID 52182436).
/// </summary>
codeunit 52182436 "Fiche fiscale"
//codeunit 39108409 "Fiche fiscale"
{
    // version HALRHPAIE.6.2.00


    trigger OnRun();
    begin
    end;

    var
        i: Integer;
        j: Integer;
        A: Code[10];
        M: Code[10];
        "années": Code[10];
        moiss: Code[10];
        k: Integer;
        dat: Date;
        An1: Date;
        An2: Date;
        TabFisc: Record "fichi fisc";
        Paie: Record Payroll;
        compteur: Integer;
        chr: Text[1];
        Rubriq: Record "Payroll Item";
        TableTemp: Record Rubrique;
        PayrollArchiveLine: Record "Payroll Archive Line";
        EcriturePaie2: Record "Payroll Archive Line";
        coef: Decimal;
        bool: Boolean;
        total: Decimal;
        an: Code[10];
        ms: Code[10];

    /// <summary>
    /// RecupAM.
    /// </summary>
    /// <param name="P_codepaie">Code[20].</param>
    /// <param name="Année">VAR Code[10].</param>
    /// <param name="mois">VAR Code[10].</param>
    procedure RecupAM(P_codepaie: Code[20]; var "Année": Code[10]; var mois: Code[10]);
    begin
        FOR i := 1 TO STRLEN(P_codepaie) - 3 DO BEGIN
            A := COPYSTR(P_codepaie, i, 2);
            IF A = '20' THEN BEGIN
                Année := COPYSTR(P_codepaie, i, 4);
                k := i;
            END;
        END;

        FOR j := 1 TO STRLEN(P_codepaie) - 1 DO BEGIN
            IF (j < k - 1) OR (j > k + 3) THEN BEGIN
                CASE COPYSTR(P_codepaie, j, 2) OF
                    '01':
                        mois := '01';
                    '02':
                        mois := '02';
                    '03':
                        mois := '03';
                    '04':
                        mois := '04';
                    '05':
                        mois := '05';
                    '06':
                        mois := '06';
                    '07':
                        mois := '07';
                    '08':
                        mois := '08';
                    '09':
                        mois := '09';
                    '10':
                        mois := '10';
                    '11':
                        mois := '11';
                    '12':
                        mois := '12';
                END;
            END;
        END;
    end;

    /// <summary>
    /// RemplirTable.
    /// </summary>
    /// <param name="A1">Integer.</param>
    /// <param name="M1">Integer.</param>
    /// <param name="A2">Integer.</param>
    /// <param name="M2">Integer.</param>
    procedure RemplirTable(A1: Integer; M1: Integer; A2: Integer; M2: Integer);
    begin
        An1 := DMY2DATE(1, M1, A1);
        An2 := DMY2DATE(31, M2, A2);
        TabFisc.DELETEALL;
        TabFisc.INIT;
        compteur := 0;

        Paie.FINDFIRST;

        REPEAT
            //  IF (Paie."Ending Date">An1) AND (Paie."Ending Date"<An2) THEN
            IF DATE2DMY(Paie."Ending Date", 3) = A2 THEN BEGIN
                compteur := compteur + 1;
                RecupAM(Paie.Code, an, ms);
                TabFisc.date := convert(ms);
                TabFisc.Codepaie := Paie.Code;
                TabFisc."No." := compteur;
                TabFisc.INSERT;
            END;

        UNTIL Paie.NEXT = 0;
    end;

    /// <summary>
    /// convert.
    /// </summary>
    /// <param name="chaine">Text[30].</param>
    /// <returns>Return variable result of type Decimal.</returns>
    procedure convert(chaine: Text[30]) result: Decimal;
    begin
        result := 0;
        coef := 0.1;
        bool := FALSE;
        FOR i := 1 TO STRLEN(chaine) DO BEGIN
            chr := COPYSTR(chaine, i, 1);
            IF chr = ',' THEN bool := TRUE;
            IF bool = TRUE THEN coef := coef * 10;
            CASE chr OF
                '0':
                    result := result * 10;
                '1':
                    result := result * 10 + 1;
                '2':
                    result := result * 10 + 2;
                '3':
                    result := result * 10 + 3;
                '4':
                    result := result * 10 + 4;
                '5':
                    result := result * 10 + 5;
                '6':
                    result := result * 10 + 6;
                '7':
                    result := result * 10 + 7;
                '8':
                    result := result * 10 + 8;
                '9':
                    result := result * 10 + 9;
            END;
        END;
        IF bool = TRUE THEN result := result / coef;
    end;

    procedure "RepTabSalarié"("Salarié": Code[10]);
    begin
        //remplir la 1ére colone de la table temporaire (désignation des rubrique)
        TableTemp.DELETEALL;
        TableTemp.INIT;

        compteur := 0;
        Rubriq.FINDFIRST;
        REPEAT
            compteur := compteur + 1;
            TableTemp."No." := compteur;
            TableTemp.Description := Rubriq.Description;
            TableTemp.payrollCode := Rubriq.Code;
            TableTemp.INSERT;
        UNTIL Rubriq.NEXT = 0;

        TableTemp.FINDFIRST;
        total := 0;
        REPEAT
            TabFisc.FINDFIRST;
            REPEAT
                RubriqueSalarié(TabFisc.Codepaie, Salarié, TableTemp.payrollCode, TabFisc.date, total, total);
            UNTIL TabFisc.NEXT = 0;
            IF total <> 0 THEN TableTemp.total := FORMAT(ROUND(total));
            TableTemp.MODIFY;
            total := 0;
        UNTIL TableTemp.NEXT = 0;
    end;

    /// <summary>
    /// InsererE.
    /// </summary>
    /// <param name="P_i">Integer.</param>
    /// <param name="Champs">Text[80].</param>
    procedure InsererE(P_i: Integer; Champs: Text[80]);
    begin
        CASE P_i OF
            1:
                IF TableTemp.Rub1 <> '' THEN
                    TableTemp.Rub1 := FORMAT(convert(TableTemp.Rub1) + convert(Champs)) ELSE
                    TableTemp.Rub1 := Champs;
            2:
                IF TableTemp.Rub2 <> '' THEN
                    TableTemp.Rub2 := FORMAT(convert(TableTemp.Rub2) + convert(Champs)) ELSE
                    TableTemp.Rub2 := Champs;
            3:
                IF TableTemp.Rub3 <> '' THEN
                    TableTemp.Rub3 := FORMAT(convert(TableTemp.Rub3) + convert(Champs)) ELSE
                    TableTemp.Rub3 := Champs;
            4:
                IF TableTemp.Rub4 <> '' THEN
                    TableTemp.Rub4 := FORMAT(convert(TableTemp.Rub4) + convert(Champs)) ELSE
                    TableTemp.Rub4 := Champs;
            5:
                IF TableTemp.Rub5 <> '' THEN
                    TableTemp.Rub5 := FORMAT(convert(TableTemp.Rub5) + convert(Champs)) ELSE
                    TableTemp.Rub5 := Champs;
            6:
                IF TableTemp.Rub6 <> '' THEN
                    TableTemp.Rub6 := FORMAT(convert(TableTemp.Rub6) + convert(Champs)) ELSE
                    TableTemp.Rub6 := Champs;
            7:
                IF TableTemp.Rub7 <> '' THEN
                    TableTemp.Rub7 := FORMAT(convert(TableTemp.Rub7) + convert(Champs)) ELSE
                    TableTemp.Rub7 := Champs;
            8:
                IF TableTemp.Rub8 <> '' THEN
                    TableTemp.Rub8 := FORMAT(convert(TableTemp.Rub8) + convert(Champs)) ELSE
                    TableTemp.Rub8 := Champs;
            9:
                IF TableTemp.Rub9 <> '' THEN
                    TableTemp.Rub9 := FORMAT(convert(TableTemp.Rub9) + convert(Champs)) ELSE
                    TableTemp.Rub9 := Champs;
            10:
                IF TableTemp.Rub10 <> '' THEN
                    TableTemp.Rub10 := FORMAT(convert(TableTemp.Rub10) + convert(Champs)) ELSE
                    TableTemp.Rub10 := Champs;
            11:
                IF TableTemp.Rub11 <> '' THEN
                    TableTemp.Rub11 := FORMAT(convert(TableTemp.Rub11) + convert(Champs)) ELSE
                    TableTemp.Rub11 := Champs;
            12:
                IF TableTemp.Rub12 <> '' THEN
                    TableTemp.Rub12 := FORMAT(convert(TableTemp.Rub12) + convert(Champs)) ELSE
                    TableTemp.Rub12 := Champs;

        END;
    end;

    procedure "RubriqueSalarié"(P_codepaie: Text[30]; P_mat: Code[20]; P_payrollCode: Code[20]; P_i: Integer; var Tle: Decimal; Tin: Decimal);
    begin
        EcriturePaie2.RESET;
        EcriturePaie2.SETRANGE("Payroll Code", P_codepaie);
        EcriturePaie2.SETRANGE("Employee No.", P_mat);
        EcriturePaie2.SETRANGE("Item Code", P_payrollCode);

        IF (EcriturePaie2.FINDSET) THEN BEGIN
            EcriturePaie2.FINDFIRST;
            IF (EcriturePaie2.Amount > 0) THEN BEGIN
                Tle := Tin + EcriturePaie2.Amount;
                IF (EcriturePaie2.Amount MOD 1 = 0) THEN
                    InsererE(P_i, FORMAT(EcriturePaie2.Amount) + ',00')
                ELSE
                    IF (EcriturePaie2.Amount MOD 0.1 = 0) THEN
                        InsererE(P_i, FORMAT(EcriturePaie2.Amount) + '0')
                    ELSE
                        InsererE(P_i, FORMAT((((EcriturePaie2.Amount) * 100) DIV 1) / 100));
            END
            ELSE BEGIN
                Tle := Tin - EcriturePaie2.Amount;
                IF (EcriturePaie2.Amount MOD 1 = 0) THEN
                    InsererE(P_i, FORMAT((-1) * EcriturePaie2.Amount) + ',00')
                ELSE
                    IF (EcriturePaie2.Amount MOD 0.1 = 0) THEN
                        InsererE(P_i, FORMAT((-1) * EcriturePaie2.Amount) + '0')
                    ELSE
                        InsererE(P_i, FORMAT(((((-1) * EcriturePaie2.Amount) * 100) DIV 1) / 100));

            END;
        END;
    end;
}

