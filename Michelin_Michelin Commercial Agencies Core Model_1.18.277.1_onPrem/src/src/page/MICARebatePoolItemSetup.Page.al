page 83002 "MICA Rebate Pool Item Setup"
{
    PageType = List;
    Caption = 'Rebate Pool Item Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA Rebate Pool Item Setup";

    layout
    {
        area(Content)
        {
            repeater(ListControl)
            {
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Category Code (Product Line).';
                }
                field("Business Line"; Rec."Business Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Business Line.';
                }
                field("Rebate Pool Item No."; Rec."Rebate Pool Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Pool Item No.';
                }
                field("Rebate Dim. Value Code"; Rec."Rebate Dim. Value Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Dimension Value Code';
                }
            }
        }
    }
}