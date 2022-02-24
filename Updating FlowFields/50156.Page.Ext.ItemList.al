
/// <summary>
/// PageExtension ItemsLits_Ext (ID 50156) extends Record Item List.
/// </summary>
pageextension 50156 ItemsLits_Ext extends "Item List"
{
    trigger OnOpenPage()
    var
        itemRec: Record Item;
    begin
        itemRec."No." := '1000';
        itemRec.CalcFields(Inventory);
        Message('%1', itemRec.Inventory);
        /* Flowfield ought to be preceeded with CalcFields, otherwise they remain empty as no value is stored yet processed 
        itemRec.Reset();
        if itemRec.FindFirst() then begin
            itemRec.CalcFields(Inventory);
            Message('%1', itemRec.Inventory);
        end;
        */

    end;
}