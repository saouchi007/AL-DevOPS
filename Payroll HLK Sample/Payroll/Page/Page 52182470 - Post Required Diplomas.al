/// <summary>
/// Page Post Required Diplomas (ID 51435).
/// </summary>
page 52182470 "Post Required Diplomas"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Post Required Diplomas',
                FRA = 'Diplômes requis du poste';
    PageType = Card;
    SourceTable = "Post Required Diploma";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Post Code"; "Post Code")
                {
                }
                field("Diploma Code"; "Diploma Code")
                {
                }
                field("Diploma Domain Code"; "Diploma Domain Code")
                {
                }
                field("Diploma Description"; "Diploma Description")
                {
                }
                field("Diploma Domain Description"; "Diploma Domain Description")
                {
                }
            }
        }
    }

    actions
    {
    }


}

