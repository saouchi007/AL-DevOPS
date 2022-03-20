/// <summary>
/// PageExtension ISA_StampDuty_SIS (ID 50157) extends Record MyTargetPage.
/// </summary>
pageextension 50157 ISA_StampDuty_SIS extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Total Amount Incl. VAT")
        {
            field(StampDuty; Rec.StampDuty)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Processed with 1% from ''Total Incl. VAT''';
            }
        }
    }

    actions
    {
        addafter(GetPrice)
        {
            action(StDuty)
            {
                Caption = 'Process Stamp Duty';
                Image = SuggestCustomerPayments;
                ApplicationArea = All;

                trigger OnAction()
                var
                    isHandled: Boolean;
                    SalesHeader: Record "Sales Header";
                begin
                    clear(Rec.StampDuty);
                    SalesHeader.get(Rec."Document Type", Rec."Document No.");
                    if SalesHeader."Payment Terms Code" <> 'COD' then begin
                        Error('Oh dear...Payment term code needs to be set to ''COD'' aka ''Cash On Delivery'' under ''Invoice Details''');
                        exit;
                    end;
                    Rec.StampDuty := TotalSalesLine."Amount Including VAT" * 0.01;
                    Rec.Modify();
                    isHandled := true;
                    Message('%1', Rec.StampDuty);
                    //Message('%1', SalesHeader."Payment Terms Code");
                end;
            }
        }
    }

    var
}
