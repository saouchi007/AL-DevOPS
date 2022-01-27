/// <summary>
/// Page Candidate Relatives (ID 52182481).
/// </summary>
page 52182481 "Candidate Relatives"
{
    // version HALRHPAIE.6.1.01

    AutoSplitKey = true;
    CaptionML = ENU = 'Candidate Relatives',
                FRA = 'Liens de parenté candidat';
    DataCaptionFields = "Candidate No.";
    PageType = Card;
    SourceTable = "Candidate Relative";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Relative Code"; "Relative Code")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                    Visible = false;
                }
                field(Sex; Sex)
                {
                }
                field("Birth Date"; "Birth Date")
                {
                }
                field("Birthplace Post Code"; "Birthplace Post Code")
                {
                }
                field("Birthplace City"; "Birthplace City")
                {
                }
                field("Phone No."; "Phone No.")
                {
                    Visible = false;
                }
                field("Relative's Candidate No."; "Relative's Candidate No.")
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
            group("&Relative")
            {
                CaptionML = ENU = '&Relative',
                            FRA = '&Parenté';
                Image = Relatives;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(2), //Const(12)
                                  "No." = FIELD("Candidate No."),
                                  "Table Line No." = FIELD("Line No.");
                }
            }
        }
    }


}

