/// <summary>
/// Page Candidature Card (ID 52182484).
/// </summary>
page 52182484 "Candidature Card"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidature Card',
                FRA = 'Fiche candidature';
    PageType = Document;
    SourceTable = Candidature;

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                field("No."; "No.")
                {

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Type; Type)
                {
                }
                field("Candidate No."; "Candidate No.")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Questionnaire Code"; "Questionnaire Code")
                {

                    trigger OnValidate();
                    begin
                        QuestionnaireCodeOnAfterValida;
                    end;
                }
                field("Open post No."; "Open post No.")
                {
                }
                field("Open Post Description"; "Open Post Description")
                {
                }
                field("Structure Code"; "Structure Code")
                {
                }
                field("Structure Description"; "Structure Description")
                {
                }
                field("Interviewing Responsible No."; "Interviewing Responsible No.")
                {
                }
                field("Interv. Responsible First Name"; "Interv. Responsible First Name")
                {
                }
                field("Interv. Responsible Last Name"; "Interv. Responsible Last Name")
                {
                }
            }
            part(Control1000000029; 52182492)
            {
                SubPageLink = "Candidature No." = FIELD("No."),
                              "Questionnaire Code" = FIELD("Questionnaire Code");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Candidature")
            {
                CaptionML = ENU = '&Candidature',
                            FRA = '&Candidature';
                Image = PersonInCharge;
                action("Questionnaire Candidat")
                {
                    Image = Questionaire;
                    RunObject = Page "Candidate Quest.";
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), //Const(15)
                                  "No." = FIELD("No.");
                }
            }
        }
        area(processing)
        {
            action(Print)
            {
                CaptionML = ENU = 'Print',
                            FRA = 'I&mprimer';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    CandidateAnswer.SETRANGE(CandidateAnswer."Candidature No.", "No.");
                    CandidateAnswer.SETRANGE(CandidateAnswer."Questionnaire Code", "Questionnaire Code");
                    REPORT.RUN(REPORT::"Questionnaire Answers", TRUE, FALSE, CandidateAnswer);
                end;
            }
        }
    }



    var
        CandidateAnswer: Record "Candidate Answer";


    local procedure QuestionnaireCodeOnAfterValida();
    begin
        CurrPage.SAVERECORD;
        CurrPage.UPDATE(FALSE);
    end;
}

