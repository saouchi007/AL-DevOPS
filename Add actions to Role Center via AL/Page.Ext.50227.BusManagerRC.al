/// <summary>
/// PageExtension ISA_BusinessManager_Ext (ID 50226) extends Record MyTargetPage.
/// </summary>
pageextension 50227 ISA_BusinessManager_Ext extends "Business Manager Role Center"
{
    actions
    {
        addafter("Chart of Accounts")
        {
            action(SalesLines)
            {
                Caption = 'Sales Lines';
                ApplicationArea = All;
                RunObject = page "Sales Lines";
            }
            action(PostedSalesInvoiceLines)
            {
                Caption = 'Posted Sales Invoice Lines';
                ApplicationArea = All;
                RunObject = page "Posted Sales Invoice Lines";
            }
        }
    }

    var
        myInt: Integer;
}