/// <summary>
/// PageExtension ISA_UserSetupPage_Ext (ID 50220) extends Record MyTargetPage.
/// </summary>
pageextension 50220 ISA_UserSetupPage_Ext extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field(OpenSettings; Rec.OpenSettings)
            {
                ApplicationArea = All;
            }
            field(ChangeRole; Rec.ChangeRole)
            {
                ApplicationArea = All;
            }
            field(ChangeCompany; Rec.ChangeCompany)
            {
                ApplicationArea = All;
            }
            field(ChangeWorkDay; Rec.ChangeWorkDay)
            {
                ApplicationArea = All;
            }
        }
    }
}