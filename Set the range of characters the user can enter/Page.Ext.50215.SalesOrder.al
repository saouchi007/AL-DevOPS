/// <summary>
/// PageExtension ISA_SalesOrder (ID 50215) extends Record Sales Order.
/// </summary>
pageextension 50215 ISA_SalesOrder extends "Sales Order"
{
    layout
    {
        addafter("External Document No.")
        {
            field(ISA_LimitedChars; Rec.ISA_LimitedChars)
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        /*
Even if the format cannot be violated by the user, it can nonetheless be set using AL
        */
        Rec.ISA_LimitedChars := Rec."Sell-to Customer Name";
        Rec.Modify();

    end;

}