page 81281 "MICA Field Security Field List"
{
    PageType = List;
    SourceTable = "MICA Field Security Field";
    Caption = 'Field Security Field List';
    ModifyAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field("Field Id"; Rec."Field Id")
                {
                    ApplicationArea = All;
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

}
