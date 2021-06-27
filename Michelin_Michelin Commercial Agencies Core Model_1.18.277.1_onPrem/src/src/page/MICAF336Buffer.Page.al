page 81940 "MICA F336 Buffer"
{
    PageType = List;
    SourceTable = "MICA F336 Buffer";
    SourceTableTemporary = true;
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Country-of Sales"; Rec."Country-of Sales")
                {
                    ApplicationArea = All;
                }
                field("Market Code"; Rec."Market Code")
                {
                    ApplicationArea = All;
                }
                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Net Turnover Invoiced"; Rec."Net Turnover Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Gross Annual Turnover"; Rec."Gross Annual Turnover")
                {
                    ApplicationArea = All;
                }
                field("Net Sales"; Rec."Net Sales")
                {
                    ApplicationArea = All;
                }
                field(CRV; Rec.CRV)
                {
                    ApplicationArea = All;
                }
                field("Invoicing Currency"; Rec."Invoicing Currency")
                {
                    ApplicationArea = All;
                }
                field("Net Sales In The Inv. Currency"; Rec."Net Sales In The Inv. Currency")
                {
                    ApplicationArea = All;
                }
                field("Intercompany Dimension"; Rec."Intercompany Dimension")
                {
                    ApplicationArea = All;
                }
                field("Structure Dimension"; Rec."Structure Dimension")
                {
                    ApplicationArea = All;
                }
                field("Service Item"; Rec."Service Item")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure SetF336Buffer(Var MICAF336Buffer: Record "MICA F336 Buffer")
    begin
        Rec.Reset();
        Rec.DeleteAll();

        MICAF336Buffer.Reset();
        IF MICAF336Buffer.FindSet() then
            repeat
                Rec := MICAF336Buffer;
                Rec.Insert();
            until MICAF336Buffer.Next() = 0;
    end;
}