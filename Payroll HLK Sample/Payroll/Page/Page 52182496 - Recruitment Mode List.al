/// <summary>
/// Page Recruitment Mode List (ID 52182496).
/// </summary>
page 52182496 "Recruitment Mode List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Recruitment Mode List',
                FRA = 'Liste des modes de recrutement';
    PageType = Card;
    SourceTable = "Recruitment Mode";

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
                field("Availability Nbre of Days"; "Availability Nbre of Days")
                {
                }
            }
        }
    }

    actions
    {
    }


}

