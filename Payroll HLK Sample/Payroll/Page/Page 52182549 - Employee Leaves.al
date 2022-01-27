/// <summary>
/// Page Employee Leaves (ID 52182549).
/// </summary>
page 52182549 "Employee Leaves"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Leaves',
                FRA = 'Congés salarié';
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Leave";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Leave Period"; "Leave Period")
                {
                }
                field("Leave Right"; "Leave Right")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Recovery Date"; "Recovery Date")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Leave")
            {
                CaptionML = ENU = '&Leave',
                            FRA = '&Congé';
                Image = Holiday;
                action("&Leave1")
                {
                    CaptionML = ENU = '&Leave',
                                FRA = '&Droits au congé';
                    Image = Holiday;
                    RunObject = Page "Leave Rights";
                    RunPageLink = "Employee No." = FIELD("Employee No.");
                }
            }
        }
    }


}

