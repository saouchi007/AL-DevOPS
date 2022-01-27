/// <summary>
/// Page Wilayas (ID 52182578).
/// </summary>
page 52182578 Wilayas
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Wilayas',
                FRA = 'Wilayas';
    PageType = Card;
    SourceTable = Wilaya;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
            }
        }
    }

    actions
    {
    }


}

