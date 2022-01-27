/// <summary>
/// Table Post Required Diploma (ID 52182448).
/// </summary>
table 52182448 "Post Required Diploma"
//table 39108419 "Post Required Diploma"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Post Required Diploma',
                FRA = 'Diplôme requis du poste';
    // DrillDownPageID = 39108398;
    // LookupPageID = 39108398;

    fields
    {
        field(1; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code poste';
            NotBlank = true;
            TableRelation = Post;
        }
        field(2; "Diploma Code"; Code[20])
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
        field(3; "Diploma Domain Code"; Code[20])
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
        field(4; "Diploma Description"; Text[50])
        {
            CaptionML = ENU = 'Diploma Description',
                        FRA = 'Désignation de diplôme';
            Editable = false;
        }
        field(5; "Diploma Domain Description"; Text[50])
        {
            CaptionML = ENU = 'Diploma Domain Description',
                        FRA = 'Désignation domaine de diplôme';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Post Code", "Diploma Code", "Diploma Description")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DiplomaDomain: Record 52182425;
        Diploma: Record 52182426;
}

