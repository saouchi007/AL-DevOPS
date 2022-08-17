/// <summary>
/// TableExtension ISA_CustomerCard (ID 50308) extends Record Customer.
/// </summary>
tableextension 50308 ISA_SalesHeader_Ext extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                Customer.Get(Rec."Sell-to Customer No.");
                if Customer."Credit Limit (LCY)" = 0 then
                    Error('Credit limit is mandatory for customers !');
            end;
        }
    }

}