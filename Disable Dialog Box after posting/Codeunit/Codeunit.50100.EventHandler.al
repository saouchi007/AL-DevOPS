/// <summary>
/// Codeunit EventHandler (ID 50100).
/// </summary>
codeunit 50100 EventHandler
{
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnPostDocumentBeforeNavigateAfterPosting', '', false, false)]
    local procedure OnPostDocumentBeforeNavigateAfterPosting(var IsHandled: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if SalesSetup.Get() then
            if SalesSetup.DisableDialogAfterPosting then
                IsHandled := true;

    end;
}