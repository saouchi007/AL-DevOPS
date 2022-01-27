/// <summary>
/// Page Payroll Template List (ID 52182554).
/// </summary>
page 52182554 "Payroll Template List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Template List',
                FRA = 'Liste des modèles de paie';
    Editable = true;
    PageType = Card;
    SourceTable = "Payroll Template Header";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Comment; Comment)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Template")
            {
                CaptionML = ENU = '&Template',
                            FRA = '&Modèle';
                Image = Template;

                action("&Card")
                {
                    CaptionML = ENU = '&Card',
                                FRA = '&Fiche';
                    Image = EditLines;
                    RunObject = Page 52182555;
                    RunPageLink = "No." = FIELD("No.");
                }
            }
        }
    }


}

