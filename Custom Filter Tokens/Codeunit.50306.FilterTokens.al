/// <summary>
/// Codeunit ISA_FilterTokens (ID 50306).
/// </summary>
codeunit 50306 ISA_FilterTokens
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 'OnResolveTextFilterToken', '', true, true)]
    local procedure ISA_TopSalesInvoicesAmount(TextToken: Text; var TextFilter: Text; var Handled: Boolean)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Counter: Integer;
    begin
        if StrLen(TextToken) < 3 then
            exit;

        if StrPos(UpperCase('topinv'), UpperCase(TextToken)) = 0 then
            exit;

        Handled := true;

        SalesInvoiceHeader.SetCurrentKey(Amount);
        SalesInvoiceHeader.SetAscending(Amount, false);

        if SalesInvoiceHeader.FindSet() then begin
            repeat
                Counter += 1;
                TextFilter += '|' + SalesInvoiceHeader."No.";
            until (SalesInvoiceHeader.Next() = 0) or (Counter = 5);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 'OnResolveTextFilterToken', '', true, true)]
    local procedure ISA_LastFivePostedSalesInvoices(TextToken: Text; var TextFilter: Text; var Handled: Boolean)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Counter: Integer;
    begin
        if StrLen(TextToken) < 3 then
            exit;

        if StrPos(UpperCase('lastfive'), UpperCase(TextToken)) = 0 then
            exit;

        Handled := true;

        SalesInvoiceHeader.SetCurrentKey("Posting Date");
        SalesInvoiceHeader.SetAscending("Posting Date", false);

        if SalesInvoiceHeader.FindSet() then begin
            repeat
                Counter += 1;
                TextFilter += '|' + SalesInvoiceHeader."No.";
            until (SalesInvoiceHeader.Next() = 0) or (Counter = 5);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 'OnResolveDateFilterToken', '', true, true)]
    local procedure ISA_SalesInvoiceCurrentYear(DateToken: Text; var FromDate: Date; var ToDate: Date; var Handled: Boolean)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Counter: Integer;
        UpperDate: Date;
        LowerDate: Date;
    begin
        UpperDate := CalcDate('<-CY>', WorkDate());
        LowerDate := CalcDate('<CY>', WorkDate());

        if StrLen(DateToken) < 3 then
            exit;

        if StrPos(UpperCase('thisyear'), UpperCase(DateToken)) = 0 then
            exit;

        Handled := true;
        FromDate := UpperDate;
        ToDate := LowerDate;

        SalesInvoiceHeader.SetCurrentKey("Posting Date");
        SalesInvoiceHeader.SetAscending("Posting Date", false);

        if SalesInvoiceHeader.FindSet() then begin
            repeat
                Counter += 1;
                DateToken += '|' + SalesInvoiceHeader."No.";
            until (SalesInvoiceHeader.Next() = 0) or (Counter = 5);
        end;
    end;
}