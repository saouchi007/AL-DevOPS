codeunit 82740 "MICA OverDue Buffer Mgt"
{
    Permissions = tabledata "Cust. Ledger Entry" = rm, tabledata "Detailed Cust. Ledg. Entry" = rm;

    [EventSubscriber(ObjectType::Table, DATABASE::"Cust. Ledger Entry", 'OnAfterValidateEvent', 'MICA Due Date (Buffer)', false, false)]
    local procedure OnAfterValidateDueDateBuffer(var Rec: Record "Cust. Ledger Entry")
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        With Rec do begin
            DetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.");
            DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", "Entry No.");
            DetailedCustLedgEntry.ModifyAll("MICA Initial Due Date (Buffer)", "MICA Due Date (Buffer)");
        end;
    end;
}