/// <summary>
/// Page Employee Unavailabilities (ID 51424).
/// </summary>
page 52182459 "Employee Unavailabilities"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Unavailabilities',
                FRA = 'Indisponibilités du salarié';
    Editable = false;
    PageType = Card;
    SourceTable = "Employee Unavailability";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Cause of Inactivity Code"; "Cause of Inactivity Code")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(Comment; Comment)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Unavailability")
            {
                CaptionML = ENU = '&Unavailability',
                            FRA = '&Indisponibilité';
                Image = Absence;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), //Count(10)
                                  "Table Line No." = FIELD("Entry No.");
                }
            }
        }
    }


}

