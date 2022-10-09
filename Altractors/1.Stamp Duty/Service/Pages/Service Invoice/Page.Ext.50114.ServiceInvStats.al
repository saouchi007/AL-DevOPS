/// <summary>
/// PageExtension ISA_ServiceInvoice_Ext (ID 50114).
/// </summary>
pageextension 50114 ISA_ServiceStats_Ext extends "Service Invoice Statistics"
{
    layout
    {
        addafter(AmountInclVAT)
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

        /*addafter("Currency Code")
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
                ToolTipML = ENU = 'Processes 1% of amount including VAT', FRA = 'Calcule 1% du TTC';
            }
        }*/
        /*modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Payment Method Code" = 'COD' then
                    ProcessStampDuty()
                else
                    Rec.ISA_StampDuty := 0;
            end;
        }*/
    }

    actions
    {
        /*addafter("P&osting")
        {
            action(PorcessStampDuty)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Process Stamp Duty', FRA = 'Calcule du droit de timbre';
                Image = PostTaxInvoice;
                ToolTipML = ENU = 'Allows updating the ''Stamp Duty''', FRA = 'Permet de mettre à jour le droit de timbre';
                trigger OnAction()
                var
                    PaymtCodeLbl: Label '''Payment Terms Code'' must be set to ''COD aka ''Cash On Delivery''''';
                begin
                    if Rec."Payment Terms Code" <> 'COD' then
                        Error(PaymtCodeLbl);
                    ProcessStampDuty();
                end;
            }
        }*/
    }
    /// <summary>
    /// ProcessStampDuty.
    /// </summary>
    /*procedure ProcessStampDuty()
    var
        ServiceLine: Record "Service Line";
        CheckStampDuty: Decimal;
    begin
        ServiceLine.Reset();
        ServiceLine.SetFilter("Document No.", Rec."No.");
        ServiceLine.CalcSums("Amount Including VAT");
        CheckStampDuty := ServiceLine."Amount Including VAT" * 0.01;
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
    end;*/
}