pageextension 50102 custLookup extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(LookupList; LookupList)
            {
                Caption = 'Lookup List';
                ApplicationArea = all;

                trigger OnLookup(var Text: Text): Boolean
                var
                    itemRec: Record Item;
                begin
                    itemRec.Reset();
                    if Page.RunModal(Page::"Item List", itemRec) = Action::LookupOK then
                        LookupList := itemRec.Description;
                end;
            }


        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        LookupList: Text[100];
        MultipleLookupList: Text[100];
}