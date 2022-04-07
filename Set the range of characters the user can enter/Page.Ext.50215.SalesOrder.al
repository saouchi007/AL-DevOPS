/// <summary>
/// PageExtension ISA_SalesOrder (ID 50215) extends Record MyTargetPage.
/// </summary>
pageextension 50216 ISA_SalesOrder extends "Sales Order"
{
    layout
    {
        addafter("External Document No.")
        {
            field(ISA_LimitedChars; Rec.ISA_LimitedChars)
            {
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        Rec.ISA_LimitedChars := Rec."Sell-to Customer Name";
        Rec.Modify();
    end;

}