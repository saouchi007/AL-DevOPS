/// <summary>
/// Codeunit Training-Request to Regist. (ID 51397).
/// </summary>
codeunit 52182425 "Training-Request to Regist."
//codeunit 39108397 "Training-Request to Regist."
{
    // version HALRHPAIE.6.1.01

    TableNo = 52182441;

    trigger OnRun();
    var
        OldTrainingCommentLine: Record 52182446;
        Training: Record 52182432;
    begin
        TESTFIELD("Document Type", Rec."Document Type"::Request);
        TESTFIELD("Training No.");
        TrainingRegistrationHeader := Rec;
        TrainingRegistrationHeader."Document Type" := TrainingRegistrationHeader."Document Type"::Registration;
        TrainingRegistrationHeader.Status := TrainingRegistrationHeader.Status::Open;
        TrainingRegistrationHeader."No." := '';
        TrainingRegistrationHeader.INSERT(TRUE);
        TrainingRequestLine.SETRANGE("Document Type", Rec."Document Type");
        TrainingRequestLine.SETRANGE("Document No.", Rec."No.");
        TrainingRequestLine.SETRANGE(Type, TrainingRequestLine.Type::Employee);
        TrainingRequestLine.SETRANGE(Processed, FALSE);
        TrainingRequestLine.SETRANGE(Selection, TRUE);
        TrainingRegistrationLine.LOCKTABLE;

        /*
        FromDocDim.SETRANGE("Table ID",DATABASE::"Training Header");
        FromDocDim.SETRANGE("Document Type","Document Type");
        FromDocDim.SETRANGE("Document No.","No.");
        
        ToDocDim.SETRANGE("Table ID",DATABASE::"Training Header");
        ToDocDim.SETRANGE("Document Type",TrainingRegistrationHeader."Document Type");
        ToDocDim.SETRANGE("Document No.",TrainingRegistrationHeader."No.");
        ToDocDim.DELETEALL;
        
        DocDim.MoveDocDimToDocDim(FromDocDim,DATABASE::"Training Header",
          TrainingRegistrationHeader."No.",TrainingRegistrationHeader."Document Type",0);
          */

        TrainingRegistrationHeader."Document Date" := Rec."Document Date";
        TrainingRegistrationHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
        TrainingRegistrationHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        TrainingRegistrationHeader.MODIFY;

        TrainingRequestLine.RESET;
        TrainingRequestLine.SETRANGE("Document Type", Rec."Document Type");
        TrainingRequestLine.SETRANGE("Document No.", Rec."No.");
        TrainingRequestLine.SETRANGE(Status, TrainingRequestLine.Status::Requested);
        TrainingRequestLine.SETRANGE(Selection, TRUE);

        /*
        FromDocDim.SETRANGE("Table ID",DATABASE::"Training Line");
        ToDocDim.SETRANGE("Table ID",DATABASE::"Training Line");
        */
        IF TrainingRequestLine.FINDSET THEN
            REPEAT
                TrainingRegistrationLine := TrainingRequestLine;
                TrainingRegistrationLine."Document Type" := TrainingRegistrationHeader."Document Type";
                TrainingRegistrationLine."Document No." := TrainingRegistrationHeader."No.";
                TrainingRegistrationLine."Shortcut Dimension 1 Code" := TrainingRequestLine."Shortcut Dimension 1 Code";
                TrainingRegistrationLine."Shortcut Dimension 2 Code" := TrainingRequestLine."Shortcut Dimension 2 Code";
                TrainingRegistrationLine.Status := TrainingRegistrationLine.Status::Requested;
                TrainingRegistrationLine.Selection := FALSE;
                TrainingRegistrationLine.INSERT;
            /*
            FromDocDim.SETRANGE("Line No.",TrainingRequestLine."Line No.");
            ToDocDim.SETRANGE("Line No.",TrainingRegistrationLine."Line No.");
            ToDocDim.DELETEALL;
            DocDim.MoveDocDimToDocDim(FromDocDim,DATABASE::"Training Line",
              TrainingRegistrationHeader."No.",TrainingRegistrationHeader."Document Type",
              TrainingRegistrationLine."Line No.");
              */
            UNTIL TrainingRequestLine.NEXT = 0;

        TrainingCommentLine.SETRANGE("Document Type", TrainingCommentLine."Document Type"::Request);
        TrainingCommentLine.SETRANGE("No.", Rec."No.");
        IF NOT TrainingCommentLine.ISEMPTY THEN BEGIN
            TrainingCommentLine.LOCKTABLE;
            IF TrainingCommentLine.FINDSET THEN
                REPEAT
                    OldTrainingCommentLine := TrainingCommentLine;
                    TrainingCommentLine."Document Type" := TrainingCommentLine."Document Type"::Registration;
                    TrainingCommentLine."No." := TrainingRegistrationHeader."No.";
                    TrainingCommentLine.INSERT;
                    TrainingCommentLine := OldTrainingCommentLine;
                UNTIL TrainingCommentLine.NEXT = 0;
        END;
        TrainingRegistrationHeader.COPYLINKS(Rec);

        IF TrainingRequestLine.FIND('-') THEN
            REPEAT
                TrainingRequestLine.Processed := TRUE;
                TrainingRequestLine.MODIFY;
            UNTIL TrainingRequestLine.NEXT = 0;

        COMMIT;

    end;

    var
        Text000: TextConst ENU = 'An Open Opportunity is linked to this quote.\', FRA = 'Sanctions générées pour les salariés ayant réussi la formation.';
        TrainingRequestLine: Record "Training Line";
        TrainingRegistrationHeader: Record 52182441;
        TrainingRegistrationLine: Record "Training Line";
        TrainingCommentLine: Record 52182446;
        DocDim: Codeunit DimensionManagement;
        HideValidationDialog: Boolean;
        DocLineComment: Record 97;
        ArchiveManagement: Codeunit 5063;
        EmployeeQualification: Record 5203;
        EmployeeDiploma: Record "Employee Diploma";
        LineNum: Integer;
        GeneratedSanctions: Boolean;
        Diploma: Record Diploma;

    /// <summary>
    /// GetTrainingRegistrationHeader.
    /// </summary>
    /// <param name="TrainingHeader2">VAR Record 52182441.</param>
    procedure GetTrainingRegistrationHeader(var TrainingHeader2: Record 52182441);
    begin
        TrainingHeader2 := TrainingRegistrationHeader;
    end;

    /// <summary>
    /// SetHideValidationDialog.
    /// </summary>
    /// <param name="NewHideValidationDialog">Boolean.</param>
    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean);
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    /// <summary>
    /// ReleaseTraining.
    /// </summary>
    /// <param name="Rec">Record 52182441.</param>
    procedure ReleaseTraining(Rec: Record 52182441);
    begin
        TrainingRegistrationLine.RESET;
        TrainingRegistrationLine.SETRANGE("Document Type", Rec."Document Type");
        TrainingRegistrationLine.SETRANGE("Document No.", Rec."No.");
        TrainingRegistrationLine.SETRANGE(Type, TrainingRegistrationLine.Type::Employee);
        TrainingRegistrationLine.SETFILTER("No.", '<>%1', '');
        TrainingRegistrationLine.SETRANGE(Status, TrainingRegistrationLine.Status::Requested);
        TrainingRegistrationLine.SETRANGE(Selection, TRUE);
        IF TrainingRegistrationLine.FINDSET THEN
            REPEAT
                TrainingRegistrationLine.Status := TrainingRegistrationLine.Status::Released;
                TrainingRegistrationLine.MODIFY;
            UNTIL TrainingRegistrationLine.NEXT = 0;
    end;

    /// <summary>
    /// FinishTraining.
    /// </summary>
    /// <param name="Rec">Record 52182441.</param>
    procedure FinishTraining(Rec: Record 52182441);
    begin
        GeneratedSanctions := FALSE;
        TrainingRegistrationLine.RESET;
        TrainingRegistrationLine.SETRANGE("Document Type", Rec."Document Type");
        TrainingRegistrationLine.SETRANGE("Document No.", Rec."No.");
        TrainingRegistrationLine.SETRANGE(Type, TrainingRegistrationLine.Type::Employee);
        TrainingRegistrationLine.SETFILTER("No.", '<>%1', '');
        TrainingRegistrationLine.SETRANGE(Status, TrainingRegistrationLine.Status::Released);
        TrainingRegistrationLine.SETRANGE(Selection, TRUE);
        IF TrainingRegistrationLine.FINDSET THEN
            REPEAT
                TrainingRegistrationLine.Status := TrainingRegistrationLine.Status::Finished;
                TrainingRegistrationLine.MODIFY;
                IF TrainingRegistrationLine.Assessment = TrainingRegistrationLine.Assessment::Success THEN
                    IF Rec.Sanction = Rec.Sanction::Qualification THEN
                        GenerateEmployeeQualification(Rec, TrainingRegistrationLine);
                IF Rec.Sanction = Rec.Sanction::Diploma THEN
                    GenerateEmployeeDiploma(Rec, TrainingRegistrationLine);
            UNTIL TrainingRegistrationLine.NEXT = 0;
        IF GeneratedSanctions THEN
            MESSAGE(Text000);
    end;

    /// <summary>
    /// CancelTraining.
    /// </summary>
    /// <param name="Rec">Record 52182441.</param>
    procedure CancelTraining(Rec: Record 52182441);
    begin
        TrainingRegistrationLine.RESET;
        TrainingRegistrationLine.SETRANGE("Document Type", Rec."Document Type");
        TrainingRegistrationLine.SETRANGE("Document No.", Rec."No.");
        TrainingRegistrationLine.SETRANGE(Type, TrainingRegistrationLine.Type::Employee);
        TrainingRegistrationLine.SETFILTER("No.", '<>%1', '');
        TrainingRegistrationLine.SETRANGE(Status, TrainingRegistrationLine.Status::Released);
        TrainingRegistrationLine.SETRANGE(Selection, TRUE);
        IF TrainingRegistrationLine.FINDSET THEN
            REPEAT
                TrainingRegistrationLine.Status := TrainingRegistrationLine.Status::Canceled;
                TrainingRegistrationLine.MODIFY;
            UNTIL TrainingRegistrationLine.NEXT = 0;
    end;

    /// <summary>
    /// GenerateEmployeeQualification.
    /// </summary>
    /// <param name="TrainingRegHeader">Record 52182441.</param>
    /// <param name="TrainingRegLine">Record "Training Line".</param>
    procedure GenerateEmployeeQualification(TrainingRegHeader: Record 52182441; TrainingRegLine: Record "Training Line");
    begin
        LineNum := 10000;
        EmployeeQualification.RESET;
        EmployeeQualification.SETRANGE(EmployeeQualification."Employee No.", TrainingRegLine."No.");
        IF EmployeeQualification.FINDLAST THEN
            LineNum := EmployeeQualification."Line No." + 10000;
        EmployeeQualification.INIT;
        EmployeeQualification."Employee No." := TrainingRegLine."No.";
        EmployeeQualification."Line No." := LineNum;
        EmployeeQualification."Qualification Code" := TrainingRegHeader."Sanction Code";
        EmployeeQualification."From Date" := TrainingRegLine."Ending Date";
        EmployeeQualification.Type := EmployeeQualification.Type::External;
        EmployeeQualification.Description := TrainingRegHeader."Sanction Description";
        EmployeeQualification."Institution/Company" := TrainingRegHeader."Institution No.";
        EmployeeQualification."Course Grade" := TrainingRegHeader."Required Level";
        EmployeeQualification.INSERT;
        GeneratedSanctions := TRUE;
    end;

    /// <summary>
    /// GenerateEmployeeDiploma.
    /// </summary>
    /// <param name="TrainingRegHeader">Record 52182441.</param>
    /// <param name="TrainingRegLine">Record "Training Line".</param>
    procedure GenerateEmployeeDiploma(TrainingRegHeader: Record 52182441; TrainingRegLine: Record "Training Line");
    begin
        EmployeeDiploma.INIT;
        EmployeeDiploma."Employee No." := TrainingRegLine."No.";
        EmployeeDiploma.VALIDATE("Diploma Code", TrainingRegHeader."Sanction Code");
        EmployeeDiploma.VALIDATE("Diploma Domain Code", TrainingRegHeader."Diploma Domain Code");
        EmployeeDiploma."Obtention Date" := TrainingRegLine."Ending Date";
        EmployeeDiploma.INSERT;
        GeneratedSanctions := TRUE;
    end;
}

