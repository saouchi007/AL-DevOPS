/// <summary>
/// Page Open Post List (ID 52182477).
/// </summary>
page 52182477 "Open Post List" // Poste ouvert
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Open Post List',
                FRA = 'Liste des postes ouverts';
    CardPageID = "Open Post Card";
    Editable = true;
    PageType = List;
    SourceTable = "Open Post";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No."; "No.")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field("Post Description"; "Post Description")
                {
                }
                field(Reference; Reference)
                {
                }
                field("Recruitment Mode"; "Recruitment Mode")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Structure Code"; "Structure Code")
                {
                }
                field(Status; Status)
                {
                }
                field("Structure Description"; "Structure Description")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Open Post")
            {
                CaptionML = ENU = '&Open Post',
                            FRA = '&Poste ouvert';
                Image = Post;
                action("&Fiche")
                {
                    Caption = '&Fiche';
                    Image = Document;
                    RunObject = Page 52182476;
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }


}

