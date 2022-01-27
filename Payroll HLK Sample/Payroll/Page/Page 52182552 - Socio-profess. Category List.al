/// <summary>
/// Page Socio-profess. Category List (ID 52182552).
/// </summary>
page 52182552 "Socio-profess. Category List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Socio-profess. Category List',
                FRA = 'Liste des catégories socio-professionnelles';
    PageType = Card;
    SourceTable = "Socio-professional Category";

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
    }


}

