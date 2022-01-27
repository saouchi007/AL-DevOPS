/// <summary>
/// Page Candidate Diplomas (ID 52182482).
/// </summary>
page 52182482 "Candidate Diplomas"
{
    // version HALRHPAIE

    CaptionML = ENU = 'candidate Diplomas',
                FRA = 'Diplômes candidat';
    Editable = true;
    PageType = Card;
    SourceTable = "Candidate Diploma";

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
                field(Nom; Nom)
                {
                }
                field(Prénom; Prénom)
                {
                }
                field("Diploma Domain Code"; "Diploma Domain Code")
                {
                }
                field("Diploma Domain Description"; "Diploma Domain Description")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("Institution/Company"; "Institution/Company")
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
                    RunObject = Page 52182519;
                    Image = Card;
                }
            }
        }
    }


}

