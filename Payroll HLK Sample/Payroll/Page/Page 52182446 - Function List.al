/// <summary>
/// Page Function List (ID 52182446).
/// </summary>
page 52182446 "Function List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Function List',
                FRA = 'Liste des fonctions';
    PageType = Card;
    SourceTable = Function;

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
        area(navigation)
        {
            group("&Function")
            {
                CaptionML = ENU = '&Function',
                            FRA = '&Fonction';
                action("&Employees")
                {
                    CaptionML = ENU = '&Employees',
                                FRA = '&Salariés';
                    RunObject = Page 52182444;
                    RunPageLink = "Function Code" = FIELD("Code");
                }
            }
        }
    }


}

