codeunit 82040 "MICA Gen. Jnl. Post Line Event"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure c12OnBeforePostGenJnlLine(VAR GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin
        GetExplanation(GenJournalLine);
    end;

    local procedure GetExplanation(VAR GenJournalLine: Record "Gen. Journal Line")
    var
        ExplanationDescription: Text[100];
    begin
        if GenJournalLine."Document Type" <> GenJournalLine."Document Type"::Payment then
            exit;
        ExplanationDescription := CopyStr(GenJournalLine."MICA Explanation (VN)" + ' ' + GenJournalLine."MICA Explanation", 1, MaxStrLen(ExplanationDescription));
        if DelChr(ExplanationDescription, '=', ' ') <> '' then
            GenJournalLine.Description := CopyStr(ExplanationDescription, 1, MaxStrLen(GenJournalLine.Description));
    end;
}