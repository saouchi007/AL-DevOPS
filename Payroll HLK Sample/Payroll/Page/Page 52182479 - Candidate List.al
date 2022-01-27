/// <summary>
/// Page Candidate List (ID 51444).
/// </summary>
page 52182479 "Candidate List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate List',
                FRA = 'Liste des candidats';
    CardPageID = "Candidate Card";
    Editable = true;
    PageType = List;
    SourceTable = Candidate;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No."; "No.")
                {
                }
                field(FullName; FullName)
                {
                    CaptionML = ENU = 'Full Name',
                                FRA = 'Nom complet';
                }
                field("First Name"; "First Name")
                {
                    Visible = false;
                }
                field("Middle Name"; "Middle Name")
                {
                    Visible = false;
                }
                field("Last Name"; "Last Name")
                {
                    Visible = false;
                }
                field("Post Code"; "Post Code")
                {
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    Visible = false;
                }
                field("Phone No."; "Phone No.")
                {
                    Visible = false;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    Visible = false;
                }
                field("E-Mail"; "E-Mail")
                {
                    Visible = false;
                }
                field("Search Name"; "Search Name")
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
            group("&Candidate")
            {
                CaptionML = ENU = '&Candidate',
                            FRA = '&Candidat';
                Image = ExportSalesPerson;
                action("&Card")
                {
                    CaptionML = ENU = '&Card',
                                FRA = '&Fiche';
                    Image = EditLines;
                    RunObject = Page "Candidate Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F5';
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), //Const(12)
                                  "No." = FIELD("No.");
                }
                action("&Picture")
                {
                    CaptionML = ENU = '&Picture',
                                FRA = '&Image';
                    RunObject = Page 52182483;
                    RunPageLink = "No." = FIELD("No.");
                }
                action("Q&ualifications")
                {
                    CaptionML = ENU = 'Q&ualifications',
                                FRA = '&Qualifications';
                    RunObject = Page 52182480;
                    RunPageLink = "Candidate No." = FIELD("No.");
                }
            }
        }
    }


}

