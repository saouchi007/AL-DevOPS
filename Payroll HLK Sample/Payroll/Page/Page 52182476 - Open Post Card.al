/// <summary>
/// Page Open Post Card (ID 51441).
/// </summary>
page 52182476 "Open Post Card"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Open Post Card',
                FRA = 'Fiche de poste ouvert';
    PageType = Card;
    SourceTable = "Open Post";

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                field("No."; "No.")
                {

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Post Code"; "Post Code")
                {
                }
                field("Post Description"; "Post Description")
                {
                }
                field("Structure Code"; "Structure Code")
                {
                }
                field("Structure Description"; "Structure Description")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Status; Status)
                {
                }
                field(Reference; Reference)
                {
                }
                field("Recruitment Mode"; "Recruitment Mode")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Post)
            {
                CaptionML = ENU = '&Open Post',
                            FRA = '&Poste ouvert';

                Image = Post;
                action("Co&mmentaires")
                {
                    Caption = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST(17),
                                  "No." = FIELD("No.");
                }

                action("&Candidatures")
                {
                    Caption = '&Candidatures';
                    image = PersonInCharge;
                    RunObject = Page 52182485;
                    RunPageLink = "Open post No." = FIELD("No.");
                }
            }
        }
    }


}

