/// <summary>
/// Page Training Entries (ID 52182451).
/// </summary>
page 52182451 "Training Entries"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Entries',
                FRA = 'Ecritures formation';
    DataCaptionFields = "No.";
    Editable = false;
    PageType = Card;
    SourceTable = "Training Line";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field(Initiative; Initiative)
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("No. Decision"; "No. Decision")
                {
                }
                field("Decision Date"; "Decision Date")
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field(Status; Status)
                {
                }
                field("Desired Starting Date"; "Desired Starting Date")
                {
                }
                field("Desired Ending Date"; "Desired Ending Date")
                {
                }
                field(Assessment; Assessment)
                {
                }
            }
        }
    }

    actions
    {
    }

}

