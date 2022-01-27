/// <summary>
/// Page Unavailability Registration (ID 52182460).
/// </summary>
page 52182460 "Unavailability Registration" //page de saisie des indisponibilité
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Unavailabilities Registration',
                FRA = 'Saisie des indisponibilités';
    DelayedInsert = true;
    PageType = List;
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
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
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
                Image = InactivityDescription;

                CaptionML = ENU = '&Unavailability',
                            FRA = '&Indisponibilité';
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1),
                    "Table Line No." = FIELD("Entry No.");
                }
            }
        }
    }



}

