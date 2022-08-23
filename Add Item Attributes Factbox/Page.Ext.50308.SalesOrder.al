/// <summary>
/// PageExtension ISA_SalesOrder (ID 50308) extends Record MyTargetPage.
/// </summary>
pageextension 50308 ISA_SalesOrder extends "Sales Order"
{
    layout
    {
        addfirst(factboxes)
        {
            part(ItemAttributesFactBox; "Item Attributes Factbox")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action(LoadItemAttributesData)
            {
                ApplicationArea = All;
                Caption = 'Load Selected Item Attributes';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortcutKey = 'Shift+Ctrl+D';
                Image = AdjustEntries;

                trigger OnAction()
                var
                    SalesLines: Record "Sales Line";
                begin
                    SalesLines.reset();
                    CurrPage.SalesLines.Page.SetSelectionFilter(SalesLines);

                    if SalesLines.FindFirst() then
                        if SalesLines.Type = SalesLines.Type::Item then
                            CurrPage.ItemAttributesFactBox.Page.LoadItemAttributesData(SalesLines."No.");


                end;
            }
        }
    }


}

