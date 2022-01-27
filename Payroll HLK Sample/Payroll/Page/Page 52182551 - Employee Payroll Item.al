/// <summary>
/// Page Employee Payroll Item (ID 52182551).
/// </summary>
page 52182551 "Employee Payroll Item"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Payroll Item',
                FRA = 'Liste des rubriques salarié';
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Payroll Item";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                    Visible = false;
                }
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

}

