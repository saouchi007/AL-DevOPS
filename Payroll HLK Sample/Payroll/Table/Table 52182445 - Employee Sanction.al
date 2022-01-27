/// <summary>
/// Table Employee Sanction (ID 52182445).
/// </summary>
table 52182445 "Employee Sanction"
//table 39108416 "Employee Sanction"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Sanction',
                FRA = 'Sanction salarié';
    DataCaptionFields = "Employee No.";
    // DrillDownPageID = 39108422;
    // LookupPageID = 39108422;

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
                IF "Employee No." = '' THEN BEGIN
                    "First Name" := '';
                    "Last Name" := '';
                    EXIT;
                END;
                Employee.GET("Employee No.");
                "First Name" := Employee."First Name";
                "Last Name" := Employee."Last Name";
                Employee.GET("Employee No.");
                Employee.GET("Employee No.");
                "Structure code" := Employee."Structure Code";
                "Structure description" := Employee."Structure Description";
                "Function code" := Employee."Function Code";
                "Function description" := Employee."Job Title";
            end;
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
        }
        field(3; "Sanction Date"; Date)
        {
            CaptionML = ENU = 'Sanction Date',
                        FRA = 'Date effet sanction';
        }
        field(4; Degree; Option)
        {
            CaptionML = ENU = 'Degree',
                        FRA = 'Degré';
            OptionCaptionML = ENU = 'Degree 1,Degree 2,Degree 3',
                              FRA = '1er degré,2nd degré,3ème degré';
            OptionMembers = "Degree 1","Degree 2","Degree 3";
        }
        field(5; "Sanction Code"; Code[20])
        {
            CaptionML = ENU = 'Sanction Code',
                        FRA = 'Code sanction';
            TableRelation = Sanction;

            trigger OnValidate();
            begin
                Sanction.GET("Sanction Code");
                "Sanction Description" := Sanction.Description;
            end;
        }
        field(6; "Sanction Description"; Text[30])
        {
            CalcFormula = Lookup(Sanction.Description WHERE(Code = FIELD("Sanction Code")));
            CaptionML = ENU = 'Sanction Description',
                        FRA = 'Nature sanction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Minutes No."; Text[30])
        {
            CaptionML = ENU = 'Minutes No.',
                        FRA = 'N° PV';
        }
        field(8; "Minutes Date"; Date)
        {
            CaptionML = ENU = 'Minutes Date',
                        FRA = 'Date PV';
        }
        field(9; "Decision No."; Text[30])
        {
            CaptionML = ENU = 'Decision No.',
                        FRA = 'N° décision';
        }
        field(10; "Decision Date"; Date)
        {
            CaptionML = ENU = 'Decision Date',
                        FRA = 'Date décision';
        }
        field(11; "Misconduct Code"; Code[10])
        {
            CaptionML = ENU = 'Misconduct Code',
                        FRA = 'Code faute/Motif';
            TableRelation = Misconduct;
        }
        field(12; "Misconduct Description"; Text[250])
        {
            CalcFormula = Lookup(Misconduct.Description WHERE(Code = FIELD("Misconduct Code")));
            CaptionML = ENU = 'Misconduct Description',
                        FRA = 'Désignation faute/Motif';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(1), //Const(7)
                                                                      "Table Line No." = FIELD("Entry No.")));
            CaptionML = ENU = 'Comment',
                         FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
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
        field(50004; Observation; Text[250])
        {
            Caption = 'Observation';
        }
        field(50005; "Structure code"; Code[10])
        {
            Caption = 'Code structure';
        }
        field(50006; "Structure description"; Text[50])
        {
            Caption = 'Désignation structure';
        }
        field(50007; "Function code"; Code[10])
        {
            Caption = 'Code fonction';
        }
        field(50008; "Function description"; Text[50])
        {
            Caption = 'Désignation fonction';
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CalcFormula = Lookup(Employee."Company Business Unit Code" WHERE("No." = FIELD("Employee No.")));
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Editable = false;
            FieldClass = FlowField;
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
        field(95007; "From Date"; Date)
        {
            Caption = 'Date de début MàP';
        }
        field(95008; "To Date"; Date)
        {
            Caption = 'Date de fin MàP';

            trigger OnValidate();
            begin
                IF ("From Date" = 0D) OR ("To Date" = 0D) THEN BEGIN
                    Number := 0;
                    EXIT;
                END;
                IF "From Date" > "To Date" THEN
                    ERROR('Date début supérieure à date fin');
                ParamPaie.GET;
                Number := "To Date" - "From Date" + 1;
                IF Number < 4 THEN Degré := 0;
                IF Number > 4 THEN Degré := 1;
                IF Number > 8 THEN Degré := 2;
            end;
        }
        field(95009; Number; Decimal)
        {
        }
        field(95010; "Degré"; Option)
        {
            OptionCaption = '1er degré, 2nd degré, 3ème degré';
            OptionMembers = "1er degré"," 2nd degré"," 3ème degré";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Employee No.", "Sanction Date")
        {
        }
        key(Key3; "Employee No.", "Sanction Code", "Sanction Date")
        {
        }
        key(Key4; "Sanction Code", "Sanction Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        EmployeeSanction.SETCURRENTKEY("Entry No.");
        IF EmployeeSanction.FIND('+') THEN
            "Entry No." := EmployeeSanction."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        Employee: Record 5200;
        EmployeeSanction: Record 52182445;
        Sanction: Record 52182444;
        ParamPaie: Record Payroll_Setup;
        NbreJours: Decimal;
}

