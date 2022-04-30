/// <summary>
/// PageExtension ISA_SalesReceivable (ID 50231) extends Record MyTargetPage.
/// </summary>
pageextension 50231 ISA_SalesReceivable extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field(ISA_StampDuty_GLA; Rec.ISA_StampDuty_GLA)
            {
                ApplicationArea = All;
                ToolTip = 'Sepcifies the G/L Account to be used to post ''Stamp Duty'' entries on Sales Orders';
            }
        }
    }


}