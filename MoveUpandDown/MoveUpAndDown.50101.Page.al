pageextension 50101 MoveUpandDown extends "Sales Order Subform"
{
    layout
    {
        modify("Line No.")
        {
            Visible = true;
        }
        moveafter(Type; "Line No.")

        addafter(Type)
        {
            field(LinePosition; Rec.LinePosition)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }


    actions
    {
        addbefore("F&unctions")
        {
            action(MoveUp)
            {
                Caption = 'Move Up';
                ApplicationArea = all;
                Image = MoveUp;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Move current line up';

                trigger OnAction()
                begin
                    MoveSalesLines(-1);
                end;
            }
            action(MoveDown)
            {
                Caption = 'Move Down';
                ApplicationArea = all;
                Image = MoveDown;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Move current line down';

                trigger OnAction()
                begin
                    MoveSalesLines(1);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey(LinePosition);
        Rec.Ascending(true);
    end;

    local procedure MoveSalesLines(MoveBy: Integer)
    var
        salesLine: Record "Sales Line";
    begin
        salesLine.Reset();
        salesLine.SetRange("Document Type", Rec."Document Type");
        salesLine.SetRange("Document Type", Rec."Document Type");
        salesLine.SetRange(LinePosition, Rec.LinePosition + MoveBy);
        if salesLine.FindFirst() then begin
            salesLine.LinePosition -= MoveBy;
            salesLine.Modify();
            Rec.LinePosition += MoveBy;
            Rec.Modify();
        end;
    end;
}