/// <summary>
/// Page Training Aims (ID 51560).
/// </summary>
page 52182580 "Training Aims"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Aims',
                FRA = 'Objectifs de formation';
    PageType = Card;
    SourceTable = "Training Aim";

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

