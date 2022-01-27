/// <summary>
/// Table Employee Assignment (ID 52182436).
/// </summary>
table 52182436 "Employee Assignment"
//table 39108407 "Employee Assignment"
{
    // version HALRHPAIE.6.1.07

    CaptionML = ENU = 'Employee Assignment',
                FRA = 'Affectation salarié';
    //DrillDownPageID = 39108409;
    //LookupPageID = 39108409;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee WHERE(Status = CONST(Active));

            trigger OnValidate();
            begin
                IF "Employee No." = '' THEN BEGIN
                    "First Name" := '';
                    "Last Name" := '';
                    EXIT;
                END;
                Employee.GET("Employee No.");
                "First Name" := Employee."First Name";
                "Last Name" := Employee."Last Name";
            end;
        }
        field(2; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code poste';
            NotBlank = true;
            TableRelation = Post;

            trigger OnValidate();
            begin
                IF "Post Code" = '' THEN
                    "Post Description" := ''
                ELSE BEGIN
                    Post.GET("Post Code");
                    "Post Description" := Post.Description;
                END;
            end;
        }
        field(3; "Structure No."; Code[20])
        {
            CaptionML = ENU = 'Structure No.',
                        FRA = 'N° Structure';
            NotBlank = true;
            TableRelation = Structure;

            trigger OnValidate();
            begin
                IF "Structure No." = '' THEN
                    "Structure Description" := ''
                ELSE BEGIN
                    Structure.GET("Structure No.");
                    "Structure Description" := Structure.Description;
                END;
            end;
        }
        field(4; "Function Code"; Code[20])
        {
            CaptionML = ENU = 'Function Code',
                        FRA = 'Code fonction';
            TableRelation = Function;

            trigger OnValidate();
            begin
                IF "Function Code" = '' THEN
                    "Function Description" := ''
                ELSE BEGIN
                    "Function".GET("Function Code");
                    "Function Description" := "Function".Description;
                END;
            end;
        }
        field(5; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date de début';
        }
        field(6; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date de fin';
        }
        field(7; "Movement Code"; Code[20])
        {
            CaptionML = ENU = 'Movement Code',
                        FRA = 'Code mouvement';
            TableRelation = "Employee Movement";
        }
        field(8; "Post Description"; Text[50])
        {
            CaptionML = ENU = 'Post Description',
                        FRA = 'Désignation poste';
            Editable = false;
        }
        field(9; "Structure Description"; Text[50])
        {
            CaptionML = ENU = 'Structure Description',
                        FRA = 'Désignation structure';
            Editable = false;
        }
        field(10; "Function Description"; Text[80])
        {
            CaptionML = ENU = 'Function Description',
                        FRA = 'Désignation fonction';
            Editable = false;
        }
        field(50002; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
            Editable = false;
        }
        field(50003; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
            Editable = false;
        }
        field(95046; Group; Text[30])
        {
            Caption = 'Groupe';
        }
        field(95048; Category; Integer)
        {
            Caption = 'Catégorie';

            trigger OnValidate();
            begin
                IF Category < 1 THEN
                    ERROR(Text03, FIELDCAPTION(Category));
                PayrollSetup.GET;
                IF Category > PayrollSetup."No. of Levels" THEN
                    ERROR(Text04, FIELDCAPTION(Category), PayrollSetup."No. of Levels");
            end;
        }
        field(95049; Class; Text[3])
        {
            Caption = 'Classe';
        }
        field(95050; Section; Text[3])
        {
            Caption = 'Section';
        }
        field(95051; Level; Text[3])
        {
            Caption = 'Echelon';
        }
        field(95052; Indice; Text[3])
        {
            Caption = 'Indice';
        }
        field(95053; "Decision No."; Text[30])
        {
            Caption = 'N° Décision';
        }
        field(95054; "Decision Date"; Date)
        {
            Caption = 'Date décision';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Starting Date", "Function Code", "Structure No.")
        {
        }
        key(Key2; "Starting Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Post: Record 52182431;
        Structure: Record 52182434;
        "Function": Record 52182437;
        Employee: Record 5200;
        TreatmentHourlyIndexGrid: Record "Treatment Hourly Index Grid";
        Text03: Label '%1 doit être positif !';
        Text04: Label '%1 ne peut pas dépasser %2 !';
        PayrollSetup: Record Payroll_Setup;
}

