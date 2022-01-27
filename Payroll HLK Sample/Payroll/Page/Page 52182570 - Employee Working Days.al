/// <summary>
/// Page Employee Working Days (ID 51545).
/// </summary>
page 52182570 "Employee Working Days"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Working Days',
                FRA = 'Jours de travail du salarié';
    PageType = Card;
    SourceTable = "Employee Working Days";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field(Day; Day)
                {
                }
                field("Starting Time"; "Starting Time")
                {
                }
                field("Ending Time"; "Ending Time")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
            }
        }
    }

    actions
    {
    }

   
}

