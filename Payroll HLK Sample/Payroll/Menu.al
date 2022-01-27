pageextension 50120 ExtendNavigationArea extends 9006
{
    CaptionML = ENU = 'RH&PAIE';

    actions
    {
        addfirst(Sections)
        {
            //"suppressWarnings": [ "AL0606", "AL0604" ] 

            group("RH & PAIE")
            {

                group(Personnel)
                {

                    Caption = 'Personnel';

                    action("Salariés")
                    {
                        Image = PersonInCharge;
                        CaptionML = ENU = 'Employe',
                                FRA = 'Salariés';
                        RunObject = Page 5201;
                    }
                    action("Saisie des Absences")
                    {
                        image = Absence;
                        CaptionML = ENU = 'People',
                                FRA = 'Saisie des Absences';
                        RunObject = Page 5212;
                    }
                    action("Saisie des récupérations")
                    {
                        Image = Recalculate;
                        Caption = 'Saisie des récupérations';
                        RunObject = Page 51459;
                    }
                    action("Saisie des indisponibilités")
                    {
                        Image = InactivityDescription;
                        Caption = 'Saisie des indisponibilités';
                        RunObject = Page 51425;
                    }
                    action("Saisie des sanctions")
                    {
                        Image = Error;
                        Caption = 'Saisie des sanctions';
                        RunObject = Page 51423;
                    }
                    action("Prêts")
                    {
                        Image = Prepayment;
                        Caption = 'Prêts';
                        RunObject = Page 51553;
                    }
                    action("Remboursement des frais médicaux")
                    {
                        image = AddToHome;
                        Caption = 'Remboursement des frais médicaux';
                        RunObject = Page 51438;
                    }
                    action("Saisie des souscriptions aux mutuelles/assurances")
                    {
                        Image = Insurance;
                        Caption = 'Saisie des souscriptions aux mutuelles/assurances';
                        RunObject = Page 51479;
                    }
                    action("Saisie des accidents de travail")
                    {
                        Image = DeleteExpiredComponents;
                        RunObject = Page 51465;
                    }
                    action("Saisie et programmation visites médicales ")
                    {
                        image = AddToHome;
                        Caption = 'Saisie et programmation visites médicales';
                        RunObject = Page 51468;
                    }
                    /*action("Visite Médicales 2019")
                    {
                        Caption = 'Visite Médicales 2019';
                        //RunObject = Page 51468;
                        //RunPageView = WHERE(Examination Date=FILTER(01/01/19..31/12/19));
                    }
                    action("Visite Médicales 2020")
                    {
                        Caption = 'Visite Médicales 2020';
                        //RunObject = Page 51468;
                        //RunPageView = WHERE(Examination Date=FILTER(01/01/20..31/12/20));
                    }
                    action("Visite Médicales 2021")
                    {
                        Caption = 'Visite Médicales 2021';
                        //RunObject = Page 51468;
                        //RunPageView = WHERE(Examination Date=FILTER(01/01/21..31/12/21));
                    }*/
                    action("Saisie des vaccins")
                    {
                        RunObject = Page 50093;
                    }
                }
                group("Carrière")
                {
                    Caption = 'Carrière';

                    action("Saisie des affectations salarié")
                    {
                        RunObject = Page 51409;
                        ApplicationArea = All;
                    }
                    action("Expérience salarié")
                    {
                        RunObject = Page 51413;
                    }
                    action("Saisie des contrats de travail")
                    {
                        RunObject = Page 51427;
                    }
                    action("Postes ouverts")
                    {
                        RunObject = Page 51442;
                    }
                    action(Candidats)
                    {
                        RunObject = Page 51444;
                    }
                    action(Candidatures)
                    {
                        RunObject = Page 51450;
                    }
                }

                // Creates a sub-menu
                group(Formation)
                {
                    Caption = 'Formation';
                    action("Etablissements de formation")
                    {
                        RunObject = Page 51400;
                    }
                    action(Formations)
                    {
                        RunObject = Page 51406;
                    }
                    action("Training Request")
                    {
                        Caption = 'Demande de Formation';
                        RunObject = Page 50097;
                        RunPageLink = "Document Type" = CONST(Request);
                        RunPageOnRec = true;
                        RunPageView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST(Request));
                    }
                    action("Inscription de Formation")
                    {
                        RunObject = Page 50097;
                        RunPageLink = "Document Type" = CONST(Registration);
                        RunPageOnRec = true;
                        RunPageView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST(Registration));
                    }
                }
                group(Paie)
                {
                    Caption = 'Paie';
                    action("Saisie des Rubriques Paie")
                    {
                        RunObject = Page 50096;
                    }
                    action("Saisie des heures supplémentaires")
                    {
                        RunObject = Page 51512;
                    }
                    action("Saisie des avances")
                    {
                        RunObject = Page 51535;
                    }
                    action("Saisie des frais de mission et AF")
                    {
                        RunObject = Page 51531;
                    }
                    action("Saisie des congés")
                    {
                        RunObject = Page 51520;
                    }
                }
            }
        }
    }
}