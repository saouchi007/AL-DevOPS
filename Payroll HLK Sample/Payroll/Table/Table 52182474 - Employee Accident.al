/// <summary>
/// Table Employee Accident (ID 52182474).
/// </summary>
table 52182474 "Employee Accident"
//table 39108446 "Employee Accident"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Employee Accident',
                FRA = 'Accident salarié';
    DataCaptionFields = "Employee No.";
    //DrillDownPageID = 39108464;
    //LookupPageID = 39108464;

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
                IF NOT ParamUtilisateur.GET(USERID) THEN
                    ERROR(Text04);
                //IF ParamUtilisateur."Company Business Unit"=''THEN
                //ERROR(Text05);
                IF NOT Employee.GET("Employee No.") THEN
                    ERROR(Text07, "Employee No.")
                ELSE
                    //IF Salarie."Company Business Unit Code"<>ParamUtilisateur."Company Business Unit"THEN
                    //ERROR(Text06,"Employee No.",ParamUtilisateur."Company Business Unit");
                    //IF Employee.Status=Employee.Status::Inactive THEN
                    //ERROR(Text08,"Employee No.");
                    IF "Employee No." = '' THEN BEGIN
                        "First Name" := '';
                        "Last Name" := '';
                        EXIT;
                    END;
                "First Name" := Employee."First Name";
                "Last Name" := Employee."Last Name";
                "Company Business Unit Code" := Employee."Company Business Unit Code";
                "Structure code" := Employee."Structure Code";
                "Structure description" := Employee."Structure Description";
                A1 := DATE2DMY(Employee."Birth Date", 3);
                A2 := DATE2DMY(TODAY, 3);
                Age := A2 - A1;
                "Catégorie Socio-Pro" := Employee."Socio-Professional Category";
                "Date recrutement" := Employee."Employment Date";
            end;
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
        }
        field(3; "Accident Date"; Date)
        {
            CaptionML = ENU = 'Advance Date',
                        FRA = 'Date accident';
        }
        field(4; "To Date"; Date)
        {
            Caption = 'Date reprise';
        }
        field(5; "Cause of Accident Code"; Code[10])
        {
            CaptionML = ENU = 'Cause of Accident Code',
                        FRA = 'Code motif accident';
            TableRelation = "Cause of Accident";

            trigger OnValidate();
            begin
                MotifofAccident.GET("Cause of Accident Code");
                Description := MotifofAccident.Description;
            end;
        }
        field(6; Description; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Nature lésions';
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
        field(11; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),// CONST(18)
                                                                     "Table Line No." = FIELD("Entry No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantité';
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Description = 'HALRHPAIE';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
        field(95001; "Date recrutement"; Date)
        {
            Caption = 'Date recrutement';
            Description = 'HALRHPAIE';
        }
        field(95002; "Structure code"; Code[10])
        {
            Caption = 'Code structure';
        }
        field(95003; "Structure description"; Text[50])
        {
            Caption = 'Designation structure';
        }
        field(95004; "Catégorie Socio-Pro"; Text[30])
        {
            Caption = 'Catégorie Socio-Pro';
        }
        field(95005; "Heure accident"; Time)
        {
            Caption = 'Heure accident';
        }
        field(95006; Age; Integer)
        {
            Caption = 'Age';
        }
        field(95007; "Jrs semaine"; Integer)
        {
            Caption = 'Jrs semaine';
        }
        field(95008; "Lieu accident"; Text[50])
        {
            Caption = 'Lieu accident';
        }
        field(95010; "Siège lésions"; Text[50])
        {
            Caption = 'Siège lésions';
        }
        field(95011; "Elément matériel"; Text[50])
        {
            Caption = 'Elément matériel';
        }
        field(95012; Rechute; Text[50])
        {
        }
        field(95013; Status; Option)
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
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Employee No.", "Accident Date")
        {
        }
        key(Key3; "Employee No.", "Cause of Accident Code", "Accident Date")
        {
        }
        key(Key4; "Cause of Accident Code", "Accident Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        EmployeeAccident.SETCURRENTKEY("Entry No.");
        IF EmployeeAccident.FIND('+') THEN
            "Entry No." := EmployeeAccident."Entry No." + 1
        ELSE
            "Entry No." := 1;
        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text04);
        //IF ParamUtilisateur."Company Business Unit"=''THEN
        //ERROR(Text05);
        Employee.GET("Employee No.");
        "Company Business Unit Code" := Employee."Company Business Unit Code";
        //"Company Business Unit Code":=ParamUtilisateur."Company Business Unit";
        //+++01+++
    end;

    var
        Employee: Record 5200;
        EmployeeAccident: Record 52182474;
        MotifofAccident: Record 52182475;
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        Text06: Label 'Salarié %1 n''appartenant pas à l''unité %2 !';
        Text07: Label 'Salarié %1 inexistant !';
        Text08: Label 'Salarié %1 inactif !';
        ParamUtilisateur: Record 91;
        AgeEmployee: Integer;
        A1: Integer;
        A2: Integer;
}

