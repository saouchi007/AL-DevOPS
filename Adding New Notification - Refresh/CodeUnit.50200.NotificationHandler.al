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
    /// <param name="ResponsabilityCenterNotification">Notification.</param>
    procedure OpenCustomersList(ResponsabilityCenterNotification: Notification)
    var
        CurrentRespCenter: Text;
        RespCenterFilter: Text;
        Customers: Record Customer;
    begin
        RespCenterFilter := ResponsabilityCenterNotification.GetData(CurrentRespCenter);
        Customers.Reset();
        Customers.SetRange("Responsibility Center", RespCenterFilter);
        Page.Run(22, Customers);
    end;

}