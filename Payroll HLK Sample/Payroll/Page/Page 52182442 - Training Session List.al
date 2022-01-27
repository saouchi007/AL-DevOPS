/// <summary>
/// Page Training Session List (ID 52182442).
/// </summary>
page 52182442 "Training Session List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Session List',
                FRA = 'Liste des sessions de formation';
    PageType = Card;
    SourceTable = "Training Session";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Institution No."; "Institution No.")
                {
                }
                field("Training No."; "Training No.")
                {
                }
                field("No."; "No.")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Starting Time"; "Starting Time")
                {
                }
                field("Ending Time"; "Ending Time")
                {
                }
                field("No. of Days"; "No. of Days")
                {
                }
                field("No. of Hours"; "No. of Hours")
                {
                }
                field("Minimum participants"; "Minimum participants")
                {
                }
                field("Maximum participants"; "Maximum participants")
                {
                }
            }
        }
    }

    actions
    {
    }


}

