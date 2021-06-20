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
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey(LinePosition);
        Rec.Ascending(true);
    end;
}