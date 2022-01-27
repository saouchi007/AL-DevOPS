/// <summary>
/// Page Post List (ID 51404).
/// </summary>
page 52182439 "Post List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Post List',
                FRA = 'Liste des postes';
    Editable = true;
    PageType = Card;
    SourceTable = Post;

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
                field(Category; Category)
                {
                }
                field("No. of Posts"; "No. of Posts")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Poste)
            {
                CaptionML = ENU = '&Post',
                            FRA = '&Poste';
                Image = Job;
                action("&Card")
                {
                    CaptionML = ENU = '&Card',
                                FRA = '&Fiche';
                    Image = EditLines;
                    RunObject = Page 52182511;
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F5';
                }

                action("Required &Qualifications")
                {
                    CaptionML = ENU = 'Required &Qualifications',
                                FRA = '&Qualifications requises';
                    Image = QualificationOverview;
                    RunObject = Page 52182469;
                    RunPageLink = "Post Code" = FIELD("No.");
                }
                action("Required &Diplomas")
                {
                    CaptionML = ENU = 'Required &Diplomas',
                                FRA = '&Diplômes requis';
                    Image = Card;
                    RunObject = Page 52182470;
                    RunPageLink = "Post Code" = FIELD("No.");
                }

                action(Duties)
                {
                    CaptionML = ENU = 'Duties',
                                FRA = '&Missions';
                    Image = MapDimensions;
                    RunObject = Page 52182443;
                    RunPageLink = "Post Code" = FIELD("No.");
                }
            }
        }
    }


}

