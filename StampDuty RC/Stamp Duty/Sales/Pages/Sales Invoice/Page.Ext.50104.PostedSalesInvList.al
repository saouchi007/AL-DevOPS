/// <summary>
/// PageExtension ISA_PostedSalesInvoice_Ext (ID 50104) extends Record Posted Sales Invoices.
/// </summary>
pageextension 50104 ISA_PostedSalesInvoice_Ext extends "Posted Sales Invoices"
{

    layout
    {
        addafter("Amount Including VAT")
        {
            field(ISA_AmountIncludingStampDuty; Rec.ISA_AmountIncludingStampDuty)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTipML = ENU = 'Specifies the amount that includes VAT and Stamp duty', FRA = 'Spécifie le montant incluant la TVA et le droit de timbre';
                CaptionML = ENU = 'Amount Including S.Duty', FRA = 'Montant includant D.Timbre';
            }
        }

    }

    trigger OnAfterGetRecord()
    begin
        if (Rec."Remaining Amount" > 0) or (Rec.Closed = false) then begin
            Rec."Remaining Amount" += Rec.ISA_StampDuty;
            Rec."Amount Including VAT" += Rec.ISA_StampDuty;
            Rec.Modify();
        end;
    end;
}