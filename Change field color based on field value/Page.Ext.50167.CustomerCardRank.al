/// <summary>
/// PageExtension ISA_CustomerCardRank (ID 50159) extends Record Customer Card.
/// </summary>
pageextension 50167 ISA_CustomerCardRank extends "Customer Card"
{
    layout
    {
        addafter("Service Zone Code")
        {
            field(Rank; Rec.Rank)
            {
                Caption = 'Rank';
                ApplicationArea = All;
                StyleExpr = StyleExprTxt;

                trigger OnValidate()
                begin
                    StyleExprTxt := ChangeColour.ChangeCustomeRankColour(Rec);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        StyleExprTxt := ChangeColour.ChangeCustomeRankColour(Rec);
    end;

    var
        StyleExprTxt: Text[50];
        ChangeColour: Codeunit ChangeColour;
}