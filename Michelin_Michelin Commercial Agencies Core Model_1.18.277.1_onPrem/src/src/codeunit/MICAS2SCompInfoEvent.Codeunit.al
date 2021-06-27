codeunit 82780 "MICA S2S Comp. Info. Event"
{

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventCompany(var Rec: Record Company)
    var
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        RecRef: RecordRef;
    begin
#if OnPremise
        RecRef := Rec.RecordId.GetRecord();
        RecRef.GetTable(Rec);        
        APIWebhookNotificationMgt.OnDatabaseInsert(RecRef);
#endif
    end;

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventCompany(var Rec: Record Company)
    var
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        RecRef: RecordRef;
    begin
#if OnPremise
        RecRef := Rec.RecordId.GetRecord();
        RecRef.GetTable(Rec);
        APIWebhookNotificationMgt.OnDatabaseModify(RecRef);
#endif
    end;

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEventCompany(var Rec: Record Company)
    var
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        RecRef: RecordRef;
    begin
#if OnPremise
        RecRef := Rec.RecordId.GetRecord();
        RecRef.GetTable(Rec);
        APIWebhookNotificationMgt.OnDatabaseDelete(RecRef);
#endif
    end;

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterRenameEvent', '', false, false)]
    local procedure OnAfterRenameEventCompany(var Rec: Record Company; var xRec: Record Company)
    var
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
#if OnPremise
        RecRef := Rec.RecordId.GetRecord();
        RecRef.GetTable(Rec);
        xRecRef := xRec.RecordId.GetRecord();
        xRecRef.GetTable(xRec);        
        APIWebhookNotificationMgt.OnDatabaseRename(RecRef, xRecRef);
#endif
    end;

    local procedure WebHookCompany()
    var
        Company: Record "Company";
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        RecRef: RecordRef;
    begin
#if OnPremise
        Company.Get(CompanyName);
        RecRef := Company.RecordId.GetRecord();
        RecRef.GetTable(Company);
        APIWebhookNotificationMgt.OnDatabaseModify(RecRef);
#endif
    end;

    [EventSubscriber(ObjectType::Table, Database::"Company Information", 'OnAfterValidateEvent', 'Name', false, false)]
    local procedure OnAfterValidateEventNameTableCompanyInformation(var Rec: Record "Company Information"; var xRec: Record "Company Information")
    begin
        if Rec.Name <> xRec.Name then
            WebHookCompany();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Company Information", 'OnAfterValidateEvent', 'Country/Region Code', false, false)]
    local procedure OnAfterValidateEventCountryRegionCodeTableCompanyInformation(var Rec: Record "Company Information"; var xRec: Record "Company Information")
    begin
        if Rec."Country/Region Code" <> xRec."Country/Region Code" then
            WebHookCompany();
    end;

    [EventSubscriber(ObjectType::Table, Database::"MICA Financial Reporting Setup", 'OnAfterValidateEvent', 'Company Code', false, false)]
    local procedure OnAfterValidateEventCompanyCodeTableMICAFinancialReportingSetup(var Rec: Record "MICA Financial Reporting Setup"; var xRec: Record "MICA Financial Reporting Setup")
    begin
        if Rec."Company Code" <> xRec."Company Code" then
            WebHookCompany();
    end;
}