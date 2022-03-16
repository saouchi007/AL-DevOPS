/// <summary>
/// PageExtension ISA_CustomerListRank (ID 50157).
/// </summary>
pageextension 50158 ISA_CustomerListRank extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field(Rank; Rec.Rank)
            {
                Caption = 'Rank';
                ApplicationArea = All;
                StyleExpr = StyleExprTxt;
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