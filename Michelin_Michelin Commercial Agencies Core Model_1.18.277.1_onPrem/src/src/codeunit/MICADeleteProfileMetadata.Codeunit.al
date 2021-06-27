codeunit 80141 "MICA DeleteProfileMetadata"
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    var
        ProfileMetadata: Record "Profile Metadata";
    begin
        ProfileMetadata.SetRange("Profile ID", 'ORDER PROCESSOR');
        ProfileMetadata.SetRange("Page ID", page::"Sales Order Subform");
        if ProfileMetadata.FindFirst() then
            ProfileMetadata.Delete();

    end;
}