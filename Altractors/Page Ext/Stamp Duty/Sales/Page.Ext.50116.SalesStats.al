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
    var
        SalandRec: Record "Sales & Receivables Setup";
    begin
        SalandRec.Get();
        if Rec."Payment Method Code" = SalandRec.ISA_StampDutyPymtMethodsCode then begin
            if Rec."Document Type" = "Document Type"::Quote then
                ProcessStampDuty('Quote')
            else
                if Rec."Document Type" = "Document Type"::Invoice then
                    ProcessStampDuty('Invoice')
                else begin
                    Rec.ISA_StampDuty := 0;
                    Rec.Modify();
                end;
        end;
    end;

    /// <summary>
    /// ProcessStampDuty.
    /// </summary>
    /// <param name="DocType">VAR Text.</param>
    procedure ProcessStampDuty(DocType: Text)
    var
        SalesLine: Record "Sales Line";
        CheckStampDuty: Decimal;
    begin
        if DocType = 'Quote' then begin
            SalesLine.Reset();
            SalesLine.SetFilter("Document Type", 'Quote');
            SalesLine.SetFilter("Document No.", Rec."No.");
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
                    Rec.Modify();
                end;
            end;
        end;

        if DocType = 'Invoice' then begin
            SalesLine.Reset();
            SalesLine.SetFilter("Document Type", 'Invoice');
            SalesLine.SetFilter("Document No.", Rec."No.");
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
                    Rec.Modify();
                end;
            end;
        end;
    end;
}