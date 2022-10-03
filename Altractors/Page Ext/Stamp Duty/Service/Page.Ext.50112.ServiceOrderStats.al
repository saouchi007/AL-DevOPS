/// <summary>
/// PageExtension ISA_ServiceOrderStats_Ext (ID 50112) extends Record Service Order Statistics.
/// </summary>
pageextension 50112 ISA_ServiceOrderStats_Ext extends "Service Order Statistics"
{
    layout
    {
        addafter("Total Incl. VAT_General")
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
                Visible = true;
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
        SalandRec: Record "Sales & Receivables Setup";
    begin
        SalandRec.Get();
        if (Rec."Payment Method Code" = SalandRec.ISA_StampDutyPymtMethodsCode) and (SalandRec.ISA_StampDutyPymtMethodsCode <> '') then
            ProcessStampDuty()
        else begin
            Rec.ISA_StampDuty := 0;
            Rec.ISA_AmountIncludingStampDuty := 0;
            Rec.Modify();
        end;
    end;
    /// <summary>
    /// ProcessStampDuty.
    /// </summary>
    procedure ProcessStampDuty()
    var
        ServiceLine: Record "Service Line";
        CheckStampDuty: Decimal;
    begin
        ServiceLine.Reset();
        ServiceLine.SetFilter("Document Type", 'Order');
        ServiceLine.SetFilter("Document No.", Rec."No.");

        if ServiceLine.FindSet then begin
            ServiceLine.CalcSums("Amount Including VAT");
            CheckStampDuty := ServiceLine."Amount Including VAT" * 0.01;
        end;
        if CheckStampDuty < 5 then begin
            Rec.ISA_StampDuty := 5;
            Rec.Modify();
        end;
        if CheckStampDuty > 2500 then begin
            Rec.ISA_StampDuty := 2500;
            Rec.Modify();
        end;
        if (CheckStampDuty > 5) and (CheckStampDuty < 2500) then begin
            Rec.ISA_StampDuty := Round(CheckStampDuty, 0.01, '=');
            Rec.Modify();
        end;
        //Rec.ISA_StampDuty := ServiceLine."Amount Including VAT" * 0.01;
        //TotalAmountIncVAT := ServiceLine."Amount Including VAT";

        if Rec.FindSet then begin
            //SalesHeader.CalcFields("Amount Including VAT");
            Rec.ISA_AmountIncludingStampDuty := ServiceLine."Amount Including VAT" + Rec.ISA_StampDuty;
            Rec.Modify();
            //Message('%1', SalesLine."Amount Including VAT");
            //Message('%1\%2\%3', (SalesHeader."Amount Including VAT" + Rec.ISA_StampDuty), SalesHeader."Amount Including VAT", Rec.ISA_StampDuty);
        end;
    end;


}