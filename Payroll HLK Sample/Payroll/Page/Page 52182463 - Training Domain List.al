/// <summary>
/// Page Training Domain List (ID 51428).
/// </summary>
page 52182463 "Training Domain List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Domain List',
                FRA = 'Liste des domaines de formation';
    PageType = Card;
    SourceTable = "Training Domain";

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
                field("No. of Subdomains"; "No. of Subdomains")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Domain")
            {
                CaptionML = ENU = '&Domain',
                            FRA = '&Domaine';
                Image = CreateDocument;
                action("&Subdomains")
                {
                    CaptionML = ENU = '&Subdomains',
                                FRA = '&Sous-domaines';
                    Image = CreateDocuments;
                    RunObject = Page 52182464;
                    RunPageLink = "Domain Code" = FIELD(Code);
                }
            }
        }
    }


}

