/// <summary>
/// Page Training Institution List (ID 52182435).
/// </summary>
page 52182435 "Training Institution List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Institution List',
                FRA = 'Liste des établissements de formation';
    CardPageID = "Training Institution Card";
    Editable = true;
    PageType = List;
    SourceTable = "Training Institution";

    layout
    {
        area(content)
        {
            repeater(new)
            {
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
                field(City; City)
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field(Contact; Contact)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Fax No."; "Fax No.")
                {
                }
                field("Institution Class Code"; "Institution Class Code")
                {
                }
                field("Institution Subclass Code"; "Institution Subclass Code")
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
                action("&List")
                {
                    CaptionML = ENU = '&List',
                                FRA = '&Lister';
                    Image = List;
                    RunObject = Page 52182435;
                    ShortCutKey = 'Shift+F5';
                }
                /*action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST(14), //Count(14)
                                  "No." = FIELD("No.");
                }*/
                action("&Training Catalog")
                {
                    CaptionML = ENU = '&Training Catalog',
                                FRA = '&Catalogue de formations';
                    Image = List;
                    RunObject = Page 52182438;
                    RunPageLink = "Training Institution No." = FIELD("No.");
                }
            }
        }
    }


}

