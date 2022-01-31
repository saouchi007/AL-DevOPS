/// <summary>
/// PageExtension SalesOrders_Ext (ID 50131) extends Record Sales Order.
/// </summary>
pageextension 50131 SalesOrders_Ext extends "Sales Order"
{
    trigger OnOpenPage()
    begin
        Message('True : ' + Rec.GetPosition(true) + '\ False : ' + Rec.GetPosition(false) + '\ Record ID : %1 \ Table No : %2', Format(Rec.RecordId),
        Rec.RecordId.TableNo);

        // if the primary key in a table has data type RecordId then it is only accessible using setrange method
    end;
}