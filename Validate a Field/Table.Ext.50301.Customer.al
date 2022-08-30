/// <summary>
/// TableExtension ISA_Customer_Ext (ID 50301) extends Record Customer.
/// </summary>
tableextension 50301 ISA_Customer_Ext extends Customer
{
    fields
    {
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            begin
                Message('OnAfterValidate of the table');
                Rec."Phone No." := '666';
            end;

            trigger OnBeforeValidate()
            begin
                Message('OnBeforeValidate of the table');
                Rec."Phone No." := '666';
            end;
        }
    }


}