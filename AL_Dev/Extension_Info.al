codeunit 50110 MyCodeunit
{
    var
        Info: Codeunit "Environment Information";

    trigger OnRun()
    var
    begin
        // MyProcedure();
        Get_App_Version('437dbf0e-84ff-417a-965d-ed2bb9650972');
    end;

    procedure MyProcedure(): Text
    begin
        /* if Info.IsFinancials() then begin
            Message('This is financials');
        end;
        if Info.IsOnPrem() then begin
            Message('This is OnPrem');
        end;
        if Info.IsProduction() then begin
            Message('This is Production');
        end;
        if Info.IsSaaS() then begin
            Message('This is SAAS');
        end;
        if Info.IsSandbox() then begin
            Message('This is Sandbox');
        end; */
        // Message(Info.GetApplicationFamily()); // Get the app family
        // Message(Info.GetEnvironmentName()); // Get the environment name , prod, prem, saas...etc
    end;

    procedure Get_App_Version(AppID: Guid): Integer
    begin
        exit(Info.VersionInstalled(AppID));
    end;
}