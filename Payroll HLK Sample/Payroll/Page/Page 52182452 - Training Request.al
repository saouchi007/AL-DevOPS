/// <summary>
/// Page Training Request (ID 52182452).
/// </summary>
page 52182452 "Training Request"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Request',
                FRA = 'Demande de formation';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Training Header";
    SourceTableView = WHERE("Document Type" = CONST(Request));

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
            }
            part(ReimbursementLines; 52182453)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Skills)
            {
                CaptionML = ENU = 'Skills',
                            FRA = 'Compétences';
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
            }
            group(Posting)
            {
                CaptionML = ENU = 'Posting',
                            FRA = 'Validation';
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
            group("&Contract")
            {
                CaptionML = ENU = '&Contract',
                            FRA = '&Imprimer';
                Image = Print;
                action("Etat des demandes de formation")
                {
                    Caption = 'Etat des demandes de formation';
                    Image = PrintReport;

                    trigger OnAction();
                    begin
                        TrainingHeader.RESET;
                        TrainingHeader.SETRANGE("No.", "No.");
                        //REPORT.RUNMODAL(51454, TRUE, FALSE, TrainingHeader);
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
                                FRA = '&Copier document';
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
                                FRA = '&Lancer le document';
                    Image = ReleaseDoc;
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

                action("&Select All")
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
                        TrainingLine.SETRANGE(Status, TrainingLine.Status::Requested);
                        TrainingLine.SETRANGE(Processed, FALSE);
                        IF TrainingLine.FIND('-') THEN
                            REPEAT
                                TrainingLine.Selection := TRUE;
                                TrainingLine.MODIFY;
                            UNTIL TrainingLine.NEXT = 0;
                    end;
                }
                action("&Unselect All")
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
            action(BtnMakeRegistration)
            {
                CaptionML = ENU = '&Make Registration',
                            FRA = '&Créer Inscription';
                Image = MakeAgreement;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    TrainingLine.SETRANGE("Document Type", "Document Type");
                    TrainingLine.SETRANGE("Document No.", "No.");
                    TrainingLine.SETRANGE(Type, TrainingLine.Type::Employee);
                    TrainingLine.SETRANGE(Processed, TRUE);
                    IF TrainingLine.FIND('-') THEN
                        REPEAT
                            TrainingLine.Selection := FALSE;
                            TrainingLine.MODIFY;
                        UNTIL TrainingLine.NEXT = 0;
                    TrainingLine.SETRANGE(Status, TrainingLine.Status::Requested);
                    TrainingLine.SETRANGE(Processed, FALSE);
                    TrainingLine.SETRANGE(Selection, TRUE);
                    IF TrainingLine.COUNT = 0 THEN BEGIN
                        MESSAGE(Text001, "No.");
                        EXIT;
                    END;
                    CODEUNIT.RUN(CODEUNIT::"Training-Requ.to Regist. (Y/N)", Rec);
                end;
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
        TrainingHeader: Record "Training Header";
        ParamRH: Record 5218;
}

