/// <summary>
/// Codeunit Release Training Document (ID 52182423).
/// </summary>
codeunit 52182423 "Release Training Document"
//codeunit 39108395 "Release Training Document"
{
    // version HALRHPAIE.6.1.01

    TableNo = 52182441;

    trigger OnRun();
    var
        trainingLine: Record 52182442;
    begin
        IF Status = Status::Released THEN
            EXIT;
        TESTFIELD("Training No.");
        trainingLine.SETRANGE("Document Type", Rec."Document Type");
        trainingLine.SETRANGE("Document No.", Rec."No.");
        trainingLine.SETRANGE(Type, trainingLine.Type::Employee);
        IF NOT trainingLine.FIND('-') THEN
            ERROR(Text001, Rec."Document Type", Rec."No.");
        Status := Status::Released;
        MODIFY(TRUE);
    end;

    var
        Text001: TextConst ENU = 'There is nothing to release for %1 %2.', FRA = 'Il n''y a rien à lancer pour %1 %2.';

    /// <summary>
    /// Reopen.
    /// </summary>
    /// <param name="TrainingHeader">VAR Record 51412.</param>
    procedure Reopen(var TrainingHeader: Record 52182441);
    var
        TrainingLine: Record 52182442;
    begin
        WITH TrainingHeader DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Open;
            MODIFY(TRUE);
        END;
    end;

    /// <summary>
    /// Archive.
    /// </summary>
    /// <param name="TrainingHeader">Record 52182441.</param>
    procedure Archive(TrainingHeader: Record 52182441);
    begin
        WITH TrainingHeader DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Archived;
            MODIFY(TRUE);
        END;
    end;

    /// <summary>
    /// PerformManualRelease.
    /// </summary>
    /// <param name="trainingHeader">VAR Record 52182442.</param>
    procedure PerformManualRelease(var trainingHeader: Record 52182442);
    begin
        CODEUNIT.RUN(39108395, trainingHeader);
    end;

    /// <summary>
    /// PerformManualReopen.
    /// </summary>
    /// <param name="trainingHeader">VAR Record 52182441.</param>
    procedure PerformManualReopen(var trainingHeader: Record 52182441);
    begin
        Reopen(trainingHeader);
    end;

    /// <summary>
    /// PerformManualArchive.
    /// </summary>
    /// <param name="trainingHeader">VAR Record 52182441.</param>
    procedure PerformManualArchive(var trainingHeader: Record 52182441);
    begin
        Archive(trainingHeader);
    end;
}

