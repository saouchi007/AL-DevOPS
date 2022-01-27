/// <summary>
/// Table Candidate Fulfilled Function (ID 52182465).
/// </summary>
table 52182465 "Candidate Fulfilled Function"
//table 39108436 "Candidate Fulfilled Function"
{
    // version HALRHPAIE.6.2.01

    CaptionML = ENU = 'Candidate Fulfilled Function',
                FRA = 'Fonction occupée candidat';

    fields
    {
        field(1; "Candidate No."; Code[20])
        {
            CaptionML = ENU = 'Candidate No.',
                        FRA = 'N° Candidat';
            NotBlank = true;
            TableRelation = Candidate;
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
        field(3; "Function"; Code[20])
        {
            CaptionML = ENU = 'Function2',
                        FRA = 'Fonction';
            NotBlank = true;
        }
        field(4; "From Date"; Date)
        {
            CaptionML = ENU = 'From Date',
                        FRA = 'Date début';

            trigger OnValidate();
            begin
                CalcPeriod;
            end;
        }
        field(5; "To Date"; Date)
        {
            CaptionML = ENU = 'To Date',
                        FRA = 'Date fin';

            trigger OnValidate();
            begin
                CalcPeriod;
            end;
        }
        field(6; Address; Text[50])
        {
        }
        field(7; Salary; Decimal)
        {
            AutoFormatType = 2;
        }
        field(8; "Cause of Departure"; Code[20])
        {
            CaptionML = ENU = 'Cause of Departure',
                        FRA = 'Motif de départ';
            TableRelation = "Grounds for Termination";
        }
        field(9; "Employer Description"; Text[30])
        {
            CaptionML = ENU = 'Employer Description',
                        FRA = 'Désignation employeur';
            Editable = false;
        }
        field(50000; Nom; Text[50])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
            Editable = false;
        }
        field(50001; "Prénom"; Text[50])
        {
            CaptionML = ENU = 'Middle Name',
                        FRA = 'Nom de jeune fille';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Candidate No.", "Employer No.", "Function")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        CANDIDATE.GET("Candidate No.");
        Prénom := CANDIDATE."First Name";
        Nom := CANDIDATE."Last Name";
    end;

    var
        Function2: Record 52182437;
        Employer: Record 52182440;
        Text001: Label 'La date de début doit être antérieure à la date de fin';
        CANDIDATE: Record 52182456;

    /// <summary>
    /// CalcPeriod.
    /// </summary>
    procedure CalcPeriod();
    begin
        IF ("From Date" <> 0D) AND ("To Date" <> 0D) THEN
            IF "From Date" > "To Date" THEN
                ERROR(Text001);
    end;
}

