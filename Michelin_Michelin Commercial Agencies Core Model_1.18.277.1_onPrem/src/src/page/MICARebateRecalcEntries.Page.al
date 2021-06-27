page 82763 "MICA Rebate Recalc. Entries"
{
    AdditionalSearchTerms = 'rebate entries, recalculation entries';
    ApplicationArea = All;
    Caption = 'Rebate Recalculation Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "MICA Rebate Recalc. Entry";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the rebate entry';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales order no. in the rebate entry';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales order date in the rebate entry.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer no. from in the rebate entry.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Customer Discount Group"; Rec."Customer Discount Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies discount group for customer in the rebate entry.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales line number in the rebate entry.';
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the promised delivery date of sales order in the rebate entry.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item for which sales rebate are being changed or set up.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description from item in the rebate entry.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location in the rebate entry.';
                }
                field("MICA Status"; Rec."MICA Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales line status in the rebate entry.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity in the rebate entry.';
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the old rebate in the rebate entry.';
                }
                field("New Discount %"; Rec."New Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the new rebate which was applied in the rebate entry.';
                }
                field("Recalculation Date"; Rec."Recalculation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of recalculation new sales rebate.';
                }
            }
        }
    }
}