/// <summary>
/// Table Employee Medical Examination (ID 52182476).
/// </summary>
table 52182476 "Employee Medical Examination"
//table 39108448 "Employee Medical Examination"
{
    // version HALRHPAIE.6.2.01

    CaptionML = ENU = 'Employee Medical Examination',
                FRA = 'Visite médicale du salarié';
    DataCaptionFields = "Employee No.";
    //DrillDownPageID = 39108467;
    //LookupPageID = 39108467;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° salarié';
            NotBlank = true;
            TableRelation = Employee WHERE(Status = CONST(Active));

            trigger OnValidate();
            begin
                Employee.GET("Employee No.");
                "First Name" := Employee."First Name";
                "Last Name" := Employee."Last Name";
                "Structure code" := Employee."Structure Code";
                "Structure description" := Employee."Structure Description";
                Comptage := 1;
                "Groupe statistique" := Employee."Statistics Group Code";
                "Company Business Unit Code" := Employee."Company Business Unit Code";
            end;
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
        }
        field(3; "Examination Date"; Date)
        {
            CaptionML = ENU = 'Examination Date',
                        FRA = 'Date visite';
        }
        field(4; Doctor; Text[100])
        {
            Caption = 'Médecin';
        }
        field(5; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            OptionCaptionML = ENU = 'Recruitment,Semestrial,Annual',
                              FRA = 'Embauche,Systematique,Annuelle';
            OptionMembers = Recruitment,Semestrial,Annual;
        }
        field(6; Result; Text[30])
        {
            CaptionML = ENU = 'Result',
                        FRA = 'Résultat';
        }
        field(7; "First Name"; Text[30])
        {
            Caption = 'Prénom';
            Editable = false;
        }
        field(8; "Last Name"; Text[30])
        {
            Caption = 'Nom';
            Editable = false;
        }
        field(11; "Structure code"; Code[10])
        {
            Caption = 'Code Structure';
        }
        field(12; "Structure description"; Text[50])
        {
            Caption = 'Désignation Structure';
        }
        field(13; Comptage; Integer)
        {
        }
        field(14; "Groupe statistique"; Code[20])
        {
        }
        field(15; Exercice; Code[4])
        {
        }
        field(16; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Description = 'HALRHPAIE';
            Editable = true;
            TableRelation = "Company Business Unit";
        }
        field(95003; Status; Option)
        {
            CalcFormula = Lookup(Employee.Status WHERE("No." = FIELD("Employee No.")));
            CaptionML = ENU = 'Status',
                        FRA = 'Statut';
            Editable = false;
            FieldClass = FlowField;
            OptionCaptionML = ENU = 'Active,Inactive',
                              FRA = 'Actif,Inactif,Bloqué';
            OptionMembers = Active,Inactive,Bloqued;

            trigger OnValidate();
            begin
                //EmployeeQualification.SETRANGE("Employee No.","No.");
                //EmployeeQualification.MODIFYALL("Employee Status",Status);
                MODIFY;
            end;
        }
        field(95004; "Date de prélèvement sanguin"; Date)
        {
            Caption = 'Date de prélèvement sanguin';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Examination Date")
        {
        }
        key(Key2; "Employee No.", Type, "Examination Date")
        {
        }
        key(Key3; Type, "Examination Date")
        {
        }
        key(Key4; "Last Name", "First Name", "Examination Date")
        {
        }
        key(Key5; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        EmployeeExamination.SETCURRENTKEY("Entry No.");
        IF EmployeeExamination.FIND('+') THEN
            "Entry No." := EmployeeExamination."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        Employee: Record 5200;
        EmployeeExamination: Record 52182476;
}

