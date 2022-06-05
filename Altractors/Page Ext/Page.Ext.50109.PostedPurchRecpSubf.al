/// <summary>
/// PageExtension ISA_PostedPurchRcpSubform (ID 50109) extends Record Posted Purchase Rcpt. Subform.
/// </summary>
pageextension 50109 ISA_PostedPurchRcpSubform extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field(ISA_CustomsFees; Rec.ISA_CustomsFees)
            {
                ApplicationArea = all;
            }
        }
    }


}