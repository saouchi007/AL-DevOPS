/// <summary>
/// Page Candidate Qualifications (ID 52182480).
/// </summary>
page 52182480 "Candidate Qualifications"
{
    // version HALRHPAIE

    AutoSplitKey = true;
    CaptionML = ENU = 'Candidate Qualifications',
                FRA = 'Qualifications candidat';
    DataCaptionFields = "Candidate No.";
    PageType = Card;
    SourceTable = "Candidate Qualification";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Qualification Code"; "Qualification Code")
                {
                }
                field("Candidate No."; "Candidate No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Nom Candidat"; "Nom Candidat")
                {
                }
                field("Prénom Candidat"; "Prénom Candidat")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field(Description; Description)
                {
                }
                field("Expiration Date"; "Expiration Date")
                {
                    Visible = false;
                }
                field("Institution/Company"; "Institution/Company")
                {
                }
                field("Course Grade"; "Course Grade")
                {
                    Visible = false;
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
            group("Q&ualification")
            {
                CaptionML = ENU = 'Q&ualification',
                            FRA = '&Qualification';
                Image = QualificationOverview;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1), //Const(13)
                                  "No." = FIELD("Candidate No."),
                                  "Table Line No." = FIELD("Line No.");
                }
                separator("")
                {
                }
                action("Q&ualification Overview")
                {
                    CaptionML = ENU = 'Q&ualification Overview',
                                FRA = 'Détail qualification';
                    Image = QualificationOverview;
                    RunObject = Page 52182518;
                }
            }
        }
    }


}

