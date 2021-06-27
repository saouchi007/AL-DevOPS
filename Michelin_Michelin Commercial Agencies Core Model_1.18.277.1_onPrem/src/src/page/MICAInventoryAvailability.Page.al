page 82580 "MICA Inventory Availability"
{
    Caption = 'Inventory Availability';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MICA Inventory Availability";
    SourceTableView = sorting ("Item No.", "Location Code");
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No"; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description.';
                }
                field(CAI; Rec.CAI)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CAI.';
                }
                field("Product Line"; Rec."Product Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Product Line.';
                }
                field("Business Line"; Rec."Business Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Business Line.';
                }
                field("Market Code"; Rec."Market Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Market Code.';
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Brand.';
                }
                field("User Item Type"; Rec."User Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User Item Type.';
                }
                field("Item Class"; Rec."Item Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Class.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location Code.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost.';
                }
                
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Calculation Type.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity.';
                }

            }
        }
    }
}