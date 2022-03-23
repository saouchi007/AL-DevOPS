/// <summary>
/// PageExtension ISA_ItemLEdgerEntries_Ext (ID 50186) extends Record MyTargetPage.
/// </summary>
pageextension 50186 ISA_ItemLEdgerEntries_Ext extends "Item Ledger Entries"
{
    layout
    {
        modify("Global Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Global Dimension 2 Code")
        {
            Visible = true;
        }
        addafter("Global Dimension 1 Code")
        {
            field(ShortDim3;Rec.ShortDim3)
            {
                ApplicationArea = all;
            }
            field(ShortDim4;Rec.ShortDim4)
            {
                ApplicationArea = all;
            }
            field(ShortDim5;Rec.ShortDim5)
            {
                ApplicationArea = all;
            }
            field(ShortDim6;Rec.ShortDim6)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}