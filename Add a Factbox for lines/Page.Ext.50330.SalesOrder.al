/// <summary>
/// PageExtension ISA_SalesOrder_Ext (ID 50330) extends Record MyTargetPage.
/// </summary>
pageextension 50330 ISA_SalesOrder_Ext extends "Sales Order"
{
    layout
    {
        addfirst(factboxes)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                Provider = Control1901314507; //SalesLines
                SubPageLink = "No." = field("No.");
            }
        }
    }


}