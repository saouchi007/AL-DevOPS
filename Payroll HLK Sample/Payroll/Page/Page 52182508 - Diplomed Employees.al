/// <summary>
/// Page Diplomed Employees (ID 52182508).
/// </summary>
page 52182508 "Diplomed Employees"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Diplomed Employees',
                FRA = 'Salariés diplômés';
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Diploma";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Diploma Code"; "Diploma Code")
                {
                }
                field("Obtention Date"; "Obtention Date")
                {
                }
                field("Diploma Domain Code"; "Diploma Domain Code")
                {
                }
            }
        }
    }

    actions
    {
    }


}

