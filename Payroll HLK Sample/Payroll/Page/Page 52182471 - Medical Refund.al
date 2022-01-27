/// <summary>
/// Page Medical Refund (ID 51436).
/// </summary>
page 52182471 "Medical Refund"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Medical Refund',
                FRA = 'Remboursement frais médicaux';
    PageType = Document;
    SourceTable = "Medical Refund Header";

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
                field(Description; Description)
                {
                }
                field("Collection Date"; "Collection Date")
                {
                }
                field("Submittion Date"; "Submittion Date")
                {
                }
                field(Status; Status)
                {
                }
                field(Comment; Comment)
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Refund Date"; "Refund Date")
                {
                    Editable = true;
                }
            }
            part(ReimbursLines; "Medical Refund Subform") 
            {
                SubPageLink = "Document No." = FIELD("No.");
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
                        MESSAGE('en cours de développement');
                        EXIT;
                        //FORM.RUNMODAL(FORM::"Reimbursement Statistics",Rec);
                    end;
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 52182475;
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
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            FRA = 'Fonction&s';
                Image = Job;
                action("Re&lease Document")
                {
                    CaptionML = ENU = 'Re&lease Document',
                                FRA = 'Lancer le document';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction();
                    begin
                        ReleaseReimbursementDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    CaptionML = ENU = 'Re&open',
                                FRA = 'R&ouvrir';
                    Image = ReOpen;

                    trigger OnAction();
                    begin
                        ReleaseReimbursementDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("&Print")
            {
                CaptionML = ENU = '&Print',
                            FRA = '&Imprimer';
                Image = Print;
                action("&Note of Reception")
                {
                    CaptionML = ENU = '&Note of Reception',
                                FRA = '&Accusé de réception';
                    Image = Note;

                    trigger OnAction();
                    begin
                        ReimbursHeader.SETRANGE("No.", "No.");
                        REPORT.RUN(REPORT::"Rembours.-Accusé de réception", TRUE, FALSE, ReimbursHeader);
                    end;
                }
            }
        }
    }



    var
        ReleaseReimbursementDoc: Codeunit 52182427;
        ReimbursHeader: Record "Medical Refund Header";

}

