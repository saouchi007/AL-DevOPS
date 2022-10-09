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
                CaptionML = ENU = 'Customs Fees', FRA = 'Droit de douane';
                ToolTipML = ENU = 'Specifies customs fees for the item', FRA = 'Spécifie le droit de douane de l''article';
            }
        }
    }


}