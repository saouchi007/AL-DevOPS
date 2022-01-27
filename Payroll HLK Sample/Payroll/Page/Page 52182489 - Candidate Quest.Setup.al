/// <summary>
/// Page Candidate Quest.Setup (ID 52182489).
/// </summary>
page 52182489 "Candidate Quest.Setup"
{
    // version HALRHPAIE.6.1.01

    AutoSplitKey = true;
    CaptionML = ENU = 'Candidate Quest.Setup',
                FRA = 'Paramètres quest. candidat';
    PageType = Card;
    SaveValues = true;
    SourceTable = "Candidate Quest.Line";

    layout
    {
        area(content)
        {
            field(CurrentQuestionsChecklistCode; CurrentQuestionsChecklistCode)
            {
                CaptionML = ENU = 'Candidate Questionnaire Code',
                            FRA = 'Code questionnaire candidat';

                trigger OnLookup(var Text: Text): Boolean;
                begin
                    CurrPage.SAVERECORD;
                    COMMIT;
                    IF PAGE.RUNMODAL(0, CandidateQuestnHeader) = ACTION::LookupOK THEN BEGIN
                        CandidateQuestnHeader.GET(CandidateQuestnHeader.Code);
                        CurrentQuestionsChecklistCode := CandidateQuestnHeader.Code;
                        CandidateManagement.SetName(CurrentQuestionsChecklistCode, Rec, 0);
                        CurrPage.UPDATE(FALSE);
                    END;
                end;

                trigger OnValidate();
                begin
                    CandidateQuestnHeader.GET(CurrentQuestionsChecklistCode);
                    CurrentQuestionsChecklistCodeO;
                end;
            }
            repeater(new)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field(Type; Type)
                {
                }
                field(Description; Description)
                {
                }
                field("Multiple Answers"; "Multiple Answers")
                {
                }
                field("Free Text"; "Free Text")
                {

                    trigger OnValidate();
                    begin
                        FreeTextOnPush;
                    end;
                }
                field(Priority; Priority)
                {
                    HideValue = PriorityHideValue;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            FRA = 'Fonction&s';
                Image = Job;
                action("Move &Up")
                {
                    CaptionML = ENU = 'Move &Up',
                                FRA = 'Déplacer vers le &haut';
                    Image = MoveUp;

                    trigger OnAction();
                    begin
                        MoveUp;
                    end;
                }
                action("Move &Down")
                {
                    CaptionML = ENU = 'Move &Down',
                                FRA = 'Déplacer vers le &bas';
                    Image = MoveDown;

                    trigger OnAction();
                    begin
                        MoveDown
                    end;
                }

                action(Print)
                {
                    CaptionML = ENU = 'Print',
                                FRA = 'I&mprimer';
                    Image = Print;

                    trigger OnAction();
                    var
                        CandidateQuestnHeader: Record "Candidate Quest.Header";
                    begin
                        CandidateQuestnHeader.SETRANGE(Code, CurrentQuestionsChecklistCode);
                        REPORT.RUN(REPORT::Questionnaire, TRUE, FALSE, CandidateQuestnHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        PriorityHideValue := FALSE;
        DescriptionIndent := 0;
        TypeOnFormat;
        DescriptionOnFormat;
        PriorityOnFormat;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Questionnaire Code" := CurrentQuestionsChecklistCode;
        Type := Type::Answer;
    end;

    trigger OnOpenPage();
    begin
        IF (CurrentQuestionsChecklistCode = '') OR
          (NOT CandidateQuestnHeader.GET(CurrentQuestionsChecklistCode))
        THEN
            CurrentQuestionsChecklistCode := CandidateManagement.GetQuestionnaire;

        CandidateManagement.SetName(CurrentQuestionsChecklistCode, Rec, 0);
    end;

    var
        Text000: TextConst ENU = 'Details only available for questions.', FRA = 'Seules les questions sont paramétrables.';
        CandidateQuestnHeader: Record "Candidate Quest.Header";
        CandidateManagement: Codeunit 52182428;
        CurrentQuestionsChecklistCode: Code[10];
        Text001: TextConst ENU = 'Where-Used only available for answers.', FRA = 'Les cas d''emploi sont uniquement disponibles pour les réponses.';
        [InDataSet]
        TypeEmphasize: Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;
        [InDataSet]
        DescriptionIndent: Integer;
        [InDataSet]
        PriorityHideValue: Boolean;


    local procedure CurrentQuestionsChecklistCodeO();
    begin
        CandidateManagement.SetName(CurrentQuestionsChecklistCode, Rec, 0);
    end;

    local procedure FreeTextOnPush();
    begin
        //CurrPage.UPDATECONTROLS
        CurrPage.UPDATE;
    end;

    local procedure TypeOnFormat();
    begin
        IF Type = Type::Question THEN
            TypeEmphasize := TRUE
    end;

    local procedure DescriptionOnFormat();
    begin
        IF Type = Type::Question THEN
            DescriptionEmphasize := TRUE
        ELSE
            DescriptionIndent := 1;
    end;

    local procedure PriorityOnFormat();
    begin
        IF Type = Type::Question THEN
            PriorityHideValue := TRUE;
    end;
}

