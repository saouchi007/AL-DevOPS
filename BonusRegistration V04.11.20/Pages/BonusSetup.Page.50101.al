page 50101 BonusSetupPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = BonusSetupTable;
    Caption = 'Bonus Setup';
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                field("Bonus Nos."; "Bonus Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies number series that will be used for bonus numbers';

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    var

    begin

        Reset();

        if not Get() then begin
            Init();
            Insert();
        end;


    end;
}