/// <summary>
/// Table Employee Diploma (ID 52182427).
/// </summary>
table 52182427 "Employee Diploma"
//table 39108398 "Employee Diploma"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Diploma',
                FRA = 'Diplôme salarié';
    //DrillDownPageID = 39108398;
    //LookupPageID = 39108398;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;
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
    }

    keys
    {
        key(Key1; "Employee No.", "Diploma Code", "Diploma Domain Code")
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

