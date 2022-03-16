/// <summary>
/// PageExtension ISA_CustomerCard (ID 50163) extends Record Customer Card.
/// </summary>
pageextension 50163 ISA_CustomerCard extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(ItemFilter; ItemFilter)
            {
                Caption = 'Item Filter';
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ItemList: Page "Item List";
                begin
                    clear(ItemFilter);
                    ItemList.LookupMode(true);
                    if ItemList.RunModal() = Action::LookupOK then begin
                        Text += ItemList.GetSelectionFilter();
                        exit(true);
                    end
                    else
                        exit(false);
                end;
            }
        }
    }


    var
        ItemFilter: Text[50];
}