/// <summary>
/// PageExtension ISA_SalesQuote_Ext (ID 50201) extends Record MyTargetPage.
/// </summary>
pageextension 50201 ISA_SalesQuote_Ext extends "Sales Quote"
{
    layout
    {
        addfirst(factboxes)
        {
            part(ISA_SalesQuoteFactbox; ISA_SalesQuoteFactbox)
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");


            }
        }
    }


}