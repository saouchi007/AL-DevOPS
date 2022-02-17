/// <summary>
/// PageExtension BusinessManager_Ext (ID 50146) extends Record Business Manager Role Center.
/// </summary>
pageextension 50146 BusinessManager_Ext extends "Business Manager Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            part(My; Cues)
            {
                ApplicationArea = All;
            }
        }
    }

}