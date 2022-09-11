/// <summary>
/// PageExtension ISA_LocationCard_Ext (ID 50314) extends Record Location Card.
/// </summary>
pageextension 50314 ISA_ServiceQuote_Ext extends "Service Quote"
{
    layout
    {
        addfirst(factboxes)
        {
            part("Documents Attachment"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(5900),
                              "No." = field("No."),
                              "Document Type" = field("Document Type");
                Visible = true;
            }
        }
    }

}