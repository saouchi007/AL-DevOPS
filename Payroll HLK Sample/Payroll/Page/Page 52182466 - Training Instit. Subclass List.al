/// <summary>
/// Page Training Instit. Subclass List (ID 52182466).
/// </summary>
page 52182466 "Training Instit. Subclass List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Instit. Subclass List',
                FRA = 'Liste des sous-classes d''établiss. de formation';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Training Institution Subclass";

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

