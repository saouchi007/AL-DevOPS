codeunit 80000 "MICA Integration Mgmt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Management", 'OnGetIntegrationDisabled', '', true, true)]
    local procedure "Integration Management_OnGetIntegrationDisabled"(var IsSyncDisabled: Boolean)
    begin
        //Force disabling insertion of record in "Integration Record" table
        //IsSyncDisabled := true;
    end;

    procedure SplitEmailToRecipient(Email: Text; var Recipients: List of [Text]): Boolean
    var
        ProcessedMails: Text;
        Mail: Text;
        i: Integer;
    begin
        ProcessedMails := ConvertStr(Email, ';', ',');
        Recipients := ProcessedMails.Split(',');
        for i := 1 to Recipients.Count() do begin
            Recipients.Get(i, Mail);
            if (Mail = '') or (StrPos(Mail, '@') = 0) then
                Recipients.Remove(Mail);
        end;
        if Recipients.Count() < 1 then
            exit(false);
        exit(true);
    end;
}