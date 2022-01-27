/// <summary>
/// Page Payroll Archive Subform (ID 51498).
/// </summary>
page 52182530 "Payroll Archive Subform"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Archive Subform',
                FRA = 'Sous-formulaire archive paie';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Payroll Archive Line";

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
                field(Type; Type)
                {
                }
                field(Number; Number)
                {
                }
                field(Basis; Basis)
                {
                }
                field(Rate; Rate)
                {
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }



    var
        PayrollSetup: Record Payroll_Setup;
        Employee: Record 5200;
        Text01: Label 'Suppression impossible de la rubrique %1 !';

}

