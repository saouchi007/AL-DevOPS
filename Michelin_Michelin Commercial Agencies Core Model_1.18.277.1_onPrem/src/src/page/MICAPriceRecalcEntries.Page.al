page 82762 "MICA Price Recalc. Entries"
{
    AdditionalSearchTerms = 'price entries, recalculation entries';
    ApplicationArea = All;
    Caption = 'Price Recalculation Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "MICA Price Recalc. Entry";
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
                    ToolTip = 'Specifies the number of price entry';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales order no. in price entry';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales order date.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer no. in price entry.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
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
                    ToolTip = 'Specifies the promised delivery date of sales order.';
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
                    ToolTip = 'Specifies the location in price entry.';
                }
                field("MICA Status"; Rec."MICA Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales line status price entry.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity in price entry.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the old unit price in price entry.';
                }
                field("New Unit Price"; Rec."New Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the new unit price which was applied, in price entry.';
                }
                field("Recalculation Date"; Rec."Recalculation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of recalculation new sales price.';
                }
            }
        }
    }
}