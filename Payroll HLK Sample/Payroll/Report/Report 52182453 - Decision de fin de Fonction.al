/// <summary>
/// Report Decision de fin de Fonction (ID 52182453).
/// </summary>
report 52182453 "Decision de fin de Fonction"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Decision de fin de Fonction.rdl';

    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            DataItemTableView = SORTING("No.")
                            WHERE(Status = CONST(Inactive));
            RequestFilterFields = "No.";
            column(NumRef; NumRef)
            {
            }
            column(NomEntreprise; NomEntreprise)
            {
            }
            column(CompanyInformation_Picture; Infosociete.Picture)
            {
                AutoCalcField = true;
            }
            column(Sexe; Sexe)
            {
            }
            column(Nom; Nom)
            {
            }
            column(Employee_Employee__Function_Description_; Employee."Job Title")
            {
            }
            column(Employee_Employee__Structure_Description_; Employee."Structure Description")
            {
            }
            column(Employee_Employee__Termination_Date_; Employee."Termination Date")
            {
            }
            column(Motif; Motif)
            {
            }
            column(Texte2; Texte2)
            {
            }
            column(TexteDate; TexteDate)
            {
            }
            column(DECISION_N_Caption; DECISION_N_CaptionLbl)
            {
            }
            column(SERVICE_DU_PERSONNELCaption; SERVICE_DU_PERSONNELCaptionLbl)
            {
            }
            column(DIRECTION_DES_RESSOURCES_HUMAINESCaption; DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl)
            {
            }
            column("Le_Gérant_Caption"; Le_Gérant_CaptionLbl)
            {
            }
            column(DECIDECaption; DECIDECaptionLbl)
            {
            }
            column(Article_1___Caption; Article_1___CaptionLbl)
            {
            }
            column(Article_2___Caption; Article_2___CaptionLbl)
            {
            }
            column("Vu_la_loi_n__90_11_du_21_04_90__modifiée_et_complétée__relative_aux_relations_de_travail_Caption"; Vu_la_loi_n__90_11_du_21_04_90__modifiée_et_complétée__relative_aux_relations_de_travail_CaptionLbl)
            {
            }
            column(DataItem1000000013; Vu)
            {
            }
            column(DataItem1000000014; Vue)
            {
            }
            column(Fonction__Caption; Fonction__CaptionLbl)
            {
            }
            column(Affectation__Caption; Affectation__CaptionLbl)
            {
            }
            column(Motif___Caption; Motif___CaptionLbl)
            {
            }
            column(Ampliation___Caption; Ampliation___CaptionLbl)
            {
            }
            column("Intéressé__e_Caption"; Intéressé__e_CaptionLbl)
            {
            }
            column(SP_DossierCaption; SP_DossierCaptionLbl)
            {
            }
            column("L_intéressé_est_rayé_des_effectifs_de_l_entreprise_à_compter_du__Caption"; L_intéressé_est_rayé_des_effectifs_de_l_entreprise_à_compter_du__CaptionLbl)
            {
            }
            column(L_employeurCaption; L_employeurCaptionLbl)
            {
            }
            column("Vu_le_contrat_de_travail_de_l_intéressé__Caption"; Vu_le_contrat_de_travail_de_l_intéressé__CaptionLbl)
            {
            }
            column("Vu_la_demande_de_démission_formulée_par_l_intéresséCaption"; Vu_la_demande_de_démission_formulée_par_l_intéresséCaptionLbl)
            {
            }
            column(Il_est_mis_fin_aux_fonctions_de__Caption; Il_est_mis_fin_aux_fonctions_de__CaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                Unite.FINDFIRST;
                Employee.Get("No.");
                IF Employee.Gender = Employee.Gender::Female THEN
                    Sexe := 'Madame :';
                IF Employee.Gender = Employee.Gender::Male THEN
                    Sexe := 'Monsieur :';

                Nom := Employee."Last Name" + ' ' + Employee."First Name";
                /*
                EmployeeAssig.SETRANGE("Employee No.",Employee."No.");
                EmployeeAssig.SETRANGE("Ending Date");
                EmployeeAssig.FINDFIRST;
                Date:=EmployeeAssig."Ending Date";
                Fonction:=EmployeeAssig."Function Description";
                Affect:=EmployeeAssig."Structure Description" ;
                
                REPEAT
                
                IF EmployeeAssig."Ending Date">Date THEN
                BEGIN
                Fonction:=EmployeeAssig."Function Description";
                Affect:=EmployeeAssig."Structure Description" ;
                Date:=EmployeeAssig."Ending Date";
                END;
                UNTIL EmployeeAssig.NEXT=0;
                 */
                IF Cause.GET(Employee."Grounds for Term. Code") THEN
                    Motif := Cause.Description;

                parampaye.GET;
                IF parampaye."Treatment Grid Type" = parampaye."Treatment Grid Type"::Sections THEN BEGIN
                    Texte1 := 'Echelle :' + FORMAT(Employee."Section Grid Section") + ',    Echelon :' + ' ' + FORMAT(Employee."Section Grid Level");
                    Texte5 := FORMAT(Employee."Section Grid Section") + ',    Echelon :' + ' ' + FORMAT(Employee."Section Grid Level");
                END;

                IF parampaye."Treatment Grid Type" = parampaye."Treatment Grid Type"::"Hourly Index" THEN BEGIN
                    Texte1 := 'Echelle :' + Employee."Hourly Index Grid CH" + ',    Echelon :' + ' ' + FORMAT(Employee."Hourly Index Grid Index");
                    Texte5 := Employee."Hourly Index Grid CH" + ',    Echelon :' + ' ' + FORMAT(Employee."Hourly Index Grid Index");
                END;

                Responsable := '';
                IF (Structure.GET("Structure Code")) AND ("Structure Code" <> '')
                THEN
                    Responsable := Structure.Responsable;
                IF Responsable = '' THEN BEGIN
                    Texte2 := 'Monsieur le Directeur des Ressources Humaines ' + ' est chargé';
                    Texte2 := Texte2 + ' l''exécution de la présente décision qui prend effet à compter du: ' + FORMAT(ImpDate)
                END;
                IF Responsable <> '' THEN BEGIN
                    Texte2 := 'Messieurs les Directeurs des Ressources Humaines et' + ' ' + Responsable + ' sont chargés chacun';
                    Texte2 := Texte2 + ' en ce qui le concerne de l''exécution de la présente décision qui prend effet à compter du: ' + FORMAT(ImpDate);
                END;

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

        Infosociete.GET;
        Lieu := Infosociete.City;
        ImpDate := TODAY;
        Motif := 'DEMISSION';
    end;

    trigger OnPreReport();
    begin
        Infosociete.GET;
        Infosociete.CALCFIELDS(Picture);
        ParamUtilisateur.GET(USERID);
        Unite.GET(ParamUtilisateur."Company Business Unit");
        Infosociete.CALCFIELDS(Picture);

        IF Lieu = ''
        THEN
            ERROR('Veuillez saisir le lieu et la Date d''édition dans l''onglet Options');

        IF Motif = ''
        THEN
            ERROR('Veuillez saisir le Motif de fin de fonction dans l''onglet Options');
    end;

    var
        CompanyInfo: Record 79;
        Employee: Record 5200;
        Infosociete: Record 79;
        Unite: Record "Company Business Unit";
        Sexe: Code[10];
        Nom: Text[30];
        Fonction: Text[50];
        Affect: Text[50];
        EmployeeAssig: Record "Employee Assignment";
        Texte1: Text[300];
        parampaye: Record Payroll_Setup;
        Texte2: Text[300];
        Texte3: Text[200];
        Texte4: Text[200];
        Texte5: Text[50];
        Cause: Record 5217;
        Date: Date;
        ParamUtilisateur: Record 91;
        NumRef: Text[30];
        NomEntreprise: Text[30];
        footer1: Text[200];
        footer2: Text[200];
        footer3: Text[200];
        ImpDate: Date;
        Lieu: Text[30];
        Motif: Text[100];
        TexteDate: Text[50];
        Responsable: Text[50];
        Structure: Record Structure;
        DECISION_N_CaptionLbl: Label 'DECISION N°';
        SERVICE_DU_PERSONNELCaptionLbl: Label 'SERVICE DU PERSONNEL';
        DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DIRECTION DES RESSOURCES HUMAINES';
        "Le_Gérant_CaptionLbl": Label 'Le Gérant,';
        DECIDECaptionLbl: Label 'DECIDE';
        Article_1___CaptionLbl: Label '"Article 1 : "';
        Article_2___CaptionLbl: Label '"Article 2 : "';
        "Vu_la_loi_n__90_11_du_21_04_90__modifiée_et_complétée__relative_aux_relations_de_travail_CaptionLbl": Label '- Vu la loi n° 90-11 du 21/04/90, modifiée et complétée, relative aux relations de travail,';
        "Vu": Label '- Vu le statut de la Sarl "  yaourt Soummam ", établi devant Maître IBERAKEN Idir le 23/12/1996, modifié et complété';
        "Vue": Label '- Vu le règlement intérieur de la sarl Laiterie Soummam, déposé le 03/05/1999 et enregistré auprès du tribunal d''Akbou sous le N°02/99, modifié le 18/05/99 et enregistré sous le N°136/99,';
        Fonction__CaptionLbl: Label 'Fonction :';
        Affectation__CaptionLbl: Label 'Affectation :';
        Motif___CaptionLbl: Label '"Motif : "';
        Ampliation___CaptionLbl: Label '"Ampliation : "';
        "Intéressé__e_CaptionLbl": Label '- Intéressé (e)';
        SP_DossierCaptionLbl: Label '- SP/Dossier';
        "L_intéressé_est_rayé_des_effectifs_de_l_entreprise_à_compter_du__CaptionLbl": Label '" L''intéressé est rayé des effectifs de l''entreprise à compter du :"';
        L_employeurCaptionLbl: Label 'L''employeur';
        "Vu_le_contrat_de_travail_de_l_intéressé__CaptionLbl": Label '"- Vu le contrat de travail de l''intéressé, "';
        "Vu_la_demande_de_démission_formulée_par_l_intéresséCaptionLbl": Label '- Vu la demande de démission formulée par l''intéressé';
        Il_est_mis_fin_aux_fonctions_de__CaptionLbl: Label 'Il est mis fin aux fonctions de :';

}

