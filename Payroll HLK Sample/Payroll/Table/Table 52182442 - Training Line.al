/// <summary>
/// Table Training Line (ID 51413).
/// </summary>
table 52182442 "Training Line"
//table 39108413 "Training Line"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Line',
                FRA = 'Ligne formation';

    fields
    {
        field(1; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type',
                        FRA = 'Type de document';
            OptionCaptionML = ENU = 'Request,Registration,Action',
                              FRA = 'Demande,Inscription,Action';
            OptionMembers = Request,Registration,"Action";
        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.',
                        FRA = 'N° document';
            TableRelation = "Training Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.',
                        FRA = 'N° ligne';
        }
        field(4; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            OptionCaptionML = ENU = ' ,Employee',
                              FRA = ' ,Salarié';
            OptionMembers = " Blank",Employee;
        }
        field(5; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
            TableRelation = IF (Type = CONST(Employee)) "Employee"."No." WHERE(Status = CONST(Active));

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF Type = Type::Employee THEN BEGIN
                    IF "No." = '' THEN BEGIN
                        "First Name" := '';
                        "Last Name" := '';
                        EXIT;
                    END;
                    GetTrainingHeader;
                    Employee.GET("No.");
                    "First Name" := Employee."First Name";
                    "Last Name" := Employee."Last Name";
                    "Structure Code" := Employee."Structure Code";
                    "Structure Description" := Employee."Structure Description";
                    "Categorie SP" := Employee."Socio-Professional Category";

                    GetEmployee;
                    "Shortcut Dimension 1 Code" := TrainingHeader."Shortcut Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := TrainingHeader."Shortcut Dimension 2 Code";
                    "Request Date" := WORKDATE;
                END;
            end;
        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
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
        field(7; "Shortcut Dimension 2 Code"; Code[20])
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
        field(8; Initiative; Option)
        {
            CaptionML = ENU = 'Initiative',
                        FRA = 'Initiative';
            OptionCaptionML = ENU = 'Employee,Hierarchy,Direction',
                              FRA = 'Salarié,Hiérarchie,Direction';
            OptionMembers = Employee,Hierarchy,Direction;
        }
        field(9; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
            Editable = false;
        }
        field(10; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
            Editable = false;
        }
        field(11; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date de début';
            Editable = true;

            trigger OnValidate();
            begin
                ValidateDates;
            end;
        }
        field(12; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date de fin';
            Editable = true;

            trigger OnValidate();
            begin
                ValidateDates;
            end;
        }
        field(13; "No. Decision"; Text[30])
        {
            CaptionML = ENU = 'No. Decision',
                        FRA = 'N° Décision';
        }
        field(14; "Decision Date"; Date)
        {
            CaptionML = ENU = 'Decision Date',
                        FRA = 'Date de décision';
        }
        field(15; "Request Date"; Date)
        {
            CaptionML = ENU = 'Request Date',
                        FRA = 'Date de demande';
        }
        field(16; Status; Option)
        {
            CaptionML = ENU = 'Status',
                        FRA = 'Statut';
            Editable = false;
            OptionCaptionML = ENU = 'Requested,Released,Canceled,Finished',
                              FRA = 'Demandée,Lancée,Annulée,Terminée';
            OptionMembers = Requested,Released,Canceled,Finished;
        }
        field(17; Selection; Boolean)
        {
            CaptionML = ENU = 'Selection',
                        FRA = 'Sélection';

            trigger OnValidate();
            begin
                CALCFIELDS("Masse Salariale Mensuelle");
                "Masse salariale Horaire" := ROUND("Masse Salariale Mensuelle" / 173.33);
                GetTrainingHeader;
                "Autres Frais" := TrainingHeader."Frais d'hébergement" + TrainingHeader."Frais de restauration" + TrainingHeader."Frais de transport" +
                TrainingHeader.Cost;
            end;
        }
        field(18; Processed; Boolean)
        {
            CaptionML = ENU = 'Processed',
                        FRA = 'Traitée';
            Editable = false;
        }
        field(19; "Desired Starting Date"; Date)
        {
            CaptionML = ENU = 'Desired Starting Date',
                        FRA = 'Date de début souhaitée';

            trigger OnValidate();
            begin
                ValidateDesiredDates
            end;
        }
        field(20; "Desired Ending Date"; Date)
        {
            CaptionML = ENU = 'Desired Ending Date',
                        FRA = 'Date de fin souhaitée';

            trigger OnValidate();
            begin
                ValidateDesiredDates
            end;
        }
        field(21; Assessment; Option)
        {
            CaptionML = ENU = 'Assessment',
                        FRA = 'Evaluation';
            OptionCaptionML = ENU = ',Success,Failure',
                              FRA = ' ,Réussite,Echec';
            OptionMembers = Blank,Success,Failure;
        }
        field(22; "Cause of Training Cancellation"; Code[10])
        {
            CaptionML = ENU = 'Cause of Cancellation Code',
                        FRA = 'Code motif annulation';
            TableRelation = "Cause of Training Cancellation";
        }
        field(23; "Structure Code"; Code[10])
        {
        }
        field(24; "Structure Description"; Text[50])
        {
        }
        field(25; "Categorie SP"; Code[10])
        {
        }
        field(26; "Masse salariale Horaire"; Decimal)
        {
        }
        field(27; "Masse Salariale Mensuelle"; Decimal)
        {
            CalcFormula = Lookup("Terms of pay".Amount WHERE("Employee No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(28; "Durée"; Decimal)
        {
            CalcFormula = Lookup("Training Header"."Durée" WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(29; "Autres Frais"; Decimal)
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
        }
        key(Key2; Status)
        {
            SumIndexFields = "Masse salariale Horaire";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TestStatusOpen;
        /*DocDim.LOCKTABLE;
        LOCKTABLE;
        DimMgt.DeleteDocDim(DATABASE::"Training Line","Document Type","Document No.","Line No.");*/

    end;

    trigger OnInsert();
    begin
        TestStatusOpen;
        /*DocDim.LOCKTABLE;
        LOCKTABLE;
        TrainingHeader."No." := '';
        
        DimMgt.InsertDocDim(DATABASE::"Training Line","Document Type","Document No.","Line No.",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
          */

    end;

    trigger OnModify();
    begin
        TestStatusOpen;
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        Employee: Record 5200;
        Text001: Label 'La date de début doit être antérieure à la date de fin';
        StatusCheckSuspended: Boolean;
        TrainingHeader: Record 52182441;
        TrainingLine2: Record 52182442;

        Text000: Label 'Vous ne pouvez pas renommer %1.';

    procedure ShowDimensions();
    var
        DocDimensions: Page 652;
    begin
        /*TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        DocDim.SETRANGE("Table ID",DATABASE::"Training Line");
        DocDim.SETRANGE("Document Type","Document Type");
        DocDim.SETRANGE("Document No.","Document No.");
        DocDim.SETRANGE("Line No.","Line No.");
        DocDimensions.SETTABLEVIEW(DocDim);
        DocDimensions.RUNMODAL;*/

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        /*DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        IF "Line No." <> 0 THEN BEGIN
          DimMgt.SaveDocDim(
            DATABASE::"Training Line","Document Type","Document No.",
            "Line No.",FieldNumber,ShortcutDimCode);
          MODIFY;
        END ELSE
          DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);*/

    end;

    procedure ValidateDates();
    begin
        IF ("Starting Date" = 0D) OR ("Ending Date" = 0D) THEN
            EXIT;
        IF "Starting Date" > "Ending Date" THEN
            ERROR(Text001);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        /*IF "Line No." <> 0 THEN
          DimMgt.UpdateGenJnlLineDimFromVendLedgEntry(DATABASE::"Training Line","Document Type","Document No.","Line No.",ShortcutDimCode)
        ELSE
          DimMgt.ShowTempDim(ShortcutDimCode);*/

    end;

    procedure GetEmployee();
    begin
        TESTFIELD("No.");
        IF Employee."No." <> "No." THEN
            Employee.GET("No.");
    end;

    procedure GetTrainingHeader();
    begin
        TESTFIELD("No.");
        IF (Type <> TrainingHeader."Document Type") OR ("No." <> TrainingHeader."No.") THEN
            TrainingHeader.GET("Document Type", "Document No.");
    end;

    procedure TestStatusOpen();
    begin
        IF StatusCheckSuspended THEN
            EXIT;
        GetTrainingHeader;
        IF Type IN [Type::Employee] THEN
            TrainingHeader.TESTFIELD(Status, TrainingHeader.Status::Open);
    end;

    procedure ValidateDesiredDates();
    begin
        IF ("Desired Starting Date" = 0D) OR ("Desired Ending Date" = 0D) THEN
            EXIT;
        IF "Desired Starting Date" > "Desired Ending Date" THEN
            ERROR(Text001);
    end;
}

