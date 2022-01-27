/// <summary>
/// Page Diploma Domain List (ID 51396).
/// </summary>
page 51396 "Diploma Domain List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Diploma Domain List',
                FRA = 'Liste des domaines de diplômes';
    PageType = Card;
    SourceTable = "Diploma Domain";

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

