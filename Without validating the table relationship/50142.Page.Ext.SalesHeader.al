/// <summary>
/// PageExtension SalesHeader_Ext (ID 50142) extends Record Sales Order.
/// </summary>
pageextension 50142 SalesHeader_Ext extends "Sales Order"
{
    layout
    {
        addafter("External Document No.")
        {
            field("End User Name"; Rec."End User Name")
            {
                Caption = 'End User';
                ApplicationArea = All;
            }
        }
    }

}