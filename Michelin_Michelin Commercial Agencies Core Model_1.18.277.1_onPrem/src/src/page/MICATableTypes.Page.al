page 81530 "MICA Table Types"
{

    PageType = List;
    SourceTable = "MICA Table Type";
    Caption = 'Table Types';
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Type; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("Max. Length for Code"; Rec."Max. Length for Code")
                {
                    ApplicationArea = All;
                }
                field("Max. Length for Description"; Rec."Max. Length for Description")
                {
                    ApplicationArea = All;
                }
                field("Synchronize to Attributes"; Rec."Synchronize to Attributes")
                {
                    ApplicationArea = All;
                }
                field("Item Attribute Name"; Rec."Item Attribute Name")
                {
                    ApplicationArea = All;
                }
                field("Value Count"; Rec."Value Count")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownValues();
                    end;
                }
                field("List Page Id"; Rec."List Page Id")
                {
                    ApplicationArea = All;
                }
                field("List Page Name"; Rec."List Page Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
