page 52182511 "Post Card"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Post Card',
                FRA = 'Fiche poste';
    PageType = Card;
    SourceTable = Post;

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
                field(Description; Description)
                {
                }
                field(Category; Category)
                {
                }
                field(Blocked; Blocked)
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
            group(Post)
            {
                CaptionML = ENU = '&Poste',
                            FRA = '&Poste';
                Image = Post;
                action("Co&mmentaires")
                {
                    Caption = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST(16),
                                  "No." = FIELD("No.");
                }

                action("Required &Qualifications")
                {
                    CaptionML = ENU = 'Required &Qualifications',
                                FRA = '&Qualifications requises';
                    Image = QualificationOverview;
                    RunObject = Page "Post Required Qualifications";
                    RunPageLink = "Post Code" = FIELD("No.");
                }
                action("Required &Diplomas")
                {
                    CaptionML = ENU = 'Required &Diplomas',
                                FRA = '&Diplômes requis';
                    Image = Card;
                    RunObject = Page "Post Required Diplomas";
                    RunPageLink = "Post Code" = FIELD("No.");
                }
                action("&Employees")
                {
                    CaptionML = ENU = '&Employees',
                                FRA = '&Salariés';
                    Image = Employee;
                    RunObject = Page "Employee Assignment List";
                    RunPageLink = "Post Code" = FIELD("No.");
                }

                action("&Duties")
                {
                    CaptionML = ENU = '&Duties',
                                FRA = '&Missions';
                    Image = MapDimensions;
                    RunObject = Page "Post Duties";
                    RunPageLink = "Post Code" = FIELD("No.");
                }
            }
        }
    }


}

