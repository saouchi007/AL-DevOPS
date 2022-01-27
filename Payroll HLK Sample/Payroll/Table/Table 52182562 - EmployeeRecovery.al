/// <summary>
/// Table Employee Recovery (ID 52182562).
/// </summary>
table 52182562 "Employee Recovery"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = FRA = 'N° salarié', ENU = 'Employee No.';
            trigger OnValidate();
            begin

                IF NOT ParamUtilisateur.GET(USERID) THEN
                    ERROR(Text04);
                IF ParamUtilisateur."Company Business Unit" = '' THEN
                    ERROR(Text05);
                IF NOT Employee.GET("Employee No.") THEN
                    ERROR(Text03, "Employee No.")
                ELSE
                    IF Employee."Company Business Unit Code" <> ParamUtilisateur."Company Business Unit" THEN
                        ERROR(Text07, "Employee No.", ParamUtilisateur."Company Business Unit");

                IF "Entry No." = 0 THEN BEGIN
                    EmployeeRecovery.SETCURRENTKEY("Entry No.");
                    IF EmployeeRecovery.FIND('+') THEN
                        "Entry No." := EmployeeRecovery."Entry No." + 1
                    ELSE
                        "Entry No." := 1;
                END;
                IF NOT ParamUtilisateur.GET(USERID) THEN
                    ERROR(Text04);
                IF ParamUtilisateur."Company Business Unit" = '' THEN
                    ERROR(Text05);
                IF NOT Employee.GET("Employee No.") THEN
                    ERROR(Text08, "Employee No.")
                ELSE
                    IF Employee."Company Business Unit Code" <> ParamUtilisateur."Company Business Unit" THEN
                        ERROR(Text07, "Employee No.", ParamUtilisateur."Company Business Unit");
                IF Employee.Status = Employee.Status::Inactive THEN
                    ERROR(Text09, "Employee No.");

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
            CaptionML = FRA = 'N° séquence', ENU = 'Entry No.';

        }
        field(3; "From Date"; Date)
        {
            CaptionML = FRA = 'Date début', ENU = 'From Date';

        }
        field(4; "To Date"; Date)
        {
            CaptionML = FRA = 'Date fin', ENU = 'To Date';

        }
        field(5; "Cause of Recovery Code"; Code[10])
        {
            CaptionML = FRA = 'Code motif récupération', ENU = 'Cause of Recovery Code';
            TableRelation = "Cause of Recovery";

        }
        field(6; "Description"; Text[30])
        {
            CaptionML = FRA = 'Désignation', ENU = 'Description';

        }
        field(7; "Quantity"; Decimal)
        {
            CaptionML = FRA = 'Quantité', ENU = 'Quantity';

        }
        field(8; "Unit of Measure Code"; Code[10])
        {
            CaptionML = FRA = 'Code unité', ENU = 'Unit of Measure Code';

        }
        field(11; "Comment"; Boolean)
        {
            CaptionML = FRA = 'Commentaires', ENU = 'Comment';

        }
        field(12; "Quantity (Base)"; Decimal)
        {
            CaptionML = FRA = 'Quantité (base)', ENU = 'Quantity (Base)';

        }
        field(13; "Qty. per Unit of Measure"; Decimal)
        {
            CaptionML = FRA = 'Quantité par unité', ENU = 'Qty. per Unit of Measure';

        }
        field(50000; "Authorised"; Boolean)
        {
            CaptionML = FRA = 'Autorisée', ENU = 'Authorised';

        }
        field(50001; "To Be Deducted"; Boolean)
        {
            CaptionML = FRA = 'A retenir', ENU = 'To Be Deducted';

        }
        field(50002; "First Name"; Text[30])
        {
            CaptionML = FRA = 'Prénom', ENU = 'First Name';

        }
        field(50003; "Last Name"; Text[30])
        {
            CaptionML = FRA = 'Nom', ENU = 'Last Name';

        }
        field(50005; "Item Code"; Text[20])
        {
            CaptionML = FRA = 'Code rubrique', ENU = 'Item Code';

        }
        field(50006; "Unit of Measure"; Option)
        {
            CaptionML = FRA = 'Unité de mesure', ENU = 'Unit of Measure';
            OptionMembers = Day,Hour;
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = FRA = 'Code unité', ENU = 'Company Business Unit Code';

        }
        field(95001; "Employee Structure Code"; Text[30])
        {
            CaptionML = FRA = '<Employee Structure Code>', ENU = 'Employee Structure Code';

        }
        field(95002; "Employee Structure Description"; Text[50])
        {
            CaptionML = FRA = '<Employee Structure Description>', ENU = 'Employee Structure Description';

        }
        field(95003; "nature"; Option)
        {
            CaptionML = FRA = '<nature>', ENU = 'nature';
            OptionMembers = Droit,consomé;
        }


    }

    keys
    {
        key(Key1; "Employee No.")
        {
            Clustered = true;
        }
    }

    var
        NbreJours: Integer;
        ParamPaie: Record 52182483;
        ParamUtilisateur: Record 91;
        Text01: Label 'La date de début doit être antérieure à la date de fin !';
        Text02: Label 'Quantité ne doit pas dépasser %1 %2 !';
        Text03: Label 'Nombre doit être positif !';
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Direction non paramétrée pour utilisateur %1 !';
        Text06: Label 'Rubrique de paie non paramétrée pour le motif %1 !';
        Text07: Label 'Salarié %1 n''appartenant pas à l''unité %2 !';
        Text08: Label 'Salarié %1 inexistant !';
        Text09: Label 'Salarié %1 inactif !';
        Employee: Record 5200;
        EmployeeRecovery: Record 52182562;

    trigger OnInsert()
    begin
        EmployeeRecovery.SETCURRENTKEY("Entry No.");
        IF EmployeeRecovery.FIND('+') THEN
            "Entry No." := EmployeeRecovery."Entry No." + 1
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

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    /// <summary>
    /// CalcBaseQty.
    /// </summary>
    /// <param name="Qty">Decimal.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalcBaseQty(Qty: Decimal): Decimal;
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));

    end;

    /// <summary>
    /// ValidateQuantity.
    /// </summary>
    procedure ValidateQuantity();
    begin
        IF ("From Date" = 0D) OR ("To Date" = 0D) OR ("Cause of Recovery Code" = '') THEN BEGIN
            Quantity := 0;
            "Quantity (Base)" := 0;
            EXIT;
        END;
        IF "From Date" > "To Date" THEN
            ERROR(Text01);
        ParamPaie.GET;
        NbreJours := "To Date" - "From Date" + 1;
        IF "Unit of Measure" = "Unit of Measure"::Day THEN BEGIN
            IF Quantity > NbreJours THEN
                ERROR(Text02, NbreJours, 'jours')
            ELSE
                IF Quantity = 0 THEN
                    Quantity := NbreJours;
        END;
        IF "Unit of Measure" = "Unit of Measure"::Hour THEN BEGIN
            IF Quantity > ParamPaie."No. of Hours By Day" * NbreJours THEN
                ERROR(Text02, ParamPaie."No. of Hours By Day" * NbreJours, 'heures')
            ELSE
                IF Quantity = 0 THEN
                    //Quantity:=ParamPaie."No. of Hours By Day"*NbreJours;
                    Quantity := NbreJours;
        END;
        IF Quantity < 0 THEN
            ERROR(Text03);
        CalculerNombreBase;
    end;

    /// <summary>
    /// CalculerNombreBase.
    /// </summary>
    procedure CalculerNombreBase();
    begin
        IF "Unit of Measure" = "Unit of Measure"::Day THEN
            "Quantity (Base)" := Quantity;
        IF "Unit of Measure" = "Unit of Measure"::Hour THEN
            "Quantity (Base)" := Quantity / ParamPaie."No. of Hours By Day";
    end;


}