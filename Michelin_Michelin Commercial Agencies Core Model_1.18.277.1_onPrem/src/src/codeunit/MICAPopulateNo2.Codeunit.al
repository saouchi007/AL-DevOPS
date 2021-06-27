codeunit 80080 "MICA PopulateNo2"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlobalGLEntry', '', False, false)]
    local procedure OnBeforeInsertGlobalGLEntry(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
    begin
        if not GLAccount.Get(GlobalGLEntry."G/L Account No.") then
            exit;
        GLAccount.TestField("No. 2");
        GlobalGLEntry."MICA No. 2" := GLAccount."No. 2";
        GlobalGLEntry."MICA Additional Information 1" := GenJournalLine."MICA Additional Information 1";
        GlobalGLEntry."MICA Additional Information 2" := GenJournalLine."MICA Additional Information 2";
        GlobalGLEntry."MICA Additional Information 3" := GenJournalLine."MICA Additional Information 3";
        GlobalGLEntry."MICA Additional Information 4" := GenJournalLine."MICA Additional Information 4";
    end;
}
