/// <summary>
/// Codeunit ISA_ShortcutDimMgmt (ID 50186).
/// </summary>
codeunit 50186 ISA_ShortcutDimMgmt
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure TransferDimValuesToItemLedgerEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line";
    TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry")
    var
        DimMgmt: Codeunit DimensionManagement;
        ShortCutDimCode: array[4] of Code[20];
    begin
        DimMgmt.GetShortcutDimensions(ItemLedgerEntry."Dimension Set ID", ShortCutDimCode);
        ItemLedgerEntry.ShortDim3 := ShortCutDimCode[3];
        ItemLedgerEntry.ShortDim3 := ShortCutDimCode[4];
        ItemLedgerEntry.ShortDim3 := ShortCutDimCode[5];
        ItemLedgerEntry.ShortDim3 := ShortCutDimCode[6];

    end;
}

