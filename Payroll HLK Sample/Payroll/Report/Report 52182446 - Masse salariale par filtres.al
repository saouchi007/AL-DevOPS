/// <summary>
/// Report Masse salariale par filtres (ID 52182446).
/// </summary>
report 52182446 "Masse salariale par filtres"
{
    // version HALRHPAIE.6.2.01

    // // Cacobapth
    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Masse salariale par filtres.rdl';


    dataset
    {
        dataitem(DataItem4380; Structure)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem6914; "Socio-professional Category")
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem2362; Function)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem6578; "Masse salariale")
        {
            DataItemTableView = SORTING(CodeStructure, Categorie);
            column(InclureCacobapth; ParamPaie."Inclure Cacobatph")
            {
            }
            column(Annee; Annee)
            {
            }
            column(NomMoisDebut; NomMoisDebut)
            {
            }
            column(NomMoisFin; NomMoisFin)
            {
            }
            column(CompanyInformation_Picture; InfoSociete."Right Logo")
            {
                AutoCalcField = true;
            }
            column(UniteSociete_Name; UniteSociete.Name)
            {
            }
            column(UniteSociete_Address; UniteSociete.Address)
            {
            }
            column(UniteSociete__Post_Code_; UniteSociete."Post Code")
            {
            }
            column(UniteSociete_City; UniteSociete.City)
            {
            }
            column(UniteSociete__Employer_SS_No__; UniteSociete."Employer SS No.")
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FiltreStructure; FiltreStructure)
            {
            }
            column(FiltreCategorie; FiltreCategorie)
            {
            }
            column(FiltreFonction; FiltreFonction)
            {
            }
            column(Masse_salariale_DesignationStructure; DesignationStructure)
            {
            }
            column(Masse_salariale__Masse_salariale__Categorie; DataItem6578.Categorie)
            {
            }
            column(Masse_salariale_NbreSalaries; NbreSalaries)
            {
            }
            column(Masse_salariale_SalaireBase; SalaireBase)
            {
            }
            column(Masse_salariale_Cotisable; Cotisable)
            {
            }
            column(Masse_salariale_Imposable; Imposable)
            {
            }
            column(Masse_salariale_NonImposable; NonImposable)
            {
            }
            column(Masse_salariale_FraisPersonnel; FraisPersonnel)
            {
            }
            column(Masse_salariale_ChargesSociales; ChargesSociales)
            {
            }
            column(Masse_salariale_ChargesFiscales; ChargesFiscales)
            {
            }
            column(Masse_salariale_TotalMasseSalariale; TotalMasseSalariale)
            {
            }
            column(Masse_salariale_AutresCharges; AutresCharges)
            {
            }
            column(TotalNbre; TotalNbre)
            {
            }
            column(TotalSalaireBase; TotalSalaireBase)
            {
            }
            column(TotalCotisable; TotalCotisable)
            {
            }
            column(TotalImposable; TotalImposable)
            {
            }
            column(TotalNonImposable; TotalNonImposable)
            {
            }
            column(TotalFraisPersonnel; TotalFraisPersonnel)
            {
            }
            column(TotalChargesFinancieres; TotalChargesFinancieres)
            {
            }
            column(TotaldeMasseSalariale; TotaldeMasseSalariale)
            {
            }
            column(TotalAutresCharges; TotalAutresCharges)
            {
            }
            column(TotalChargesSociales; TotalChargesSociales)
            {
            }
            column(AffectationCaption; AffectationCaptionLbl)
            {
            }
            column(GroupeCaption; GroupeCaptionLbl)
            {
            }
            column(NbreCaption; NbreCaptionLbl)
            {
            }
            column(Salaire_de_BaseCaption; Salaire_de_BaseCaptionLbl)
            {
            }
            column(CotisablesCaption; CotisablesCaptionLbl)
            {
            }
            column(ImposablesCaption; ImposablesCaptionLbl)
            {
            }
            column(N_ImposableCaption; N_ImposableCaptionLbl)
            {
            }
            column(Total_frais_personnelCaption; Total_frais_personnelCaptionLbl)
            {
            }
            column(Charges_SocialesCaption; Charges_SocialesCaptionLbl)
            {
            }
            column(Charges_FiscalesCaption; Charges_FiscalesCaptionLbl)
            {
            }
            column(Total_Masse_SalarialeCaption; Total_Masse_SalarialeCaptionLbl)
            {
            }
            column(PRIMES_ET_INDEMNITESCaption; PRIMES_ET_INDEMNITESCaptionLbl)
            {
            }
            column(MASSE_SALARIALE_PAR_GROUPE_FONCTIONSCaption; MASSE_SALARIALE_PAR_GROUPE_FONCTIONSCaptionLbl)
            {
            }
            column("Mois_début__Caption"; Mois_début__CaptionLbl)
            {
            }
            column(Mois_fin__Caption; Mois_fin__CaptionLbl)
            {
            }
            column(Exercice__Caption; Exercice__CaptionLbl)
            {
            }
            column(N__EmployeurCaption; N__EmployeurCaptionLbl)
            {
            }
            column(Page_N__Caption; Page_N__CaptionLbl)
            {
            }
            column(Structure__Caption; Structure__CaptionLbl)
            {
            }
            column("Catégorie__Caption"; Catégorie__CaptionLbl)
            {
            }
            column(Fonction__Caption; Fonction__CaptionLbl)
            {
            }
            column("Retenue_Sécu__socialeCaption"; Retenue_Sécu__socialeCaptionLbl)
            {
            }
            column(TOTAL_GENERAL_Caption; TOTAL_GENERAL_CaptionLbl)
            {
            }
            column(Masse_salariale_CodeStructure; CodeStructure)
            {
            }
            column(FraisPersonnel; DataItem6578.FraisPersonnel)
            {
            }
            column(IndemniteNonCotisabeEtImposable; IndemniteNonCotisabeEtImposable)
            {
            }
            column(TotalCotisationCacobatph; TotalCotisationCacobatph)
            {
            }
            column(TotalCotisationPretbatph; TotalCotisationPretbatph)
            {
            }
            column(Masse_salariale_Cacobatph; DataItem6578.Cacobatph)
            {
            }
            column(Masse_salariale_Pretbath; DataItem6578.Pretbath)
            {
            }
            column(NonImposableNonCotisable; DataItem6578."Non Imposable Non cotisable")
            {
            }
            column(ImposableNonCotisable; DataItem6578."Imposable Non Cotisable")
            {
            }

            trigger OnAfterGetRecord();
            begin
                TotalNbre := TotalNbre + DataItem6578.NbreSalaries;
                TotalSalaireBase := TotalSalaireBase + DataItem6578.SalaireBase;
                TotalCotisable := TotalCotisable + DataItem6578.Cotisable;
                //TotalImposable:=TotalImposable+DataItem6578.Imposable;
                //TotalNonImposable:=TotalNonImposable+DataItem6578.NonImposable;
                //TotalFraisPersonnel:=TotalFraisPersonnel+DataItem6578.FraisPersonnel;
                TotalChargesSociales := TotalChargesSociales + DataItem6578.ChargesSociales;
                //TotalChargesFinancieres:=TotalChargesFinancieres+DataItem6578.ChargesFiscales;
                //TotalAutresCharges:=TotalAutresCharges+DataItem6578.AutresCharges;
                TotaldeMasseSalariale := TotaldeMasseSalariale + DataItem6578.TotalMasseSalariale;
                // Cacobapth
                TotalCotisationCacobatph := TotalCotisationCacobatph + DataItem6578.Cacobatph;
                TotalCotisationPretbatph := TotalCotisationPretbatph + DataItem6578.Pretbath;
                TotalImposableNonCotisable := TotalImposableNonCotisable + DataItem6578."Imposable Non Cotisable";
                TotalNonImposableNonCotisable := TotalNonImposableNonCotisable + DataItem6578."Non Imposable Non cotisable";
                //
            end;

            trigger OnPreDataItem();
            begin
                IF MoisDebut = 0 THEN
                    ERROR(Text01, 'Mois début');
                IF MoisFin = 0 THEN
                    ERROR(Text01, 'Mois fin');
                IF Annee = 0 THEN
                    ERROR(Text01, 'Année');
                IF (MoisDebut < 1) OR (MoisDebut > 12) THEN
                    ERROR(Text02, 'Mois début');
                IF (MoisFin < 1) OR (MoisFin > 12) THEN
                    ERROR(Text02, 'Mois fin');
                IF (Annee < 2000) OR (Annee > 2100) THEN
                    ERROR(Text02, 'Année');
                IF MoisDebut > MoisFin THEN
                    ERROR(Text03);
                FiltreStructure := DataItem4380.GETFILTERS;
                FiltreCategorie := DataItem6914.GETFILTERS;
                FiltreFonction := DataItem2362.GETFILTERS;
                MasseSalariale.Traitement(MoisDebut, MoisFin, Annee, Unite, FiltreStructure, FiltreCategorie, FiltreFonction);
                IF FiltreStructure = '' THEN
                    FiltreStructure := 'Toutes';
                IF FiltreCategorie = '' THEN
                    FiltreCategorie := 'Toutes';
                IF FiltreFonction = '' THEN
                    FiltreFonction := 'Toutes';
                NomMoisDebut := NomMois(MoisDebut);
                NomMoisFin := NomMois(MoisFin);
                TotalNbre := 0;
                TotalSalaireBase := 0;
                TotalCotisable := 0;
                TotalImposable := 0;
                TotalNonImposable := 0;
                TotalFraisPersonnel := 0;
                TotalChargesSociales := 0;
                TotalChargesFinancieres := 0;
                TotalAutresCharges := 0;
                TotalMasseSalariale := 0;
                // Cacobapth
                TotalCotisationCacobatph := 0;
                TotalCotisationPretbatph := 0;
                TotalImposableNonCotisable := 0;
                TotalNonImposableNonCotisable := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(MoisDebut; MoisDebut)
                    {
                        Caption = 'Mois Début';
                    }
                    field(MoisFin; MoisFin)
                    {
                        Caption = 'Mois Fin';
                    }
                    field(Annee; Annee)
                    {
                        Caption = 'Année';
                    }
                    field(Unite; Unite)
                    {
                        Caption = 'Code Direction';
                    }
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
        ParamPaie.GET;

        MoisDebut := DATE2DMY(TODAY, 2);
        MoisFin := DATE2DMY(TODAY, 2);
        Annee := DATE2DMY(TODAY, 3);
        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(Text05, USERID);
        Unite := GestionnairePaie."Company Business Unit Code";
        IF Unite = '' THEN
            ERROR(Text04, USERID);
        UniteSociete.GET(Unite);
        InfoSociete.GET;
        InfoSociete.SETAUTOCALCFIELDS(InfoSociete."Right Logo");
        MoisDebut := 9;
        MoisFin := 9;
    end;

    var
        MasseSalariale: Codeunit "Masse salariale";
        MoisDebut: Integer;
        MoisFin: Integer;
        Annee: Integer;
        Annee1: Date;
        Annee2: Date;
        NomMoisDebut: Text[30];
        NomMoisFin: Text[30];
        TotalNbre: Integer;
        TotalSalaireBase: Decimal;
        TotalCotisable: Decimal;
        TotalImposable: Decimal;
        TotalNonImposable: Decimal;
        TotalFraisPersonnel: Decimal;
        TotalChargesSociales: Decimal;
        TotalChargesFinancieres: Decimal;
        TotalAutresCharges: Decimal;
        TotaldeMasseSalariale: Decimal;
        GestionnairePaie: Record "Payroll Manager";
        InfoSociete: Record 79;
        Unite: Code[10];
        Text01: Label 'Information manquante ! %1';
        Text02: Label 'Information incorrecte ! %1';
        Text03: Label 'Mois début doit être antérieur au mois fin !';
        Text04: Label 'Unité non configurée dans la table des gestionnaires de paie pour l''utilisateur %1 !';
        Text05: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        UniteSociete: Record "Company Business Unit";
        FiltreStructure: Text[200];
        FiltreCategorie: Text[200];
        FiltreFonction: Text[200];
        AffectationCaptionLbl: Label 'Affectation';
        GroupeCaptionLbl: Label 'Groupe';
        NbreCaptionLbl: Label 'Nbre';
        Salaire_de_BaseCaptionLbl: Label 'Salaire de Base';
        CotisablesCaptionLbl: Label 'Cotisables';
        ImposablesCaptionLbl: Label 'Imposables';
        N_ImposableCaptionLbl: Label 'N.Imposable';
        Total_frais_personnelCaptionLbl: Label 'Total frais personnel';
        Charges_SocialesCaptionLbl: Label 'Charges Sociales';
        Charges_FiscalesCaptionLbl: Label 'Charges Fiscales';
        Total_Masse_SalarialeCaptionLbl: Label 'Total Masse Salariale';
        PRIMES_ET_INDEMNITESCaptionLbl: Label 'PRIMES ET INDEMNITES';
        MASSE_SALARIALE_PAR_GROUPE_FONCTIONSCaptionLbl: Label 'MASSE SALARIALE PAR GROUPE FONCTIONS';
        "Mois_début__CaptionLbl": Label 'Mois début :';
        Mois_fin__CaptionLbl: Label 'Mois fin :';
        Exercice__CaptionLbl: Label 'Exercice :';
        N__EmployeurCaptionLbl: Label 'N° Employeur';
        Page_N__CaptionLbl: Label '"Page N° "';
        Structure__CaptionLbl: Label 'Structure :';
        "Catégorie__CaptionLbl": Label 'Catégorie :';
        Fonction__CaptionLbl: Label 'Fonction :';
        "Retenue_Sécu__socialeCaptionLbl": Label 'Retenue Sécu. sociale';
        TOTAL_GENERAL_CaptionLbl: Label '"TOTAL GENERAL "';
        IndemniteNonCotisabeEtImposable: Decimal;
        TotalCotisationCacobatph: Decimal;
        TotalCotisationPretbatph: Decimal;
        ParamPaie: Record Payroll_Setup;

        TotalImposableNonCotisable: Decimal;
        TotalNonImposableNonCotisable: Decimal;

    /// <summary>
    /// NomMois.
    /// </summary>
    /// <param name="NumMois">Integer.</param>
    /// <returns>Return value of type Text[30].</returns>
    procedure NomMois(NumMois: Integer): Text[30];
    begin
        CASE NumMois OF
            1:
                EXIT('Janvier');
            2:
                EXIT('Février');
            3:
                EXIT('Mars');
            4:
                EXIT('Avril');
            5:
                EXIT('Mai');
            6:
                EXIT('Juin');
            7:
                EXIT('Juillet');
            8:
                EXIT('Août');
            9:
                EXIT('Septembre');
            10:
                EXIT('Octobre');
            11:
                EXIT('Novembre');
            12:
                EXIT('Décembre');
        END;
    end;
}

