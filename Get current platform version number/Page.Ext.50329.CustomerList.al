/// <summary>
/// PageExtension ISA_CustomerList_Ext (ID 50329) extends Record Customer List.
/// </summary>
pageextension 50329 ISA_CustomerList_Ext extends "Customer List"
{
    trigger OnOpenPage()
    var
    begin
        ISA_PlatformVersionAlpha();
        ISA_PlatformVersionBeta();
    end;


    local procedure ISA_PlatformVersionAlpha()
    var
        Info: ModuleInfo;
        BaseAppId: Codeunit "BaseApp ID";
        VersionInfoLbl: Label 'Version info:\\Major version : %1\Minor version : %2\Build version : %3\Revision version : %4';
    begin
        NavApp.GetModuleInfo(BaseAppId.Get(), Info);
        Message(VersionInfoLbl, Info.DataVersion.Major, Info.DataVersion.Minor, Info.DataVersion.Build, Info.DataVersion.Revision);
    end;

    local procedure ISA_PlatformVersionBeta()
    var
        AppSysConstants: Codeunit "Application System Constants";
        VersionInfoLbl: Label 'Version info:\\Application version : %1\The build file version : %2,\Application build : %3,\Build branch : %4\Pltaform production version : %5,\Platfrom version : %6';
    begin
        Message(VersionInfoLbl, AppSysConstants.ApplicationVersion(), AppSysConstants.BuildFileVersion(), AppSysConstants.ApplicationBuild(),
         AppSysConstants.BuildBranch(), AppSysConstants.PlatformProductVersion(), AppSysConstants.PlatformFileVersion());
    end;
}