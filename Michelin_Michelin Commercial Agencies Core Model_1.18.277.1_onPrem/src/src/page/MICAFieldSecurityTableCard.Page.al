page 81282 "MICA Field Security Table Card"
{

    PageType = Card;
    SourceTable = "MICA Field Security Table";
    Caption = 'Field Security Table Card';
    UsageCategory = None;
    layout
    {
        area(content)
        {
            field("Table ID"; Rec."Table ID")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("Table Name"; Rec."Table Name")
            {
                ApplicationArea = All;
            }
            field(Enable; Rec."Enable")
            {
                ApplicationArea = All;
            }
            part("MICA Field Security Field List"; "MICA Field Security Field Part")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = field("Table ID");
            }
        }
    }

}
