/// <summary>
/// Page Training Subdomain List (ID 52182464).
/// </summary>
page 52182464 "Training Subdomain List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Subdomain List',
                FRA = 'Liste des sous-domaines de formation';
    DataCaptionFields = "Domain Code";
    PageType = Card;
    SourceTable = "Training Subdomain";

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
                field("Domain Code"; "Domain Code")
                {
                    Editable = false;
                }
                field("Domain Description"; "Domain Description")
                {
                }
            }
        }
    }

    actions
    {
    }


}

