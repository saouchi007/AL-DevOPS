page 81283 "MICA Field Security Field Part"
{
    PageType = ListPart;
    SourceTable = "MICA Field Security Field";
    Caption = 'Fields';
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Field Id"; Rec."Field Id")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;
                }
                field(Mandatory; Rec."Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Equal To"; Rec."Equal To")
                {
                    ApplicationArea = All;
                }
                field("User Access Count"; Rec."User Access Count")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("User Access")
            {
                ApplicationArea = All;
                Image = UserSetup;
                Caption = 'User Access';
                RunObject = page "MICA F. Secur User Access List";
                RunPageLink = "Table Id" = field("Table ID"), "Field ID" = field("Field Id");
                trigger OnAction()
                begin
                end;
            }
        }
    }
}
