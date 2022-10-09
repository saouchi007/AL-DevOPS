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
        SvcMgmt: Record "Service Mgt. Setup";
    begin
        SvcMgmt.Get();
        if (Rec."Payment Method Code" = SvcMgmt.ISA_StampDutyPymtMethodsCode) and (SvcMgmt.ISA_StampDutyPymtMethodsCode <> '') then
            ToolBox.ProcessServiceStampDuty(Rec, 'Quote')
        else begin
            Rec.ISA_StampDuty := 0;
            Rec.ISA_AmountIncludingStampDuty := 0;
            Rec.Modify();
        end;
    end;
}