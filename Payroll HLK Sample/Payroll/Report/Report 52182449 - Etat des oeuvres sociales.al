/// <summary>
/// Report Etat des oeuvres sociales (ID 51435).
/// </summary>
report 52182449 "Etat des oeuvres sociales"
{
    // version HALRHPAIE.6.1.06

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Etat des oeuvres sociales.rdl';

    dataset
    {
        dataitem(DataItem8955; Payroll)
        {
            RequestFilterFields = "Code";
        }
        dataitem(DataItem5556; "Oeuvres sociales")
        {
            DataItemTableView = SORTING("Line No.");
            column(Logo; CompanyInfo.Picture)
            {
            }
            column(DesignationPaie; DesignationPaie)
            {
            }
            column(Unite__Employer_SS_No__; Unite."Employer SS No.")
            {
            }
            column(Unite__Post_Code_; Unite."Post Code")
            {
            }
            column(Unite_City; Unite.City)
            {
            }
            column(Unite_Name; Unite.Name)
            {
            }
            column(InfoSociete_Picture; InfoSociete.Picture)
            {
                AutoCalcField = true;
            }
            column(Unite_Address; Unite.Address)
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(Titre; Titre)
            {
            }
            column(Unite__Address_2_; Unite."Address 2")
            {
            }
            column(Oeuvres_sociales_Description; Description)
            {
            }
            column(Oeuvres_sociales_Rate; Rate)
            {
            }
            column(Oeuvres_sociales_Amount; Amount)
            {
            }
            column(Oeuvres_sociales__Basis_Amount_; "Basis Amount")
            {
            }
            column(TotalMontant; TotalMontant)
            {
            }
            column(DescriptionLine_1_; DescriptionLine[1])
            {
            }
            column(DescriptionLine_2_; DescriptionLine[2])
            {
            }
            column(DIRECTION_DU_PERSONNEL_ET_DES_MOYENS_DEPARTEMENT_DES_RESSOURCES_HUMAINESCaption; DIRECTION_DU_PERSONNEL_ET_DES_MOYENS_DEPARTEMENT_DES_RESSOURCES_HUMAINESCaptionLbl)
            {
            }
            column(RubriqueCaption; RubriqueCaptionLbl)
            {
            }
            column(TauxCaption; TauxCaptionLbl)
            {
            }
            column(MontantCaption; MontantCaptionLbl)
            {
            }
            column(AssietteCaption; AssietteCaptionLbl)
            {
            }
            column(N__SS_EmployeurCaption; N__SS_EmployeurCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Total_des_oeuvres_sociales__Caption; Total_des_oeuvres_sociales__CaptionLbl)
            {
            }
            column("Arrêter_le_présent_état_à_la_somme_de__Caption"; Arrêter_le_présent_état_à_la_somme_de__CaptionLbl)
            {
            }
            column(Oeuvres_sociales_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord();
            begin

                CLEAR(DescriptionLine);
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(DescriptionLine, ROUND(TotalMontant), '');
            end;

            trigger OnPreDataItem();
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                CompanyInfo.CALCFIELDS("Right Logo");
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        GestionnairePaie.RESET;
        GestionnairePaie.SETRANGE("User ID", USERID);
        IF NOT GestionnairePaie.FINDSET THEN
            ERROR(Text06, USERID);

        EVALUATE(NumReport, COPYSTR(FORMAT(CurrReport.OBJECTID(FALSE)), 8, 100));
        IF SelectionEtats.GET(NumReport) THEN
            Titre := SelectionEtats."Report Name"
        ELSE
            Titre := CurrReport.OBJECTID(TRUE);
    end;

    trigger OnPreReport();
    begin
        InfoSociete.GET;
        InfoSociete.CALCFIELDS(Picture);
        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");
        InfoSociete.CALCFIELDS(Picture);
        IF DataItem8955.GETFILTERS = '' THEN
            ERROR(Text01);
        Paie.COPYFILTERS(DataItem8955);
        DataItem8955.COPYFILTER(Code, EcriturePaie."Document No.");
        Paie.FINDFIRST;
        CodePaie := Paie.Code;
        DesignationPaie := Paie.Description;
        IF EcriturePaie.ISEMPTY THEN
            ERROR(Text07, CodePaie);
        CodeUnite := Paie."Company Business Unit Code";
        IF CodeUnite = '' THEN
            ERROR(Text08, CodePaie);
        GestionnairePaie.RESET;
        GestionnairePaie.SETRANGE("User ID", USERID);
        GestionnairePaie.SETRANGE("Company Business Unit Code", CodeUnite);
        IF NOT GestionnairePaie.FINDSET THEN
            ERROR(Text03, USERID, CodePaie);
        Salarie2.RESET;
        Salarie1.COPYFILTER("No.", Salarie2."No.");
        Salarie2.SETRANGE(Salarie2."Company Business Unit Code", CodeUnite);
        IF NOT Salarie2.FINDSET(FALSE, FALSE) THEN
            ERROR(Text02, CodeUnite);
        OeuvresSociales.RESET;
        OeuvresSociales.DELETEALL;
        ParamPaie.GET;
        EcriturePaie.RESET;
        EcriturePaie.SETFILTER("Document No.", COPYSTR(DataItem8955.GETFILTERS, 6, 200));
        EcriturePaie.SETFILTER("Item Code", ParamPaie."Base oeuvres sociales");
        Base1 := 0;
        IF EcriturePaie.FINDFIRST THEN
            REPEAT
                Base1 := Base1 + EcriturePaie.Amount;
            UNTIL EcriturePaie.NEXT = 0;
        EcriturePaie.SETFILTER("Item Code", ParamPaie."Base cotisation patronale");
        Base2 := 0;
        IF EcriturePaie.FINDFIRST THEN
            REPEAT
                Base2 := Base2 + EcriturePaie.Amount;
            UNTIL EcriturePaie.NEXT = 0;
        OeuvresSociales.INIT;
        OeuvresSociales."Line No." := 1;
        OeuvresSociales.Description := ParamPaie."Intitule oeuvres sociales 1";
        OeuvresSociales."Basis Amount" := Base1;
        OeuvresSociales.Rate := ParamPaie."Taux oeuvres sociales";
        OeuvresSociales.Amount := Base1 * ParamPaie."Taux oeuvres sociales" / 100;
        OeuvresSociales.INSERT;
        OeuvresSociales.INIT;
        OeuvresSociales."Line No." := 2;
        OeuvresSociales.Description := ParamPaie."Intitule oeuvres sociales 2";
        OeuvresSociales."Basis Amount" := Base2;
        OeuvresSociales.Rate := ParamPaie."Taux cotisation patronale";
        OeuvresSociales.Amount := Base2 * ParamPaie."Taux cotisation patronale" / 100;
        OeuvresSociales.INSERT;
    end;

    var
        DesignationPaie: Text[30];
        InfoSociete: Record 79;
        OeuvresSociales: Record "Oeuvres sociales";
        GestionnairePaie: Record "Payroll Manager";
        Paie: Record Payroll;
        Text01: Label 'Code de paie manquant !';
        Text06: Label 'Utilisateur %1 non configuré dans la table des gestionnaires de paie !';
        Text07: Label 'Paie %1 non encore calculée  !';
        EcriturePaie: Record "Payroll Entry";
        CodePaie: Code[20];
        Text08: Label 'Code de direction manquant pour la paie %1 !';
        CodeUnite: Code[10];
        Text03: Label 'L''utilisateur %1 n''est pas autorisé à visualiser la paie %2 !';
        Salarie1: Record 5200;
        Salarie2: Record 5200;
        Text02: Label 'Aucun salarié n''est affecté à la direction %1 !';
        Base1: Decimal;
        Base2: Decimal;
        ParamPaie: Record Payroll_Setup;
        DescriptionLine: array[2] of Text[80];
        Cheque: Report 1401;
        TotalMontant: Decimal;
        Unite: Record "Company Business Unit";
        ParamUtilisateur: Record 91;
        Titre: Text[100];
        SelectionEtats: Record "HR Payroll Report Selections";
        NumReport: Integer;
        CheckReport: Report 1401;
        ParamCompta: Record 98;
        DIRECTION_DU_PERSONNEL_ET_DES_MOYENS_DEPARTEMENT_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DIRECTION DU PERSONNEL ET DES MOYENS DEPARTEMENT DES RESSOURCES HUMAINES';
        RubriqueCaptionLbl: Label 'Rubrique';
        TauxCaptionLbl: Label 'Taux';
        MontantCaptionLbl: Label 'Montant';
        AssietteCaptionLbl: Label 'Assiette';
        N__SS_EmployeurCaptionLbl: Label 'N° SS Employeur';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Total_des_oeuvres_sociales__CaptionLbl: Label 'Total des oeuvres sociales :';
        "Arrêter_le_présent_état_à_la_somme_de__CaptionLbl": Label 'Arrêter le présent état à la somme de :';
        CompanyInfo: Record 79;
        TotalOrder: Decimal;
}

