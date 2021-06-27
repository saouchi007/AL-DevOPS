page 80767 "MICA Customer Accrual Rates"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MICA Customer Accrual Rates";
    Editable = false;
    Caption = 'Customer Deferred Rebates Rates';

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
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;

                }
                field("Calculation Date"; Rec."Calculation Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec."Amount")
                {
                    ApplicationArea = All;

                }
                field(Quantity; Rec."Quantity")
                {
                    ApplicationArea = All;

                }
                field("% Accrual Rate"; Rec."% Accrual Rate")
                {
                    ApplicationArea = All;

                }

            }
        }
    }
}