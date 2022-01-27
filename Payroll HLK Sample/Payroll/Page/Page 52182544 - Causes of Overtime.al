/// <summary>
/// Page Causes of Overtime (ID 52182544).
/// </summary>
page 52182544 "Causes of Overtime"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Causes of Overtime',
                FRA = 'Motifs d''heures supp.';
    PageType = Card;
    SourceTable = "Cause of Overtime";

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
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Total Overtime (Base)"; "Total Overtime (Base)")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Overtime")
            {
                CaptionML = ENU = '&Overtime',
                            FRA = '&Heure supp.';
                Image = ServiceHours;
                action("Overview by &Categories")
                {
                    CaptionML = ENU = 'Overview by &Categories',
                                FRA = 'Détail par catégorie';
                    Image = ViewDetails;
                    RunObject = Page 52182567;
                    RunPageLink = "Employee No. Filter" = FIELD("Employee No. Filter");
                }
                action("Overview by &Periods")
                {
                    CaptionML = ENU = 'Overview by &Periods',
                                FRA = 'Détail par péri&ode';
                    Image = TaxDetail;
                    RunObject = Page 52182568;
                }
            }
        }
    }


}

