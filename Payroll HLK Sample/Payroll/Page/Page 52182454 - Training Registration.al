/// <summary>
/// Page Training Registration (ID 51419).
/// </summary>
page 52182454 "Training Registration"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Registration',
                FRA = 'Inscription et Evaluation de la formation';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Training Header";
    SourceTableView = WHERE("Document Type" = CONST(Registration));

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
                field("Training No."; "Training No.")
                {
                }
                field("Training Description"; "Training Description")
                {
                }
                field(Type; Type)
                {
                }
                field("Domain Description"; "Domain Description")
                {
                }
                field("Subdomain Description"; "Subdomain Description")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field(Status; Status)
                {
                }
                field("No. of Employees"; "No. of Employees")
                {
                }
                field("Lieu de la Formation"; "Lieu de la Formation")
                {
                }
            }
            part(TrainingLines; 52182455)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Session)
            {
                CaptionML = ENU = 'Session',
                            FRA = 'Session';
                field("Institution No."; "Institution No.")
                {
                }
                field("Session No."; "Session No.")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Starting Time"; "Starting Time")
                {
                }
                field("Ending Time"; "Ending Time")
                {
                }
                field(Durée; Durée)
                {
                    Caption = 'Durée en heures';
                    Editable = false;
                }
                field(Cost; Cost)
                {
                    Editable = false;
                }
                field("Frais d'hébergement"; "Frais d'hébergement")
                {
                }
                field("Frais de restauration"; "Frais de restauration")
                {
                }
                field("Frais de transport"; "Frais de transport")
                {
                }
                field("Autres Frais"; "Autres Frais")
                {
                }
                field("Frais Personnel Total"; "Frais d'hébergement" + "Frais de restauration" + "Frais de transport" + "Autres Frais")
                {
                    Editable = false;

                }
                field("Coût Total"; "Frais d'hébergement" + "Frais de restauration" + "Frais de transport" + "Autres Frais")
                {
                    Editable = false;
                }
                field("Update Costs"; "Update Costs")
                {
                }
            }
            group(Posting)
            {
                CaptionML = ENU = 'Posting',
                            FRA = 'Validation';
                field(Aim; Aim)
                {
                }
                field("Required Level"; "Required Level")
                {
                }
                field(Sanction; Sanction)
                {
                }
                field("Sanction Code"; "Sanction Code")
                {
                }
                field("Sanction Description"; "Sanction Description")
                {
                }
                field("Diploma Domain Code"; "Diploma Domain Code")
                {
                }
                field("Diploma Domain Description"; "Diploma Domain Description")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Request")
            {
                CaptionML = ENU = '&Request',
                            FRA = '&Demande';
                Image = SendApprovalRequest;
                action(Statistics)
                {
                    CaptionML = ENU = 'Statistics',
                                FRA = 'Statistiques';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    Visible = false;

                    trigger OnAction();
                    begin
                        MESSAGE('en cours de développement');
                        EXIT;
                        //PAGE.RUNMODAL(PAGE::"Trainings Statistics", Rec);
                    end;
                }
                action("Training Card")
                {
                    CaptionML = ENU = 'Training Card',
                                FRA = 'Fiche formation';
                    Image = List;
                    RunObject = Page "Training Card";
                    RunPageLink = "No." = FIELD("Training No.");
                    ShortCutKey = 'Shift+F5';
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 52182468;
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                FRA = 'A&xes analytiques';
                    Image = Dimensions;

                    trigger OnAction();
                    begin
                        Rec.ShowDocDim;
                    end;
                }
            }
            group("&Line")
            {
                CaptionML = ENU = '&Line',
                            FRA = '&Ligne';
                Image = Line;

                action(BtnSelectAll)
                {
                    CaptionML = ENU = '&Select All',
                                FRA = '&Sélectionner tout';
                    Image = Select;

                    trigger OnAction();
                    begin
                        TrainingLine.RESET;
                        TrainingLine.SETRANGE("Document Type", "Document Type");
                        TrainingLine.SETRANGE("Document No.", "No.");
                        TrainingLine.SETRANGE(Type, TrainingLine.Type::Employee);
                        TrainingLine.SETFILTER(Status, '%1|%2', TrainingLine.Status::Requested, TrainingLine.Status::Released);
                        TrainingLine.SETRANGE(Processed, FALSE);
                        IF TrainingLine.FIND('-') THEN
                            REPEAT
                                TrainingLine.Selection := TRUE;
                                TrainingLine.MODIFY;
                            UNTIL TrainingLine.NEXT = 0;
                    end;
                }
                action(BtnUnselectAll)
                {
                    CaptionML = ENU = '&Unselect All',
                                FRA = '&Désélectionner tout';
                    Image = DeleteRow;

                    trigger OnAction();
                    begin
                        TrainingLine.RESET;
                        TrainingLine.SETRANGE("Document Type", "Document Type");
                        TrainingLine.SETRANGE("Document No.", "No.");
                        TrainingLine.SETRANGE(Type, TrainingLine.Type::Employee);
                        IF TrainingLine.FIND('-') THEN
                            REPEAT
                                TrainingLine.Selection := FALSE;
                                TrainingLine.MODIFY;
                            UNTIL TrainingLine.NEXT = 0;
                    end;
                }
            }
            group("&Contract")
            {
                CaptionML = ENU = '&Contract',
                            FRA = '&Imprimer';
                Image = Print;
                action("Etat des inscriptions")
                {
                    Caption = 'Etat des inscriptions';
                    Image = PrintReport;

                    trigger OnAction();
                    begin
                        TrainingHeader.RESET;
                        TrainingHeader.SETRANGE("No.", "No.");
                        //REPORT.RUNMODAL(51454, TRUE, FALSE, TrainingHeader); ************
                    end;
                }
                action("Evaluation de formation")
                {
                    Caption = 'Evaluation de formation';
                    Image = Evaluate;

                    trigger OnAction();
                    begin
                        TrainingLine.RESET;
                        TrainingLine.SETRANGE("Document No.", "No.");
                        //REPORT.RUNMODAL(51449, TRUE, FALSE, TrainingLine); ***************
                    end;
                }
                action("Fiche de Formation")
                {
                    Caption = 'Fiche de Formation';
                    Image = TaskList;

                    trigger OnAction();
                    begin
                        TrainingHeader.RESET;
                        TrainingHeader.SETRANGE("No.", "No.");
                        //REPORT.RUNMODAL(51450, TRUE, FALSE, TrainingHeader); ***************
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            FRA = 'Fonction&s';
                Image = Job;
                action("Copy Document")
                {
                    CaptionML = ENU = 'Copy Document',
                                FRA = 'Copier &document';
                    Image = CopyDocument;
                    Visible = false;

                    trigger OnAction();
                    begin
                        MESSAGE('En cours de développement');
                        /*
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RUNMODAL;
                        CLEAR(CopyPurchDoc);
                         */

                    end;
                }

                action("Re&lease Document")
                {
                    CaptionML = ENU = 'Re&lease Document',
                                FRA = 'Lancer le document';
                    Image = DocumentEdit;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction();
                    begin
                        ReleaseTrainingDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    CaptionML = ENU = 'Re&open',
                                FRA = 'R&ouvrir';
                    Image = ReOpen;

                    trigger OnAction();
                    begin
                        ReleaseTrainingDoc.PerformManualReopen(Rec);
                    end;
                }
                action("A&rchiver")
                {
                    Caption = 'A&rchiver';
                    Image = Archive;

                    trigger OnAction();
                    begin
                        ReleaseTrainingDoc.PerformManualArchive(Rec);
                    end;
                }

                action(BtnRelease)
                {
                    CaptionML = ENU = '&Release',
                                FRA = '&Lancer';
                    Image = ReleaseDoc;

                    trigger OnAction();
                    begin
                        TESTFIELD("Training No.");
                        TESTFIELD("Session No.");
                        TrainingLine.SETRANGE("Document Type", "Document Type");
                        TrainingLine.SETRANGE("Document No.", "No.");
                        TrainingLine.SETRANGE(Type, TrainingLine.Type::Employee);
                        TrainingLine.SETFILTER(Status, '%1|%2|%3', TrainingLine.Status::Released, TrainingLine.Status::Finished,
                        TrainingLine.Status::Canceled);
                        IF TrainingLine.FIND('-') THEN
                            REPEAT
                                TrainingLine.Selection := FALSE;
                                TrainingLine.MODIFY;
                            UNTIL TrainingLine.NEXT = 0;
                        TrainingLine.SETRANGE(Status, TrainingLine.Status::Requested);
                        TrainingLine.SETRANGE(Selection, TRUE);
                        IF TrainingLine.COUNT = 0 THEN BEGIN
                            MESSAGE(Text001, "No.");
                            EXIT;
                        END;
                        ParametresCompta.GET;
                        TrainingLine.FINDFIRST;
                        REPEAT
                            TrainingLine.TESTFIELD("Starting Date");
                            TrainingLine.TESTFIELD("Ending Date");
                            IF ParametresCompta."Global Dimension 1 Code" <> '' THEN
                                TrainingLine.TESTFIELD("Shortcut Dimension 1 Code");
                            IF ParametresCompta."Global Dimension 2 Code" <> '' THEN
                                TrainingLine.TESTFIELD("Shortcut Dimension 2 Code");
                            IF (TrainingLine.Initiative = TrainingLine.Initiative::Hierarchy)
                            OR (TrainingLine.Initiative = TrainingLine.Initiative::Direction) THEN BEGIN
                                TrainingLine.TESTFIELD("No. Decision");
                                TrainingLine.TESTFIELD("Decision Date");
                            END;
                            IF (Sanction = Sanction::Qualification)
                            OR (Sanction = Sanction::Diploma) THEN
                                TESTFIELD("Sanction Description");
                        UNTIL TrainingLine.NEXT = 0;
                        RequesttoRegistration.ReleaseTraining(Rec);
                    end;
                }
                action(BtnFinish)
                {
                    CaptionML = ENU = '&Finish',
                                FRA = '&Terminer';
                    Image = Stop;

                    trigger OnAction();
                    begin
                        TESTFIELD("Training No.");
                        TESTFIELD("Session No.");
                        TrainingLine.SETRANGE("Document Type", "Document Type");
                        TrainingLine.SETRANGE("Document No.", "No.");
                        TrainingLine.SETRANGE(Type, TrainingLine.Type::Employee);
                        TrainingLine.SETFILTER(Status, '%1|%2|%3', TrainingLine.Status::Requested, TrainingLine.Status::Finished,
                        TrainingLine.Status::Canceled);
                        IF TrainingLine.FIND('-') THEN
                            REPEAT
                                TrainingLine.Selection := FALSE;
                                TrainingLine.MODIFY;
                            UNTIL TrainingLine.NEXT = 0;
                        TrainingLine.SETRANGE(Status, TrainingLine.Status::Released);
                        TrainingLine.SETRANGE(Selection, TRUE);
                        IF TrainingLine.COUNT = 0 THEN BEGIN
                            MESSAGE(Text001, "No.");
                            EXIT;
                        END;
                        ParametresCompta.GET;
                        TrainingLine.FINDFIRST;
                        REPEAT
                            TrainingLine.TESTFIELD("Starting Date");
                            TrainingLine.TESTFIELD("Ending Date");
                            IF ParametresCompta."Global Dimension 1 Code" <> '' THEN
                                TrainingLine.TESTFIELD("Shortcut Dimension 1 Code");
                            IF ParametresCompta."Global Dimension 2 Code" <> '' THEN
                                TrainingLine.TESTFIELD("Shortcut Dimension 2 Code");
                            IF (TrainingLine.Initiative = TrainingLine.Initiative::Hierarchy)
                            OR (TrainingLine.Initiative = TrainingLine.Initiative::Direction) THEN BEGIN
                                TrainingLine.TESTFIELD("No. Decision");
                                TrainingLine.TESTFIELD("Decision Date");
                            END;
                            IF TrainingLine.Assessment = TrainingLine.Assessment::Blank THEN
                                TrainingLine.FIELDERROR(Assessment);
                        UNTIL TrainingLine.NEXT = 0;
                        RequesttoRegistration.FinishTraining(Rec);
                    end;
                }
                action(BtnCancel)
                {
                    CaptionML = ENU = '&Deny',
                                FRA = '&Annuler';
                    Image = Close;

                    trigger OnAction();
                    begin
                        TrainingLine.SETRANGE("Document Type", "Document Type");
                        TrainingLine.SETRANGE("Document No.", "No.");
                        TrainingLine.SETRANGE(Type, TrainingLine.Type::Employee);
                        TrainingLine.SETFILTER(Status, '%1|%2|%3', TrainingLine.Status::Requested, TrainingLine.Status::Finished,
                        TrainingLine.Status::Canceled);
                        IF TrainingLine.FIND('-') THEN
                            REPEAT
                                TrainingLine.Selection := FALSE;
                                TrainingLine.MODIFY;
                            UNTIL TrainingLine.NEXT = 0;
                        TrainingLine.SETRANGE(Status, TrainingLine.Status::Released);
                        TrainingLine.SETRANGE(Selection, TRUE);
                        IF TrainingLine.COUNT = 0 THEN BEGIN
                            MESSAGE(Text001, "No.");
                            EXIT;
                        END;
                        ParametresCompta.GET;
                        TrainingLine.FINDFIRST;
                        REPEAT
                            TrainingLine.TESTFIELD("Starting Date");
                            TrainingLine.TESTFIELD("Ending Date");
                            IF ParametresCompta."Global Dimension 1 Code" <> '' THEN
                                TrainingLine.TESTFIELD("Shortcut Dimension 1 Code");
                            IF ParametresCompta."Global Dimension 2 Code" <> '' THEN
                                TrainingLine.TESTFIELD("Shortcut Dimension 2 Code");
                            IF (TrainingLine.Initiative = TrainingLine.Initiative::Hierarchy)
                            OR (TrainingLine.Initiative = TrainingLine.Initiative::Direction) THEN BEGIN
                                TrainingLine.TESTFIELD("No. Decision");
                                TrainingLine.TESTFIELD("Decision Date");
                            END;
                        UNTIL TrainingLine.NEXT = 0;
                        RequesttoRegistration.CancelTraining(Rec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        ParamRH.GET;
        IF ParamRH."Do not show archived training" THEN
            SETFILTER(Status, '<>%1', Status::Archived);
    end;

    var
        ReleaseTrainingDoc: Codeunit 52182423;
        TrainingLine: Record "Training Line";
        Text001: Label 'Aucune sélection de lignes pour le document %1';
        RequesttoRegistration: Codeunit 52182425;
        ParametresCompta: Record 98;
        TrainingHeader: Record "Training Header";
        ParamRH: Record 5218;
}

