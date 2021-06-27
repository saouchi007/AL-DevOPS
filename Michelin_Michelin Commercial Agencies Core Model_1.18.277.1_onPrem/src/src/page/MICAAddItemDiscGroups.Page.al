page 80180 "MICA Add. Item Disc. Groups"
{
    // version OFFINVOICE

    ApplicationArea = Basic, Suite;
    Caption = 'Additional Item Disc. Groups';
    DataCaptionFields = "Item No.";
    PageType = List;
    SourceTable = "MICA Add. Item Discount Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Discount Group Code"; Rec."Item Discount Group Code")
                {
                    ApplicationArea = All;
                }
                field("Item Discount Group Desc."; Rec."Item Discount Group Desc.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("Item &Disc. Groups")
            {
                Caption = 'Item &Disc. Groups';
                Image = Group;
                action("Sales &Line Discounts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales &Line Discounts';
                    Image = SalesLineDisc;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    RunObject = Page 7004;
                    RunPageLink = Type = CONST("Item Disc. Group"),
                                  Code = FIELD("Item Discount Group Code");
                    RunPageView = SORTING(Type, Code);
                    ToolTip = 'View the sales line discounts that are available. These discount agreements can be for individual customers, for a group of customers, for all customers or for a campaign.';
                }
            }
        }
    }
}

