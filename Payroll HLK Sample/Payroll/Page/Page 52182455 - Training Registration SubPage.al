/// <summary>
/// Page Training Registration SubPage (ID 52182455).
/// </summary>
page 52182455 "Training Registration SubPage"
{
    // version HALRHPAIE.6.1.01

    AutoSplitKey = true;
    CaptionML = ENU = 'Training Registration SubPage',
                FRA = 'Sous-form. inscription formation';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Training Line";
    SourceTableView = WHERE("Document Type" = CONST(Registration));

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field(Selection; Selection)
                {
                }
                field(Status; Status)
                {
                }
                field(Processed; Processed)
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Initiative; Initiative)
                {
                }
                field("No. Decision"; "No. Decision")
                {
                }
                field("Decision Date"; "Decision Date")
                {
                }
                field(Assessment; Assessment)
                {
                }
                field("Desired Starting Date"; "Desired Starting Date")
                {
                    Visible = false;
                }
                field("Desired Ending Date"; "Desired Ending Date")
                {
                    Visible = false;
                }
                field("Cause of Training Cancellation"; "Cause of Training Cancellation")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("&Ligne")
            {
                Caption = '&Ligne';
                Image = Line;
                action(BtnAxes)
                {
                    Caption = 'A&xes analytiques';
                    Image = Dimensions;

                    trigger OnAction();
                    begin
                        //This functionality was copied from page #51419. Unsupported part was commented. Please check it.
                        /*CurrPage.TrainingLines.FORM.*/
                        _ShowDimensions;

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Type := xRec.Type;
        CLEAR(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];

    /// <summary>
    /// _ShowDimensions.
    /// </summary>
    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;


}

