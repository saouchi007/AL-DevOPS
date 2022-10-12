/// <summary>
/// PageExtension ISA_LocationCard_Ext (ID 50314) extends Record Location Card.
/// </summary>
pageextension 50314 ISA_ServiceQuote_Ext extends "Service Quote"
{
    layout
    {
        addfirst(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5900),
                              "No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type");
            }
        }
    }
}