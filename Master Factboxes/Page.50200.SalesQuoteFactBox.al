/// <summary>
/// Page ISA_SalesQuoteFactbox (ID 50200).
/// </summary>
page 50200 ISA_SalesQuoteFactbox
{
    PageType = CardPart;
    SourceTable = "Sales Line";
    Caption = 'Sales Quote Factbox';
    AboutTitle = 'ISA Sales Quote Factbox';
    AboutText = 'Shows the last invoiced price for the highlighted Sales Quote Line.';

    layout
    {
        area(Content)
        {
            field(LastUnitPrice; ToolBox.ISA_FindLastInvoicedPrice(Rec."Bill-to Customer No.", Rec."No."))
            {
                ApplicationArea = All;
                Caption = 'Last Unit Price';

                trigger OnDrillDown()
                var
                    SalesInvLine: Record "Sales Invoice Line";
                begin
                    SalesInvLine.SetRange("Bill-to Customer No.", Rec."Bill-to Customer No.");
                    SalesInvLine.SetRange("No.", Rec."No.");

                    if SalesInvLine.FindFirst then
                        Page.RunModal(Page::"Posted Sales Invoice Lines", SalesInvLine)
                end;
            }
        }
    }

    var
        ToolBox: Codeunit ISA_ToolBox;

}