pageextension 80860 "MICA General Ledger Setup" extends "General Ledger Setup" //MyTargetPageId
{
    layout
    {
        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Special Characters"; Rec."MICA Special Characters")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("MICA Special Char. Length"; Rec."MICA Special Char. Length")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = StyleUnfavorable;
                }
                field("MICA Translated Characters";
                Rec."MICA Translated Characters")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("MICA Translated Char. Length"; Rec."MICA Translated Char. Length")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = StyleUnfavorable;
                }
                field("MICA Field Security Enable"; Rec."MICA Field Security Enable")
                {
                    ApplicationArea = All;
                }
                field("MICA Madatory Field Enable"; Rec."MICA Mandatory Field Enable")
                {
                    ApplicationArea = All;
                }
                field("MICA LB Dimension code"; Rec."MICA LB Dimension code")
                {
                    ApplicationArea = All;
                }
                field("MICA Last DateTime SO Archive"; Rec."MICA Last DateTime SO Archive")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        if Rec."MICA Special Char. Length" <> Rec."MICA Translated Char. Length" then
            StyleUnfavorable := true
        else
            StyleUnfavorable := false;
    end;

    var
        StyleUnfavorable: Boolean;
}
