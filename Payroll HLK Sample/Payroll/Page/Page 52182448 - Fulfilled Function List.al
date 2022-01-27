/// <summary>
/// Page Fulfilled Function List (ID 52182448).
/// </summary>
page 52182448 "Fulfilled Function List" //Experience Salarié
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Fulfilled Function List',
                FRA = 'Liste des fonctions occupées salarié';
    PageType = List;
    SourceTable = "Employee Fulfilled Function";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Employer No."; "Employer No.")
                {
                }
                field("Function Code"; "Function Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Employer Description"; "Employer Description")
                {
                }
                field("Function Description"; "Function Description")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Period; Period)
                {
                }
            }
        }
    }

    actions
    {
    }


}

