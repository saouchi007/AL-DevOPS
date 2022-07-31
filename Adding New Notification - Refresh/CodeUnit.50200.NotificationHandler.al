/// <summary>
/// Codeunit ISA_NotificationHandler (ID 50200).
/// </summary>
codeunit 50200 ISA_NotificationHandler
{

    /// <summary>
    /// OpenMySettings.
    /// </summary>
    /// <param name="PostingDateNotification">Notification.</param>
    procedure OpenMySettings(PostingDateNotification: Notification)
    begin
        Page.Run(9204);
    end;

    /// <summary>
    /// OpenCustLedgerEntries.
    /// </summary>
    /// <param name="CreditBalanceNotification">Notification.</param>
    procedure OpenCustLedgerEntries(CreditBalanceNotification: Notification)
    var
        CustNumber: Text;
        CustNo: Text;
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustNo := CreditBalanceNotification.GetData(CustNumber);
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", CustNo);
        CustLedgerEntry.SetRange(Open, true);
        Page.Run(25, CustLedgerEntry);
    end;

}