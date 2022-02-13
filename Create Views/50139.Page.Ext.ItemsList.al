/// <summary>
/// PageExtension ItemsList_Ext (ID 50139) extends Record Item List.
/// </summary>
pageextension 50139 ItemsList_Ext extends "Item List"
{
    views
    {
        addfirst
        {
            view(InventoryNull)
            {
                Caption = 'Items without Inventory';
                Filters = where(Inventory = filter(= 0));
            }
        }
    }
}