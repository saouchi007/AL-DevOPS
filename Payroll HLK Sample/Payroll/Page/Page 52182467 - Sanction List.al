/// <summary>
/// Page Sanction List (ID 52182467).
/// </summary>
page 52182467 "Sanction List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Sanction List',
                FRA = 'Liste des sanctions';
    PageType = Card;
    SourceTable = Sanction;

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
        area(navigation)
        {
            group("&Sanction")
            {
                CaptionML = ENU = '&Sanction',
                            FRA = '&Sanction';
                Image = DeleteAllBreakpoints;
                action("&Détail sanctions")
                {
                    Caption = '&Détail sanctions';
                    Image = ViewDetails;
                    RunObject = Page 52182514;
                }
            }
        }
    }


}

