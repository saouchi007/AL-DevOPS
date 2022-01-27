/// <summary>
/// Page Training Request list (ID 52182429).
/// </summary>
page 52182429 "Training Request list"
{
    // version HALRHPAIE

    CaptionML = ENU = 'Training Request List',
                FRA = 'Liste des Demandes de formation';
    CardPageID = "Training Request";
    PageType = List;
    SourceTable = "Training Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("No."; "No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field(Status; Status)
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Training No."; "Training No.")
                {
                }
                field("Training Description"; "Training Description")
                {
                }
                field(Comment; Comment)
                {
                }
                field(Aim; Aim)
                {
                }
                field(Type; Type)
                {
                }
                field("Domain Description"; "Domain Description")
                {
                }
                field("Subdomain Description"; "Subdomain Description")
                {
                }
                field("Required Level"; "Required Level")
                {
                }
                field(Sanction; Sanction)
                {
                }
                field("Sanction Description"; "Sanction Description")
                {
                }
                field("No. of Employees"; "No. of Employees")
                {
                }
                field("Institution No."; "Institution No.")
                {
                }
                field("Session No."; "Session No.")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Starting Time"; "Starting Time")
                {
                }
                field("Ending Time"; "Ending Time")
                {
                }
                field(Cost; Cost)
                {
                }
                field("Sanction Code"; "Sanction Code")
                {
                }
                field("Domain Code"; "Domain Code")
                {
                }
                field("Diploma Domain Code"; "Diploma Domain Code")
                {
                }
                field("Diploma Domain Description"; "Diploma Domain Description")
                {
                }
                field("Frais d'hébergement"; "Frais d'hébergement")
                {
                }
                field("Frais de restauration"; "Frais de restauration")
                {
                }
                field("Frais de transport"; "Frais de transport")
                {
                }
                field("Autres Frais"; "Autres Frais")
                {
                }
                field("Coût Total"; "Coût Total")
                {
                }
                field("Frais personnel Horaire"; "Frais personnel Horaire")
                {
                }
                field(Durée; Durée)
                {
                }
                field("Frais Personnel Total"; "Frais Personnel Total")
                {
                }
                field("Lieu de la Formation"; "Lieu de la Formation")
                {
                }
                field("Nom Formateur"; "Nom Formateur")
                {
                }
                field("Update Costs"; "Update Costs")
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
                Caption = '&Fiche';
                Image = EditList;
                action(Fiche)
                {
                    Caption = 'Fiche';
                    Image = EditLines;

                    trigger OnAction();
                    begin
                        CASE "Document Type" OF

                            "Document Type"::Request:
                                PAGE.RUN(PAGE::"Training Request", Rec);
                            ELSE
                                PAGE.RUN(PAGE::"Training Registration", Rec);

                        END;
                    end;
                }
            }
        }
    }


}

