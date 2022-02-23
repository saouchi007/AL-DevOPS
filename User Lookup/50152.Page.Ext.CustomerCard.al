/// <summary>
/// PageExtension CustomerCard_Ext (ID 50152) extends Record MyTargetPage.
/// </summary>
pageextension 50152 CustomerCard_Ext extends "Customer Card"
{
    layout
    {
        addbefore(Blocked)
        {
            field("User Name"; Rec."User Name")
            {
                ApplicationArea = All;
            }
        }
    }


}