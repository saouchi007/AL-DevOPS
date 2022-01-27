table 52182470 "Candidate Answer"
//table 39108441 "Candidate Answer"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Answer',
                FRA = 'Réponse candidat';

    fields
    {
        field(1; "Candidature No."; Code[20])
        {
            CaptionML = ENU = 'Candidature No.',
                        FRA = 'N° candidature';
            Editable = false;
            NotBlank = true;
            TableRelation = Candidature;

            trigger OnValidate();
            var
                Cont: Record 5050;
            begin
            end;
        }
        field(2; "Questionnaire Code"; Code[10])
        {
            CaptionML = ENU = 'Candidate Profile Questionnaire Code',
                        FRA = 'Code questionnaire profil candidat';
            Editable = false;
            NotBlank = true;
            TableRelation = "Candidate Quest.Header";
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.',
                        FRA = 'N° ligne';
            Editable = false;
            NotBlank = true;
            TableRelation = "Candidate Quest.Line"."Line No." WHERE("Questionnaire Code" = FIELD("Questionnaire Code"),
                                                                     Type = CONST(Answer));
        }
        field(4; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            Editable = false;
            OptionCaptionML = ENU = 'Question,Answer',
                              FRA = 'Question,Réponse';
            OptionMembers = Question,Answer;
        }
        field(5; Description; Text[250])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(6; "Multiple Answers"; Boolean)
        {
            CaptionML = ENU = 'Multiple Answers',
                        FRA = 'Réponses multiples';
            Editable = false;
        }
        field(7; "Free Text"; Boolean)
        {
            CaptionML = ENU = 'Free Text',
                        FRA = 'Libre saisie';
            Editable = false;
        }
        field(8; "Questionnaire Priority"; Option)
        {
            CaptionML = ENU = 'Questionnaire Priority',
                        FRA = 'Priorité questionnaire';
            Editable = false;
            OptionCaptionML = ENU = 'Very Low,Low,Normal,High,Very High',
                              FRA = 'Très faible,Faible,Normale,Haute,Très haute';
            OptionMembers = "Very Low",Low,Normal,High,"Very High";
        }
        field(9; "Answer Priority"; Option)
        {
            CaptionML = ENU = 'Answer Priority',
                        FRA = 'Priorité réponse';
            Editable = false;
            OptionCaptionML = ENU = 'Very Low (Hidden),Low,Normal,High,Very High',
                              FRA = 'Très faible (cachée),Faible,Normale,Haute,Très haute';
            OptionMembers = "Very Low (Hidden)",Low,Normal,High,"Very High";
        }
        field(10; "Last Date Updated"; Date)
        {
            CaptionML = ENU = 'Last Date Updated',
                        FRA = 'Date dernière mise à jour';
            Editable = false;
        }
        field(11; Answer; Boolean)
        {
            CaptionML = ENU = 'Answer',
                        FRA = 'Réponse';

            trigger OnValidate();
            begin
                CandidateAnswer.RESET;
                CandidateAnswer.SETRANGE(CandidateAnswer."Candidature No.", "Candidature No.");
                CandidateAnswer.SETRANGE(CandidateAnswer."Questionnaire Code", "Questionnaire Code");
                CandidateAnswer.SETFILTER("Line No.", '<%1', Rec."Line No.");
                CandidateAnswer.SETRANGE(Type, Type::Question);
                IF CandidateAnswer.FINDLAST THEN BEGIN
                    QuestionLineNumber := CandidateAnswer."Line No.";
                    MultipleAnswers := CandidateAnswer."Multiple Answers";
                END;
                CandidateAnswer.SETFILTER("Line No.", '>%1', Rec."Line No.");
                NextQuestionLineNumber := 0;
                IF CandidateAnswer.FINDFIRST THEN BEGIN
                    IF MultipleAnswers THEN
                        EXIT;
                    NextQuestionLineNumber := CandidateAnswer."Line No.";
                END;
                CandidateAnswer.RESET;
                CandidateAnswer.SETRANGE(CandidateAnswer."Candidature No.", "Candidature No.");
                CandidateAnswer.SETRANGE(CandidateAnswer."Questionnaire Code", "Questionnaire Code");
                CandidateAnswer.SETRANGE(Type, Type::Answer);
                CandidateAnswer.SETRANGE(Answer, TRUE);
                IF NextQuestionLineNumber = 0 THEN
                    CandidateAnswer.SETFILTER("Line No.", '>%1', QuestionLineNumber)
                ELSE
                    CandidateAnswer.SETFILTER("Line No.", '%1..%2', QuestionLineNumber, NextQuestionLineNumber);
                IF CandidateAnswer.FINDFIRST THEN
                    IF CandidateAnswer."Line No." <> Rec."Line No." THEN
                        ERROR(Text02);
            end;
        }
    }

    keys
    {
        key(Key1; "Candidature No.", "Questionnaire Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        QuestnLine: Record 5088;
    begin
    end;

    var
        Text01: TextConst ENU = 'This Question does not allow %1.', FRA = 'Cette question ne permet pas de %1 !';
        CandidateAnswer: Record 52182470;
        QuestionLineNumber: Integer;
        NextQuestionLineNumber: Integer;
        Text02: Label 'Cette question est limitée à une seule réponse !';
        MultipleAnswers: Boolean;
}

