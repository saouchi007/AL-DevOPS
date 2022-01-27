/// <summary>
/// Page Overtime Categories (ID 52182558).
/// </summary>
page 52182558 "Overtime Categories"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Overtime Categories',
                FRA = 'Catégories heures supp.';
    PageType = Card;
    SourceTable = "Overtime Category";

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
                field("Item Code"; "Item Code")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Majoration %"; "Majoration %")
                {
                }
            }
        }
    }

    actions
    {
    }


}

