page 82900 "MICA Off-Inv. Item Sel. List"
{
    PageType = List;
    Caption = 'Off-Invoice Item Selection Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA Off-Inv. Item Sel. Setup";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item Discount Group Code"; Rec."Item Discount Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Discount Group Code from the table Item Discount Group';
                }
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item number';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Category Code from the table Item Category Code';
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Brand from the Item Card';
                }
                field("Rim Diametar"; Rec."Rim Diametar")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rim Diametar from the Item Card';
                }
                field(Pattern; Rec.Pattern)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Pattern from the Item Card';
                }
                field("Commercial Label"; Rec."Commercial Label")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Commercial Label from the Item Card';
                }
                field("Market Code"; Rec."Market Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Market Code from the Item Card';
                }
                field("Item Class"; Rec."Item Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Class from the Item Card';
                }
                field("Product Nature"; Rec."Product Nature")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Product Nature from the Item Card';
                }
                field("LPR Category"; Rec."LPR Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the LPR Category from the Item Card';
                }
                field("Section Width"; Rec."Section Width")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Section Width from the Item Card';
                }
                field("Aspect Ratio"; Rec."Aspect Ratio")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Aspect Ratio from the Item Card';
                }
                field("CCID Code"; Rec."CCID Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CCID Code from the Item Card';
                }
                field("Business Line"; Rec."Business Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Business Line from the Item Card';
                }
            }
        }
    }
}