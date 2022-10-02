/// <summary>
/// PageExtension ISA_SalesOrderStats_Ext (ID 50115) extends Record Sales Order Statistics.
/// </summary>
pageextension 50115 ISA_SalesOrderStats_Ext extends "Sales Order Statistics"
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
        SalandRec: Record "Sales & Receivables Setup";
    begin
        SalandRec.Get();
        if (Rec."Payment Method Code" = SalandRec.ISA_StampDutyPymtMethodsCode) and (SalandRec.ISA_StampDutyPymtMethodsCode <> '') then
            //Rec.SetFilter("Document Type", 'Order');
            ProcessStampDuty()
        else begin
            Rec.ISA_StampDuty := 0;
            Rec.Modify();
        end;
    end;
    /// <summary>
    /// ProcessStampDuty.
    /// </summary>
    procedure ProcessStampDuty()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        CheckStampDuty: Decimal;
    begin
        SalesLine.Reset();
        SalesLine.SetFilter("Document Type", 'Order');
        SalesLine.SetFilter("Document No.", Rec."No.");

        SalesHeader.Reset();
        SalesHeader.SetFilter("Document Type", 'Order');
        SalesHeader.SetFilter("No.", SalesLine."Document No.");


        if SalesLine.FindSet then begin
            SalesLine.CalcSums("Amount Including VAT");
            CheckStampDuty := (SalesLine."Amount Including VAT" * 0.01);


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
                //Rec.ISA_AmountIncludingStampDuty := Rec."Amount Including VAT" + Rec.ISA_StampDuty;
                //Message('%1\%2', Rec."Amount Including VAT", Rec."Amount Including VAT" + Rec.ISA_StampDuty);
                Rec.Modify();
            end;

        end;

        if SalesHeader.FindSet then begin
            //SalesHeader.CalcFields("Amount Including VAT");
            Rec.ISA_AmountIncludingStampDuty := SalesLine."Amount Including VAT" + Rec.ISA_StampDuty;
            Rec.Modify();
            //Message('%1', SalesLine."Amount Including VAT");
            //Message('%1\%2\%3', (SalesHeader."Amount Including VAT" + Rec.ISA_StampDuty), SalesHeader."Amount Including VAT", Rec.ISA_StampDuty);
        end;
    end;

}