/// <summary>
/// Page Payroll Items (ID 51552).
/// </summary>
page 52182574 "Payroll Items"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Item List',
                FRA = 'Liste des rubriques de paie';
    Editable = true;
    PageType = Card;
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
                        balAccountNo := (Code <> PayrollSetup."Post Salary") AND (Code <> PayrollSetup."Taxable Salary");
                        PayrollSetup.GET;
                        accountNo := (Code <> PayrollSetup."Post Salary") AND (Code <> PayrollSetup."Taxable Salary");
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
                }
                field(Category; Category)
                {
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
                field(Balance; Balance)
                {
                }
                field("Net Change"; "Net Change")
                {
                }
                field(Taxable; Taxable)
                {
                    // Editable = false;
                }
                field(Regularization; Regularization)
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
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

        PayrollSetup.GET;
        accountNo := (Code <> PayrollSetup."Post Salary") AND (Code <> PayrollSetup."Taxable Salary");

        PayrollSetup.GET;
        balAccountNo := (Code <> PayrollSetup."Post Salary") AND (Code <> PayrollSetup."Taxable Salary");
    end;

    trigger OnInit();
    begin
        itemTypeEdit := FALSE;
        accountNo := FALSE;
        balAccountNo := FALSE;
    end;

    trigger OnOpenPage();
    begin

        FILTERGROUP(2);
        SETFILTER(Blocked, '%1|%2', Blocked::None, Blocked::Use);
        FILTERGROUP(0);
    end;

    var
        PayrollSetup: Record Payroll_Setup;
        itemTypeEdit: Boolean;
        balAccountNo: Boolean;
        accountNo: Boolean;


    local procedure ItemTypeOnBeforeInput();
    begin
        //CurrPage."Item Type".UPDATEEDITABLE(Nature<>Nature::Calculated);
    end;

    local procedure AccountNoOnBeforeInput();
    begin
        /*PayrollSetup.GET;
        CurrPage."Account No.".UPDATEEDITABLE((Code<>PayrollSetup."Post Salary")
        AND(Code<>PayrollSetup."Taxable Salary"));       */

    end;

    local procedure BalAccountNoOnBeforeInput();
    begin
        /*PayrollSetup.GET;
        CurrPage."Bal. Account No.".UPDATEEDITABLE((Code<>PayrollSetup."Post Salary")
        AND(Code<>PayrollSetup."Taxable Salary"));   */

    end;

    local procedure CodeOnFormat();
    begin
        /*PayrollSetup.GET;
        CurrPage.Code.UPDATEFONTBOLD((Code=PayrollSetup."Base Salary")
        OR(Code=PayrollSetup."Base Salary Without Indemnity")
        OR(Code=PayrollSetup."Post Salary")
        OR(Code=PayrollSetup."Taxable Salary")
        OR(Code=PayrollSetup."Net Salary"));   */

    end;

    local procedure DescriptionOnFormat();
    begin
        /*PayrollSetup.GET;
        CurrPage.Description.UPDATEFONTBOLD((Code=PayrollSetup."Base Salary")
        OR(Code=PayrollSetup."Base Salary Without Indemnity")
        OR(Code=PayrollSetup."Post Salary")
        OR(Code=PayrollSetup."Taxable Salary")
        OR(Code=PayrollSetup."Net Salary"));     */

    end;
}

