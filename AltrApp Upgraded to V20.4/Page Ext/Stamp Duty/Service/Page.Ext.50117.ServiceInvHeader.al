/// <summary>
/// PageExtension ISA_ServiceInvoiceHeader_Ext (ID 50117) extends Record Posted Service Invoice.
/// </summary>
pageextension 50117 ISA_ServiceInvoiceStats_Ext extends "Posted Service Invoice"
{
    layout
    {
        addafter("Bill-to Contact No.")
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTipML = ENU = 'Processes 1% of amount including VAT', FRA = 'Calcule 1% du TTC';
                CaptionML = ENU = 'Stamp Duty', FRA = 'Droit de timbre';
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
            Rec.Modify();
        end;
    end;

    /// <summary>
    /// ProcessStampDuty.
    /// </summary>
    procedure ProcessStampDuty()
    var
        ServiceInvLine: Record "Service Invoice Line";
        CheckStampDuty: Decimal;
    begin
        ServiceInvLine.Reset();
        ServiceInvLine.SetFilter("Document No.", Rec."No.");

        if ServiceInvLine.FindSet then begin
            ServiceInvLine.CalcSums("Amount Including VAT");
            CheckStampDuty := ServiceInvLine."Amount Including VAT" * 0.01;

            if CheckStampDuty < 5 then begin
                Rec.ISA_StampDuty := 5;
                Rec.Modify();
            end;
        end;
        if CheckStampDuty > 2500 then begin
            Rec.ISA_StampDuty := 2500;
            Rec.Modify();
        end;
        if (CheckStampDuty > 5) and (CheckStampDuty < 2500) then begin
            Rec.ISA_StampDuty := Round(CheckStampDuty, 0.01, '=');
            Rec.Modify();
        end;

    end;
}