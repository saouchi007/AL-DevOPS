/// <summary>
/// Codeunit PublishWebServices (ID 15160).
/// </summary>
codeunit 50160 PublishWebServices
{

    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        TenantWebService.Init();
        TenantWebService."Object Type" := TenantWebService."Object Type"::Page;
        TenantWebService."Object ID" := 146;
        TenantWebService."Service Name" := 'PostedPurchaseInvoiceWS';
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;

}