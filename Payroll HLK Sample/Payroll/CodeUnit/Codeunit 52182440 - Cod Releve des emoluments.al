/// <summary>
/// Codeunit Cod Releve des emoluments (ID 52182440).
/// </summary>
codeunit 52182440 "Cod Releve des emoluments"
//codeunit 39108413 "Cod Releve des emoluments"
{
    // version HALRHPAIE.6.1.01


    trigger OnRun();
    begin
        //inserer(3,100,200,'janvier 2010');
        // insererligne('PA2009-01','S000002','janvier 2009',1);
        //traitement('S000002',1,12,2009);
    end;

    var
        TabRel: Record "Tab Releve des emoluments";
        payrollEntry: Record "Payroll Entry";
        payrollsetup: Record Payroll_Setup;
        an1: Date;
        an2: Date;
        payroll: Record Payroll;
        dat: Text[30];
        FicheFiscale: Codeunit "Fiche fiscale";
        i: Integer;
        j: Integer;
        k: Integer;
        a: Text[30];
        an: Code[10];
        m: Integer;

    /// <summary>
    /// inserer.
    /// </summary>
    /// <param name="p_m">Integer.</param>
    /// <param name="P_Base">Decimal.</param>
    /// <param name="P_ret">Decimal.</param>
    /// <param name="p_date">Text[30].</param>
    procedure inserer(p_m: Integer; P_Base: Decimal; P_ret: Decimal; p_date: Text[30]);
    begin
        TabRel.RESET;
        TabRel.SETRANGE(No, p_m);
        IF TabRel.FINDSET THEN BEGIN
            TabRel.FINDFIRST;
            TabRel.base := TabRel.base + P_Base;
            TabRel.retenue := TabRel.retenue + P_ret;
            TabRel.MODIFY;
        END
        ELSE BEGIN
            TabRel.INIT;
            TabRel.No := p_m;
            TabRel.base := P_Base;
            TabRel.retenue := P_ret;
            TabRel.Mois := p_date;
            TabRel.INSERT;

        END;
    end;

    /// <summary>
    /// InsererLigne.
    /// </summary>
    /// <param name="P_coodpaie">Code[20].</param>
    /// <param name="P_salarié">Code[20].</param>
    /// <param name="P_date">Text[30].</param>
    /// <param name="P_m">Integer.</param>
    procedure InsererLigne(P_coodpaie: Code[20]; "P_salarié": Code[20]; P_date: Text[30]; P_m: Integer);
    begin
        payrollsetup.GET;
        payrollEntry.RESET;
        payrollEntry.SETRANGE("Document No.", P_coodpaie);
        payrollEntry.SETRANGE("Employee No.", P_salarié);
        payrollEntry.SETRANGE("Item Code", payrollsetup."TIT Deduction");
        IF payrollEntry.FINDSET THEN BEGIN
            payrollEntry.FINDFIRST;
            inserer(P_m, payrollEntry.Basis, (-1) * payrollEntry.Amount, P_date);
        END;
    end;

    /// <summary>
    /// traitement.
    /// </summary>
    /// <param name="P_salarié">Code[20].</param>
    /// <param name="p_moisD">Integer.</param>
    /// <param name="P_moisF">Integer.</param>
    /// <param name="Année">Integer.</param>
    procedure traitement("P_salarié": Code[20]; p_moisD: Integer; P_moisF: Integer; "Année": Integer);
    begin
        TabRel.DELETEALL;
        an1 := DMY2DATE(1, p_moisD, Année);
        an2 := DMY2DATE(28, P_moisF, Année);
        //message('%1   %2',an1,an2);
        payroll.FINDFIRST;


        REPEAT
            IF (payroll."Ending Date" >= an1) AND (payroll."Ending Date" <= an2) THEN BEGIN
                dat := FORMAT(payroll."Ending Date", 0, 4);
                dat := COPYSTR(dat, 4, STRLEN(dat) - 3);
                //message(dat);
                recupAM(payroll.Code, an, m);
                // MESSAGE('%1 ',m);
                InsererLigne(payroll.Code, P_salarié, dat, m);
            END;
        UNTIL payroll.NEXT = 0;
    end;

    /// <summary>
    /// recupAM.
    /// </summary>
    /// <param name="P_codepaie">Code[20].</param>
    /// <param name="année">VAR Code[10].</param>
    /// <param name="mois">VAR Integer.</param>
    procedure recupAM(P_codepaie: Code[20]; var "année": Code[10]; var mois: Integer);
    begin
        FOR i := 1 TO STRLEN(P_codepaie) - 3 DO BEGIN
            a := COPYSTR(P_codepaie, i, 2);
            IF a = '20' THEN BEGIN
                année := COPYSTR(P_codepaie, i, 4);
                k := i;
            END;
        END;

        FOR j := 1 TO STRLEN(P_codepaie) - 1 DO BEGIN
            IF (j < k - 1) OR (j > k + 3) THEN BEGIN
                CASE COPYSTR(P_codepaie, j, 2) OF
                    '01':
                        mois := 1;
                    '02':
                        mois := 2;
                    '03':
                        mois := 3;
                    '04':
                        mois := 4;
                    '05':
                        mois := 5;
                    '06':
                        mois := 6;
                    '07':
                        mois := 7;
                    '08':
                        mois := 8;
                    '09':
                        mois := 9;
                    '10':
                        mois := 10;
                    '11':
                        mois := 11;
                    '12':
                        mois := 12;
                END;
            END;
        END;
    end;
}

