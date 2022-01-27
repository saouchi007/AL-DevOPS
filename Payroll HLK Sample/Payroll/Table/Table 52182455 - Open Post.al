/// <summary>
/// Table Open Post (ID 52182455).
/// </summary>
table 52182455 "Open Post"
//table 39108426 "Open Post"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Open Post',
                FRA = 'Poste ouvert';
    //DrillDownPageID = 39108442;
    //LookupPageID = 39108442;

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
                    NoSeriesMgt.TestManual(HumanResSetup."Open Post Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code poste';
            TableRelation = Post;

            trigger OnValidate();
            begin
                IF "Post Code" = '' THEN
                    "Post Description" := ''
                ELSE
                    IF "Post Description" = '' THEN BEGIN
                        Post.GET("Post Code");
                        "Post Description" := Post.Description;
                    END;
            end;
        }
        field(3; "Post Description"; Text[50])
        {
            CaptionML = ENU = 'Post Description',
                        FRA = 'Désignation poste';
        }
        field(4; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date début';
        }
        field(5; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date fin';
        }
        field(6; "Structure Code"; Code[10])
        {
            CaptionML = ENU = 'Structure Code',
                        FRA = 'Code structure';
            TableRelation = Structure;

            trigger OnValidate();
            begin
                IF "Structure Code" = '' THEN
                    "Structure Description" := ''
                ELSE BEGIN
                    Structure.GET("Structure Code");
                    "Structure Description" := Structure.Description;
                END;
            end;
        }
        field(7; Status; Option)
        {
            CaptionML = ENU = 'Status',
                        FRA = 'Statut';
            OptionCaptionML = ENU = 'Open,Canceled,Closed',
                              FRA = 'Ouvert,Annulé,Clôturé';
            OptionMembers = Open,Canceled,Closed;
        }
        field(8; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'N° Série';
            TableRelation = "No. Series";
        }
        /*field(9; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(17),
                                                      "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }*/
        field(10; "Structure Description"; Text[50])
        {
            CaptionML = ENU = 'Structure Description',
                        FRA = 'Désignation de structure';
            Editable = false;
        }
        field(11; "Profile Questionnaire"; Code[10])
        {
            CaptionML = ENU = 'Profile Questionnaire',
                        FRA = 'Questionnaire de profil';
            TableRelation = "Candidate Quest.Header" WHERE(Type = CONST(Candidate));
        }
        field(12; "Rating Questionnaire"; Code[10])
        {
            CaptionML = ENU = 'Rating Questionnaire',
                        FRA = 'Questionnaire de notation';
            TableRelation = "Candidate Quest.Header" WHERE(Type = CONST(Candidate));
        }
        field(13; Reference; Text[30])
        {
            CaptionML = ENU = 'Reference',
                        FRA = 'Référence';
        }
        field(14; "Recruitment Mode"; Code[10])
        {
            CaptionML = ENU = 'Recruitment Mode',
                        FRA = 'Mode recrutement';
            TableRelation = "Recruitment Mode";

            trigger OnValidate();
            begin
                IF ("Ending Date" = 0D) AND ("Starting Date" <> 0D) THEN BEGIN
                    RecruitmentMode.GET("Recruitment Mode");
                    IF RecruitmentMode."Availability Nbre of Days" > 0 THEN
                        "Ending Date" := "Starting Date" + RecruitmentMode."Availability Nbre of Days";
                END;
            end;
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

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD(HumanResSetup."Open Post Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Open Post Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    var
        OpenPost: Record 52182455;
        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit 396;
        Post: Record 52182431;
        Structure: Record 52182434;
        RecruitmentMode: Record 52182472;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldOpenPost">Record 51426.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldOpenPost: Record "Open Post"): Boolean;
    begin
        WITH OpenPost DO BEGIN
            COPY(Rec);
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Open Post Nos.");
            IF NoSeriesMgt.SelectSeries(HumanResSetup."Open Post Nos.", OldOpenPost."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := OpenPost;
                EXIT(TRUE);
            END;
        END;
    end;
}

