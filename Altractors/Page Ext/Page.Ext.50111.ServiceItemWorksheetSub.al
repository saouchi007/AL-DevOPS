
/// <summary>
/// TableExtension ISA_Service (ID 50108) extends Record Service Line.
/// </summary>
pageextension 50108 ISA_SvcItemWksheetSub_Ext extends "Service Item Worksheet Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
                Visible = true;
                ApplicationArea = all;
            }
        }
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
            }
        }
    }
    actions
    {
        addafter("F&unctions")
        {
            action(StampDuty)
            {
                Caption = 'Stamp Duty';
                ApplicationArea = All;
                Image = ProductDesign;
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
    begin
        TotalAmountIncVAT := 0;
        ServiceLine.Reset();
        ServiceLine.CopyFilters(Rec);
        ServiceLine.CalcSums("Amount Including VAT");
        Rec.ISA_StampDuty := ServiceLine."Amount Including VAT";
        TotalAmountIncVAT := ServiceLine."Amount Including VAT";
        NbOfLines := ServiceLine.Count;
        Rec.Modify();
        //Message('%1 - NB = %2', TotalAmountIncVAT, NbOfLines);
    end;

    var
        TotalAmountIncVAT: Decimal;
        NbOfLines: Integer;


}

