page 82760 "MICA Price Recalc. Worksheet"
{
    AdditionalSearchTerms = 'recalculation worksheet, price recalculation';
    ApplicationArea = All;
    Caption = 'Price Recalculation Worksheet';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "MICA Price Recalc. Worksheet";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales order no.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales order date.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer No. from sales order.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name';
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies price group for customer.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number from sales order.';
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the promised delivery date of sales order, taken from sales order line.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item for which sales prices are being changed or set up.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description from item.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location from sales lines.';
                }
                field("MICA Status"; Rec."MICA Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status for which sales line can be suggested new sales price.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity from sales order line.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current, old unit price.';
                }
                field("New Unit Price"; Rec."New Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the new unit price which will be applied.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                Image = Action;
                action("Suggest Sales Lines on Wksh.")
                {
                    ApplicationArea = All;
                    Caption = 'Suggest Sales Lines on Worksheet';
                    Ellipsis = true;
                    Image = SuggestSalesPrice;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create suggestions for changing the agreed item unit prices. When the batch job has completed, you can see the result in the Price Recalc. Worksheet window. You can also use the Suggest Sales Price on Worksheet batch job to create suggestions for new sales prices.';

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"MICA Sugg. Price Recalc. Wksh.", true, false);
                    end;
                }
                action("Implement Price Change")
                {
                    ApplicationArea = All;
                    Caption = 'Implement Price Change';
                    Ellipsis = true;
                    Image = ImplementPriceChange;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ToolTip = 'Update the new prices in the Sales Order Lines with the ones in the Price Recalc. Worksheet window. Update Price Recalc. Entries for every line in Price Recalc. Worksheet.';

                    trigger OnAction()
                    var
                        MICAPriceRecalcWorksheet: Record "MICA Price Recalc. Worksheet";
                    begin
                        MICAPriceRecalcWorksheet := Rec;
                        CurrPage.SetSelectionFilter(MICAPriceRecalcWorksheet);
                        Report.Run(Report::"MICA Implement Price Changes", true, false, MICAPriceRecalcWorksheet);
                    end;
                }
                action("Export Worksheet in Excel")
                {
                    ApplicationArea = All;
                    Caption = 'Export Worksheet in Excel';
                    Ellipsis = true;
                    Image = ExportToExcel;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ToolTip = 'Export content of the worksheet in Excel.';

                    trigger OnAction()
                    var
                        RecalcWkshToExcel: Codeunit "MICA Recalc. Wksh. To Excel";
                        NothingToExportMsg: Label 'There are no data for export';
                    begin
                        Clear(RecalcWkshToExcel);

                        RecalcWkshToExcel.InitializeRequestFromWksh(0);
                        if not RecalcWkshToExcel.ExportWkshToExcel() then
                            Message(NothingToExportMsg);
                    end;
                }
            }
        }
    }
}