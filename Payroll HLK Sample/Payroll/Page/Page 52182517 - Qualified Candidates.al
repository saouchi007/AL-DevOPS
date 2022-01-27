/// <summary>
/// Page Qualified Candidates (ID 51483).
/// </summary>
page 52182517 "Qualified Candidates"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Qualified Candidates',
                FRA = 'Compétences disponibles';
    DataCaptionFields = "Qualification Code";
    Editable = false;
    PageType = Card;
    SourceTable = "Candidate Qualification";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Candidate No."; "Candidate No.")
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
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(1),
                                  "No." = FIELD("Candidate No."),
                                  "Table Line No." = FIELD("Line No.");
                }

                action("Q&ualification Overview")
                {
                    CaptionML = ENU = 'Q&ualification Overview',
                                FRA = 'Détail qualification';
                    RunObject = Page 52182518;
                }
            }
        }
    }


}

