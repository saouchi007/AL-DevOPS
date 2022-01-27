/// <summary>
/// Page Employee Diplomas (ID 51398).
/// </summary>
page 52182433 "Employee Diplomas"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employee Diplomas',
                FRA = 'Diplômes salarié';
    Editable = true;
    PageType = Card;
    SourceTable = "Employee Diploma";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Diploma Code"; "Diploma Code")
                {
                }
                field("Diploma Description"; "Diploma Description")
                {
                }
                field("Diploma Domain Code"; "Diploma Domain Code")
                {
                }
                field("Diploma Domain Description"; "Diploma Domain Description")
                {
                }
                field("Obtention Date"; "Obtention Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Diploma")
            {
                CaptionML = ENU = '&Diploma',
                            FRA = '&Diplôme';
                Image = Card;
                action("&Diploma Overview")
                {
                    CaptionML = ENU = '&Diploma Overview',
                                FRA = 'Détail Diplômes';
                    RunObject = Page 52182498;
                    Image = Card;
                }
            }
        }
    }


}

