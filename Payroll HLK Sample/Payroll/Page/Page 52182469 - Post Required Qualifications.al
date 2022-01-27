/// <summary>
/// Page Post Required Qualifications (ID 51434).
/// </summary>
page 52182469 "Post Required Qualifications"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Post Required Qualifications',
                FRA = 'Qualifications requises du poste';
    PageType = Card;
    SourceTable = "Post Required Qualification";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Post Code"; "Post Code")
                {
                }
                field("Qualification Code"; "Qualification Code")
                {
                }
                field("Qualification Description"; "Qualification Description")
                {
                }
                field("Post Description"; "Post Description")
                {
                }
            }
        }
    }

    actions
    {
    }


}

