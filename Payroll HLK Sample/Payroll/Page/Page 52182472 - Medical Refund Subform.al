/// <summary>
/// Page Medical Refund Subform (ID 52182472).
/// </summary>
page 52182472 "Medical Refund Subform"
{
    // version HALRHPAIE.6.1.01

    AutoSplitKey = true;
    CaptionML = ENU = 'Medical Refund Subform',
                FRA = 'Sous-form. remboursement frais médicaux';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Medical Refund Line";
    SourceTableView = WHERE("Document Type" = CONST(Blank));

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
                field("Social Security No."; "Social Security No.")
                {
                }
                field("Collection Date"; "Collection Date")
                {
                }
                field(Amount; Amount)
                {
                }
                field(Status; Status)
                {
                }
                field("Refund Date"; "Refund Date")
                {
                }
                field("Refund Amount"; "Refund Amount")
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
                action(BtnAxes)
                {
                    CaptionML = ENU = '&Dimensions',
                                FRA = 'A&xes analytiques';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        //This functionality was copied from page #51436. Unsupported part was commented. Please check it.
                        /*CurrPage.ReimbursLines.FORM.*/
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

    /*procedure ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;*/
}

