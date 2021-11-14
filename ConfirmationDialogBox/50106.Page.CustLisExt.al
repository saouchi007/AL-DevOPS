pageextension 50106 ConfirmDialog extends "Customer List"
{
    actions
    {
        addafter("Request Approval")
        {
            action("Confirm Dialog")
            {
                Caption = 'Confirm Dialog';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                    if Confirm('Do you want to view the name of customer n° : %1', true, Rec."No.") then
                        Message(Rec.Name)
                    else
                        Message('You have declined the name');
                end;
            }
        }
    }
}