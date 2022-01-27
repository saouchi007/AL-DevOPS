/// <summary>
/// Page Refunds List (ID 52182473).
/// </summary>
Page 52182473 "Refunds List" // Remboursement des frais medicaux 
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Refunds List',
                FRA = 'Liste des remboursements';
    CardPageID = "Medical Refund";
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = List;
    SourceTable = "Medical Refund Header";

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
                field("Collection Date"; "Collection Date")
                {
                }
                field("Submittion Date"; "Submittion Date")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Refund Date"; "Refund Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                CaptionML = ENU = '&Line',
                            FRA = '&Ligne';
                Image = Line;
                action(Card)
                {
                    CaptionML = ENU = 'Card',
                                FRA = 'Fiche';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F5';

                    trigger OnAction();
                    begin
                        CASE "Document Type" OF
                            "Document Type"::Blank:
                                PAGE.RUN(PAGE::"Medical Refund", Rec);
                        END;
                    end;
                }
            }
        }
    }




}

