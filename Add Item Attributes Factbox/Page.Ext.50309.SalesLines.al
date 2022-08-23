/// <summary>
/// PageExtension ISA_SalesLines (ID 50309) extends Record Sales Lines.
/// </summary>
pageextension 50309 ISA_SalesLines extends "Sales Lines"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(ItemAttributesFactBox; "Item Attributes Factbox")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }

    }

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Type = Rec.Type::Item then
            CurrPage.ItemAttributesFactBox.Page.LoadItemAttributesData(Rec."No.")
        else
            CurrPage.ItemAttributesFactBox.Page.LoadItemAttributesData('');
    end;
}