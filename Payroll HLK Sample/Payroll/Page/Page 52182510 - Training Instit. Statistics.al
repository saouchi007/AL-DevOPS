/// <summary>
/// Page Training Instit. Statistics (ID 52182510).
/// </summary>
page 52182510 "Training Instit. Statistics"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Taining Institution Statistics',
                FRA = 'Statistiques établissement de formation';
    Editable = false;
    PageType = Card;
    SourceTable = "Training Institution";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General',
                            FRA = 'Général';
                field("No. of Trainings"; "No. of Trainings")
                {
                }
            }
        }
    }

    actions
    {
    }



    var
        AvgCostPerResp: Decimal;
        AvgDurationPerResp: Decimal;

}

