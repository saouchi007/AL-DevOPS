/// <summary>
/// Page Causes of Departure (ID 51456).
/// </summary>
page 52182491 "Causes of Departure"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Causes of Departure',
                FRA = 'Motifs de départ';
    PageType = Card;
    SourceTable = "Cause of Departure";

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
            }
        }
    }

    actions
    {
    }


}

