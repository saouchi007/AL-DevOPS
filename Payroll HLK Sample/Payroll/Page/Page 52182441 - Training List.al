/// <summary>
/// Page Training List (ID 52182441).
/// </summary>
page 52182441 "Training List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training List',
                FRA = 'Liste des formations';
    CardPageID = "Training Card";
    Editable = false;
    PageType = List;
    SourceTable = Training;

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
                field("Domain Code"; "Domain Code")
                {
                }
                field("Domain Description"; "Domain Description")
                {
                }
                field("Subdomain Code"; "Subdomain Code")
                {
                }
                field("Subdomain Description"; "Subdomain Description")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Formation)
            {
                CaptionML = ENU = '&Training',
                            FRA = '&Formation';
                Image = GetStandardJournal;
                action("&Card")
                {
                    CaptionML = ENU = '&Card',
                                FRA = '&Fiche';
                    Image = EditLines;
                    RunObject = Page 52182440;
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F5';
                }
                action("&Requests")
                {
                    CaptionML = ENU = '&Requests',
                                FRA = '&Demandes';
                    Image = SendApprovalRequest;
                    RunObject = Page 52182509;
                    RunPageLink = "Training No." = FIELD("No.");
                }
            }
        }
    }


}

