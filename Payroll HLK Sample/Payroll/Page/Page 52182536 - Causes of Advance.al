/// <summary>
/// Page Causes of Advance (ID 51505).
/// </summary>
page 52182536 "Causes of Advance"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Causes of Advance',
                FRA = 'Motifs d''avance';
    PageType = Card;
    SourceTable = "Cause of Advance";

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
                field("Total Advance"; "Total Advance")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Advance")
            {
                CaptionML = ENU = '&Advance',
                            FRA = '&Avance';
                Image = Prepayment;
                action("Overview by &Categories")
                {
                    CaptionML = ENU = 'Overview by &Categories',
                                FRA = 'Détail par catégorie';
                    Image = ViewDetails;
                    RunObject = Page 52182566;
                    RunPageLink = "Employee No. Filter" = FIELD("Employee No. Filter");
                }
                action("Overview by &Periods")
                {
                    CaptionML = ENU = 'Overview by &Periods',
                                FRA = 'Détail par péri&ode';
                    Image = TaxDetail;
                    RunObject = Page 52182565;
                }
            }
        }
    }


}

