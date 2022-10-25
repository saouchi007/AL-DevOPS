// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

/// <summary>
/// PageExtension ISA_CustomerList_Ext (ID 50304) extends Record Customer List.
/// </summary>
pageextension 50304 ISA_CustomerList_Ext extends "Customer List"
{
    trigger OnOpenPage();
    var
        CompanyInfo: Record "Company Information";
    begin
        if CompanyInfo.get() then
            Message('This company is : %1', CompanyInfo.Name);
        if CompanyInfo.ChangeCompany('Trial Company') then
            if CompanyInfo.get() then
                Message('New Company is : %1', CompanyInfo.Name);
    end;
}