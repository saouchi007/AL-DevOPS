/// <summary>
/// PageExtension ISA_SalesOrderStats_Ext (ID 50100) extends Record MyTargetPage.
/// </summary>
pageextension 50100 ISA_SalesOrderStats_Ext extends "Sales Order Statistics"
{
    layout
    {
        addafter("TotalAmount2[1]")
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
                ToolTipML = ENU = 'Specifies the amount that includes VAT and Stamp duty', FRA = 'Spécifie le montant incluant la TVA et droit de timbre';
                CaptionML = ENU = 'Amount Including SDuty', FRA = 'Montant includant DTimbre';
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
        ToolBox.ProcessSaleStampDuty(Rec, 'Order')
        else begin
            Rec.ISA_StampDuty := 0;
            Rec.ISA_AmountIncludingStampDuty := 0;
            Rec.Modify();
        end;
    end;


}