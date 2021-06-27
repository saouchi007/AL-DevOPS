codeunit 82200 "MICA MICAItemJnlReclPostEvent"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntryAddReasonCode(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."MICA Reason Code" := ItemJournalLine."Reason Code";

    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Check Line", 'OnAfterCheckItemJnlLine', '', false, false)]
    local procedure OnAfterCheckItemTrackingTestReasonCode(var ItemJnlLine: Record "Item Journal Line")
    begin
        if (ItemJnlLine."Journal Template Name" <> '') and
          (ItemJnlLine."Journal Batch Name" <> '') and
          (ItemJnlLine."Document Type" = ItemJnlLine."Document Type"::" ") and
          (ItemJnlLine."Document Line No." = 0)
        then
            ItemJnlLine.TestField("Reason Code");

    end;

}