/// <summary>
/// Report Questionnaire Answers (ID 52182431).
/// </summary>
report 52182431 "Questionnaire Answers"
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Questionnaire Answers.rdl';
    CaptionML = ENU = 'Questionnaire Answers',
                FRA = 'Réponses au questionnaire';

    dataset
    {
        dataitem(DataItem3807; "Candidate Answer")
        {

            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(NumCandidature; NumCandidature)
            {
            }
            column(NumCandidate; NumCandidate)
            {
            }
            column(FirstName; FirstName)
            {
            }
            column(LastName; LastName)
            {
            }
            column(OpenPostDescription; OpenPostDescription)
            {
            }
            column(QuestionnaireCode; QuestionnaireCode)
            {
            }
            column(InterviewerLastName; InterviewerLastName)
            {
            }
            column(InterviewerFirstName; InterviewerFirstName)
            {
            }
            column(Candidate_Answer_Description; Description)
            {
            }
            column(Candidate_Answer_Description_Control55; Description)
            {
            }
            column(Candidate_Answer_Description_Control13; Description)
            {
            }
            column(Candidate_Answer_Description_Control1000000003; Description)
            {
            }
            column(Candidate_Answer_Description_Control1000000001; Description)
            {
            }
            column(Candidate_Answer_Description_Control13Caption; FIELDCAPTION(Description))
            {
            }
            column(AnswerCaption; AnswerCaptionLbl)
            {
            }
            column(Number_of_AnswersCaption; Number_of_AnswersCaptionLbl)
            {
            }
            column(QuestionnaireCaption; QuestionnaireCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(N__CandidatureCaption; N__CandidatureCaptionLbl)
            {
            }
            column(N__CandidatCaption; N__CandidatCaptionLbl)
            {
            }
            column("PrénomCaption"; PrénomCaptionLbl)
            {
            }
            column(NomCaption; NomCaptionLbl)
            {
            }
            column(Poste_ouvertCaption; Poste_ouvertCaptionLbl)
            {
            }
            column(QuestionnaireCaption_Control1000000012; QuestionnaireCaption_Control1000000012Lbl)
            {
            }
            column(NomCaption_Control1000000025; NomCaption_Control1000000025Lbl)
            {
            }
            column("PrénomCaption_Control1000000027"; PrénomCaption_Control1000000027Lbl)
            {
            }
            column("Chargé_de_l_entretien__Caption"; Chargé_de_l_entretien__CaptionLbl)
            {
            }
            column(MultipleCaption; MultipleCaptionLbl)
            {
            }
            column(One_onlyCaption; One_onlyCaptionLbl)
            {
            }
            column(XCaption; XCaptionLbl)
            {
            }
            column(Candidate_Answer_Candidature_No_; "Candidature No.")
            {
            }
            column(Candidate_Answer_Questionnaire_Code; "Questionnaire Code")
            {
            }
            column(Candidate_Answer_Line_No_; "Line No.")
            {
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



    trigger OnPreReport();
    begin
        QuestionnaireFilter := "Candidate Answer".GETFILTERS;
    end;

    var
        "Candidate Answer": Record "Candidate Answer";
        QuestionnaireFilter: Text[250];
        NumCandidature: Code[20];
        NumCandidate: Code[20];
        FirstName: Text[30];
        LastName: Text[30];
        OpenPostDescription: Text[50];
        Candidature: Record Candidate;
        QuestionnaireCode: Code[10];
        InterviewerFirstName: Text[30];
        InterviewerLastName: Text[30];
        Salarie: Record 5200;
        AnswerCaptionLbl: TextConst ENU = 'Answer', FRA = 'Réponse';
        Number_of_AnswersCaptionLbl: TextConst ENU = 'Number of Answers', FRA = 'Nombre de réponses';
        QuestionnaireCaptionLbl: TextConst ENU = 'Questionnaire', FRA = 'Questionnaire';
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', FRA = 'Page';
        N__CandidatureCaptionLbl: Label 'N° Candidature';
        N__CandidatCaptionLbl: Label 'N° Candidat';
        "PrénomCaptionLbl": Label 'Prénom';
        NomCaptionLbl: Label 'Nom';
        Poste_ouvertCaptionLbl: Label 'Poste ouvert';
        QuestionnaireCaption_Control1000000012Lbl: Label 'Questionnaire';
        NomCaption_Control1000000025Lbl: Label 'Nom';
        "PrénomCaption_Control1000000027Lbl": Label 'Prénom';
        "Chargé_de_l_entretien__CaptionLbl": Label 'Chargé de l''entretien :';
        MultipleCaptionLbl: TextConst ENU = 'Multiple', FRA = 'Multiple';
        One_onlyCaptionLbl: TextConst ENU = 'One only', FRA = 'Une seule';
        XCaptionLbl: Label 'X';

}

