/// <summary>
/// Codeunit MyCodeunit (ID 50158).
/// </summary>
codeunit 50158 MyCodeunit
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure MyProcedure()
    var
        SalesLines: Record "Sales Line";
        SalesRecei: Record "Sales & Receivables Setup";
        GLPost: Codeunit "Gen. Jnl.-Post Line";
        Line: Record "Gen. Journal Line";
    begin
        Message('%1', SalesLines.StampDuty);
        exit;
        SalesRecei.Get();
        Line.init();
        Line."Posting Date" := Today;
        Line."Document Type" := Line."Document Type"::Invoice;
        Line."Document No." := 'X000001';
        Line."Account Type" := Line."Account Type"::"G/L Account";
        Line."Account No." := SalesRecei.ISA_DutyStampGLA;
        Line.Description := 'Stamp Duty';
        //Line.Amount := SalesLines.StampDuty;
        Line."Bal. Account Type" := Line."Bal. Account Type"::"G/L Account";
        GLPost.RunWithCheck(Line);

        //Message('%1', SalesRecei.ISA_DutyStampGLA);
    end;
}