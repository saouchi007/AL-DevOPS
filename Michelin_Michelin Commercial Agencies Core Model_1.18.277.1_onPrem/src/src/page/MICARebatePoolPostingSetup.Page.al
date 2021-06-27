page 83004 "MICA Rebate Pool Posting Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA Rebate Pool Posting Setup";
    Caption = 'Rebate Pool Posting Setup';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Receivable Rebate Account No."; Rec."Receivable Rebate Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Receivable Rebate Account No.';
                }
                field("Rebate Account No."; Rec."Rebate Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Receivable Rebate Account No.';
                }
                field("Balancing Rebate Account No."; Rec."Balancing Rebate Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Receivable Rebate Account No.';
                }
            }
        }
    }
}