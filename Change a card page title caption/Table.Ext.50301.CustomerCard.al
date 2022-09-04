/// <summary>
/// TableExtension ISA_CustomerCard (ID 50301) extends Record Customer.
/// </summary>
tableextension 50304 ISA_CustomerCard extends Customer
{
    DataCaptionFields = "No.","Salesperson Code", "Payment Terms Code";

//Note:
//Although you can also set DataCaptionFields property in a new Page, it cannot be set in PageExtension.
}