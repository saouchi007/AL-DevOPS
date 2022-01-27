/// <summary>
/// Table Employee Unavailability (ID 51424).
/// </summary>
table 52182453 "Employee Unavailability"
//table 39108424 "Employee Unavailability"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Unavailabilities',
                FRA = 'Indisponibilités salarié';
    DataCaptionFields = "Employee No.";
    // DrillDownPageID = 39108424;
    //LookupPageID = 39108424;

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
            end;
        }
        field(2; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.',
                        FRA = 'N° séquence';
        }
        field(3; "Cause of Inactivity Code"; Code[20])
        {
            CaptionML = ENU = 'Cause of Inactivity Code',
                        FRA = 'Code motif indisponibilité';
            TableRelation = "Cause of Inactivity";

            trigger OnValidate();
            begin
                IF "Cause of Inactivity Code" = '' THEN
                    Description := ''
                ELSE BEGIN
                    CauseOfUnavailability.GET("Cause of Inactivity Code");
                    Description := CauseOfUnavailability.Description;
                END;
                VALIDATE("Unit of Measure Code", CauseOfUnavailability."Unit of Measure Code");
            end;
        }
        field(4; Quantity; Decimal)
        {
            CaptionML = ENU = 'Quantity',
                        FRA = 'Quantité';

            trigger OnValidate();
            begin
                ValidatePeriod;
                IF Quantity < 0 THEN
                    ERROR(Text01);
                "Quantity (Base)" := CalcBaseQty(Quantity);
            end;
        }
        field(6; Description; Text[30])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(7; "Starting Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date début';

            trigger OnValidate();
            begin
                ValidatePeriod;
            end;
        }
        field(8; "Ending Date"; Date)
        {
            CaptionML = ENU = 'Ending Date',
                        FRA = 'Date fin';

            trigger OnValidate();
            begin
                ValidatePeriod;
            end;
        }
        field(9; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),//CONST(10)
                                                                     "Table Line No." = FIELD("Entry No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Quantity (Base)"; Decimal)
        {
            CaptionML = ENU = 'Quantity (Base)',
                        FRA = 'Quantité (base)';

            trigger OnValidate();
            begin
                TESTFIELD("Qty. per Unit of Measure", 1);
                VALIDATE(Quantity, "Quantity (Base)");
            end;
        }
        field(11; "Qty. per Unit of Measure"; Decimal)
        {
            CaptionML = ENU = 'Qty. per Unit of Measure',
                        FRA = 'Quantité par unité';
        }
        field(12; "Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Unit of Measure Code',
                        FRA = 'Code unité';
            TableRelation = "Human Resource Unit of Measure";

            trigger OnValidate();
            begin
                HumanResUnitOfMeasure.GET("Unit of Measure Code");
                "Qty. per Unit of Measure" := HumanResUnitOfMeasure."Qty. per Unit of Measure";
                VALIDATE(Quantity);
            end;
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
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Employee No.", "Starting Date")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key3; "Employee No.", "Cause of Inactivity Code", "Starting Date")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key4; "Cause of Inactivity Code", "Starting Date")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key5; "Starting Date", "Ending Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        EmployeeUnavailability.SETCURRENTKEY("Entry No.");
        IF EmployeeUnavailability.FIND('+') THEN
            "Entry No." := EmployeeUnavailability."Entry No." + 1
        ELSE
            "Entry No." := 1;
        HumanResSetup.GET;
        "Unit of Measure Code" := HumanResSetup."Base Unit of Measure";
    end;

    var
        Employee: Record 5200;
        EmployeeUnavailability: Record 52182453;
        CauseOfUnavailability: Record 5210;
        HumanResUnitOfMeasure: Record 5220;
        Text01: Label 'Nombre doit être positif !';
        HumanResSetup: Record 5218;
        Text03: Label 'La date de début doit être antérieure à la date de fin !';

    procedure CalcBaseQty(Qty: Decimal): Decimal;
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

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
                "Quantity (Base)" := CalcBaseQty(Quantity);
                EXIT;
            END;
        END;
    end;
}

