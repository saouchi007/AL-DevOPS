/// <summary>
/// PageExtension ISA_BMgrRoleCenter_Ext (ID 50302) extends Record MyTargetPage.
/// </summary>
pageextension 50302 ISA_BMgrRoleCenter_Ext extends "Business Manager Role Center"
{
    layout
    {
        addbefore(Emails)
        {
            part(ISA_CueBackgroundTask; ISA_CueBackgroundTask)
            {
                ApplicationArea = All;
            }

        }
    }


}