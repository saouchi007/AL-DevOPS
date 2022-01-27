/// <summary>
/// Table Training Header (ID 52182441).
/// </summary>
table 52182441 "Training Header"
//table 39108412 "Training Header"
{

    CaptionML = ENU = 'Training Header',
                FRA = 'En-tête formation';
    DataCaptionFields = "No.";
    // DrillDownPageID = 39108474;
    // LookupPageID = 39108474;

    fields
    {
        field(1; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type',
                        FRA = 'Type document';
            OptionCaptionML = ENU = 'Request,Registration,Action',
                              FRA = 'Demande,Inscription,Action';
            OptionMembers = Request,Registration,"Action";
        }
        field(2; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Training Registration Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(3; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date',
                        FRA = 'Date document';

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(4; Status; Option)
        {
            CaptionML = ENU = 'Status',
                        FRA = 'Statut';
            Editable = false;
            OptionCaptionML = ENU = 'Open,Released',
                              FRA = 'Ouvert,Lancé,Archivé';
            OptionMembers = Open,Released,Archived;
        }
        field(5; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'Souches de n°';
            TableRelation = "No. Series";
        }
        field(6; "Posting No. Series"; Code[10])
        {
            CaptionML = ENU = 'Posting No. Series',
                        FRA = 'Souches de n° validation';
            TableRelation = "No. Series";
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU = 'Shortcut Dimension 1 Code',
                        FRA = 'Code raccourci axe 1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU = 'Shortcut Dimension 2 Code',
                        FRA = 'Code raccourci axe 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(9; "Training No."; Code[20])
        {
            CaptionML = ENU = 'Training No.',
                        FRA = 'N° formation';
            TableRelation = Training;

            trigger OnValidate();
            begin
                TESTFIELD(Status, Status::Open);
                IF "Document Type" = "Document Type"::Registration THEN BEGIN
                    TrainingLine.RESET;
                    TrainingLine.SETRANGE("Document Type", "Document Type");
                    TrainingLine.SETRANGE("Document No.", "No.");
                    TrainingLine.SETRANGE(Type, TrainingLine.Type::Employee);
                    TrainingLine.SETFILTER("No.", '<>%1', '');
                    TrainingLine.SETFILTER(Status, '%1|%2', TrainingLine.Status::Released, TrainingLine.Status::Finished);
                    IF TrainingLine.FINDSET THEN BEGIN
                        MESSAGE(Text001, FIELDCAPTION("Training No."));
                        "Training No." := xRec."Training No.";
                        EXIT;
                    END;
                END;
                IF "Training No." = '' THEN BEGIN
                    "Training Description" := '';
                    Type := '';
                    "Domain Code" := '';
                    "Domain Description" := '';
                    "Subdomain Description" := '';
                    Aim := '';
                    "Required Level" := '';
                    Sanction := Sanction::Blank;
                    "Sanction Code" := '';
                    "Sanction Description" := '';
                    "Diploma Domain Code" := '';
                    "Diploma Domain Description" := '';
                    VALIDATE("Institution No.", '');
                    VALIDATE("Session No.", '');
                END
                ELSE BEGIN
                    IF "Training No." <> xRec."Training No." THEN BEGIN
                        Training.GET("Training No.");
                        Training.TESTFIELD(Blocked, FALSE);
                        "Training Description" := Training.Description;
                        Type := Training.Type;
                        "Domain Code" := Training."Domain Code";
                        "Domain Description" := Training."Domain Description";
                        "Subdomain Description" := Training."Subdomain Description";
                        //Aim:=Training.Aim;
                        "Required Level" := Training."Required Level";
                        Sanction := Training.Sanction;
                        "Sanction Code" := Training."Sanction Code";
                        "Sanction Description" := Training."Sanction Description";
                        "Diploma Domain Code" := Training."Diploma Domain Code";
                        "Diploma Domain Description" := Training."Diploma Domain Description";
                        VALIDATE("Institution No.", '');
                        VALIDATE("Session No.", '');
                    END
                END;
            end;
        }
        field(10; "Training Description"; Text[50])
        {
            CaptionML = ENU = 'Training Description',
                        FRA = 'Désignation formation';
            Editable = false;
        }
        field(11; Comment; Boolean)
        {
            CalcFormula = Exist("Training Comment Line" WHERE("Document Type" = FIELD("Document Type"),
                                                               "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; Aim; Code[10])
        {
            CaptionML = ENU = 'Aim',
                        FRA = 'Objectif';
            Editable = false;
        }
        field(13; Type; Code[10])
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
        }
        field(14; "Domain Description"; Text[50])
        {
            CaptionML = ENU = 'Domain Description',
                        FRA = 'Désignation de domaine';
            Editable = false;
        }
        field(15; "Subdomain Description"; Text[50])
        {
            CaptionML = ENU = 'Subdomain Description',
                        FRA = 'Désignation de sous-domaine';
            Editable = false;
        }
        field(16; "Required Level"; Code[10])
        {
            CaptionML = ENU = 'Required Level',
                        FRA = 'Niveau requis';
            Editable = false;
            TableRelation = "Course Grade";
        }
        field(17; Sanction; Option)
        {
            CaptionML = ENU = 'Sanction',
                        FRA = 'Sanction';
            Editable = false;
            OptionCaptionML = ENU = ' ,Qualification,Diploma',
                              FRA = ' ,Qualification,Diplôme';
            OptionMembers = Blank,Qualification,Diploma;
        }
        field(18; "Sanction Description"; Text[50])
        {
            CaptionML = ENU = 'Sanction Description',
                        FRA = 'Désignation sanction';
            Editable = false;
        }
        field(19; "No. of Employees"; Integer)
        {
            CalcFormula = Count("Training Line" WHERE(Status = FILTER(Released | Finished),
                                                       "Document No." = FIELD("No.")));
            CaptionML = ENU = 'No. of Employees',
                        FRA = 'Nbre de salariés';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Institution No."; Code[20])
        {
            CaptionML = ENU = 'Institution No.',
                        FRA = 'N° Etablissement';
            TableRelation = "Training Institution Catalog"."Training Institution No." WHERE("Training No." = FIELD("Training No."));
        }
        field(21; "Session No."; Code[20])
        {
            CaptionML = ENU = 'Session No.',
                        FRA = 'N° Session';
            TableRelation = "Training Session"."No." WHERE("Training No." = FIELD("Training No."),
                                                          "Institution No." = FIELD("Institution No."));

            trigger OnValidate();
            begin
                UpdateSessionInfo;
            end;
        }
        field(22; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date de début';

            trigger OnValidate();
            begin
                UpdateLinesDates;
            end;
        }
        field(23; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date de fin';

            trigger OnValidate();
            begin
                UpdateLinesDates;
            end;
        }
        field(24; "Starting Time"; Time)
        {
            CaptionML = ENU = 'Starting Time',
                        FRA = 'Heure début';
        }
        field(25; "Ending Time"; Time)
        {
            CaptionML = ENU = 'Ending Time',
                        FRA = 'Heure fin';
        }
        field(26; Cost; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Cost',
                        FRA = 'Coût par apprenant';
        }
        field(27; "Sanction Code"; Code[20])
        {
            CaptionML = ENU = 'Sanction Code',
                        FRA = 'Code sanction';
            Editable = false;
            TableRelation = IF (Sanction = CONST(Qualification)) Qualification.Code
            ELSE
            IF (Sanction = CONST(Diploma)) Diploma.Code;
        }
        field(28; "Domain Code"; Code[20])
        {
            CaptionML = ENU = 'Domain Code',
                        FRA = 'Code domaine';
            Editable = false;
            TableRelation = "Training Domain";
        }
        field(29; "Diploma Domain Code"; Code[10])
        {
            CaptionML = ENU = 'Diploma Domain Code',
                        FRA = 'Code domaine du diplôme';
            Editable = false;
            TableRelation = IF (Sanction = CONST(Diploma)) "Diploma Domain";
        }
        field(30; "Diploma Domain Description"; Text[50])
        {
            CaptionML = ENU = 'Diploma Domain Description',
                        FRA = 'Désignation domaine du diplôme';
            Editable = false;
        }
        field(31; "Frais d'hébergement"; Decimal)
        {
            Caption = 'Frais d''hébergement par apprenant';

            trigger OnValidate();
            begin
                "Coût Total" := (("Frais d'hébergement" + "Frais de restauration" + "Frais de transport" + "Autres Frais"
                + Cost) * "No. of Employees") + "Frais Personnel Total";
            end;
        }
        field(32; "Frais de restauration"; Decimal)
        {
            Caption = 'Frais de restauration par apprenant';

            trigger OnValidate();
            begin
                "Coût Total" := (("Frais d'hébergement" + "Frais de restauration" + "Frais de transport" + "Autres Frais"
                + Cost) * "No. of Employees") + "Frais Personnel Total";
            end;
        }
        field(33; "Frais de transport"; Decimal)
        {
            Caption = 'Frais de transport par apprenant';

            trigger OnValidate();
            begin
                "Coût Total" := (("Frais d'hébergement" + "Frais de restauration" + "Frais de transport" + "Autres Frais"
                + Cost) * "No. of Employees") + "Frais Personnel Total";
            end;
        }
        field(34; "Autres Frais"; Decimal)
        {
            Caption = 'Autres Frais par apprenant';

            trigger OnValidate();
            begin
                "Coût Total" := (("Frais d'hébergement" + "Frais de restauration" + "Frais de transport" + "Autres Frais"
                + Cost) * "No. of Employees") + "Frais Personnel Total";
            end;
        }
        field(35; "Coût Total"; Decimal)
        {
            Caption = 'Coût Total de la formation';
        }
        field(36; "Frais personnel Horaire"; Decimal)
        {
            CalcFormula = Sum("Training Line"."Masse salariale Horaire" WHERE("Document No." = FIELD("No."),
                                                                               Status = FILTER(Finished)));
            FieldClass = FlowField;
        }
        field(37; "Durée"; Decimal)
        {
        }
        field(38; "Frais Personnel Total"; Decimal)
        {
        }
        field(39; "Lieu de la Formation"; Text[50])
        {
        }
        field(40; "Nom Formateur"; Text[50])
        {
        }
        field(41; "Update Costs"; Boolean)
        {
            Caption = 'Mise à jour Frais';

            trigger OnValidate();
            begin
                CALCFIELDS("Frais personnel Horaire");
                "Frais Personnel Total" := "Frais personnel Horaire" * Durée;
                "Coût Total" := (("Frais d'hébergement" + "Frais de restauration" + "Frais de transport" + "Autres Frais"
                + Cost) * "No. of Employees") + "Frais Personnel Total";
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
        }
        key(Key2; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //DimMgt.DeleteDocDim(DATABASE::"Training Header","Document Type","No.",0);
        DeleteTrainingLines;
        TrainingCommentLine.SETRANGE("Document Type", "Document Type");
        TrainingCommentLine.SETRANGE("No.", "No.");
        TrainingCommentLine.DELETEALL;
    end;

    trigger OnInsert();
    begin
        HumanResSetup.GET;
        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Document Date", "No.", "No. Series");
        END;
        "Document Date" := WORKDATE;
    end;

    var
        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit 396;
        TrainingHeader: Record 52182441;
        Training: Record 52182432;
        DimMgt: Codeunit 408;
        TrainingCommentLine: Record "Training Comment Line";
        TrainingLine: Record "Training Line";
        TrainingSession: Record "Training Session";
        TrainingCatalog: Record 52182430;
        Qualification: Record 5202;
        Diploma: Record 52182426;
        DiplomaDomain: Record 52182425;
        Text001: Label 'Impossible de modifier %1';

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldTrainingHeader">Record 51412.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldTrainingHeader: Record 52182432): Boolean;
    begin
        WITH TrainingHeader DO BEGIN
            COPY(Rec);
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Training Registration Nos.");
            IF NoSeriesMgt.SelectSeries(HumanResSetup."Training Registration Nos.", OldTrainingHeader."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := TrainingHeader;
                EXIT(TRUE);
            END;
        END;
    end;

    /// <summary>
    /// ShowDocDim.
    /// </summary>
    procedure ShowDocDim();
    var
        DocDims: Page 652;
    begin

        /*DocDims.SETRANGE("Table ID",DATABASE::"Training Header");
        DocDims.SETRANGE("Document Type","Document Type");
        DocDims.SETRANGE("Document No.","No.");
        DocDims.SETRANGE("Line No.",0);
        DocDims.SETTABLEVIEW(DocDim);
        DocDims.RUNMODAL;
        GET("Document Type","No.");*/

    end;

    /// <summary>
    /// ValidateShortcutDimCode.
    /// </summary>
    /// <param name="FieldNumber">Integer.</param>
    /// <param name="ShortcutDimCode">VAR Code[20].</param>
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        /*IF "No." <> '' THEN BEGIN
          DimMgt.SaveDocDim(
            DATABASE::"Training Header","Document Type","No.",0,FieldNumber,ShortcutDimCode);
          MODIFY;
        END ELSE
          DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);*/

    end;

    /// <summary>
    /// GetNoSeriesCode.
    /// </summary>
    /// <returns>Return value of type Code[10].</returns>
    procedure GetNoSeriesCode(): Code[10];
    begin
        CASE "Document Type" OF
            "Document Type"::Request:
                EXIT(HumanResSetup."Training Request Nos.");
            "Document Type"::Registration:
                EXIT(HumanResSetup."Training Registration Nos.");
        END;
    end;

    /// <summary>
    /// TestNoSeries.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure TestNoSeries(): Boolean;
    begin
        CASE "Document Type" OF
            "Document Type"::Request:
                HumanResSetup.TESTFIELD("Training Request Nos.");
            "Document Type"::Registration:
                HumanResSetup.TESTFIELD("Training Registration Nos.");
        END;
    end;

    /// <summary>
    /// DeleteTrainingLines.
    /// </summary>
    procedure DeleteTrainingLines();
    begin
        TrainingLine.SETRANGE("Document Type", "Document Type");
        TrainingLine.SETRANGE("Document No.", "No.");
        IF TrainingLine.FINDSET THEN BEGIN
            REPEAT
                TrainingLine.DELETE(TRUE);
            UNTIL TrainingLine.NEXT = 0;
        END;
    end;

    /// <summary>
    /// UpdateSessionInfo.
    /// </summary>
    procedure UpdateSessionInfo();
    begin
        IF "Institution No." <> xRec."Institution No." THEN
            "Session No." := '';
        IF "Session No." = '' THEN BEGIN
            "Starting Date" := 0D;
            "Ending Date" := 0D;
            "Starting Time" := 0T;
            "Ending Time" := 0T;
            Cost := 0;
        END
        ELSE
            IF ("Session No." <> xRec."Session No.") AND ("Training No." <> '') THEN BEGIN
                TrainingSession.GET("Institution No.", "Training No.", "Session No.");
                TrainingCatalog.GET("Institution No.", "Training No.");
                VALIDATE("Starting Date", TrainingSession."Starting Date");
                VALIDATE("Ending Date", TrainingSession."Ending Date");
                "Starting Time" := TrainingSession."Starting Time";
                "Ending Time" := TrainingSession."Ending Time";
                Cost := TrainingCatalog.Coût;
                IF TrainingCatalog."Unit of Measure" = 0 THEN
                    Durée := TrainingCatalog.Period;
                IF TrainingCatalog."Unit of Measure" = 1 THEN
                    Durée := TrainingCatalog.Period * 8;
                IF TrainingCatalog."Unit of Measure" = 2 THEN
                    Durée := TrainingCatalog.Period * 8 * 22;
                IF TrainingCatalog."Unit of Measure" = 3 THEN
                    Durée := TrainingCatalog.Period * 8 * 22 * 12;
                CALCFIELDS("Frais personnel Horaire");
                "Frais Personnel Total" := "Frais personnel Horaire" * Durée;
                "Coût Total" := (("Frais d'hébergement" + "Frais de restauration" + "Frais de transport" + "Autres Frais"
                + Cost) * "No. of Employees") + "Frais Personnel Total";
            END;
    end;

    /// <summary>
    /// UpdateLinesDates.
    /// </summary>
    procedure UpdateLinesDates();
    begin
        TrainingLine.SETRANGE("Document Type", "Document Type");
        TrainingLine.SETRANGE("Document No.", "No.");
        TrainingLine.SETRANGE(Status, TrainingLine.Status::Requested);
        IF TrainingLine.FINDSET THEN BEGIN
            REPEAT
                TrainingLine."Starting Date" := "Starting Date";
                TrainingLine."Ending Date" := "Ending Date";
                TrainingLine.MODIFY;
            UNTIL TrainingLine.NEXT = 0;
        END;
    end;
}

