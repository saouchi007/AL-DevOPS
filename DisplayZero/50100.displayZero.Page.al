pageextension 50100 DisplayZero extends "Sales Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            BlankZero = false;
        }

        modify("Unit Price")
        {
            BlankZero = false;
        }
    }

}