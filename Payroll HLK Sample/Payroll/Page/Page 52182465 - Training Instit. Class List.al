/// <summary>
/// Page Training Instit. Class List (ID 51430).
/// </summary>
page 52182465 "Training Instit. Class List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Instit. Class List',
                FRA = 'Liste des classes d''établiss. de formation';
    PageType = Card;
    SourceTable = "Training Institution Class";

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

