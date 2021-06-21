pageextension 50103 MultiLookupSelect extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(multiSelectLookup; multiSelectLookup)
            {
                Caption = 'Multi Select Lookup';
                ApplicationArea = all;

                trigger OnLookup(var text: Text): Boolean
                var
                    itemList: Page "Item List";
                begin
                    Clear(itemList);
                    itemList.LookupMode(true);
                    if itemList.RunModal() = Action::LookupOK then begin
                        text += itemList.GetSelectionFilter();
                        exit(true)
                    end
                    else
                        exit(false);

                end;
            }
        }

    }

    actions
    {
    }

    var
        multiSelectLookup: Text[50];
}