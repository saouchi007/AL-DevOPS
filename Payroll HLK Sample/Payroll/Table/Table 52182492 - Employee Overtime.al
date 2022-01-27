/// <summary>
/// Table Employee Overtime (ID 52182492).
/// </summary>
table 52182492 "Employee Overtime"
//table 39108465 "Employee Overtime"
{
    // version HALRHPAIE.6.1.01

    // HALKORB - HALRHPAIE - F.HAOUS - Avril 2010
    // 01 : Cloisonnement par unité

    CaptionML = ENU = 'Employee Overtime',
                FRA = 'Heure supp. salarié';
    DataCaptionFields = "Employee No.";
    //DrillDownPageID = 39108512;
    //LookupPageID = 39108512;

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
                    EmployeeOvertime.SETCURRENTKEY("Entry No.");
                    IF EmployeeOvertime.FIND('+') THEN
                        "Entry No." := EmployeeOvertime."Entry No." + 1
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
            end;
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
            NotBlank = true;
        }
        field(3; "Overtime Date"; Date)
        {
            CaptionML = ENU = 'Overtime Date',
                        FRA = 'Date heure supp.';
        }
        field(4; Category; Code[10])
        {
            CaptionML = ENU = 'Category',
                        FRA = 'Catégorie';
            TableRelation = "Overtime Category";
        }
        field(5; "Cause of Overtime Code"; Code[10])
        {
            CaptionML = ENU = 'Cause of Overtime Code',
                        FRA = 'Code motif heure supp.';
            TableRelation = "Cause of Overtime";

            trigger OnValidate();
            begin
                CauseOfOvertime.GET("Cause of Overtime Code");
                Description := CauseOfOvertime.Description;
                VALIDATE("Unit of Measure Code", CauseOfOvertime."Unit of Measure Code");
            end;
        }
        field(6; Description; Text[30])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(7; Quantity; Decimal)
        {
            CaptionML = ENU = 'Quantity',
                        FRA = 'Quantité';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                IF Quantity < 0 THEN
                    ERROR(Text02);
                "Quantity (Base)" := CalcBaseQty(Quantity);
            end;
        }
        field(8; "Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Unit of Measure Code',
                        FRA = 'Code unité';
            TableRelation = "Payroll Unit of Measure";

            trigger OnValidate();
            begin
                UniteMesurePaie.GET("Unit of Measure Code");
                "Qty. per Unit of Measure" := UniteMesurePaie."Qty. per Unit of Measure";
                VALIDATE(Quantity);
            end;
        }
        field(9; "CATEGORY DESCRIPTION"; Text[30])
        {
        }
        field(11; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),//CONST(9)
                                                                     "Table Line No." = FIELD("Entry No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Quantity (Base)"; Decimal)
        {
            CaptionML = ENU = 'Quantity (Base)',
                        FRA = 'Quantité (base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                TESTFIELD("Qty. per Unit of Measure", 1);
                VALIDATE(Quantity, "Quantity (Base)");
            end;
        }
        field(13; "Qty. per Unit of Measure"; Decimal)
        {
            CaptionML = ENU = 'Qty. per Unit of Measure',
                        FRA = 'Quantité par unité';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(14; "Food Gain"; Boolean)
        {
            CaptionML = ENU = 'Food Gain',
                        FRA = 'Panier';
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
        field(95001; Date; Date)
        {
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
        key(Key1; "Employee No.", "Entry No.")
        {
        }
        key(Key2; "Entry No.")
        {
        }
        key(Key3; "Employee No.", "Overtime Date")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key4; "Employee No.", "Cause of Overtime Code", "Overtime Date", Category)
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key5; "Cause of Overtime Code", "Overtime Date")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        EmployeeOvertime.SETCURRENTKEY("Entry No.");
        IF EmployeeOvertime.FIND('+') THEN
            "Entry No." := EmployeeOvertime."Entry No." + 1
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
        CauseOfOvertime: Record 52182493;
        Employee: Record 5200;
        EmployeeOvertime: Record 52182492;
        UniteMesurePaie: Record 52182494;
        Text02: Label 'Nombre doit être positif !';
        ParamUtilisateur: Record 91;
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Unité non paramétrée pour l''utilisateur %1 !';

    local procedure CalcBaseQty(Qty: Decimal): Decimal;
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;
}

