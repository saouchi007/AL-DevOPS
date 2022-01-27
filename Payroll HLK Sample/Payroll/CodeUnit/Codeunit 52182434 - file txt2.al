/// <summary>
/// Codeunit file txt2 (ID 52182434).
/// </summary>
codeunit 52182434 "file txt2"
//codeunit 39108407 "file txt2"
{
    // version HALRHPAIE.6.1.01


    trigger OnRun();
    begin
        //CodNbSalarié('2010-04',m);
        //MESSAGE(m);

        //CodCalcMontantGlobal('2010-04',m);
        //MESSAGE(m);
        //MESSAGE('%1',STRLEN(m));

        //ligneEntete('2010-04',m);
        //MESSAGE('%1      taille =  %2',m, strlen(m));


        //CodCalcMontantSalarié('2010-04','s000001',m);
        //MESSAGE(m);



        //CodName('s000001',NameS,V_compte);
        //message(NameS);
        //message(V_compte);
        //LigneSalarie('2010-04');

        CodeTrans('2010-03');
    end;

    var
        PayrollRegister: Record "Payroll Register";
        "NbSalarié": Integer;
        Mois: Text[2];
        "Année": Text[4];
        Montant: Decimal;
        PayrollArchiveLine: Record "Payroll Archive Line";
        m: Text[62];
        PayrollSetup: Record Payroll_Setup;
        mont: Decimal;
        c: Text[30];
        c2: Text[30];
        BankAccount: Record 270;
        CompanyBusinessUnit: Record "Company Business Unit";
        NbS: Text[7];
        mnt: Text[13];
        "key": Text[20];
        compte: Text[20];
        "salarié": Record 5200;
        nom: Text[30];
        prenom: Text[30];
        NameS: Text[27];
        v_compte: Text[12];
        LName: Text[27];
        LCompte: Text[12];
        Lmontant: Text[13];
        ligneS: Text[62];
        PayrollArchiveLine2: Record "Payroll Archive Line";
        compt: Decimal;
        "table": Record 51585;
        T001: Label '"La clé RIB du compte du salarié N° "';
        T002: Label 'est superieur à 2 caractéres';
        T003: Label 'Le N° du compte du Salarié N°';
        T004: Label 'est superieur à 10 caractéres';
        T005: Label '"La clé RIB du compte de la sociéte est superieur à 2 caractéres "';
        T006: Label 'Le N° du compte de la sociéte est superieur à 10 caractéres';

    procedure "CodNbSalarié"(P_CodePaie: Code[20]; var "P_NbSalarié": Text[7]);
    begin

        PayrollRegister.RESET;
        PayrollRegister.SETRANGE("Payroll Code", P_CodePaie);
        PayrollRegister.FINDFIRST;
        P_NbSalarié := FORMAT(PayrollRegister."No. of employees");
        c := '0';
        IF (STRLEN(P_NbSalarié) < 7) THEN
            REPEAT
                P_NbSalarié := c + P_NbSalarié;
            UNTIL (STRLEN(P_NbSalarié) = 7);
    end;

    /// <summary>
    /// CodCalcMontantGlobal.
    /// </summary>
    /// <param name="P_CodePaie">Code[20].</param>
    /// <param name="P_Montant">VAR Text[13].</param>
    procedure CodCalcMontantGlobal(P_CodePaie: Code[20]; var P_Montant: Text[13]);
    begin
        PayrollSetup.GET;
        PayrollArchiveLine.RESET;
        PayrollArchiveLine.SETRANGE("Payroll Code", P_CodePaie);
        PayrollArchiveLine.SETRANGE("Item Code", PayrollSetup."Net Salary");
        PayrollArchiveLine.FINDFIRST;
        REPEAT
            Montant := Montant + PayrollArchiveLine.Amount;
        UNTIL PayrollArchiveLine.NEXT = 0;
        //P_Montant :=DELCHR(FORMAT(Montant),'=',',');
        //P_Montant :=P_Montant'+'FORMAT(Montant mod 1);
        //MESSAGE('%1',Montant);
        mont := Montant * 100;
        c := '';
        IF (mont > 1) THEN
            REPEAT
            BEGIN
                c := FORMAT((mont DIV 1) MOD 1000) + c;
                IF (((mont DIV 1) MOD 1000) < 100) THEN c := '0' + c;
                IF (((mont DIV 1) MOD 1000) < 10) THEN c := '0' + c;

                mont := mont DIV 1000;
            END;
            UNTIL mont < 1;
        P_Montant := c;
        c := '0';

        IF (STRLEN(P_Montant) < 13) THEN
            REPEAT
                P_Montant := c + P_Montant;
            UNTIL (STRLEN(P_Montant) = 13);
    end;

    /// <summary>
    /// LigneEntete.
    /// </summary>
    /// <param name="code_paie">Code[20].</param>
    /// <param name="ligne">VAR Text[62].</param>
    procedure LigneEntete(code_paie: Code[20]; var ligne: Text[62]);
    begin

        CompanyBusinessUnit.GET('SIEGE');

        BankAccount.RESET;
        BankAccount.SETRANGE("No.", CompanyBusinessUnit."Payroll Bank Account");
        BankAccount.FINDFIRST;
        key := FORMAT(BankAccount."Bank Account No.");

        IF (STRLEN(key) < 2) THEN
            REPEAT
                key := '0' + key;
            UNTIL (STRLEN(key) = 2)
        ELSE
            IF (STRLEN(key) > 2) THEN
                ERROR(T005);



        compte := BankAccount."Bank Account No.";

        IF (STRLEN(compte) < 10) THEN
            REPEAT
                compte := '0' + compte;
            UNTIL (STRLEN(compte) = 10)
        ELSE
            IF (STRLEN(compte) > 10) THEN
                ERROR(T006);


        CodCalcMontantGlobal(code_paie, mnt);
        CodNbSalarié(code_paie, NbS);
        ligne := '*00000000' + compte + key + mnt + NbS + COPYSTR(code_paie, 6, 2) + COPYSTR(code_paie, 1, 4) + '              0';


        // les controls
        //if ()
    end;

    procedure "CodCalcMontantSalarié"(code_paie: Code[20]; "NoSalarié": Code[20]; var SalaireNet: Text[13]);
    begin
        PayrollSetup.GET;
        PayrollArchiveLine.RESET;
        PayrollArchiveLine.SETRANGE("Payroll Code", code_paie);
        PayrollArchiveLine.SETRANGE("Item Code", PayrollSetup."Net Salary");
        PayrollArchiveLine.SETRANGE("Employee No.", NoSalarié);

        PayrollArchiveLine.FINDFIRST;
        Montant := PayrollArchiveLine.Amount;
        mont := Montant * 100;
        c := '';
        IF (mont > 1) THEN
            REPEAT
            BEGIN
                c := FORMAT((mont DIV 1) MOD 1000) + c;
                IF (((mont DIV 1) MOD 1000) < 100) THEN c := '0' + c;
                IF (((mont DIV 1) MOD 1000) < 10) THEN c := '0' + c;


                mont := mont DIV 1000;
            END;
            UNTIL mont < 1;
        SalaireNet := c;
        c := '0';

        IF (STRLEN(SalaireNet) < 13) THEN
            REPEAT
                SalaireNet := c + SalaireNet;
            UNTIL (STRLEN(SalaireNet) = 13);
    end;

    /// <summary>
    /// CodName.
    /// </summary>
    /// <param name="No">Code[20].</param>
    /// <param name="Name">VAR Text[27].</param>
    /// <param name="P_compte">VAR Text[12].</param>
    procedure CodName(No: Code[20]; var Name: Text[27]; var P_compte: Text[12]);
    begin
        salarié.RESET;
        salarié.SETRANGE("No.", No);
        salarié.FINDFIRST;
        prenom := salarié."First Name";
        nom := salarié."Last Name";
        Name := nom + ' ' + prenom;
        IF (STRLEN(Name) < 27) THEN
            REPEAT
                Name := Name + ' ';
            UNTIL (STRLEN(Name) = 27);

        key := FORMAT(salarié."RIB Key");
        IF (STRLEN(key) < 2) THEN
            REPEAT
                key := '0' + key;
            UNTIL (STRLEN(key) = 2)
        ELSE
            IF (STRLEN(key) > 2) THEN
                ERROR('%1 %2 %3', T001, salarié."No.", T002);

        compte := salarié."Payroll Bank Account No.";

        IF (STRLEN(compte) < 10) THEN
            REPEAT
                compte := '0' + compte;
            UNTIL (STRLEN(compte) = 10)
        ELSE
            IF (STRLEN(compte) > 10) THEN
                ERROR('%1 %2 %3', T003, salarié."No.", T004);


        P_compte := compte + key;
    end;

    procedure LigneSalarie(Code_paie: Code[20]);
    begin
        compt := 2;
        PayrollSetup.GET;
        PayrollArchiveLine2.RESET;
        PayrollArchiveLine2.SETRANGE("Payroll Code", Code_paie);
        PayrollArchiveLine2.SETRANGE("Item Code", PayrollSetup."Net Salary");
        PayrollArchiveLine2.FINDFIRST;
        REPEAT
            CodName(PayrollArchiveLine2."Employee No.", LName, LCompte);
            CodCalcMontantSalarié(Code_paie, PayrollArchiveLine2."Employee No.", Lmontant);
            ligneS := '*00000000' + LCompte + Lmontant + LName + '1';
            //MESSAGE(ligneS);
            table.INIT;
            table.No := compt;
            table.ligne := ligneS;
            table.INSERT;
            compt := compt + 1;


        UNTIL PayrollArchiveLine2.NEXT = 0;
    end;

    procedure CodeTrans(Code_paie: Code[20]);
    begin


        LigneEntete('2010-03', m);
        table.INIT;
        table.No := 1;
        table.ligne := m;
        table.INSERT;

        LigneSalarie('2010-03');
    end;
}

