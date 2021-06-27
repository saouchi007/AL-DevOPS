page 80761 "MICA Accrual Posting Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA Accrual Posting Setup";
    Caption = 'Rebate Posting Setup';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;

                }
                field("Receivable Accr. Account No."; Rec."Receivable Accr. Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Receivable Rebate Account No.';
                }

                field("Accrual Account No."; Rec."Accrual Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rebate Account No.';
                }
                field("Balancing Rebate Account No."; Rec."Balancing Rebate Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Balancing Rebate Account No.';
                }
            }
        }
    }
}