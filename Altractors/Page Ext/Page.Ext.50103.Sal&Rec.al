/// <summary>
/// PageExtension ISA_SalesReceivable (ID 50231) extends Record MyTargetPage.
/// </summary>
pageextension 50103 ISA_SalesReceivable extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field(ISA_StampDuty_GLA; Rec.ISA_StampDuty_GLA)
            {
                ApplicationArea = All;
                ToolTipML = ENU = 'Sepcifies the G/L Account to be used to post ''Stamp Duty'' entries on Sales Orders',
                FRA = 'Représente le compte général utilisé par le ''Droit de timbre'' ';
                trigger OnValidate()
                begin
                    Rec.Modify();
                end;
            }
        }
    }
}