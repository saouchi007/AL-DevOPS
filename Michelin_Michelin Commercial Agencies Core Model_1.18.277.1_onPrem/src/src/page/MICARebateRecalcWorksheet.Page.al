page 82761 "MICA Rebate Recalc. Worksheet"
{
    AdditionalSearchTerms = 'recalculation worksheet, rebate recalculation';
    ApplicationArea = All;
    Caption = 'Rebate Recalculation Worksheet';
    DelayedInsert = true;
    SaveValues = true;
    SourceTable = "MICA Rebate Recalc. Worksheet";
    PageType = Worksheet;
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
                field("Customer Discount Group"; Rec."Customer Discount Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies discount group for customer.';
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
                    ToolTip = 'Specifies the number of the item for which sales rebate are being changed or set up.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description from item.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location from sales line.';
                }
                field("MICA Status"; Rec."MICA Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status for which sales line can be suggested new sales rebate.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity from sales order line.';
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current, old unit rebate.';
                }
                field("New Discount %"; Rec."New Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the new rebate which will be applied.';
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
                    ToolTip = 'Create suggestions for changing the agreed item rebates. When the batch job has completed, you can see the result in the Rebate Recalc. Worksheet window. You can also use the Suggest Sales Price on Worksheet batch job to create suggestions for new sales rebates.';

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"MICA Sugg. Reb. Recalc. Wksh.", true, false);
                    end;
                }
                action("Implement Rebate Change")
                {
                    ApplicationArea = All;
                    Caption = 'Implement Rebate Change';
                    Ellipsis = true;
                    Image = ImplementPriceChange;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ToolTip = 'Update the new rebates in the Sales Order Lines with the ones in the Rebate Recalc. Worksheet window. Update Rebate Recalc. Entries for every line in Rebate Recalc. Worksheet.';

                    trigger OnAction()
                    var
                        MICARebateRecalcWorksheet: Record "MICA Rebate Recalc. Worksheet";
                    begin
                        MICARebateRecalcWorksheet := Rec;
                        CurrPage.SetSelectionFilter(MICARebateRecalcWorksheet);
                        Report.Run(Report::"MICA Implement Rebate Changes", true, false, MICARebateRecalcWorksheet);
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

                        RecalcWkshToExcel.InitializeRequestFromWksh(1);
                        if not RecalcWkshToExcel.ExportWkshToExcel() then
                            Message(NothingToExportMsg);
                    end;
                }
            }
        }
    }
}