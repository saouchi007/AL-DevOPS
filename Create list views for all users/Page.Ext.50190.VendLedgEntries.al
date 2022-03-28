/// <summary>
/// PageExtension ISA_CustLedgEntries_Ext (ID 50190) extends Record Customer Ledger Entries.
/// </summary>
pageextension 50190 ISA_VendLedgEntries_Ext extends "Vendor Ledger Entries"
{
    views
    {
        addfirst
        {
            view(AddedFromVSCode)
            {
                Caption = 'Entries Between 01/01/24 and 01/14/24';
                Filters = where("Posting Date" = filter('010124..011424'),
                                "Vendor No." = const('20000'));
                //Open = const(false));
            }
        }
    }
}