/// <summary>
/// PageExtension ISA_PaymentTerms_Ext (ID 50308) extends Record Payment Terms.
/// </summary>
pageextension 50308 ISA_PaymentTerms_Ext extends "Payment Terms"
{
    layout
    {
        addafter("Discount Date Calculation")
        {
            field(AlphaBoolean; AlphaBoolean)
            {
                ApplicationArea = All;
            }
            field(BetaBoolean; BetaBoolean)
            {
                ApplicationArea = All;
                Editable = false;

                trigger OnDrillDown()
                begin
                    Message('Booya !');
                end;
            }
        }
    }

    var
        AlphaBoolean: Boolean;
        BetaBoolean: Boolean;
}