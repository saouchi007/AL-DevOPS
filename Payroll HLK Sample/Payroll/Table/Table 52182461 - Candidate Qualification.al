/// <summary>
/// Table Candidate Qualification (ID 52182461).
/// </summary>
table 52182461 "Candidate Qualification"
//table 39108432 "Candidate Qualification"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Candidate Qualification',
                FRA = 'Qualification candidat';
    DataCaptionFields = "Candidate No.";
    // DrillDownPageID = 39108483;
    // LookupPageID = 39108445;

    fields
    {
        field(1; "Candidate No."; Code[20])
        {
            CaptionML = ENU = 'Candidate No.',
                        FRA = 'N° Candidat';
            NotBlank = true;
            TableRelation = Candidate;
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.',
                        FRA = 'N° ligne';
        }
        field(3; "Qualification Code"; Code[10])
        {
            CaptionML = ENU = 'Qualification Code',
                        FRA = 'Code qualification';
            NotBlank = true;
            TableRelation = Qualification;

            trigger OnValidate();
            begin
                Qualification.GET("Qualification Code");
                Description := Qualification.Description;
            end;
        }
        field(4; "From Date"; Date)
        {
            CaptionML = ENU = 'From Date',
                        FRA = 'Date début';
        }
        field(5; "To Date"; Date)
        {
            CaptionML = ENU = 'To Date',
                        FRA = 'Date fin';
        }
        field(7; Description; Text[30])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(8; "Institution/Company"; Text[30])
        {
            CaptionML = ENU = 'Institution/Company',
                        FRA = 'Organisme/Société';
        }
        field(10; "Course Grade"; Text[30])
        {
            CaptionML = ENU = 'Course Grade',
                        FRA = 'Niveau formation';
        }
        field(12; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),//CONST(13)
                                                                    "No." = FIELD("Candidate No."),
                                                                     "Table Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Expiration Date"; Date)
        {
            CaptionML = ENU = 'Expiration Date',
                        FRA = 'Date d''expiration';
        }
        field(50000; "Nom Candidat"; Text[30])
        {
        }
        field(50001; "Prénom Candidat"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Candidate No.", "Line No.")
        {
        }
        key(Key2; "Qualification Code")
        {
        }
    }

    fieldgroups
    {
    }

   /* trigger OnDelete();
    begin
        IF Comment THEN
            ERROR(Text000);
    end;*/

    trigger OnInsert();
    begin
        Candidate.GET("Candidate No.");
        "Prénom Candidat" := Candidate."First Name";
        "Nom Candidat" := Candidate."Last Name";
    end;

    var
        Text000: TextConst ENU = 'You cannot delete employee qualification information if there are comments associated with it.', FRA = 'Vous ne pouvez pas supprimer les informations sur les qualifications des candidats s''il existe des commentaires associés.';
        Qualification: Record 5202;
        Candidate: Record 52182456;
}

