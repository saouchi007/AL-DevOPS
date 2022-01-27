/// <summary>
/// Page Training Request Subform (ID 52182453).
/// </summary>
page 52182453 "Training Request Subform"
{
    // version HALRHPAIE.6.1.01

    AutoSplitKey = true;
    CaptionML = ENU = 'Training Request Subform',
                FRA = 'Sous-form. demande formation';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Training Line";
    SourceTableView = WHERE("Document Type" = CONST(Request));

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
                field("Desired Starting Date"; "Desired Starting Date")
                {
                }
                field("Desired Ending Date"; "Desired Ending Date")
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
            group("&Line")
            {
                CaptionML = ENU = '&Line',
                            FRA = '&Ligne';
                Image = Line;
                action(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                FRA = 'A&xes analytiques';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        //This functionality was copied from page #51417. Unsupported part was commented. Please check it.
                        /*CurrPage.ReimbursementLines.FORM.*/
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

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;


}

