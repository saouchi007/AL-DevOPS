page 80183 "MICA Add. Item Disc. Details"
{
    // version OFFINVOICE
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Additional Item Discounts Detail';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Line Discount";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

