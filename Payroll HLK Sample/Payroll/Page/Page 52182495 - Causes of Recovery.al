/// <summary>
/// Page Causes of Recovery (ID 52182495).
/// </summary>
page 52182495 "Causes of Recovery"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Causes of Recovery',
                FRA = 'Motifs de récupération';
    PageType = Card;
    SourceTable = "Cause of Recovery";

    layout
    {
        area(content)
        {
            repeater(NEW)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {

                }
                field("Total Recovery (Base)"; "Total Recovery (Base)")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Recovery")
            {
                CaptionML = ENU = '&Recovery',
                            FRA = '&Récupération';
                Image = ResourcePrice;
                action("Overview by &Categories")
                {
                    CaptionML = ENU = 'Overview by &Categories',
                                FRA = 'Détail par catégorie';
                    Image = FiledOverview;
                    RunObject = Page 52182521;
                    RunPageLink = "Employee No. Filter" = FIELD("Employee No. Filter");
                }
                action("Overview by &Periods")
                {
                    CaptionML = ENU = 'Overview by &Periods',
                                FRA = 'Détail par péri&ode';
                    Image = Period;
                    RunObject = Page 52182522;
                }
            }
        }
    }


}

