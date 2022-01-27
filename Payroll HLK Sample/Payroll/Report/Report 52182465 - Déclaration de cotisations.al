/// <summary>
/// Report Déclaration de cotisations (ID 51496).
/// </summary>
report 52182465 "Déclaration de cotisations"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Déclaration de cotisations.rdl';

    dataset
    {
        dataitem(DataItem6582; "Déclaration de cotisations")
        {
            DataItemTableView = SORTING(Code);
            column(Unite__Agence_CNAS_; Unite."Agence CNAS")
            {
            }
            column(InfosSociete_Name; InfosSociete.Name)
            {
            }
            column(Unite__Employer_SS_No__; Unite."Employer SS No.")
            {
            }
            column(Periode; Periode)
            {
            }
            column(Titre; Titre)
            {
            }
            column(Unite__N__CCP_CNAS_; Unite."N° CCP CNAS")
            {
            }
            column("Unite__N__Tél__CNAS_"; Unite."N° Tél. CNAS")
            {
            }
            column("Unite__N__Cpte_Trésor_CNAS_"; Unite."N° Cpte Trésor CNAS")
            {
            }
            column(Unite__Adresse_CNAS_; Unite."Adresse CNAS")
            {
            }
            column(Unite__Ville_CNAS_; Unite."Ville CNAS")
            {
            }
            column(Unite__Code_Agence_CNAS_; Unite."Code Agence CNAS")
            {
            }
            column(InfosSociete_Activity; InfosSociete.Activity)
            {
            }
            column(InfosSociete_City; InfosSociete.City)
            {
            }
            column(InfosSociete_Address; InfosSociete.Address)
            {
            }
            column(InfosSociete__Address_2_; InfosSociete."Address 2")
            {
            }
            column(InfosSociete__Post_Code_; InfosSociete."Post Code")
            {
            }
            column("Déclaration_de_cotisations_Code"; Code)
            {
            }
            column("Déclaration_de_cotisations_Description"; Description)
            {
            }
            column("Déclaration_de_cotisations_Assiette"; Assiette)
            {
            }
            column("Déclaration_de_cotisations_Taux"; Taux)
            {
            }
            column("Déclaration_de_cotisations_Montant"; Montant)
            {
            }
            column("Déclaration_de_cotisations_Entrée"; Entrée)
            {
            }
            column("Déclaration_de_cotisations_Sortie"; Sortie)
            {
            }
            column("Déclaration_de_cotisations_Effectif"; Effectif)
            {
            }
            column(TotalCotisations; TotalCotisations)
            {
            }
            column(Periode_Control1000000059; Periode)
            {
            }
            column(TotalCotisations_Control1000000067; TotalCotisations)
            {
            }
            column(DescriptionLine_1_; DescriptionLine[1])
            {
            }
            column(DescriptionLine_2_; DescriptionLine[2])
            {
            }
            column(Unite__Employer_SS_No___Control1000000062; Unite."Employer SS No.")
            {
            }
            column(InfosSociete_Name_Control1000000073; InfosSociete.Name)
            {
            }
            column(InfosSociete_Address_Control1000000074; InfosSociete.Address)
            {
            }
            column(InfosSociete__Address_2__Control1000000075; InfosSociete."Address 2")
            {
            }
            column(InfosSociete_City_Control1000000076; InfosSociete.City)
            {
            }
            column(InfosSociete__Post_Code__Control1000000077; InfosSociete."Post Code")
            {
            }
            column(BasDocument; BasDocument)
            {
            }
            column(SECURITE_SOCIALECaption; SECURITE_SOCIALECaptionLbl)
            {
            }
            column(CODECaption; CODECaptionLbl)
            {
            }
            column(NATURE_DES_COTISATIONSCaption; NATURE_DES_COTISATIONSCaptionLbl)
            {
            }
            column(ASSIETTECaption; ASSIETTECaptionLbl)
            {
            }
            column(TAUXCaption; TAUXCaptionLbl)
            {
            }
            column(MONTANTCaption; MONTANTCaptionLbl)
            {
            }
            column(DECOMPTE_DES_COTISATIONSCaption; DECOMPTE_DES_COTISATIONSCaptionLbl)
            {
            }
            column("Déclaration_de_cotisations_EntréeCaption"; FIELDCAPTION(Entrée))
            {
            }
            column("Déclaration_de_cotisations_SortieCaption"; FIELDCAPTION(Sortie))
            {
            }
            column(EFFECTIF_TOTAL_EN_EXERCICECaption; EFFECTIF_TOTAL_EN_EXERCICECaptionLbl)
            {
            }
            column(MOUVEMENT_DU_PERSONNELCaption; MOUVEMENT_DU_PERSONNELCaptionLbl)
            {
            }
            column(CNASCaption; CNASCaptionLbl)
            {
            }
            column(Agence__Caption; Agence__CaptionLbl)
            {
            }
            column(N__CCP__Caption; N__CCP__CaptionLbl)
            {
            }
            column("N__Cpte_Trésor__Caption"; N__Cpte_Trésor__CaptionLbl)
            {
            }
            column("N__Tél___Caption"; N__Tél___CaptionLbl)
            {
            }
            column(Code_AgenceCaption; Code_AgenceCaptionLbl)
            {
            }
            column("Date_RéceptionCaption"; Date_RéceptionCaptionLbl)
            {
            }
            column("Période_CotisationCaption"; Période_CotisationCaptionLbl)
            {
            }
            column("Numéro_CotisantCaption"; Numéro_CotisantCaptionLbl)
            {
            }
            column(Classe_de_CotisantCaption; Classe_de_CotisantCaptionLbl)
            {
            }
            column(DESTINATAIRECaption; DESTINATAIRECaptionLbl)
            {
            }
            column(TOTAL_DES_COTISATIONSCaption; TOTAL_DES_COTISATIONSCaptionLbl)
            {
            }
            column(PERIODECaption; PERIODECaptionLbl)
            {
            }
            column(CANALCaption; CANALCaptionLbl)
            {
            }
            column(JOURNEECaption; JOURNEECaptionLbl)
            {
            }
            column("Montant_versé_à_déduireCaption"; Montant_versé_à_déduireCaptionLbl)
            {
            }
            column(Montant_du_versementCaption; Montant_du_versementCaptionLbl)
            {
            }
            column(DACaption; DACaptionLbl)
            {
            }
            column(Montant_en_lettres__Caption; Montant_en_lettres__CaptionLbl)
            {
            }
            column(IDENTIFICATION_COTISANTCaption; IDENTIFICATION_COTISANTCaptionLbl)
            {
            }
            column("Règlement_par__Caption"; Règlement_par__CaptionLbl)
            {
            }
            column("Chèque_bancaire_n___Caption"; Chèque_bancaire_n___CaptionLbl)
            {
            }
            column("Chèque_postal_n___Caption"; Chèque_postal_n___CaptionLbl)
            {
            }
            column("Caisse_reçu_n___Caption"; Caisse_reçu_n___CaptionLbl)
            {
            }
            column(Cachet_et_signature_du_cotisantCaption; Cachet_et_signature_du_cotisantCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000116; EmptyStringCaption_Control1000000116Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000117; EmptyStringCaption_Control1000000117Lbl)
            {
            }
            column(BORDEREAU_DE_VERSEMENT_DES_COTISATIONSCaption; BORDEREAU_DE_VERSEMENT_DES_COTISATIONSCaptionLbl)
            {
            }
            column(Entree; DataItem6582.Entrée)
            {
            }
            column(Sortie; DataItem6582.Sortie)
            {
            }

            trigger OnAfterGetRecord();
            begin
                BasDocument := 'Certifié exact à ' + InfosSociete.City + ' ' + 'Le: ' + FORMAT(DateEdition);

                /// --- 000


                CLEAR(DescriptionLine);
                CheckReport.InitTextVariable;
                CheckReport.FormatNoTextFR(DescriptionLine, ROUND(TotalCotisations), '');
                /// +++ 000
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(Mois; Mois)
                    {
                        Caption = 'Mois';
                    }
                    field(Annee; Annee)
                    {
                        Caption = 'Année';
                    }
                    field(DateEdition; DateEdition)
                    {
                        Caption = 'Date d''édition';
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
        IF NOT GestionnairePaie.GET(USERID) THEN
            ERROR(Text01);
        CodeUnite := GestionnairePaie."Company Business Unit Code";
        IF CodeUnite = '' THEN
            Unite.FINDFIRST
        ELSE
            Unite.GET(CodeUnite);
        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);
        Mois := DATE2DMY(TODAY, 2);
        Annee := DATE2DMY(TODAY, 3);
        DateEdition := TODAY;
        InfosSociete.GET;
    end;

    trigger OnPreReport();
    begin
        ParamPaie.GET;
        IF Mois = 0 THEN
            ERROR(Text03, 'Mois');
        IF Annee = 0 THEN
            ERROR(Text03, 'Année');
        IF (Mois < 1) OR (Mois > 12) THEN
            ERROR('Mois incorect !');
        IF (Annee < 1900) OR (Annee > 2100) THEN
            ERROR('Année incorecte !');
        Periode := Outils.Format_Text(FORMAT(Mois), 2, '0', TRUE) + '/' + FORMAT(Annee);
        TableDonnees.RESET;
        TableDonnees.DELETEALL;
        MvtDAC.RESET;
        MvtDAC.DELETEALL;
        IF TypeCotisation.FINDFIRST THEN
            REPEAT
                TableDonnees.INIT;
                TableDonnees.Code := TypeCotisation.Code;
                TableDonnees.Description := TypeCotisation.Description;
                TableDonnees.Taux := TypeCotisation.Rate;
                TableDonnees.INSERT;
            UNTIL TypeCotisation.NEXT = 0;
        TypeCotisation.RESET;
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
        Paie.RESET;
        Paie.SETFILTER("Ending Date", '>=%1&<=%2', DebutPeriode, FinPeriode);
        IF CodeUnite <> '' THEN
            Paie.SETRANGE("Company Business Unit Code", CodeUnite);
        EcriturePaie.RESET;
        EcriturePaie.SETCURRENTKEY("Document No.", "Employee No.", "Item Code");
        EcriturePaie.SETRANGE("Item Code", ParamPaie."Employer Cotisation");
        TableDonnees.RESET;
        IF TableDonnees.FINDFIRST THEN
            REPEAT
                IF Paie.FINDFIRST THEN
                    REPEAT
                        EcriturePaie.SETRANGE("Document No.", Paie.Code);
                        IF EcriturePaie.FINDFIRST THEN
                            REPEAT
                                IF CotisationSalarie.GET(EcriturePaie."Employee No.", TableDonnees.Code) THEN BEGIN
                                    TableDonnees.Assiette := TableDonnees.Assiette + EcriturePaie.Basis;
                                    TableDonnees.MODIFY;
                                    Salarie.GET(EcriturePaie."Employee No.");
                                    IF NOT MvtDAC.GET(EcriturePaie."Employee No.", TableDonnees.Code) THEN BEGIN
                                        MvtDAC.INIT;
                                        MvtDAC."Employee No." := EcriturePaie."Employee No.";
                                        MvtDAC."Cotisation Type" := TableDonnees.Code;
                                        MvtDAC.INSERT;
                                    END;
                                    IF (Salarie."Employment Date" >= DebutPeriode)
                                    AND (Salarie."Employment Date" <= FinPeriode) THEN BEGIN
                                        MvtDAC.GET(EcriturePaie."Employee No.", TableDonnees.Code);
                                        MvtDAC.Entree := TRUE;
                                        MvtDAC.MODIFY;
                                    END;
                                    IF (Salarie."Termination Date" >= DebutPeriode)
                                    AND (Salarie."Termination Date" <= FinPeriode) THEN BEGIN
                                        MvtDAC.GET(EcriturePaie."Employee No.", TableDonnees.Code);
                                        MvtDAC.Sortie := TRUE;
                                        MvtDAC.MODIFY;
                                    END;
                                END;
                            UNTIL EcriturePaie.NEXT = 0;
                    UNTIL Paie.NEXT = 0;
            UNTIL TableDonnees.NEXT = 0;
        TotalCotisations := 0;
        IF TableDonnees.FINDFIRST THEN BEGIN
            REPEAT
                TableDonnees.Montant := TableDonnees.Assiette * TableDonnees.Taux / 100;
                MvtDAC.RESET;
                MvtDAC.SETRANGE(Entree, TRUE);
                MvtDAC.SETRANGE("Cotisation Type", TableDonnees.Code);
                TableDonnees.Entrée := MvtDAC.COUNT;
                MvtDAC.RESET;
                MvtDAC.SETRANGE(Sortie, TRUE);
                MvtDAC.SETRANGE("Cotisation Type", TableDonnees.Code);
                TableDonnees.Sortie := MvtDAC.COUNT;
                MvtDAC.RESET;
                MvtDAC.SETRANGE("Cotisation Type", TableDonnees.Code);
                TableDonnees.Effectif := MvtDAC.COUNT;
                TableDonnees.MODIFY;
                TotalCotisations := TotalCotisations + TableDonnees.Montant;
            UNTIL TableDonnees.NEXT = 0;
        END;
    end;

    var
        InfosSociete: Record 79;
        Unite: Record "Company Business Unit";
        GestionnairePaie: Record "Payroll Manager";
        Text01: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        CodeUnite: Code[10];
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        TotalCotisations: Decimal;
        TableDonnees: Record "Déclaration de cotisations";
        CotisationSalarie: Record "Employee Cotisation";
        TypeCotisation: Record "Cotisation Type";
        EcriturePaie: Record "Payroll Entry";
        ParamPaie: Record Payroll_Setup;
        Paie: Record Payroll;
        Text03: Label 'Information manquante : %1 !';
        Mois: Integer;
        Annee: Integer;
        Jour: Integer;
        DebutPeriode: Date;
        FinPeriode: Date;
        Periode: Text[30];
        Outils: Codeunit "Tools Library";
        Salarie: Record 5200;
        Entrees: Integer;
        Sorties: Integer;
        Effectif: Integer;
        MvtDAC: Record "Mouvement DAC";
        DescriptionLine: array[2] of Text[200];
        CheckReport: Report 1401;
        BasDocument: Text[50];
        DateEdition: Date;
        SECURITE_SOCIALECaptionLbl: Label 'SECURITE SOCIALE';
        CODECaptionLbl: Label 'CODE';
        NATURE_DES_COTISATIONSCaptionLbl: Label 'NATURE DES COTISATIONS';
        ASSIETTECaptionLbl: Label 'ASSIETTE';
        TAUXCaptionLbl: Label 'TAUX';
        MONTANTCaptionLbl: Label 'MONTANT';
        DECOMPTE_DES_COTISATIONSCaptionLbl: Label 'DECOMPTE DES COTISATIONS';
        EFFECTIF_TOTAL_EN_EXERCICECaptionLbl: Label 'EFFECTIF TOTAL EN EXERCICE';
        MOUVEMENT_DU_PERSONNELCaptionLbl: Label 'MOUVEMENT DU PERSONNEL';
        CNASCaptionLbl: Label 'CNAS';
        Agence__CaptionLbl: Label 'Agence :';
        N__CCP__CaptionLbl: Label 'N° CCP :';
        "N__Cpte_Trésor__CaptionLbl": Label 'N° Cpte Trésor :';
        "N__Tél___CaptionLbl": Label 'N° Tél. :';
        Code_AgenceCaptionLbl: Label 'Code Agence';
        "Date_RéceptionCaptionLbl": Label 'Date Réception';
        "Période_CotisationCaptionLbl": Label 'Période Cotisation';
        "Numéro_CotisantCaptionLbl": Label 'Numéro Cotisant';
        Classe_de_CotisantCaptionLbl: Label 'Classe de Cotisant';
        DESTINATAIRECaptionLbl: Label 'DESTINATAIRE';
        TOTAL_DES_COTISATIONSCaptionLbl: Label 'TOTAL DES COTISATIONS';
        PERIODECaptionLbl: Label 'PERIODE';
        CANALCaptionLbl: Label 'CANAL';
        JOURNEECaptionLbl: Label 'JOURNEE';
        "Montant_versé_à_déduireCaptionLbl": Label 'Montant versé à déduire';
        Montant_du_versementCaptionLbl: Label 'Montant du versement';
        DACaptionLbl: Label 'DA';
        Montant_en_lettres__CaptionLbl: Label 'Montant en lettres :';
        IDENTIFICATION_COTISANTCaptionLbl: Label 'IDENTIFICATION COTISANT';
        "Règlement_par__CaptionLbl": Label 'Règlement par :';
        "Chèque_bancaire_n___CaptionLbl": Label 'Chèque bancaire n° :';
        "Chèque_postal_n___CaptionLbl": Label 'Chèque postal n° :';
        "Caisse_reçu_n___CaptionLbl": Label 'Caisse reçu n° :';
        Cachet_et_signature_du_cotisantCaptionLbl: Label 'Cachet et signature du cotisant';
        EmptyStringCaptionLbl: Label '..............................';
        EmptyStringCaption_Control1000000116Lbl: Label '..............................';
        EmptyStringCaption_Control1000000117Lbl: Label '..............................';
        BORDEREAU_DE_VERSEMENT_DES_COTISATIONSCaptionLbl: Label 'BORDEREAU DE VERSEMENT DES COTISATIONS';

}

