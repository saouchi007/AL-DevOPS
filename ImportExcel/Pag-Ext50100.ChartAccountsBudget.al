pageextension 50100 ChartAccountsBudget extends "Chart of Accounts"
{
    layout
    {
        addafter("No.")
        {
            field("Budget at Date"; Rec."Budget at Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
