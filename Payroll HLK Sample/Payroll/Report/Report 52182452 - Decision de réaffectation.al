/// <summary>
/// Report Decision de réaffectation (ID 51439).
/// </summary>
report 52182452 "Decision de réaffectation"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Decision de réaffectation.rdl';

    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
            column(NumRef; NumRef)
            {
            }
            column(NomEntreprise; NomEntreprise)
            {
            }
            column(Sexe; Sexe)
            {
            }
            column(Nom; Nom)
            {
            }
            column(Fonction; Fonction)
            {
            }
            column(Affect; Affect)
            {
            }
            column(Employee_Employee__Function_Description_; Employee."Job Title")
            {
            }
            column(Texte3; Texte3)
            {
            }
            column(Employee_Employee__Structure_Description_; Employee."Structure Description")
            {
            }
            column(Employee_Employee__Structure_Description__Control1000000011; Employee."Structure Description")
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
            column(Article_1__Caption; Article_1__CaptionLbl)
            {
            }
            column(Article_2__Caption; Article_2__CaptionLbl)
            {
            }
            column(Fonction__Caption; Fonction__CaptionLbl)
            {
            }
            column(Affectation__Caption; Affectation__CaptionLbl)
            {
            }
            column("Est_affecté_au_posteCaption"; Est_affecté_au_posteCaptionLbl)
            {
            }
            column(DECIDECaption; DECIDECaptionLbl)
            {
            }
            column("Vu_la_loi_n__90_11_du_21_04_90__modifiée_et_complétée__relative_aux_relations_de_travail_Caption"; Vu_la_loi_n__90_11_du_21_04_90__modifiée_et_complétée__relative_aux_relations_de_travail_CaptionLbl)
            {
            }
            column(DataItem1000000005; Vu_le_statut_de_la_Sarl)
            {
            }
            column(DataItem1000000007; Vu_le_règlement_intérieur_de_la_sarl_Laiterie)
            {
            }
            column("Vu_la__nécessité_de_service_Caption"; Vu_la__nécessité_de_service_CaptionLbl)
            {
            }
            column(Vu_la_nouvelle_organisation_de_la_structureCaption; Vu_la_nouvelle_organisation_de_la_structureCaptionLbl)
            {
            }
            column("Sur_proposition_de_la_Direction_Générale_Caption"; Sur_proposition_de_la_Direction_Générale_CaptionLbl)
            {
            }
            column(LE_DIRECTEUR_GENERALCaption; LE_DIRECTEUR_GENERALCaptionLbl)
            {
            }
            column(SP_DossierCaption; SP_DossierCaptionLbl)
            {
            }
            column("Intéressé__e_Caption"; Intéressé__e_CaptionLbl)
            {
            }
            column(Ampliation___Caption; Ampliation___CaptionLbl)
            {
            }
            column("Direction_GénéraleCaption"; Direction_GénéraleCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                Unite.FINDFIRST;
                Employee.Get("No.");

                IF Employee.Gender = Employee.Gender::Female THEN BEGIN
                    IF Employee."Marital Status" = Employee."Marital Status"::Married THEN BEGIN
                        Sexe := 'Madame :';
                    END
                    ELSE BEGIN
                        Sexe := 'Mlle';
                    END;
                END;

                IF Employee.Gender = Employee.Gender::Male THEN
                    Sexe := 'Monsieur :';


                Nom := Employee."Last Name" + ' ' + Employee."First Name";

                EmployeeAssig.SETRANGE("Employee No.", Employee."No.");
                EmployeeAssig.SETRANGE("Ending Date");
                EmployeeAssig.FINDFIRST;
                Date := EmployeeAssig."Ending Date";
                Fonction := EmployeeAssig."Function Description";
                Affect := EmployeeAssig."Structure Description";
                Class := 'Catégorie ' + EmployeeAssig.Class + ' Section ' + EmployeeAssig.Section;
                REPEAT
                    IF EmployeeAssig."Ending Date" > Date THEN BEGIN
                        Fonction := EmployeeAssig."Function Description";
                        Affect := EmployeeAssig."Structure Description";
                        Class := 'Catégorie ' + EmployeeAssig.Class + ' Section ' + EmployeeAssig.Section;
                        Date := EmployeeAssig."Ending Date";
                    END;
                UNTIL EmployeeAssig.NEXT = 0;


                parampaye.GET;
                IF parampaye."Treatment Grid Type" = parampaye."Treatment Grid Type"::Sections THEN BEGIN
                    Texte1 := 'Classe: ' + FORMAT(Employee."Section Grid Class") + ',  Section :' + ' ' + FORMAT(Employee."Section Grid Section");
                END;

                IF parampaye."Treatment Grid Type" = parampaye."Treatment Grid Type"::"Hourly Index" THEN BEGIN
                    Texte1 := Employee."Hourly Index Grid CH" + ',    Echelon :' + ' ' + FORMAT(Employee."Hourly Index Grid Index") +
                    ' de la grille des salaires de l''entreprise.';
                    Texte4 := FORMAT(ROUND(Employee."Base salary")) + '  DA';
                END;

                Texte2 := 'Il lui est attribué ' + Primes + '.';

                Texte3 := 'Messieurs les Directeurs des Ressources Humaines et' + ' ' + Employee."Structure Description" + ' sont chargés chacun';
                Texte3 := Texte3 + 'en ce qui le concerne de l''exécution de la présente décision qui prend effet à compter du' + ' ';
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
        Texte1: Text[120];
        parampaye: Record Payroll_Setup;
        Texte2: Text[200];
        Texte3: Text[200];
        Texte4: Text[200];
        Texte5: Text[200];
        Date: Date;
        ParamUtilisateur: Record 91;
        ImpDate: Date;
        Lieu: Text[30];
        TexteDate: Text[50];
        Primes: Text[250];
        Class: Text[100];
        NumRef: Text[30];
        NomEntreprise: Text[30];
        DECISION_N_CaptionLbl: Label 'DECISION N°';
        SERVICE_DU_PERSONNELCaptionLbl: Label 'SERVICE DU PERSONNEL';
        DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DIRECTION DES RESSOURCES HUMAINES';
        Article_1__CaptionLbl: Label 'Article 1 :';
        Article_2__CaptionLbl: Label 'Article 2 :';
        Fonction__CaptionLbl: Label 'Fonction :';
        Affectation__CaptionLbl: Label 'Affectation :';
        "Est_affecté_au_posteCaptionLbl": Label 'Est affecté au poste';
        DECIDECaptionLbl: Label 'DECIDE';
        "Vu_la_loi_n__90_11_du_21_04_90__modifiée_et_complétée__relative_aux_relations_de_travail_CaptionLbl": Label '- Vu la loi n° 90-11 du 21/04/90, modifiée et complétée, relative aux relations de travail,';
        "Vu_le_statut_de_la_Sarl": Label '- Vu le statut de la Sarl "  yaourt Soummam ", établi devant Maître IBERAKEN Idir le 23/12/1996, modifié et complété';
        "Vu_le_règlement_intérieur_de_la_sarl_Laiterie": Label '- Vu le règlement intérieur de la sarl Laiterie Soummam, déposé le 03/05/1999 et enregistré auprès du tribunal d''Akbou sous le N°02/99, modifié le 18/05/99 et enregistré sous le N°136/99,';
        "Vu_la__nécessité_de_service_CaptionLbl": Label '- Vu la  nécessité de service,';
        Vu_la_nouvelle_organisation_de_la_structureCaptionLbl: Label '- Vu la nouvelle organisation de la structure';
        "Sur_proposition_de_la_Direction_Générale_CaptionLbl": Label '- Sur proposition de la Direction Générale,';
        LE_DIRECTEUR_GENERALCaptionLbl: Label 'LE DIRECTEUR GENERAL';
        SP_DossierCaptionLbl: Label '- SP/Dossier';
        "Intéressé__e_CaptionLbl": Label '- Intéressé (e)';
        Ampliation___CaptionLbl: Label '"Ampliation : "';
        "Direction_GénéraleCaptionLbl": Label '- Direction Générale';

}

