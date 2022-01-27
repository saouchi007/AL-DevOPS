/// <summary>
/// Page Movement (ID 51439).
/// </summary>
page 52182474 Movement
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Movement',
                FRA = 'Mouvement';
    PageType = Card;
    SourceTable = "Employee Movement" ;

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

