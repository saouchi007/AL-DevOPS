/// <summary>
/// PageExtension ISA_CustomerCard (ID 50164) extends Record Customer Card.
/// </summary>
pageextension 50164 ISA_CustomerCard extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(ItemNo; ItemNo)
            {
                Caption = 'Item No.';
                ApplicationArea = All;
                TableRelation = Item."No.";

                trigger OnValidate()
                var
                    ItemRec: Record Item;
                begin
                    if ItemRec.Get(ItemNo) then
                        ItemDescription := ItemRec.Description;
                end;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        ItemDescription: Text[50];
        ItemNo: Text[50];
}