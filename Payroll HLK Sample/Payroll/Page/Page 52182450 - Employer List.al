/// <summary>
/// Page Employer List (ID 52182450).
/// </summary>
page 52182450 "Employer List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Employer List',
                FRA = 'Liste des employeurs';
    Editable = true;
    PageType = List;
    SourceTable = Employer;

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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Employer)
            {
                CaptionML = ENU = '&Employer',
                            FRA = '&Employeur';
                Image = Employee;
                action("&Card")
                {
                    CaptionML = ENU = '&Card',
                                FRA = '&Fiche';
                    Image = EditLines;
                    RunObject = Page "Employer Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }


}

