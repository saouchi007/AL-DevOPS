page 81280 "MICA Field Security Table List"
{
    PageType = List;
    SourceTable = "MICA Field Security Table";
    Caption = 'Field Security Table List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "MICA Field Security Table Card";
    ModifyAllowed = false;
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
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                }
                field(Enable; Rec."Enable")
                {
                    ApplicationArea = All;
                }
                field("No. Of Fields Setup"; Rec."No. Of Fields Setup")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
