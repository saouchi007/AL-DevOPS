/// <summary>
/// PageExtension ISA_SalesRecSetup_Ext (ID 50159).
/// </summary>
pageextension 50160 ISA_SalesRecSetup_Ext extends "Sales & Receivables Setup"
{
    layout
    {
        addfirst("Background Posting")
        {
            field(ISA_DutyStampGLA; Rec.ISA_DutyStampGLA)
            {
                Editable = true;
                ApplicationArea = All;
                ToolTip = 'Specifies the GL Account used to post entries on Sales Invoices, ''Direct Posting'' must be activated for the GLA';
            }
        }
    }
    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}