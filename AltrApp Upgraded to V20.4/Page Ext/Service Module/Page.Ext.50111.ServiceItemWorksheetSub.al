
/// <summary>
/// TableExtension ISA_Service (ID 50108) extends Record Service Line.
/// </summary>
pageextension 50108 ISA_SvcItemWksheetSub_Ext extends "Service Item Worksheet Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                // ProcessStampDuty();
            end;
        }
        addafter("Location Code")
        {
            field("Unit Cost "; Rec."Unit Cost (LCY)")
            {
                Visible = true;
                ApplicationArea = all;
            }
        }

        /* Stamp Duty has been implemented on Stats page of service order (which applies to service quote, order, )
        addafter(Control1)
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
            }

        }
        addafter(ISA_StampDuty)
        {
            field(ISA_PayMethodCode; Rec.ISA_PayMethodCode)
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    ProcessStampDuty();
                end;
            }
        }*/

    }
    actions
    {
        addlast("F&unctions")
        {
            action(StampDuty)
            {
                CaptionML = ENU = 'Stamp Duty', FRA = 'Calcul du droit de timbre';
                ToolTipML = ENU = 'Processes stamp duty', FRA = 'Pour calculer le droit de timbre';
                ApplicationArea = All;
                Image = ProjectExpense;
                trigger OnAction()
                begin
                    ProcessStampDuty();
                end;
            }
        }
    }
    /// <summary>
    /// ProcessStampDuty.
    /// </summary>
    procedure ProcessStampDuty()
    var
        ServiceLine: Record "Service Line";
        CheckStampDuty: Decimal;
    begin
        if Rec.ISA_PayMethodCode = 'COD' then begin
            ServiceLine.Reset();
            ServiceLine.CopyFilters(Rec);
            ServiceLine.CalcSums("Amount Including VAT");
            CheckStampDuty := ServiceLine."Amount Including VAT" * 0.01;
            //Message('%1 - %2', ServiceLine."Amount Including VAT", CheckStampDuty);
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
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.ISA_PayMethodCode := '';
    end;
}

