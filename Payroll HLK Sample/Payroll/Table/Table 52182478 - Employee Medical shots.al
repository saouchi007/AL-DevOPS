/// <summary>
/// Table Employee Medical shots (ID 52182478).
/// </summary>
table 52182478 "Employee Medical shots"
//table 39108450 "Employee Medical shots"
{
    // version HALRHPAIE.6.2.01

    CaptionML = ENU = 'Employee Medical Examination',
                FRA = 'Saisie des vaccins du salarié';
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
                "Groupe statistique" := Employee."Statistics Group Code";
                "Company Business Unit Code" := Employee."Company Business Unit Code";
            end;
        }
        field(3; "First Name"; Text[30])
        {
            Caption = 'Prénom';
            Editable = false;
        }
        field(4; Comptage; Text[100])
        {
            Caption = 'Comptage';
        }
        field(5; "Examination Date"; Date)
        {
            CaptionML = ENU = 'Examination Date',
                        FRA = 'Date vaccin';
        }
        field(6; "01 DT"; Text[30])
        {
            Caption = '01 DT';
        }
        field(8; "Last Name"; Text[30])
        {
            Caption = 'Nom';
            Editable = false;
        }
        field(9; "02 DT"; Text[30])
        {
            Caption = '02 DT';
        }
        field(10; "1er R DT"; Text[30])
        {
            Caption = '1er R DT';
        }
        field(11; "Structure code"; Code[10])
        {
            Caption = 'Code Structure';
        }
        field(12; "Structure description"; Text[50])
        {
            Caption = 'Désignation Structure';
        }
        field(13; "Hépatite C"; Date)
        {
        }
        field(14; "Rappel Hépatite C"; Date)
        {
        }
        field(15; "Groupe statistique"; Code[20])
        {
        }
        field(50000; "deuxième Rappel  Hépatite C"; Date)
        {
            Description = 'abdenacer';
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Editable = false;
            FieldClass = Normal;
            TableRelation = "Company Business Unit";
        }
        field(95006; Status; Option)
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
    }

    keys
    {
        key(Key1; "Employee No.", "01 DT", "02 DT")
        {
        }
        key(Key2; "Last Name", "First Name", "Examination Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record 5200;
        EmployeeExamination: Record 52182478;
}

