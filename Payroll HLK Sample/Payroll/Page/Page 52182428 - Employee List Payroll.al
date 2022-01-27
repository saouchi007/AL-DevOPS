/// <summary>
/// Page Employee List Payroll (ID 50096).
/// </summary>
page 52182428 "Employee List Payroll"
{
    // version NAVW15.00,HALRHPAIE.6.1.01

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement par direction

    CaptionML = ENU = 'Employee List',
                FRA = 'Liste des salariés';
    CardPageID = "Employee Payroll Items";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = 5200;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No."; "No.")
                {
                }
                field("Structure Description"; "Structure Description")
                {
                }
                field("Section Index"; "Section Index")
                {
                }
                field("Birth Date"; "Birth Date")
                {
                }
                field("Employment Date Init"; "Employment Date Init")
                {
                }
                field("Grounds for Term. Code"; "Grounds for Term. Code")
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Birthplace City"; "Birthplace City")
                {
                }
                field(Address; Address)
                {
                }
                field("Last Name"; "Last Name")
                {
                    Visible = true;
                }
                field("First Name"; "First Name")
                {
                    Visible = true;
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Employer Cotisation %"; "Employer Cotisation %")
                {
                }
                field("Function Code"; "Function Code")
                {
                }
                field(StatutPay; StatutPay)
                {
                }
                field("Birthplace Wilaya Description"; "Birthplace Wilaya Description")
                {
                }
                field("Birthplace Wilaya Code"; "Birthplace Wilaya Code")
                {
                }
                field("No. of Children"; "No. of Children")
                {
                }
                field("Termination Date"; "Termination Date")
                {
                }
                field(Status; Status)
                {
                }
                field("Marital Status"; "Marital Status")
                {
                }
                field(UserPay; UserPay)
                {
                }
                field("Emplymt. Contract Code"; "Emplymt. Contract Code")
                {
                }
                field("Section Grid Class"; "Section Grid Class")
                {
                }
                field("Section Grid Section"; "Section Grid Section")
                {
                }
                field("Section Grid Level"; "Section Grid Level")
                {
                }
                field("Payroll Bank Account No."; "Payroll Bank Account No.")
                {
                }
                field("RIB Key"; "RIB Key")
                {
                }
                field("CCP N"; "CCP N")
                {
                }
                field("Employment Date"; "Employment Date")
                {
                }
                field("Social Security No."; "Social Security No.")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field("Post Code"; "Post Code")
                {
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    Visible = false;
                }
                field(Extension; Extension)
                {
                }
                field("Phone No."; "Phone No.")
                {
                    Visible = false;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    Visible = false;
                }
                field("E-Mail"; "E-Mail")
                {
                    Visible = false;
                }
                field("Statistics Group Code"; "Statistics Group Code")
                {
                    Visible = false;
                }
                field("Resource No."; "Resource No.")
                {
                    Visible = false;
                }
                field("Search Name"; "Search Name")
                {
                }
                field(Comment; Comment)
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Previous IEP"; "Previous IEP")
                {
                }
                field("Current IEP"; "Current IEP")
                {
                }
                field("Socio-Professional Category"; "Socio-Professional Category")
                {
                }
                field(Gender; Gender)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                CaptionML = ENU = 'Géneral',
                             FRA = 'Générale';
                Image = Employee;

                action("Rubriques de paie")
                {
                    Image = ListPage;
                    RunObject = Page 52182524;
                }
                action("Grille des traitements par sections")
                {
                    Caption = 'Grille des traitements par sections';
                    Image = ListPage;
                    RunObject = Page 52182538;
                }
                action("Barème IRG")
                {
                    Image = ListPage;
                    RunObject = Page 52182487;
                }
                action("Barème IEP")
                {
                    Image = ListPage;
                    RunObject = Page 52182537;
                }
                action("Modèle de paie")
                {
                    Image = Template;
                    RunObject = Page 52182555;
                }
                action("Mutuelles/Assurances")
                {
                    Image = ListPage;
                }
                action("Catégories heures supp.")
                {
                    Image = ListPage;
                    RunObject = Page 52182558;
                }
                action("Motifs d'heures supp.")
                {
                    Image = ListPage;

                    RunObject = Page 52182544;
                }
                action("Motifs d'avance")
                {
                    Image = ListPage;
                    RunObject = Page 52182536;
                }
                action("Gestionnaires de paie")
                {
                    Image = ListPage;
                    RunObject = Page 52182559;
                }
                action("Paramètres utilisateur RH")
                {
                    Image = ListPage;
                    RunObject = Page 52182424;
                }
                action(Paies)
                {
                    Image = ListPage;
                    RunObject = Page 52182534;
                }
                action("Comptes bancaires de paie")
                {
                    Image = ListPage;
                    RunObject = Page 52182540;
                }
                action("Unités de mesure paie")
                {
                    Image = Attach;
                    RunObject = Page 52182545;
                }
            }
            group(Historiques)
            {
                Image = History;
                action("Société")
                {
                    Image = Archive;
                    RunObject = Page 52182436;
                }
                action("Paramètres de paie")
                {
                    Image = Agreement;
                    RunObject = Page "Payroll--Setup";
                }
                action("Journaux de paie")
                {
                    Image = Archive;
                    RunObject = Page 52182528;
                }
                action("Journaux de rappel")
                {
                    Image = Archive;
                    RunObject = Page 52182532; //ça fonctionne plus sur NAV
                }
                action("Paies archivées")
                {
                    Image = Archive;
                    RunObject = Page 52182531;
                }
                action("Changements de salaire de base")
                {
                    Image = Archive;
                    RunObject = Page 52182553;
                }
            }
        }
        area(processing)
        {
            group(Général)
            {
                Image = GLAccountBalance;
                CaptionML = ENU = 'General',
                            FRA = 'Générale';
                action("Calcul de la paie")
                {
                    Image = Report2;
                    RunObject = Report "Payroll Calculation";
                }
                action("Génération de la paie")
                {
                    Image = Report2;
                    RunObject = Report "Payroll Generation";
                }
                action("Comptabilisation de la paie")
                {
                    Image = Report2;
                    RunObject = Report "Comptabilisation de la paie";
                }
                action("Clôture de la paie")
                {
                    Image = CashFlow;
                    RunObject = Page 52182583;
                }
                action("Calcul de l'IEP")
                {
                    Image = Card;
                    RunObject = Report "IEP Calculation";
                }
                action("Attribuer une rubrique de paie")
                {
                    Image = Card;
                    RunObject = Report "Assign Payroll Item";
                }
            }
            group("Contrôle de la paie")
            {
                CaptionML = ENU = 'Payroll Control',
                            FRA = 'Contrôle de la paie';
                Image = PayrollStatistics;
                action("Archives de Paie")
                {
                    Image = View;
                    RunObject = Page 52182531;
                }
                action("Vérification de la Paie")
                {
                    Image = Voucher;
                    RunObject = Page 52182582;
                }
                action("Contrôle des données salarié")
                {
                    Image = Voucher;
                    RunObject = Report "Employee Data Control";
                }
                action("Journal d'erreurs paie")
                {
                    Image = Journal;
                    RunObject = Page "Payroll Constatation Warnings";
                }
            }
            group("Congé")
            {
                Image = Holiday;
                CaptionML = ENU = 'Leave',
                            FRA = 'Congé';
                action("Périodes de congé")
                {
                    Image = Period;
                    RunObject = Page 52182546;
                }
                action("Actualisation des congés")
                {
                    Visible = false;
                }
                action("Congé salariés mutés")
                {
                    Image = List;
                    //RunObject = Page 51469;
                    Visible = false;
                }
                action("Calcul du droit au congé")
                {
                    Image = Report2;
                    RunObject = Report "Leave Right Calculation";
                }
                action("Droits au congé")
                {
                    Image = Archive;
                    RunObject = page 52182548;

                    /*trigger OnAction();
                    begin
                        DroitConge.RESET;
                        DroitConge.SETRANGE("Employee No.", Rec."No.");
                        IF DroitConge.FINDFIRST THEN BEGIN
                            REPEAT
                                DroitConge.CALCFIELDS("No. of Consumed Days");
                                DroitConge.Difference := DroitConge."No. of Days" - DroitConge."No. of Consumed Days";
                                DroitConge.MODIFY;
                            UNTIL DroitConge.NEXT = 0;
                            COMMIT;
                            PAGE.RUNMODAL(51518, DroitConge);
                        END;
                    end;*/
                }
            }
        }
        area(Reporting)
        {
            group(General)
            {
                Image = GeneralLedger;
                CaptionML = ENU = 'General',
                            FRA = 'Générale';
                action("Absences by Ca&tegories")
                {
                    CaptionML = ENU = 'Absences by Ca&tegories',
                                FRA = 'Bulletin de paie';
                    Image = Report2;
                    RunObject = Report "Bulletin de paie Personnalisé";
                    RunPageOnRec = true;
                }
                action("Livre de paie")
                {
                    CaptionML = ENU = 'Misc. Articles &Overview',
                                FRA = 'Livre de paie';
                    Image = Report2;
                    RunObject = Report "Journal de paie";
                }
                action("Journal de paie")
                {
                    CaptionML = ENU = 'Con&fidential Info. Overview',
                                FRA = 'Journal de paie';
                    Image = ConfidentialOverview;
                    RunObject = Report "Payroll Book";
                }
                action("Fiche Fiscale")
                {
                    Image = "Report";
                    RunObject = Report "Fiche fiscale";
                }
                action("Etat récapitulatif de paie")
                {
                    Image = "Report";
                    RunObject = Report "Ventilation comptable";
                }
                action("Etat statistique")
                {
                    Image = "Report";
                    RunObject = Report "Etat statistique";
                }
                action("Masse Salariale")
                {
                    Image = "Report";
                    RunObject = Report "Masse salariale par filtres";
                }
                action("Titre de congé")
                {
                    Image = "Report";
                    RunObject = Report "Employee - Addresses";
                }
                action("Avances salarie")
                {
                    Image = "Report";
                    RunObject = Report "Avances salarie";
                    Scope = Page;
                }
                action("Relevé des émoluments")
                {
                    Image = "Report";
                    RunObject = Report "Relevé des émoluments- Nouveau";
                }
                action("Etat des prêts")
                {
                    Image = "Report";

                    RunObject = Report "Lending List";
                }

            }
            group(Virement)
            {
                Image = PaymentJournal;
                action("Etat de paiement")
                {
                    Image = Report2;
                    RunObject = Report "Etat de paiement";
                }
                action("Etat de virement SGA")
                {
                    Image = Report2;
                    RunObject = Report "Etat de virement";
                }
                action("Etat de virement CPA")
                {
                    Image = Report2;
                    //RunObject = Page 50021;
                }
                action("DAS & DAS Cacobatph")
                {
                    Caption = 'DAS & DAS Cacobatph';
                    Image = Report2;
                    //RunObject = Page 51562;
                }
                action("Etat de virement Global")
                {
                    Image = Report2;
                }
                action("Récap des virements")
                {
                    Image = Report2;
                    RunObject = Report "Récap des virements";
                }
                action("Etat de virement EDI")
                {
                    Image = Report2;
                    //RunObject = Report 50089;
                }
                group(Rappels)
                {
                }
            }
            group("Déclarations mensuelles")
            {
                CaptionML = ENU = 'Mensual Declaration',
                            FRA = 'GénéraleDéclarations mensuelles';
                Image = MovementWorksheet;
                action("Déclaration de cotisations")
                {
                    Image = "Report";
                    RunObject = Report "Déclaration de cotisations";
                }
                action("Déclaration de cotisations après clôture")
                {
                    Caption = 'Déclaration de cotisations après clôture';
                    Image = "Report";
                }
                action("Etat des mouvements des salariés")
                {
                    Image = "Report";
                    RunObject = Report "Etat des mouv des salariés";
                }
                action("Oeuvres sociales")
                {
                    Image = "Report";
                    RunObject = Report "Etat des oeuvres sociales";
                }
                action("Bordereau des Cotisations")
                {
                    Image = "Report";
                    RunObject = Report "Bordereau des Cotisations";
                }
                action("Récap des charges sociales")
                {
                    Image = "Report";
                    RunObject = Report "Etat des charges sociales";
                }
                action("Etat cotisations patronales")
                {
                    Image = "Report";
                    RunObject = Report "Etat cotisations patronales";
                }
                action("Relevé cotisations mutuelles")
                {
                    Image = "Report";
                    //RunObject = Report 51414;
                }
            }
            group("Déclarations annuelles")
            {
                CaptionML = ENU = 'Annual Declaration',
                            FRA = 'GénéraleDéclarations annuelles';
                Image = MovementWorksheet;

                action("301 Bis")
                {
                    Image = Report2;
                    //RunObject = Report 51433;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        RESET;
        FILTERGROUP(6);
        ParamRH.GET;
        //IF ParamRH."Show Only Active Employees"THEN
        SETRANGE(Status, Status::Active);

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text02);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            //FILTERGROUP(2);
            SETRANGE("Company Business Unit Code", ParamUtilisateur."Company Business Unit");
        END;
        //+++01+++

        FILTERGROUP(0);
    end;

    var
        ParamRH: Record 5218;
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        Text02: Label 'Utilisateur %1 non configuré !';
        Text03: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        DroitConge: Record "Leave Right";
}

