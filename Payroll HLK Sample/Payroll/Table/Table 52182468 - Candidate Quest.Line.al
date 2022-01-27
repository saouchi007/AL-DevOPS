/// <summary>
/// Table Candidate Quest.Line (ID 52182468).
/// </summary>
table 52182468 "Candidate Quest.Line"
//table 39108439 "Candidate Quest.Line"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Quest.Line',
                FRA = 'Ligne questionnaire candidat';
    DataCaptionFields = "Questionnaire Code", Description;
    LookupPageID = 5149;//par defaut 5149

    fields
    {
        field(1; "Questionnaire Code"; Code[10])
        {
            CaptionML = ENU = 'Questionnaire Code',
                        FRA = 'Code questionnaire';
            TableRelation = "Candidate Quest.Header";
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.',
                        FRA = 'N° ligne';
        }
        field(3; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            OptionCaptionML = ENU = 'Question,Answer',
                              FRA = 'Question,Réponse';
            OptionMembers = Question,Answer;

            trigger OnValidate();
            begin
                CASE Type OF
                    Type::Answer:
                        TESTFIELD("Multiple Answers", FALSE);
                END;
            end;
        }
        field(4; Description; Text[250])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
            NotBlank = true;
        }
        field(5; "Multiple Answers"; Boolean)
        {
            CaptionML = ENU = 'Multiple Answers',
                        FRA = 'Réponses multiples';

            trigger OnValidate();
            begin
                IF "Multiple Answers" THEN
                    TESTFIELD(Type, Type::Question);
            end;
        }
        field(6; "Free Text"; Boolean)
        {
            CaptionML = ENU = 'Free Text',
                        FRA = 'Libre saisie';

            trigger OnValidate();
            var
                QuestionnaireLine: Record 52182468;
            begin
                TESTFIELD(Type, Type::Question);
                QuestionnaireLine.GET("Questionnaire Code", "Line No.");
                QuestionnaireLine.NEXT;
                WHILE QuestionnaireLine.Type = QuestnLine.Type::Answer DO BEGIN
                    QuestionnaireLine."Free Text" := "Free Text";
                    QuestionnaireLine.MODIFY;
                    IF QuestionnaireLine.NEXT = 0 THEN
                        EXIT;
                END;
            end;
        }
        field(17; Priority; Option)
        {
            CaptionML = ENU = 'Priority',
                        FRA = 'Priorité';
            InitValue = Normal;
            OptionCaptionML = ENU = 'Very Low (Hidden),Low,Normal,High,Very High',
                              FRA = 'Très faible (cachée),Faible,Normale,Haute,Très haute';
            OptionMembers = "Very Low (Hidden)",Low,Normal,High,"Very High";
        }
    }

    keys
    {
        key(Key1; "Questionnaire Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        QuestionnaireLine: Record 52182468;
    begin
        IF Type = Type::Question THEN BEGIN
            QuestionnaireLine.GET("Questionnaire Code", "Line No.");
            IF (QuestionnaireLine.NEXT <> 0) AND
               (QuestionnaireLine.Type = QuestnLine.Type::Answer) THEN
                ERROR(Text004, TABLECAPTION);
        END;
    end;

    var
        QuestnLine: Record 52182468;
        TempLineAnswer: Record 52182468 temporary;
        "0DF": DateFormula;
        Text000: TextConst ENU = 'Do you want to delete the rating values?', FRA = 'Souhaitez-vous supprimer les valeurs d''évaluation ?';
        Text001: TextConst ENU = '%1 cannot be changed until the rating value is deleted.', FRA = 'Vous ne pouvez pas modifier l''enregistrement %1 avant d''avoir supprimer la valeur d''évaluation.';
        Text004: TextConst ENU = 'You cannot delete this question while answers exists.', FRA = 'Vous ne pouvez pas supprimer cette question car il existe des réponses correspondantes.';
        Text005: TextConst ENU = 'Please select for which questionnaire this rating should be created.', FRA = 'Indiquez à quel questionnaire cette évaluation est destinée.';
        Text006: TextConst ENU = 'Please describe the rating.', FRA = 'Décrivez l''évaluation.';
        Text007: TextConst ENU = 'Please create one or more different answers.', FRA = 'Créez plusieurs réponses différentes.';
        Text008: TextConst ENU = 'Please enter which range of points this answer should require.', FRA = 'Saisissez l''intervalle de points requis par cette réponse.';
        Text009: TextConst ENU = 'High', FRA = 'Elevée';
        Text010: TextConst ENU = 'Low', FRA = 'Faible';
        Continue: Boolean;

    /// <summary>
    /// MoveUp.
    /// </summary>
    procedure MoveUp();
    var
        UpperQuestnLine: Record 52182468;
        LineNo: Integer;
        UpperRecLineNo: Integer;
    begin
        TESTFIELD(Type, Type::Answer);
        UpperQuestnLine.SETRANGE("Questionnaire Code", "Questionnaire Code");
        LineNo := "Line No.";
        UpperQuestnLine.GET("Questionnaire Code", "Line No.");

        IF UpperQuestnLine.FIND('<') AND
           (UpperQuestnLine.Type = UpperQuestnLine.Type::Answer)
        THEN BEGIN
            UpperRecLineNo := UpperQuestnLine."Line No.";
            RENAME("Questionnaire Code", -1);
            UpperQuestnLine.RENAME("Questionnaire Code", LineNo);
            RENAME("Questionnaire Code", UpperRecLineNo);
        END;
    end;

    /// <summary>
    /// MoveDown.
    /// </summary>
    procedure MoveDown();
    var
        LowerQuestnLine: Record 52182468;
        LineNo: Integer;
        LowerRecLineNo: Integer;
    begin
        TESTFIELD(Type, Type::Answer);
        LowerQuestnLine.SETRANGE("Questionnaire Code", "Questionnaire Code");
        LineNo := "Line No.";
        LowerQuestnLine.GET("Questionnaire Code", "Line No.");

        IF LowerQuestnLine.FIND('>') AND
           (LowerQuestnLine.Type = LowerQuestnLine.Type::Answer)
        THEN BEGIN
            LowerRecLineNo := LowerQuestnLine."Line No.";
            RENAME("Questionnaire Code", -1);
            LowerQuestnLine.RENAME("Questionnaire Code", LineNo);
            RENAME("Questionnaire Code", LowerRecLineNo);
        END;
    end;

    /// <summary>
    /// Question.
    /// </summary>
    /// <returns>Return value of type Text[50].</returns>
    procedure Question(): Text[50];
    begin
        QuestnLine.RESET;
        QuestnLine.SETRANGE("Questionnaire Code", Rec."Questionnaire Code");
        QuestnLine.SETFILTER("Line No.", '<%1', Rec."Line No.");
        QuestnLine.SETRANGE(Type, Type::Question);
        IF QuestnLine.FIND('+') THEN
            EXIT(QuestnLine.Description);
    end;

    /// <summary>
    /// FindQuestionLine.
    /// </summary>
    /// <returns>Return variable QuestnLineNo of type Integer.</returns>
    procedure FindQuestionLine() QuestnLineNo: Integer;
    var
        QuestnLine: Record 52182468;
    begin
        QuestnLine.RESET;
        QuestnLine.SETRANGE("Questionnaire Code", "Questionnaire Code");
        QuestnLine.SETFILTER("Line No.", '<%1', "Line No.");
        QuestnLine.SETRANGE(Type, Type::Question);
        IF QuestnLine.FIND('+') THEN
            EXIT(QuestnLine."Line No.");
    end;

    /// <summary>
    /// CreateAnswer.
    /// </summary>
    /// <param name="AnswerDescription">Text[50].</param>
    procedure CreateAnswer(AnswerDescription: Text[50]);
    begin
        TempLineAnswer.INIT;
        TempLineAnswer."Line No." := (TempLineAnswer.COUNT + 1) * 10000;
        TempLineAnswer.Type := TempLineAnswer.Type::Answer;
        TempLineAnswer.Description := AnswerDescription;
        TempLineAnswer.INSERT;
    end;

    /// <summary>
    /// NoOfCandidateAnswers.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure NoOfCandidateAnswers(): Decimal;
    begin
        EXIT(TempLineAnswer.COUNT);
    end;

    /// <summary>
    /// GetAnswers.
    /// </summary>
    /// <param name="LineAnswer">VAR Record 51439.</param>
    procedure GetAnswers(var LineAnswer: Record "Candidate Quest.Line");
    begin
        TempLineAnswer.RESET;
        LineAnswer.RESET;
        LineAnswer.DELETEALL;
        IF TempLineAnswer.FIND('-') THEN
            REPEAT
                LineAnswer.INIT;
                LineAnswer := TempLineAnswer;
                LineAnswer.INSERT;
            UNTIL TempLineAnswer.NEXT = 0;
    end;
}

