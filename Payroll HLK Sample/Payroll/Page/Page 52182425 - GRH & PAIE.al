/// <summary>
/// Page GRH & PAIE (ID 52182425).
/// </summary>
page 52182425 "GRH & PAIE"
{
    // version NAVW19.00.00.44974,RHPAIEKarim

    CaptionML = ENU = 'Role Center',
                FRA = 'Tableau de bord';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                /*   part("My Employee";"My Employee")
                 {
                     Visible = false;
                 }*/
                part("Resource Manag Activities_EXT"; "Resource Manag Activities_EXT")
                {
                    ApplicationArea = Advanced;
                }
            }
            group(Control1900724708)
            {
                Caption = 'Nounou';
                part("My Job queue"; 675)
                {
                    Visible = false;
                }
                part("Report nbox Part"; 681)
                {
                    Visible = false;
                }
                systempart("MyNotes"; MyNotes)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            action("Salariés.")
            {
                Caption = 'Salariés';
                RunObject = Page 5201;
            }
            action("Saisie des congés.")
            {
                Caption = 'Saisie des congés';
                RunObject = Page 52182550;
            }
            action("import données")
            {
                Image = Import;
                Promoted = true;
                RunObject = Page 8615;
                RunPageView = WHERE(Code = CONST());
            }
        }
        area(Sections)
        {
            group(Personnel)
            {
                Caption = 'Personnel';
                Image = HumanResources;
                action("Salariés")
                {
                    CaptionML = ENU = 'Employe',
                                FRA = 'Salariés';
                    RunObject = Page 5201;
                }
                action("Saisie des Absences")
                {
                    CaptionML = ENU = 'People',
                                FRA = 'Saisie des Absences';
                    RunObject = Page 5212;
                }
                action("Saisie des récupérations")
                {
                    Caption = 'Saisie des récupérations';
                    RunObject = Page 52182494;
                }
                action("Saisie des indisponibilités")
                {
                    Caption = 'Saisie des indisponibilités';
                    RunObject = Page 52182460;
                }
                action("Saisie des sanctions")
                {
                    Caption = 'Saisie des sanctions';
                    RunObject = Page 52182458;
                }
                action("Prêts")
                {
                    Caption = 'Prêts';
                    RunObject = Page 52182575;
                }
                action("Remboursement des frais médicaux")
                {
                    Caption = 'Remboursement des frais médicaux';
                    RunObject = Page 52182473;
                }
                action("Saisie des souscriptions aux mutuelles/assurances")
                {
                    Caption = 'Saisie des souscriptions aux mutuelles/assurances';
                    RunObject = Page 52182513;
                }
                action("Saisie des accidents de travail")
                {
                    RunObject = Page 52182500;
                }
                action("Saisie et programmation visites médicales ")
                {
                    Caption = 'Saisie et programmation visites médicales';
                    RunObject = Page 52182503;
                }

                action("Saisie des vaccins")
                {
                    RunObject = Page 52182426;
                }
            }
            group("Carrière")
            {
                Caption = 'Carrière';

                action("Saisie des affectations salarié")
                {
                    RunObject = Page 52182444;
                    ApplicationArea = All;
                }
                action("Expérience salarié")
                {
                    RunObject = Page 52182448;
                }
                action("Saisie des contrats de travail")
                {
                    RunObject = Page 52182462;
                }
                action("Postes ouverts")
                {
                    RunObject = Page 52182477;
                }
                action(Candidats)
                {
                    RunObject = Page 52182479;
                }
                action(Candidatures)
                {
                    RunObject = Page 52182485;
                }
            }
            group(Formation)
            {
                Caption = 'Formation';
                action("Etablissements de formation")
                {
                    RunObject = Page 52182435;
                }
                action(Formations)
                {
                    RunObject = Page 52182509;
                }
                action("Training Request")
                {
                    Caption = 'Demande de Formation';
                    RunObject = Page 52182429;
                    RunPageLink = "Document Type" = CONST(Request);
                    RunPageOnRec = true;
                    RunPageView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST(Request));
                }
                action("Inscription de Formation")
                {
                    RunObject = Page 52182429;
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
                    RunObject = Page 52182428;
                }
                action("Saisie des heures supplémentaires")
                {
                    RunObject = Page 52182542;
                }
                action("Saisie des avances")
                {
                    RunObject = Page 52182561;
                }
                action("Saisie des frais de mission et AF")
                {
                    RunObject = Page 52182560;
                }
                action("Saisie des congés")
                {
                    RunObject = Page 52182550;
                }
            }
        }
    }
}

