/// <summary>
/// Report Questionnaire (ID 52182426).
/// </summary>
report 52182426 Questionnaire
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Questionnaire.rdl';
    CaptionML = ENU = 'Questionnaire',
                FRA = 'Questionnaire';

    dataset
    {
        dataitem(DataItem6588; "Candidate Quest.Header")
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(Candidate_Quest_Header__TABLECAPTION__________QuestionnaireFilter; "Candidate Quest.Header".TABLECAPTION + ': ' + QuestionnaireFilter)
            {
            }
            column(Candidate_Quest_Header_Description; Description)
            {
            }
            column(Candidate_Quest_Header_Code; Code)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(QuestionnaireCaption; QuestionnaireCaptionLbl)
            {
            }
            column(Including_Classification_QuestionsCaption; Including_Classification_QuestionsCaptionLbl)
            {
            }
            dataitem(DataItem5098; "Candidate Quest.Line")
            {
                DataItemLink = "Questionnaire Code" = FIELD(Code);
                DataItemTableView = SORTING("Questionnaire Code", "Line No.");
                column(Candidate_Quest_Line_Description; Description)
                {
                }
                column(Candidate_Quest_Line_Description_Control55; Description)
                {
                }
                column(Candidate_Quest_Line_Description_Control13; Description)
                {
                }
                column(Candidate_Quest_Line_Description_Control13Caption; FIELDCAPTION(Description))
                {
                }
                column(AnswerCaption; AnswerCaptionLbl)
                {
                }
                column(Number_of_AnswersCaption; Number_of_AnswersCaptionLbl)
                {
                }
                column(MultipleCaption; MultipleCaptionLbl)
                {
                }
                column(One_onlyCaption; One_onlyCaptionLbl)
                {
                }
                column(Candidate_Quest_Line_Questionnaire_Code; "Questionnaire Code")
                {
                }
                column(Candidate_Quest_Line_Line_No_; "Line No.")
                {
                }
            }
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
        //accesspay.accesstopay;
    end;

    trigger OnPreReport();
    begin
        QuestionnaireFilter := "Candidate Quest.Header".GETFILTERS;
    end;

    var
        "Candidate Quest.Header": Record "Candidate Quest.Header";
        QuestionnaireFilter: Text[250];
        PrintClassificationFields: Boolean;
        ClassificationQuestion: Boolean;
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', FRA = 'Page';
        QuestionnaireCaptionLbl: TextConst ENU = 'Questionnaire', FRA = 'Questionnaire';
        Including_Classification_QuestionsCaptionLbl: TextConst ENU = 'Including Classification Questions', FRA = 'Contient les questions classification';
        AnswerCaptionLbl: TextConst ENU = 'Answer', FRA = 'Réponse';
        Number_of_AnswersCaptionLbl: TextConst ENU = 'Number of Answers', FRA = 'Nombre de réponses';
        MultipleCaptionLbl: TextConst ENU = 'Multiple', FRA = 'Multiple';
        One_onlyCaptionLbl: TextConst ENU = 'One only', FRA = 'Une seule';

}

