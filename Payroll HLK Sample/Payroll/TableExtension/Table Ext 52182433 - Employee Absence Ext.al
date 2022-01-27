/// <summary>
/// TableExtension Employee Absence Ext (ID 52182433) extends Record Employee Absence.
/// </summary>
tableextension 52182433 "Employee Absence Ext" extends "Employee Absence"
{

    fields
    {
        modify("Cause of Absence Code")
        {
            trigger OnAfterValidate()
            begin
                /*CauseOfAbsence.GET("Cause of Absence Code");
                Description := CauseOfAbsence.Description;
                EmployeeAbsence."Item Code":= CauseOfAbsence."Item Code";
                VALIDATE("Unit of Measure Code",CauseOfAbsence."Unit of Measure Code");
                MODIFY;*/
                MotifAbsence.GET("Cause of Absence Code");
                IF (MotifAbsence."To Be Deducted") AND (MotifAbsence."Item Code" = '') THEN
                    ERROR(Text06, "Cause of Absence Code");
                Description := MotifAbsence.Description;
                Authorised := MotifAbsence.Authorised;
                "To Be Deducted" := MotifAbsence."To Be Deducted";
                "Item Code" := MotifAbsence."Item Code";
                "Unit of Measure Code" := CauseOfAbsence."Unit of Measure Code";
                ValidateNumber;

            end;
        }
        field(50000; Authorised; Boolean)
        {
            CaptionML = ENU = 'Authorised',
                        FRA = 'Autorisée';
        }
        field(50001; "To Be Deducted"; Boolean)
        {
            CaptionML = ENU = 'To Be Deducted',
                        FRA = 'A retenir';

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
        field(50004; "Deduction Payroll Code"; Code[20])
        {
            Caption = 'Code paie retenue';
            TableRelation = Payroll;
        }
        field(50005; "Item Code"; Text[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            Description = 'HALRHPAIE';
            Editable = false;
            NotBlank = true;
            TableRelation = "Payroll Item" WHERE(Nature = CONST(Calculated));
        }
        field(50006; "Unit of Measure"; Option)
        {
            CaptionML = ENU = 'Unit of Measure',
                        FRA = 'Unité de mesure';
            Editable = true;
            InitValue = Hour;
            OptionCaptionML = ENU = 'Day,Hour',
                              FRA = 'Jour,Heure';
            OptionMembers = Day,Hour;

            trigger OnValidate();
            begin
                IF "Quantity (Base)" <> xRec."Quantity (Base)" THEN
                    ValidateNumber;
            end;
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            Description = 'HALRHPAIE';
            Editable = true;
            TableRelation = "Company Business Unit";
        }
        field(95001; "Employee Structure Code"; Text[30])
        {
            Description = 'HALRHPAIE';
        }
        field(95002; "Employee Structure Description"; Text[50])
        {
            Description = 'HALRHPAIE';
        }
        field(95003; Status; Option)
        {
            //CalcFormula = Lookup("Employee".Status WHERE("No." = FIELD("Employee No."))); //Comment By Abdelhak 
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
                //EmployeeQualification.MODIFYALL(Emp,Status);
                MODIFY;
            end;
        }
    }

    var
        CauseOfAbsence: Record 5206;
        Employee: Record 5200;
        EmployeeAbsence: Record 5207;
        HumanResUnitOfMeasure: Record 5220;
        Text01: Label 'La date de début doit être antérieure à la date de fin !';
        Text02: Label 'Le nombre ne doit pas dépasser %1 %2 !';
        Text03: Label 'Le nombre doit être positif !';
        Text04: Label 'Utilisateur %1 non configuré !';
        Text05: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        Text06: Label 'Rubrique de paie non paramétrée pour le motif %1 !';
        Text07: Label 'Salarié %1 n''appartenant pas à l''unité %2 !';
        Text08: Label 'Salarié %1 inexistant !';
        Text09: Label 'Salarié %1 inactif !';
        ParamPaie: Record 52182483;
        NbreJours: Integer;
        MotifAbsence: Record 5206;
        ParamUtilisateur: Record 91;

    local procedure CalcBaseQty(Qty: Decimal): Decimal;
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    procedure ValidateNumber();
    begin

        IF ("From Date" = 0D) OR ("To Date" = 0D) OR ("Cause of Absence Code" = '') THEN BEGIN
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
                    Quantity := ParamPaie."No. of Hours By Day" * NbreJours;
        END;
        IF Quantity < 0 THEN
            ERROR(Text03);
        CalculerNombreBase;
    end;

    procedure CalculerNombreBase();
    begin
        IF "Unit of Measure" = "Unit of Measure"::Day THEN
            "Quantity (Base)" := Quantity;
        IF "Unit of Measure" = "Unit of Measure"::Hour THEN
            "Quantity (Base)" := Quantity / ParamPaie."No. of Hours By Day";
    end;

}