/// <summary>
/// Table Employee Fulfilled Function (ID 52182439).
/// </summary>
table 52182439 "Employee Fulfilled Function"
//table 39108410 "Employee Fulfilled Function"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Fulfilled Function',
                FRA = 'Fonction occupée salarié';

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
        field(2; "Employer No."; Code[20])
        {
            CaptionML = ENU = 'Employer No.',
                        FRA = 'N° Employeur';
            NotBlank = true;
            TableRelation = Employer;

            trigger OnValidate();
            begin
                IF "Employer No." = '' THEN
                    "Employer Description" := ''
                ELSE BEGIN
                    Employer.GET("Employer No.");
                    "Employer Description" := Employer.Description;
                END;
            end;
        }
        field(3; "Function Code"; Code[20])
        {
            CaptionML = ENU = 'Function Code',
                        FRA = 'Code fonction';
            NotBlank = true;
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
        field(4; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date de début';

            trigger OnValidate();
            begin
                CalcPeriod;
            end;
        }
        field(5; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date de fin';

            trigger OnValidate();
            begin
                CalcPeriod;
            end;
        }
        field(6; "Function Description"; Text[80])
        {
            CaptionML = ENU = 'Function Description',
                        FRA = 'Désignation fonction';
            Editable = false;
        }
        field(7; "Employer Description"; Text[30])
        {
            CaptionML = ENU = 'Employer Description',
                        FRA = 'Désignation employeur';
            Editable = false;
        }
        field(10; Period; Integer)
        {
            CaptionML = ENU = 'Period',
                        FRA = 'Durée';
        }
        field(11; "Unit of Measure"; Option)
        {
            CaptionML = ENU = 'Unit of Measure',
                        FRA = 'Unité de mesure';
            OptionCaptionML = ENU = 'Day,Month,Year',
                              FRA = 'Jour,Mois,An';
            OptionMembers = Hour,Day,Month,Year;
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
        field(50004; "Post code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code poste';
            NotBlank = true;
            TableRelation = Post;

            trigger OnValidate();
            begin
                IF Post."No." = '' THEN
                    Post.Description := ''
                ELSE BEGIN
                    Post.GET(Post."No.");
                    "Post Description" := Post.Description;
                END;
            end;
        }
        field(50005; "Post Description"; Text[50])
        {
            CaptionML = ENU = 'Post Description',
                        FRA = 'Désignation poste';
            Editable = false;
        }
        field(50006; Salary; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50007; "Cause of Departure"; Code[20])
        {
            CaptionML = ENU = 'Cause of Departure',
                        FRA = 'Motif de départ';
            TableRelation = "Grounds for Termination";
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Employer No.", "Function Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        "Function": Record 52182437;
        Employer: Record 52182440;
        Text001: Label 'La date de début doit être antérieure à la date de fin';
        Employee: Record 5200;
        Post: Record 52182431;

    /// <summary>
    /// CalcPeriod.
    /// </summary>
    procedure CalcPeriod();
    begin
        IF ("Starting Date" <> 0D) AND ("Ending Date" <> 0D) THEN
            IF "Starting Date" > "Ending Date" THEN
                ERROR(Text001);
    end;
}

