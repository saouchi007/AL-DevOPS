/// <summary>
/// Codeunit Reminder Management (ID "Reminder Management").
/// </summary>
codeunit 52182433 "Reminder Management"
//codeunit 39108405 "Reminder Management"
{
    // version HALRHPAIE.6.2.01

    //  Souhila :
    //  18/03/2012 : Type formule reprendre le calcul de libre saisie pour ajouter et modifier


    trigger OnRun();
    begin
    end;

    var
        EcriturePaie: Record "Payroll Entry";
        Text01: Label 'Annuler le rappel %1 du salarié %2 ? Toutes les écritures de rappel seront annulées irrévocablement.';
        Text02: Label '"Générer les écritures comptables %1 %2 ? "';
        Text03: Label 'Génération de l''écriture comptable %1 %2 effectuée avec succès.\Modèle %3, Feuille %4';
        ParamPaie: Record Payroll_Setup;
        ModeleFeuille: Code[10];
        Feuille: Code[10];
        Journal: Code[10];
        GenJournalTemplate: Record 80;
        GLPayrollBuffer: Record "G/L Payroll Buffer";
        GLPayrollBuffer2: Record "G/L Payroll Buffer";
        NumProchaineSequence: Integer;
        GenJournalLine: Record 81;
        ParametresCompta: Record 98;
        Salarie: Record 5200;
        Cpte: Record 15;
        Paie: Record Payroll;
        Text04: Label 'Le rappel %1 est clôturé !';
        Text05: Label 'Suppression impossible du salarié %1. Il est utilisé dans la table %2.';
        Text06: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        CodeUnite: Code[10];
        Text07: Label 'Calcul du rappel %1 effectué avec succès.\Génération de %2 écritures pour le salarié %3.';
        Text08: Label 'Code de direction non configuré dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        ConstatationWarning: Record "Payroll Constatation Warning";
        Text09: Label 'Rappel %1 pour le salarié %2 déjà calculé ! Veuillez l''annuler avant de relancer le calcul.\Voulez-vous l''annuler maintenant ?';
        Text10: Label 'Rubrique "Salaire de base" manquante !';
        SalaireBase: Decimal;
        SalaireImposable: Decimal;
        SalairePoste: Decimal;
        Rubrique: Record "Payroll Item";
        Rubrique2: Record "Payroll Item";
        Montant1: Decimal;
        BaseIRG: Decimal;
        NumeroSalarie: Code[20];
        Abattement: Decimal;
        LigneArchivePaie: Record "Payroll Archive Line";
        EnteteArchivePaie: Record "Payroll Archive Header";
        EnteteRappel: Record "Payroll Reminder Header";
        RappelSituation: Record "Reminder Payroll Archive";
        RappelSituation2: Record "Reminder Payroll Archive";
        RappelSituation3: Record "Reminder Payroll Archive";
        GestionRappel: Codeunit "Reminder Management";
        RubriqueRappel: Record "Reminder Payroll Item";
        BaremeIRG: Record "TIT Grid";
        MontantIRG: Decimal;
        MontantSS: Decimal;
        SalairePosteMoyen: Decimal;
        AffectAnalytique: Record 352;
        HistTransactRappel: Record "Reminder Register";
        RubriquesLot: Record "Reminder Lot Items";
        Nbre1: Decimal;
        NbreHeuresVacataire: Decimal;
        NbreJoursVacataire: Decimal;
        MotifAbsence: Record 5206;
        TotalisationLot: Record "Reminder Lot Totalisation";

    /// <summary>
    /// CalcRappel.
    /// </summary>
    /// <param name="P_LotRappel">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Colonne">Integer.</param>
    procedure CalcRappel(P_LotRappel: Code[20]; P_Salarie: Code[20]; P_Paie: Code[20]; P_Colonne: Integer);
    begin
        ParamPaie.GET;
        RubriquesLot.RESET;
        RubriquesLot.SETRANGE("No.", P_LotRappel);
        RubriquesLot.FINDFIRST;
        REPEAT
            IF NOT RappelSituation.GET(P_LotRappel, P_Salarie, RubriquesLot."Item Code") THEN
                IF RubriquesLot."Add if Inexistant" THEN BEGIN
                    RappelSituation.INIT;
                    RappelSituation."Reminder Lot No." := P_LotRappel;
                    RappelSituation."Employee No." := P_Salarie;
                    RappelSituation."Item Code" := RubriquesLot."Item Code";
                    RappelSituation."Item Description" := RubriquesLot."Item Description";
                    Rubrique.GET(RubriquesLot."Item Code");
                    RappelSituation.Type := Rubrique."Item Type";
                    CASE Rubrique."Item Type" OF
                        Rubrique."Item Type"::Pourcentage:
                            BEGIN
                                RappelSituation2.GET(P_LotRappel, P_Salarie, Rubrique."Basis of Calculation");
                                CASE P_Colonne OF
                                    1:
                                        RappelSituation."Basis 1" := ROUND(RappelSituation2."Amount 1");
                                    2:
                                        RappelSituation."Basis 2" := RappelSituation2."Amount 2";
                                    3:
                                        RappelSituation."Basis 3" := RappelSituation2."Amount 3";
                                    4:
                                        RappelSituation."Basis 4" := RappelSituation2."Amount 4";
                                    5:
                                        RappelSituation."Basis 5" := RappelSituation2."Amount 5";
                                    6:
                                        RappelSituation."Basis 6" := RappelSituation2."Amount 6";
                                    7:
                                        RappelSituation."Basis 7" := RappelSituation2."Amount 7";
                                    8:
                                        RappelSituation."Basis 8" := RappelSituation2."Amount 8";
                                    9:
                                        RappelSituation."Basis 9" := RappelSituation2."Amount 9";
                                    10:
                                        RappelSituation."Basis 10" := RappelSituation2."Amount 10";
                                    11:
                                        RappelSituation."Basis 11" := RappelSituation2."Amount 11";
                                    12:
                                        RappelSituation."Basis 12" := RappelSituation2."Amount 12";
                                END;
                            END;
                        Rubrique."Item Type"::"Au prorata", Rubrique."Item Type"::"Au prorata autorisé":
                            BEGIN
                                CASE P_Colonne OF
                                    1:
                                        RappelSituation."Rate 1" := 1;
                                    2:
                                        RappelSituation."Rate 2" := 1;
                                    3:
                                        RappelSituation."Rate 3" := 1;
                                    4:
                                        RappelSituation."Rate 4" := 1;
                                    5:
                                        RappelSituation."Rate 5" := 1;
                                    6:
                                        RappelSituation."Rate 6" := 1;
                                    7:
                                        RappelSituation."Rate 7" := 1;
                                    8:
                                        RappelSituation."Rate 8" := 1;
                                    9:
                                        RappelSituation."Rate 9" := 1;
                                    10:
                                        RappelSituation."Rate 10" := 1;
                                    11:
                                        RappelSituation."Rate 11" := 1;
                                    12:
                                        RappelSituation."Rate 12" := 1;
                                END;
                            END;
                    END;
                    RappelSituation.INSERT;
                END;
            IF RappelSituation.GET(P_LotRappel, P_Salarie, RubriquesLot."Item Code") THEN BEGIN
                CASE P_Colonne OF
                    1:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 1" := RappelSituation."Payroll Basis 1" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 1" := RappelSituation."Payroll Number 1" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 1" := RappelSituation."Payroll Basis 1" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 1" := RappelSituation."Payroll Number 1" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 1" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 1" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 1" := RubriquesLot.Amount;
                                                            RappelSituation."Number 1" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 1" := ROUND(RappelSituation."Number 1" * RappelSituation."Basis 1");
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 1" := RappelSituation."Payroll Rate 1" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 1" := RappelSituation."Payroll Rate 1" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 1" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 1" := ROUND(RappelSituation."Rate 1" * RappelSituation."Basis 1" / 100);
                                END;
                            RappelSituation.Type::Formule:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 1" := ROUND(RappelSituation."Payroll Amount 1" * RubriquesLot.Rate);
                                        // RubriquesLot.Calculation::"Ajouter une valeur":
                                        // RappelSituation."Amount 1":=ROUND(RappelSituation."Payroll Amount 1"+RubriquesLot.Amount);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 1" := ROUND(RappelSituation."Payroll Amount 1" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 1" := RappelSituation."Payroll Basis 1" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 1" := RappelSituation."Payroll Number 1" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 1" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 1" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 1" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 1" := RubriquesLot.Amount;
                                                            RappelSituation."Number 1" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN BEGIN
                                        MotifAbsence.RESET;
                                        MotifAbsence.SETRANGE("Item Code", RubriquesLot."Item Code");
                                        IF MotifAbsence.FINDFIRST THEN BEGIN                                                                             //ICI
                                            IF EnteteArchivePaie.GET(P_Paie, P_Salarie) THEN BEGIN
                                                CASE EnteteArchivePaie.Regime OF
                                                    EnteteArchivePaie.Regime::Mensuel:
                                                        BEGIN
                                                            RappelSituation2.GET(P_LotRappel, P_Salarie, ParamPaie."Base Salary");
                                                            CASE MotifAbsence."Unit of Measure Code" OF
                                                                'JOUR':
                                                                    Nbre1 := ParamPaie."No. of Worked Days";
                                                                'HEURE':
                                                                    Nbre1 := ParamPaie."No. of Worked Hours";
                                                            END;
                                                        END;
                                                    EnteteArchivePaie.Regime::"Vacataire journalier":
                                                        RappelSituation2.GET(P_LotRappel, P_Salarie, ParamPaie."No. of Days (Daily Vacatary)");
                                                END;
                                                CASE P_Colonne OF
                                                    1:
                                                        BEGIN //A DUPLIQUER SUR les autres 11 mois
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 1";
                                                            RappelSituation."Basis 1" := ROUND(RappelSituation2."Amount 1" / Nbre1);
                                                            RappelSituation."Amount 1" := -ROUND(RappelSituation."Basis 1" * RappelSituation."Number 1");
                                                        END;
                                                    2:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 2";
                                                            RappelSituation."Basis 2" := ROUND(RappelSituation2."Amount 2" / Nbre1);
                                                            RappelSituation."Amount 2" := -ROUND(RappelSituation."Basis 2" * RappelSituation."Number 2");
                                                        END;
                                                    3:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 3";
                                                            RappelSituation."Basis 3" := ROUND(RappelSituation3."Amount 3" / Nbre1);
                                                            RappelSituation."Amount 3" := -ROUND(RappelSituation."Basis 3" * RappelSituation."Number 3");
                                                        END;
                                                    4:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 4";
                                                            RappelSituation."Basis 4" := ROUND(RappelSituation2."Amount 4" / Nbre1);
                                                            RappelSituation."Amount 4" := -ROUND(RappelSituation."Basis 4" * RappelSituation."Number 4");
                                                        END;
                                                    5:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 5";
                                                            RappelSituation."Basis 5" := ROUND(RappelSituation2."Amount 5" / Nbre1);
                                                            RappelSituation."Amount 5" := -ROUND(RappelSituation."Basis 5" * RappelSituation."Number 5");
                                                        END;
                                                    6:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 6";
                                                            RappelSituation."Basis 6" := ROUND(RappelSituation2."Amount 6" / Nbre1);
                                                            RappelSituation."Amount 6" := -ROUND(RappelSituation."Basis 6" * RappelSituation."Number 6");
                                                        END;
                                                    7:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 7";
                                                            RappelSituation."Basis 7" := ROUND(RappelSituation2."Amount 7" / Nbre1);
                                                            RappelSituation."Amount 7" := -ROUND(RappelSituation."Basis 7" * RappelSituation."Number 7");
                                                        END;
                                                    8:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 8";
                                                            RappelSituation."Basis 8" := ROUND(RappelSituation2."Amount 8" / Nbre1);
                                                            RappelSituation."Amount 8" := -ROUND(RappelSituation."Basis 8" * RappelSituation."Number 8");
                                                        END;
                                                    9:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 9";
                                                            RappelSituation."Basis 9" := ROUND(RappelSituation2."Amount 9" / Nbre1);
                                                            RappelSituation."Amount 9" := -ROUND(RappelSituation."Basis 9" * RappelSituation."Number 9");
                                                        END;
                                                    10:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 10";
                                                            RappelSituation."Basis 10" := ROUND(RappelSituation2."Amount 10" / Nbre1);
                                                            RappelSituation."Amount 10" := -ROUND(RappelSituation."Basis 10" * RappelSituation."Number 10");
                                                        END;
                                                    11:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 11";
                                                            RappelSituation."Basis 11" := ROUND(RappelSituation2."Amount 11" / Nbre1);
                                                            RappelSituation."Amount 11" := -ROUND(RappelSituation."Basis 11" * RappelSituation."Number 11");
                                                        END;
                                                    12:
                                                        BEGIN
                                                            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                                Nbre1 := RappelSituation2."Number 12";
                                                            RappelSituation."Basis 12" := ROUND(RappelSituation2."Amount 12" / Nbre1);
                                                            RappelSituation."Amount 12" := -ROUND(RappelSituation."Basis 12" * RappelSituation."Number 12");
                                                        END;
                                                END;
                                            END;
                                        END
                                        ELSE
                                            RappelSituation."Amount 1" := ROUND(RappelSituation."Basis 1" * RappelSituation."Number 1")
                                    END

                                    ELSE
                                        RappelSituation."Basis 1" := ROUND(RappelSituation."Amount 1" / RappelSituation."Number 1");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 1" := RappelSituation."Payroll Basis 1" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 1" := RappelSituation."Payroll Basis 1" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 1" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 1" := ROUND(RappelSituation."Rate 1" * RappelSituation."Basis 1");
                                END;
                        END;

                    2:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 2" := RappelSituation."Payroll Basis 2" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 2" := RappelSituation."Payroll Number 2" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 2" := RappelSituation."Payroll Basis 2" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 2" := RappelSituation."Payroll Number 2" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 2" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 2" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 2" := RubriquesLot.Amount;
                                                            RappelSituation."Number 2" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 2" := ROUND(RappelSituation."Number 2" * RappelSituation."Basis 2");
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 2" := RappelSituation."Payroll Rate 2" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 2" := RappelSituation."Payroll Rate 2" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 2" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 2" := ROUND(RappelSituation."Rate 2" * RappelSituation."Basis 2" / 100);
                                END;
                            RappelSituation.Type::Formule:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 2" := ROUND(RappelSituation."Payroll Amount 2" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 2" := ROUND(RappelSituation."Payroll Amount 2" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 2" := RappelSituation."Payroll Basis 2" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 2" := RappelSituation."Payroll Number 2" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 2" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 2" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 2" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 2" := RubriquesLot.Amount;
                                                            RappelSituation."Number 2" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 2" := ROUND(RappelSituation."Basis 2" * RappelSituation."Number 2")
                                    ELSE
                                        RappelSituation."Basis 2" := ROUND(RappelSituation."Amount 2" / RappelSituation."Number 2");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 2" := RappelSituation."Payroll Basis 2" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 2" := RappelSituation."Payroll Basis 2" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 2" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 2" := ROUND(RappelSituation."Rate 2" * RappelSituation."Basis 2");
                                END;
                        END;
                    3:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 3" := RappelSituation."Payroll Basis 3" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 3" := RappelSituation."Payroll Number 3" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 3" := RappelSituation."Payroll Basis 3" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 3" := RappelSituation."Payroll Number 3" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 3" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 3" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 3" := RubriquesLot.Amount;
                                                            RappelSituation."Number 3" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 3" := RappelSituation."Number 3" * RappelSituation."Basis 3";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 3" := RappelSituation."Payroll Rate 3" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 3" := RappelSituation."Payroll Rate 3" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 3" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 3" := ROUND(RappelSituation."Rate 3" * RappelSituation."Basis 3" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 3" := ROUND(RappelSituation."Payroll Amount 3" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 3" := ROUND(RappelSituation."Payroll Amount 3" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 3" := RappelSituation."Payroll Basis 3" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 3" := RappelSituation."Payroll Number 3" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 3" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 3" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 3" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 3" := RubriquesLot.Amount;
                                                            RappelSituation."Number 3" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 3" := ROUND(RappelSituation."Basis 3" * RappelSituation."Number 3")
                                    ELSE
                                        RappelSituation."Basis 3" := ROUND(RappelSituation."Amount 3" / RappelSituation."Number 3");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 3" := RappelSituation."Payroll Basis 3" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 3" := RappelSituation."Payroll Basis 3" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 3" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 3" := ROUND(RappelSituation."Rate 3" * RappelSituation."Basis 3");
                                END;
                        END;
                    4:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 4" := RappelSituation."Payroll Basis 4" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 4" := RappelSituation."Payroll Number 4" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 4" := RappelSituation."Payroll Basis 4" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 4" := RappelSituation."Payroll Number 4" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 4" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 4" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 4" := RubriquesLot.Amount;
                                                            RappelSituation."Number 4" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 4" := RappelSituation."Number 4" * RappelSituation."Basis 4";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 4" := RappelSituation."Payroll Rate 4" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 4" := RappelSituation."Payroll Rate 4" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 4" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 4" := ROUND(RappelSituation."Rate 4" * RappelSituation."Basis 4" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 4" := ROUND(RappelSituation."Payroll Amount 4" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 4" := ROUND(RappelSituation."Payroll Amount 4" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 4" := RappelSituation."Payroll Basis 4" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 4" := RappelSituation."Payroll Number 4" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 4" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 4" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 4" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 4" := RubriquesLot.Amount;
                                                            RappelSituation."Number 4" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 4" := ROUND(RappelSituation."Basis 4" * RappelSituation."Number 4")
                                    ELSE
                                        RappelSituation."Basis 4" := ROUND(RappelSituation."Amount 4" / RappelSituation."Number 4");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 4" := RappelSituation."Payroll Basis 4" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 4" := RappelSituation."Payroll Basis 4" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 4" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 4" := ROUND(RappelSituation."Rate 4" * RappelSituation."Basis 4");
                                END;
                        END;
                    5:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 5" := RappelSituation."Payroll Basis 5" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 5" := RappelSituation."Payroll Number 5" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 5" := RappelSituation."Payroll Basis 5" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 5" := RappelSituation."Payroll Number 5" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 5" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 5" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 5" := RubriquesLot.Amount;
                                                            RappelSituation."Number 5" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 5" := RappelSituation."Number 5" * RappelSituation."Basis 5";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 5" := RappelSituation."Payroll Rate 5" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 5" := RappelSituation."Payroll Rate 5" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 5" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 5" := ROUND(RappelSituation."Rate 5" * RappelSituation."Basis 5" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 5" := ROUND(RappelSituation."Payroll Amount 5" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 5" := ROUND(RappelSituation."Payroll Amount 5" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 5" := RappelSituation."Payroll Basis 5" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 5" := RappelSituation."Payroll Number 5" + RubriquesLot.Number;
                                                END;
                                            END;

                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 5" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 5" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 5" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 5" := RubriquesLot.Amount;
                                                            RappelSituation."Number 5" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 5" := ROUND(RappelSituation."Basis 5" * RappelSituation."Number 5")
                                    ELSE
                                        RappelSituation."Basis 5" := ROUND(RappelSituation."Amount 5" / RappelSituation."Number 5");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 5" := RappelSituation."Payroll Basis 5" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 5" := RappelSituation."Payroll Basis 5" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 5" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 5" := ROUND(RappelSituation."Rate 5" * RappelSituation."Basis 5");
                                END;
                        END;
                    6:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 6" := RappelSituation."Payroll Basis 6" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 6" := RappelSituation."Payroll Number 6" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 6" := RappelSituation."Payroll Basis 6" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 6" := RappelSituation."Payroll Number 6" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 6" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 6" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 6" := RubriquesLot.Amount;
                                                            RappelSituation."Number 6" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 6" := RappelSituation."Number 6" * RappelSituation."Basis 6";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 6" := RappelSituation."Payroll Rate 6" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 6" := RappelSituation."Payroll Rate 6" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 6" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 6" := ROUND(RappelSituation."Rate 6" * RappelSituation."Basis 6" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 6" := ROUND(RappelSituation."Payroll Amount 6" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 6" := ROUND(RappelSituation."Payroll Amount 6" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 6" := RappelSituation."Payroll Basis 6" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 6" := RappelSituation."Payroll Number 6" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 6" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 6" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 6" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 6" := RubriquesLot.Amount;
                                                            RappelSituation."Number 6" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 6" := ROUND(RappelSituation."Basis 6" * RappelSituation."Number 6")
                                    ELSE
                                        RappelSituation."Basis 6" := ROUND(RappelSituation."Amount 6" / RappelSituation."Number 6");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 6" := RappelSituation."Payroll Basis 6" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 6" := RappelSituation."Payroll Basis 6" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 6" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 6" := ROUND(RappelSituation."Rate 6" * RappelSituation."Basis 6");
                                END;
                        END;
                    7:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 7" := RappelSituation."Payroll Basis 7" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 7" := RappelSituation."Payroll Number 7" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 7" := RappelSituation."Payroll Basis 7" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 7" := RappelSituation."Payroll Number 7" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 7" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 7" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 7" := RubriquesLot.Amount;
                                                            RappelSituation."Number 7" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 7" := RappelSituation."Number 7" * RappelSituation."Basis 7";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 7" := RappelSituation."Payroll Rate 7" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 7" := RappelSituation."Payroll Rate 7" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 7" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 7" := ROUND(RappelSituation."Rate 7" * RappelSituation."Basis 7" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 7" := ROUND(RappelSituation."Payroll Amount 7" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 7" := ROUND(RappelSituation."Payroll Amount 7" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 7" := RappelSituation."Payroll Basis 7" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 7" := RappelSituation."Payroll Number 7" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 7" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 7" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 7" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 7" := RubriquesLot.Amount;
                                                            RappelSituation."Number 7" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 7" := ROUND(RappelSituation."Basis 7" * RappelSituation."Number 7")
                                    ELSE
                                        RappelSituation."Basis 7" := ROUND(RappelSituation."Amount 7" / RappelSituation."Number 7");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 7" := RappelSituation."Payroll Basis 7" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 7" := RappelSituation."Payroll Basis 7" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 7" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 7" := ROUND(RappelSituation."Rate 7" * RappelSituation."Basis 7");
                                END;
                        END;
                    8:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 8" := RappelSituation."Payroll Basis 8" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 8" := RappelSituation."Payroll Number 8" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 8" := RappelSituation."Payroll Basis 8" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 8" := RappelSituation."Payroll Number 8" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 8" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 8" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 8" := RubriquesLot.Amount;
                                                            RappelSituation."Number 8" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 8" := RappelSituation."Number 8" * RappelSituation."Basis 8";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 8" := RappelSituation."Payroll Rate 8" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 8" := RappelSituation."Payroll Rate 8" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 8" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 8" := ROUND(RappelSituation."Rate 8" * RappelSituation."Basis 8" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 8" := ROUND(RappelSituation."Payroll Amount 8" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 8" := ROUND(RappelSituation."Payroll Amount 8" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 8" := RappelSituation."Payroll Basis 8" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 8" := RappelSituation."Payroll Number 8" + RubriquesLot.Number;
                                                END;
                                            END;

                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 8" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 8" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 8" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 8" := RubriquesLot.Amount;
                                                            RappelSituation."Number 8" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 8" := ROUND(RappelSituation."Basis 8" * RappelSituation."Number 8")
                                    ELSE
                                        RappelSituation."Basis 8" := ROUND(RappelSituation."Amount 8" / RappelSituation."Number 8");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 8" := RappelSituation."Payroll Basis 8" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 8" := RappelSituation."Payroll Basis 8" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 8" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 8" := ROUND(RappelSituation."Rate 8" * RappelSituation."Basis 8");
                                END;
                        END;
                    9:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 9" := RappelSituation."Payroll Basis 9" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 9" := RappelSituation."Payroll Number 9" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 9" := RappelSituation."Payroll Basis 9" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 9" := RappelSituation."Payroll Number 9" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 9" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 9" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 9" := RubriquesLot.Amount;
                                                            RappelSituation."Number 9" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 9" := RappelSituation."Number 9" * RappelSituation."Basis 9";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 9" := RappelSituation."Payroll Rate 9" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 9" := RappelSituation."Payroll Rate 9" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 9" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 9" := ROUND(RappelSituation."Rate 9" * RappelSituation."Basis 9" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 9" := ROUND(RappelSituation."Payroll Amount 9" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 9" := ROUND(RappelSituation."Payroll Amount 9" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 9" := RappelSituation."Payroll Basis 9" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 9" := RappelSituation."Payroll Number 9" + RubriquesLot.Number;
                                                END;
                                            END;

                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 9" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 9" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 9" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 9" := RubriquesLot.Amount;
                                                            RappelSituation."Number 9" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 9" := ROUND(RappelSituation."Basis 9" * RappelSituation."Number 9")
                                    ELSE
                                        RappelSituation."Basis 9" := ROUND(RappelSituation."Amount 9" / RappelSituation."Number 9");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 9" := RappelSituation."Payroll Basis 9" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 9" := RappelSituation."Payroll Basis 9" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 9" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 9" := ROUND(RappelSituation."Rate 9" * RappelSituation."Basis 9");
                                END;
                        END;
                    10:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 10" := RappelSituation."Payroll Basis 10" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 10" := RappelSituation."Payroll Number 10" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 10" := RappelSituation."Payroll Basis 10" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 10" := RappelSituation."Payroll Number 10" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 10" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 10" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 10" := RubriquesLot.Amount;
                                                            RappelSituation."Number 10" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 10" := RappelSituation."Number 10" * RappelSituation."Basis 10";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 10" := RappelSituation."Payroll Rate 10" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 10" := RappelSituation."Payroll Rate 10" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 10" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 10" := ROUND(RappelSituation."Rate 10" * RappelSituation."Basis 10" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 10" := ROUND(RappelSituation."Payroll Amount 10" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 10" := ROUND(RappelSituation."Payroll Amount 10" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 10" := RappelSituation."Payroll Basis 10" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 10" := RappelSituation."Payroll Number 10" + RubriquesLot.Number;
                                                END;
                                            END;

                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 10" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 10" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 10" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 10" := RubriquesLot.Amount;
                                                            RappelSituation."Number 10" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 10" := ROUND(RappelSituation."Basis 10" * RappelSituation."Number 10")
                                    ELSE
                                        RappelSituation."Basis 10" := ROUND(RappelSituation."Amount 10" / RappelSituation."Number 10");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 10" := RappelSituation."Payroll Basis 10" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 10" := RappelSituation."Payroll Basis 10" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 10" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 10" := ROUND(RappelSituation."Rate 10" * RappelSituation."Basis 10");
                                END;
                        END;
                    11:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 11" := RappelSituation."Payroll Basis 11" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 11" := RappelSituation."Payroll Number 11" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 11" := RappelSituation."Payroll Basis 11" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 11" := RappelSituation."Payroll Number 11" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 11" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 11" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 11" := RubriquesLot.Amount;
                                                            RappelSituation."Number 11" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 11" := RappelSituation."Number 11" * RappelSituation."Basis 11";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 11" := RappelSituation."Payroll Rate 11" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 11" := RappelSituation."Payroll Rate 11" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 11" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 11" := ROUND(RappelSituation."Rate 11" * RappelSituation."Basis 11" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 11" := ROUND(RappelSituation."Payroll Amount 11" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 11" := ROUND(RappelSituation."Payroll Amount 11" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 11" := RappelSituation."Payroll Basis 11" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 11" := RappelSituation."Payroll Number 11" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 11" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 11" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 11" := RubriquesLot.Amount;
                                                            RappelSituation."Number 11" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    // RubriquesLot.Calculation::"Remplacer la valeur": Commented by AK
                                    //     BEGIN
                                    //         CASE RubriquesLot.Value OF
                                    //             RubriquesLot.Value::Montant:
                                    //                 RappelSituation."Amount 11" := ROUND(RubriquesLot.Amount);
                                    //             RubriquesLot.Value::Base:
                                    //                 RappelSituation."Basis 11" := RubriquesLot.Amount;
                                    //             RubriquesLot.Value::Nombre:
                                    //                 RappelSituation."Number 11" := RubriquesLot.Number;
                                    //             RubriquesLot.Value::"Nbre&Base":
                                    //                 BEGIN
                                    //                     RappelSituation."Basis 11" := RubriquesLot.Amount;
                                    //                     RappelSituation."Number 11" := RubriquesLot.Number;
                                    //                 END;
                                    //         END;
                                    //     END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 11" := ROUND(RappelSituation."Basis 11" * RappelSituation."Number 11")
                                    ELSE
                                        RappelSituation."Basis 11" := ROUND(RappelSituation."Amount 11" / RappelSituation."Number 11");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 11" := RappelSituation."Payroll Basis 11" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 11" := RappelSituation."Payroll Basis 11" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 11" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 11" := ROUND(RappelSituation."Rate 11" * RappelSituation."Basis 11");
                                END;
                        END;
                    12:
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::"Libre saisie":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 12" := RappelSituation."Payroll Basis 12" * RubriquesLot.Rate;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 12" := RappelSituation."Payroll Number 12" * RubriquesLot.Rate;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 12" := RappelSituation."Payroll Basis 12" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 12" := RappelSituation."Payroll Number 12" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 12" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 12" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 12" := RubriquesLot.Amount;
                                                            RappelSituation."Number 12" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    RappelSituation."Amount 12" := RappelSituation."Number 12" * RappelSituation."Basis 12";
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Rate 12" := RappelSituation."Payroll Rate 12" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Rate 12" := RappelSituation."Payroll Rate 12" + RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Rate 12" := RubriquesLot.Rate;
                                    END;
                                    RappelSituation."Amount 12" := ROUND(RappelSituation."Rate 12" * RappelSituation."Basis 12" / 100);
                                END;
                            RappelSituation.Type::Formule:

                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Amount 12" := ROUND(RappelSituation."Payroll Amount 12" * RubriquesLot.Rate);
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 12" := ROUND(RappelSituation."Payroll Amount 12" + RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 12" := RappelSituation."Payroll Basis 12" + RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 12" := RappelSituation."Payroll Number 12" + RubriquesLot.Number;
                                                END;
                                            END;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            BEGIN
                                                CASE RubriquesLot.Value OF
                                                    RubriquesLot.Value::Montant:
                                                        RappelSituation."Amount 12" := ROUND(RubriquesLot.Amount);
                                                    RubriquesLot.Value::Base:
                                                        RappelSituation."Basis 12" := RubriquesLot.Amount;
                                                    RubriquesLot.Value::Nombre:
                                                        RappelSituation."Number 12" := RubriquesLot.Number;
                                                    RubriquesLot.Value::"Nbre&Base":
                                                        BEGIN
                                                            RappelSituation."Basis 12" := RubriquesLot.Amount;
                                                            RappelSituation."Number 12" := RubriquesLot.Number;
                                                        END;
                                                END;
                                            END;
                                    END;
                                    IF RappelSituation."Item Code" <> '001' THEN
                                        RappelSituation."Amount 12" := ROUND(RappelSituation."Basis 12" * RappelSituation."Number 12")
                                    ELSE
                                        RappelSituation."Basis 12" := ROUND(RappelSituation."Amount 12" / RappelSituation."Number 12");
                                END;
                            RappelSituation.Type::"Au prorata", RappelSituation.Type::"Au prorata autorisé":
                                BEGIN
                                    CASE RubriquesLot.Calculation OF
                                        RubriquesLot.Calculation::"Appliquer un coefficient":
                                            RappelSituation."Basis 12" := RappelSituation."Payroll Basis 12" * RubriquesLot.Rate;
                                        RubriquesLot.Calculation::"Ajouter une valeur":
                                            RappelSituation."Basis 12" := RappelSituation."Payroll Basis 12" + RubriquesLot.Amount;
                                        RubriquesLot.Calculation::"Remplacer la valeur":
                                            RappelSituation."Basis 12" := RubriquesLot.Amount;
                                    END;
                                    RappelSituation."Amount 12" := ROUND(RappelSituation."Rate 12" * RappelSituation."Basis 12");
                                END;
                        END;
                END;
                RappelSituation.MODIFY;
                RappelSituation.RESET;
                RappelSituation.SETRANGE("Reminder Lot No.", P_LotRappel);
                RappelSituation.SETRANGE("Employee No.", P_Salarie);
                RappelSituation.SETFILTER("Item Code", '>%1', RubriquesLot."Item Code");
                IF RappelSituation.FINDFIRST THEN
                    REPEAT
                        Rubrique.GET(RappelSituation."Item Code");
                        CASE RappelSituation.Type OF
                            RappelSituation.Type::Formule:
                                IF Rubrique."Calculation Formula" <> '' THEN BEGIN
                                    RappelSituation2.RESET;
                                    RappelSituation2.SETRANGE("Reminder Lot No.", P_LotRappel);
                                    RappelSituation2.SETRANGE("Employee No.", P_Salarie);
                                    RappelSituation2.SETFILTER("Item Code", Rubrique."Calculation Formula");
                                    Montant1 := 0;
                                    IF RappelSituation2.FINDSET THEN
                                        REPEAT
                                            CASE P_Colonne OF
                                                1:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 1");
                                                2:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 2");
                                                3:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 3");
                                                4:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 4");
                                                5:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 5");
                                                6:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 6");
                                                7:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 7");
                                                8:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 8");
                                                9:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 9");
                                                10:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 10");
                                                11:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 11");
                                                12:
                                                    Montant1 := Montant1 + ROUND(RappelSituation2."Amount 12");
                                            END;
                                        UNTIL RappelSituation2.NEXT = 0;
                                    CASE P_Colonne OF
                                        1:
                                            RappelSituation."Amount 1" := ROUND(Montant1);
                                        2:
                                            RappelSituation."Amount 2" := Montant1;
                                        3:
                                            RappelSituation."Amount 3" := Montant1;
                                        4:
                                            RappelSituation."Amount 4" := Montant1;
                                        5:
                                            RappelSituation."Amount 5" := Montant1;
                                        6:
                                            RappelSituation."Amount 6" := Montant1;
                                        7:
                                            RappelSituation."Amount 7" := Montant1;
                                        8:
                                            RappelSituation."Amount 8" := Montant1;
                                        9:
                                            RappelSituation."Amount 9" := Montant1;
                                        10:
                                            RappelSituation."Amount 10" := Montant1;
                                        11:
                                            RappelSituation."Amount 11" := Montant1;
                                        12:
                                            RappelSituation."Amount 12" := Montant1;
                                    END;
                                    IF RappelSituation."Item Code" = ParamPaie."Net Salary" THEN BEGIN
                                        RappelSituation3.RESET;
                                        RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                        RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                        RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                        IF RappelSituation3.FINDFIRST THEN
                                            REPEAT
                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                    CASE P_Colonne OF
                                                        1:
                                                            RappelSituation."Amount 1" := RappelSituation."Amount 1" + RappelSituation3."Amount 1";//susu
                                                        2:
                                                            RappelSituation."Amount 2" := RappelSituation."Amount 2" + RappelSituation3."Amount 2";
                                                        3:
                                                            RappelSituation."Amount 3" := RappelSituation."Amount 3" + RappelSituation3."Amount 3";
                                                        4:
                                                            RappelSituation."Amount 4" := RappelSituation."Amount 4" + RappelSituation3."Amount 4";
                                                        5:
                                                            RappelSituation."Amount 5" := RappelSituation."Amount 5" + RappelSituation3."Amount 5";
                                                        6:
                                                            RappelSituation."Amount 6" := RappelSituation."Amount 6" + RappelSituation3."Amount 6";
                                                        7:
                                                            RappelSituation."Amount 7" := RappelSituation."Amount 7" + RappelSituation3."Amount 7";
                                                        8:
                                                            RappelSituation."Amount 8" := RappelSituation."Amount 8" + RappelSituation3."Amount 8";
                                                        9:
                                                            RappelSituation."Amount 9" := RappelSituation."Amount 9" + RappelSituation3."Amount 9";
                                                        10:
                                                            RappelSituation."Amount 10" := RappelSituation."Amount 10" + RappelSituation3."Amount 10";
                                                        11:
                                                            RappelSituation."Amount 11" := RappelSituation."Amount 11" + RappelSituation3."Amount 11";
                                                        12:
                                                            RappelSituation."Amount 12" := RappelSituation."Amount 12" + RappelSituation3."Amount 12";
                                                    END;
                                                END;
                                            UNTIL RappelSituation3.NEXT = 0;
                                    END;
                                    RappelSituation.MODIFY;
                                END
                                ELSE BEGIN
                                    //***Absences***
                                    IF EnteteArchivePaie.GET(P_Paie, P_Salarie) THEN BEGIN
                                        MotifAbsence.RESET;
                                        MotifAbsence.SETRANGE("Item Code", Rubrique.Code);
                                        IF MotifAbsence.FINDFIRST THEN BEGIN
                                            CASE EnteteArchivePaie.Regime OF
                                                EnteteArchivePaie.Regime::Mensuel:
                                                    BEGIN
                                                        RappelSituation2.GET(P_LotRappel, P_Salarie, ParamPaie."Base Salary");
                                                        CASE MotifAbsence."Unit of Measure Code" OF

                                                            'JOUR':
                                                                Nbre1 := ParamPaie."No. of Worked Days";
                                                            'HEURE':
                                                                Nbre1 := ParamPaie."No. of Worked Hours";
                                                        END;
                                                    END;
                                                EnteteArchivePaie.Regime::"Vacataire journalier":
                                                    RappelSituation2.GET(P_LotRappel, P_Salarie, ParamPaie."No. of Days (Daily Vacatary)");
                                            END;
                                            CASE P_Colonne OF
                                                1:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 1";
                                                        RappelSituation."Basis 1" := ROUND(RappelSituation2."Amount 1" / Nbre1);
                                                        RappelSituation."Amount 1" := -ROUND(RappelSituation."Basis 1" * RappelSituation."Number 1");
                                                    END;
                                                2:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 2";
                                                        RappelSituation."Basis 2" := ROUND(RappelSituation2."Amount 2" / Nbre1);
                                                        RappelSituation."Amount 2" := -ROUND(RappelSituation."Basis 2" * RappelSituation."Number 2");
                                                    END;
                                                3:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 3";
                                                        RappelSituation."Basis 3" := ROUND(RappelSituation2."Amount 3" / Nbre1);
                                                        RappelSituation."Amount 3" := -ROUND(RappelSituation."Basis 3" * RappelSituation."Number 3");
                                                    END;
                                                4:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 4";
                                                        RappelSituation."Basis 4" := ROUND(RappelSituation2."Amount 4" / Nbre1);
                                                        RappelSituation."Amount 4" := -ROUND(RappelSituation."Basis 4" * RappelSituation."Number 4");
                                                    END;
                                                5:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 5";
                                                        RappelSituation."Basis 5" := ROUND(RappelSituation2."Amount 5" / Nbre1);
                                                        RappelSituation."Amount 5" := -ROUND(RappelSituation."Basis 5" * RappelSituation."Number 5");
                                                    END;
                                                6:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 6";
                                                        RappelSituation."Basis 6" := ROUND(RappelSituation2."Amount 6" / Nbre1);
                                                        RappelSituation."Amount 6" := -ROUND(RappelSituation."Basis 6" * RappelSituation."Number 6");
                                                    END;
                                                7:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 7";
                                                        RappelSituation."Basis 7" := ROUND(RappelSituation2."Amount 7" / Nbre1);
                                                        RappelSituation."Amount 7" := -ROUND(RappelSituation."Basis 7" * RappelSituation."Number 7");
                                                    END;
                                                8:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 8";
                                                        RappelSituation."Basis 8" := ROUND(RappelSituation2."Amount 8" / Nbre1);
                                                        RappelSituation."Amount 8" := -ROUND(RappelSituation."Basis 8" * RappelSituation."Number 8");
                                                    END;
                                                9:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 9";
                                                        RappelSituation."Basis 9" := ROUND(RappelSituation2."Amount 9" / Nbre1);
                                                        RappelSituation."Amount 9" := -ROUND(RappelSituation."Basis 9" * RappelSituation."Number 9");
                                                    END;
                                                10:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 10";
                                                        RappelSituation."Basis 10" := ROUND(RappelSituation2."Amount 10" / Nbre1);
                                                        RappelSituation."Amount 10" := -ROUND(RappelSituation."Basis 10" * RappelSituation."Number 10");
                                                    END;
                                                11:
                                                    BEGIN //A DUPLIQUER SUR 11 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 11";
                                                        RappelSituation."Basis 11" := ROUND(RappelSituation2."Amount 11" / Nbre1);
                                                        RappelSituation."Amount 11" := -ROUND(RappelSituation."Basis 11" * RappelSituation."Number 11");
                                                    END;
                                                12:
                                                    BEGIN //A DUPLIQUER SUR 12 mois
                                                        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                                                            Nbre1 := RappelSituation2."Number 12";
                                                        RappelSituation."Basis 12" := ROUND(RappelSituation2."Amount 12" / Nbre1);
                                                        RappelSituation."Amount 12" := -ROUND(RappelSituation."Basis 12" * RappelSituation."Number 12");
                                                    END;
                                            END;
                                            RappelSituation.MODIFY;
                                        END;
                                    END;
                                    //***Heures supp.***
                                    IF STRPOS(ParamPaie."Overtime Filter", Rubrique.Code) > 0 THEN BEGIN
                                        RappelSituation2.GET(P_LotRappel, P_Salarie, ParamPaie."Base Salary");
                                        CASE P_Colonne OF
                                            1:
                                                BEGIN
                                                    RappelSituation."Basis 1" := ROUND(ROUND((RappelSituation."Payroll Basis 1"
                                                    / RappelSituation2."Payroll Amount 1" * ParamPaie."No. of Worked Hours")) * RappelSituation2."Amount 1"
                                                    / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 1" := ROUND(RappelSituation."Basis 1" * RappelSituation."Number 1");
                                                END;
                                            2:
                                                BEGIN
                                                    RappelSituation."Basis 2" := ROUND(ROUND((RappelSituation."Payroll Basis 2"
                                                    / RappelSituation2."Payroll Amount 2" * ParamPaie."No. of Worked Hours")) * RappelSituation2."Amount 2"
                                                    / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 2" := ROUND(RappelSituation."Basis 2" * RappelSituation."Number 2");
                                                END;
                                            3:
                                                BEGIN
                                                    RappelSituation."Basis 3" := ROUND(ROUND((RappelSituation."Payroll Basis 3"
                                                    / RappelSituation2."Payroll Amount 3"
                                                    * ParamPaie."No. of Worked Hours")) * RappelSituation2."Amount 3" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 3" := ROUND(RappelSituation."Basis 3" * RappelSituation."Number 3");
                                                END;
                                            4:
                                                BEGIN
                                                    RappelSituation."Basis 4" := ROUND(ROUND((RappelSituation."Payroll Basis 4"
                                                    / RappelSituation2."Payroll Amount 4"
                                                    * ParamPaie."No. of Worked Hours")) * RappelSituation2."Amount 4" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 4" := ROUND(RappelSituation."Basis 4" * RappelSituation."Number 4");
                                                END;
                                            5:
                                                BEGIN
                                                    RappelSituation."Basis 5" := ROUND(ROUND((RappelSituation."Payroll Basis 5"
                                                    / RappelSituation2."Payroll Amount 5"
                                                    * ParamPaie."No. of Worked Hours")) * RappelSituation2."Amount 5" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 5" := ROUND(RappelSituation."Basis 5" * RappelSituation."Number 5");
                                                END;
                                            6:
                                                BEGIN
                                                    RappelSituation."Basis 6" := ROUND(ROUND((RappelSituation."Payroll Basis 6"
                                                    / RappelSituation2."Payroll Amount 6"
                                                    * ParamPaie."No. of Worked Hours")) * RappelSituation2."Amount 6" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 6" := ROUND(RappelSituation."Basis 6" * RappelSituation."Number 6");
                                                END;
                                            7:
                                                BEGIN
                                                    RappelSituation."Basis 7" := ROUND(ROUND((RappelSituation."Payroll Basis 7"
                                                    / RappelSituation2."Payroll Amount 7"
                                                    * ParamPaie."No. of Worked Hours")) * RappelSituation2."Amount 7" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 7" := ROUND(RappelSituation."Basis 7" * RappelSituation."Number 7");
                                                END;
                                            8:
                                                BEGIN
                                                    RappelSituation."Basis 8" := ROUND(ROUND((RappelSituation."Payroll Basis 8"
                                                    / RappelSituation2."Payroll Amount 8"
                                                    * ParamPaie."No. of Worked Hours")) * RappelSituation2."Amount 8" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 8" := ROUND(RappelSituation."Basis 8" * RappelSituation."Number 8");
                                                END;
                                            9:
                                                BEGIN
                                                    RappelSituation."Basis 9" := ROUND(ROUND((RappelSituation."Payroll Basis 9"
                                                    / RappelSituation2."Payroll Amount 9"
                                                    * ParamPaie."No. of Worked Hours")) * RappelSituation2."Amount 9" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 9" := ROUND(RappelSituation."Basis 9" * RappelSituation."Number 9");
                                                END;
                                            10:
                                                BEGIN
                                                    RappelSituation."Basis 10" := ROUND(ROUND((RappelSituation."Payroll Basis 10"
                                                    / RappelSituation2."Payroll Amount 10" * ParamPaie."No. of Worked Hours"))
                                                    * RappelSituation2."Amount 10" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 10" := ROUND(RappelSituation."Basis 10" * RappelSituation."Number 10");
                                                END;
                                            11:
                                                BEGIN
                                                    RappelSituation."Basis 11" := ROUND(ROUND((RappelSituation."Payroll Basis 11"
                                                    / RappelSituation2."Payroll Amount 11" * ParamPaie."No. of Worked Hours"))
                                                    * RappelSituation2."Amount 11" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 11" := ROUND(RappelSituation."Basis 11" * RappelSituation."Number 11");
                                                END;
                                            12:
                                                BEGIN
                                                    RappelSituation."Basis 12" := ROUND(ROUND((RappelSituation."Payroll Basis 12"
                                                    / RappelSituation2."Payroll Amount 12" * ParamPaie."No. of Worked Hours"))
                                                    * RappelSituation2."Amount 12" / ParamPaie."No. of Worked Hours");
                                                    RappelSituation."Amount 12" := ROUND(RappelSituation."Basis 12" * RappelSituation."Number 12");
                                                END;
                                        END;
                                        RappelSituation.MODIFY;
                                    END;
                                    //***Retenue SS employé***
                                    IF Rubrique.Code = ParamPaie."Employee SS Deduction" THEN BEGIN
                                        RappelSituation2.GET(P_LotRappel, P_Salarie, ParamPaie."Post Salary");
                                        CASE P_Colonne OF
                                            1:
                                                BEGIN
                                                    RappelSituation."Basis 1" := ROUND(RappelSituation2."Amount 1");
                                                    RappelSituation."Amount 1" := -ROUND(RappelSituation."Basis 1" * RappelSituation."Rate 1" / 100);
                                                END;
                                            2:
                                                BEGIN
                                                    RappelSituation."Basis 2" := RappelSituation2."Amount 2";
                                                    RappelSituation."Amount 2" := -ROUND(RappelSituation."Basis 2" * RappelSituation."Rate 2" / 100);
                                                END;
                                            3:
                                                BEGIN
                                                    RappelSituation."Basis 3" := RappelSituation2."Amount 3";
                                                    RappelSituation."Amount 3" := -ROUND(RappelSituation."Basis 3" * RappelSituation."Rate 3" / 100);
                                                END;
                                            4:
                                                BEGIN
                                                    RappelSituation."Basis 4" := RappelSituation2."Amount 4";
                                                    RappelSituation."Amount 4" := -ROUND(RappelSituation."Basis 4" * RappelSituation."Rate 4" / 100);
                                                END;
                                            5:
                                                BEGIN
                                                    RappelSituation."Basis 5" := RappelSituation2."Amount 5";
                                                    RappelSituation."Amount 5" := -ROUND(RappelSituation."Basis 5" * RappelSituation."Rate 5" / 100);
                                                END;
                                            6:
                                                BEGIN
                                                    RappelSituation."Basis 6" := RappelSituation2."Amount 6";
                                                    RappelSituation."Amount 6" := -ROUND(RappelSituation."Basis 6" * RappelSituation."Rate 6" / 100);
                                                END;
                                            7:
                                                BEGIN
                                                    RappelSituation."Basis 7" := RappelSituation2."Amount 7";
                                                    RappelSituation."Amount 7" := -ROUND(RappelSituation."Basis 7" * RappelSituation."Rate 7" / 100);
                                                END;
                                            8:
                                                BEGIN
                                                    RappelSituation."Basis 8" := RappelSituation2."Amount 8";
                                                    RappelSituation."Amount 8" := -ROUND(RappelSituation."Basis 8" * RappelSituation."Rate 8" / 100);
                                                END;
                                            9:
                                                BEGIN
                                                    RappelSituation."Basis 9" := RappelSituation2."Amount 9";
                                                    RappelSituation."Amount 9" := -ROUND(RappelSituation."Basis 9" * RappelSituation."Rate 9" / 100);
                                                END;
                                            10:
                                                BEGIN
                                                    RappelSituation."Basis 10" := RappelSituation2."Amount 10";
                                                    RappelSituation."Amount 10" := -ROUND(RappelSituation."Basis 10" * RappelSituation."Rate 10" / 100);
                                                END;
                                            11:
                                                BEGIN
                                                    RappelSituation."Basis 11" := RappelSituation2."Amount 11";
                                                    RappelSituation."Amount 11" := -ROUND(RappelSituation."Basis 11" * RappelSituation."Rate 11" / 100);
                                                END;
                                            12:
                                                BEGIN
                                                    RappelSituation."Basis 12" := RappelSituation2."Amount 12";
                                                    RappelSituation."Amount 12" := -ROUND(RappelSituation."Basis 12" * RappelSituation."Rate 12" / 100);
                                                END;
                                        END;
                                        RappelSituation.MODIFY;
                                    END;
                                    //***Retenue IRG***
                                    IF Rubrique.Code = ParamPaie."TIT Deduction" THEN BEGIN
                                        RappelSituation2.GET(P_LotRappel, P_Salarie, ParamPaie."Taxable Salary");
                                        CASE P_Colonne OF
                                            1:
                                                BEGIN
                                                    //Calcul de la base de l'IRG
                                                    Montant1 := RappelSituation2."Amount 1";
                                                    //DEBUT - Déduction des rubriques cotisablesd non imposables
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 1" := ROUND(RappelSituation2."Amount 1" - ROUND(RappelSituation3."Amount 1"));
                                                                RappelSituation2."Basis 1" := ROUND(RappelSituation2."Amount 1");
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    //FIN - Déduction des rubriques cotisablesd non imposables
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 1" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 1" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization OR Rubrique2."TIT Out of Grid" THEN     //SOUMMAM ADD RUB 10%
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := ROUND(Montant1 - RappelSituation3."Amount 1"
                                                                    * (100 - ParamPaie."Employee SS %") / 100)
                                                                ELSE
                                                                    Montant1 := ROUND(Montant1 - RappelSituation3."Amount 1")
                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 1");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 1" := ROUND(Montant1);
                                                    RappelSituation."Amount 1" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            2:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 2";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 2" := RappelSituation2."Amount 2" - ROUND(RappelSituation3."Amount 2");
                                                                RappelSituation2."Basis 2" := RappelSituation2."Amount 2";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 2" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 2" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 2"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 2"//here
                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 2");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 2" := ROUND(Montant1);
                                                    RappelSituation."Amount 2" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            3:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 3";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 3" := RappelSituation2."Amount 3" - ROUND(RappelSituation3."Amount 3");
                                                                RappelSituation2."Basis 3" := RappelSituation2."Amount 3";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 3" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 3" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 3"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 3"//here
                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 3");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 3" := ROUND(Montant1);
                                                    RappelSituation."Amount 3" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            4:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 4";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 4" := RappelSituation2."Amount 4" - ROUND(RappelSituation3."Amount 4");
                                                                RappelSituation2."Basis 4" := RappelSituation2."Amount 4";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 4" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 4" * (100 - ParamPaie."Employee SS %") / 100);

                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 4"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 4"//here

                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 4");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 4" := ROUND(Montant1);
                                                    RappelSituation."Amount 4" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            5:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 5";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 5" := RappelSituation2."Amount 5" - ROUND(RappelSituation3."Amount 5");
                                                                RappelSituation2."Basis 5" := RappelSituation2."Amount 5";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 5" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 5" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 5"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 5"//here
                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 5");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 5" := ROUND(Montant1);
                                                    RappelSituation."Amount 5" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            6:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 6";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 6" := RappelSituation2."Amount 6" - ROUND(RappelSituation3."Amount 6");
                                                                RappelSituation2."Basis 6" := RappelSituation2."Amount 6";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 6" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 6" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 5"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 5"//here
                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 6");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 6" := ROUND(Montant1);
                                                    RappelSituation."Amount 6" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            7:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 7";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 7" := RappelSituation2."Amount 7" - ROUND(RappelSituation3."Amount 7");
                                                                RappelSituation2."Basis 7" := RappelSituation2."Amount 7";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 7" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 7" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 7"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 7"//here
                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 7");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 7" := ROUND(Montant1);
                                                    RappelSituation."Amount 7" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            8:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 8";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 8" := RappelSituation2."Amount 8" - ROUND(RappelSituation3."Amount 8");
                                                                RappelSituation2."Basis 8" := RappelSituation2."Amount 8";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 8" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 8" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 8"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 8"//here

                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 8");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 8" := ROUND(Montant1);
                                                    RappelSituation."Amount 8" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            9:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 9";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 9" := RappelSituation2."Amount 9" - ROUND(RappelSituation3."Amount 9");
                                                                RappelSituation2."Basis 9" := RappelSituation2."Amount 9";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 9" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 9" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN
                                                                IF Rubrique2.Regularization THEN //here
                                                                    IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                        Montant1 := Montant1 - RappelSituation3."Amount 9"
                                                                        * (100 - ParamPaie."Employee SS %") / 100
                                                                    ELSE
                                                                        Montant1 := Montant1 - RappelSituation3."Amount 9"//here

                                                                ELSE
                                                                    IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                        Montant1 := Montant1 - ROUND(RappelSituation3."Amount 9");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 9" := ROUND(Montant1);
                                                    RappelSituation."Amount 9" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            10:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 10";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 10" := RappelSituation2."Amount 10" - ROUND(RappelSituation3."Amount 10");
                                                                RappelSituation2."Basis 10" := RappelSituation2."Amount 10";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 10" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 10" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 10"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 10"//here

                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 10");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 10" := ROUND(Montant1);
                                                    RappelSituation."Amount 10" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            11:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 11";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 11" := RappelSituation2."Amount 11" - ROUND(RappelSituation3."Amount 11");
                                                                RappelSituation2."Basis 11" := RappelSituation2."Amount 11";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 11" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 11" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 11"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 11"//here

                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 11");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 11" := ROUND(Montant1);
                                                    RappelSituation."Amount 11" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                            12:
                                                BEGIN
                                                    Montant1 := RappelSituation2."Amount 12";
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN BEGIN
                                                                RappelSituation2."Amount 12" := RappelSituation2."Amount 12" - ROUND(RappelSituation3."Amount 12");
                                                                RappelSituation2."Basis 12" := RappelSituation2."Amount 12";
                                                                RappelSituation2.MODIFY;
                                                            END;
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '222') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 12" * (100 - ParamPaie."Employee SS %") / 100);
                                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, '221') THEN
                                                        Montant1 := ROUND(Montant1 - RappelSituation2."Payroll Amount 12" * (100 - ParamPaie."Employee SS %") / 100);
                                                    RappelSituation3.RESET;
                                                    RappelSituation3.SETRANGE("Reminder Lot No.", P_LotRappel);
                                                    RappelSituation3.SETRANGE("Employee No.", P_Salarie);
                                                    RappelSituation3.SETFILTER("Item Code", '<%1', ParamPaie."Taxable Salary");
                                                    IF RappelSituation3.FINDFIRST THEN
                                                        REPEAT
                                                            Rubrique2.GET(RappelSituation3."Item Code");
                                                            IF Rubrique2.Regularization THEN //here
                                                                IF RappelSituation3."Item Code" < ParamPaie."Post Salary" THEN
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 12"
                                                                    * (100 - ParamPaie."Employee SS %") / 100
                                                                ELSE
                                                                    Montant1 := Montant1 - RappelSituation3."Amount 12"//here
                                                            ELSE
                                                                IF STRPOS(ParamPaie."Taxable Deduction Filter", RappelSituation3."Item Code") > 0 THEN
                                                                    Montant1 := Montant1 - ROUND(RappelSituation3."Amount 12");
                                                        UNTIL RappelSituation3.NEXT = 0;
                                                    RappelSituation."Basis 12" := ROUND(Montant1);
                                                    RappelSituation."Amount 12" := ROUND(CalcIRG(P_LotRappel, P_Paie, P_Salarie, Montant1));
                                                END;
                                        END;
                                        RappelSituation.MODIFY;
                                    END;
                                END;
                            RappelSituation.Type::Pourcentage:
                                BEGIN
                                    Rubrique.TESTFIELD("Basis of Calculation");
                                    IF RappelSituation2.GET(P_LotRappel, P_Salarie, Rubrique."Basis of Calculation") THEN BEGIN
                                        CASE P_Colonne OF
                                            1:
                                                BEGIN
                                                    RappelSituation."Basis 1" := ROUND(RappelSituation2."Amount 1");
                                                    RappelSituation."Amount 1" := ROUND(RappelSituation2."Amount 1" * RappelSituation."Rate 1" / 100);
                                                END;
                                            2:
                                                BEGIN
                                                    RappelSituation."Basis 2" := RappelSituation2."Amount 2";
                                                    RappelSituation."Amount 2" := ROUND(RappelSituation2."Amount 2" * RappelSituation."Rate 2" / 100);
                                                END;
                                            3:
                                                BEGIN
                                                    RappelSituation."Basis 3" := RappelSituation2."Amount 3";
                                                    RappelSituation."Amount 3" := ROUND(RappelSituation2."Amount 3" * RappelSituation."Rate 3" / 100);
                                                END;
                                            4:
                                                BEGIN
                                                    RappelSituation."Basis 4" := RappelSituation2."Amount 4";
                                                    RappelSituation."Amount 4" := ROUND(RappelSituation2."Amount 4" * RappelSituation."Rate 4" / 100);
                                                END;
                                            5:
                                                BEGIN
                                                    RappelSituation."Basis 5" := RappelSituation2."Amount 5";
                                                    RappelSituation."Amount 5" := ROUND(RappelSituation2."Amount 5" * RappelSituation."Rate 5" / 100);
                                                END;
                                            6:
                                                BEGIN
                                                    RappelSituation."Basis 6" := RappelSituation2."Amount 6";
                                                    RappelSituation."Amount 6" := ROUND(RappelSituation2."Amount 6" * RappelSituation."Rate 6" / 100);
                                                END;
                                            7:
                                                BEGIN
                                                    RappelSituation."Basis 7" := RappelSituation2."Amount 7";
                                                    RappelSituation."Amount 7" := ROUND(RappelSituation2."Amount 7" * RappelSituation."Rate 7" / 100);
                                                END;
                                            8:
                                                BEGIN
                                                    RappelSituation."Basis 8" := RappelSituation2."Amount 8";
                                                    RappelSituation."Amount 8" := ROUND(RappelSituation2."Amount 8" * RappelSituation."Rate 8" / 100);
                                                END;
                                            9:
                                                BEGIN
                                                    RappelSituation."Basis 9" := RappelSituation2."Amount 9";
                                                    RappelSituation."Amount 9" := ROUND(RappelSituation2."Amount 9" * RappelSituation."Rate 9" / 100);
                                                END;
                                            10:
                                                BEGIN
                                                    RappelSituation."Basis 10" := RappelSituation2."Amount 10";
                                                    RappelSituation."Amount 10" := ROUND(RappelSituation2."Amount 10" * RappelSituation."Rate 10" / 100);
                                                END;
                                            11:
                                                BEGIN
                                                    RappelSituation."Basis 11" := RappelSituation2."Amount 11";
                                                    RappelSituation."Amount 11" := ROUND(RappelSituation2."Amount 11" * RappelSituation."Rate 11" / 100);
                                                END;
                                            12:
                                                BEGIN
                                                    RappelSituation."Basis 12" := RappelSituation2."Amount 12";
                                                    RappelSituation."Amount 12" := ROUND(RappelSituation2."Amount 12" * RappelSituation."Rate 12" / 100);
                                                END;
                                        END;
                                        RappelSituation.MODIFY;
                                    END;
                                END;
                        END;
                    UNTIL RappelSituation.NEXT = 0;
            END;
        UNTIL RubriquesLot.NEXT = 0;
    end;

    /// <summary>
    /// ChargerPaieArchivee.
    /// </summary>
    /// <param name="P_LotRappel">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Colonne">Integer.</param>
    /// <param name="P_NbrePaies">VAR Integer.</param>
    procedure ChargerPaieArchivee(P_LotRappel: Code[20]; P_Salarie: Code[20]; P_Paie: Code[20]; P_Colonne: Integer; var P_NbrePaies: Integer);
    begin
        //***Chargement des paies archivées***
        ParamPaie.GET;
        LigneArchivePaie.RESET;
        LigneArchivePaie.SETRANGE("Employee No.", P_Salarie);
        LigneArchivePaie.SETRANGE("Payroll Code", P_Paie);
        LigneArchivePaie.SETRANGE(Category, LigneArchivePaie.Category::Employee);
        LigneArchivePaie.SETFILTER("Item Code", '<>%1', ParamPaie."Brut Salary");
        IF LigneArchivePaie.FINDFIRST THEN
            REPEAT
                IF NOT RappelSituation.GET(P_LotRappel, P_Salarie, LigneArchivePaie."Item Code") THEN BEGIN
                    RappelSituation.INIT;
                    RappelSituation."Reminder Lot No." := P_LotRappel;
                    RappelSituation."Employee No." := P_Salarie;
                    P_NbrePaies := P_NbrePaies + 1;
                    RappelSituation."Item Code" := LigneArchivePaie."Item Code";
                    RappelSituation."Item Description" := LigneArchivePaie."Item Description";
                    Rubrique.GET(LigneArchivePaie."Item Code");
                    RappelSituation.Type := Rubrique."Item Type";
                    RappelSituation.INSERT;
                END;
                RappelSituation.GET(P_LotRappel, P_Salarie, LigneArchivePaie."Item Code");
                CASE P_Colonne OF
                    1:
                        BEGIN
                            RappelSituation."Number 1" := LigneArchivePaie.Number;
                            RappelSituation."Basis 1" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 1" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 1" := ROUND(LigneArchivePaie.Amount);
                            RappelSituation."Payroll Number 1" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 1" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 1" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 1" := ROUND(LigneArchivePaie.Amount);
                        END;
                    2:
                        BEGIN
                            RappelSituation."Number 2" := LigneArchivePaie.Number;
                            RappelSituation."Basis 2" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 2" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 2" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 2" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 2" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 2" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 2" := LigneArchivePaie.Amount;
                        END;
                    3:
                        BEGIN
                            RappelSituation."Number 3" := LigneArchivePaie.Number;
                            RappelSituation."Basis 3" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 3" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 3" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 3" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 3" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 3" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 3" := LigneArchivePaie.Amount;
                        END;
                    4:
                        BEGIN
                            RappelSituation."Number 4" := LigneArchivePaie.Number;
                            RappelSituation."Basis 4" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 4" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 4" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 4" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 4" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 4" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 4" := LigneArchivePaie.Amount;
                        END;
                    5:
                        BEGIN
                            RappelSituation."Number 5" := LigneArchivePaie.Number;
                            RappelSituation."Basis 5" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 5" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 5" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 5" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 5" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 5" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 5" := LigneArchivePaie.Amount;
                        END;
                    6:
                        BEGIN
                            RappelSituation."Number 6" := LigneArchivePaie.Number;
                            RappelSituation."Basis 6" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 6" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 6" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 6" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 6" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 6" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 6" := LigneArchivePaie.Amount;
                        END;
                    7:
                        BEGIN
                            RappelSituation."Number 7" := LigneArchivePaie.Number;
                            RappelSituation."Basis 7" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 7" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 7" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 7" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 7" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 7" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 7" := LigneArchivePaie.Amount;
                        END;
                    8:
                        BEGIN
                            RappelSituation."Number 8" := LigneArchivePaie.Number;
                            RappelSituation."Basis 8" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 8" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 8" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 8" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 8" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 8" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 8" := LigneArchivePaie.Amount;
                        END;
                    9:
                        BEGIN
                            RappelSituation."Number 9" := LigneArchivePaie.Number;
                            RappelSituation."Basis 9" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 9" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 9" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 9" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 9" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 9" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 9" := LigneArchivePaie.Amount;
                        END;
                    10:
                        BEGIN
                            RappelSituation."Number 10" := LigneArchivePaie.Number;
                            RappelSituation."Basis 10" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 10" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 10" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 10" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 10" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 10" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 10" := LigneArchivePaie.Amount;
                        END;
                    11:
                        BEGIN
                            RappelSituation."Number 11" := LigneArchivePaie.Number;
                            RappelSituation."Basis 11" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 11" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 11" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 11" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 11" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 11" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 11" := LigneArchivePaie.Amount;
                        END;
                    12:
                        BEGIN
                            RappelSituation."Number 12" := LigneArchivePaie.Number;
                            RappelSituation."Basis 12" := LigneArchivePaie.Basis;
                            RappelSituation."Rate 12" := LigneArchivePaie.Rate;
                            RappelSituation."Amount 12" := LigneArchivePaie.Amount;
                            RappelSituation."Payroll Number 12" := LigneArchivePaie.Number;
                            RappelSituation."Payroll Basis 12" := LigneArchivePaie.Basis;
                            RappelSituation."Payroll Rate 12" := LigneArchivePaie.Rate;
                            RappelSituation."Payroll Amount 12" := LigneArchivePaie.Amount;
                        END;
                END;
                RappelSituation.MODIFY;
            UNTIL LigneArchivePaie.NEXT = 0;
    end;

    /// <summary>
    /// SupprimerRappel.
    /// </summary>
    /// <param name="P_Rappel">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    procedure SupprimerRappel(P_Rappel: Code[20]; P_Salarie: Code[20]);
    begin
        Paie.GET(P_Rappel);
        IF Paie.Closed THEN
            ERROR(Text04, 'le rappel', P_Rappel);
        HistTransactRappel.RESET;
        HistTransactRappel.SETRANGE("Payroll Code", P_Rappel);
        HistTransactRappel.SETRANGE("Employee No.", P_Salarie);
        HistTransactRappel.FINDFIRST;
        IF CONFIRM(Text01, FALSE, 'le rappel', P_Rappel, P_Salarie) THEN BEGIN
            LigneArchivePaie.RESET;
            LigneArchivePaie.SETRANGE("Payroll Code", P_Rappel);
            LigneArchivePaie.SETRANGE("Employee No.", P_Salarie);
            LigneArchivePaie.DELETEALL;
            EnteteArchivePaie.RESET;
            EnteteArchivePaie.SETRANGE("Payroll Code", P_Rappel);
            EnteteArchivePaie.SETRANGE("No.", P_Salarie);
            EnteteArchivePaie.DELETEALL;
            EcriturePaie.RESET;
            EcriturePaie.SETFILTER("Entry No.", '%1..%2', HistTransactRappel."From Entry No.", HistTransactRappel."To Entry No.");
            EcriturePaie.DELETEALL;
            /*
            AnalEcritureCompta.RESET;
            AnalEcritureCompta.SETRANGE("Table ID",DATABASE::"Payroll Entry");
            AnalEcritureCompta.SETFILTER("Entry No.",'%1..%2',HistTransactRappel."From Entry No.",HistTransactRappel."To Entry No.");
            AnalEcritureCompta.DELETEALL;
            HistTransactRappel.DELETE;*/
        END;

    end;

    /// <summary>
    /// CalcIRG.
    /// </summary>
    /// <param name="P_LotRappel">Code[20].</param>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <param name="P_BaseImposable">Decimal.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcIRG(P_LotRappel: Code[20]; P_Paie: Code[20]; P_Salarie: Code[20]; P_BaseImposable: Decimal): Decimal;
    begin
        ParamPaie.GET;
        Montant1 := 0;
        //***Calcul de l'IRG***
        IF EnteteArchivePaie.GET(P_Paie, P_Salarie) THEN BEGIN
            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                BaseIRG := P_BaseImposable * ParamPaie."No. of Worked Days" / NbreJoursPresence(P_Paie, P_Salarie);
            IF (ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index") THEN
                BaseIRG := P_BaseImposable * ParamPaie."No. of Worked Hours" / NbreHeuresPresence(P_Paie, P_Salarie);
            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire horaire" THEN BEGIN
                RappelSituation2.GET(P_LotRappel, P_Salarie, ParamPaie."No. of Hours (Hourly Vacatary)");
                NbreHeuresVacataire := NbreHeuresPresence(P_Paie, P_Salarie);
                BaseIRG := P_BaseImposable / NbreHeuresVacataire * ParamPaie."No. of Worked Hours";
            END;
            IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN BEGIN
                RappelSituation2.GET(P_LotRappel, P_Salarie, ParamPaie."No. of Days (Daily Vacatary)");
                NbreJoursVacataire := NbreJoursPresence(P_Paie, P_Salarie);
                BaseIRG := P_BaseImposable / NbreJoursVacataire * ParamPaie."No. of Worked Days";
            END;
            BaseIRG := BaseIRG DIV 10 * 10;
            Rubrique.GET(ParamPaie."TIT Deduction");
            BaremeIRG.RESET;
            BaremeIRG.SETRANGE(BaremeIRG.Basis, BaseIRG);
            IF BaremeIRG.FINDFIRST THEN BEGIN
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                    Montant1 := BaremeIRG.TIT * NbreJoursPresence(P_Paie, P_Salarie) / ParamPaie."No. of Worked Days";
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                    Montant1 := BaremeIRG.TIT * (NbreHeuresPresence(P_Paie, P_Salarie) / ParamPaie."No. of Worked Hours");
                IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire horaire" THEN
                    Montant1 := BaremeIRG.TIT * (NbreHeuresVacataire / ParamPaie."No. of Worked Hours");
                IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN
                    Montant1 := BaremeIRG.TIT * (NbreJoursVacataire / ParamPaie."No. of Worked Days");
            END
            ELSE
                Montant1 := 0;
        END;
        EXIT(-Montant1);
    end;

    /// <summary>
    /// NbreHeuresPresence.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure NbreHeuresPresence(P_Paie: Code[20]; P_Salarie: Code[20]): Decimal;
    var
        NbreJoursTravailles: Decimal;
        L_Valeur: Decimal;
        L_LigneArchive: Record "Payroll Archive Line";
    begin
        ParamPaie.GET;
        EnteteArchivePaie.GET(P_Paie, P_Salarie);
        Nbre1 := EnteteArchivePaie."Total Absences Days" * ParamPaie."No. of Hours By Day" + EnteteArchivePaie."Total Absences Hours";
        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire horaire" THEN BEGIN
            L_LigneArchive.GET(P_Salarie, P_Paie, ParamPaie."No. of Hours (Hourly Vacatary)");
            L_Valeur := L_LigneArchive.Number;
        END
        ELSE
            L_Valeur := ParamPaie."No. of Worked Hours";
        EXIT(ROUND(L_Valeur - Nbre1));
    end;

    /// <summary>
    /// NbreJoursPresence.
    /// </summary>
    /// <param name="P_Paie">Code[20].</param>
    /// <param name="P_Salarie">Code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure NbreJoursPresence(P_Paie: Code[20]; P_Salarie: Code[20]): Decimal;
    var
        NbreJoursAbsence: Decimal;
        L_LigneArchive: Record "Payroll Archive Line";
        L_Valeur: Decimal;
    begin
        ParamPaie.GET;
        EnteteArchivePaie.GET(P_Paie, P_Salarie);
        Nbre1 := EnteteArchivePaie."Total Absences Days" + EnteteArchivePaie."Total Absences Hours" / ParamPaie."No. of Hours By Day";
        IF EnteteArchivePaie.Regime = EnteteArchivePaie.Regime::"Vacataire journalier" THEN BEGIN
            L_LigneArchive.GET(P_Salarie, P_Paie, ParamPaie."No. of Days (Daily Vacatary)");
            L_Valeur := L_LigneArchive.Number;
        END
        ELSE
            L_Valeur := ParamPaie."No. of Worked Days";
        EXIT(ROUND(L_Valeur - Nbre1));
    end;

    /// <summary>
    /// CalcDifferences.
    /// </summary>
    /// <param name="P_LotRappel">Code[20].</param>
    procedure CalcDifferences(P_LotRappel: Code[20]);
    var
        L_RubriqueSalarie: Record "Payroll Archive Line";
        L_Valeur: Decimal;
    begin
        RappelSituation.RESET;
        RappelSituation.SETRANGE("Reminder Lot No.", P_LotRappel);
        IF RappelSituation.FINDFIRST THEN
            REPEAT
                RappelSituation."Reminder Amount 1" := ROUND(RappelSituation."Amount 1" - RappelSituation."Payroll Amount 1");
                RappelSituation."Reminder Amount 2" := ROUND(RappelSituation."Amount 2" - RappelSituation."Payroll Amount 2");
                RappelSituation."Reminder Amount 3" := ROUND(RappelSituation."Amount 3" - RappelSituation."Payroll Amount 3");
                RappelSituation."Reminder Amount 4" := ROUND(RappelSituation."Amount 4" - RappelSituation."Payroll Amount 4");
                RappelSituation."Reminder Amount 5" := ROUND(RappelSituation."Amount 5" - RappelSituation."Payroll Amount 5");
                RappelSituation."Reminder Amount 6" := ROUND(RappelSituation."Amount 6" - RappelSituation."Payroll Amount 6");
                RappelSituation."Reminder Amount 7" := ROUND(RappelSituation."Amount 7" - RappelSituation."Payroll Amount 7");
                RappelSituation."Reminder Amount 8" := ROUND(RappelSituation."Amount 8" - RappelSituation."Payroll Amount 8");
                RappelSituation."Reminder Amount 9" := ROUND(RappelSituation."Amount 9" - RappelSituation."Payroll Amount 9");
                RappelSituation."Reminder Amount 10" := ROUND(RappelSituation."Amount 10" - RappelSituation."Payroll Amount 10");
                RappelSituation."Reminder Amount 11" := ROUND(RappelSituation."Amount 11" - RappelSituation."Payroll Amount 11");
                RappelSituation."Reminder Amount 12" := ROUND(RappelSituation."Amount 12" - RappelSituation."Payroll Amount 12");
                RappelSituation."Total Reminder" := RappelSituation."Reminder Amount 1" + RappelSituation."Reminder Amount 2"
                + RappelSituation."Reminder Amount 3" + RappelSituation."Reminder Amount 4"
                + RappelSituation."Reminder Amount 5" + RappelSituation."Reminder Amount 6"
                + RappelSituation."Reminder Amount 7" + RappelSituation."Reminder Amount 8"
                + RappelSituation."Reminder Amount 9" + RappelSituation."Reminder Amount 10"
                + RappelSituation."Reminder Amount 11" + RappelSituation."Reminder Amount 12";
                RappelSituation.MODIFY;
                IF NOT TotalisationLot.GET(P_LotRappel, RappelSituation."Item Code") THEN BEGIN
                    TotalisationLot.INIT;
                    TotalisationLot."Reminder Lot No." := P_LotRappel;
                    TotalisationLot."Item Code" := RappelSituation."Item Code";
                    TotalisationLot."Item Description" := RappelSituation."Item Description";
                    TotalisationLot.INSERT;
                END;
            UNTIL RappelSituation.NEXT = 0;
    end;
}

