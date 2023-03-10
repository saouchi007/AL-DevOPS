/// <summary>
/// Report Decision de Promotion (ID 52182451).
/// </summary>
report 52182451 "Decision de Promotion"
{
    // version HALRHPAIE.6.2.00

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Decision de Promotion.rdl';

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
            column(Clause6; Clause6)
            {
            }
            column(Clause5; Clause5)
            {
            }
            column(Clause4; Clause4)
            {
            }
            column(Clause3; Clause3)
            {
            }
            column(Clause2; Clause2)
            {
            }
            column(Clause1; Clause1)
            {
            }
            column(Clause7; Clause7)
            {
            }
            column(Clause8; Clause8)
            {
            }
            column(Clause10; Clause10)
            {
            }
            column(Clause9; Clause9)
            {
            }
            column(PeriodeEssai; PeriodeEssai)
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
            column("Est_mis_??_l_essai_pour_une_dur??e_de________________mois_au_poste_de__Caption"; Est_mis_??_l_essai_pour_une_dur??e_de________________mois_au_poste_de__CaptionLbl)
            {
            }
            column("Vu_la_loi_n__90_11_du_21_04_90__modifi??e_et_compl??t??e__relative_aux_relations_de_travail_Caption"; Vu_la_loi_n__90_11_du_21_04_90__modifi??e_et_compl??t??e__relative_aux_relations_de_travail_CaptionLbl)
            {
            }
            column(DataItem1000000005; Vu_le_statut_de_la_Srl)
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
            column("Class??_??_la_Caption"; Class??_??_la_CaptionLbl)
            {
            }
            column(relevant_de_la_Caption; relevant_de_la_CaptionLbl)
            {
            }
            column(DataItem1000000023; A_l_issue_de_la_p??riode_d_essai)
            {
            }
            column(Copies_Caption; Copies_CaptionLbl)
            {
            }
            column("Int??ress??__e_Caption"; Int??ress??__e_CaptionLbl)
            {
            }
            column(SP_Dossier__Caption; SP_Dossier__CaptionLbl)
            {
            }
            column(L_employeurCaption; L_employeurCaptionLbl)
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
                Class := 'Cat??gorie ' + EmployeeAssig.Class + ' Section ' + EmployeeAssig.Section;
                REPEAT
                    IF EmployeeAssig."Ending Date" > Date THEN BEGIN
                        Fonction := EmployeeAssig."Function Description";
                        Affect := EmployeeAssig."Structure Description";
                        Class := 'Cat??gorie ' + EmployeeAssig.Class + ' Section ' + EmployeeAssig.Section;
                        Date := EmployeeAssig."Ending Date";
                    END;
                UNTIL EmployeeAssig.NEXT = 0;

                //clauses de remuneration
                ClauseRemuneration.RESET;
                ClauseRemuneration.SETRANGE("Employee No.", "No.");
                ClauseRemuneration.SETFILTER("Item Code", '<>%1&<>%2&<>%3&<>%4&<>%5&<>%6&<>%7&<>%8&<>%9',
                '001', '500', '501', '600', '601', '999', '999 B', '999 P', '669');
                IF ClauseRemuneration.FINDFIRST THEN
                    Clause1 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);
                IF ClauseRemuneration.NEXT <> 0 THEN
                    Clause2 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);
                IF ClauseRemuneration.NEXT <> 0 THEN
                    Clause3 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);
                IF ClauseRemuneration.NEXT <> 0 THEN
                    Clause4 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);
                IF ClauseRemuneration.NEXT <> 0 THEN
                    Clause5 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);
                IF ClauseRemuneration.NEXT <> 0 THEN
                    Clause6 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);
                IF ClauseRemuneration.NEXT <> 0 THEN
                    Clause7 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);
                IF ClauseRemuneration.NEXT <> 0 THEN
                    Clause8 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);
                IF ClauseRemuneration.NEXT <> 0 THEN
                    Clause9 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);
                IF ClauseRemuneration.NEXT <> 0 THEN
                    Clause10 := ClauseRemuneration.Description + ' ' + FORMAT(ClauseRemuneration.Amount);



                parampaye.GET;
                IF parampaye."Treatment Grid Type" = parampaye."Treatment Grid Type"::Sections THEN BEGIN
                    Texte1 := 'Classe: ' + FORMAT(Employee."Section Grid Class") + ',  Section :' + ' ' + FORMAT(Employee."Section Grid Section");
                END;

                IF parampaye."Treatment Grid Type" = parampaye."Treatment Grid Type"::"Hourly Index" THEN BEGIN
                    Texte1 := Employee."Hourly Index Grid CH" + ',    Echelon :' + ' ' + FORMAT(Employee."Hourly Index Grid Index") +
                    ' de la grille des salaires de l''entreprise.';
                    Texte4 := FORMAT(ROUND(Employee."Base salary")) + '  DA';
                END;

                Texte2 := 'la r??mun??ration de l''int??ress?? s''??tablit comme suit : ';

                Texte3 := 'Messieurs les Directeurs des Ressources Humaines et' + ' ' + Employee."Structure Description" + ' sont charg??s chacun';
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
        PeriodeEssai := 'Trois (03)';
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
        ClauseRemuneration: Record "Terms of pay";
        Clause1: Text[80];
        Clause2: Text[80];
        Clause3: Text[80];
        Clause4: Text[80];
        Clause5: Text[80];
        Clause6: Text[80];
        Clause7: Text[80];
        Clause8: Text[80];
        Clause9: Text[80];
        Clause10: Text[80];
        PeriodeEssai: Text[30];
        DECISION_N_CaptionLbl: Label 'DECISION N??';
        SERVICE_DU_PERSONNELCaptionLbl: Label 'SERVICE DU PERSONNEL';
        DIRECTION_DES_RESSOURCES_HUMAINESCaptionLbl: Label 'DIRECTION DES RESSOURCES HUMAINES';
        Article_1__CaptionLbl: Label 'Article 1 :';
        Article_2__CaptionLbl: Label 'Article 2 :';
        Article_3__CaptionLbl: Label 'Article 3 :';
        Fonction__CaptionLbl: Label 'Fonction :';
        Affectation__CaptionLbl: Label 'Affectation :';
        "Est_mis_??_l_essai_pour_une_dur??e_de________________mois_au_poste_de__CaptionLbl": Label 'Est mis ?? l''essai pour une dur??e de                mois au poste de :';
        "Vu_la_loi_n__90_11_du_21_04_90__modifi??e_et_compl??t??e__relative_aux_relations_de_travail_CaptionLbl": Label '- Vu la loi n?? 90-11 du 21/04/90, modifi??e et compl??t??e, relative aux relations de travail,';
        "Vu_le_statut_de_la_Srl": Label '- Vu le statut de la Sarl "  yaourt Soummam ", ??tabli devant Ma??tre IBERAKEN Idir le 23/12/1996, modifi?? et compl??t??';
        "Vu_le_r??glement_int??rieur_de_la_sarl_Laiterie": Label '- Vu le r??glement int??rieur de la sarl Laiterie Soummam, d??pos?? le 03/05/1999 et enregistr?? aupr??s du tribunal d''Akbou sous le N??02/99, modifi?? le 18/05/99 et enregistr?? sous le N??136/99,';
        "Sur_proposition_du_Responsable_Hi??rarchique__CaptionLbl": Label '"- Sur proposition du Responsable Hi??rarchique ;"';
        DECIDECaptionLbl: Label 'DECIDE';
        "Vu_le_contrat_de_travail_de_l_int??ress??__CaptionLbl": Label '"- Vu le contrat de travail de l''int??ress??, "';
        "Le_G??rant_CaptionLbl": Label 'Le G??rant,';
        Classification__CaptionLbl: Label 'Classification :';
        "Class??_??_la_CaptionLbl": Label '"Class?? ?? la "';
        relevant_de_la_CaptionLbl: Label '"relevant de la "';
        "A_l_issue_de_la_p??riode_d_essai": Label 'A l''issue de la p??riode d''essai, si les r??sultats sont satisfaisants, il sera confirm??  ?? ce poste. Le cas contraire, il sera revers?? ?? son poste d''origine ou ?? un poste  r??pondant ?? son profil.';
        Copies_CaptionLbl: Label 'Copies:';
        "Int??ress??__e_CaptionLbl": Label '- Int??ress?? (e)';
        SP_Dossier__CaptionLbl: Label '"- SP/Dossier  "';
        L_employeurCaptionLbl: Label 'L''employeur';

}

