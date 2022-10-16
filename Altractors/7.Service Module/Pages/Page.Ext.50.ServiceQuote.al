/// <summary>
/// PageExtension ISA_ServiceQuote_Ext (ID 50102) extends Record Service Quote.
/// </summary>
pageextension 50102 ISA_ServiceQuote_Ext extends "Service Quote"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5900),
                              "No." = FIELD("No."),
                              "Document Type" = field("Document Type");
            }
        }
    }
}