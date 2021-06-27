page 83001 "MICA Rebate Pool Dtld. Entries"
{
    AdditionalSearchTerms = 'rebate detail pool entries, pool detail entries';
    PageType = List;
    ApplicationArea = All;
    Caption = 'Rebate Pool Detail Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    SourceTable = "MICA Rebate Pool Dtld. Entry";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Pool Detail Entry No.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Entry Posting Date.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Pool Entry Type.';
                }
                field("Rebate Pool Entry No."; Rec."Rebate Pool Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Pool Entry No.';
                }
                field("Rebate Code"; Rec."Rebate Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Setup Code.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Customer No.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Product Line.';
                }
                field("Business Line"; Rec."Business Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Business Line.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Pool Detail Entry Amount.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoice No.';
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoice Line No.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Order No. for Entry Type = Invoice.';
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Order Line No. for Entry Type = Invoice.';
                }
            }
        }
    }
}