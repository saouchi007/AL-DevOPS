pageextension 80103 "MICA User Task List" extends "User Task List" //MyTargetPageId
{
    layout
    {

    }

    actions
    {
        addafter("Go To Task Item")
        {
            action("MICA Go To Task Item Spe")
            {
                ApplicationArea = All;
                Caption = 'Go To Task Item';
                Image = Navigate;
                trigger OnAction()
                var
                    MICACustRqst: Codeunit "MICA Customer Request";
                begin
                    MICACustRqst.GoToTaskItem(Rec);
                end;
            }
        }
        modify("Go To Task Item")
        {
            Visible = false;
        }
    }
}