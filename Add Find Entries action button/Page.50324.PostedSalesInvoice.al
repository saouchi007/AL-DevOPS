/// <summary>
/// Page ISA_PostedSalesInvoice (ID 50324).
/// </summary>
page 50324 ISA_PostedSalesInvoice
{
    AdditionalSearchTerms = 'posted bill';
    ApplicationArea = Basic, Sutie;
    UsageCategory = History;
    Caption = 'ISA Posted Sales Invoice';
    CardPageId = "Posted Sales Invoice";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New, Process, Report, Invoice, Navigate, Correct, Print/Send';
    RefreshOnActivate = true;
    SourceTable = "Sales Invoice Header";
    SourceTableView = sorting("Posting Date")
                      order(descending);
    QueryCategory = 'Posted Sales Invoice';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the customer the invoice concerns.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer''s name.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the posted sales invoice must be paid.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount on the sales invoice excluding VAT.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount on the sales invoice including VAT.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount that remains to be paid for the posted sales invoice.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the location from which the items were shipped.';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Navigate)
            {
                Caption = 'Find Entries...';
                ApplicationArea = All;
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    NavigatePage.SetDoc(Rec."Posting Date", Rec."No.");
                    NavigatePage.Run();
                end;
            }
        }
    }

    var
        NavigatePage: Page Navigate;
}
