/// <summary>
/// Report Decision de Confirmation (ID 52182450).
/// </summary>
report 52182450 "Decision de Confirmation"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Decision de Confirmation.rdl';

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
            column(Texte1; Texte1)
            {
            }
            column(Texte2; Texte2)
            {
            }
            column(Texte3; Texte3)
            {
            }
            column(Class; Class)
            {
            }
            column(Employee_Employee__Structure_Description_; Employee."Structure Description")
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
            column(Article_3__Caption; Article_3__CaptionLbl)
            {
            }
            column(Fonction__Caption; Fonction__CaptionLbl)
            {
            }
            column(Affectation__Caption; Affectation__CaptionLbl)
            {
            }
            column("Est_affect??_au_posteCaption"; Est_affect??_au_posteCaptionLbl)
            {
            }
            column("Vu_la_loi_n__90_11_du_21_04_90__modifi??e_et_compl??t??e__relative_aux_relations_de_travail_Caption"; Vu_la_loi_n__90_11_du_21_04_90__modifi??e_et_compl??t??e__relative_aux_relations_de_travail_CaptionLbl)
            {
            }
            column(DataItem1000000005; Vu_le_statut_de_la_Sarl)
            {
            }
            column(DataItem1000000007; Vu_le_r??glement_int??rieur_de_la_sarl_Laiterie)
            {
            }
            column("Sur_proposition_du_Responsable_Hi??rarchique__Caption"; Sur_proposition_du_Responsable_Hi??rarchique__CaptionLbl)
            {
            }
            column(DECIDECaption; DECIDECaptionLbl)
            {
            }
            column("Vu_le_contrat_de_travail_de_l_int??ress??__Caption"; Vu_le_contrat_de_travail_de_l_int??ress??__CaptionLbl)
            {
            }
            column("Le_G??rant_Caption"; Le_G??rant_CaptionLbl)
            {
            }
            column(Classification__Caption; Classification__CaptionLbl)
            {
            }
            column(Classification__Caption_Control1000000035; Classification__Caption_Control1000000035Lbl)
            {
            }
            column(Affectation__Caption_Control1000000036; Affectation__Caption_Control1000000036Lbl)
            {
            }
            column(Copies_Caption; Copies_CaptionLbl)
            {
            }
            column("Int??ress??__e_Caption"; Int??ress??__e_CaptionLbl)
            {
            }
            column(Dossier_du_personnelCaption; Dossier_du_personnelCaptionLbl)
            {
            }
            column(LE_DIRECTEUR_GENERALCaption; LE_DIRECTEUR_GENERALCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                Unite.FINDFIRST;
                //test
                Employee.Get("No.");
                //test
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
                EmployeeAssig.FindFirst;
                Date := EmployeeAssig."Ending Date";
                Fonction := EmployeeAssig."Function Description";
                Affect := EmployeeAssig."Structure Description";
                Class := 'Cat??gorie ' + EmployeeAssig.Class + ' Section ' + EmployeeAssig.Section;
                REPEAT
                    IF EmployeeAssig."Ending Date" > Date THEN BEGIN
                        Fonction := EmployeeAssig."Function Description";
                        Affect := EmployeeAssig."Structure Description";
                        Class := 'Cat??gorie ' + EmployeeAssig.Class + ' Section ' + EmployeeAssig.Section;
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

                Texte2 := 'Il lui est attribu?? ' + Primes + '.';

                Texte3 := 'Messieurs les Directeurs des Ressources Humaines et' + ' ' + Employee."Structure Description" + ' sont charg??s chacun ';
                Texte3 := Texte3 + 'en ce qui le concerne de l''ex??cution de la pr??sente d??cision qui prend effet ?? compter du' + ' ';
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
            ERROR('Veuillez saisir le lieu et la Date d''??dition dans l''onglet Options');
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
        DECISION_N_CaptionLbl: Label 'DECISION N??';
        SERVICE_DU_PERSONNELCaptionLbl: Label 'SERVICE DU PERSONNEL';
        DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DIRECTION DES RESSOURCES HUMAINES';
        Article_1__CaptionLbl: Label 'Article 1 :';
        Article_2__CaptionLbl: Label 'Article 2 :';
        Article_3__CaptionLbl: Label 'Article 3 :';
        Fonction__CaptionLbl: Label 'Fonction :';
        Affectation__CaptionLbl: Label 'Affectation :';
        "Est_affect??_au_posteCaptionLbl": Label 'Est affect?? au poste';
        "Vu_la_loi_n__90_11_du_21_04_90__modifi??e_et_compl??t??e__relative_aux_relations_de_travail_CaptionLbl": Label '- Vu la loi n?? 90-11 du 21/04/90, modifi??e et compl??t??e, relative aux relations de travail,';
        "Vu_le_statut_de_la_Sarl": Label '- Vu le statut de la Sarl "  yaourt Soummam ", ??tabli devant Ma??tre IBERAKEN Idir le 23/12/1996, modifi?? et compl??t??.';
        "Vu_le_r??glement_int??rieur_de_la_sarl_Laiterie": Label '- Vu le r??glement int??rieur de la sarl Laiterie Soummam, d??pos?? le 03/05/1999 et enregistr?? aupr??s du tribunal d''Akbou sous le N??02/99, modifi?? le 18/05/99 et enregistr?? sous le N??136/99,';
        "Sur_proposition_du_Responsable_Hi??rarchique__CaptionLbl": Label '"- Sur proposition du Responsable Hi??rarchique ;"';
        DECIDECaptionLbl: Label 'DECIDE';
        "Vu_le_contrat_de_travail_de_l_int??ress??__CaptionLbl": Label '"- Vu le contrat de travail de l''int??ress??, "';
        "Le_G??rant_CaptionLbl": Label 'Le G??rant,';
        Classification__CaptionLbl: Label 'Classification :';
        Classification__Caption_Control1000000035Lbl: Label 'Classification :';
        Affectation__Caption_Control1000000036Lbl: Label 'Affectation :';
        Copies_CaptionLbl: Label 'Copies:';
        "Int??ress??__e_CaptionLbl": Label '- Int??ress?? (e)';
        Dossier_du_personnelCaptionLbl: Label '- Dossier du personnel';
        LE_DIRECTEUR_GENERALCaptionLbl: Label 'LE DIRECTEUR GENERAL';

}

