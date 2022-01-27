/// <summary>
/// Page Causes of Accident (ID 52182501).
/// </summary>
page 52182501 "Causes of Accident"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Causes of Accident',
                FRA = 'Motifs d''accident';
    PageType = Card;
    SourceTable = "Cause of Accident";

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

