/// <summary>
/// PageExtension ItemList_Ext (ID 50155) extends Record Item List.
/// </summary>
pageextension 50155 ItemList_Ext extends "Item List"
{
    actions
    {
        addbefore(Attributes)
        {
            action(EditInExcel)
            {
                Caption = 'Trial Action';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = false;
                ApplicationArea = All;
            }
        }
    }
}