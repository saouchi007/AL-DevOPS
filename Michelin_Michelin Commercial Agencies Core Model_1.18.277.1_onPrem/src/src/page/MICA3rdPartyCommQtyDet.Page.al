page 82921 "MICA 3rd Party Comm. Qty. Det."
{

    ApplicationArea = All;
    Caption = '3rd Party Comm. Qty. Det. List';
    PageType = List;
    SourceTable = "MICA 3rd Party Comm. Qty. Det.";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Blanket Purch. Order Doc. No."; Rec."Blanket Purch. Order Doc. No.")
                {
                    ApplicationArea = All;
                }
                field("Blanket Purch. Order Line No."; Rec."Blanket Purch. Order Line No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Commited Qty."; Rec."Commited Qty.")
                {
                    ApplicationArea = All;
                }
                field("Commitment DateTime"; Rec."Commitment DateTime")
                {
                    ApplicationArea = All;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
