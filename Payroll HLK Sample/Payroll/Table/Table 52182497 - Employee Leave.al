/// <summary>
/// Table Employee Leave (ID 52182497).
/// </summary>
table 52182497 "Employee Leave"
//table 39108470 "Employee Leave"
{
    // version HALRHPAIE.6.1.05

    // HALKORB - cloisonnement par unité - F.HAOUS - Mai 2011
    // 01 : Cloisonnement par unité

    CaptionML = ENU = 'Employee Leave',
                FRA = 'Congé salarié';
    DataCaptionFields = "Employee No.";
    //DrillDownPageID = 39108519;
    //LookupPageID = 39108521;

    fields
    {
        field(1; "Leave Period"; Code[10])
        {
            CaptionML = ENU = 'Leave Period',
                        FRA = 'Période de congé';
            NotBlank = true;
            TableRelation = "Leave Right"."Leave Period Code" WHERE("Employee No." = FIELD("Employee No."));

            trigger OnValidate();
            begin
                ValidateQuantity;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° salarié';
            TableRelation = Employee WHERE(Status = CONST(Active));

            trigger OnValidate();
            begin
                ValidateQuantity;
                IF NOT ParamUtilisateur.GET(USERID) THEN
                    ERROR(Text04);
                IF ParamUtilisateur."Company Business Unit" = '' THEN
                    ERROR(Text05);
                IF NOT Salarie.GET("Employee No.") THEN
                    ERROR(Text07, "Employee No.")
                ELSE
                    IF Salarie."Company Business Unit Code" <> ParamUtilisateur."Company Business Unit" THEN
                        ERROR(Text06, "Employee No.", ParamUtilisateur."Company Business Unit");
                IF Salarie.Status = Salarie.Status::Inactive THEN
                    ERROR(Text08, "Employee No.");
                IF "Employee No." = '' THEN BEGIN
                    "First Name" := '';
                    "Last Name" := '';
                    EXIT;
                END;
                "First Name" := Salarie."First Name";
                "Last Name" := Salarie."Last Name";
                "Employee Structure Code" := Salarie."Structure Code";
                "Employee Structure Description" := Salarie."Structure Description";
            end;
        }
        field(3; "Leave Right"; Decimal)
        {
            CaptionML = ENU = 'Leave Right',
                        FRA = 'Droit au congé';
            Editable = false;
            TableRelation = "Leave Right"."Leave Period Code" WHERE("Employee No." = FIELD("Employee No."));
        }
        field(4; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Starting Date',
                        FRA = 'Date début';

            trigger OnValidate();
            begin
                ValidatePeriod;
            end;
        }
        field(5; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date fin';

            trigger OnValidate();
            begin
                ValidatePeriod;
                IF "Recovery Date" = 0D THEN
                    "Recovery Date" := "Ending Date";
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
                TESTFIELD("Leave Period");
                TESTFIELD("Employee No.");
                ValidatePeriod;
                ParametresPaie.GET;
                IF Quantity > "Leave Right" THEN
                    IF ParametresPaie."Limit Leaves to Rights" THEN
                        ERROR(Text01, "Leave Right");
                IF Quantity < 0 THEN
                    ERROR(Text02);
                "Quantity (Base)" := CalcBaseQty(Quantity);
            end;
        }
        field(8; "Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Unit of Measure Code',
                        FRA = 'Code unité';
            Editable = false;
            TableRelation = "Human Resource Unit of Measure";

            trigger OnValidate();
            begin
                HumanResUnitOfMeasure.GET("Unit of Measure Code");
                "Qty. per Unit of Measure" := HumanResUnitOfMeasure."Qty. per Unit of Measure";
                VALIDATE(Quantity);
            end;
        }
        field(9; "Quantity (Base)"; Decimal)
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
        field(10; "Qty. per Unit of Measure"; Decimal)
        {
            CaptionML = ENU = 'Qty. per Unit of Measure',
                        FRA = 'Quantité par unité';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(11; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
            Editable = false;
        }
        field(12; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
            Editable = false;
        }
        field(13; "No. of Consumed Days"; Decimal)
        {
            CalcFormula = Sum("Employee Leave"."Quantity (Base)" WHERE("Leave Period" = FIELD("Leave Period"),
                                                                        "Employee No." = FIELD("Employee No.")));
            Caption = 'Nbre de jours consommés';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
            Editable = false;
        }
        field(15; "Recovery Date"; Date)
        {
            CaptionML = ENU = 'Recovery Date',
                        FRA = 'Date de reprise';
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Description = 'HALRHPAIE';
            Editable = false;
            TableRelation = "Company Business Unit";
        }
        field(95001; "Employee Structure Code"; Text[30])
        {
            Caption = 'Code Structure';
            Description = 'HALRHPAIE';
        }
        field(95002; "Employee Structure Description"; Text[50])
        {
            Caption = 'Structure';
            Description = 'HALRHPAIE';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key2; "Employee No.", "Leave Period")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text05, USERID);
        IF ParamUtilisateur."Company Business Unit" = '' THEN
            ERROR(Text04, USERID);
        "Company Business Unit Code" := ParamUtilisateur."Company Business Unit";
        //+++01+++
        HumanResSetup.GET;
        "Unit of Measure Code" := HumanResSetup."Base Unit of Measure";
        EmployeeLeave.SETCURRENTKEY("Entry No.");
        IF EmployeeLeave.FIND('+') THEN
            "Entry No." := EmployeeLeave."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        Salarie: Record 5200;
        EmployeeLeave: Record 52182497;
        HumanResUnitOfMeasure: Record 5220;
        LeaveRight: Record 52182496;
        Text01: Label 'Quantité ne doit pas dépasser %1';
        Text02: Label 'Nombre doit être positif !';
        Text03: Label 'La date de début doit être antérieure à la date de fin !';
        HumanResSetup: Record 5218;
        ParametresPaie: Record 52182483;
        ParamUtilisateur: Record 91;
        Direction: Record 52182429;
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        Text06: Label 'Salarié %1 n''appartenant pas à l''unité %2 !';
        Text07: Label 'Salarié %1 inexistant !';
        Text08: Label 'Salarié %1 inactif !';

    local procedure CalcBaseQty(Qty: Decimal): Decimal;
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    /// <summary>
    /// ValidateQuantity.
    /// </summary>
    procedure ValidateQuantity();
    begin
        IF ("Employee No." = '') OR ("Leave Period" = '') THEN
            EXIT;
        IF LeaveRight.GET("Leave Period", "Employee No.") THEN
            "Leave Right" := LeaveRight."No. of Days"
        ELSE
            "Leave Right" := 0;
        ParametresPaie.GET;
        IF Quantity > "Leave Right" THEN
            IF ParametresPaie."Limit Leaves to Rights" THEN
                Quantity := 0;
    end;

    /// <summary>
    /// ValidatePeriod.
    /// </summary>
    procedure ValidatePeriod();
    begin
        IF "Starting Date" = 0D THEN BEGIN
            IF "Ending Date" = 0D THEN BEGIN
                Quantity := 0;
                "Quantity (Base)" := CalcBaseQty(Quantity);
                EXIT;
            END
            ELSE
                IF Quantity = 0 THEN BEGIN
                    "Ending Date" := 0D;
                    EXIT;
                END
                ELSE BEGIN
                    "Starting Date" := "Ending Date" - Quantity + 1;
                    EXIT;
                END;
        END
        ELSE BEGIN
            IF "Ending Date" = 0D THEN BEGIN
                IF Quantity = 0 THEN
                    EXIT
                ELSE BEGIN
                    "Ending Date" := "Starting Date" + Quantity - 1;
                    EXIT;
                END;
            END
            ELSE BEGIN
                IF "Starting Date" > "Ending Date" THEN
                    ERROR(Text03);
                Quantity := "Ending Date" - "Starting Date" + 1;
                ValidateQuantity;
                "Quantity (Base)" := CalcBaseQty(Quantity);
                EXIT;
            END;
        END;
    end;
}

