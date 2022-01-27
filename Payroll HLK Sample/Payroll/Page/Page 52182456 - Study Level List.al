/// <summary>
/// Page Study Level List (ID 51421).
/// </summary>
page 52182456 "Study Level List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Course Grade List',
                FRA = 'Liste des niveaux d''étude';
    PageType = Card;
    SourceTable = "Course Grade";

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

