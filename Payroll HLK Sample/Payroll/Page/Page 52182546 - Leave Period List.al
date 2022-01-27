/// <summary>
/// Page Leave Period List (ID 51516).
/// </summary>
page 52182546 "Leave Period List"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Leave Period List',
                FRA = 'Liste des périodes de congé';
    PageType = Card;
    SourceTable = "Leave Period";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Code; Code)
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
                field(Closed; Closed)
                {
                }
            }
        }
    }

    actions
    {
    }


}

