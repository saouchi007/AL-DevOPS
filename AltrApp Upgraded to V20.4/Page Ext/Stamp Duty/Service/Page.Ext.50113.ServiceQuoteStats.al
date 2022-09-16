/// <summary>
/// PageExtension ISA_ServiceQuoteExt (ID 50113) extends Record Service Quote.
/// </summary>
pageextension 50113 ISA_ServiceQuoteExt extends "Service Statistics"
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
        ServiceLine: Record "Service Line";
        CheckStampDuty: Decimal;
    begin
        ServiceLine.Reset();
        ServiceLine.SetFilter("Document Type", 'Quote');
        ServiceLine.SetFilter("Document No.", Rec."No.");

        if ServiceLine.FindSet then begin
            ServiceLine.CalcSums("Amount Including VAT");
            CheckStampDuty := ServiceLine.ISA_StampDuty;
        end;
        /*
                if CheckStampDuty <> Rec.ISA_StampDuty then begin
                    ServiceLine.ISA_StampDuty := Rec.ISA_StampDuty;
                    ServiceLine.Modify();
                end;
                    ServiceLine.CalcSums("Amount Including VAT");*/
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
    end;



}