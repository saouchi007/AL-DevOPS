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
            field(itemFilter; itemFilter)
            {
                Caption = 'Item Filter';
                ApplicationArea = All;
                ToolTip = 'To select a set of items';

                trigger OnLookup(var text: text): Boolean
                var
                    itemList: page "Item List";
                begin
                    Clear(itemFilter);
                    itemList.LookupMode(true);
                    if itemList.RunModal() = Action::LookupOK then begin
                        text += itemList.GetSelectionFilter();
                        exit(true);
                    end else
                        exit(false);
                end;
            }
        }


    }

    var
        itemDescription: Text[50];
        itemFilter: Text[100];
}