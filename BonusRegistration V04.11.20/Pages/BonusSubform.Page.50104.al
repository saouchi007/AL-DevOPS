page 50104 BonusSubformPage
{
    PageType = ListPart;
    SourceTable = BonusLineTable;
    Caption = 'Lines';
    DeleteAllowed = true;
    InsertAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Type; Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies type of bonus assigned';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies item number for which bonus is assigned';
                }
                field("Bonus Perc."; "Bonus Perc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies bonus percent';
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

                trigger OnAction();
                begin

                end;
            }
        }
    }
}