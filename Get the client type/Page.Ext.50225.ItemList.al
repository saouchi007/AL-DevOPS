/// <summary>
/// PageExtension ISA_ItemList_Ext (ID 50225) extends Record Item List.
/// </summary>
pageextension 50225 ISA_ItemCard_Ext extends "Item Card"
{
    layout
    {
        modify(Description)
        {
            trigger OnBeforeValidate()
            var
                ClientTypeError: Label 'Data can only be modified via desktop client';
            begin
                if CurrentClientType <> ClientType::Desktop then
                    Error(ClientTypeError);
            end;
        }
    }
    trigger OnOpenPage()
    var
        Msg: Label 'Client type that is running in current session is ''%1''';
    begin
        Message(Msg, CurrentClientType);
    end;
}