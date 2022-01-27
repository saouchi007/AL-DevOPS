/// <summary>
/// Table Employee Advance (ID 52182490).
/// </summary>
table 52182490 "Employee Advance"
//table 39108463 "Employee Advance"
{
    // version HALRHPAIE

    // HALKORB - HALRHPAIE - F.HAOUS - Mai 2010
    // 01 : Cloisonnement par unité

    CaptionML = ENU = 'Employee Advance',
                FRA = 'Avance salarié';
    DataCaptionFields = "Employee No.";
    //DrillDownPageID = 39108509;
    //LookupPageID = 39108509;

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
                IF "Entry No." = 0 THEN BEGIN
                    EmployeeAdvance.SETCURRENTKEY("Entry No.");
                    IF EmployeeAdvance.FIND('+') THEN
                        "Entry No." := EmployeeAdvance."Entry No." + 1
                    ELSE
                        "Entry No." := 1;
                END;
                IF "Employee No." = '' THEN BEGIN
                    "First Name" := '';
                    "Last Name" := '';
                    EXIT;
                END;
                Employee.GET("Employee No.");
                "First Name" := Employee."First Name";
                "Last Name" := Employee."Last Name";
                "Employee Structure Code" := Employee."Structure Code";
                "Employee Structure Description" := Employee."Structure Description";
                "Groupe Statistique" := Employee."Statistics Group Code";
                "Payroll Bank Account No." := Employee."Payroll Bank Account No.";
                "RIB Key" := Employee."RIB Key";
            end;
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
            Editable = false;
        }
        field(3; "Advance Date"; Date)
        {
            CaptionML = ENU = 'Advance Date',
                        FRA = 'Date avance';
        }
        field(5; "Cause of Advance Code"; Code[10])
        {
            CaptionML = ENU = 'Cause of Advance Code',
                        FRA = 'Code motif avance';
            TableRelation = "Cause of Advance";

            trigger OnValidate();
            begin
                IF "Cause of Advance Code" = '' THEN
                    Description := ''
                ELSE BEGIN
                    MotifofAdvance.GET("Cause of Advance Code");
                    Description := MotifofAdvance.Description;
                END;
            end;
        }
        field(6; Description; Text[30])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(7; Amount; Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
            DecimalPlaces = 0 : 5;
        }
        field(11; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),// par defaut CONST(8) 
                                                                     "Table Line No." = FIELD("Entry No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50000; "Advanced Amount"; Decimal)
        {
            Caption = 'Montant avancé';
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
        field(95002; "First Name"; Text[30])
        {
            Caption = 'Prénom';
            Editable = false;
        }
        field(95003; "Last Name"; Text[30])
        {
            Caption = 'Nom';
            Editable = false;
        }
        field(95004; "Employee Structure Code"; Text[30])
        {
            Caption = 'Code Structure';
            Description = 'HALRHPAIE';
        }
        field(95005; "Employee Structure Description"; Text[50])
        {
            Caption = 'Structure';
            Description = 'HALRHPAIE';
        }
        field(95006; "Groupe Statistique"; Code[10])
        {
        }
        field(95007; "Payroll Bank Account No."; Text[20])
        {
            CaptionML = ENU = 'Payroll Bank Account No.',
                        FRA = 'N° compte bancaire de paie';
            Description = 'HALRHPAIE';
            Editable = false;
        }
        field(95008; "RIB Key"; Text[2])
        {
            Caption = 'Clé RIB';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Employee No.")
        {
        }
        key(Key2; "Employee No.", "Advance Date")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Employee No.", "Cause of Advance Code", "Advance Date")
        {
            SumIndexFields = Amount;
        }
        key(Key4; "Cause of Advance Code", "Advance Date")
        {
            SumIndexFields = Amount;
        }
        key(Key5; "Employee Structure Code", "Groupe Statistique")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        EmployeeAdvance.SETCURRENTKEY("Entry No.");
        IF EmployeeAdvance.FIND('+') THEN
            "Entry No." := EmployeeAdvance."Entry No." + 1
        ELSE
            "Entry No." := 1;

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text04);
        IF ParamUtilisateur."Company Business Unit" = '' THEN
            ERROR(Text05);
        "Company Business Unit Code" := ParamUtilisateur."Company Business Unit";
        //+++01+++
    end;

    var
        Employee: Record 5200;
        EmployeeAdvance: Record 52182490;
        MotifofAdvance: Record 52182487;
        ParamUtilisateur: Record 91;
        Text02: Label 'Nombre doit être positif !';
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Unité non paramétrée pour l''utilisateur %1 !';
}

