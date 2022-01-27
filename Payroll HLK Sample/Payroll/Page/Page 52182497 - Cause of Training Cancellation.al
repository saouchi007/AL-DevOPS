/// <summary>
/// Page Cause of Training Cancellation (ID 52182497).
/// </summary>
page 52182497 "Cause of Training Cancellation"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Cause of Training Cancellation',
                FRA = 'Motifs d''annulation de formation';
    PageType = Card;
    SourceTable = "Cause of Training Cancellation";

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

