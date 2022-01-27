/// <summary>
/// Page Training Institution Card (ID 52182434).
/// </summary>
page 52182434 "Training Institution Card"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Institution Card',
                FRA = 'Fiche établissement de formation';
    PageType = Card;
    SourceTable = "Training Institution";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General',
                            FRA = 'Général';
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                    CaptionML = ENU = 'Post Code/City',
                                FRA = 'CP/Ville';
                }
                field(City; City)
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field(Contact; Contact)
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Institution Class Code"; "Institution Class Code")
                {
                }
                field("Institution Subclass Code"; "Institution Subclass Code")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field(Picture; Picture)
                {
                }
            }
            group(Communication)
            {
                CaptionML = ENU = 'Communication',
                            FRA = 'Communication';
                field("Phone No."; "Phone No.")
                {
                }
                field("Fax No."; "Fax No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field("Home Page"; "Home Page")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Institution)
            {
                CaptionML = ENU = '&Institution',
                            FRA = '&Etablissement';
                Image = Home;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST(14),
                                  "No." = FIELD("No.");
                }
                action("&Training Catalog")
                {
                    CaptionML = ENU = '&Training Catalog',
                                FRA = '&Formations';
                    Image = List;
                    RunObject = Page 52182438;
                    RunPageLink = "Training Institution No." = FIELD("No.");
                }
                action("&Statistiques")
                {
                    Caption = '&Statistiques';
                    Image = Statistics;
                    RunObject = Page 52182510;
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
            }
        }
    }



    var
        PictureExists: Boolean;
        Text001: TextConst ENU = 'Do you want to replace the existing picture?', FRA = 'Souhaitez-vous remplacer l''image existante ?';
        Text002: TextConst ENU = 'Do you want to delete the picture?', FRA = 'Souhaitez-vous supprimer l''image ?';

}

