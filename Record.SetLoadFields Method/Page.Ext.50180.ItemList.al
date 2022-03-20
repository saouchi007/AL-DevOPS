/// <summary>
/// PageExtension ISA_ItemList_Ext (ID 50179) extends Record Item List.
/// </summary>
pageextension 50180 ISA_ItemList_Ext extends "Item List"
{
    trigger OnOpenPage()
    var
        Item: Record Item;
        SumTotal: Decimal;
        GrandTotal: Decimal;
        Counter: Integer;
    begin
        Item.SetLoadFields(Item."Unit Cost", Item."Unit Price");
        if Item.FindSet() then begin
            repeat
                SumTotal += Item."Unit Cost";
                GrandTotal += Item."Unit Price"; // bad practise to call a field that has not been called on setloadfields
                Counter += 1;
            until Item.Next() = 0;
            Message(Format(SumTotal / Counter) + ' & ' + Format(GrandTotal / Counter));

        end;
    end;
}