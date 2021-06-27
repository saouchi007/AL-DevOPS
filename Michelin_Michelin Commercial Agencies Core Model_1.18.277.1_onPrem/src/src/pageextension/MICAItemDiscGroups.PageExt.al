pageextension 80189 "MICA Item Disc. Groups" extends "Item Disc. Groups"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA Add. Item Disc. Group Count"; Rec."MICA Add. Item Disc. Grp Count")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Sales &Line Discounts")
        {
            action("MICA Off-Invoice Item Selection Setup")
            {
                Caption = 'Off-Invoice Item Selection Setup';
                ApplicationArea = all;
                Image = ItemGroup;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View the Off-Invoice Items available';
                RunObject = Page "MICA Off-Inv. Item Sel. List";
                RunPageLink = "Item Discount Group Code" = field(Code);
            }
        }
    }

}