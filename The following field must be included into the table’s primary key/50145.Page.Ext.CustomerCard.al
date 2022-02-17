/// <summary>
/// PageExtension CustomerCard_Ext (ID 50145) extends Record Customer Card.
/// </summary>
pageextension 50145 CustomerCard_Ext extends "Customer Card"
{


    layout
    {
        addafter("Document Sending Profile")
        {
            field(VendorName; Rec.VendorName)
            {
                Caption = 'Vendor Name';
                ApplicationArea = All;

            }
            field(VendorNo; Rec.VendorNo)
            {
                Caption = 'Vendor No.';
                ApplicationArea = All;
            }
        }
    }
}