/// <summary>
/// PageExtension ISA_SalesStats_Ext (ID 50116) extends Record MyTargetPage.
/// </summary>
pageextension 50116 ISA_SalesQuoteStats_Ext extends "Sales Statistics"
{
    layout
    {
        addafter(TotalAmount2)
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTipML = ENU = 'Processes 1% of amount including VAT', FRA = 'Calcule 1% du TTC';
                CaptionML = ENU = 'Stamp Duty', FRA = 'Droit de timbre';
            }
            field(ISA_AmountIncludingStampDuty; Rec.ISA_AmountIncludingStampDuty)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTipML = ENU = 'Specifies the amount that includes VAT and Stamp duty', FRA = 'Spécifie le montant incluant la TVA et le droit de timbre';
                CaptionML = ENU = 'Amount Including S.Duty', FRA = 'Montant includant D.Timbre';
            }
        }
    }
    trigger OnOpenPage()
    var
        ToolBox: Codeunit ISA_ToolBox;
        SalandRec: Record "Sales & Receivables Setup";
    begin
        SalandRec.Get();
        if (Rec."Payment Method Code" = SalandRec.ISA_StampDutyPymtMethodsCode) and (SalandRec.ISA_StampDutyPymtMethodsCode <> '') then
            //Rec.SetFilter("Document Type", 'Order');
        ToolBox.ProcessSaleStampDuty(Rec, 'Quote')
        else begin
            Rec.ISA_StampDuty := 0;
            Rec.ISA_AmountIncludingStampDuty := 0;
            Rec.Modify();
        end;

        /*if SalesHeader.FindSet then begin   // used to refresh ISA_AmountIncludingStampDuty on the Sales order list
            //SalesHeader.CalcFields("Amount Including VAT");
            Rec.ISA_AmountIncludingStampDuty := SalesLine."Amount Including VAT" + Rec.ISA_StampDuty;
            Rec.Modify();
            //Message('%1', SalesLine."Amount Including VAT");
            //Message('%1\%2\%3', (SalesHeader."Amount Including VAT" + Rec.ISA_StampDuty), SalesHeader."Amount Including VAT", Rec.ISA_StampDuty);
        end;*/
    end;
}