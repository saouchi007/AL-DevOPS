/// <summary>
/// Page Employee Payroll Items Subform (ID 51494).
/// </summary>
page 52182526 "Employee Payroll Items Subform"
{
    // version HALRHPAIE.6.1.03

    AutoSplitKey = false;
    CaptionML = ENU = 'Employee Payroll Items Subform',
                FRA = 'Sous-formulaire saisie des rubriques salarié';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Employee Payroll Item";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Item Code"; "Item Code")
                {

                    trigger OnValidate();
                    begin


                        Employee.GET("Employee No.");
                        IF ParamPaie."Allow Payroll Manual Adjust."
                        OR (Employee."Do not Use Treatment Grid") AND ("Item Code" = ParamPaie."Base Salary") THEN
                            basisEdit := TRUE
                        ELSE
                            basisEdit := (Type <> Type::Formule) AND (Type <> Type::Pourcentage)
                             OR (ParamPaie."Allow SS Manual Modif.")
                             AND (("Item Code" = ParamPaie."Employee SS Deduction") OR ("Item Code" = ParamPaie."Post Salary"))
                             OR ((ParamPaie."Allow TIT Manual Modif.") AND (("Item Code" = ParamPaie."TIT Deduction")
                             OR ("Item Code" = ParamPaie."TIT Out of Grid") OR ("Item Code" = ParamPaie."Taxable Salary")
                             OR ("Item Code" = ParamPaie."Net Salary")));

                        IF ParamPaie."Allow Payroll Manual Adjust." THEN
                            rateEdit := TRUE
                        ELSE
                            rateEdit := (Type = Type::Pourcentage)
                            OR ("Item Code" = ParamPaie."TIT Out of Grid")
                            OR (("Item Code" >= ParamPaie."Taxable Salary") AND ("Item Code" <= ParamPaie."Net Salary"));

                        IF ParamPaie."Allow Payroll Manual Adjust." THEN
                            amountEdit := TRUE
                        ELSE BEGIN
                            amountEdit := ((ParamPaie."Allow TIT Manual Modif.") AND
                           (("Item Code" = ParamPaie."TIT Deduction") OR ("Item Code" = ParamPaie."Net Salary")
                           OR ("Item Code" = ParamPaie."TIT Out of Grid"))
                           OR (ParamPaie."Allow SS Manual Modif.") AND ("Item Code" = ParamPaie."Employee SS Deduction"));

                            amountEdit := ((Type <> Type::Formule) AND (Type <> Type::Pourcentage)
                            OR (ParamPaie."Allow SS Manual Modif.")
                            AND (("Item Code" = ParamPaie."Employee SS Deduction") OR ("Item Code" = ParamPaie."Post Salary"))
                            OR ((ParamPaie."Allow TIT Manual Modif.") AND (("Item Code" = ParamPaie."TIT Deduction")
                            OR ("Item Code" = ParamPaie."TIT Out of Grid") OR ("Item Code" = ParamPaie."Taxable Salary")
                            OR (("Item Code" >= ParamPaie."Taxable Salary") AND ("Item Code" <= ParamPaie."Net Salary")))));
                        END;
                    end;
                }
                field("Item Description"; "Item Description")
                {
                    Editable = itemCodeEdit;
                }
                field(Type; Type)
                {
                    Editable = itemCodeEdit;

                    trigger OnValidate();
                    begin
                        itemCodeEdit := Type <> Type::Formule;

                        IF ParamPaie."Allow Payroll Manual Adjust." THEN
                            numberEdit := TRUE
                        ELSE
                            numberEdit := (Type <> Type::Formule) AND (Type <> Type::Pourcentage)
                            AND (Type <> Type::"Au prorata") OR ("Item Code" = ParamPaie."Base Salary");

                        Employee.GET("Employee No.");
                        IF ParamPaie."Allow Payroll Manual Adjust."
                        OR (Employee."Do not Use Treatment Grid") AND ("Item Code" = ParamPaie."Base Salary") THEN
                            basisEdit := TRUE
                        ELSE
                            basisEdit := (Type <> Type::Formule) AND (Type <> Type::Pourcentage)
                             OR (ParamPaie."Allow SS Manual Modif.")
                             AND (("Item Code" = ParamPaie."Employee SS Deduction") OR ("Item Code" = ParamPaie."Post Salary"))
                             OR ((ParamPaie."Allow TIT Manual Modif.") AND (("Item Code" = ParamPaie."TIT Deduction")
                             OR ("Item Code" = ParamPaie."TIT Out of Grid") OR ("Item Code" = ParamPaie."Taxable Salary")
                             OR ("Item Code" = ParamPaie."Net Salary")));

                        IF ParamPaie."Allow Payroll Manual Adjust." THEN
                            rateEdit := TRUE
                        ELSE
                            rateEdit := (Type = Type::Pourcentage)
                            OR ("Item Code" = ParamPaie."TIT Out of Grid")
                            OR (("Item Code" >= ParamPaie."Taxable Salary") AND ("Item Code" <= ParamPaie."Net Salary"));

                        IF ParamPaie."Allow Payroll Manual Adjust." THEN
                            amountEdit := TRUE
                        ELSE BEGIN
                            amountEdit := ((ParamPaie."Allow TIT Manual Modif.") AND
                           (("Item Code" = ParamPaie."TIT Deduction") OR ("Item Code" = ParamPaie."Net Salary")
                           OR ("Item Code" = ParamPaie."TIT Out of Grid"))
                           OR (ParamPaie."Allow SS Manual Modif.") AND ("Item Code" = ParamPaie."Employee SS Deduction"));

                            amountEdit := ((Type <> Type::Formule) AND (Type <> Type::Pourcentage)
                            OR (ParamPaie."Allow SS Manual Modif.")
                            AND (("Item Code" = ParamPaie."Employee SS Deduction") OR ("Item Code" = ParamPaie."Post Salary"))
                            OR ((ParamPaie."Allow TIT Manual Modif.") AND (("Item Code" = ParamPaie."TIT Deduction")
                            OR ("Item Code" = ParamPaie."TIT Out of Grid") OR ("Item Code" = ParamPaie."Taxable Salary")
                            OR (("Item Code" >= ParamPaie."Taxable Salary") AND ("Item Code" <= ParamPaie."Net Salary")))));
                        END;
                    end;
                }
                field(Number; Number)
                {
                    Editable = numberEdit;
                }
                field(Basis; Basis)
                {
                }
                field(Rate; Rate)
                {
                    Editable = rateEdit;
                }
                field(Amount; Amount)
                {
                    Editable = amountEdit;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin

        ItemCodeOnFormat;
        ItemDescriptionOnFormat;
        TypeOnFormat;
        NumberOnFormat;
        BasisOnFormat;
        RateOnFormat;
        AmountOnFormat;
        itemCodeEdit := Type <> Type::Formule;

        IF ParamPaie."Allow Payroll Manual Adjust." THEN
            numberEdit := TRUE
        ELSE
            numberEdit := (Type <> Type::Formule) AND (Type <> Type::Pourcentage)
            AND (Type <> Type::"Au prorata") OR ("Item Code" = ParamPaie."Base Salary");

        Employee.GET("Employee No.");
        IF ParamPaie."Allow Payroll Manual Adjust."
        OR (Employee."Do not Use Treatment Grid") AND ("Item Code" = ParamPaie."Base Salary") THEN
            basisEdit := TRUE
        ELSE
            basisEdit := (Type <> Type::Formule) AND (Type <> Type::Pourcentage)
             OR (ParamPaie."Allow SS Manual Modif.")
             AND (("Item Code" = ParamPaie."Employee SS Deduction") OR ("Item Code" = ParamPaie."Post Salary"))
             OR ((ParamPaie."Allow TIT Manual Modif.") AND (("Item Code" = ParamPaie."TIT Deduction")
             OR ("Item Code" = ParamPaie."TIT Out of Grid") OR ("Item Code" = ParamPaie."Taxable Salary")
             OR ("Item Code" = ParamPaie."Net Salary")));


        IF ParamPaie."Allow Payroll Manual Adjust." THEN
            rateEdit := TRUE
        ELSE
            rateEdit := (Type = Type::Pourcentage)
            OR ("Item Code" = ParamPaie."TIT Out of Grid")
            OR (("Item Code" >= ParamPaie."Taxable Salary") AND ("Item Code" <= ParamPaie."Net Salary"));

        IF ParamPaie."Allow Payroll Manual Adjust." THEN
            amountEdit := TRUE
        ELSE BEGIN
            amountEdit := ((ParamPaie."Allow TIT Manual Modif.") AND
           (("Item Code" = ParamPaie."TIT Deduction") OR ("Item Code" = ParamPaie."Net Salary")
           OR ("Item Code" = ParamPaie."TIT Out of Grid"))
           OR (ParamPaie."Allow SS Manual Modif.") AND ("Item Code" = ParamPaie."Employee SS Deduction"));

            amountEdit := ((Type <> Type::Formule) AND (Type <> Type::Pourcentage)
            OR (ParamPaie."Allow SS Manual Modif.")
            AND (("Item Code" = ParamPaie."Employee SS Deduction") OR ("Item Code" = ParamPaie."Post Salary"))
            OR ((ParamPaie."Allow TIT Manual Modif.") AND (("Item Code" = ParamPaie."TIT Deduction")
            OR ("Item Code" = ParamPaie."TIT Out of Grid") OR ("Item Code" = ParamPaie."Taxable Salary")
            OR (("Item Code" >= ParamPaie."Taxable Salary") AND ("Item Code" <= ParamPaie."Net Salary")))));
        END;
    end;

    trigger OnInit();
    begin
        /* itemCodeEdit:=FALSE;
         numberEdit:=FALSE;
         basisEdit:=FALSE;
         rateEdit:=FALSE;
         amountEdit:=FALSE;*/

    end;

    trigger OnOpenPage();
    begin

        ParamPaie.GET;
    end;

    var
        ParamPaie: Record Payroll_Setup;
        Employee: Record 5200;
        Text01: Label 'Suppression impossible de la rubrique %1 !';
        itemCodeEdit: Boolean;
        numberEdit: Boolean;
        basisEdit: Boolean;
        rateEdit: Boolean;
        amountEdit: Boolean;


    local procedure ItemCodeOnBeforeInput();
    begin
        //CurrPage."Item Code".UPDATEEDITABLE(Type<>Type::Formule);
    end;

    local procedure ItemDescriptionOnBeforeInput();
    begin
        //CurrPage."Item Description".UPDATEEDITABLE(Type<>Type::Formule);
    end;

    local procedure TypeOnBeforeInput();
    begin
        //CurrPage.Type.UPDATEEDITABLE(Type<>Type::Formule);
    end;

    local procedure NumberOnBeforeInput();
    begin
        /*IF ParamPaie."Allow Payroll Manual Adjust."THEN
          CurrPage.Number.UPDATEEDITABLE(TRUE)
        ELSE
          CurrPage.Number.UPDATEEDITABLE((Type<>Type::Formule)AND(Type<>Type::Pourcentage)
          AND(Type<>Type::"Au prorata")OR("Item Code"=ParamPaie."Base Salary"));*/

    end;

    local procedure BasisOnBeforeInput();
    begin
        /*Employee.GET("Employee No.");
        IF ParamPaie."Allow Payroll Manual Adjust."
        OR(Employee."Do not Use Treatment Grid")AND("Item Code"=ParamPaie."Base Salary")THEN
          CurrPage.Basis.UPDATEEDITABLE(TRUE)
        ELSE
          CurrPage.Basis.UPDATEEDITABLE((Type<>Type::Formule)AND(Type<>Type::Pourcentage)
          OR (ParamPaie."Allow SS Manual Modif.")
          AND(("Item Code"=ParamPaie."Employee SS Deduction")OR("Item Code"=ParamPaie."Post Salary"))
          OR((ParamPaie."Allow TIT Manual Modif.")AND(("Item Code"=ParamPaie."TIT Deduction")
          OR("Item Code"=ParamPaie."TIT Out of Grid")OR("Item Code"=ParamPaie."Taxable Salary")
          OR("Item Code"=ParamPaie."Net Salary"))));  */

    end;

    local procedure RateOnBeforeInput();
    begin
        /*IF ParamPaie."Allow Payroll Manual Adjust."THEN
          CurrPage.Rate.UPDATEEDITABLE(TRUE)
        ELSE
          CurrPage.Rate.UPDATEEDITABLE((Type=Type::Pourcentage)
          OR("Item Code"=ParamPaie."TIT Out of Grid")
          OR(("Item Code">=ParamPaie."Taxable Salary")AND("Item Code"<=ParamPaie."Net Salary")));  */

    end;

    local procedure AmountOnBeforeInput();
    begin
        /*IF ParamPaie."Allow Payroll Manual Adjust."THEN
          CurrPage.Amount.UPDATEEDITABLE(TRUE)
        ELSE
          BEGIN
            CurrPage.Amount.UPDATEEDITABLE((ParamPaie."Allow TIT Manual Modif.")AND
            (("Item Code"=ParamPaie."TIT Deduction")OR("Item Code"=ParamPaie."Net Salary")
            OR("Item Code"=ParamPaie."TIT Out of Grid"))
            OR (ParamPaie."Allow SS Manual Modif.")AND("Item Code"=ParamPaie."Employee SS Deduction"));
        
            CurrPage.Amount.UPDATEEDITABLE((Type<>Type::Formule)AND(Type<>Type::Pourcentage)
            OR (ParamPaie."Allow SS Manual Modif.")
            AND(("Item Code"=ParamPaie."Employee SS Deduction")OR("Item Code"=ParamPaie."Post Salary"))
            OR((ParamPaie."Allow TIT Manual Modif.")AND(("Item Code"=ParamPaie."TIT Deduction")
            OR("Item Code"=ParamPaie."TIT Out of Grid")OR("Item Code"=ParamPaie."Taxable Salary")
            OR(("Item Code">=ParamPaie."Taxable Salary")AND("Item Code"<=ParamPaie."Net Salary")))));
          END;
            */

    end;

    local procedure ItemCodeOnFormat();
    begin
        /*CurrPage."Item Code".UPDATEFONTBOLD(
        ("Item Code"=ParamPaie."Base Salary")
        OR("Item Code"=ParamPaie."Base Salary Without Indemnity")
        OR("Item Code"=ParamPaie."Post Salary")
        OR("Item Code"=ParamPaie."Taxable Salary")
        OR("Item Code"=ParamPaie."DAIP Taxable Salary")
        OR("Item Code"=ParamPaie."Net Salary")); */

    end;

    local procedure ItemDescriptionOnFormat();
    begin
        /*CurrPage."Item Description".UPDATEFONTBOLD(
        ("Item Code"=ParamPaie."Base Salary")
        OR("Item Code"=ParamPaie."Base Salary Without Indemnity")
        OR("Item Code"=ParamPaie."Post Salary")
        OR("Item Code"=ParamPaie."Taxable Salary")
        OR("Item Code"=ParamPaie."DAIP Taxable Salary")
        OR("Item Code"=ParamPaie."Net Salary"));*/

    end;

    local procedure TypeOnFormat();
    begin
        /*CurrPage.Type.UPDATEFONTBOLD(
        ("Item Code"=ParamPaie."Base Salary")
        OR("Item Code"=ParamPaie."Base Salary Without Indemnity")
        OR("Item Code"=ParamPaie."Post Salary")
        OR("Item Code"=ParamPaie."Taxable Salary")
        OR("Item Code"=ParamPaie."DAIP Taxable Salary")
        OR("Item Code"=ParamPaie."Net Salary"));     */

    end;

    local procedure NumberOnFormat();
    begin
        /*CurrPage.Number.UPDATEFONTBOLD(
        ("Item Code"=ParamPaie."Base Salary")
        OR("Item Code"=ParamPaie."Base Salary Without Indemnity")
        OR("Item Code"=ParamPaie."Post Salary")
        OR("Item Code"=ParamPaie."Taxable Salary")
        OR("Item Code"=ParamPaie."DAIP Taxable Salary")
        OR("Item Code"=ParamPaie."Net Salary")); */

    end;

    local procedure BasisOnFormat();
    begin
        /*CurrPage.Basis.UPDATEFONTBOLD(
        ("Item Code"=ParamPaie."Base Salary")
        OR("Item Code"=ParamPaie."Base Salary Without Indemnity")
        OR("Item Code"=ParamPaie."Post Salary")
        OR("Item Code"=ParamPaie."Taxable Salary")
        OR("Item Code"=ParamPaie."DAIP Taxable Salary")
        OR("Item Code"=ParamPaie."Net Salary"));*/

    end;

    local procedure RateOnFormat();
    begin
        /*CurrPage.Rate.UPDATEFONTBOLD(
        ("Item Code"=ParamPaie."Base Salary")
        OR("Item Code"=ParamPaie."Base Salary Without Indemnity")
        OR("Item Code"=ParamPaie."Post Salary")
        OR("Item Code"=ParamPaie."Taxable Salary")
        OR("Item Code"=ParamPaie."DAIP Taxable Salary")
        OR("Item Code"=ParamPaie."Net Salary")); */

    end;

    local procedure AmountOnFormat();
    begin
        /*CurrPage.Amount.UPDATEFONTBOLD(
        ("Item Code"=ParamPaie."Base Salary")
        OR("Item Code"=ParamPaie."Base Salary Without Indemnity")
        OR("Item Code"=ParamPaie."Post Salary")
        OR("Item Code"=ParamPaie."Taxable Salary")
        OR("Item Code"=ParamPaie."DAIP Taxable Salary")
        OR("Item Code"=ParamPaie."Net Salary")); */

    end;
}

