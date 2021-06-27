page 80873 "MICA Sample Data List"
{

    PageType = List;
    SourceTable = "MICA Sample Data";
    Caption = 'Sample Data List';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Costing Method"; Rec."Costing Method")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Cost Is Adjusted"; Rec."Cost Is Adjusted")
                {
                    ApplicationArea = All;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = All;
                }
                field("Last Date Time Modified"; Rec."Last Date Time Modified")
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field("Last Time Modified"; Rec."Last Time Modified")
                {
                    ApplicationArea = All;
                }

                field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Send Last DateTime"; Rec."MICA Send Last DateTime")
                {
                    ApplicationArea = All;
                }
                field("MICA Send Last Info Count"; Rec."MICA Send Last Info Count")
                {
                    ApplicationArea = All;
                }
                field("MICA Send Last Warning Count"; Rec."MICA Send Last Warning Count")
                {
                    ApplicationArea = All;
                }
                field("MICA Send Last Error Count"; Rec."MICA Send Last Error Count")
                {
                    ApplicationArea = All;
                }
                field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("MICA Receive Last Flow Status"; Rec."MICA Receive Last Flow Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Receive Last DateTime"; Rec."MICA Receive Last DateTime")
                {
                    ApplicationArea = All;
                }
                field("MICA Receive Last Info Count"; Rec."MICA Receive Last Info Count")
                {
                    ApplicationArea = All;
                }
                field("MICA Rcv. Last Warning Count"; Rec."MICA Rcv. Last Warning Count")
                {
                    ApplicationArea = All;
                }
                field("MICA Receive Last Error Count"; Rec."MICA Receive Last Error Count")
                {
                    ApplicationArea = All;
                }
                field("MICA Record ID"; Rec."MICA Record ID")
                {
                    ApplicationArea = All;
                }
                field(SubLineCount; Rec.SubLineCount)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
