page 81022 "MICA STE4 Extraction"
{
    Caption = 'Extraction';
    PageType = List;
    Editable = false;
    UsageCategory = None;
    SourceTable = "MICA STE4 Extraction";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Origin Entry No."; Rec."Origin Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Initial Amount (LCY)"; Rec."Initial Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount (LCY)"; Rec."Remaining Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                }
                field(NDCA; Rec.NDCA)
                {
                    ApplicationArea = All;
                }
                field(LB; Rec.LB)
                {
                    ApplicationArea = All;
                }
                field("Party Ownership"; Rec."Party Ownership")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Market Code"; Rec."Market Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange(UserId, Database.UserId());
        Rec.FilterGroup(0);
    end;
}