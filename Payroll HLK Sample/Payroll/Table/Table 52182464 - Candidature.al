/// <summary>
/// Table Candidature (ID 52182464).
/// </summary>
table 52182464 Candidature
//table 39108435 Candidature
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidature',
                FRA = 'Candidature';
    //DrillDownPageID = 39108450;
    //LookupPageID = 39108450;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Candidature Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            OptionCaptionML = ENU = 'External,Internal',
                              FRA = 'Externe,Interne';
            OptionMembers = External,Internal;
        }
        field(3; "Candidate No."; Code[20])
        {
            CaptionML = ENU = 'Candidate No.',
                        FRA = 'N° Candidat';
            TableRelation = IF (Type = CONST(External)) Candidate
            ELSE
            IF (Type = CONST(Internal)) Employee WHERE(Status = CONST(Active));

            trigger OnValidate();
            begin
                IF "Candidate No." = '' THEN BEGIN
                    "First Name" := '';
                    "Middle Name" := '';
                    "Last Name" := '';
                END
                ELSE BEGIN
                    IF Type = Type::External THEN BEGIN
                        Candidate.GET("Candidate No.");
                        "First Name" := Candidate."First Name";
                        "Middle Name" := Candidate."Middle Name";
                        "Last Name" := Candidate."Last Name";
                    END;
                    IF Type = Type::Internal THEN BEGIN
                        Salarie.GET("Candidate No.");
                        "First Name" := Salarie."First Name";
                        "Middle Name" := Salarie."Middle Name";
                        "Last Name" := Salarie."Last Name";
                    END;
                END;
            end;
        }
        field(4; "Open post No."; Code[20])
        {
            CaptionML = ENU = 'Open post No.',
                        FRA = 'N° Poste ouvert';
            Editable = true;
            TableRelation = "Open Post";

            trigger OnValidate();
            begin
                IF "Open post No." = '' THEN
                    EXIT
                ELSE BEGIN
                    OpenPost.GET("Open post No.");
                    "Open Post Description" := OpenPost."Post Description";
                    "Structure Code" := OpenPost."Structure Code";
                    "Structure Description" := OpenPost."Structure Description";
                END;
            end;
        }
        field(5; "First Name"; Text[50])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
            Editable = false;
        }
        field(6; "Middle Name"; Text[50])
        {
            CaptionML = ENU = 'Middle Name',
                        FRA = 'Nom de jeune fille';
            Editable = false;
        }
        field(7; "Last Name"; Text[50])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
            Editable = false;

            trigger OnValidate();
            begin
                IF "Search Name" = '' THEN
                    "Search Name" := "Last Name";
            end;
        }
        field(8; "Open Post Description"; Text[50])
        {
            CaptionML = ENU = 'Open Post Description',
                        FRA = 'Désignation poste ouvert';
            Editable = false;
        }
        field(9; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),//CONST(15)
                                                                     "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            FieldClass = FlowField;
        }
        field(10; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'Souches de n°';
            TableRelation = "No. Series";
        }
        field(11; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified',
                        FRA = 'Date dern. modification';
        }
        field(12; "Search Name"; Code[30])
        {
            CaptionML = ENU = 'Search Name',
                        FRA = 'Nom de recherche';
        }
        field(13; "Structure Code"; Code[10])
        {
            CaptionML = ENU = 'Structure Code',
                        FRA = 'Code structure';
            Editable = false;
            TableRelation = Structure;
        }
        field(14; "Structure Description"; Text[50])
        {
            CaptionML = ENU = 'Structure Description',
                        FRA = 'Désignation de structure';
            Editable = false;
        }
        field(15; "Questionnaire Code"; Code[10])
        {
            CaptionML = ENU = 'Questionnaire Code',
                        FRA = 'Code questionnaire';
            TableRelation = "Candidate Quest.Header" WHERE(Type = CONST(Candidate));

            trigger OnValidate();
            begin
                IF "Questionnaire Code" = '' THEN
                    EXIT;
                CandidateAnswer.RESET;
                CandidateAnswer.SETRANGE(CandidateAnswer."Candidature No.", "No.");
                CandidateAnswer.SETRANGE(CandidateAnswer."Questionnaire Code", "Questionnaire Code");
                IF NOT CandidateAnswer.FINDSET THEN BEGIN
                    QuestLine.RESET;
                    QuestLine.SETRANGE(QuestLine."Questionnaire Code", "Questionnaire Code");
                    QuestLine.FINDFIRST;
                    REPEAT
                        CandidateAnswer.INIT;
                        CandidateAnswer."Candidature No." := "No.";
                        CandidateAnswer."Questionnaire Code" := "Questionnaire Code";
                        CandidateAnswer."Line No." := QuestLine."Line No.";
                        CandidateAnswer.Type := QuestLine.Type;
                        CandidateAnswer.Description := QuestLine.Description;
                        CandidateAnswer."Multiple Answers" := QuestLine."Multiple Answers";
                        CandidateAnswer."Free Text" := QuestLine."Free Text";
                        CandidateAnswer."Questionnaire Priority" := QuestLine.Priority;
                        CandidateAnswer."Last Date Updated" := TODAY;
                        CandidateAnswer.INSERT;
                    UNTIL QuestLine.NEXT = 0;
                END;
            end;
        }
        field(16; "Interviewing Responsible No."; Code[20])
        {
            CaptionML = ENU = 'Interviewing Responsible No.',
                        FRA = 'N° chargé de l''entretien';
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF "Interviewing Responsible No." = '' THEN BEGIN
                    "Interv. Responsible First Name" := '';
                    "Interv. Responsible Last Name" := '';
                END
                ELSE BEGIN
                    Salarie.GET("Interviewing Responsible No.");
                    "Interv. Responsible First Name" := Salarie."First Name";
                    "Interv. Responsible Last Name" := Salarie."Last Name";
                END;
            end;
        }
        field(17; "Interv. Responsible First Name"; Text[30])
        {
            CaptionML = ENU = 'Interv. Responsible First Name',
                        FRA = 'Prénom chargé de l''entretien';
            Editable = false;
        }
        field(18; "Interv. Responsible Last Name"; Text[30])
        {
            CaptionML = ENU = 'Interv. Responsible Last Name',
                        FRA = 'Nom Chargé de l''entretien';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        HumanResComment.SETRANGE("No.", "No.");
        HumanResComment.DELETEALL;
    end;

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Candidature Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Candidature Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        Candidature: Record 52182464;
        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit 396;
        CandidateQualification: Record 52182461;
        HumanResComment: Record 5208;
        Candidate: Record 52182456;
        Salarie: Record 5200;
        OpenPost: Record 52182455;
        QuestLine: Record 52182468;
        CandidateAnswer: Record 52182470;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldCandidature">Record 51435.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldCandidature: Record 52182464): Boolean;
    begin
        WITH Candidature DO BEGIN
            Candidature := Rec;
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Candidature Nos.");
            IF NoSeriesMgt.SelectSeries(HumanResSetup."Candidature Nos.", OldCandidature."No. Series", "No. Series") THEN BEGIN
                HumanResSetup.GET;
                HumanResSetup.TESTFIELD("Candidature Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := Candidature;
                EXIT(TRUE);
            END;
        END;
    end;
}

