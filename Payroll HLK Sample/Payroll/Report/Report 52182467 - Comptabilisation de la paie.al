/// <summary>
/// Report Comptabilisation de la paie (ID 52182467).
/// </summary>
report 52182467 "Comptabilisation de la paie"
{
    // version HALRHPAIE.6.2.00

    // //Axe Analytique

    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";

            trigger OnPostDataItem();
            begin
                IF NOT AxeAnalytique.GET('SALARIE') THEN BEGIN
                    AxeAnalytique.INIT;
                    AxeAnalytique.Code := 'SALARIE';
                    AxeAnalytique.Name := 'Salarié';
                    //Axe Analytique
                    AxeAnalytique."Code Caption" := 'Salarié Code';
                    AxeAnalytique."Filter Caption" := 'Salarié filtre';
                    //Axe Analytique
                    AxeAnalytique.INSERT;
                END;
                Paie.RESET;
                IF CodePaie = '' THEN BEGIN
                    CASE Mois OF
                        1, 3, 5, 7, 8, 10, 12:
                            Jour := 31;
                        4, 6, 9, 11:
                            Jour := 30;
                        2:
                            IF Annee MOD 4 = 0 THEN
                                Jour := 29
                            ELSE
                                Jour := 28;
                    END;
                    DebutPeriode := DMY2DATE(1, Mois, Annee);
                    FinPeriode := DMY2DATE(Jour, Mois, Annee);
                    Paie.SETFILTER("Ending Date", '%1..%2', DebutPeriode, FinPeriode);
                END
                ELSE
                    Paie.SETRANGE(Code, CodePaie);
                IF UniteConcernee <> 'Toutes les unités' THEN
                    Paie.SETRANGE("Company Business Unit Code", CodeUnite);
                FOR i := 1 TO 10 DO
                    FOR j := 1 TO 2 DO
                        Tableau[i] [j] := 0;
                NbreTaux := 0;
                IF Paie.FINDFIRST THEN
                    REPEAT
                        IF Paie."Ending Date" = 0D THEN
                            ERROR(Text03, Paie.FIELDCAPTION("Ending Date"), Paie.Code);
                        Mois := DATE2DMY(Paie."Ending Date", 2);
                        Annee := DATE2DMY(Paie."Ending Date", 3);
                        CumulerPaie(Paie.Code);
                    UNTIL Paie.NEXT = 0;
                GenererEcritureCompta;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Date de Comptabilisation"; DateComptabilisation)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        //accesspay.accesstopay;
        ParamPaie.GET;
        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(Text01, USERID);
        CodeUnite := GestionnairePaie."Company Business Unit Code";
        IF CodeUnite = '' THEN
            UniteConcernee := 'Toutes les unités'
        ELSE
            UniteConcernee := CodeUnite;
        Mois := DATE2DMY(TODAY, 2);
        Annee := DATE2DMY(TODAY, 3);
        SoldeParCompte := FALSE;
    end;

    trigger OnPreReport();
    begin
        IF DataItem8955.GETFILTERS = '' THEN BEGIN
            CodePaie := '';
            IF Mois = 0 THEN
                ERROR(Text02, 'Mois');
            IF (Mois < 1) OR (Mois > 12) THEN
                ERROR('Mois incorrect !');
            IF Annee = 0 THEN
                ERROR(Text02, 'Année');
            IF (Annee < 1900) OR (Annee > 2100) THEN
                ERROR('Année incorrecte !');
            NumDocument := STRSUBSTNO('PAIE %1 %2', FORMAT(Mois), FORMAT(Annee));
        END
        ELSE BEGIN
            DataItem8955.COPYFILTER(Code, Paie.Code);
            Paie.FINDFIRST;
            CodePaie := Paie.Code;

            DateComptabilisation := Paie."Ending Date";
            NumDocument := STRSUBSTNO('PAIE %1', CodePaie);
        END;
        IF CodeUnite = '' THEN BEGIN
            ParamPaie.TESTFIELD("Payroll Journal Template Name");
            ParamPaie.TESTFIELD("Payroll Journal Batch Name");
            Modele := ParamPaie."Payroll Journal Template Name";
            Feuille := ParamPaie."Payroll Journal Batch Name";
        END
        ELSE BEGIN
            UniteSociete.GET(CodeUnite);
            UniteSociete.TESTFIELD("Payroll Journal Template Name");
            UniteSociete.TESTFIELD("Payroll Journal Batch Name");
            Modele := UniteSociete."Payroll Journal Template Name";
            Feuille := UniteSociete."Payroll Journal Batch Name";
        END;
        ModeleFeuille.GET(Modele);
        IF CodeUnite = '' THEN
            CodeUnite := ModeleFeuille."Company Business Unit";
        Journal := ModeleFeuille."Source Code";
        IF NOT CONFIRM(Text04, FALSE, 'de la paie ', CodePaie) THEN
            EXIT;
        TamponCompta.RESET;
        TamponCompta.DELETEALL;
        TotalisationCompta.RESET;
        TotalisationCompta.DELETEALL;
        Progression.OPEN('Paie    #1#########\Salarié #2#########');
    end;

    var
        Mois: Integer;
        Annee: Integer;
        ParamPaie: Record Payroll_Setup;
        GestionnairePaie: Record "Payroll Manager";
        CodeUnite: Code[10];
        Text01: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text02: Label 'Information manquante : %1 !';
        CodePaie: Code[20];
        Paie: Record Payroll;
        UniteConcernee: Text[30];
        Text03: Label '%1 non paramétrée pour la paie %2 !';
        Jour: Integer;
        DebutPeriode: Date;
        FinPeriode: Date;
        UniteSociete: Record "Company Business Unit";
        payroll: Record Payroll;
        ModeleFeuille: Record 80;
        Modele: Code[10];
        Feuille: Code[10];
        Journal: Code[10];
        TamponCompta: Record "G/L Payroll Buffer";
        TamponCompta2: Record "G/L Payroll Buffer";
        EcriturePaie: Record "Payroll Entry";
        Rubrique: Record "Payroll Item";
        NumProchaineSequence: Integer;
        Text04: Label '"Générer les écritures comptables %1 %2 ? "';
        Text05: Label 'Génération de l''écriture comptable %1 %2 effectuée avec succès.\Modèle %3, Feuille %4';
        Progression: Dialog;
        EcritureCompta: Record 81;
        EcritureCompta2: Record 81;
        ParamCompta: Record 98;
        NumDocument: Code[20];
        CpteGeneral: Record 15;
        HistTransactPaie: Record "Payroll Register";
        Base: Decimal;
        i: Integer;
        j: Integer;
        Tableau: array[10, 10] of Decimal;
        NbreTaux: Integer;
        Arret: Boolean;
        Debit1: Decimal;
        Debit2: Decimal;
        Credit: Decimal;
        TotalisationCompta: Record "Totalisation comptable de paie";
        TotalisationCompta2: Record "Totalisation comptable de paie";
        SectionAnalytique: Record 349;
        AxeAnalytique: Record 348;
        BaseOeuvresSociales: Decimal;
        BaseTaxeFormation: Decimal;
        SoldeParCompte: Boolean;
        Salarie: Record 5200;
        GlobalDimension1CodeDebit: Code[20];
        GlobalDimension2CodeDebit: Code[20];
        AccountNoDebit: Code[20];
        GlobalDimension1CodeCredit: Code[20];
        GlobalDimension2CodeCredit: Code[20];
        AccountNoCredit: Code[20];
        GlobalDimension1CodeDebitLocal: Code[20];
        GlobalDimension2CodeDebitLocal: Code[20];
        AccountNoDebitLocal: Code[20];
        GlobalDimension1CodeCreditLocal: Code[20];
        GlobalDimension2CodeCreditLocal: Code[20];
        AccountNoCreditLocal: Code[20];
        ItemCode: Code[20];
        DateComptabilisation: Date;
        DateComptabilisationFilter: Date;

    /// <summary>
    /// CumulerPaie.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    procedure CumulerPaie(P_Paie: Code[20]);
    begin
        //Axe Analytique
        GlobalDimension1CodeDebit := '';
        GlobalDimension2CodeDebit := '';
        AccountNoDebit := '';
        GlobalDimension1CodeCredit := '';
        GlobalDimension2CodeCredit := '';
        AccountNoCredit := '';

        //Axe Analytique
        EcriturePaie.RESET;
        EcriturePaie.SETCURRENTKEY("Employee No.", "Document No.");
        EcriturePaie.SETRANGE("Document No.", P_Paie);

        //EcriturePaie.SETFILTER("Employee No.",'%1','000001');

        //EcriturePaie.SETFILTER("Item Code",'<>%1',ParamPaie."Base Salary");
        IF EcriturePaie.FINDFIRST THEN
            REPEAT
                Progression.UPDATE(1, P_Paie);
                Progression.UPDATE(2, EcriturePaie."Employee No.");
                Rubrique.GET(EcriturePaie."Item Code");
                //Mvt Débit
                IF Rubrique."Account No." <> '' THEN BEGIN
                    IF NOT TamponCompta.GET(EcriturePaie."Item Code", EcriturePaie."Employee No.", TamponCompta.Nature::Debit) THEN BEGIN
                        TamponCompta.INIT;
                        TamponCompta."Item Code" := EcriturePaie."Item Code";
                        TamponCompta."Account No." := Rubrique."Account No.";
                        TamponCompta."Company Business Unit Code" := EcriturePaie."Company Business Unit Code";
                        TamponCompta."Employee No." := EcriturePaie."Employee No.";
                        TamponCompta.Nature := TamponCompta.Nature::Debit;
                        //Axe Analytique
                        TamponCompta."Global Dimension 1 Code" := EcriturePaie."Global Dimension 1 Code";
                        TamponCompta."Global Dimension 2 Code" := EcriturePaie."Global Dimension 2 Code";
                        //Axe Analytique
                        TamponCompta.INSERT;
                    END;
                    TamponCompta.GET(EcriturePaie."Item Code", EcriturePaie."Employee No.", TamponCompta.Nature::Debit);
                    TamponCompta.Amount := TamponCompta.Amount + ROUND(EcriturePaie.Amount);
                    TamponCompta.MODIFY;
                    //Axe Analytique
                    IF NOT TotalisationCompta.GET(Rubrique."Account No.", EcriturePaie."Global Dimension 1 Code", EcriturePaie."Global Dimension 2 Code") THEN BEGIN
                        TotalisationCompta.INIT;
                        GlobalDimension1CodeDebitLocal := EcriturePaie."Global Dimension 1 Code";
                        GlobalDimension2CodeDebitLocal := EcriturePaie."Global Dimension 2 Code";
                        AccountNoDebitLocal := EcriturePaie."Account No.";
                        IF (AccountNoDebit <> AccountNoDebitLocal) OR (GlobalDimension1CodeDebit <> GlobalDimension1CodeDebitLocal) OR (GlobalDimension2CodeDebit <> GlobalDimension2CodeDebitLocal) THEN BEGIN
                            AccountNoDebit := AccountNoDebitLocal;
                            GlobalDimension1CodeDebit := GlobalDimension1CodeDebitLocal;
                            GlobalDimension2CodeDebit := GlobalDimension2CodeDebitLocal;
                            TotalisationCompta."Account No." := AccountNoDebit;
                            TotalisationCompta."Global Dimension 1 Code" := GlobalDimension1CodeDebit;
                            TotalisationCompta."Global Dimension 2 Code" := GlobalDimension2CodeDebit;
                            TotalisationCompta.INSERT;
                        END;
                    END;

                END;

                //Mvt Crédit
                IF Rubrique."Bal. Account No." <> '' THEN BEGIN
                    IF NOT TamponCompta.GET(EcriturePaie."Item Code", EcriturePaie."Employee No.", TamponCompta.Nature::Credit) THEN BEGIN
                        TamponCompta.INIT;
                        TamponCompta."Item Code" := EcriturePaie."Item Code";
                        TamponCompta."Account No." := Rubrique."Bal. Account No.";
                        TamponCompta."Company Business Unit Code" := EcriturePaie."Company Business Unit Code";
                        TamponCompta."Employee No." := EcriturePaie."Employee No.";
                        TamponCompta.Nature := TamponCompta.Nature::Credit;
                        //Axe Analytique
                        TamponCompta."Global Dimension 1 Code" := EcriturePaie."Global Dimension 1 Code";
                        TamponCompta."Global Dimension 2 Code" := EcriturePaie."Global Dimension 2 Code";
                        //Axe Analytique
                        TamponCompta.INSERT;
                    END;
                    TamponCompta.GET(EcriturePaie."Item Code", EcriturePaie."Employee No.", TamponCompta.Nature::Credit);
                    IF (EcriturePaie."Item Code" = ParamPaie."Net Salary") OR (EcriturePaie."Item Code" = ParamPaie."Employer Cotisation") THEN
                        TamponCompta.Amount := TamponCompta.Amount + (ROUND(EcriturePaie.Amount))
                    ELSE
                        IF (EcriturePaie."Item Code" <> ParamPaie."Employee SS Deduction") THEN
                            TamponCompta.Amount := TamponCompta.Amount + ABS(ROUND(EcriturePaie.Amount));
                    IF (EcriturePaie."Item Code" = ParamPaie."Employee SS Deduction") THEN
                        IF EcriturePaie.Amount > 0 THEN
                            TamponCompta.Amount := TamponCompta.Amount - (ROUND(EcriturePaie.Amount))
                        ELSE
                            TamponCompta.Amount := TamponCompta.Amount - (ROUND(EcriturePaie.Amount));
                    TamponCompta.MODIFY;
                    //Axe Analytique

                    IF NOT TotalisationCompta.GET(Rubrique."Bal. Account No.", EcriturePaie."Global Dimension 1 Code", EcriturePaie."Global Dimension 2 Code") THEN BEGIN
                        TotalisationCompta.INIT;
                        GlobalDimension1CodeCreditLocal := EcriturePaie."Global Dimension 1 Code";
                        GlobalDimension2CodeCreditLocal := EcriturePaie."Global Dimension 2 Code";
                        AccountNoCreditLocal := EcriturePaie."Bal. Account No.";
                        IF (AccountNoCredit <> AccountNoCreditLocal) OR (GlobalDimension1CodeCredit <> GlobalDimension1CodeCreditLocal) OR (GlobalDimension2CodeCredit <> GlobalDimension2CodeCreditLocal) THEN BEGIN
                            AccountNoCredit := AccountNoCreditLocal;
                            GlobalDimension1CodeCredit := GlobalDimension1CodeCreditLocal;
                            GlobalDimension2CodeCredit := GlobalDimension2CodeCreditLocal;
                            TotalisationCompta."Account No." := AccountNoCredit;
                            TotalisationCompta."Global Dimension 1 Code" := GlobalDimension1CodeCredit;
                            TotalisationCompta."Global Dimension 2 Code" := GlobalDimension2CodeCredit;
                            TotalisationCompta.INSERT;
                        END;
                        //Axe Analytique
                    END;

                END;
                //Bases de calcul
                IF STRPOS(ParamPaie."Base oeuvres sociales", EcriturePaie."Item Code") > 0 THEN
                    BaseOeuvresSociales := BaseOeuvresSociales + EcriturePaie.Amount;
                IF STRPOS(ParamPaie."Base taxe formation", EcriturePaie."Item Code") > 0 THEN
                    BaseTaxeFormation := BaseTaxeFormation + EcriturePaie.Amount;
                IF EcriturePaie."Item Code" = ParamPaie."Employer Cotisation" THEN BEGIN
                    i := 1;
                    Arret := FALSE;
                    REPEAT
                        IF Tableau[i] [1] = EcriturePaie.Rate THEN
                            Arret := TRUE
                        ELSE
                            i := i + 1;
                        IF i > NbreTaux THEN
                            Arret := TRUE;
                    UNTIL Arret;
                    IF i > NbreTaux THEN BEGIN
                        NbreTaux := NbreTaux + 1;
                        i := NbreTaux;
                        Tableau[i] [1] := EcriturePaie.Rate;
                    END;
                    Tableau[i] [2] := Tableau[i] [2] + EcriturePaie.Basis;
                END;
                EcriturePaie."Account No." := Rubrique."Account No.";
                EcriturePaie."Bal. Account No." := Rubrique."Bal. Account No.";
                EcriturePaie.MODIFY;
                HistTransactPaie.RESET;
                HistTransactPaie.SETRANGE("Payroll Code", P_Paie);
                HistTransactPaie.FINDFIRST;
                HistTransactPaie.Recorded := TRUE;
                HistTransactPaie."Recording Date" := TODAY;
                HistTransactPaie."Recorded By" := USERID;
                HistTransactPaie.MODIFY;
            UNTIL EcriturePaie.NEXT = 0;
    end;

    /// <summary>
    /// GenererEcritureCompta.
    /// </summary>
    procedure GenererEcritureCompta();
    begin
        //***Suppression des écritures de la feuille***
        EcritureCompta.RESET;
        EcritureCompta.SETRANGE("Journal Template Name", Modele);
        EcritureCompta.SETRANGE("Journal Batch Name", Feuille);
        NumProchaineSequence := 0;
        IF ParamPaie."Delete Existing Entries" THEN BEGIN
            IF EcritureCompta.FINDSET THEN
                EcritureCompta.DELETEALL;
        END
        ELSE
            IF EcritureCompta.FINDLAST THEN
                NumProchaineSequence := EcritureCompta."Line No.";
        ParamCompta.GET;
        /*AnalytiqueLigne.RESET;
        AnalytiqueLigne.SETRANGE("Table ID",81);
        AnalytiqueLigne.SETRANGE("Journal Template Name",Modele);
        AnalytiqueLigne.SETRANGE("Journal Batch Name",Feuille);
        AnalytiqueLigne.DELETEALL;*/
        TotalisationCompta.RESET;
        IF TotalisationCompta.FINDFIRST THEN
            REPEAT
                CpteGeneral.GET(TotalisationCompta."Account No.");
                IF CpteGeneral."Detail By Employee" THEN BEGIN
                    TamponCompta.RESET;
                    TamponCompta.SETRANGE("Account No.", TotalisationCompta."Account No.");
                    //Axe Analytique
                    TamponCompta.SETRANGE("Global Dimension 1 Code", TotalisationCompta."Global Dimension 1 Code");
                    TamponCompta.SETRANGE("Global Dimension 2 Code", TotalisationCompta."Global Dimension 2 Code");
                    //Axe Analytique
                    TamponCompta.FINDFIRST;
                    REPEAT
                        NumProchaineSequence := NumProchaineSequence + 100;
                        EcritureCompta.INIT;
                        EcritureCompta."Journal Template Name" := Modele;
                        EcritureCompta."Journal Batch Name" := Feuille;
                        EcritureCompta."Source Code" := Journal;
                        EcritureCompta."Line No." := NumProchaineSequence;
                        EcritureCompta."Account Type" := EcritureCompta."Account Type"::"G/L Account";
                        EcritureCompta."Account No." := TamponCompta."Account No.";
                        EcritureCompta."Posting Date" := DateComptabilisation;// TODAY;
                        EcritureCompta."Document No." := NumDocument;
                        EcritureCompta.Description := CpteGeneral.Name;
                        IF TamponCompta.Nature = TamponCompta.Nature::Debit THEN
                            EcritureCompta.VALIDATE(Amount, TamponCompta.Amount)
                        ELSE
                            EcritureCompta.VALIDATE(Amount, -TamponCompta.Amount);
                        //Axe Analytique
                        EcritureCompta.VALIDATE("Shortcut Dimension 1 Code", TotalisationCompta."Global Dimension 1 Code");
                        EcritureCompta.VALIDATE("Shortcut Dimension 2 Code", TotalisationCompta."Global Dimension 2 Code");
                        //Axe Analytique
                        Salarie.GET(TamponCompta."Employee No.");
                        EcritureCompta."Description 2" := Salarie."First Name" + ' ' + Salarie."Last Name";
                        EcritureCompta."Description 2" := Salarie."Last Name" + ' ' + Salarie."First Name";
                        EcritureCompta."Employee code" := TamponCompta."Employee No.";
                        IF NOT SectionAnalytique.GET('SALARIE', TamponCompta."Employee No.") THEN BEGIN
                            SectionAnalytique.INIT;
                            SectionAnalytique."Dimension Code" := 'SALARIE';
                            SectionAnalytique.Code := TamponCompta."Employee No.";
                            SectionAnalytique.INSERT;
                        END;
                        /*AnalytiqueLigne.INIT;
                        AnalytiqueLigne."Table ID":=81;
                        AnalytiqueLigne."Journal Template Name":=Modele;
                        AnalytiqueLigne."Journal Batch Name":=Feuille;
                        AnalytiqueLigne."Journal Line No.":=NumProchaineSequence;
                        AnalytiqueLigne."Dimension Code":='SALARIE';
                        AnalytiqueLigne."Dimension Value Code":=TamponCompta."Employee No.";
                        AnalytiqueLigne.INSERT;*/
                        EcritureCompta.INSERT;
                    UNTIL TamponCompta.NEXT = 0;
                END
                ELSE BEGIN
                    NumProchaineSequence := NumProchaineSequence + 100;
                    EcritureCompta.INIT;
                    EcritureCompta."Journal Template Name" := Modele;
                    EcritureCompta."Journal Batch Name" := Feuille;
                    EcritureCompta."Source Code" := Journal;
                    EcritureCompta."Line No." := NumProchaineSequence;
                    EcritureCompta."Account Type" := EcritureCompta."Account Type"::"G/L Account";
                    EcritureCompta."Account No." := TotalisationCompta."Account No.";
                    EcritureCompta."Posting Date" := DateComptabilisation;// TODAY;
                    EcritureCompta."Document No." := NumDocument;
                    EcritureCompta.Description := CpteGeneral.Name;
                    TotalisationCompta.CALCFIELDS("Debit Total", "Credit Total");
                    //Axe Analytique
                    EcritureCompta.VALIDATE("Shortcut Dimension 1 Code", TotalisationCompta."Global Dimension 1 Code");
                    EcritureCompta.VALIDATE("Shortcut Dimension 2 Code", TotalisationCompta."Global Dimension 2 Code");
                    //Axe Analytique
                    IF SoldeParCompte THEN BEGIN
                        EcritureCompta.VALIDATE(Amount, TotalisationCompta."Debit Total" - TotalisationCompta."Credit Total");
                        //Axe Analytique
                        EcritureCompta.VALIDATE("Shortcut Dimension 1 Code", TotalisationCompta."Global Dimension 1 Code");
                        EcritureCompta.VALIDATE("Shortcut Dimension 2 Code", TotalisationCompta."Global Dimension 2 Code");
                        //Axe Analytique
                        EcritureCompta.INSERT;
                    END
                    ELSE BEGIN
                        IF TotalisationCompta."Debit Total" <> 0 THEN BEGIN
                            EcritureCompta.VALIDATE(Amount, TotalisationCompta."Debit Total");
                            //Axe Analytique
                            EcritureCompta.VALIDATE("Shortcut Dimension 1 Code", TotalisationCompta."Global Dimension 1 Code");
                            EcritureCompta.VALIDATE("Shortcut Dimension 2 Code", TotalisationCompta."Global Dimension 2 Code");
                            //Axe Analytique
                            EcritureCompta.INSERT;
                        END;
                        IF TotalisationCompta."Credit Total" <> 0 THEN BEGIN
                            NumProchaineSequence := NumProchaineSequence + 100;
                            EcritureCompta."Line No." := NumProchaineSequence;
                            EcritureCompta.VALIDATE(Amount, -TotalisationCompta."Credit Total");
                            //Axe Analytique
                            EcritureCompta.VALIDATE("Shortcut Dimension 1 Code", TotalisationCompta."Global Dimension 1 Code");
                            EcritureCompta.VALIDATE("Shortcut Dimension 2 Code", TotalisationCompta."Global Dimension 2 Code");
                            //Axe Analytique
                            EcritureCompta.INSERT;
                        END;
                    END;
                END
            UNTIL TotalisationCompta.NEXT = 0;
        /*IF ParamPaie."Compta. les charges patronales"THEN
          BEGIN
            //***Ecriture de contribution aux oeuvres sociales***
            EcritureCompta.INIT;
            EcritureCompta."Journal Template Name":=Modele;
            EcritureCompta."Journal Batch Name":=Feuille;
            EcritureCompta."Source Code":=Journal;
            EcritureCompta."Account Type":=EcritureCompta."Account Type"::"G/L Account";
            EcritureCompta."Posting Date":=TODAY;
            EcritureCompta."Document No.":=NumDocument;
            //***Débit***
            NumProchaineSequence:=NumProchaineSequence+100;
            EcritureCompta."Line No.":=NumProchaineSequence;
            EcritureCompta."Account No.":=ParamPaie."Cpte oeuvres sociales (débit)";
            CpteGeneral.GET(ParamPaie."Cpte oeuvres sociales (débit)");
            EcritureCompta.Description:=CpteGeneral.Name;
            EcritureCompta.VALIDATE(Amount,BaseOeuvresSociales*ParamPaie."Taux oeuvres sociales"/100);
            //Axe Analytique
            EcritureCompta.VALIDATE("Shortcut Dimension 1 Code",TotalisationCompta."Global Dimension 1 Code");
            EcritureCompta.VALIDATE("Shortcut Dimension 2 Code",TotalisationCompta."Global Dimension 2 Code");
            //Axe Analytique
            EcritureCompta.INSERT;
            //***Crédit***
            NumProchaineSequence:=NumProchaineSequence+100;
            EcritureCompta."Line No.":=NumProchaineSequence;
            EcritureCompta."Account No.":=ParamPaie."Cpte oeuvres sociales (crédit)";
            CpteGeneral.GET(ParamPaie."Cpte oeuvres sociales (crédit)");
            EcritureCompta.Description:=CpteGeneral.Name;
            EcritureCompta.VALIDATE(Amount,-BaseOeuvresSociales*ParamPaie."Taux oeuvres sociales"/100);
            //Axe Analytique
            EcritureCompta.VALIDATE("Shortcut Dimension 1 Code",TotalisationCompta."Global Dimension 1 Code");
            EcritureCompta.VALIDATE("Shortcut Dimension 2 Code",TotalisationCompta."Global Dimension 2 Code");
            //Axe Analytique
            EcritureCompta.INSERT;*/
        //***Ecriture de cotisation patronale***
        /* FOR i:=1 TO NbreTaux DO
           BEGIN
             EcritureCompta.INIT;
             EcritureCompta."Journal Template Name":=Modele;
             EcritureCompta."Journal Batch Name":=Feuille;
             EcritureCompta."Source Code":=Journal;
             EcritureCompta."Account Type":=EcritureCompta."Account Type"::"G/L Account";
             EcritureCompta."Posting Date":=TODAY;
             EcritureCompta."Document No.":=NumDocument;
             Debit2:=ROUND(Tableau[i][2]*ParamPaie."Taux cotisation patronale"/100);
             Credit:=ROUND(Tableau[i][2]*Tableau[i][1]/100);
             Debit1:=Credit-Debit2;
             //***Débit 1 ***
             NumProchaineSequence:=NumProchaineSequence+100;
             EcritureCompta."Line No.":=NumProchaineSequence;
             EcritureCompta."Account No.":=ParamPaie."Cpte 1 cotis. patron. (débit)";
             CpteGeneral.GET(ParamPaie."Cpte 1 cotis. patron. (débit)");
             EcritureCompta.Description:=CpteGeneral.Name;
             EcritureCompta.VALIDATE(Amount,Debit1);
             //Axe Analytique
             EcritureCompta.VALIDATE("Shortcut Dimension 1 Code",TotalisationCompta."Global Dimension 1 Code");
             EcritureCompta.VALIDATE("Shortcut Dimension 2 Code",TotalisationCompta."Global Dimension 2 Code");
             //Axe Analytique
             EcritureCompta.INSERT;
             //***Débit 2 ***
             NumProchaineSequence:=NumProchaineSequence+100;
             EcritureCompta."Line No.":=NumProchaineSequence;
             EcritureCompta."Account No.":=ParamPaie."Cpte 2 cotis. patron. (débit)";
             CpteGeneral.GET(ParamPaie."Cpte 2 cotis. patron. (débit)");
             EcritureCompta.Description:=CpteGeneral.Name;
             EcritureCompta.VALIDATE(Amount,Debit2);
             //Axe Analytique
             EcritureCompta.VALIDATE("Shortcut Dimension 1 Code",TotalisationCompta."Global Dimension 1 Code");
             EcritureCompta.VALIDATE("Shortcut Dimension 2 Code",TotalisationCompta."Global Dimension 2 Code");
             //Axe Analytique
             EcritureCompta.INSERT;
             //***Crédit***
             NumProchaineSequence:=NumProchaineSequence+100;
             EcritureCompta."Line No.":=NumProchaineSequence;
             EcritureCompta."Account No.":=ParamPaie."Cpte cotis.patronales (crédit)";
             CpteGeneral.GET(ParamPaie."Cpte oeuvres sociales (crédit)");
             EcritureCompta.Description:=CpteGeneral.Name;
             EcritureCompta.VALIDATE(Amount,-Credit);
             //Axe Analytique
             EcritureCompta.VALIDATE("Shortcut Dimension 1 Code",TotalisationCompta."Global Dimension 1 Code");
             EcritureCompta.VALIDATE("Shortcut Dimension 2 Code",TotalisationCompta."Global Dimension 2 Code");
             //Axe Analytique
             EcritureCompta.INSERT;
           END;*/
        //***Ecriture de taxe de formation et d'apprentissage***
        /*EcritureCompta.INIT;
        EcritureCompta."Journal Template Name":=Modele;
        EcritureCompta."Journal Batch Name":=Feuille;
        EcritureCompta."Source Code":=Journal;
        EcritureCompta."Account Type":=EcritureCompta."Account Type"::"G/L Account";
        EcritureCompta."Posting Date":=TODAY;
        EcritureCompta."Document No.":=NumDocument;
        //***Débit***
        NumProchaineSequence:=NumProchaineSequence+100;
        EcritureCompta."Line No.":=NumProchaineSequence;
        EcritureCompta."Account No.":=ParamPaie."Cpte taxe form. appr. (débit)";
        CpteGeneral.GET(ParamPaie."Cpte taxe form. appr. (débit)");
        EcritureCompta.Description:=CpteGeneral.Name;
        EcritureCompta.VALIDATE(Amount,BaseTaxeFormation*ParamPaie."Taux taxe formation"/100);
        //Axe Analytique
        EcritureCompta.VALIDATE("Shortcut Dimension 1 Code",TotalisationCompta."Global Dimension 1 Code");
        EcritureCompta.VALIDATE("Shortcut Dimension 2 Code",TotalisationCompta."Global Dimension 2 Code");
        //Axe Analytique
        EcritureCompta.INSERT;
        //***Crédit***
        NumProchaineSequence:=NumProchaineSequence+100;
        EcritureCompta."Line No.":=NumProchaineSequence;
        EcritureCompta."Account No.":=ParamPaie."Cpte taxe form. appr. (crédit)";
        CpteGeneral.GET(ParamPaie."Cpte taxe form. appr. (crédit)");
        EcritureCompta.Description:=CpteGeneral.Name;
        EcritureCompta.VALIDATE(Amount,-BaseTaxeFormation*ParamPaie."Taux taxe formation"/100);
        //Axe Analytique
        EcritureCompta.VALIDATE("Shortcut Dimension 1 Code",TotalisationCompta."Global Dimension 1 Code");
        EcritureCompta.VALIDATE("Shortcut Dimension 2 Code",TotalisationCompta."Global Dimension 2 Code");
        //Axe Analytique
        EcritureCompta.INSERT;
      END;*/
        Progression.CLOSE;
        MESSAGE(Text05, 'de la paie', NumDocument, Modele, Feuille);

    end;
}

