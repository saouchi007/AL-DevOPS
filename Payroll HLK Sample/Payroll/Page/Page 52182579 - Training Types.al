/// <summary>
/// Page Training Types (ID 52182579).
/// </summary>
page 52182579 "Training Types"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Types',
                FRA = 'Types de formation';
    PageType = Card;
    SourceTable = "Training Type";

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

