/// <summary>
/// Table Candidate Diploma (ID 52182463).
/// </summary>
table 52182463 "Candidate Diploma"
//table 39108434 "Candidate Diploma"
{
    CaptionML = ENU = 'Candidate Diploma',
                FRA = 'Diplôme candidat';
    //DrillDownPageID = 39108447;
    //LookupPageID = 39108447;

    fields
    {
        field(1; "Candidate No."; Code[20])
        {
            CaptionML = ENU = 'Candidate No.',
                        FRA = 'N° Candidat';
            NotBlank = true;
            TableRelation = Candidate;
        }
        field(2; "Diploma Code"; Code[10])
        {
            CaptionML = ENU = 'Diploma Code',
                        FRA = 'Code diplôme';
            NotBlank = true;
            TableRelation = Diploma;

            trigger OnValidate();
            begin
                IF "Diploma Code" = '' THEN
                    "Diploma Description" := ''
                ELSE BEGIN
                    Diploma.GET("Diploma Code");
                    "Diploma Description" := Diploma.Description;
                END;
            end;
        }
        field(3; "Obtention Date"; Date)
        {
            CaptionML = ENU = 'Obtention Date',
                        FRA = 'Date d''obtention';
        }
        field(4; "Diploma Domain Code"; Code[50])
        {
            CaptionML = ENU = 'Dilpoma Domain Code',
                        FRA = 'Code domaine du diplôme';
            TableRelation = "Diploma Domain";

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
        field(5; "Diploma Description"; Text[50])
        {
            CaptionML = ENU = 'Diploma Description',
                        FRA = 'Désignation de diplôme';
            Editable = false;
        }
        field(6; "Diploma Domain Description"; Text[50])
        {
            CaptionML = ENU = 'Diploma Domain Description',
                        FRA = 'Désignation domaine de diplôme';
            Editable = false;
        }
        field(7; "From Date"; Date)
        {
            CaptionML = ENU = 'From Date',
                        FRA = 'Date début';
        }
        field(8; "To Date"; Date)
        {
            CaptionML = ENU = 'To Date',
                        FRA = 'Date fin';
        }
        field(9; "Institution/Company"; Text[50])
        {
            CaptionML = ENU = 'Institution/Company',
                        FRA = 'Organisme/Société';
        }
        field(50000; Nom; Text[30])
        {
        }
        field(50001; "Prénom"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Candidate No.", "Diploma Code", "Diploma Domain Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        Candidate.GET("Candidate No.");
        Prénom := Candidate."First Name";
        Nom := Candidate."Last Name";
    end;

    var
        DiplomaDomain: Record 52182425;
        Diploma: Record 52182426;
        Candidate: Record 52182456;
}

