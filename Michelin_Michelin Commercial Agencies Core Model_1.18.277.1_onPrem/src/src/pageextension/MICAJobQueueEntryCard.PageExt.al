pageextension 80963 "MICA Job Queue Entry Card" extends "Job Queue Entry Card"
{
    actions
    {
        addafter(Restart)
        {
            action("MICA MICARunManually")
            {
                ApplicationArea = all;
                Image = ExecuteBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortcutKey = F11;
                caption = 'Run job manually';

                trigger OnAction();
                var
                    ConfirmMessageLbl: label 'Do you want to run this process ?';
                begin
                    if Confirm(ConfirmMessageLbl) then
                        Codeunit.Run(Codeunit::"Job Queue Start Codeunit", Rec);
                end;
            }
        }
    }
}