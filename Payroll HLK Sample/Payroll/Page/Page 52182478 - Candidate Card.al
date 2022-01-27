/// <summary>
/// Page Candidate Card (ID 51443).
/// </summary>
page 52182478 "Candidate Card"
{
    // version HALRHPAIE.6.2.01

    CaptionML = ENU = 'Candidate Card',
                FRA = 'Fiche candidat';
    PageType = Card;
    SourceTable = Candidate;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General',
                            FRA = 'Général';
                field("No."; "No.")
                {

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                    CaptionML = ENU = 'Middle Name',
                                FRA = 'Nom de jeune fille';
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                    CaptionML = ENU = 'Post Code/City',
                                FRA = 'CP/Ville';
                }
                field(City; City)
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Search Name"; "Search Name")
                {
                }
                field(Sex; Sex)
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field(Picture; Picture)
                {
                }
            }
            group(Communication)
            {
                CaptionML = ENU = 'Communication',
                            FRA = 'Communication';
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
            }
            group(Personal)
            {
                CaptionML = ENU = 'Personal',
                            FRA = 'Personnel';
                field("Birth Date"; "Birth Date")
                {
                }
                field("Birthplace Post Code"; "Birthplace Post Code")
                {
                    CaptionML = ENU = 'Post Code/City Birthplace',
                                FRA = 'CP/Ville Lieu de naissance';
                }
                field("Birthplace City"; "Birthplace City")
                {
                }
                field("Marital Status"; "Marital Status")
                {
                }
                field("Nationality Code"; "Nationality Code")
                {
                }
                field("Military Situation"; "Military Situation")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Candidate")
            {
                CaptionML = ENU = '&Candidate',
                            FRA = '&Candidat';
                Image = ExportSalesPerson;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), //Const(12)
                                  "No." = FIELD("No.");
                }
                action("&Picture")
                {
                    CaptionML = ENU = '&Picture',
                                FRA = 'Photo';
                    Image = Picture;
                    RunObject = Page 52182483;
                    RunPageLink = "No." = FIELD("No.");
                }
                action("&Relatives")
                {
                    CaptionML = ENU = '&Relatives',
                                FRA = 'Lien&s de parenté';
                    Image = Relatives;
                    RunObject = Page 52182481;
                    RunPageLink = "Candidate No." = FIELD("No.");
                }
                action("Q&ualifications")
                {
                    CaptionML = ENU = 'Q&ualifications',
                                FRA = 'Qualifications';
                    Image = QualificationOverview;
                    RunObject = Page 52182480;
                    RunPageLink = "Candidate No." = FIELD("No.");
                }
                action("&Diplomas")
                {
                    CaptionML = ENU = '&Diplomas',
                                FRA = '&Diplômes';
                    Image = Card;
                    RunObject = Page 52182482;
                    RunPageLink = "Candidate No." = FIELD("No.");
                }
                action("Expérience")
                {
                    Caption = 'Expérience';
                    Image = Timesheet;
                    RunObject = Page 52182486;
                }
            }
            group(fonctions)
            {
                Caption = 'Fonctions';
                Image = Job;
                separator("---------------------------------")
                {
                    Caption = '---------------------------------';
                }
                action("Créer Fiche Salarié")
                {
                    Caption = 'Créer Fiche Salarié';
                    Image = Employee;

                    trigger OnAction();
                    begin
                        CLEAR(employe);
                        BEGIN

                            IF "fiche créée" THEN ok1 := CONFIRM(text012, TRUE) ELSE ok2 := CONFIRM(text011);

                            IF ok1 OR ok2 THEN BEGIN
                                employe.INIT;
                                employe."First Name" := "First Name";
                                employe."Last Name" := "Last Name";
                                employe.Address := xRec.Address;
                                employe."Address 2" := "Address 2";
                                employe.City := City;
                                employe."Post Code" := "Post Code";
                                employe.County := County;
                                employe."Phone No." := "Phone No.";
                                employe."Mobile Phone No." := "Mobile Phone No.";
                                employe."E-Mail" := "E-Mail";
                                employe."Birth Date" := "Birth Date";
                                employe.Gender := Sex;
                                employe."Country/Region Code" := "Country/Region Code";
                                employe."Marital Status" := "Marital Status";
                                //employe."Nombre d'enfants":="Nombre d'enfants";
                                //employe."Chef de famille":="Chef de famille";
                                //employe."Military Situation":="Service Militaire";
                                //employe.Fumeur:=Fumeur;
                                //employe."Type Permis de Conduire":="Type Permis de Conduire";
                                //employe."Date Obtention":="Date Obtention";
                                employe.Picture := Picture;
                                employe.Status := 0;

                                employe.INSERT(TRUE);

                                CurrPage.EDITABLE := TRUE;
                                "fiche créée" := TRUE;
                                MODIFY;
                                CurrPage.EDITABLE := FALSE;

                                CopierDiplomes;
                                CopierLiens;
                                CopierQualifications;
                                CopierExpérience;

                                PAGE.RUN(5200, employe);

                            END;
                        END;
                    end;
                }
                separator("----------------------------------")
                {
                    Caption = '----------------------------------';
                }
            }
        }
    }

    trigger OnInit();
    begin
        MapPointVisible := TRUE;
    end;

    trigger OnOpenPage();
    var
        MapMgt: Codeunit 802;
    begin

        IF NOT MapMgt.TestSetup THEN
            MapPointVisible := FALSE;
    end;

    var
        Mail: Codeunit 397;
        employe: Record 5200;
        PictureExists: Boolean;
        ok1: Boolean;
        ok2: Boolean;
        Text001: TextConst ENU = 'Do you want to replace the existing picture?', FRA = 'Souhaitez-vous remplacer l''image existante ?';
        Text002: TextConst ENU = 'Do you want to delete the picture?', FRA = 'Souhaitez-vous supprimer l''image ?';
        text004: Label 'Souhaitez-Vous réouvrir le CV Validé ?';
        text003: Label '"Souhaitez-Vous valider le CV ? "';
        text005: Label 'Le CV est déjà validé.';
        text006: Label 'Le CV est déjà ouvert.';
        text007: Label 'Un CV est encore ouvert pour qu''il soit pris en compte sur un Besoin de Recrutement.';
        text008: Label 'Vous ne pouvez pas réouvrir le CV %1, il est affecté à au moins une Commission Ouverte dont au moins un Avis de Jury est donné.';
        text009: Label 'Le Candidat a été admis lors d'' une Commission de Recrutement, vous ne pouvez pas réouvrir son CV.';
        text010: Label 'Une Fiche Salarié n''est créée qu''à partir d''un CV d''un candidat A Recruter.';
        text011: Label 'Voulez-vous créer une Fiche Salarié à partir de ce CV?';
        text012: Label 'Au Moins une Fiche Salarié a été déjà créée pour ce CV, voulez-vous en créer une autre?';
        DiplomeS: Record "Employee Diploma";
        DiplomeC: Record "Candidate Diploma";
        ExperienceS: Record "Employee Fulfilled Function";
        ExperienceC: Record "Candidate Fulfilled Function";
        QualifS: Record 5203;
        QualifC: Record "Candidate Qualification";
        LienS: Record 5205;
        LienC: Record "Candidate Relative";
        [InDataSet]
        MapPointVisible: Boolean;


    procedure CopierDiplomes();
    begin
        DiplomeC.RESET;
        DiplomeC.SETRANGE(DiplomeC."Candidate No.", "No.");
        IF DiplomeC.FIND('-') THEN
            REPEAT
                DiplomeS.INIT;
                DiplomeS."Employee No." := employe."No.";
                DiplomeS."Diploma Domain Code" := DiplomeC."Diploma Domain Code";
                DiplomeS."Diploma Code" := DiplomeC."Diploma Code";
                DiplomeS."Obtention Date" := DiplomeC."Obtention Date";
                DiplomeS."Diploma Description" := DiplomeC."Diploma Description";
                DiplomeS."Diploma Domain Description" := DiplomeC."Diploma Domain Description";
                DiplomeS.INSERT(TRUE);
            UNTIL DiplomeC.NEXT = 0;
    end;

    procedure CopierQualifications();
    begin
        QualifC.RESET;
        QualifC.SETRANGE(QualifC."Candidate No.", "No.");
        IF QualifC.FIND('-') THEN
            REPEAT
                QualifS.INIT;
                QualifS."Employee No." := employe."No.";
                QualifS."Line No." := QualifC."Line No.";
                QualifS."Qualification Code" := QualifC."Qualification Code";
                QualifS."From Date" := QualifC."From Date";
                QualifS."To Date" := QualifC."To Date";
                QualifS."Institution/Company" := QualifC."Institution/Company";
                QualifS.Description := QualifC.Description;
                QualifS.INSERT(TRUE);
            UNTIL QualifC.NEXT = 0;
    end;

    procedure "CopierExpérience"();
    begin
        ExperienceC.RESET;
        ExperienceC.SETRANGE(ExperienceC."Candidate No.", "No.");
        IF ExperienceC.FIND('-') THEN
            REPEAT
                ExperienceS.INIT;
                ExperienceS."Employee No." := employe."No.";
                ExperienceS."Employer No." := ExperienceC."Employer No.";
                ExperienceS."Starting Date" := ExperienceC."From Date";
                ExperienceS."Ending Date" := ExperienceC."To Date";
                ExperienceS."Function Description" := ExperienceC."Function";
                ExperienceS."Employer Description" := ExperienceC."Employer Description";
                ExperienceS."Cause of Departure" := ExperienceC."Cause of Departure";
                ExperienceS.Salary := ExperienceC.Salary;
                ExperienceS."First Name" := ExperienceC.Prénom;
                ExperienceS."Last Name" := ExperienceC.Nom;
                ExperienceS.INSERT(TRUE);
            UNTIL ExperienceC.NEXT = 0;
    end;

    procedure CopierLiens();
    begin
        LienC.RESET;
        LienC.SETRANGE(LienC."Candidate No.", "No.");
        IF LienC.FIND('-') THEN
            REPEAT
                LienS.INIT;
                LienS."Employee No." := employe."No.";
                LienS."Line No." := LienC."Line No.";
                LienS."Relative Code" := LienC."Relative Code";
                LienS."First Name" := LienC."First Name";
                LienS."Middle Name" := LienC."Middle Name";
                LienS."Last Name" := LienC."Last Name";
                LienS."Birth Date" := LienC."Birth Date";
                LienS."Phone No." := LienC."Phone No.";
                LienS."Relative's Employee No." := LienC."Relative's Candidate No.";
                LienS.Sex := LienC.Sex;
                LienS.Comment := LienC.Comment;
                LienS.INSERT(TRUE);
            UNTIL LienC.NEXT = 0;
    end;
}

