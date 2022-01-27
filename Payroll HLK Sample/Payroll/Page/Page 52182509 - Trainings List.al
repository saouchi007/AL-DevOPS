/// <summary>
/// Page Trainings List (ID 52182509).
/// </summary>
page 52182509 "Trainings List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training List',
                FRA = 'Liste des formations';
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = Card;
    SourceTable = "Training Header";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No."; "No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Training No."; "Training No.")
                {
                }
                field("Training Description"; "Training Description")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Institution No."; "Institution No.")
                {
                }
                field("Session No."; "Session No.")
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
                            "Document Type"::Request:
                                PAGE.RUN(PAGE::"Training Request", Rec);
                            "Document Type"::Registration:
                                PAGE.RUN(PAGE::"Training Registration", Rec);
                        END;
                    end;
                }
            }
        }
    }


}

