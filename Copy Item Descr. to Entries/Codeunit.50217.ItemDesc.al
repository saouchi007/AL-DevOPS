/// <summary>
/// Codeunit ISA_ItemDescription_Update (ID 50217).
/// </summary>
codeunit 50217 ISA_ItemDescription_Update
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure SetDescriptionToItemLedger(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        if NewItemLedgEntry.Description = '' then
            NewItemLedgEntry.Description := ItemJournalLine.Description + '_inserted by ISA';
    end;
}