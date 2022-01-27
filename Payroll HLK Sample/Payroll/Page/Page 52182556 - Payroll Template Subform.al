/// <summary>
/// Page Payroll Template Subform (ID 51527).
/// </summary>
page 52182556 "Payroll Template Subform"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Template Subform',
                FRA = 'Sous-formulaire modèle de paie';
    PageType = ListPart;
    SourceTable = "Payroll Template Line";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Item Code"; "Item Code")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Item Type"; "Item Type")
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
    }



    var
        PayrollSetup: Record Payroll_Setup;


    local procedure AmountOnBeforeInput();
    begin
        PayrollSetup.GET;
        //CurrPage.Amount.UPDATEEDITABLE(("Item Type"="Item Type"::"Libre saisie")AND("Item Code"<>PayrollSetup."Base Salary"));
        CurrPage.UPDATE;
    end;
}

