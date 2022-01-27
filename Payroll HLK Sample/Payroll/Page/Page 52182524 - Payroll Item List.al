/// <summary>
/// Page Payroll Item List (ID 52182524).
/// </summary>
page 52182524 "Payroll Item List"
{
    // version HALRHPAIE.6.2.00

    // MODIFIER PAR DJEBARA YACINE LE 15/09/2015
    // Vérouillage de toutes les collones pour tous les utilisateurs sauf ASSIA HAMITOUCHE ET MOKHTAR SALHI ET NORA YOUNSI

    CaptionML = ENU = 'Payroll Item List',
                FRA = 'Liste des rubriques de paie';
    PageType = List;
    SourceTable = "Payroll Item";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Code; Code)
                {

                    trigger OnValidate();
                    begin
                        PayrollSetup.GET;
                        accountEdit := (Code <> PayrollSetup."Post Salary") AND (Code <> PayrollSetup."Taxable Salary");
                    end;
                }
                field(Description; Description)
                {
                }
                field(Nature; Nature)
                {

                    trigger OnValidate();
                    begin
                        itemTypeEdit := Nature <> Nature::Calculated;
                    end;
                }
                field("Item Type"; "Item Type")
                {
                    Editable = itemTypeEdit;
                }
                field(Category; Category)
                {
                }
                field(Taxable; Taxable)
                {
                }
                field(Regularization; Regularization)
                {

                    trigger OnValidate();
                    begin
                        reminderEdit := NOT Regularization;
                    end;
                }
                field("Basis of Calculation"; "Basis of Calculation")
                {
                }
                field("Calculation Rate"; "Calculation Rate")
                {
                }
                field("Calculation Formula"; "Calculation Formula")
                {
                }
                field(Tarification; Tarification)
                {
                }
                field("Reminder +"; "Reminder +")
                {
                    Editable = reminderEdit;
                }
                field("Reminder -"; "Reminder -")
                {
                    Editable = reminderEdit;
                }
                field(Balance; Balance)
                {
                }
                field("Net Change"; "Net Change")
                {
                }
                field("Account No."; "Account No.")
                {
                    Editable = accountEdit;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    Editable = accountEdit;
                }
                field("Submitted To Leave"; "Submitted To Leave")
                {
                }
                field("TIT Out of Grid"; "TIT Out of Grid")
                {
                }
                field(Variable; Variable)
                {
                }
                field("Ignored When Reminder"; "Ignored When Reminder")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Non Cotisable et Imposable"; "Non Cotisable et Imposable")
                {
                }
                field("Non Cotisable Non Imposable"; "Non Cotisable Non Imposable")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        CodeOnFormat;
        DescriptionOnFormat;
        itemTypeEdit := Nature <> Nature::Calculated;
        reminderEdit := NOT Regularization;

        PayrollSetup.GET;
        accountEdit := (Code <> PayrollSetup."Post Salary") AND (Code <> PayrollSetup."Taxable Salary");
    end;

    trigger OnInit();
    begin

        //-------- Vérouillage de toutes les collones pour tous les utilisateurs sauf ASSIA HAMITOUCHE ET MOKHTAR SALHI ET NORA YOUNSI

        /*    CurrForm.EDITABLE:=FALSE;
        IF USERID IN ['ASSIA.HAMITOUCHE','MOKHTAR.SALHI','NORA.YOUNSI'] THEN
            CurrForm.EDITABLE:=TRUE;
        */

        itemTypeEdit := FALSE;
        reminderEdit := FALSE;
        accountEdit := FALSE;

    end;


    var
        PayrollSetup: Record Payroll_Setup;
        itemTypeEdit: Boolean;
        reminderEdit: Boolean;
        accountEdit: Boolean;


    local procedure ItemTypeOnBeforeInput();
    begin
        //CurrPage."Item Type".UPDATEEDITABLE(Nature<>Nature::Calculated);
    end;

    local procedure Reminder43OnBeforeInput();
    begin
        //CurrPage."Reminder +".UPDATEEDITABLE(NOT Regularization);
    end;

    local procedure ReminderOnBeforeInput();
    begin
        //CurrPage."Reminder -".UPDATEEDITABLE(NOT Regularization);
    end;

    local procedure AccountNoOnBeforeInput();
    begin
    end;

    local procedure BalAccountNoOnBeforeInput();
    begin
    end;

    local procedure CodeOnFormat();
    begin
        /*PayrollSetup.GET;
        CurrPage.Code.UPDATEFONTBOLD((Code=PayrollSetup."Base Salary")
        OR(Code=PayrollSetup."Base Salary Without Indemnity")
        OR(Code=PayrollSetup."Post Salary")
        OR(Code=PayrollSetup."Taxable Salary")
        OR(Code=PayrollSetup."Net Salary"));
         */

    end;

    local procedure DescriptionOnFormat();
    begin
        /*PayrollSetup.GET;
        CurrPage.Description.UPDATEFONTBOLD((Code=PayrollSetup."Base Salary")
        OR(Code=PayrollSetup."Base Salary Without Indemnity")
        OR(Code=PayrollSetup."Post Salary")
        OR(Code=PayrollSetup."Taxable Salary")
        OR(Code=PayrollSetup."Net Salary")); */

    end;
}

