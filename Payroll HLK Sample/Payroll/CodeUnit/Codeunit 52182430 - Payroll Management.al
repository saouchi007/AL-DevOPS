/// <summary>
/// Codeunit Payroll Managemen ExtHLK (ID 52182430).
/// </summary>
codeunit 52182430 "Payroll Managemen ExtHLK"
//codeunit 39108402 "Payroll Management"
{
    // version HALRHPAIE.6.2.00

    // //Test
    // //TFinPeriodePaie:=Paie."Ending Date";estCours
    // //Prime panier et Transport
    // //Cacobatph


    trigger OnRun();
    begin
        //NbreJoursPresencePanierTransport('000025');
    end;

    var
        HistTransactPaie: Record "Payroll Register";
        EcriturePaie: Record "Payroll Entry";
        Text01: Label 'Annuler %1 %2 ? Toutes les écritures salaires seront annulées irrévocablement.\Veuillez lancer le traitement de correction des congés.';
        Text02: Label '"Générer les écritures comptables %1 %2 ? "';
        Text03: Label 'Génération de l''écriture comptable %1 %2 effectuée avec succès.\Modèle %3, Feuille %4';
        ParamPaie: Record Payroll_Setup;
        ModeleFeuille: Code[10];
        Feuille: Code[10];
        Journal: Code[10];
        GenJournalBatch: Record 232;
        GenJournalTemplate: Record 80;
        NumProchaineSequence: Integer;
        GenJournalLine: Record 81;
        ParametresCompta: Record 98;
        Salarie: Record 5200;
        Cpte: Record 15;
        Paie: Record Payroll;
        Text04: Label '%1 %2 est clôturé(e) !';
        Text05: Label 'Suppression impossible du salarié %1. Il est utilisé dans la table %2.';
        EmployeeQualification: Record 5203;
        EmployeeRelative: Record 5205;
        AbsenceSalarie: Record 5207;
        EmployeeDiploma: Record "Employee Diploma";
        EmployeeAssignment: Record "Employee Assignment";
        EmployeeFulfilledFunction: Record "Employee Fulfilled Function";
        EmployeeMisconduct: Record "Employee Sanction";
        EmployeeUnavailability: Record "Employee Unavailability";
        EmployeeContract: Record "Employee Contract";
        EmployeeRecovery: Record "Employee Recovery";
        RubriqueSalarie: Record "Employee Payroll Item";
        RubriqueSalarie2: Record "Employee Payroll Item";
        EmployeeAdvance: Record "Employee Advance";
        EmployeeUnionSubscription: Record "Employee Union Subscription";
        EmployeeOvertime: Record "Employee Overtime";
        EmployeeLeave: Record "Employee Leave";
        GestionnairePaie: Record "Payroll Manager";
        Text06: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        UniteSociete: Record "Company Business Unit";
        CodeDirection: Code[10];
        CodePaie: Code[20];
        Text07: Label 'Calcul du rappel %1 effectué avec succès.\Génération de %2 écritures pour 1 salarié.';
        Text08: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        DebutPeriodePaie: Date;
        FinPeriodePaie: Date;
        OvertimeCategory: Record "Overtime Category";
        Text09: Label 'Rappel %1 déjà calculé ! Veuillez l''annuler avant de relancer le calcul.\Voulez-vous l''annuler maintenant ?';
        Text10: Label 'Rubrique "Salaire de base" manquante !';
        SalaireBase: Decimal;
        SalaireImposableSansConge: Decimal;
        SalaireImposable: Decimal;
        SalairePoste: Decimal;
        Rubrique: Record "Payroll Item";
        TauxHoraire: Decimal;
        Montant: Decimal;
        TotalMontant: Decimal;
        BaseIRG: Decimal;
        LigneRembMedical: Record "Medical Refund Line";
        NumeroSalarie: Code[20];
        TreatmentIndexGrid: Record "Treatment Section Grid";
        TreatmentHourlyIndexGrid: Record "Treatment Hourly Index Grid";
        Abattement: Decimal;
        Taux: Decimal;
        PayrollLineArchive: Record "Payroll Archive Line";
        PayrollHeaderArchive: Record "Payroll Archive Header";
        NbreHeuresAbsence: Decimal;
        BaremeIRG: Record "TIT Grid"; // yes is missing AK
        TypePaie: Record "Payroll Type";
        MontantPaie: Decimal;
        CongeNbre: Decimal;
        CongeMontant: Decimal;
        CongeIRG: Decimal;
        BaseIRGHorsBareme: Decimal;
        NbreHeuresVacataire: Decimal;
        NbreJoursVacataire: Decimal;
        Pret: Record Lending;
        TypePret: Record "Lending Type";
        "No.": Integer;
        SalaireBrut: Decimal;
        BaseIRGHorsBaremeBrut: Decimal;
        Rubrique2: Record "Payroll Item";
        TotalMensualite: Decimal;
        Coefficient: Decimal;
        Base: Decimal;
        Tableau: array[10, 10] of Decimal;
        i: Integer;
        j: Integer;
        Arret: Boolean;
        NbreTaux: Integer;
        Debit1: Decimal;
        Debit2: Decimal;
        Credit: Decimal;
        Nbre: Decimal;
        RubriqueMin: Text[10];
        RubriqueMax: Text[10];
        IndemniteConge: Decimal;
        MotifAbsence: Record 5206;
        Text11: Label 'Veuillez exécuter le traitement d''actualisation des congés ?';
        Indice: Decimal;
        TotalIndices: Decimal;
        IndiceMinimal: Decimal;
        RS: Record "Employee Payroll Item";
        Text12: Label 'Type de prêt non paramétré pour le prêt %1 !';
        Text13: Label 'Veuillez vérifier le remboursement du prêt %1 !';
        CongeNbreMois: Decimal;
        EcritureCongeExercice: Record "Leave Right";
        TotalNbreJours: Decimal;
        PayrollTemplateLine: Record "Payroll Template Line";

    /// <summary>
    /// CalcPaieSalarie.
    /// </summary>
    /// <param name="EmployeeNumber">Code[20].</param>
    procedure CalcPaieSalarie(EmployeeNumber: Code[20]);
    begin
        NumeroSalarie := EmployeeNumber;
        ParamPaie.GET;
        Salarie.GET(NumeroSalarie);
        ControlerParametres(NumeroSalarie);
        IF Salarie."Payroll Type Code" = '' THEN BEGIN
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETCURRENTKEY(Type);
            RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETRANGE(Type, RubriqueSalarie.Type::Formule);
            RubriqueSalarie.SETFILTER("Item Code",
            '<>%1&<>%2&<>%3', ParamPaie."Base Salary", '222', ParamPaie."Lending Deduction (Capital)");
            RubriqueSalarie.DELETEALL;
            ConstaterRubriquesSalarie;
            //***REACTUALISATION DES RUBRIQUES POURCENTAGE***
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETCURRENTKEY(Type);
            RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETRANGE(Type, RubriqueSalarie.Type::Pourcentage);
            IF RubriqueSalarie.FINDSET THEN
                REPEAT
                    Rubrique.GET(RubriqueSalarie."Item Code");
                    Rubrique.TESTFIELD("Basis of Calculation");
                    RubriqueSalarie2.GET(NumeroSalarie, Rubrique."Basis of Calculation");
                    RubriqueSalarie.Basis := RubriqueSalarie2.Amount;
                    RubriqueSalarie.Amount := ROUND(RubriqueSalarie.Basis * RubriqueSalarie.Rate / 100);
                    RubriqueSalarie.MODIFY(TRUE);
                UNTIL RubriqueSalarie.NEXT = 0;
            //***REACTUALISATION DES RUBRIQUES AU PRORATA***
            RubriqueSalarie2.RESET;
            RubriqueSalarie2.SETCURRENTKEY(Type);
            RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie2.SETRANGE(RubriqueSalarie2.Type, RubriqueSalarie2.Type::"Au prorata");
            IF RubriqueSalarie2.FINDSET THEN
                REPEAT
                    IF Salarie.Regime = Salarie.Regime::"Vacataire journalier" THEN BEGIN
                        RubriqueSalarie.GET(NumeroSalarie, ParamPaie."No. of Days (Daily Vacatary)");
                        RubriqueSalarie2.Rate := NbreJoursPresence(NumeroSalarie) / ParamPaie."No. of Worked Days";
                    END;
                    IF Salarie.Regime = Salarie.Regime::"Vacataire horaire" THEN BEGIN
                        RubriqueSalarie.GET(NumeroSalarie, ParamPaie."No. of Hours (Hourly Vacatary)");
                        RubriqueSalarie2.Rate := NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours";
                    END;
                    IF Salarie.Regime = Salarie.Regime::Mensuel THEN BEGIN
                        IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                            RubriqueSalarie2.Rate := NbreJoursPresence(NumeroSalarie) / ParamPaie."No. of Worked Days";
                        IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                            RubriqueSalarie2.Rate := NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours";
                    END;
                    RubriqueSalarie2.Amount := ROUND(RubriqueSalarie2.Basis * RubriqueSalarie2.Rate);
                    RubriqueSalarie2.MODIFY;
                UNTIL RubriqueSalarie2.NEXT = 0;
            RubriqueSalarie2.RESET;
            RubriqueSalarie2.SETCURRENTKEY(Type);
            RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie2.SETRANGE(RubriqueSalarie2.Type, RubriqueSalarie2.Type::"Libre saisie");
            IF RubriqueSalarie2.FINDSET THEN
                REPEAT
                    IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                        RubriqueSalarie2.Amount := ROUND(RubriqueSalarie2.Basis * RubriqueSalarie2.Number);
                    IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                        RubriqueSalarie2.Amount := ROUND(RubriqueSalarie2.Basis * RubriqueSalarie2.Number);
                    RubriqueSalarie2.Amount := ROUND(RubriqueSalarie2.Basis * RubriqueSalarie2.Number);
                    RubriqueSalarie2.MODIFY;
                UNTIL RubriqueSalarie2.NEXT = 0;
            //***REACTUALISATION DES RUBRIQUES AU PRORATA AUTORISE***
            Salarie.CALCFIELDS("Total Unauthorised Absence");
            RubriqueSalarie2.RESET;
            RubriqueSalarie2.SETCURRENTKEY(Type);
            RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie2.SETRANGE(RubriqueSalarie2.Type, RubriqueSalarie2.Type::"Au prorata autorisé");
            IF RubriqueSalarie2.FINDSET THEN
                REPEAT
                    IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                        RubriqueSalarie2.Rate := (ParamPaie."No. of Worked Days" - Salarie."Total Unauthorised Absence")
                        / ParamPaie."No. of Worked Days";
                    IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                        RubriqueSalarie2.Rate := (ParamPaie."No. of Worked Hours"
                        - Salarie."Total Unauthorised Absence" / ParamPaie."No. of Hours By Day") / ParamPaie."No. of Worked Hours";
                    RubriqueSalarie2.Amount := ROUND(RubriqueSalarie2.Basis * RubriqueSalarie2.Rate);
                    RubriqueSalarie2.MODIFY;
                UNTIL RubriqueSalarie2.NEXT = 0;
            //***IRG HORS BAREME***
            RubriqueSalarie2.RESET;
            RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
            BaseIRGHorsBareme := 0;
            IF RubriqueSalarie2.FINDFIRST THEN
                REPEAT
                    IF Rubrique.GET(RubriqueSalarie2."Item Code") THEN
                        IF Rubrique."TIT Out of Grid" THEN
                            BaseIRGHorsBareme := BaseIRGHorsBareme + RubriqueSalarie2.Amount;
                UNTIL RubriqueSalarie2.NEXT = 0;
            BaseIRGHorsBaremeBrut := 0;
            IF BaseIRGHorsBareme > 0 THEN BEGIN
                BaseIRGHorsBaremeBrut := BaseIRGHorsBareme;
                BaseIRGHorsBareme := BaseIRGHorsBareme;
                RubriqueSalarie2.INIT;
                RubriqueSalarie2."Employee No." := NumeroSalarie;
                RubriqueSalarie2."Item Code" := ParamPaie."TIT Out of Grid";
                Rubrique.GET(ParamPaie."TIT Out of Grid");
                RubriqueSalarie2."Item Description" := Rubrique.Description;
                RubriqueSalarie2.Basis := BaseIRGHorsBareme;
                RubriqueSalarie2.Rate := ParamPaie."TIT Out of Grid %";
                //RubriqueSalarie2.Amount:=-ROUND(BaseIRGHorsBareme*ParamPaie."TIT Out of Grid %"/100,0.1); Commented
                RubriqueSalarie2.Amount := -ROUND(BaseIRGHorsBareme * ParamPaie."TIT Out of Grid %" / 100, 0.01);  //Code added
                RubriqueSalarie2.Type := Rubrique."Item Type";
                RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
                RubriqueSalarie2.Taxable := Rubrique.Taxable;
                RubriqueSalarie2.Regularization := Rubrique.Regularization;
                RubriqueSalarie2.INSERT;
            END;
            RubriqueSalarie2.RESET;
            RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
            IF RubriqueSalarie2.FINDFIRST THEN
                REPEAT
                    Rubrique.GET(RubriqueSalarie2."Item Code");
                    RubriqueSalarie2.Taxable := Rubrique.Taxable;
                    RubriqueSalarie2.Regularization := Rubrique.Regularization;
                    RubriqueSalarie2.MODIFY;
                UNTIL RubriqueSalarie2.NEXT = 0;
            //***CALCUL DES RUBRIQUES DE PARAMETRAGE***
            CalcEmployeePayrollSetupItem(ParamPaie."Post Salary");
            //Prime panier et Transport
            CalcEmployeeFraisPanier;
            CalcEmployeeIndemniteTransport;
            //Prime panier et Transport
            CalcEmployeeSSDeduction;
            CalcEmployeePayrollSetupItem(ParamPaie."Taxable Salary");
            //Cacobatph
            IF ParamPaie."Inclure Cacobatph" = TRUE THEN BEGIN
                CalcEmployeeCacobatphDeduction();
                CalcEmployeePretbatphDeduction();
            END;
            //Cacobatph
            //Element 25 Début
            Rubrique.GET(ParamPaie."DAIP Taxable Salary");
            RubriqueMin := COPYSTR(Rubrique."Calculation Formula", 1, 3);
            RubriqueMax := COPYSTR(Rubrique."Calculation Formula", 6, 3);
            RubriqueSalarie2.RESET;
            RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie2.SETRANGE("TIT Out of Grid", TRUE);
            IF RubriqueSalarie2.FINDFIRST THEN
                REPEAT
                    IF (RubriqueSalarie2."Item Code" < RubriqueMin) OR (RubriqueSalarie2."Item Code" > RubriqueMax) THEN
                        IF RubriqueSalarie2."Item Code" < ParamPaie."Post Salary" THEN BEGIN
                            // Commenté par khaled
                            /*  RubriqueSalarie.GET(NumeroSalarie,ParamPaie."Taxable Salary");
                              RubriqueSalarie.Amount:=RubriqueSalarie.Amount
                              -RubriqueSalarie2.Amount*(100-ParamPaie."Employee SS %")/100;
                              RubriqueSalarie.MODIFY;*/
                            // Commenté par khaled
                            RubriqueSalarie.GET(NumeroSalarie, ParamPaie."TIT Out of Grid");
                            RubriqueSalarie.Basis := RubriqueSalarie.Basis
                            - RubriqueSalarie2.Amount * ParamPaie."Employee SS %" / 100;
                            //RubriqueSalarie.Amount:=-ROUND(RubriqueSalarie.Basis*RubriqueSalarie.Rate/100,0.1); Commented
                            RubriqueSalarie.Amount := -ROUND(RubriqueSalarie.Basis * RubriqueSalarie.Rate / 100, 0.01);  //Code added
                            RubriqueSalarie.MODIFY;
                        END
                        ELSE BEGIN
                            RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Taxable Salary");
                            //RubriqueSalarie.Amount:=RubriqueSalarie.Amount-RubriqueSalarie2.Amount;
                            RubriqueSalarie.MODIFY;
                            RubriqueSalarie.GET(NumeroSalarie, ParamPaie."TIT Out of Grid");
                            RubriqueSalarie.Basis := RubriqueSalarie2.Amount;
                            RubriqueSalarie.Amount := -ROUND(RubriqueSalarie.Basis * ParamPaie."TIT Out of Grid %" / 100, 0.01);
                            RubriqueSalarie.MODIFY;
                        END;
                UNTIL RubriqueSalarie2.NEXT = 0;
            //Element 25 Fin
            CalcEmployeeTITDeduction;
            ConstaterMutuelle;
            ConstaterRemboursementFrais;
            ConstaterFrais;
            CalcEmployeePayrollSetupItem(ParamPaie."Net Salary");
            //Element 25 Début
            // Commenté par khaled
            /*
            RubriqueSalarie2.RESET;
            RubriqueSalarie2.SETRANGE("Employee No.",NumeroSalarie);
            RubriqueSalarie2.SETRANGE("TIT Out of Grid",TRUE);
            IF RubriqueSalarie2.FINDFIRST THEN
              REPEAT
                IF (RubriqueSalarie2."Item Code"<RubriqueMin)OR(RubriqueSalarie2."Item Code">RubriqueMax)THEN
                  IF RubriqueSalarie2."Item Code"<ParamPaie."Post Salary" THEN
                    BEGIN
                      RubriqueSalarie.GET(NumeroSalarie,ParamPaie."Net Salary");
                      RubriqueSalarie.Amount:=RubriqueSalarie.Amount
                      -RubriqueSalarie2.Amount*ParamPaie."Employee SS %"/100;
                      RubriqueSalarie.MODIFY;
                    END;
              UNTIL RubriqueSalarie2.NEXT=0;
              */
            // Fin Commenté par khaled
            //Element 25 Fin
            CalcEmployerSSDeduction;
            CalcSalaireBrut;
            //Paie DAIP
            Rubrique.GET(ParamPaie."DAIP Taxable Salary");
            EVALUATE(i, ParamPaie."Taxable Salary");
            IF Rubrique."Calculation Formula" <> STRSUBSTNO('%1..%2', ParamPaie."Post Salary", i - 1) THEN BEGIN
                CalcEmployeePayrollSetupItem(ParamPaie."DAIP Taxable Salary");
                RubriqueSalarie2.RESET;
                RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
                RubriqueSalarie2.SETRANGE("Item Code", ParamPaie."DAIP Taxable Salary");
                IF RubriqueSalarie2.FINDFIRST THEN
                    IF RubriqueSalarie2.Amount = 0 THEN
                        RubriqueSalarie2.DELETE;
                RubriqueSalarie.RESET;
                RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
            END;
        END
        ELSE BEGIN
            TypePaie.GET(Salarie."Payroll Type Code");
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETRANGE(Type, RubriqueSalarie.Type::Formule);
            RubriqueSalarie.SETFILTER("Item Code", '<>%1', '222');
            RubriqueSalarie.DELETEALL;
            IF ParamPaie.Advances THEN
                ConstaterAvances;
            IF ParamPaie."Medical Refunds" THEN
                ConstaterFraisMedicaux;
            ConstaterFrais;
            RubriqueSalarie.SETRANGE(Type, RubriqueSalarie.Type::"Libre saisie");
            RubriqueSalarie.SETFILTER("Item Code", '<>%1&<%2', '222', ParamPaie."Taxable Salary");
            MontantPaie := 0;
            IF RubriqueSalarie.FINDFIRST THEN
                REPEAT
                    MontantPaie := MontantPaie + RubriqueSalarie.Amount;
                UNTIL RubriqueSalarie.NEXT = 0;
            IF TypePaie."SS Deduction" THEN BEGIN
                IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Post Salary") THEN
                    RubriqueSalarie.DELETE;
                RubriqueSalarie2.INIT;
                RubriqueSalarie2."Employee No." := NumeroSalarie;
                RubriqueSalarie2."Item Code" := ParamPaie."Post Salary";
                Rubrique.GET(ParamPaie."Post Salary");
                RubriqueSalarie2."Item Description" := Rubrique.Description;
                RubriqueSalarie2.Number := 1;
                RubriqueSalarie2.Basis := MontantPaie;
                RubriqueSalarie2.Amount := MontantPaie;
                RubriqueSalarie2.Type := Rubrique."Item Type";
                RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
                RubriqueSalarie2.Taxable := Rubrique.Taxable;
                RubriqueSalarie2.Regularization := Rubrique.Regularization;
                RubriqueSalarie2.INSERT;
                CalcEmployeeSSDeduction;
                RubriqueSalarie.SETFILTER("Item Code", ParamPaie."Employee SS Deduction");
                IF RubriqueSalarie.FINDFIRST THEN
                    MontantPaie := MontantPaie + RubriqueSalarie.Amount;
            END;
            IF TypePaie."IRG %" > 0 THEN BEGIN
                RubriqueSalarie.RESET;
                RubriqueSalarie.SETFILTER("Employee No.", NumeroSalarie);
                RubriqueSalarie.SETFILTER("Item Code", ParamPaie."Taxable Salary");
                IF RubriqueSalarie.FINDSET THEN
                    RubriqueSalarie.DELETE;
                RubriqueSalarie2.INIT;
                RubriqueSalarie2."Employee No." := NumeroSalarie;
                RubriqueSalarie2."Item Code" := ParamPaie."Taxable Salary";
                Rubrique.GET(ParamPaie."Taxable Salary");
                RubriqueSalarie2."Item Description" := Rubrique.Description;
                RubriqueSalarie2.Number := 1;
                RubriqueSalarie2.Basis := MontantPaie;
                RubriqueSalarie2.Amount := MontantPaie;
                RubriqueSalarie2.Type := Rubrique."Item Type";
                RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
                RubriqueSalarie2.Taxable := Rubrique.Taxable;
                RubriqueSalarie2.Regularization := Rubrique.Regularization;
                RubriqueSalarie2.INSERT;
                CalcIRGTaux;
            END
            ELSE
                CalcEmployeePayrollSetupItem(ParamPaie."DAIP Taxable Salary");
            //***Rubriques non imposables***
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETFILTER("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETFILTER("Item Code", '<>%1&<>%2&>%3', ParamPaie."Net Salary",
            ParamPaie."Employer Cotisation", ParamPaie."Taxable Salary");
            IF RubriqueSalarie.FINDFIRST THEN
                REPEAT
                    MontantPaie := MontantPaie + RubriqueSalarie.Amount;
                UNTIL RubriqueSalarie.NEXT = 0;
            RubriqueSalarie.SETFILTER("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETFILTER("Item Code", ParamPaie."Net Salary");
            IF RubriqueSalarie.FINDSET THEN
                RubriqueSalarie.DELETE;
            RubriqueSalarie2.INIT;
            RubriqueSalarie2."Employee No." := NumeroSalarie;
            RubriqueSalarie2."Item Code" := ParamPaie."Net Salary";
            Rubrique.GET(ParamPaie."Net Salary");
            RubriqueSalarie2."Item Description" := Rubrique.Description;
            RubriqueSalarie2.Number := 1;
            RubriqueSalarie2.Basis := MontantPaie;
            RubriqueSalarie2.Amount := MontantPaie;
            RubriqueSalarie2.Type := Rubrique."Item Type";
            RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
            RubriqueSalarie2.Taxable := Rubrique.Taxable;
            RubriqueSalarie2.Regularization := Rubrique.Regularization;
            RubriqueSalarie2.INSERT;
            CalcSalaireBrut;
        END;
        //Element 01 Début
        //***Droit au congé***
        CalcDroitConge(NumeroSalarie, CongeNbre, CongeMontant);
        CongeNbreMois := UniteSociete."Leave Nbre of Days by Month";
        Salarie.GET(NumeroSalarie);
        Coefficient := 1;
        IF Salarie."STC Payroll" THEN BEGIN
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                Coefficient := NbreJoursPresence(NumeroSalarie) / ParamPaie."No. of Worked Days";
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                Coefficient := NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours";
        END;
        IF Paie."Regular Payroll" THEN BEGIN
            //Element 19 Début
            IF Salarie."STC Payroll" THEN BEGIN
                IF RubriqueSalarie2.GET(NumeroSalarie, '222') THEN
                    CongeMontant := CongeMontant - RubriqueSalarie2.Amount / 12;
                IF (DATE2DMY(Salarie."Termination Date", 2) = DATE2DMY(FinPeriodePaie, 2))
                AND (DATE2DMY(Salarie."Termination Date", 3) = DATE2DMY(FinPeriodePaie, 3))
                AND (DATE2DMY(Salarie."Termination Date", 1) <= 15) THEN
                    Salarie."Leave Indemnity No." := 0
                ELSE
                    Salarie."Leave Indemnity No." := ROUND(NbreJoursPresence(NumeroSalarie) / CongeNbre * CongeNbreMois);
                Salarie."Leave Indemnity Amount" := ROUND(CongeMontant * CongeNbre / UniteSociete."Nbre de jours de congé par an");
            END
            ELSE BEGIN
                IF (DATE2DMY(Salarie."Employment Date", 2) = DATE2DMY(FinPeriodePaie, 2))
                AND (DATE2DMY(Salarie."Employment Date", 3) = DATE2DMY(FinPeriodePaie, 3))
                AND (DATE2DMY(Salarie."Employment Date", 1) > 15) THEN
                    CongeNbreMois := 0;
                Salarie."Leave Indemnity No." := CongeNbreMois;
                Salarie."Leave Indemnity Amount" := ROUND(CongeMontant * CongeNbre / UniteSociete."Nbre de jours de congé par an");
            END;
            //Element 19 Fin
        END
        ELSE BEGIN
            Salarie."Leave Indemnity No." := 0;
            Salarie."Leave Indemnity Amount" := ROUND(CongeMontant * CongeNbre / UniteSociete."Nbre de jours de congé par an");
        END;
        Salarie.MODIFY;
        //Element 01 Fin

    end;

    /// <summary>
    /// ControlerParametres.
    /// </summary>
    /// <param name="EmployeeNumber">Code[20].</param>
    procedure ControlerParametres(EmployeeNumber: Code[20]);
    begin
        ParamPaie.GET;
        GestionnairePaie.RESET;
        GestionnairePaie.SETRANGE("User ID", USERID);
        IF NOT GestionnairePaie.FINDSET THEN
            ERROR(Text06, USERID);
        CodeDirection := GestionnairePaie."Company Business Unit Code";
        IF CodeDirection = '' THEN
            ERROR(Text08, CodeDirection);
        UniteSociete.GET(CodeDirection);
        ParametresCompta.GET;
        Salarie.GET(EmployeeNumber);
        IF (Salarie."Company Business Unit Code" <> CodeDirection)
        OR (Salarie.Status = Salarie.Status::Inactive) THEN
            EXIT;
        IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN BEGIN
            Salarie.TESTFIELD("Section Grid Class");
            Salarie.TESTFIELD("Section Grid Section");
        END;
        IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN BEGIN
            Salarie.TESTFIELD("Hourly Index Grid Function No.");
            Salarie.TESTFIELD("Hourly Index Grid Function");
            Salarie.TESTFIELD("Hourly Index Grid CH");
        END;
        CodePaie := UniteSociete."Current Payroll";
        Paie.GET(CodePaie);
        IF Paie.Closed THEN
            ERROR(Text04, 'la paie', CodePaie);
        DebutPeriodePaie := Paie."Starting Date";
        FinPeriodePaie := Paie."Ending Date";
        //Test Karim
        //Salarie.SETFILTER("Date Filter",'%1..%2',DebutPeriodePaie,FinPeriodePaie);
        //Test Karim
        OvertimeCategory.RESET;
        OvertimeCategory.FINDFIRST;
        REPEAT
            OvertimeCategory.TESTFIELD(OvertimeCategory."Item Code");
        UNTIL OvertimeCategory.NEXT = 0;
        ParamPaie.TESTFIELD(ParamPaie."Advance Deduction");
        ParamPaie.TESTFIELD(ParamPaie."Overtime Filter");
        ParamPaie.TESTFIELD(ParamPaie."Union Subscription Deduction");
        ParamPaie.TESTFIELD(ParamPaie."Medical Refund");
        ParamPaie.TESTFIELD(ParamPaie."Professional Expances");
        ParamPaie.TESTFIELD(ParamPaie."Professional Expances Refund");
        DebutPeriodePaie := Paie."Starting Date";
        FinPeriodePaie := Paie."Ending Date";
        ParamPaie.TESTFIELD(ParamPaie."Post Salary");
        Rubrique.GET(ParamPaie."Post Salary");
        Rubrique.TESTFIELD(Rubrique.Nature, Rubrique.Nature::Calculated);
        Rubrique.TESTFIELD(Rubrique."Item Type", Rubrique."Item Type"::Formule);
        Rubrique.TESTFIELD(Rubrique."Calculation Formula");
        ParamPaie.TESTFIELD(ParamPaie."Taxable Salary");
        Rubrique.GET(ParamPaie."Taxable Salary");
        Rubrique.TESTFIELD(Rubrique.Nature, Rubrique.Nature::Calculated);
        Rubrique.TESTFIELD(Rubrique."Item Type", Rubrique."Item Type"::Formule);
        Rubrique.TESTFIELD(Rubrique."Calculation Formula");
        ParamPaie.TESTFIELD(ParamPaie."Net Salary");
        Rubrique.GET(ParamPaie."Net Salary");
        Rubrique.TESTFIELD(Rubrique.Nature, Rubrique.Nature::Calculated);
        Rubrique.TESTFIELD(Rubrique."Item Type", Rubrique."Item Type"::Formule);
        Rubrique.TESTFIELD(Rubrique."Calculation Formula");
        ParamPaie.TESTFIELD(ParamPaie."SS Basis");
        ParamPaie.TESTFIELD(ParamPaie."Employee SS Deduction");
        ParamPaie.TESTFIELD(ParamPaie."Employee SS %");
        ParamPaie.TESTFIELD(ParamPaie."TIT Deduction");
    end;

    /// <summary>
    /// ConstaterRubriquesSalarie.
    /// </summary>
    procedure ConstaterRubriquesSalarie();
    begin
        Salarie.SETFILTER("Date Filter", '%1..%2', DebutPeriodePaie, FinPeriodePaie);
        IF NOT Salarie."Do not Use Treatment Grid" THEN BEGIN
            CASE Salarie.Regime OF
                Salarie.Regime::Mensuel:
                    CalcSalaireBase(NumeroSalarie);
                Salarie.Regime::"Vacataire journalier":
                    CalcSalaireBaseJournalier(NumeroSalarie);
                Salarie.Regime::"Vacataire horaire":
                    CalcSalaireBaseHoraire(NumeroSalarie);
            END;
        END
        ELSE BEGIN
            // Hors Grille
            CalcSalaireBase(NumeroSalarie);
        END;
        RubriqueSalarie.SETCURRENTKEY("Employee No.", "Item Code");
        IF ParamPaie.Absences THEN
            ConstaterAbsences;
        IF ParamPaie.Advances THEN
            ConstaterAvances;
        IF ParamPaie.Overtime THEN
            ConstaterHeuresSupp;
        IF ParamPaie."Medical Refunds" THEN
            ConstaterFraisMedicaux;
        //***Element 35 Début***
        IF Salarie."Current IEP" + Salarie."Previous IEP" > 0 THEN
            CalcIEP;
        //***Element 35 Fin***
        CalcSalaireBasesansIndemnites;
        CalcRetenuePret;
    end;

    /// <summary>
    /// CalcEmployeePayrollSetupItem.
    /// </summary>
    /// <param name="PayrollItemCode">Code[20].</param>
    procedure CalcEmployeePayrollSetupItem(PayrollItemCode: Code[20]);
    begin
        Rubrique.GET(PayrollItemCode);
        CreateEmployeePayrollSetupItem;
    end;

    /// <summary>
    /// CreateEmployeePayrollSetupItem.
    /// </summary>
    procedure CreateEmployeePayrollSetupItem();
    begin
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETFILTER("Employee No.", NumeroSalarie);
        RubriqueSalarie.SETFILTER("Item Code", Rubrique.Code);
        IF RubriqueSalarie.FINDSET THEN
            RubriqueSalarie.DELETE;
        RubriqueSalarie.SETFILTER("Item Code", Rubrique."Calculation Formula");
        //Si
        IF Rubrique.Code = ParamPaie."Taxable Salary" THEN
            RubriqueSalarie.SETRANGE("TIT Out of Grid", FALSE);

        TotalMontant := 0;
        IF RubriqueSalarie.FINDSET THEN
            REPEAT
                TotalMontant := TotalMontant + ROUND(RubriqueSalarie.Amount);
            UNTIL RubriqueSalarie.NEXT = 0;
        // Commenté par khaled
        /*IF Rubrique.Code=ParamPaie."Net Salary"THEN
          TotalMontant:=TotalMontant+BaseIRGHorsBaremeBrut;*/
        // Fin Commenté par khaled
        //***Element 46 Début***
        IF Rubrique.Code = ParamPaie."Post Salary" THEN BEGIN
            Rubrique2.GET(ParamPaie."Base Salary Without Indemnity");
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETFILTER("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETFILTER("Item Code", Rubrique2."Calculation Formula");
            RubriqueSalarie.SETRANGE(Regularization, TRUE);
            IF RubriqueSalarie.FINDSET THEN
                REPEAT
                    TotalMontant := TotalMontant + ROUND(RubriqueSalarie.Amount);
                UNTIL RubriqueSalarie.NEXT = 0;
        END;
        //***Element 46 Fin***
        //Déduction des rubriques cotisables non imposables
        IF Rubrique.Code = ParamPaie."Taxable Salary" THEN BEGIN
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
            IF RubriqueSalarie.FINDFIRST THEN
                REPEAT
                    IF STRPOS(ParamPaie."Taxable Deduction Filter", RubriqueSalarie."Item Code") > 0 THEN
                        TotalMontant := TotalMontant - ROUND(RubriqueSalarie.Amount);
                UNTIL RubriqueSalarie.NEXT = 0;
        END;

        /*
        //Prise en compte des rubriques cotisables non imposable
        IF Rubrique.Code=ParamPaie."Net Salary"THEN
          BEGIN
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETRANGE("Employee No.",NumeroSalarie);
            RubriqueSalarie.SETFILTER("Item Code",'<%1',ParamPaie."Taxable Salary");
            IF RubriqueSalarie.FINDFIRST THEN
              REPEAT
                IF STRPOS(ParamPaie."Taxable Deduction Filter",RubriqueSalarie."Item Code")>0 THEN
                  TotalMontant:=TotalMontant+ROUND(RubriqueSalarie.Amount*(100-ParamPaie."Employee SS %")/100);
              UNTIL RubriqueSalarie.NEXT=0;
          END;  */
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := Rubrique.Code;
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        //Element 14 Début
        RubriqueSalarie2.Number := 1;
        RubriqueSalarie2.Amount := TotalMontant;
        //Si
        // Commenté par khaled
        /*IF Rubrique.Code=ParamPaie."Taxable Salary"THEN
          BEGIN
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETRANGE("Employee No.",NumeroSalarie);
            RubriqueSalarie.SETFILTER("Item Code",'<%1',ParamPaie."Taxable Salary");
            RubriqueSalarie.SETRANGE("TIT Out of Grid",TRUE);
            IF RubriqueSalarie.FINDFIRST THEN
              REPEAT
                IF RubriqueSalarie."TIT Out of Grid"THEN
                  TotalMontant:=TotalMontant+RubriqueSalarie.Amount;
              UNTIL RubriqueSalarie.NEXT=0;
          END;*/
        // Fin Commenté par khaled
        //Element 14 Fin
        RubriqueSalarie2.Basis := TotalMontant;
        IF TotalMontant < 0 THEN MESSAGE('%1  %2', 'SALAIRE NEGATIF Pour le salarié :', NumeroSalarie);
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;

    end;

    /// <summary>
    /// CalcSalaireBase.
    /// </summary>
    /// <param name="P_Salarie">Code[20].</param>
    procedure CalcSalaireBase(P_Salarie: Code[20]);
    begin
        Salarie.GET(P_Salarie);
        IF RubriqueSalarie.GET(P_Salarie, ParamPaie."Base Salary") THEN
            RubriqueSalarie.DELETE;

        IF NOT Salarie."Do not Use Treatment Grid" THEN BEGIN
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                CalcAmountFromSectionGrid;
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                CalcAmountFromHourlyIndexGrid;
            RubriqueSalarie2.INIT;
            RubriqueSalarie2."Employee No." := P_Salarie;
            RubriqueSalarie2."Item Code" := ParamPaie."Base Salary";
            Rubrique.GET(ParamPaie."Base Salary");
            RubriqueSalarie2."Item Description" := Rubrique.Description;
            //Element 32 Début
            IF ParamPaie."Show Post Salary Basis" THEN
                RubriqueSalarie2.Basis := ROUND(TotalIndices * ParamPaie."Index Point Value"
                / ParamPaie."No. of Worked Days")
            ELSE
                IF ParamPaie."Index Point Value" = 0 THEN
                    RubriqueSalarie2.Basis := TotalIndices
                ELSE
                    RubriqueSalarie2.Basis := TotalIndices * ParamPaie."Index Point Value";
            //Element 32 Fin
            RubriqueSalarie2.Number := ParamPaie."No. of Worked Days";
            IF ParamPaie."Apply Index Point Value" THEN
                RubriqueSalarie2.Amount := ROUND(TotalIndices * ParamPaie."Index Point Value")
            ELSE
                RubriqueSalarie2.Amount := ROUND(TotalIndices);
            RubriqueSalarie2.Type := Rubrique."Item Type";
            RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
            RubriqueSalarie2.Taxable := Rubrique.Taxable;
            RubriqueSalarie2.Regularization := Rubrique.Regularization;
            RubriqueSalarie2.INSERT;
        END
        // hors grille
        ELSE BEGIN
            RubriqueSalarie2.INIT;
            RubriqueSalarie2."Employee No." := P_Salarie;
            RubriqueSalarie2."Item Code" := ParamPaie."Base Salary";
            Rubrique.GET(ParamPaie."Base Salary");
            RubriqueSalarie2."Item Description" := Rubrique.Description;
            RubriqueSalarie2.Number := ParamPaie."No. of Worked Days";
            RubriqueSalarie2.Basis := Salarie."Base salary";
            RubriqueSalarie2.Type := Rubrique."Item Type";
            RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
            RubriqueSalarie2.Taxable := Rubrique.Taxable;
            RubriqueSalarie2.Regularization := Rubrique.Regularization;
            RubriqueSalarie2.Amount := Salarie."Base salary";
            RubriqueSalarie2.INSERT;
        END;
    end;

    /// <summary>
    /// CalcAmountFromSectionGrid.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcAmountFromSectionGrid(): Decimal;
    begin
        TreatmentIndexGrid.RESET;
        TreatmentIndexGrid.SETRANGE(Class, Salarie."Section Grid Class");
        TreatmentIndexGrid.SETRANGE(Section, Salarie."Section Grid Section");
        IF NOT TreatmentIndexGrid.FINDFIRST THEN
            EXIT;
        IndiceMinimal := TreatmentIndexGrid."Minimal Index";
        CASE Salarie."Section Grid Level" OF
            //Element 07 Début
            0:
                Indice := TreatmentIndexGrid."Minimal Index";
            //Element 07 Fin
            1:
                Indice := TreatmentIndexGrid."Level 1";
            2:
                Indice := TreatmentIndexGrid."Level 2";
            3:
                Indice := TreatmentIndexGrid."Level 3";
            4:
                Indice := TreatmentIndexGrid."Level 4";
            5:
                Indice := TreatmentIndexGrid."Level 5";
            6:
                Indice := TreatmentIndexGrid."Level 6";
            7:
                Indice := TreatmentIndexGrid."Level 7";
            8:
                Indice := TreatmentIndexGrid."Level 8";
            9:
                Indice := TreatmentIndexGrid."Level 9";
            10:
                Indice := TreatmentIndexGrid."Level 10";
            11:
                Indice := TreatmentIndexGrid."Level 11";
            12:
                Indice := TreatmentIndexGrid."Level 12";
            13:
                Indice := TreatmentIndexGrid."Level 13";
            14:
                Indice := TreatmentIndexGrid."Level 14";
            15:
                Indice := TreatmentIndexGrid."Level 15";
            16:
                Indice := TreatmentIndexGrid."Level 16";
            17:
                Indice := TreatmentIndexGrid."Level 17";
            18:
                Indice := TreatmentIndexGrid."Level 18";
            19:
                Indice := TreatmentIndexGrid."Level 19";
            20:
                Indice := TreatmentIndexGrid."Level 20";
        END;
        TotalIndices := Indice;
        IF ParamPaie."Include Minimal Index" THEN
            TotalIndices := TotalIndices + IndiceMinimal;
        EXIT(TotalIndices);
    end;

    /// <summary>
    /// CalcAmountFromHourlyIndexGrid.
    /// </summary>
    procedure CalcAmountFromHourlyIndexGrid();
    begin
        /*TreatmentHourlyIndexGrid.RESET;
        TreatmentHourlyIndexGrid.SETRANGE("No.",Salarie."Hourly Index Grid Function No.");
        IF NOT TreatmentHourlyIndexGrid.FIND('-')THEN
          EXIT;
        CASE Salarie."Hourly Index Grid Index" OF
          1 :Indice:=TreatmentHourlyIndexGrid."Section 1";
          2 :Indice:=TreatmentHourlyIndexGrid."Section 2";
          3 :Indice:=TreatmentHourlyIndexGrid."Section 3";
          4 :Indice:=TreatmentHourlyIndexGrid."Section 4";
          5 :Indice:=TreatmentHourlyIndexGrid."Section 5";
          6 :Indice:=TreatmentHourlyIndexGrid."Section 6";
          7 :Indice:=TreatmentHourlyIndexGrid."Section 7";
          8 :Indice:=TreatmentHourlyIndexGrid."Section 8";
          9 :Indice:=TreatmentHourlyIndexGrid."Section 9";
        END;
        TotalIndices:=Indice;     */

    end;

    /// <summary>
    /// CalcSalaireBasesansIndemnites.
    /// </summary>
    procedure CalcSalaireBasesansIndemnites();
    begin
        Rubrique.GET(ParamPaie."Base Salary Without Indemnity");
        IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Base Salary Without Indemnity") THEN
            RubriqueSalarie.DELETE;
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
        RubriqueSalarie.SETFILTER("Item Code", Rubrique."Calculation Formula");
        //***Element 46 Début***
        RubriqueSalarie.SETRANGE(Regularization, FALSE);
        //***Element 46 Fin***
        TotalMontant := 0;
        IF RubriqueSalarie.FINDSET THEN
            REPEAT
                TotalMontant := TotalMontant + ROUND(RubriqueSalarie.Amount);
            UNTIL RubriqueSalarie.NEXT = 0;
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := ParamPaie."Base Salary Without Indemnity";
        Rubrique.GET(ParamPaie."Base Salary Without Indemnity");
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        RubriqueSalarie2.Amount := TotalMontant;
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;
    end;

    /// <summary>
    /// ConstaterAbsences.
    /// </summary>
    procedure ConstaterAbsences();
    begin

        CASE Salarie.Regime OF
            Salarie.Regime::Mensuel:
                BEGIN
                    IF Salarie."Do not Use Treatment Grid" THEN
                        SalaireBase := Salarie."Base salary"
                    ELSE BEGIN
                        RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Base Salary");
                        SalaireBase := RubriqueSalarie.Amount;
                    END
                END;
            Salarie.Regime::"Vacataire journalier":
                BEGIN
                    IF Salarie."Do not Use Treatment Grid" THEN
                        SalaireBase := Salarie."Base salary"
                    ELSE BEGIN
                        RubriqueSalarie.GET(NumeroSalarie, ParamPaie."No. of Days (Daily Vacatary)");
                        SalaireBase := Salarie."Section Index";
                    END;
                END;
            Salarie.Regime::"Vacataire horaire":
                BEGIN
                    IF Salarie."Do not Use Treatment Grid" THEN
                        SalaireBase := Salarie."Base salary"
                    ELSE BEGIN
                        RubriqueSalarie.GET(NumeroSalarie, ParamPaie."No. of Hours (Hourly Vacatary)");
                        SalaireBase := Salarie."Section Index";
                    END;
                END;
        END;
        RubriqueSalarie.RESET;
        //Suppression des anciennes absences
        MotifAbsence.RESET;
        IF MotifAbsence.FINDFIRST THEN
            REPEAT
                IF MotifAbsence."Item Code" <> '' THEN
                    IF RubriqueSalarie.GET(NumeroSalarie, MotifAbsence."Item Code") THEN
                        RubriqueSalarie.DELETE;
            UNTIL MotifAbsence.NEXT = 0;
        //Génération des nouvelles absences
        AbsenceSalarie.RESET;
        AbsenceSalarie.SETCURRENTKEY("Employee No.", "To Be Deducted", "From Date");
        AbsenceSalarie.SETRANGE("Employee No.", NumeroSalarie);
        AbsenceSalarie.SETRANGE("To Be Deducted", TRUE);
        AbsenceSalarie.SETFILTER("From Date", '%1..%2', DebutPeriodePaie, FinPeriodePaie);
        IF AbsenceSalarie.FINDFIRST THEN
            REPEAT
                IF NOT RubriqueSalarie.GET(NumeroSalarie, AbsenceSalarie."Item Code") THEN BEGIN
                    RubriqueSalarie.INIT;
                    RubriqueSalarie."Employee No." := NumeroSalarie;
                    RubriqueSalarie."Item Code" := AbsenceSalarie."Item Code";
                    Rubrique.GET(AbsenceSalarie."Item Code");
                    RubriqueSalarie."Item Description" := Rubrique.Description;

                    IF AbsenceSalarie."Unit of Measure" = AbsenceSalarie."Unit of Measure"::Day THEN BEGIN
                        RubriqueSalarie.Basis := ROUND(SalaireBase / ParamPaie."No. of Worked Days");
                        RubriqueSalarie.Amount := ROUND(-AbsenceSalarie.Quantity * SalaireBase / ParamPaie."No. of Worked Days");
                    END;
                    IF AbsenceSalarie."Unit of Measure" = AbsenceSalarie."Unit of Measure"::Hour THEN BEGIN
                        RubriqueSalarie.Basis := ROUND(SalaireBase / ParamPaie."No. of Worked Hours");
                        RubriqueSalarie.Amount := ROUND(-AbsenceSalarie.Quantity * SalaireBase / ParamPaie."No. of Worked Hours");
                    END;
                    RubriqueSalarie.Type := Rubrique."Item Type";
                    RubriqueSalarie.Number := AbsenceSalarie.Quantity;
                    RubriqueSalarie."Submitted To Leave" := Rubrique."Submitted To Leave";
                    RubriqueSalarie.Taxable := Rubrique.Taxable;
                    RubriqueSalarie.Regularization := Rubrique.Regularization;
                    RubriqueSalarie.INSERT;
                END
                ELSE BEGIN
                    RubriqueSalarie.Number := RubriqueSalarie.Number + AbsenceSalarie.Quantity;
                    RubriqueSalarie.Amount := -ROUND(RubriqueSalarie.Number * RubriqueSalarie.Basis);
                    RubriqueSalarie.MODIFY;
                END;
            UNTIL AbsenceSalarie.NEXT = 0;
    end;

    /// <summary>
    /// ConstaterAvances.
    /// </summary>
    procedure ConstaterAvances();
    begin
        Salarie.SETFILTER("Date Filter", '%1..%2', DebutPeriodePaie, FinPeriodePaie);
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Item Code", ParamPaie."Advance Deduction");
        RubriqueSalarie.DELETEALL;
        Salarie.CALCFIELDS("Total Advance");
        IF Salarie."Total Advance" = 0 THEN
            EXIT;
        RubriqueSalarie.INIT;
        RubriqueSalarie."Employee No." := NumeroSalarie;
        RubriqueSalarie."Item Code" := ParamPaie."Advance Deduction";
        Rubrique.GET(ParamPaie."Advance Deduction");
        RubriqueSalarie."Item Description" := Rubrique.Description;
        RubriqueSalarie.Number := 1;
        RubriqueSalarie.Amount := -Salarie."Total Advance";
        RubriqueSalarie.Type := Rubrique."Item Type";
        RubriqueSalarie.Basis := Salarie."Total Advance";
        RubriqueSalarie."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie.Taxable := Rubrique.Taxable;
        RubriqueSalarie.Regularization := Rubrique.Regularization;
        RubriqueSalarie.INSERT;
    end;

    /// <summary>
    /// ConstaterHeuresSupp.
    /// </summary>
    procedure ConstaterHeuresSupp();
    begin
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", NumeroSalarie);
        RubriqueSalarie.SETFILTER(RubriqueSalarie."Item Code", ParamPaie."Overtime Filter");
        RubriqueSalarie.DELETEALL;
        CASE Salarie.Regime OF
            Salarie.Regime::Mensuel:
                BEGIN
                    IF Salarie."Do not Use Treatment Grid" THEN
                        SalaireBase := Salarie."Base salary"
                    ELSE BEGIN
                        RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Base Salary");
                        SalaireBase := RubriqueSalarie.Amount;
                    END;
                END;
            Salarie.Regime::"Vacataire journalier":
                BEGIN

                    IF Salarie."Do not Use Treatment Grid" THEN
                        SalaireBase := Salarie."Base salary"
                    ELSE BEGIN
                        RubriqueSalarie.GET(NumeroSalarie, ParamPaie."No. of Days (Daily Vacatary)");
                        SalaireBase := Salarie."Section Index";
                    END;
                END;
            Salarie.Regime::"Vacataire horaire":
                BEGIN
                    IF Salarie."Do not Use Treatment Grid" THEN
                        SalaireBase := Salarie."Base salary"
                    ELSE BEGIN
                        RubriqueSalarie.GET(NumeroSalarie, ParamPaie."No. of Hours (Hourly Vacatary)");
                        SalaireBase := Salarie."Section Index";
                    END;
                END;
        END;


        OvertimeCategory.RESET;
        OvertimeCategory.FINDFIRST;
        REPEAT
            //****** Calcul basé sur Jours ou heures supplémentaires
            IF OvertimeCategory.Code = '999' THEN
                TauxHoraire := SalaireBase / ParamPaie."No. of Worked Days"
            ELSE
                TauxHoraire := SalaireBase / ParamPaie."No. of Worked Hours";
            //****** Fin Calcul basé sur Jours ou heures supplémentaires

            Salarie.SETFILTER(Salarie."Overtime Category Filter", OvertimeCategory.Code);
            Salarie.CALCFIELDS(Salarie."Total Overtime (Base)");
            IF Salarie."Total Overtime (Base)" > 0 THEN BEGIN
                RubriqueSalarie.INIT;
                RubriqueSalarie."Employee No." := NumeroSalarie;
                RubriqueSalarie."Item Code" := OvertimeCategory."Item Code";
                RubriqueSalarie."Item Description" := OvertimeCategory."Item Description";
                RubriqueSalarie.Number := Salarie."Total Overtime (Base)";
                RubriqueSalarie.Basis := ROUND(TauxHoraire * (1 + OvertimeCategory."Majoration %" / 100));
                RubriqueSalarie.Amount := ROUND(RubriqueSalarie.Basis * RubriqueSalarie.Number);
                Rubrique.GET(OvertimeCategory."Item Code");
                RubriqueSalarie.Type := Rubrique."Item Type";
                RubriqueSalarie."Submitted To Leave" := Rubrique."Submitted To Leave";
                RubriqueSalarie.Taxable := Rubrique.Taxable;
                RubriqueSalarie.Regularization := Rubrique.Regularization;
                RubriqueSalarie.INSERT;
            END;
        UNTIL OvertimeCategory.NEXT = 0;
    end;

    /// <summary>
    /// ConstaterMutuelle.
    /// </summary>
    procedure ConstaterMutuelle();
    begin
        IF (Salarie."Union Code" <> '') AND (Salarie."Union Membership No." <> '') THEN BEGIN
            EmployeeUnionSubscription.RESET;
            EmployeeUnionSubscription.SETRANGE(EmployeeUnionSubscription."Employee No.", Salarie."No.");
            EmployeeUnionSubscription.SETRANGE(EmployeeUnionSubscription."Union/Insurance Code", Salarie."Union Code");
            IF EmployeeUnionSubscription.FINDLAST THEN BEGIN
                IF (EmployeeUnionSubscription."Ending Date" >= DebutPeriodePaie)
                AND (EmployeeUnionSubscription."Starting Date" <= FinPeriodePaie) THEN
                    CalcMutuelleFixe;
            END
            ELSE
                CalcMutuelleTaux;
        END;
    end;

    /// <summary>
    /// ConstaterFraisMedicaux.
    /// </summary>
    procedure ConstaterFraisMedicaux();
    begin
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", NumeroSalarie);
        RubriqueSalarie.SETFILTER(RubriqueSalarie."Item Code", ParamPaie."Medical Refund");
        RubriqueSalarie.DELETEALL;
        LigneRembMedical.RESET;
        LigneRembMedical.SETRANGE(Type, LigneRembMedical.Type::Employee);
        LigneRembMedical.SETRANGE("No.", NumeroSalarie);
        IF LigneRembMedical.FINDFIRST THEN BEGIN
            Montant := 0;
            REPEAT
                IF (LigneRembMedical."Refund Date" >= Paie."Starting Date")
                AND (LigneRembMedical."Refund Date" <= Paie."Ending Date") THEN
                    Montant := Montant + LigneRembMedical."Refund Amount";
            UNTIL LigneRembMedical.NEXT = 0;
            IF Montant > 0 THEN BEGIN
                RubriqueSalarie.INIT;
                RubriqueSalarie."Employee No." := NumeroSalarie;
                RubriqueSalarie."Item Code" := ParamPaie."Medical Refund";
                Rubrique.GET(ParamPaie."Medical Refund");
                RubriqueSalarie."Item Description" := Rubrique.Description;
                RubriqueSalarie.Number := 1;
                RubriqueSalarie.Basis := Montant;
                RubriqueSalarie.Amount := Montant;
                RubriqueSalarie.Type := Rubrique."Item Type";
                RubriqueSalarie."Submitted To Leave" := Rubrique."Submitted To Leave";
                RubriqueSalarie.Taxable := Rubrique.Taxable;
                RubriqueSalarie.Regularization := Rubrique.Regularization;
                RubriqueSalarie.INSERT;
            END;
        END;
    end;

    /// <summary>
    /// ConstaterRemboursementFrais.
    /// </summary>
    procedure ConstaterRemboursementFrais();
    begin
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Item Code", ParamPaie."Professional Expances Refund");
        RubriqueSalarie.DELETEALL;
        Salarie.CALCFIELDS(Salarie."Total Profess. Expances Refund");
        IF Salarie."Total Profess. Expances Refund" = 0 THEN
            EXIT;
        RubriqueSalarie.INIT;
        RubriqueSalarie."Employee No." := NumeroSalarie;
        RubriqueSalarie."Item Code" := ParamPaie."Professional Expances Refund";
        Rubrique.GET(ParamPaie."Professional Expances Refund");
        RubriqueSalarie."Item Description" := Rubrique.Description;
        RubriqueSalarie.Amount := Salarie."Total Profess. Expances Refund";
        RubriqueSalarie.Type := Rubrique."Item Type";
        RubriqueSalarie.Basis := Salarie."Total Profess. Expances Refund";
        RubriqueSalarie.Number := 1;
        RubriqueSalarie."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie.Taxable := Rubrique.Taxable;
        RubriqueSalarie.Regularization := Rubrique.Regularization;
        RubriqueSalarie.INSERT;
    end;

    /// <summary>
    /// ConstaterFrais.
    /// </summary>
    procedure ConstaterFrais();
    begin
        //filter date
        Salarie.SETFILTER("Date Filter", '%1..%2', DebutPeriodePaie, FinPeriodePaie);
        //filter date

        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Item Code", ParamPaie."Professional Expances");
        RubriqueSalarie.DELETEALL;
        Salarie.CALCFIELDS("Total Professional Expances");
        IF Salarie."Total Professional Expances" = 0 THEN
            EXIT;
        RubriqueSalarie.INIT;
        RubriqueSalarie."Employee No." := NumeroSalarie;
        RubriqueSalarie."Item Code" := ParamPaie."Professional Expances";
        Rubrique.GET(ParamPaie."Professional Expances");
        RubriqueSalarie."Item Description" := Rubrique.Description;
        RubriqueSalarie.Amount := Salarie."Total Professional Expances";
        RubriqueSalarie.Type := Rubrique."Item Type";
        RubriqueSalarie.Basis := Salarie."Total Professional Expances";
        RubriqueSalarie.Number := 1;
        RubriqueSalarie."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie.Taxable := Rubrique.Taxable;
        RubriqueSalarie.Regularization := Rubrique.Regularization;
        RubriqueSalarie.INSERT;
    end;

    /// <summary>
    /// CalcEmployeeSSDeduction.
    /// </summary>
    procedure CalcEmployeeSSDeduction();
    begin
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Item Code", ParamPaie."SS Basis");
        RubriqueSalarie.FINDFIRST;
        Rubrique.GET(ParamPaie."Employee SS Deduction");
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := Rubrique.Code;
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        RubriqueSalarie2.Amount := ROUND(-1 * RubriqueSalarie.Amount * ParamPaie."Employee SS %" / 100);
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2.Basis := RubriqueSalarie.Amount;
        RubriqueSalarie2.Rate := ParamPaie."Employee SS %";
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;
    end;

    /// <summary>
    /// CalcEmployerSSDeduction.
    /// </summary>
    procedure CalcEmployerSSDeduction();
    begin
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Item Code", ParamPaie."SS Basis");
        RubriqueSalarie.FINDFIRST;
        Rubrique.GET(ParamPaie."Employer Cotisation");
        Taux := Salarie."Employer Cotisation %";
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := Rubrique.Code;
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        RubriqueSalarie2.Amount := ROUND(RubriqueSalarie.Amount * Taux / 100);
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2.Basis := RubriqueSalarie.Amount;
        RubriqueSalarie2.Rate := Taux;
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;
    end;

    /// <summary>
    /// CalcEmployeeTITDeduction.
    /// </summary>
    procedure CalcEmployeeTITDeduction();
    var
        TauxLocal: Decimal;
        BaremeLocal: Decimal;
        TITOutGridBasis: Decimal;
    begin
        TITOutGridBasis := 0;
        // Début intervention khaled
        Rubrique.GET(ParamPaie."DAIP Taxable Salary");
        RubriqueMin := COPYSTR(Rubrique."Calculation Formula", 1, 3);
        RubriqueMax := COPYSTR(Rubrique."Calculation Formula", 6, 3);
        RubriqueSalarie2.RESET;
        RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
        RubriqueSalarie2.SETRANGE("TIT Out of Grid", TRUE);
        IF RubriqueSalarie2.FINDFIRST THEN
            REPEAT
                IF (RubriqueSalarie2."Item Code" < RubriqueMin) OR (RubriqueSalarie2."Item Code" > RubriqueMax) THEN
                    IF RubriqueSalarie2."Item Code" < ParamPaie."Post Salary" THEN BEGIN

                        TITOutGridBasis := TITOutGridBasis + (RubriqueSalarie2.Amount - RubriqueSalarie2.Amount * ParamPaie."Employee SS %" / 100);

                    END

            UNTIL RubriqueSalarie2.NEXT = 0;

        // Fin intervention khaled


        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE("Item Code", ParamPaie."TIT Basis");
        RubriqueSalarie.FINDFIRST;

        // Début intervention khaled
        SalaireImposable := RubriqueSalarie.Amount - TITOutGridBasis;
        //SalaireImposable:=RubriqueSalarie.Amount ;
        // Fin intervention khaled
        SalaireImposableSansConge := SalaireImposable;
        RubriqueSalarie.SETRANGE("Item Code", '222');
        IndemniteConge := 0;
        IF RubriqueSalarie.FINDFIRST THEN BEGIN
            IndemniteConge := RubriqueSalarie.Amount;
            SalaireImposable := SalaireImposable - RubriqueSalarie.Amount * (100 - ParamPaie."Employee SS %") / 100;
            SalaireImposableSansConge := SalaireImposableSansConge
            - IndemniteConge * (100 - ParamPaie."Employee SS %") / 100;
        END;
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETFILTER("Employee No.", NumeroSalarie);
        RubriqueSalarie.SETFILTER("Item Code", '%1..%2', ParamPaie."Post Salary", ParamPaie."Taxable Salary");
        RubriqueSalarie.SETRANGE(Regularization, TRUE);
        IF RubriqueSalarie.FINDSET THEN
            REPEAT
                SalaireImposableSansConge := SalaireImposableSansConge - ROUND(RubriqueSalarie.Amount);
            UNTIL RubriqueSalarie.NEXT = 0;
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETFILTER("Employee No.", NumeroSalarie);
        RubriqueSalarie.SETFILTER("Item Code", '%1..%2', ParamPaie."Base Salary", ParamPaie."Post Salary");
        //bASE SALARY WITHOUT INDEMNITY SOU
        RubriqueSalarie.SETRANGE(Regularization, TRUE);
        IF RubriqueSalarie.FINDSET THEN
            REPEAT
                SalaireImposableSansConge := SalaireImposableSansConge -
                ROUND(RubriqueSalarie.Amount) * ((100 - ParamPaie."Employee SS %") / 100);
            //MESSAGE('%1',RubriqueSalarie.Amount);
            UNTIL RubriqueSalarie.NEXT = 0;
        IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN BEGIN
            IF Salarie.Regime = Salarie.Regime::"Vacataire horaire" THEN
                Coefficient := NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours"
            ELSE
                Coefficient := NbreJoursPresence(NumeroSalarie) / ParamPaie."No. of Worked Days";
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                Coefficient := NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours";
            // modifié par khaled
            //Original :
            IF (Coefficient = 0) AND (SalaireImposable = 0) THEN
              // fin modifié par khaled
              //Original :
              // IF Coefficient=0 THEN
              BEGIN
                IF (TotalMontant <> 0) OR ((TotalMontant = 0) AND (NOT ParamPaie."Do Not Generate Blank TIT")) THEN BEGIN
                    RubriqueSalarie2.INIT;
                    Rubrique.GET(ParamPaie."TIT Deduction");
                    RubriqueSalarie2.INIT;
                    RubriqueSalarie2."Employee No." := NumeroSalarie;
                    RubriqueSalarie2."Item Code" := Rubrique.Code;
                    RubriqueSalarie2."Item Description" := Rubrique.Description;
                    RubriqueSalarie2.Amount := 0;
                    RubriqueSalarie2.Type := Rubrique."Item Type";
                    RubriqueSalarie2.Basis := 0;
                    RubriqueSalarie2.Taxable := Rubrique.Taxable;
                    RubriqueSalarie2.Regularization := Rubrique.Regularization;
                    RubriqueSalarie2.INSERT;
                END;
                //Prise en charge de l'IRG congé
                RubriqueSalarie.RESET;
                RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
                RubriqueSalarie.SETRANGE("Item Code", '222');
                IF RubriqueSalarie.FINDFIRST THEN BEGIN
                    SalaireImposable := RubriqueSalarie.Amount * (100 - ParamPaie."Employee SS %") / 100;
                    RubriqueSalarie2.GET(NumeroSalarie, ParamPaie."Base Salary Without Indemnity");
                    IF RubriqueSalarie2.Amount = 0 THEN BEGIN
                        RubriqueSalarie2.GET(NumeroSalarie, ParamPaie."Taxable Salary");
                        SalaireImposable := RubriqueSalarie2.Amount;
                    END;
                    BaseIRG := SalaireImposable / RubriqueSalarie.Number * UniteSociete."Nbre de jours de congé par an";
                    BaseIRG := BaseIRG DIV 10 * 10;
                    Rubrique.GET(ParamPaie."TIT Deduction");
                    BaremeIRG.RESET;
                    BaremeIRG.SETRANGE(BaremeIRG.Basis, BaseIRG);
                    TotalMontant := 0;
                    IF BaremeIRG.FINDFIRST THEN
                        //samir
                        IF Paie."Starting Date" >= DWY2DATE(1, 6, 2020)
                    THEN
                            IF NOT Salarie."Grand Sud"
                              THEN
                                IF Salarie."Regime IRG" = Salarie."Regime IRG"::" "
                                THEN
                                    TotalMontant := BaremeIRG.TIT20 * (RubriqueSalarie.Number / UniteSociete."Nbre de jours de congé par an")
                                ELSE
                                    TotalMontant := BaremeIRG.TITR * (RubriqueSalarie.Number / UniteSociete."Nbre de jours de congé par an")
                            ELSE
                                TotalMontant := BaremeIRG.TITGS * (RubriqueSalarie.Number / UniteSociete."Nbre de jours de congé par an")
                        ELSE
                            TotalMontant := BaremeIRG.TIT * (RubriqueSalarie.Number / UniteSociete."Nbre de jours de congé par an");
                    //SAMIR
                    IF ParamPaie."TIT merged" THEN BEGIN
                        RubriqueSalarie2.Amount := ROUND(RubriqueSalarie2.Amount - TotalMontant, 0.1);
                        RubriqueSalarie2.MODIFY;
                    END
                    ELSE BEGIN
                        Rubrique.GET(ParamPaie."Leave TIT");
                        IF (TotalMontant <> 0) OR ((TotalMontant = 0) AND (NOT ParamPaie."Do Not Generate Blank TIT")) THEN BEGIN
                            RubriqueSalarie2.INIT;
                            RubriqueSalarie2."Employee No." := NumeroSalarie;
                            RubriqueSalarie2."Item Code" := Rubrique.Code;
                            RubriqueSalarie2."Item Description" := Rubrique.Description;
                            RubriqueSalarie2.Type := Rubrique."Item Type";
                            RubriqueSalarie2.Basis := SalaireImposable;
                            RubriqueSalarie2.Amount := ROUND(-1 * TotalMontant, 0.1);
                            RubriqueSalarie2.Taxable := Rubrique.Taxable;
                            RubriqueSalarie2.Regularization := Rubrique.Regularization;
                            RubriqueSalarie2.INSERT;
                        END;
                    END;
                END;
                EXIT;
            END;
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN BEGIN
                // modifié par khaled
                IF (Coefficient = 0) AND (SalaireImposable > 0) THEN
                    BaseIRG := SalaireImposable
                ELSE
                    BaseIRG := SalaireImposableSansConge * ParamPaie."No. of Worked Days" / NbreJoursPresence(NumeroSalarie);
            END;
            // fin modifié par khaled
            //Original :
            //BaseIRG:=SalaireImposableSansConge*ParamPaie."No. of Worked Days"/NbreJoursPresence(NumeroSalarie);
            IF (ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index") THEN
                BaseIRG := SalaireImposableSansConge / (NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours");
            IF Salarie.Regime = Salarie.Regime::"Vacataire horaire" THEN BEGIN
                RubriqueSalarie2.RESET;
                RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
                RubriqueSalarie2.SETRANGE("Item Code", ParamPaie."No. of Hours (Hourly Vacatary)");
                RubriqueSalarie2.FINDFIRST;
                NbreHeuresVacataire := NbreHeuresPresence(NumeroSalarie);
                BaseIRG := SalaireImposableSansConge / NbreHeuresVacataire * ParamPaie."No. of Worked Hours";
            END;
            IF Salarie.Regime = Salarie.Regime::"Vacataire journalier" THEN BEGIN
                RubriqueSalarie2.RESET;
                RubriqueSalarie2.SETRANGE("Employee No.", NumeroSalarie);
                RubriqueSalarie2.SETRANGE("Item Code", ParamPaie."No. of Days (Daily Vacatary)");
                RubriqueSalarie2.FINDFIRST;
                NbreJoursVacataire := NbreJoursPresence(NumeroSalarie);
                BaseIRG := SalaireImposable / NbreJoursVacataire * ParamPaie."No. of Worked Days";
            END;
            //MESSAGE('%1',BaseIRG);
            BaseIRG := BaseIRG DIV 10 * 10;
            //MESSAGE('%1',BaseIRG);
            //MESSAGE('%1',BaseIRG);
            Rubrique.GET(ParamPaie."TIT Deduction");
            RubriqueSalarie2.INIT;
            RubriqueSalarie2."Employee No." := NumeroSalarie;
            RubriqueSalarie2."Item Code" := Rubrique.Code;
            RubriqueSalarie2."Item Description" := Rubrique.Description;
            BaremeIRG.RESET;
            BaremeIRG.SETRANGE(BaremeIRG.Basis, BaseIRG);
            TotalMontant := 0;
            IF BaremeIRG.FINDFIRST THEN BEGIN
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN BEGIN
                    //TestCours
                    TauxLocal := ROUND(NbreJoursPresence(NumeroSalarie) / ParamPaie."No. of Worked Days", 0.0001);
                    // Ajouté par khaled
                    IF (Coefficient = 0) AND (SalaireImposable > 0) THEN
                        TauxLocal := 1;
                    // Fin AJouté par khaled
                    //samir
                    IF Paie."Starting Date" >= DWY2DATE(1, 6, 2020)
                      THEN
                        IF NOT Salarie."Grand Sud"
                          THEN
                            IF Salarie."Regime IRG" = Salarie."Regime IRG"::" "
                            THEN
                                BaremeLocal := BaremeIRG.TIT20
                            ELSE
                                BaremeLocal := BaremeIRG.TITR
                        ELSE
                            BaremeLocal := BaremeIRG.TITGS
                    ELSE
                        BaremeLocal := BaremeIRG.TIT;
                    //samir
                    TotalMontant := ROUND(BaremeLocal * TauxLocal, 0.0001);
                END;
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                    //samir
                    IF Paie."Starting Date" >= DWY2DATE(1, 6, 2020)
               THEN
                        IF NOT Salarie."Grand Sud"
                          THEN
                            IF Salarie."Regime IRG" = Salarie."Regime IRG"::" "
                              THEN
                                TotalMontant := BaremeIRG.TIT20 * (NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours")
                            ELSE
                                TotalMontant := BaremeIRG.TITR * (NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours")
                        ELSE
                            TotalMontant := BaremeIRG.TITGS * (NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours")
                    ELSE
                        TotalMontant := BaremeIRG.TIT * (NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours");
                //samir

                IF Salarie.Regime = Salarie.Regime::"Vacataire horaire" THEN
                    //samir
                    IF Paie."Starting Date" >= DWY2DATE(1, 6, 2020)
                THEN
                        IF NOT Salarie."Grand Sud"
                          THEN
                            IF Salarie."Regime IRG" = Salarie."Regime IRG"::" "
                              THEN
                                TotalMontant := BaremeIRG.TIT20 * (NbreHeuresVacataire / ParamPaie."No. of Worked Hours")
                            ELSE
                                TotalMontant := BaremeIRG.TITR * (NbreHeuresVacataire / ParamPaie."No. of Worked Hours")
                        ELSE
                            TotalMontant := BaremeIRG.TITGS * (NbreHeuresVacataire / ParamPaie."No. of Worked Hours")
                    ELSE
                        TotalMontant := BaremeIRG.TIT * (NbreHeuresVacataire / ParamPaie."No. of Worked Hours");
                //samir
                IF Salarie.Regime = Salarie.Regime::"Vacataire journalier" THEN
                    //samir
                    IF Paie."Starting Date" >= DWY2DATE(1, 6, 2020)
               THEN
                        IF NOT Salarie."Grand Sud"
                          THEN
                            IF Salarie."Regime IRG" = Salarie."Regime IRG"::" "
                              THEN
                                TotalMontant := BaremeIRG.TIT20 * (NbreJoursVacataire / ParamPaie."No. of Worked Days")
                            ELSE
                                TotalMontant := BaremeIRG.TITR * (NbreJoursVacataire / ParamPaie."No. of Worked Days")
                        ELSE
                            TotalMontant := BaremeIRG.TITGS * (NbreJoursVacataire / ParamPaie."No. of Worked Days")
                    ELSE
                        TotalMontant := BaremeIRG.TIT * (NbreJoursVacataire / ParamPaie."No. of Worked Days");
                //samir
            END
            ELSE
                TotalMontant := 0;
            IF (TotalMontant <> 0) OR ((TotalMontant = 0) AND (NOT ParamPaie."Do Not Generate Blank TIT")) THEN BEGIN
                Rubrique.GET(ParamPaie."TIT Deduction");
                RubriqueSalarie2.INIT;
                RubriqueSalarie2."Employee No." := NumeroSalarie;
                RubriqueSalarie2."Item Code" := Rubrique.Code;
                RubriqueSalarie2."Item Description" := Rubrique.Description;
                //Test
                RubriqueSalarie2.Amount := ROUND(-TotalMontant, 0.1);
                RubriqueSalarie2.Type := Rubrique."Item Type";
                RubriqueSalarie2.Basis := SalaireImposableSansConge;
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                    RubriqueSalarie2.Rate := (NbreJoursPresence(NumeroSalarie) / ParamPaie."No. of Worked Days");
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                    RubriqueSalarie2.Rate := (NbreHeuresPresence(NumeroSalarie) / ParamPaie."No. of Worked Hours");
                IF Salarie.Regime = Salarie.Regime::"Vacataire horaire" THEN
                    RubriqueSalarie2.Rate := (NbreHeuresVacataire / ParamPaie."No. of Worked Hours");
                IF Salarie.Regime = Salarie.Regime::"Vacataire journalier" THEN
                    RubriqueSalarie2.Rate := (NbreJoursVacataire / ParamPaie."No. of Worked Days");
                RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
                RubriqueSalarie2.Taxable := Rubrique.Taxable;
                RubriqueSalarie2.Regularization := Rubrique.Regularization;
                RubriqueSalarie2.INSERT;
            END;
            //Prise en charge de l'IRG congé
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETRANGE("Item Code", '222');
            IF RubriqueSalarie.FINDFIRST THEN BEGIN
                SalaireImposable := RubriqueSalarie.Amount * (100 - ParamPaie."Employee SS %") / 100;
                RubriqueSalarie2.GET(NumeroSalarie, ParamPaie."Base Salary Without Indemnity");
                IF RubriqueSalarie2.Amount = 0 THEN BEGIN
                    RubriqueSalarie2.GET(NumeroSalarie, ParamPaie."Taxable Salary");
                END;
                BaseIRG := SalaireImposable / RubriqueSalarie.Number * UniteSociete."Nbre de jours de congé par an";
                BaseIRG := BaseIRG DIV 10 * 10;
                Rubrique.GET(ParamPaie."TIT Deduction");
                BaremeIRG.RESET;
                BaremeIRG.SETRANGE(BaremeIRG.Basis, BaseIRG);
                TotalMontant := 0;
                IF BaremeIRG.FINDFIRST THEN
                    //samir
                    IF Paie."Starting Date" >= DWY2DATE(1, 6, 2020)
                    THEN
                        IF NOT Salarie."Grand Sud"
                          THEN
                            IF Salarie."Regime IRG" = Salarie."Regime IRG"::" "
                            THEN
                                TotalMontant := BaremeIRG.TIT20 * (RubriqueSalarie.Number / UniteSociete."Nbre de jours de congé par an")
                            ELSE
                                TotalMontant := BaremeIRG.TITR * (RubriqueSalarie.Number / UniteSociete."Nbre de jours de congé par an")
                        ELSE
                            TotalMontant := BaremeIRG.TITGS * (RubriqueSalarie.Number / UniteSociete."Nbre de jours de congé par an")
                    ELSE
                        TotalMontant := BaremeIRG.TIT * (RubriqueSalarie.Number / UniteSociete."Nbre de jours de congé par an");
                //SAMIR
                IF ParamPaie."TIT merged" THEN BEGIN
                    RubriqueSalarie2.Amount := RubriqueSalarie2.Amount - 1 * TotalMontant;
                    RubriqueSalarie2.MODIFY;
                END
                ELSE BEGIN
                    IF (TotalMontant <> 0) OR ((TotalMontant = 0) AND (NOT ParamPaie."Do Not Generate Blank TIT")) THEN BEGIN
                        Rubrique.GET(ParamPaie."Leave TIT");
                        RubriqueSalarie2.INIT;
                        RubriqueSalarie2."Employee No." := NumeroSalarie;
                        RubriqueSalarie2."Item Code" := Rubrique.Code;
                        RubriqueSalarie2."Item Description" := Rubrique.Description;
                        RubriqueSalarie2.Type := Rubrique."Item Type";
                        RubriqueSalarie2.Basis := SalaireImposable;
                        //Element 33 Début
                        RubriqueSalarie2.Amount := ROUND(-1 * TotalMontant, 0.1);
                        //Element 33 Fin
                        RubriqueSalarie2.Taxable := Rubrique.Taxable;
                        RubriqueSalarie2.Regularization := Rubrique.Regularization;
                        RubriqueSalarie2.INSERT;
                    END;
                END;
            END;
            //IRG Congé
            IF RubriqueSalarie2.GET(NumeroSalarie, ParamPaie."TIT Deduction") THEN;
            IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Leave TIT") THEN
                IF (RubriqueSalarie.Amount <> RubriqueSalarie2.Amount) AND (RubriqueSalarie2.Amount = 0) THEN BEGIN
                    RubriqueSalarie.Basis := RubriqueSalarie.Basis + RubriqueSalarie2.Basis;
                    BaseIRG := RubriqueSalarie.Basis DIV 10 * 10;
                    BaremeIRG.RESET;
                    BaremeIRG.SETRANGE(BaremeIRG.Basis, BaseIRG);
                    TotalMontant := 0;
                    IF BaremeIRG.FINDFIRST THEN
                        //samir
                        IF Paie."Starting Date" >= DWY2DATE(1, 6, 2020)
                  THEN
                            IF NOT Salarie."Grand Sud"
                              THEN
                                IF Salarie."Regime IRG" = Salarie."Regime IRG"::" "
                                  THEN
                                    RubriqueSalarie.Amount := -1 * BaremeIRG.TIT20
                                ELSE
                                    RubriqueSalarie.Amount := -1 * BaremeIRG.TITR
                            ELSE
                                RubriqueSalarie.Amount := -1 * BaremeIRG.TITGS
                        ELSE
                            RubriqueSalarie.Amount := -1 * BaremeIRG.TIT;
                    //samir
                    RubriqueSalarie.MODIFY;
                END;
            IF RubriqueSalarie2.Rate < 0 THEN BEGIN
                RubriqueSalarie2.Rate := 0;
                RubriqueSalarie2.Basis := 0;
                RubriqueSalarie2.MODIFY;
            END;
        END;
    end;

    /// <summary>
    /// CalcIRGTaux.
    /// </summary>
    procedure CalcIRGTaux();
    begin
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE("Item Code", ParamPaie."TIT Basis");
        RubriqueSalarie.FINDFIRST;
        SalaireImposable := RubriqueSalarie.Amount;
        TotalMontant := SalaireImposable * TypePaie."IRG %" / 100;
        Rubrique.GET(ParamPaie."TIT Out of Grid");
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := Rubrique.Code;
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        RubriqueSalarie2.Amount := -ROUND(TotalMontant, 0.1);
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2.Basis := SalaireImposable;
        RubriqueSalarie2.Rate := TypePaie."IRG %";
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;
    end;

    /// <summary>
    /// NbreHeuresPresence.
    /// </summary>
    /// <param name="EmployeeNumber">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure NbreHeuresPresence(EmployeeNumber: Code[20]): Decimal;
    var
        L_Valeur: Decimal;
        L_RubriqueSalarie: Record "Employee Payroll Item";
    begin
        ParamPaie.GET;
        Salarie.CALCFIELDS("Total Absences Days");
        Salarie.CALCFIELDS("Total Absences Hours");
        NbreHeuresAbsence := Salarie."Total Absences Days" * ParamPaie."No. of Hours By Day" + Salarie."Total Absences Hours";
        IF Salarie.Regime = Salarie.Regime::"Vacataire horaire" THEN BEGIN
            L_RubriqueSalarie.GET(Salarie."No.", ParamPaie."No. of Hours (Hourly Vacatary)");
            L_Valeur := L_RubriqueSalarie.Number;
        END
        ELSE
            L_Valeur := ParamPaie."No. of Worked Hours";
        EXIT((L_Valeur - NbreHeuresAbsence));
    end;

    /// <summary>
    /// NbreJoursPresence.
    /// </summary>
    /// <param name="EmployeeNumber">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure NbreJoursPresence(EmployeeNumber: Code[20]): Decimal;
    var
        NbreJoursAbsence: Decimal;
        L_Valeur: Decimal;
        L_RubriqueSalarie: Record "Employee Payroll Item";
        NbreJoursPresence: Decimal;
    begin
        ParamPaie.GET;
        RubriqueSalarie.RESET;
        //Test Karim
        Salarie.SETFILTER("Date Filter", '%1..%2', DebutPeriodePaie, FinPeriodePaie);
        //Test Karim
        Salarie.CALCFIELDS("Total Absences Days");
        Salarie.CALCFIELDS("Total Absences Hours");
        NbreJoursAbsence := ROUND(Salarie."Total Absences Days" + Salarie."Total Absences Hours" / ParamPaie."No. of Hours By Day", 0.01);
        //NbreJoursAbsence:=0;//Test Karim
        IF Salarie.Regime = Salarie.Regime::"Vacataire journalier" THEN BEGIN
            L_RubriqueSalarie.GET(Salarie."No.", ParamPaie."No. of Days (Daily Vacatary)");
            L_Valeur := L_RubriqueSalarie.Number;
        END
        ELSE
            L_Valeur := ParamPaie."No. of Worked Days";
        EXIT((L_Valeur - NbreJoursAbsence));
    end;

    /// <summary>
    /// CalcMutuelleFixe.
    /// </summary>
    procedure CalcMutuelleFixe();
    begin
        IF Salarie."Union Code" = '' THEN
            EXIT;
        EmployeeUnionSubscription.RESET;
        EmployeeUnionSubscription.SETRANGE(EmployeeUnionSubscription."Employee No.", NumeroSalarie);
        EmployeeUnionSubscription.SETRANGE(EmployeeUnionSubscription."Union/Insurance Code", Salarie."Union Code");
        IF NOT EmployeeUnionSubscription.FINDLAST THEN
            EXIT;
        IF (EmployeeUnionSubscription."Ending Date" < DebutPeriodePaie)
        OR (EmployeeUnionSubscription."Starting Date" > FinPeriodePaie) THEN
            EXIT;
        Rubrique.GET(ParamPaie."Union Subscription Deduction");
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := Rubrique.Code;
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        RubriqueSalarie2.Amount := -EmployeeUnionSubscription."Subscription Amount";
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2.Basis := EmployeeUnionSubscription."Subscription Amount";
        RubriqueSalarie2.Number := 1;
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;
    end;

    /// <summary>
    /// CalcMutuelleTaux.
    /// </summary>
    procedure CalcMutuelleTaux();
    begin
        Rubrique.GET(ParamPaie."Union Subscription Deduction");
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETFILTER("Employee No.", NumeroSalarie);
        RubriqueSalarie.SETFILTER("Item Code", ParamPaie."Post Salary");
        IF RubriqueSalarie.FINDFIRST THEN
            TotalMontant := ROUND(RubriqueSalarie.Amount);
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := Rubrique.Code;
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        RubriqueSalarie2.Amount := ROUND(-1 * TotalMontant * ParamPaie."Union Rate" / 100);
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2.Basis := TotalMontant;
        RubriqueSalarie2.Rate := ParamPaie."Union Rate";
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;
    end;

    /// <summary>
    /// SupprimerPaie.
    /// </summary>
    /// <param name="CodePaie">Code[20].</param>
    procedure SupprimerPaie(CodePaie: Code[20]);
    begin
        Paie.GET(CodePaie);
        HistTransactPaie.RESET;
        HistTransactPaie.SETRANGE("Payroll Code", CodePaie);
        HistTransactPaie.FINDFIRST;
        IF Paie.Closed THEN
            ERROR(Text04, 'la paie', CodePaie);
        IF CONFIRM(Text01, FALSE, 'la paie', CodePaie, FALSE) THEN BEGIN
            //Suppression des lignes d'archive
            PayrollLineArchive.RESET;
            PayrollLineArchive.SETRANGE("Payroll Code", CodePaie);
            PayrollLineArchive.DELETEALL;
            //Suppression des entêtes d'archive
            PayrollHeaderArchive.RESET;
            PayrollHeaderArchive.SETRANGE("Payroll Code", CodePaie);
            PayrollHeaderArchive.DELETEALL;
            EcriturePaie.RESET;
            EcriturePaie.SETFILTER("Entry No.", '%1..%2', HistTransactPaie."From Entry No.", HistTransactPaie."To Entry No.");
            EcriturePaie.DELETEALL;
            //Suppression des écritures analytiques
            /* AnalEcriture.RESET;
             AnalEcriture.SETRANGE("Table ID",39108622);
             AnalEcriture.SETFILTER("Entry No.",'%1..%2',HistTransactPaie."From Entry No.",HistTransactPaie."To Entry No.");
             AnalEcriture.DELETEALL;*/
            HistTransactPaie.DELETE;
            //Actualisation des prêts
            Pret.RESET;
            IF Pret.FINDFIRST THEN
                REPEAT
                    EcriturePaie.RESET;
                    EcriturePaie.SETRANGE("Employee No.", Pret."Employee No.");
                    EcriturePaie.SETRANGE("Item Code", Pret."Lending Deduction (Capital)");
                    EcriturePaie.SETFILTER("Document Date", '%1..%2', Pret."Grant Date", Pret."End Date");
                    Montant := 0;
                    IF EcriturePaie.FINDFIRST THEN
                        REPEAT
                            Montant := Montant - EcriturePaie.Amount;
                        UNTIL EcriturePaie.NEXT = 0;
                    Pret."Total Refund" := Montant;
                    Pret."No. of Monthly Payments" := EcriturePaie.COUNT;
                    Pret.MODIFY;
                UNTIL Pret.NEXT = 0;
        END;

    end;

    /// <summary>
    /// TestEmployeeUse.
    /// </summary>
    /// <param name="EmployeeNum">Code[20].</param>
    procedure TestEmployeeUse(EmployeeNum: Code[20]);
    begin
        EcriturePaie.RESET;
        EcriturePaie.SETRANGE(EcriturePaie."Employee No.", EmployeeNum);
        IF EcriturePaie.FINDSET THEN
            ERROR(Text05, EmployeeNum, EcriturePaie.TABLECAPTION);

        EmployeeQualification.RESET;
        EmployeeQualification.SETRANGE(EmployeeQualification."Employee No.", EmployeeNum);
        IF EmployeeQualification.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeQualification.TABLECAPTION);

        EmployeeRelative.RESET;
        EmployeeRelative.SETRANGE(EmployeeRelative."Employee No.", EmployeeNum);
        IF EmployeeRelative.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeRelative.TABLECAPTION);

        AbsenceSalarie.RESET;
        AbsenceSalarie.SETRANGE(AbsenceSalarie."Employee No.", EmployeeNum);
        IF AbsenceSalarie.FINDSET THEN
            ERROR(Text05, EmployeeNum, AbsenceSalarie.TABLECAPTION);

        EmployeeDiploma.RESET;
        EmployeeDiploma.SETRANGE(EmployeeDiploma."Employee No.", EmployeeNum);
        IF EmployeeDiploma.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeDiploma.TABLECAPTION);

        EmployeeAssignment.RESET;
        EmployeeAssignment.SETRANGE(EmployeeAssignment."Employee No.", EmployeeNum);
        IF EmployeeAssignment.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeAssignment.TABLECAPTION);

        EmployeeFulfilledFunction.RESET;
        EmployeeFulfilledFunction.SETRANGE(EmployeeFulfilledFunction."Employee No.", EmployeeNum);
        IF EmployeeFulfilledFunction.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeFulfilledFunction.TABLECAPTION);

        EmployeeMisconduct.RESET;
        EmployeeMisconduct.SETRANGE(EmployeeMisconduct."Employee No.", EmployeeNum);
        IF EmployeeMisconduct.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeMisconduct.TABLECAPTION);

        EmployeeUnavailability.RESET;
        EmployeeUnavailability.SETRANGE(EmployeeUnavailability."Employee No.", EmployeeNum);
        IF EmployeeUnavailability.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeUnavailability.TABLECAPTION);

        EmployeeContract.RESET;
        EmployeeContract.SETRANGE(EmployeeContract."Employee No.", EmployeeNum);
        IF EmployeeContract.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeContract.TABLECAPTION);

        EmployeeRecovery.RESET;
        EmployeeRecovery.SETRANGE(EmployeeRecovery."Employee No.", EmployeeNum);
        IF EmployeeRecovery.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeRecovery.TABLECAPTION);

        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", EmployeeNum);
        IF RubriqueSalarie.FINDSET THEN
            ERROR(Text05, EmployeeNum, RubriqueSalarie.TABLECAPTION);

        EmployeeAdvance.RESET;
        EmployeeAdvance.SETRANGE(EmployeeAdvance."Employee No.", EmployeeNum);
        IF EmployeeAdvance.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeAdvance.TABLECAPTION);

        EmployeeUnionSubscription.RESET;
        EmployeeUnionSubscription.SETRANGE(EmployeeUnionSubscription."Employee No.", EmployeeNum);
        IF EmployeeUnionSubscription.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeUnionSubscription.TABLECAPTION);

        EmployeeOvertime.RESET;
        EmployeeOvertime.SETRANGE(EmployeeOvertime."Employee No.", EmployeeNum);
        IF EmployeeOvertime.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeOvertime.TABLECAPTION);

        EmployeeLeave.RESET;
        EmployeeLeave.SETRANGE(EmployeeLeave."Employee No.", EmployeeNum);
        IF EmployeeLeave.FINDSET THEN
            ERROR(Text05, EmployeeNum, EmployeeLeave.TABLECAPTION);
    end;

    /// <summary>
    /// CalcDroitConge.
    /// </summary>
    /// <param name="P_NumSalarie">Code[20].</param>
    /// <param name="P_CongeNbre">VAR Decimal.</param>
    /// <param name="P_CongeMontant">VAR Decimal.</param>
    procedure CalcDroitConge(P_NumSalarie: Code[20]; var P_CongeNbre: Decimal; var P_CongeMontant: Decimal);
    begin
        //Element 01 Début
        Salarie.GET(P_NumSalarie);
        P_CongeNbre := UniteSociete."Nbre de jours de congé par an";
        //Element 26 Début
        IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN BEGIN
            Nbre := NbreJoursPresence(NumeroSalarie);
            IF (Salarie."Employment Date" >= DebutPeriodePaie) AND (Salarie."Employment Date" <= FinPeriodePaie)
            AND (Nbre < ParamPaie."No. of Worked Days" / 2) THEN
                P_CongeNbre := 0;
        END;
        IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN BEGIN
            Nbre := NbreHeuresPresence(NumeroSalarie);
            IF (Salarie."Employment Date" >= DebutPeriodePaie) AND (Salarie."Employment Date" <= FinPeriodePaie)
            AND (Nbre < ParamPaie."No. of Worked Hours" / 2) THEN
                P_CongeNbre := 0;
        END;
        //Element 26 Fin
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE("Employee No.", P_NumSalarie);
        RubriqueSalarie.SETRANGE("Submitted To Leave", TRUE);
        P_CongeMontant := 0;
        IF RubriqueSalarie.FINDFIRST THEN
            REPEAT
                P_CongeMontant := P_CongeMontant + RubriqueSalarie.Amount;
            UNTIL RubriqueSalarie.NEXT = 0;
        P_CongeMontant := ROUND(P_CongeMontant / 12);
        //Element 01 Fin
    end;

    /// <summary>
    /// CalcRetenuePret.
    /// </summary>
    procedure CalcRetenuePret();
    begin
        //Un seul prêt par type : si 2ème, modifier le 1er
        TypePret.RESET;
        IF TypePret.FINDSET THEN
            REPEAT
                IF RubriqueSalarie.GET(NumeroSalarie, TypePret."Lending Deduction (Capital)") THEN
                    RubriqueSalarie.DELETE;
            UNTIL TypePret.NEXT = 0;
        Pret.RESET;
        Pret.SETRANGE("Employee No.", NumeroSalarie);
        Pret.SETRANGE("Deduct From Payroll", TRUE);
        Pret.SETRANGE(Pret.Status, Pret.Status::"En cours");
        IF NOT Pret.FINDFIRST THEN
            EXIT;
        REPEAT
            IF Pret."Lending Type" = '' THEN
                ERROR(Text12, Pret."No.")
            ELSE
                IF Pret."Previous Refund" + Pret."Total Refund" > Pret."Lending Amount" THEN
                    ERROR(Text13, Pret."No.");
            IF Pret."Previous Refund" + Pret."Total Refund" < Pret."Lending Amount" THEN BEGIN
                TypePret.GET(Pret."Lending Type");
                TypePret.TESTFIELD("Lending Deduction (Capital)");
                IF NOT RubriqueSalarie.GET(NumeroSalarie, TypePret."Lending Deduction (Capital)") THEN BEGIN
                    RubriqueSalarie2.INIT;
                    RubriqueSalarie2."Employee No." := NumeroSalarie;
                    RubriqueSalarie2."Item Code" := TypePret."Lending Deduction (Capital)";
                    Rubrique.GET(TypePret."Lending Deduction (Capital)");
                    RubriqueSalarie2."Item Description" := Rubrique.Description;
                    RubriqueSalarie2.Number := 1;
                    RubriqueSalarie2.Basis := -Pret."Monthly Amount";
                    RubriqueSalarie2.Amount := -Pret."Monthly Amount";
                    RubriqueSalarie2.Type := Rubrique."Item Type";
                    RubriqueSalarie2.Taxable := Rubrique.Taxable;
                    RubriqueSalarie2.Regularization := Rubrique.Regularization;
                    RubriqueSalarie2.INSERT;
                END;
            END;
        UNTIL Pret.NEXT = 0;
    end;

    /// <summary>
    /// CalcSalaireBrut.
    /// </summary>
    procedure CalcSalaireBrut();
    begin
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE(Type, RubriqueSalarie.Type::"Libre saisie");
        IF RubriqueSalarie.FINDFIRST THEN
            REPEAT
                Rubrique.GET(RubriqueSalarie."Item Code");
                RubriqueSalarie.Taxable := Rubrique.Taxable;
                RubriqueSalarie.MODIFY;
            UNTIL RubriqueSalarie.NEXT = 0;
        IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Taxable Salary") THEN BEGIN
            IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Post Salary") THEN
                SalaireBrut := RubriqueSalarie.Amount;
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETRANGE(Taxable, TRUE);
            IF RubriqueSalarie.FINDFIRST THEN
                REPEAT
                    SalaireBrut := SalaireBrut + RubriqueSalarie.Amount;
                UNTIL RubriqueSalarie.NEXT = 0;
        END
        ELSE //Paie complément gérée manuellement
          BEGIN
            IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Net Salary") THEN
                SalaireBrut := RubriqueSalarie.Amount;
            RubriqueSalarie.RESET;
            RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
            RubriqueSalarie.SETFILTER("Item Code", ParamPaie."TIT Filter");
            IF RubriqueSalarie.FINDFIRST THEN
                REPEAT
                    SalaireBrut := SalaireBrut - RubriqueSalarie.Amount;
                UNTIL RubriqueSalarie.NEXT = 0;
            IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Employee SS Deduction") THEN
                SalaireBrut := SalaireBrut - RubriqueSalarie.Amount;
        END;
        IF Salarie."Payroll Type Code" <> '' THEN
            IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie."DAIP Taxable Salary") THEN BEGIN
                IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie."Post Salary") THEN
                    SalaireBrut := RubriqueSalarie.Amount
                ELSE
                    SalaireBrut := 0;
                RubriqueSalarie.RESET;
                RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
                RubriqueSalarie.SETRANGE(Taxable, TRUE);
                IF RubriqueSalarie.FINDFIRST THEN
                    REPEAT
                        SalaireBrut := SalaireBrut + RubriqueSalarie.Amount;
                    UNTIL RubriqueSalarie.NEXT = 0;
            END;
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := ParamPaie."Brut Salary";
        Rubrique.GET(ParamPaie."Brut Salary");
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        RubriqueSalarie2.Number := 1;
        RubriqueSalarie2.Basis := SalaireBrut;
        RubriqueSalarie2.Amount := SalaireBrut;
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;
    end;

    /// <summary>
    /// CalcSalaireBaseJournalier.
    /// </summary>
    /// <param name="EmployeeNumber">Code[20].</param>
    procedure CalcSalaireBaseJournalier(EmployeeNumber: Code[20]);
    begin
        Salarie.GET(EmployeeNumber);
        Rubrique.GET(ParamPaie."No. of Days (Daily Vacatary)");
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETFILTER("Employee No.", EmployeeNumber);
        RubriqueSalarie.SETFILTER("Item Code", ParamPaie."No. of Days (Daily Vacatary)");
        IF NOT RubriqueSalarie.FINDFIRST THEN BEGIN
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                CalcAmountFromSectionGrid;
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                CalcAmountFromHourlyIndexGrid;
            RubriqueSalarie2.INIT;
            RubriqueSalarie2."Employee No." := EmployeeNumber;
            RubriqueSalarie2."Item Code" := ParamPaie."No. of Days (Daily Vacatary)";
            Rubrique.GET(ParamPaie."No. of Days (Daily Vacatary)");
            RubriqueSalarie2."Item Description" := Rubrique.Description;
            RubriqueSalarie2.Basis := ROUND(TotalIndices / ParamPaie."No. of Worked Days");
            RubriqueSalarie2.Number := ParamPaie."No. of Worked Days";
            IF ParamPaie."Apply Index Point Value" THEN
                RubriqueSalarie2.Amount := ROUND(TotalIndices * ParamPaie."Index Point Value")
            ELSE
                RubriqueSalarie2.Amount := ROUND(TotalIndices);
            RubriqueSalarie2.Type := Rubrique."Item Type";
            RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
            RubriqueSalarie2.INSERT;
        END;
    end;

    /// <summary>
    /// CalcSalaireBaseHoraire.
    /// </summary>
    /// <param name="EmployeeNumber">Code[20].</param>
    procedure CalcSalaireBaseHoraire(EmployeeNumber: Code[20]);
    begin
        Salarie.GET(EmployeeNumber);
        Rubrique.GET(ParamPaie."No. of Hours (Hourly Vacatary)");
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETFILTER("Employee No.", EmployeeNumber);
        RubriqueSalarie.SETFILTER("Item Code", ParamPaie."No. of Hours (Hourly Vacatary)");
        IF NOT RubriqueSalarie.FINDFIRST THEN BEGIN
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                CalcAmountFromSectionGrid;
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                CalcAmountFromHourlyIndexGrid;
            RubriqueSalarie2.INIT;
            RubriqueSalarie2."Employee No." := EmployeeNumber;
            RubriqueSalarie2."Item Code" := ParamPaie."No. of Hours (Hourly Vacatary)";
            Rubrique.GET(ParamPaie."No. of Hours (Hourly Vacatary)");
            RubriqueSalarie2."Item Description" := Rubrique.Description;
            RubriqueSalarie2.Basis := ROUND(TotalIndices / ParamPaie."No. of Worked Hours");
            RubriqueSalarie2.Number := ParamPaie."No. of Worked Hours";
            IF ParamPaie."Apply Index Point Value" THEN
                RubriqueSalarie2.Amount := ROUND(TotalIndices * ParamPaie."Index Point Value")
            ELSE
                RubriqueSalarie2.Amount := ROUND(TotalIndices);
            RubriqueSalarie2.Type := Rubrique."Item Type";
            RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
            RubriqueSalarie2.INSERT;
        END;
    end;

    /// <summary>
    /// ActualiserRubriquesPourcentage.
    /// </summary>
    procedure ActualiserRubriquesPourcentage();
    begin
        //***REACTUALISATION DES RUBRIQUES POURCENTAGE***
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE("Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE(Type, RubriqueSalarie.Type::Pourcentage);
        IF RubriqueSalarie.FINDSET THEN
            REPEAT
                Rubrique.GET(RubriqueSalarie."Item Code");
                Rubrique.TESTFIELD("Basis of Calculation");
                IF RubriqueSalarie2.GET(NumeroSalarie, Rubrique."Basis of Calculation") THEN BEGIN
                    RubriqueSalarie.Basis := RubriqueSalarie2.Amount;
                    RubriqueSalarie.Amount := ROUND(RubriqueSalarie.Basis * RubriqueSalarie.Rate / 100);
                    RubriqueSalarie.MODIFY;
                END;
            UNTIL RubriqueSalarie.NEXT = 0;
    end;

    /// <summary>
    /// CalcIEP.
    /// </summary>
    procedure CalcIEP();
    begin
        IF RubriqueSalarie.GET(NumeroSalarie, ParamPaie.IEP) THEN BEGIN
            TotalMontant := 0;
            Rubrique.GET(ParamPaie.IEP);
            IF RubriqueSalarie2.GET(NumeroSalarie, Rubrique."Basis of Calculation") THEN
                TotalMontant := ROUND(RubriqueSalarie2.Amount);
            IF Salarie."Current IEP" + Salarie."Previous IEP" < ParamPaie."Maximal IEP" THEN
                RubriqueSalarie.Rate := Salarie."Current IEP" + Salarie."Previous IEP"
            ELSE
                RubriqueSalarie.Rate := ParamPaie."Maximal IEP";
            RubriqueSalarie.Amount := TotalMontant * RubriqueSalarie.Rate / 100;
            RubriqueSalarie.MODIFY;
        END;
    end;

    /// <summary>
    /// CalcEmployeeFraisPanier.
    /// </summary>
    procedure CalcEmployeeFraisPanier();
    begin
        Rubrique.GET(ParamPaie."Prime de Panier");
        IF Rubrique."Item Type" = Rubrique."Item Type"::Formule THEN BEGIN
            Salarie.RESET;
            Salarie.SETRANGE("No.", NumeroSalarie);
            IF Salarie.FINDFIRST THEN BEGIN
                PayrollTemplateLine.RESET;
                PayrollTemplateLine.SETRANGE("Template No.", Salarie."Payroll Template No.");
                PayrollTemplateLine.SETRANGE("Item Code", ParamPaie."Prime de Panier");
                IF PayrollTemplateLine.FINDFIRST THEN BEGIN

                    RubriqueSalarie2.INIT;
                    RubriqueSalarie2."Employee No." := NumeroSalarie;
                    RubriqueSalarie2."Item Code" := Rubrique.Code;
                    RubriqueSalarie2."Item Description" := Rubrique.Description;
                    RubriqueSalarie2.Type := Rubrique."Item Type";
                    // RubriqueSalarie2.Basis:=Rubrique.Tarification;
                    RubriqueSalarie2.Basis := PayrollTemplateLine.Amount;
                    RubriqueSalarie2.Number := NbreJoursPresencePanierTransport(NumeroSalarie);
                    RubriqueSalarie2.Amount := ROUND(PayrollTemplateLine.Amount * RubriqueSalarie2.Number);
                    RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
                    RubriqueSalarie2.Taxable := Rubrique.Taxable;
                    RubriqueSalarie2.Regularization := Rubrique.Regularization;
                    RubriqueSalarie2.INSERT;
                END;
            END;
        END;
    end;

    /// <summary>
    /// CalcEmployeeIndemniteTransport.
    /// </summary>
    procedure CalcEmployeeIndemniteTransport();
    begin
        Rubrique.GET(ParamPaie."Indemnité de transport");
        IF Rubrique."Item Type" = Rubrique."Item Type"::Formule THEN BEGIN
            Salarie.RESET;
            Salarie.SETRANGE("No.", NumeroSalarie);
            IF Salarie.FINDFIRST THEN BEGIN
                PayrollTemplateLine.RESET;
                PayrollTemplateLine.SETRANGE("Template No.", Salarie."Payroll Template No.");
                PayrollTemplateLine.SETRANGE("Item Code", ParamPaie."Indemnité de transport");
                IF PayrollTemplateLine.FINDFIRST THEN BEGIN
                    RubriqueSalarie2.INIT;
                    RubriqueSalarie2."Employee No." := NumeroSalarie;
                    RubriqueSalarie2."Item Code" := Rubrique.Code;
                    RubriqueSalarie2."Item Description" := Rubrique.Description;
                    RubriqueSalarie2.Type := Rubrique."Item Type";
                    //RubriqueSalarie2.Basis:=Rubrique.Tarification;
                    RubriqueSalarie2.Basis := PayrollTemplateLine.Amount;
                    RubriqueSalarie2.Number := NbreJoursPresencePanierTransport(NumeroSalarie);
                    RubriqueSalarie2.Amount := ROUND(PayrollTemplateLine.Amount * RubriqueSalarie2.Number);
                    RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
                    RubriqueSalarie2.Taxable := Rubrique.Taxable;
                    RubriqueSalarie2.Regularization := Rubrique.Regularization;
                    RubriqueSalarie2.INSERT;
                END;
            END;
        END;
    end;

    /// <summary>
    /// NbreJoursPresencePanierTransportEncien.
    /// </summary>
    /// <param name="EmployeeNumber">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure NbreJoursPresencePanierTransportEncien(EmployeeNumber: Code[20]): Decimal;
    var
        NbreJoursAbsence: Decimal;
        L_Valeur: Decimal;
        L_RubriqueSalarie: Record "Employee Payroll Item";
        NbreJoursPresence: Decimal;
        EmployeeRecovery: Record "Employee Recovery";
        ProfessionalExpances: Record "Professional Expances";
    begin
        ParamPaie.GET;

        RubriqueSalarie.RESET;
        Salarie.CALCFIELDS("Total Absences Days");
        //Salarie.CALCFIELDS("Total Absences Hours");
        NbreJoursAbsence := Salarie."Total Absences Days";//ROUND(Salarie."Total Absences Days"/ParamPaie."No. of Hours By Day",0.01);

        IF Salarie.Regime = Salarie.Regime::"Vacataire journalier" THEN BEGIN
            L_RubriqueSalarie.GET(Salarie."No.", ParamPaie."No. of Days (Daily Vacatary)");
            L_Valeur := L_RubriqueSalarie.Number;
        END
        ELSE
            //20
            L_Valeur := ParamPaie."No. of Worked Days";
        EXIT((L_Valeur - NbreJoursAbsence));
    end;

    /// <summary>
    /// NbreJoursPresencePanierTransport.
    /// </summary>
    /// <param name="EmployeeNumber">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure NbreJoursPresencePanierTransport(EmployeeNumber: Code[20]): Decimal;
    var
        NbreJoursAbsence: Decimal;
        L_Valeur: Decimal;
        L_RubriqueSalarie: Record "Employee Payroll Item";
        NbreJoursPresence: Decimal;
        EmployeeRecovery: Record "Employee Recovery";
        ProfessionalExpances: Record "Professional Expances";
    begin
        Salarie.SETFILTER("Date Filter", '%1..%2', DebutPeriodePaie, FinPeriodePaie);
        ParamPaie.GET;
        //MESSAGE('Debut:%1,fin:%2',DebutPeriodePaie,FinPeriodePaie);
        EmployeeRecovery.RESET;
        EmployeeRecovery.SETRANGE("Employee No.", EmployeeNumber);
        EmployeeRecovery.SETRANGE(EmployeeRecovery.nature, EmployeeRecovery.nature::consomé);
        EmployeeRecovery.SETFILTER("From Date", '>=%1 & <=%2', DebutPeriodePaie, FinPeriodePaie);
        EmployeeRecovery.SETFILTER("To Date", '>=%1 & <=%2', DebutPeriodePaie, FinPeriodePaie);
        NbreJoursAbsence := 0;
        IF EmployeeRecovery.FINDFIRST THEN BEGIN
            REPEAT
                NbreJoursAbsence := NbreJoursAbsence + EmployeeRecovery.Quantity;
            UNTIL EmployeeRecovery.NEXT = 0;
        END;
        //  MESSAGE('%1 1:',NbreJoursAbsence);
        ProfessionalExpances.RESET;
        ProfessionalExpances.SETRANGE("Employee No.", EmployeeNumber);
        ProfessionalExpances.SETFILTER(Date, '>=%1 & <=%2', DebutPeriodePaie, FinPeriodePaie);
        //ProfessionalExpances.SETFILTER(Date,'<=%2',FinPeriodePaie);
        //NbreJoursAbsence:=0;
        IF ProfessionalExpances.FINDFIRST THEN BEGIN
            REPEAT
                NbreJoursAbsence := NbreJoursAbsence + ProfessionalExpances.Quantity;
            UNTIL ProfessionalExpances.NEXT = 0;
        END;
        // MESSAGE('%1 2:',NbreJoursAbsence);
        RubriqueSalarie.RESET;
        Salarie.CALCFIELDS("Total Absences Days");

        //Salarie.CALCFIELDS("Total Absences Hours");
        NbreJoursAbsence := NbreJoursAbsence + Salarie."Total Absences Days";//ROUND(Salarie."Total Absences Days"/ParamPaie."No. of Hours By Day",0.01);
        //MESSAGE('%1 3:',NbreJoursAbsence);
        IF Salarie.Regime = Salarie.Regime::"Vacataire journalier" THEN BEGIN
            L_RubriqueSalarie.GET(Salarie."No.", ParamPaie."No. of Days (Daily Vacatary)");
            L_Valeur := L_RubriqueSalarie.Number;
        END
        ELSE
            L_Valeur := ParamPaie."No. of Worked Days";

        //MESSAGE('%1 4:  ',L_Valeur);
        EXIT((L_Valeur - NbreJoursAbsence));
    end;

    /// <summary>
    /// CalcEmployeeCacobatphDeduction.
    /// </summary>
    procedure CalcEmployeeCacobatphDeduction();
    begin
        //Cacobatph
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Item Code", ParamPaie."SS Basis");
        RubriqueSalarie.FINDFIRST;
        Rubrique.GET(ParamPaie."Employer Cotisation Cacobaptph");
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := Rubrique.Code;
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        RubriqueSalarie2.Amount := ROUND(RubriqueSalarie.Amount * ParamPaie."Cotisation employeur cacobatph" / 100);
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2.Basis := RubriqueSalarie.Amount;
        RubriqueSalarie2.Rate := ParamPaie."Cotisation employeur cacobatph";
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;
    end;

    /// <summary>
    /// CalcEmployeePretbatphDeduction.
    /// </summary>
    procedure CalcEmployeePretbatphDeduction();
    begin
        //Cacobatph
        RubriqueSalarie.RESET;
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Employee No.", NumeroSalarie);
        RubriqueSalarie.SETRANGE(RubriqueSalarie."Item Code", ParamPaie."SS Basis");
        RubriqueSalarie.FINDFIRST;
        Rubrique.GET(ParamPaie."Employer Cotisation pretbath");
        RubriqueSalarie2.INIT;
        RubriqueSalarie2."Employee No." := NumeroSalarie;
        RubriqueSalarie2."Item Code" := Rubrique.Code;
        RubriqueSalarie2."Item Description" := Rubrique.Description;
        RubriqueSalarie2.Amount := ROUND(RubriqueSalarie.Amount * ParamPaie."Cotisation employeur pretbath" / 100);
        RubriqueSalarie2.Type := Rubrique."Item Type";
        RubriqueSalarie2.Basis := RubriqueSalarie.Amount;
        RubriqueSalarie2.Rate := ParamPaie."Cotisation employeur pretbath";
        RubriqueSalarie2."Submitted To Leave" := Rubrique."Submitted To Leave";
        RubriqueSalarie2.Taxable := Rubrique.Taxable;
        RubriqueSalarie2.Regularization := Rubrique.Regularization;
        RubriqueSalarie2.INSERT;
    end;
}

