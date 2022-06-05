/// <summary>
/// PageExtension ISA_ItemChargeAssign (ID 50107) extends Record Item Charge Assignment (Purch).
/// </summary>
pageextension 50107 ISA_ItemChargeAssign extends "Item Charge Assignment (Purch)"
{
    layout
    {
        addafter("<Gross Weight>")
        {
            field(ISA_CustomsFees; CustomsFees)
            {
                ApplicationArea = ItemCharges;
                BlankZero = true;
                Caption = 'Customs Fees';
                DecimalPlaces = 0 : 5;
                Editable = false;
            }
        }

    }
    local procedure UpdateQty()
    begin
        case Rec."Applies-to Doc. Type" of
            Rec."Applies-to Doc. Type"::Order, Rec."Applies-to Doc. Type"::Invoice:
                begin
                    PurchLine.Get(Rec."Applies-to Doc. Type", Rec."Applies-to Doc. No.", Rec."Applies-to Doc. Line No.");
                    CustomsFees := PurchLine.ISA_CustomsFees;
                end;
            Rec."Applies-to Doc. Type"::Receipt:
                begin
                    PurchRcptLine.Get(Rec."Applies-to Doc. No.", Rec."Applies-to Doc. Line No.");
                    CustomsFees := PurchRcptLine.ISA_CustomsFees;
                end;
        end;

        OnAfterUpdateQty(Rec, CustomsFees);
    end;

    local procedure OnAfterUpdateQty(var ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)"; var CustomsFees: Decimal)
    begin
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateQty();
    end;

    var
        CustomsFees: Decimal;
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TransferRcptLine: Record "Transfer Receipt Line";
}