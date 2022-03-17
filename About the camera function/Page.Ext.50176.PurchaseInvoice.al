/// <summary>
/// PageExtension ISA_PurchaseInvoice_Ext (ID 50176) extends Record MyTargetPage.
/// </summary>
pageextension 50176 ISA_PurchaseInvoice_Ext extends "Purchase Invoice"
{
    layout
    {
        addbefore(IncomingDocAttachFactBox)
        {
            part(PurchaseInvoicePicture; PurchaseInvoicePicture)
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                                                "No." = field("No.");
            }
        }
    }


}