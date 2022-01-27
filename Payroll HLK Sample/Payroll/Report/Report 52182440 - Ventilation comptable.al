report 51419 "Ventilation comptable"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Ventilation comptable.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem4380; Structure)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem6914; "Socio-professional Category")
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem4587; "Tab Ventilation Comptable")
        {
            DataItemTableView = SORTING(No);
            column(Periode; Periode)
            {
            }
            column(FiltreStructure; FiltreStructure)
            {
            }
            column(FiltreCategorie; FiltreCategorie)
            {
            }
            column(Titre; Titre)
            {
            }
            column(InfoSociete_Picture; InfoSociete.Picture)
            {
            }
            column(CodeUnite; CodeUnite)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(Tab_Ventilation_Comptable__No_Rub_; "No Rub")
            {
            }
            column(Tab_Ventilation_Comptable_Nombre; Nombre)
            {
            }
            column(Tab_Ventilation_Comptable_retenue; retenue)
            {
            }
            column(Tab_Ventilation_Comptable__Tab_Ventilation_Comptable__description; DataItem4587.description)
            {
            }
            column(Tab_Ventilation_Comptable_base; base)
            {
            }
            column(Tab_Ventilation_Comptable_versement; versement)
            {
            }
            column(Tab_Ventilation_Comptable_compte; compte)
            {
            }
            column(Nb; Nb)
            {
            }
            column(Tab_Ventilation_Comptable_retenue_Control1000000047; retenue)
            {
            }
            column(Tab_Ventilation_Comptable_versement_Control1000000046; versement)
            {
            }
            column(DescriptionLine_2_; DescriptionLine[2])
            {
            }
            column(DescriptionLine_1_; DescriptionLine[1])
            {
            }
            column(TotalNet; TotalNet)
            {
            }
            column(N__RubriqueCaption; N__RubriqueCaptionLbl)
            {
            }
            column(EffectifCaption; EffectifCaptionLbl)
            {
            }
            column("DésignationCaption"; DésignationCaptionLbl)
            {
            }
            column(CompteCaption; CompteCaptionLbl)
            {
            }
            column(BaseCaption; BaseCaptionLbl)
            {
            }
            column("Retenue__Crédit_Caption"; Retenue__Crédit_CaptionLbl)
            {
            }
            column("Gain__Débit_Caption"; Gain__Débit_CaptionLbl)
            {
            }
            column(Structure__Caption; Structure__CaptionLbl)
            {
            }
            column("Catégorie__Caption"; Catégorie__CaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column("Nombre_de_salariés__Caption"; Nombre_de_salariés__CaptionLbl)
            {
            }
            column(Totaux__Caption; Totaux__CaptionLbl)
            {
            }
            column("Arrêter_le_présent_état_à_la_somme_de__Caption"; Arrêter_le_présent_état_à_la_somme_de__CaptionLbl)
            {
            }
            column("Total_net_à_payer__Caption"; Total_net_à_payer__CaptionLbl)
            {
            }
            column(Tab_Ventilation_Comptable_No; No)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF ParamPaie."Net Salary" = DataItem4587."No Rub" THEN
                    Nb := DataItem4587.Nombre;

                //*************** <Code Section 3> ********************************//
                IF DataItem4587."No Rub" = ParamPaie."Net Salary" THEN
                    TotalNet := DataItem4587.retenue;
                //*************** <Code Section 3> ********************************//

                //*************** <Code Section 3> ****************************//
                CLEAR(DescriptionLine);
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(DescriptionLine, ROUND(TotalNet), '');
                //*************** <Code Section 3> ***************************//
            end;

            trigger OnPostDataItem();
            var
                LigneArchivePaie: Record "Payroll Archive Line";
                AmountToDeduct: Decimal;
            begin
                /*
                // deduction des bases imposables sans retenue
                AmountToDeduct:=0;
                ParamPaie.GET;
                LigneArchivePaie.RESET;
                LigneArchivePaie.SETRANGE("Payroll Code",CodePaie);
                LigneArchivePaie.SETRANGE("Item Code",ParamPaie."TIT Deduction");
                //LigneArchivePaie.SETFILTER(Amount,'<%1',1);
                 MESSAGE(codePaievent);
                IF LigneArchivePaie.FINDSET THEN
                  BEGIN
                
                    MESSAGE('%1',LigneArchivePaie.Basis);
                    REPEAT
                     AmountToDeduct:= AmountToDeduct + LigneArchivePaie.Basis;
                
                    UNTIL LigneArchivePaie.NEXT=0;
                
                
                  END;
                
                  // deduction sur le 601
                    TabVentilationComptable.RESET;
                
                    TabVentilationComptable.SETRANGE(TabVentilationComptable."No Rub",ParamPaie."TIT Deduction");
                    IF TabVentilationComptable.FINDFIRST THEN
                    BEGIN
                
                    TabVentilationComptable.base:=TabVentilationComptable.base - AmountToDeduct;
                    TabVentilationComptable.MODIFY;
                    END;
                
                  // deduction sur le 600
                
                    TabVentilationComptable.RESET;
                    TabVentilationComptable.SETRANGE(TabVentilationComptable."No Rub",ParamPaie."Taxable Salary");
                       IF TabVentilationComptable.FINDFIRST THEN
                    BEGIN
                
                    TabVentilationComptable.base:=TabVentilationComptable.base - AmountToDeduct;
                    TabVentilationComptable.MODIFY;
                        END;
                        */

            end;

            trigger OnPreDataItem();
            var
                LigneArchivePaie: Record "Payroll Archive Line";
                AmountToDeduct: Decimal;
            begin
                IF CodePaie = '' THEN BEGIN
                    IF MoisDebut = 0 THEN
                        ERROR(Text03, 'Mois début');
                    IF MoisFin = 0 THEN
                        ERROR(Text03, 'Mois fin');
                    IF AnneeDebut = 0 THEN
                        ERROR(Text03, 'Année début');
                    IF AnneeFin = 0 THEN
                        ERROR(Text03, 'Année fin');
                    IF (MoisDebut < 1) OR (MoisDebut > 12) THEN
                        ERROR('Mois début inccorect !');
                    IF (MoisFin < 1) OR (MoisFin > 12) THEN
                        ERROR('Mois fin inccorect !');
                    IF (AnneeDebut < 1900) OR (AnneeDebut > 2100) THEN
                        ERROR('Année début inccorecte !');
                    IF (AnneeFin < 1900) OR (AnneeFin > 2100) THEN
                        ERROR('Année fin inccorecte !');
                END
                ELSE BEGIN
                    IF Paie."Ending Date" = 0D THEN
                        ERROR(Text02, Paie.FIELDCAPTION("Ending Date"), CodePaie);
                    MoisDebut := DATE2DMY(Paie."Ending Date", 2);
                    MoisFin := MoisDebut;
                    AnneeDebut := DATE2DMY(Paie."Ending Date", 3);
                    AnneeFin := AnneeDebut;
                END;
                VentilationComptable.TraitementRubrique(AnneeDebut, AnneeFin, MoisDebut, MoisFin, CodePaie, Gain, retenue,
                DataItem4380.GETFILTERS, DataItem6914.GETFILTERS);
                IF DataItem4380.GETFILTERS = '' THEN
                    FiltreStructure := 'Toutes'
                ELSE
                    FiltreStructure := DataItem4380.GETFILTERS;
                IF DataItem6914.GETFILTERS = '' THEN
                    FiltreCategorie := 'Toutes'
                ELSE
                    FiltreCategorie := DataItem6914.GETFILTERS;
                Periode := 'DE ' + FORMAT(MoisDebut) + '/' + FORMAT(AnneeDebut) + ' à ' + FORMAT(MoisFin) + '/' + FORMAT(AnneeFin);
                IF CodePaie <> '' THEN
                    Periode := Periode + ' [' + CodePaie + ']';
                /*
                // debut intervention khaled
                // Recalcul de la base 600 et 601
                // deduction des bases imposables sans retenue
                AmountToDeduct:=0;
                ParamPaie.GET;
                LigneArchivePaie.RESET;
                
                LigneArchivePaie.SETRANGE("Payroll Code",'PAIE062020');
                //CodePaie);
                LigneArchivePaie.SETRANGE("Item Code",ParamPaie."TIT Deduction");
                LigneArchivePaie.SETFILTER(Amount,'=%1',0);
                
                
                IF LigneArchivePaie.FINDSET THEN
                  BEGIN
                
                
                    REPEAT
                     AmountToDeduct:= AmountToDeduct + LigneArchivePaie.Basis;
                
                    UNTIL LigneArchivePaie.NEXT=0;
                
                
                  END;
                
                  // deduction sur le 601
                    TabVentilationComptable.RESET;
                
                    TabVentilationComptable.SETRANGE(TabVentilationComptable."No Rub",ParamPaie."TIT Deduction");
                    IF TabVentilationComptable.FINDFIRST THEN
                    BEGIN
                
                    TabVentilationComptable.base:=TabVentilationComptable.base - AmountToDeduct;
                    TabVentilationComptable.MODIFY;
                    END;
                
                  // deduction sur le 600
                
                    TabVentilationComptable.RESET;
                    TabVentilationComptable.SETRANGE(TabVentilationComptable."No Rub",ParamPaie."Taxable Salary");
                       IF TabVentilationComptable.FINDFIRST THEN
                    BEGIN
                
                    TabVentilationComptable.base:=TabVentilationComptable.base - AmountToDeduct;
                    TabVentilationComptable.MODIFY;
                        END;
                // Fin intervention khaled
                */

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
                    field(MoisDebut; MoisDebut)
                    {
                        Caption = 'Mois Début :';
                    }
                    field(AnneeDebut; AnneeDebut)
                    {
                        Caption = 'Année Début :';
                    }
                    field(MoisFin; MoisFin)
                    {
                        Caption = 'Mois Fin :';
                    }
                    field(AnneeFin; AnneeFin)
                    {
                        Caption = 'Année Fin :';
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
            ERROR(Text01, USERID);
        IF GestionnairePaie."Company Business Unit Code" <> '' THEN
            Unite.GET(GestionnairePaie."Company Business Unit Code");
        CodeUnite := GestionnairePaie."Company Business Unit Code";
        MoisDebut := DATE2DMY(TODAY, 2);
        MoisFin := MoisDebut;
        AnneeDebut := DATE2DMY(TODAY, 3);
        AnneeFin := AnneeDebut;
        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);
        InfoSociete.GET;
        InfoSociete.CALCFIELDS(Picture);
        ParamPaie.GET;
    end;

    trigger OnPreReport();
    begin
        IF DataItem8955.GETFILTERS = '' THEN
            CodePaie := ''
        ELSE BEGIN
            Paie.COPYFILTERS(DataItem8955);
            Paie.FINDFIRST;
            CodePaie := Paie.Code;
            codePaievent := Paie.Code;
            IF (Paie."Company Business Unit Code" <> CodeUnite)
            AND (CodeUnite <> '') THEN
                ERROR(Text04, USERID, CodePaie);
        END;
    end;

    var
        VentilationComptable: Codeunit "Ventilation comptable";
        Periode: Text[50];
        Gain: Decimal;
        Retenue: Decimal;
        Nb: Integer;
        ParamPaie: Record Payroll_Setup;
        Nbligne: Integer;
        Compteur: Integer;
        FiltreStructure: Code[200];
        FiltreCategorie: Code[200];
        InfoSociete: Record 79;
        AnneeDebut: Integer;
        AnneeFin: Integer;
        MoisDebut: Integer;
        MoisFin: Integer;
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        Titre: Text[100];
        Unite: Record "Company Business Unit";
        GestionnairePaie: Record "Payroll Manager";
        Text01: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        DescriptionLine: array[2] of Text[80];
        CheckReport: Report 1401;
        TotalNet: Decimal;
        TabVentilationComptable: Record "Tab Ventilation Comptable";
        Rubrique: Record "Payroll Item";
        CodePaie: Code[20];
        Paie: Record Payroll;
        Text02: Label '%1 non paramétrée pour la paie %2 !';
        Text03: Label 'Information manquante : %1 !';
        Text04: Label 'L''utilisateur %1 n''est pas autorisé à visualiser la paie %2 !';
        CodeUnite: Code[10];
        N__RubriqueCaptionLbl: Label 'N° Rubrique';
        EffectifCaptionLbl: Label 'Effectif';
        "DésignationCaptionLbl": Label 'Désignation';
        CompteCaptionLbl: Label 'Compte';
        BaseCaptionLbl: Label 'Base';
        "Retenue__Crédit_CaptionLbl": Label 'Retenue (Crédit)';
        "Gain__Débit_CaptionLbl": Label 'Gain (Débit)';
        Structure__CaptionLbl: Label 'Structure :';
        "Catégorie__CaptionLbl": Label 'Catégorie :';
        PageCaptionLbl: Label 'Page';
        "Nombre_de_salariés__CaptionLbl": Label 'Nombre de salariés :';
        Totaux__CaptionLbl: Label 'Totaux :';
        "Arrêter_le_présent_état_à_la_somme_de__CaptionLbl": Label 'Arrêter le présent état à la somme de :';
        "Total_net_à_payer__CaptionLbl": Label 'Total net à payer :';
        "PériodeDu": Date;
        au: Date;
        codePaievent: Code[20];
}

