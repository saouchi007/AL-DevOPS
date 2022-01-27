/// <summary>
/// Codeunit CandidateManagement (ID 52182428).
/// </summary>
codeunit 52182428 CandidateManagement
//codeunit 39108400 CandidateManagement
{
    // version HALRHPAIE.6.1.01


    trigger OnRun();
    begin
    end;

    var
        Text000: TextConst ENU = 'GENERAL', FRA = 'GENERAL';
        Text001: TextConst ENU = 'General', FRA = 'Général';
        Text002: TextConst ENU = 'No Profile Questionnaire is created for this Contact.', FRA = 'Aucun questionnaire profil n''a été créé pour ce contact.';
        QuestnHeaderTemp: Record "Candidate Quest.Header" temporary;

    procedure GetQuestionnaire(): Code[10];
    var
        QuestnHeader: Record "Candidate Quest.Header";
    begin
        IF QuestnHeader.FIND('-') THEN
            EXIT(QuestnHeader.Code);

        QuestnHeader.INIT;
        QuestnHeader.Code := Text000;
        QuestnHeader.Description := Text001;
        QuestnHeader.INSERT;
        EXIT(QuestnHeader.Code);
    end;

    /// <summary>
    /// QuestionnaireAllowed.
    /// </summary>
    /// <param name="Candidate">Record Candidate.</param>
    /// <param name="QuestnHeaderCode">Code[10].</param>
    /// <returns>Return value of type Code[10].</returns>
    procedure QuestionnaireAllowed(Candidate: Record Candidate; QuestnHeaderCode: Code[10]): Code[10];
    begin
        IF QuestnHeaderTemp.GET(QuestnHeaderCode) THEN
            EXIT(QuestnHeaderCode)
        ELSE
            IF QuestnHeaderTemp.FIND('-') THEN
                EXIT(QuestnHeaderTemp.Code)
            ELSE
                ERROR(Text002, QuestnHeaderTemp.TABLECAPTION);
    end;

    /// <summary>
    /// CheckName.
    /// </summary>
    /// <param name="CurrentQuestionsChecklistCode">Code[10].</param>
    /// <param name="Candidate">VAR Record Candidate.</param>
    procedure CheckName(CurrentQuestionsChecklistCode: Code[10]; var Candidate: Record Candidate);
    begin
        QuestnHeaderTemp.GET(CurrentQuestionsChecklistCode);
    end;

    /// <summary>
    /// SetName.
    /// </summary>
    /// <param name="QuestnHeaderCode">Code[10].</param>
    /// <param name="QuestnLine">VAR Record "Candidate Quest.Line".</param>
    /// <param name="CandidateAnswerLine">Integer.</param>
    procedure SetName(QuestnHeaderCode: Code[10]; var QuestnLine: Record "Candidate Quest.Line"; CandidateAnswerLine: Integer);
    begin
        QuestnLine.FILTERGROUP := 2;
        QuestnLine.SETRANGE("Questionnaire Code", QuestnHeaderCode);
        QuestnLine.FILTERGROUP := 0;
        IF CandidateAnswerLine = 0 THEN
            IF QuestnLine.FIND('-') THEN;
    end;

    /// <summary>
    /// LookupName.
    /// </summary>
    /// <param name="QuestnHeaderCode">VAR Code[10].</param>
    /// <param name="QuestnLine">VAR Record "Candidate Quest.Line".</param>
    /// <param name="Candidate">VAR Record Candidate.</param>
    procedure LookupName(var QuestnHeaderCode: Code[10]; var QuestnLine: Record "Candidate Quest.Line"; var Candidate: Record Candidate);
    begin
        COMMIT;
        IF QuestnHeaderTemp.GET(QuestnHeaderCode) THEN;
        IF PAGE.RUNMODAL(
          PAGE::"Profile Questionnaire List", QuestnHeaderTemp) = ACTION::LookupOK
        THEN
            QuestnHeaderCode := QuestnHeaderTemp.Code;

        SetName(QuestnHeaderCode, QuestnLine, 0);
    end;
}

