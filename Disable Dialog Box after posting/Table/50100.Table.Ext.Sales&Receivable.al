/// <summary>
/// TableExtension Sales (ID 50100).
/// </summary>
tableextension 50100 SalesReceivable_Ext extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "DisableDialogAfterPosting"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Disable Dilog Box After Posting';
        }
    }
}