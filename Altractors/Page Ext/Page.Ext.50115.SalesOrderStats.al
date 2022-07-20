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
        //SalesLine.SetFilter("Document Type", 'Order');
        SalesLine.CalcSums("Amount Including VAT");
        Message('Header :%1', Rec."Amount Including VAT");
        CheckStampDuty := Rec."Amount Including VAT" * 0.01;
        Message('%1', CheckStampDuty);
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