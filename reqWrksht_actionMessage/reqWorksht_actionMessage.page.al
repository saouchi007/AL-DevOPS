pageextension 50100 ActionMessage extends "Req. Worksheet"
{

    actions
    {
        addafter(CalculatePlan)
        {
            action(uncheckActionMessage)
            {
                Promoted = true;
                Caption = 'Uncheck action message';
                ToolTip = 'This would uncheck Accept Action Message of the lines.';
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = CancelFALedgerEntries;
                trigger OnAction()
                begin
                    if Rec.FindFirst() then begin
                        repeat
                            Rec."Accept Action Message" := false;
                            Rec.Modify();
                        until Rec.Next() = 0;
                    end else
                        Error('Oh dear, this worksheet seems empty !');
                end;
            }
            action(checkActionMessage)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Check Action Message';
                ToolTip = 'This would check Accept Action Message of the lines.';
                Image = Action;

                trigger OnAction()
                begin
                    if Rec.FindFirst() then begin
                        repeat
                            Rec."Accept Action Message" := true;
                            Rec.Modify();
                        until Rec.Next() = 0;
                    end else
                        Error('Oh dear, this worksheet seems empty !');
                end;
            }
        }
    }
}