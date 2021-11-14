pageextension 50100 Customer extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(itemDescription; itemDescription)
            {
                Caption = 'Item Description';
                ApplicationArea = All;
                ToolTip = 'Description of the item';

                trigger OnLookup(var text: text): Boolean
                var
                    itemRec: Record Item;
                begin
                    itemRec.Reset();
                    if page.RunModal(Page::"Item List", itemRec) = Action::LookupOK then
                        itemDescription := itemRec.Description;
                end;
            }
        }
    }

    var
        itemDescription: Text[50];
}