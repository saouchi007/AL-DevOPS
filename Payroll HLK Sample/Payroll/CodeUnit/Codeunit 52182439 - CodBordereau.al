/// <summary>
/// Codeunit CodBordereau (ID 51412).
/// </summary>
codeunit 52182439 CodBordereau
//codeunit 39108412 CodBordereau
{
    // version HALRHPAIE.6.2.00


    trigger OnRun();
    begin
        //valeurs('PA01-2009','S000001',base,ret);
        //message('%1    %2',base,ret);
        //infos('S000001',np,imass,'PA2009-01');
        //message('%1    %2',np,imass);

        //TabBordereau.findfirst;
        //insérer(1000,2000,200,3);
        //TabBordereau.modify;

        //message(NbreJrTrav('S000003'));
        //traitement('2009');
    end;

    var
        payrollsetup: Record Payroll_Setup;
        PayrollArchiveLine: Record "Payroll Archive Line";
        base: Decimal;
        NP: Text[50];
        imaSS: Code[20];
        ret: Decimal;
        PayrollArchiveHeader: Record "Payroll Archive Header";
        TabBordereau: Record TabBordereau;
        nbjr: Decimal;
        NumSS1: Code[20];
        NomPremon1: Text[50];
        PayrollArchiveHeader2: Record "Payroll Archive Header";
        RubriqueSalarie: Record "Payroll Entry";
        NbreJoursAbsence: Decimal;
        conv: Codeunit "Fiche fiscale";
        PayrollArchiveHeader3: Record "Payroll Archive Header";
        An: Code[10];
        Ms: Code[10];
        payroll: Record Payroll;

    /// <summary>
    /// valeurs.
    /// </summary>
    /// <param name="P_codepaie">Code[20].</param>
    /// <param name="P_salarié">Code[20].</param>
    /// <param name="P_base">VAR Decimal.</param>
    /// <param name="P_retenueSS">VAR Decimal.</param>
    procedure valeurs(P_codepaie: Code[20]; "P_salarié": Code[20]; var P_base: Decimal; var P_retenueSS: Decimal);
    begin
        payrollsetup.GET;
        PayrollArchiveLine.RESET;
        PayrollArchiveLine.SETRANGE("Payroll Code", P_codepaie);
        PayrollArchiveLine.SETRANGE("Employee No.", P_salarié);
        PayrollArchiveLine.SETRANGE("Item Code", payrollsetup."Employee SS Deduction");

        IF (PayrollArchiveLine.FINDSET) THEN BEGIN
            PayrollArchiveLine.FINDFIRST;
            P_base := PayrollArchiveLine.Basis;
            P_retenueSS := (-1) * PayrollArchiveLine.Amount;
        END;
    end;

    /// <summary>
    /// infos.
    /// </summary>
    /// <param name="P_salarié">Code[20].</param>
    /// <param name="P_NomPrénom">VAR Text[50].</param>
    /// <param name="P_NumSS">VAR Code[20].</param>
    /// <param name="P_codepaie">Code[20].</param>
    procedure infos("P_salarié": Code[20]; var "P_NomPrénom": Text[50]; var P_NumSS: Code[20]; P_codepaie: Code[20]);
    begin
        PayrollArchiveHeader.RESET;
        PayrollArchiveHeader.SETRANGE("No.", P_salarié);
        PayrollArchiveHeader.SETRANGE("Payroll Code", P_codepaie);
        PayrollArchiveHeader.FINDFIRST;
        P_NomPrénom := PayrollArchiveHeader."Last Name" + '  ' + PayrollArchiveHeader."First Name";
        P_NumSS := PayrollArchiveHeader."Social Security No.";
    end;

    /// <summary>
    /// insérer.
    /// </summary>
    /// <param name="P_base">Decimal.</param>
    /// <param name="P_retenueSS">Decimal.</param>
    /// <param name="P_NbreJr">Code[10].</param>
    /// <param name="m">Integer.</param>
    procedure "insérer"(P_base: Decimal; P_retenueSS: Decimal; P_NbreJr: Code[10]; m: Integer);
    begin

        CASE m OF
            1:
                BEGIN
                    TabBordereau.J1 := P_NbreJr;
                    TabBordereau.r1 := P_retenueSS + TabBordereau.r1;
                    TabBordereau.b1 := P_base + TabBordereau.b1;
                END;
            2:
                BEGIN
                    TabBordereau.J2 := P_NbreJr;
                    TabBordereau.r2 := P_retenueSS + TabBordereau.r2;
                    TabBordereau.b2 := P_base + TabBordereau.b2;
                END;
            3:
                BEGIN
                    TabBordereau.J3 := P_NbreJr;
                    TabBordereau.r3 := P_retenueSS + TabBordereau.r3;
                    TabBordereau.b3 := P_base + TabBordereau.b3;
                END;
            4:
                BEGIN
                    TabBordereau.J4 := P_NbreJr;
                    TabBordereau.r4 := P_retenueSS + TabBordereau.r4;
                    TabBordereau.b4 := P_base + TabBordereau.b4;
                END;
            5:
                BEGIN
                    TabBordereau.J5 := P_NbreJr;
                    TabBordereau.r5 := P_retenueSS + TabBordereau.r5;
                    TabBordereau.b5 := P_base + TabBordereau.b5;
                END;
            6:
                BEGIN
                    TabBordereau.J6 := P_NbreJr;
                    TabBordereau.r6 := P_retenueSS + TabBordereau.r6;
                    TabBordereau.b6 := P_base + TabBordereau.b6;
                END;
            7:
                BEGIN
                    TabBordereau.J7 := P_NbreJr;
                    TabBordereau.r7 := P_retenueSS + TabBordereau.r7;
                    TabBordereau.b7 := P_base + TabBordereau.b7;
                END;
            8:
                BEGIN
                    TabBordereau.J8 := P_NbreJr;
                    TabBordereau.r8 := P_retenueSS + TabBordereau.r8;
                    TabBordereau.b8 := P_base + TabBordereau.b8;
                END;
            9:
                BEGIN
                    TabBordereau.J9 := P_NbreJr;
                    TabBordereau.r9 := P_retenueSS + TabBordereau.r9;
                    TabBordereau.b9 := P_base + TabBordereau.b9;
                END;
            10:
                BEGIN
                    TabBordereau.J10 := P_NbreJr;
                    TabBordereau.r10 := P_retenueSS + TabBordereau.r10;
                    TabBordereau.b10 := P_base + TabBordereau.b10;
                END;
            11:
                BEGIN
                    TabBordereau.J11 := P_NbreJr;
                    TabBordereau.r11 := P_retenueSS + TabBordereau.r11;
                    TabBordereau.b11 := P_base + TabBordereau.b11;
                END;
            12:
                BEGIN
                    TabBordereau.J12 := P_NbreJr;
                    TabBordereau.r12 := P_retenueSS + TabBordereau.r12;
                    TabBordereau.b12 := P_base + TabBordereau.b12;
                END;
        END;
    end;

    /// <summary>
    /// insert.
    /// </summary>
    /// <param name="P_codepaie">Code[20].</param>
    /// <param name="P_salarié">Code[20].</param>
    /// <param name="P_base">Decimal.</param>
    /// <param name="P_retenueSS">Decimal.</param>
    /// <param name="P_NbreJr">Code[10].</param>
    /// <param name="m">Integer.</param>
    procedure insert(P_codepaie: Code[20]; "P_salarié": Code[20]; P_base: Decimal; P_retenueSS: Decimal; P_NbreJr: Code[10]; m: Integer);
    begin
        TabBordereau.RESET;
        TabBordereau.SETRANGE(Matricule, P_salarié);

        IF (TabBordereau.FINDSET) THEN BEGIN
            TabBordereau.FINDFIRST;
            insérer(P_base, P_retenueSS, P_NbreJr, m);
            TabBordereau.MODIFY;
        END
        ELSE BEGIN
            TabBordereau.INIT;
            infos(P_salarié, NomPremon1, NumSS1, P_codepaie);
            TabBordereau.Matricule := P_salarié;
            TabBordereau."Num SS" := NumSS1;
            TabBordereau.NomPrenom := NomPremon1;
            insérer(P_base, P_retenueSS, P_NbreJr, m);
            TabBordereau.INSERT;
        END;
    end;

    /// <summary>
    /// InsererLigne.
    /// </summary>
    /// <param name="P_codepaie">Code[20].</param>
    /// <param name="m">Integer.</param>
    procedure InsererLigne(P_codepaie: Code[20]; m: Integer);
    begin
        PayrollArchiveHeader2.RESET;
        PayrollArchiveHeader2.SETRANGE("Payroll Code", P_codepaie);
        PayrollArchiveHeader2.FINDFIRST;
        REPEAT
            valeurs(P_codepaie, PayrollArchiveHeader2."No.", base, ret);
            insert(P_codepaie, PayrollArchiveHeader2."No.", base, ret, NbreJrTrav(PayrollArchiveHeader2."No.", P_codepaie), m);
        UNTIL PayrollArchiveHeader2.NEXT = 0;
    end;

    /// <summary>
    /// NbreJrTrav.
    /// </summary>
    /// <param name="employee">Code[20].</param>
    /// <param name="P_codepaie">Code[20].</param>
    /// <returns>Return variable heure of type Text[30].</returns>
    procedure NbreJrTrav(employee: Code[20]; P_codepaie: Code[20]) heure: Text[30];
    var
        ArchivePaieEntete: Record "Payroll Archive Header";
    begin
        payrollsetup.GET;
        ArchivePaieEntete.GET(P_codepaie, employee);
        NbreJoursAbsence := ArchivePaieEntete."Total Absences Days" + ArchivePaieEntete."Total Absences Hours" /
        payrollsetup."No. of Hours By Day";
        NbreJoursAbsence := NbreJoursAbsence DIV 1;
        EXIT(FORMAT(ROUND(payrollsetup."No. of Worked Days" - NbreJoursAbsence)) + ' J');
    end;

    /// <summary>
    /// traitement.
    /// </summary>
    /// <param name="Exercice">Code[10].</param>
    /// <param name="v">VAR Boolean.</param>
    procedure traitement(Exercice: Code[10]; var v: Boolean);
    begin
        TabBordereau.DELETEALL;
        payroll.FINDFIRST;
        v := FALSE;
        REPEAT
            conv.RecupAM(payroll.Code, An, Ms);
            IF (An = Exercice) THEN BEGIN
                InsererLigne(payroll.Code, conv.convert(Ms));
                v := TRUE;
            END;
        UNTIL payroll.NEXT = 0;
    end;
}

