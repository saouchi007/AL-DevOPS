/// <summary>
/// Page Leave Periods (ID 52182547).
/// </summary>
page 52182547 "Leave Periods"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Leave Periods',
                FRA = 'Périodes de congé';
    Editable = false;
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

