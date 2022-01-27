/// <summary>
/// Page Decision Template SubPage (ID 51471).
/// </summary>
page 52182506 "Decision Template SubPage"
{
    // version HALRHPAIE.6.1.01

    AutoSplitKey = true;
    CaptionML = ENU = 'Decision Template SubPage',
                FRA = 'Sous-formulaire modèle de décisions';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Employee Medical shots";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field(Comptage; Comptage)
                {
                }
                field("Examination Date"; "Examination Date")
                {
                }
            }
        }
    }

    actions
    {
    }


}

