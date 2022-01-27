/// <summary>
/// Table Employee Payroll Item (ID 51455).
/// </summary>
table 52182482 "Employee Payroll Item"
//table 39108455 "Employee Payroll Item"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Employee Payroll Item',
                FRA = 'Rubrique salarié';
    //DrillDownPageID = 39108493;
    //LookupPageID = 39108493;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            CaptionML = ENU = 'Employee No.',
                        FRA = 'N° Salarié';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "Item Code"; Text[20])
        {
            CaptionML = ENU = 'Item Code',
                        FRA = 'Code rubrique';
            NotBlank = true;
            TableRelation = "Payroll Item";

            trigger OnValidate();
            begin
                IF "Item Code" = '' THEN
                    "Item Description" := ''
                ELSE
                    //*************
                    /*
                     IF"Item Code"='222'THEN
                      ERROR(Text07)
                    ELSE
                    */
                    //**************
                    BEGIN
                    ParamPaie.GET;
                    Rubrique.GET("Item Code");
                    IF (Rubrique.Nature = Rubrique.Nature::Calculated) AND ("Item Code" <> ParamPaie."Base Salary") THEN
                        ERROR(Text01);
                    IF (Rubrique.Blocked = Rubrique.Blocked::Use) OR (Rubrique.Blocked = Rubrique.Blocked::All) THEN
                        ERROR(Text05, "Item Code");
                    "Item Description" := Rubrique.Description;
                    Type := Rubrique."Item Type";
                    "Submitted To Leave" := Rubrique."Submitted To Leave";
                    //Element 25 Début
                    "TIT Out of Grid" := Rubrique."TIT Out of Grid";
                    //Element 25 Fin
                    Taxable := Rubrique.Taxable;
                    Regularization := Rubrique.Regularization;
                    Salarie.GET("Employee No.");
                    CalcItemAmount;
                END;

            end;
        }
        field(3; "Item Description"; Text[50])
        {
            CaptionML = ENU = 'Item Description',
                        FRA = 'Désignation rubrique';
            Editable = false;
        }
        field(4; Basis; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Basis',
                        FRA = 'Base';

            trigger OnValidate();
            begin
                IF ("Item Code" = '426')
                AND (Basis > 8000)
                AND (NOT Salarie."Do not Use Treatment Grid") THEN
                    ERROR(Text02, FIELDCAPTION(Basis), 8000);

                IF Rubrique."Item Type" = Rubrique."Item Type"::"Libre saisie" THEN
                    IF Number = 0 THEN
                        IF Rate = 0 THEN
                            Amount := Basis;
                Rubrique.GET("Item Code");
                IF Rubrique.Nature = Rubrique.Nature::Deduction THEN
                    IF Basis > 0 THEN
                        Basis := -Basis;
                IF Rubrique.Nature = Rubrique.Nature::Gain THEN
                    IF Basis < 0 THEN
                        Basis := -Basis;

                TraiterRegulIRG;
            end;
        }
        field(5; Rate; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Rate',
                        FRA = 'Taux';
        }
        field(6; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount',
                        FRA = 'Montant';
            Editable = true;
        }
        field(7; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            Editable = false;
            OptionCaption = 'Libre saisie,Formule,Pourcentage,Au prorata,Au prorata autorisé';
            OptionMembers = "Libre saisie",Formule,Pourcentage,"Au prorata","Au prorata autorisé";
        }
        field(8; Number; Decimal)
        {
            BlankNumbers = BlankZero;
            CaptionML = ENU = 'Number',
                        FRA = 'Nombre';

            trigger OnValidate();
            begin
                ParamPaie.GET;
                Salarie.GET("Employee No.");
                /*IF "Item Code"='222'THEN
                  BEGIN
                    Salarie.CALCFIELDS("Total Leave Indem. No.");
                    IF Number>Salarie."Total Leave Indem. No."THEN
                      ERROR(Text02,FIELDCAPTION(Number),Salarie."Total Leave Indem. No.");
                  END;
                IF("Item Code"<>'222')
                AND(Number>ParamPaie."No. of Worked Days")
                AND(NOT Salarie."Do not Use Treatment Grid")THEN
                  ERROR(Text02,FIELDCAPTION(Number),ParamPaie."No. of Worked Days");
                */
                IF ("Item Code" = '510')
                AND (Number > 30)
                AND (NOT Salarie."Do not Use Treatment Grid") THEN
                    ERROR(Text02, FIELDCAPTION(Number), 30);

                IF Number < 0 THEN
                    ERROR(Text03, FIELDCAPTION(Number));
                CalcItemAmount;
                TraiterRegulIRG;
                //*******************
                //MODIFY;
                //*******************

            end;
        }
        field(9; "Submitted To Leave"; Boolean)
        {
            Caption = 'Soumis à congé';
            Editable = false;
        }
        field(10; "TIT Out of Grid"; Boolean)
        {
            Caption = 'IRG hors barème';
        }
        field(11; Taxable; Boolean)
        {
            CaptionML = ENU = 'Taxable',
                        FRA = 'Imposable';
            Editable = true;
        }
        field(12; Regularization; Boolean)
        {
            CaptionML = ENU = 'Taxable',
                        FRA = 'Régularisation';
        }
        field(50001; "Lending code"; Code[20])
        {
            Caption = 'Code Prêt';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Item Code")
        {
        }
        key(Key2; Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        EXIT;
        ParamPaie.GET;
        Salarie.GET("Employee No.");
        IF (Salarie."STC Payroll") AND (("Item Code" = '222') OR ("Item Code" = ParamPaie."Leave TIT")) THEN
            ERROR(STRSUBSTNO('%1\%2', Text04, Text06));
    end;

    trigger OnInsert();
    begin
        //*******************
        CalcItemAmount;
        TraiterRegulIRG;

        //*******************
    end;

    trigger OnModify();
    begin
        CalcItemAmount;
        TraiterRegulIRG;
    end;

    var
        Rubrique: Record 52182481;
        Rubrique2: Record 52182481;
        EmployeePayrollItem: Record 52182482;
        EmployeePayrollItem2: Record 52182482;
        ParamPaie: Record 52182483;
        Text01: Label 'Nature de la rubrique ne doit pas être "Calculée" !';
        Text02: Label '%1 ne doit pas dépasser %2 !';
        Text03: Label '%1 doit être positif !';
        Salarie: Record 5200;
        NbreJoursTravailles: Decimal;
        Text04: Label 'Suppression impossible de la rubrique %1';
        PayrollMgt: Codeunit 52182430;
        Text05: Label 'Rubrique %1 bloquée à l''utilisation !';
        Text06: Label 'Utiliser la fonction Annuler le STC puis réessayer de nouveau.';
        Text07: Label 'Utiliser la fonction Générer le STC.';

    /// <summary>
    /// CalcItemAmount.
    /// </summary>
    procedure CalcItemAmount();
    begin
        ParamPaie.GET;
        IF Rubrique.GET("Item Code") THEN BEGIN
            IF Rubrique."Item Type" = Rubrique."Item Type"::"Libre saisie" THEN
                IF Number = 0 THEN BEGIN
                    Basis := Rubrique.Tarification;
                    IF Rate = 0 THEN
                        Amount := Basis * Number
                    ELSE
                        Amount := Basis * Rate / 100;
                END
                ELSE
                    Amount := Basis * Number;
            IF Rubrique."Item Type" = Rubrique."Item Type"::Pourcentage THEN BEGIN
                Rubrique.TESTFIELD("Basis of Calculation");
                EmployeePayrollItem.GET("Employee No.", Rubrique."Basis of Calculation");
                IF Rate = 0 THEN BEGIN
                    Basis := EmployeePayrollItem.Amount;
                    Rate := Rubrique."Calculation Rate";
                END;
                Amount := EmployeePayrollItem.Amount * Rate / 100;
            END;
            IF Rubrique."Item Type" = Rubrique."Item Type"::"Au prorata" THEN BEGIN
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                    Rate := PayrollMgt.NbreJoursPresence("Employee No.") / ParamPaie."No. of Worked Days";
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                    Rate := PayrollMgt.NbreHeuresPresence("Employee No.") / ParamPaie."No. of Worked Hours";
                Amount := Basis * Rate;
            END;
            IF Rubrique."Item Type" = Rubrique."Item Type"::"Au prorata autorisé" THEN BEGIN
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                    Rate := PayrollMgt.NbreJoursPresence("Employee No.") / ParamPaie."No. of Worked Days";
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN
                    Rate := PayrollMgt.NbreHeuresPresence("Employee No.") / ParamPaie."No. of Worked Hours";
                Amount := Basis * Rate;
            END;
            IF "Item Code" = ParamPaie."Base Salary" THEN BEGIN
                IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN
                    Amount := ROUND(Number * Basis);
            END;
            IF "Item Code" = ParamPaie.IEP THEN BEGIN
                Salarie.GET("Employee No.");
                Rate := Salarie."Previous IEP" + Salarie."Current IEP";
                IF Rate > ParamPaie."Maximal IEP" THEN
                    Rate := ParamPaie."Maximal IEP";
            END;
        END;
    end;

    /// <summary>
    /// TraiterRegulIRG.
    /// </summary>
    procedure TraiterRegulIRG();
    begin
        //Régularisation de l'IRG
        ParamPaie.GET;
        Rubrique2.RESET;
        Rubrique2.SETFILTER(Code, ParamPaie."TIT Filter");
        Rubrique2.SETRANGE("Reminder +", "Item Code");
        IF Rubrique2.FINDSET THEN BEGIN
            IF Basis > 0 THEN
                Basis := -Basis;
            IF Amount < 0 THEN
                Amount := -Amount;
            EXIT;
        END;
        Rubrique2.RESET;
        Rubrique2.SETFILTER(Code, ParamPaie."TIT Filter");
        Rubrique2.SETRANGE("Reminder -", "Item Code");
        IF Rubrique2.FINDSET THEN BEGIN
            IF Basis < 0 THEN
                Basis := -Basis;
            IF Amount > 0 THEN
                Amount := -Amount;
            EXIT;
        END;
        // MODIFY;
    end;
}

