/// <summary>
/// Page Base Salary Changes (ID 51524).
/// </summary>
page 52182553 "Base Salary Changes"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Base Salary Changes',
                FRA = 'Changements de salaire de base';
    Editable = false;
    PageType = Card;
    SourceTable = "Base Salary Changes";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Employee First Name"; "Employee First Name")
                {
                }
                field("Employee Last Name"; "Employee Last Name")
                {
                }
                field("Old Base Salary"; "Old Base Salary")
                {
                }
                field("New Base Salary"; "New Base Salary")
                {
                }
            }
        }
    }

    actions
    {
    }


}

