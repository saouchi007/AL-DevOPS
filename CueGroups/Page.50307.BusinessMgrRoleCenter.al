/// <summary>
/// PageExtension ISA_BusinessMgrRoleCenter (ID 50307) extends Record Business Manager Role Center.
/// </summary>
pageextension 50307 ISA_BusinessMgrRoleCenter extends "Order Processor Role Center"
{
    layout
    {
        addafter(Emails)
        {
            part(ISA_Cue; ISA_Cue)
            {
                ApplicationArea = All;

            }
        }
    }


}