/// <summary>
/// Page Candidature List (ID 52182485).
/// </summary>
page 52182485 "Candidature List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidature List',
                FRA = 'Liste des candidatures';
    CardPageID = "Candidature Card";
    Editable = true;
    PageType = List;
    SourceTable = Candidature;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No."; "No.")
                {
                }
                field(Type; Type)
                {
                }
                field("Candidate No."; "Candidate No.")
                {
                }
                field("Open post No."; "Open post No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Open Post Description"; "Open Post Description")
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
            group("&Candidature")
            {
                CaptionML = ENU = '&Candidature',
                            FRA = '&Candidature';
                Image = PersonInCharge;
                action("&Card")
                {
                    CaptionML = ENU = '&Card',
                                FRA = '&Fiche';
                    Image = EditLines;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F5';
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(0), // Const(15)
                                  "No." = FIELD("No.");
                }
                action("Questionnaire Candidat")
                {
                    Image = Questionaire;
                    RunObject = Page 52182488;
                }
            }
        }
    }


}

