/// <summary>
/// PageExtension SalesSetup_Ext (ID 50100) extends Record Sales & Receivables Setup.
/// </summary>
pageextension 50100 SalesSetup_Ext extends "Sales & Receivables Setup"
{
    layout
    {
        addfirst(General)
        {
            field(DisableDialogAfterPosting; Rec.DisableDialogAfterPosting)
            {
                ApplicationArea = All;
            }
        }

    }


}