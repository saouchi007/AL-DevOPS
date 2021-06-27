pageextension 80761 "MICA Job Queue Entries" extends "Job Queue Entries" //MyTargetPageId
{
    layout
    {

    }

    actions
    {
        addlast("Job &Queue")
        {
            action("MICA RunManually")
            {
                ApplicationArea = All;
                Image = ExecuteBatch;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ActionRunManVisible;
                ShortcutKey = F11;
                caption = 'Run job manually';

                trigger OnAction();
                var
                    ConfirmMessageLbl: label 'Do you wan to run this process ?';
                begin
                    if Confirm(ConfirmMessageLbl) then
                        Codeunit.Run(Codeunit::"Job Queue Start Codeunit", Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId()) then
            ActionRunManVisible := UserSetup."MICA Allow Run JobQueue";
    end;

    var
        UserSetup: Record "User Setup";
        ActionRunManVisible: Boolean;
}