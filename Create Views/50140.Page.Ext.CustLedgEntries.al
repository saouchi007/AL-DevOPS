/// <summary>
/// PageExtension CustomerLedgerEntries_Ext (ID 50140) extends Record Customer Ledger Entries.
/// </summary>
pageextension 50140 CustomerLedgerEntries_Ext extends "Customer Ledger Entries"
{
    views
    {
        addfirst
        {
            view(CustomerWithDates)
            {
                Caption = 'Customer 2k';
                Filters = where("Posting Date" = filter('010123..123123'),
                Open = const(false));
            }
        }
    }
}