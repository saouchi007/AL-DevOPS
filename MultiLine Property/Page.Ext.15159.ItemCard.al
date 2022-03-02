/// <summary>
/// PageExtension ItemCard_Ext (ID 15159) extends Record MyTargetPage.
/// </summary>
pageextension 50159 ItemCard_Ext extends "Item Card"
{
    layout
    {
        addafter("Purchasing Code")
        {
            field(InstrAlpha; Rec.InstrAlpha)
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field(InstrBeta; Rec.InstrBeta)
            {
                ApplicationArea = All;
                MultiLine = true;
                Editable = false;
            }
        }
    }

    var
        Alpha: Label 'This is init line\';
        Beta: Label 'This is Beta line\';
        Charlie: Label 'This is Charlie line\';
        Delta: Label 'This is Delta line';

    trigger OnOpenPage()
    begin
        Rec.InstrBeta := Alpha + Beta + Charlie + Delta;
        Rec.Modify();
    end;
}