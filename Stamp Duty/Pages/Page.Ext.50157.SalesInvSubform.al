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
            }
        }
    }

    actions
    {
        addafter("F&unctions")
        {
            action(StDuty)
            {
                Caption = 'Process Stamp Duty';
                Image = SuggestCustomerPayments;
                ApplicationArea = All;

                trigger OnAction()
                var
                    TotalAmountInclVAT: Decimal;
                    isHandled: Boolean;
                begin
                    Rec.StampDuty := 0;
                    Rec.StampDuty := TotalSalesLine."Amount Including VAT" * 0.01;
                end;
            }
        }
    }

    var
}