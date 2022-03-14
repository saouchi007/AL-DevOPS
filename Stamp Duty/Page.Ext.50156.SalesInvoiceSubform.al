/// <summary>
/// PageExtension ISA_DutyStamp (ID 50156) extends Record Sales Invoice.
/// </summary>
pageextension 50156 ISA_DutyStamp extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Total Amount Incl. VAT")
        {
            field(ISA_DutyStamp; Rec.ISA_DutyStamp)
            {
                ApplicationArea = All;
                ToolTip = 'Stamp Duty is processed from ''Total Amount Incl. VAT''';
            }
        }
    }


    actions
    {
        addafter(GetPrice)
        {
            action(SD)
            {
                ApplicationArea = All;
                Caption = 'Stamp Duty';
                Image = InsertStartingFee;

                trigger OnAction()
                var
                    ProcAmnt: Decimal;
                    set: Boolean;
                begin
                    Rec.ISA_DutyStamp := 0;
                    ProcAmnt := 0;
                    Rec.SetRange("Line Amount");
                    if Rec.Find('-') and set = false then begin
                        repeat
                            ProcAmnt += Rec."Line Amount";
                            Rec.ISA_DutyStamp := ((ProcAmnt * 0.19) + ProcAmnt) * 0.01;
                        until Rec.Next = 0;
                        set := true;
                    end;
                    Rec.Modify();
                end;
            }
        }
    }

}