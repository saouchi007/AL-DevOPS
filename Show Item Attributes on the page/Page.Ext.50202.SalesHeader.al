/// <summary>
/// PageExtension ISA_SlesHeader_Ext (ID 50203) extends Record Sales Order.
/// </summary>
pageextension 50203 ISA_SlesHeader_Ext extends "Sales Order"
{
    layout
    {
        addafter("Your Reference")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
            }
        }
    }
}



