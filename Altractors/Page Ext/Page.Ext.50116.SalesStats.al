/// <summary>
/// PageExtension ISA_SalesStats_Ext (ID 50116) extends Record MyTargetPage.
/// </summary>
pageextension 50116 ISA_SalesStats_Ext extends "Sales Statistics"
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
        }
    }

    trigger OnOpenPage()
    begin
        ProcessStampDuty();
    end;
    /// <summary>
    /// ProcessStampDuty.
    /// </summary>
    procedure ProcessStampDuty()
    var
        SalesLine: Record "Sales Line";
        CheckStampDuty: Decimal;
    begin
        SalesLine.Reset();
        SalesLine.SetFilter("Document No.", Rec."No.");
        SalesLine.CalcSums("Amount Including VAT");
        CheckStampDuty := SalesLine."Amount Including VAT" * 0.01;
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
    end;
}