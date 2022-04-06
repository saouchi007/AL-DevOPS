/// <summary>
/// Codeunit ISA_NotificationActionHandler (ID 50200).
/// </summary>
codeunit 50200 ISA_NotificationActionHandler
{
    /// <summary>
    /// OpenMySettings.
    /// </summary>
    /// <param name="PostingDateNotification">Notification.</param>
    procedure OpenMySettings(PostingDateNotification: Notification)
    begin
        Page.Run(9176); // This ID seems to work as well : 9204
    end;

    /// <summary>
    /// OpenCustomerLedgerEntries.
    /// </summary>
    /// <param name="CreditBalanceNotification">Notification.</param>
    procedure OpenCustomerLedgerEntries(CreditBalanceNotification: Notification)
    var
        CustNumber: Text;
        CustNo: Text;
        CustLedgEntryRec: Record "Cust. Ledger Entry";
    begin
        CustNo := CreditBalanceNotification.GetData(CustNumber);
        CustLedgEntryRec.Reset();
        CustLedgEntryRec.SetRange("Customer No.", CustNo);
        CustLedgEntryRec.SetRange(Open, true);
        Page.Run(25, CustLedgEntryRec);
    end;
}