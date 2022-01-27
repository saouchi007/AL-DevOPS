/// <summary>
/// Table Training (ID 52182432).
/// </summary>
table 52182432 Training
//table 39108403 Training

{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training',
                FRA = 'Formation';
    DataCaptionFields = "No.", Description;
    //DrillDownPageID = 39108406;
    //LookupPageID = 39108406;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
            NotBlank = false;

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Training Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; Aim; Code[10])
        {
            CaptionML = ENU = 'Aim',
                        FRA = 'Objectif';
            TableRelation = "Training Aim";
        }
        field(4; Sanction; Option)
        {
            CaptionML = ENU = 'Sanction',
                        FRA = 'Sanction';
            OptionCaptionML = ENU = ' ,Qualification,Diploma',
                              FRA = ' ,Qualification,Diplôme';
            OptionMembers = Blank,Qualification,Diploma;

            trigger OnValidate();
            begin
                IF (Sanction <> xRec.Sanction)
                OR (Sanction = Sanction::Blank) THEN BEGIN
                    VALIDATE("Sanction Code", '');
                    VALIDATE("Diploma Domain Code", '');
                END;
            end;
        }
        field(5; "Domain Code"; Code[10])
        {
            CaptionML = ENU = 'Domain Code',
                        FRA = 'Code domaine';
            TableRelation = "Training Domain";

            trigger OnValidate();
            begin
                UpdateDomainDesc;
            end;
        }
        field(6; "Subdomain Code"; Code[10])
        {
            CaptionML = ENU = 'Subdomain Code',
                        FRA = 'Code sous-domaine';
            TableRelation = "Training Subdomain" WHERE("Domain Code" = FIELD("Domain Code"));

            trigger OnValidate();
            begin
                UpdateDomainDesc;
            end;
        }
        field(7; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'N° Série';
            TableRelation = "No. Series";
        }
        field(8; "Domain Description"; Text[50])
        {
            CaptionML = ENU = 'Domain Description',
                        FRA = 'Désignation de domaine';
            Editable = false;
        }
        field(9; "Subdomain Description"; Text[50])
        {
            CaptionML = ENU = 'Subdomain Description',
                        FRA = 'Désignation de sous-domaine';
            Editable = false;
        }
        field(10; "Required Level"; Code[10])
        {
            CaptionML = ENU = 'Required Level',
                        FRA = 'Niveau requis';
            TableRelation = "Course Grade";
        }
        field(11; Type; Code[10])
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            TableRelation = "Training Type";
        }
        /* field(12; Comment; Boolean)
         {
             CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(15), "No." = FIELD("No.")));
             CaptionML = ENU = 'Comment',
                         FRA = 'Commentaire';
             FieldClass = FlowField;
         }*/
        field(13; "Sanction Code"; Code[10])
        {
            CaptionML = ENU = 'Sanction Code',
                        FRA = 'Code sanction';
            TableRelation = IF (Sanction = CONST(Qualification)) Qualification.Code
            ELSE
            IF (Sanction = CONST(Diploma)) Diploma.Code;

            trigger OnValidate();
            begin
                IF "Sanction Code" = '' THEN BEGIN
                    "Sanction Description" := '';
                    EXIT;
                END;
                IF Sanction = Sanction::Qualification THEN BEGIN
                    Qualification.GET("Sanction Code");
                    "Sanction Description" := Qualification.Description;
                END;
                IF Sanction = Sanction::Diploma THEN BEGIN
                    Diploma.GET("Sanction Code");
                    "Sanction Description" := Diploma.Description;
                END;
            end;
        }
        field(14; "Sanction Description"; Text[50])
        {
            CaptionML = ENU = 'Sanction Description',
                        FRA = 'Désignation sanction';
            Editable = false;
        }
        field(15; Blocked; Boolean)
        {
            CaptionML = ENU = 'Blocked',
                        FRA = 'Bloquée';
        }
        field(16; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified',
                        FRA = 'Date dern. modification';
            Editable = false;
        }
        field(17; "Diploma Domain Code"; Code[10])
        {
            CaptionML = ENU = 'Diploma Domain Code',
                        FRA = 'Code domaine du diplôme';
            TableRelation = IF (Sanction = CONST(Diploma)) "Diploma Domain";

            trigger OnValidate();
            begin
                IF "Diploma Domain Code" = '' THEN
                    "Diploma Domain Description" := ''
                ELSE BEGIN
                    DiplomaDomain.GET("Diploma Domain Code");
                    "Diploma Domain Description" := DiplomaDomain.Description;
                END;
            end;
        }
        field(18; "Diploma Domain Description"; Text[50])
        {
            CaptionML = ENU = 'Diploma Domain Description',
                        FRA = 'Désignation domaine du diplôme';
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
        CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::MyValue15);// it was "15" I create Enum extend to 97 
        CommentLine.SETRANGE("No.", "No.");
        CommentLine.DELETEALL;
    end;

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Training Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Training Nos.", xRec."No. Series", 0D, "No.", "No. Series");
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
        TrainingInstitution: Record 52182428;
        Qualification: Record 5202;
        Diploma: Record 52182426;
        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Training: Record 52182432;
        Domain: Record "Training Domain";
        Subdomain: Record "Training Subdomain";
        CommentLine: Record 97;
        DiplomaDomain: Record 52182425;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldTraining">Record 51403.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldTraining: Record Training): Boolean;
    begin
        WITH Training DO BEGIN
            COPY(Rec);
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Training Nos.");
            IF NoSeriesMgt.SelectSeries(HumanResSetup."Training Nos.", OldTraining."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := Training;
                EXIT(TRUE);
            END;
        END;
    end;

    procedure UpdateDomainDesc();
    begin
        IF "Domain Code" <> xRec."Domain Code" THEN
            "Subdomain Code" := '';
        IF "Domain Code" = '' THEN
            "Domain Description" := ''
        ELSE BEGIN
            Domain.GET("Domain Code");
            "Domain Description" := Domain.Description;
        END;
        IF "Subdomain Code" = '' THEN
            "Subdomain Description" := ''
        ELSE
            IF "Domain Code" <> '' THEN BEGIN
                Subdomain.GET("Subdomain Code", "Domain Code");
                "Subdomain Description" := Subdomain.Description;
            END;
    end;
}

