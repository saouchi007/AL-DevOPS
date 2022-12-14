/// <summary>
/// TableExtension ISA_CustomerExt (ID 50301) extends Record Customer.
/// </summary>
tableextension 50301 ISA_CustomerExt extends Customer
{
    trigger OnAfterModify()
    begin
        Message('A field has been modified sunshine !');
    end;
}