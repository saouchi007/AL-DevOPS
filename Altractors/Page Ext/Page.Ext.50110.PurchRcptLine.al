/// <summary>
/// PageExtension ISA_PurchRecptLine (ID 50110) extends Record Purch. Receipt Lines.
/// </summary>
pageextension 50110 ISA_PurchRecptLine extends "Purch. Receipt Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field(ISA_CustomsFees; Rec.ISA_CustomsFees)
            {
                ApplicationArea = All;
            }
        }
    }


}