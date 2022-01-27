/// <summary>
/// Page Training Card (ID 52182440).
/// </summary>
page 52182440 "Training Card"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Card',
                FRA = 'Fiche de formation';
    PageType = Card;
    SourceTable = Training;

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

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Description)
                {
                }
                field(Aim; Aim)
                {
                }
                field(Type; Type)
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Domain Code"; "Domain Code")
                {
                }
                field("Domain Description"; "Domain Description")
                {
                }
                field("Subdomain Code"; "Subdomain Code")
                {
                }
                field("Subdomain Description"; "Subdomain Description")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
            }
            group(Skills)
            {
                CaptionML = ENU = 'Skills',
                            FRA = 'Compétences';
                field("Required Level"; "Required Level")
                {
                }
                field(Sanction; Sanction)
                {
                }
                field("Sanction Code"; "Sanction Code")
                {
                }
                field("Sanction Description"; "Sanction Description")
                {
                }
                field("Diploma Domain Code"; "Diploma Domain Code")
                {
                    Lookup = true;
                }
                field("Diploma Domain Description"; "Diploma Domain Description")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Training)
            {
                CaptionML = ENU = '&Training',
                            FRA = '&Formation';
                Image = GetStandardJournal;
                /*action("Co&mmentaires")
                {
                    Caption = 'Co&mmentaires';
                    Image = Comment;
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST(15), //count(15)
                                  "No." = FIELD("No.");
                }*/
                action("&Institutions")
                {
                    CaptionML = ENU = '&Institutions',
                                FRA = '&Etablissements';
                    Image = Home;
                    RunObject = Page 52182490;
                    RunPageLink = "Training No." = FIELD("No.");
                }
            }
        }
    }


}

