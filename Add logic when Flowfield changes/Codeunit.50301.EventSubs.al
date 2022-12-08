codeunit 50301 ISA_EventSub
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterCustLedgEntryInsert', '', true, true)]
    local procedure OnAfterCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        CustRec: Record Customer;
    begin
        if CustRec.Get(CustLedgerEntry."Customer No.") then begin
            CustRec.CalcFields("Balance (LCY)");
            if CustRec.Blocked = CustRec.Blocked::" " then
                Message('Cleared');
            CustRec.Blocked := CustRec.Blocked::All;
            CustRec.Modify();
        end;
    end;

    //I post a SO in order to trigger "Balance LCY" recalculation which would trigger inserting a record in table Customer with event OnAfterCustLedgEntryInsert
}