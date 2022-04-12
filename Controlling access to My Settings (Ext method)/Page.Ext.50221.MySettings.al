/// <summary>
/// PageExtension ISA_MySettings_Ext (ID 50221) extends Record MyTargetPage.
/// </summary>
pageextension 50221 ISA_MySettings_Ext extends "User Settings"
{
    layout
    {
        modify(UserRoleCenter)
        {
            Visible = AllowChangeRole;
        }
        modify(Company)
        {
            Visible = AllowChangeCompanyName;
        }
        modify("Work Date")
        {
            Visible = AllowChangeWorkDay;
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        NoPermission: Label 'You do not have permission to open My Settings page, please contac your administrator';
    begin
        AllowChangeCompanyName := false;
        AllowChangeRole := false;
        AllowChangeWorkDay := false;
        if UserSetup.Get(UserId) then
            if UserSetup.OpenSettings then begin
                AllowChangeRole := UserSetup.OpenSettings;
                AllowChangeCompanyName := UserSetup.ChangeCompany;
                AllowChangeWorkDay := UserSetup.ChangeWorkDay;
                exit;
            end;
        Error(NoPermission);
    end;

    var
        AllowChangeRole: Boolean;
        AllowChangeCompanyName: Boolean;
        AllowChangeWorkDay: Boolean;
}