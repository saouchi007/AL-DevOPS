page 80185 "MICA Posted Applied SL Disc"
{
    Caption = 'Posted Applied Sales Line Discount';
    // version OFFINVOICE    
    Editable = false;
    PageType = List;
    SourceTable = "MICA Posted Applied SL Disc.";
    UsageCategory = None;



    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Rebates Type"; Rec."Rebates Type")
                {
                    ApplicationArea = All;
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posted Document Line No."; Rec."Posted Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                }

                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Product Line"; Rec."Product Line")
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Sales Discount %"; Rec."Sales Discount %")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."MICA Status")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }

                field("Exceptional Discount Reason"; Rec."MICA Except. Rebate Reason")
                {
                    ApplicationArea = All;
                }
                field("MICA Source Document No."; Rec."MICA Source Document No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Source Doc. Line No."; Rec."MICA Source Doc. Line No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}