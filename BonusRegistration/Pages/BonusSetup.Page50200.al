page 50200 "BonusSetup"
{
    Caption = 'Bonus Page Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = BonusSetup;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
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
            action(ActionMan)
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
            Reset();
        end;


    end;
}