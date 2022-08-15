/// <summary>
/// PageExtension ISA_OrderProcessorRoleCenter_Ext (ID 50304) extends Record Order Processor Role Center.
/// </summary>
pageextension 50304 ISA_OrderProcessorRC_Ext extends "Order Processor Role Center"
{
    layout
    {
        addbefore(Emails)
        {
            part(ISA_CustomerCue; ISA_CustomerCue)
            {
                ApplicationArea = All;
            }
        }
    }

}