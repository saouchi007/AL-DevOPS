pageextension 82201 "MICA Item Reclass. Journal" extends "Item Reclass. Journal"
{
    layout
    {
        addafter("Applies-to Entry")
        {
            field("MICA Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Get Bin Content")
        {
            action("MICA Move Location Full Stock")
            {
                ApplicationArea = All;
                Caption = 'Move Location Full Stock';
                Image = MovementWorksheet;
                Ellipsis = true;
                ToolTip = 'Move Location stock from one location to another.';

                trigger OnAction()
                var
                    MoveLocationFullStock: Report "MICA Move Location Full Stock";
                begin
                    MoveLocationFullStock.SetItemReclassJournal(Rec);
                    MoveLocationFullStock.Run();
                end;
            }
        }
    }
}