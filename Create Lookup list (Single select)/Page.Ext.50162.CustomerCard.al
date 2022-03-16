/// <summary>
/// PageExtension ISA_CustomerCard (ID 50162) extends Record Customer Card.
/// </summary>
pageextension 50162 ISA_CustomerCard extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(ItemDescription; ItemDescription)
            {
                Caption = 'Item Descritpion';
                ApplicationArea = All;
                ToolTip = 'To select the item''s description from a lookup list';

                trigger OnLookup(var Text: Text): Boolean
                var
                    ItemRec: Record Item;
                begin
                    ItemRec.Reset();
                    if Page.RunModal(Page::"Item List", ItemRec) = Action::LookupOK then
                        ItemDescription := ItemRec.Description;
                end;
            }
        }
    }

    var
        ItemDescription: Text[50];
}