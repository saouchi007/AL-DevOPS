/// <summary>
/// Page Diploma List (ID 52182432).
/// </summary>
page 52182432 "Diploma List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Diploma List',
                FRA = 'Liste des diplômes';
    PageType = Card;
    SourceTable = Diploma;

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
                field(Level; Level)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Diploma")
            {
                CaptionML = ENU = '&Diploma',
                            FRA = '&Diplôme';
                Image = Card;
                action("&Trainings")
                {
                    CaptionML = ENU = '&Trainings',
                                FRA = '&Formations';
                    Image = ItemTrackingLines;
                    RunObject = Page 52182509;
                }
                action("&Diploma Overview")
                {
                    CaptionML = ENU = '&Diploma Overview',
                                FRA = '&Détail diplômes';
                    Image = FiledOverview;
                    RunObject = Page 52182498;
                }

                action("&Post Required Diplomas")
                {
                    CaptionML = ENU = '&Post Required Diplomas',
                                FRA = '&Diplômes requis du poste';
                    Image = PostedPayableVoucher;
                    RunObject = Page 52182470;
                    RunPageLink = "Diploma Code" = FIELD(Code);
                }
            }
        }
    }


}

